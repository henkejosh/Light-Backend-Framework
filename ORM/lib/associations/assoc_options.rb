require_relative 'attr_accessor_object'

class AssocOptions
  extend AttrAccessorObject

  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    if @class_name == "Human"
      return "humans"
    else
      @class_name.tableize
    end
  end
end
