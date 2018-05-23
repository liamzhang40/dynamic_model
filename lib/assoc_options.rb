class AssocOptions
  # just defining accessor and two methods in a different class which
  # are also accessable in its descendants. Can be defined in BelongsToOptions
  # and HasManyOptions, but code would be wet
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end
