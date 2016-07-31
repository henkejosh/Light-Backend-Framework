#TODO -> make it so that this actually works as an attr_accessor
# probably need to make it a module to extend in models?
# or can I just descend models from this class??

module AttrAccessorObject
  def self.attr_accessor(*names)
    self.attr_reader(*names)
    self.attr_writer(*names)
  end

  def self.attr_reader(*names)
    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}")
      end
    end
  end

  def self.attr_writer(*names)
    names.each do |name|
      define_method("#{name}=") do |item|
        instance_variable_set("@#{name}", item)
      end
    end
  end
end
