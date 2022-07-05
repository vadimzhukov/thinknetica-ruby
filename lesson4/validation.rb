module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def object_existed_with_parameter?(parameter, value)
      self.instance_objs.each do |obj|
        return true if obj.parameter == value
      end
      false
    end
  end

  module InstanceMethods
    def validate_not_nil(value)
      raise "Передано некорректное пустое значение/ введенный объект не найден" if value.nil?
    end
    def validate_length(value, min_length = 0, max_length)
      raise "Длина переданного значения - #{value} - некорректна, должна быть в интервале #{min_length} - #{max_length} символов" if value.to_s.length > max_length || value.to_s.length < min_length
    end
    def validate_by_regexp(value, regexp)
      raise "Переданное значение - #{value} - не соответствует regexp: #{regexp}" if value.to_s !~ regexp
    end
    def validate_not_yet_existed(parameter, value, arr)
      raise "Объект с #{parameter} == #{value} уже существует!" if arr.any?{|i| i.instance_variable_get(parameter.to_sym) == value}
    end
    def validate_existed(parameter, value, arr)
      raise "Объекта с #{parameter} == #{value} не существует!" if arr.none?{|i| i.instance_variable_get(parameter.to_sym) == value}
    end
  end
end
