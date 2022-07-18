module Accessors
  def attr_accessor_with_history(*names)
    values_history = {}
    names.each do |name|
      var_name = "@#{name}".to_sym
      values_history[name.to_sym] = []
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value| 
        instance_variable_set(var_name, value) 
        values_history[name.to_sym] << instance_variable_get(var_name)
      end
      define_method("#{name}_history") { values_history[name.to_sym]}
    end
  end
  
  def strong_attr_accessor(name, type)
    var_name = "@#{name}"
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise "Entered value type is not correct, should be #{type}" if type.to_s != value.class.to_s

      instance_variable_set(var_name, value)
    end
  end

end

class C
  extend Accessors

  attr_accessor_with_history :a, :b, :C
  strong_attr_accessor(:x, "String")
end
