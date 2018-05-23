require_relative 'assoc_options'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] ? options[:foreign_key] : "#{self_class_name.to_s.downcase}_id".to_sym
    @primary_key = options[:primary_key] ? options[:primary_key] : :id
    @class_name = options[:class_name] ? options[:class_name] : name.to_s.camelcase.singularize
  end
end
