class KeyParts
  def self.with_parts(str,ops={})
    parts = str.kind_of?(String) ? str.to_s.split('.') : str
    if parts.size > 1
      start = ops[:array] ? parts[0..-2] : parts[0..-2].join(".")
      lst = parts[-1]
      mult = true
    else
      start = str
      lst = nil
      mult = false
    end
    yield(start,lst,mult)
  end
  def self.mult?(str)
    str.to_s.split('.').size > 1
  end
  def self.single?(str)
    !mult?(str)
  end
end