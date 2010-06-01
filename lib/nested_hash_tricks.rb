class NestedHashTricks
  def self.load_subfiles!
    load File.dirname(__FILE__) + "/nested_hash_tricks/key_parts.rb"
    load File.dirname(__FILE__) + "/nested_hash_tricks/main.rb"
  end
  def self.load_self!
    load File.dirname(__FILE__) + "/nested_hash_tricks.rb"
  end
  def self.load_files!
    load_subfiles!
    load_self!
  end
end

NestedHashTricks.load_subfiles!