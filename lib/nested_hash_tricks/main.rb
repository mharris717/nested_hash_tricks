class Object
  def dot_get(str)
    str = str.split(".") if str.is_a?(String)
    res = self
    last_f = last_res = nil
    str.each do |f|
      if f.num? && !res.kind_of?(Array)
        last_res[last_f] = res = []
      end
      last_res = res
      if res.kind_of?(Array)
        temp = res[f.safe_to_i]
        if !temp
          res << {}
          temp = res.last
          raise "can only add new row at end" unless res.size-1 == f.safe_to_i
        end
        res = temp
      else
        res = res[f]
      end
      last_f = f
    end
    res
  end
  def dot_set(str,val=nil,&b)
    mylog 'dot_set', :k => str, :v => val, :block_given => block_given?, :self => self    
    KeyParts.with_parts(str) do |first,lst,mult|
      return self[str] = val unless mult
      obj = dot_get(first)
      return obj unless obj
      obj.nested_set(lst,val,&b)
    end
  end
end

class Object
  def nested_set(k,v=nil,&b)
    mylog 'dot_set', :context => 'nested_set', :k => k, :v => v, :block_given => block_given?, :self => self
    v = yield(self) if block_given?
    v = v.tmo if v.respond_to?(:tmo)
    self[k] = v
    self.delete(k) unless v.present?
    v
  end
end

module ArrayMod
  def nested_set(k,v=nil)
    each do |x| 
      v = yield(x) if block_given?
      x.nested_set(k,v) 
    end
  end
end
[Array,ArrayWrapper].each { |cls| cls.send(:include,ArrayMod) }

class String
  def num?
    size > 0 && self =~ /^[\d\.]*$/
  end
  def date?
    matches = (self =~ /\/\d+\//) || (self =~ /-\d+-/)
    matches2 = self =~ /^[ \d\-\/:]+$/
    !!(matches && matches2 && Time.parse(self))
  rescue
    return false
  end
  def to_time
    Time.parse(self)
  end
  def tmo
    if num? 
      to_f.tmo 
    elsif blank?
      nil
    else
      self
    end
  end
end