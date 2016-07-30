#TODO -> make it so that this actually works as an attr_accessor
# 2) add attr_reader
# 3) add attr_writer


class AttrAccessorObject
  def self.attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |item|
        instance_variable_set("@#{name}", item)
      end
    end
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
