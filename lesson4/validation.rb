# frozen_string_literal: true

# This module has methods to validate different values for classes and instances
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # This module validates instances of class
  module ClassMethods
    def object_existed_with_parameter?(_parameter, value)
      instance_objs.each do |obj|
        return true if obj.parameter == value
      end
      false
    end
  end

  # This module validates parameters of instances
  module InstanceMethods
    def validate_not_nil(value)
      raise 'Передано некорректное пустое значение/ введенный объект не найден' if value.nil?
    end

    def validate_length(value, min_length, max_length)
      if value.to_s.length > max_length || value.to_s.length < min_length
        raise "Длина значения - #{value} - некорректна, должна быть в интервале #{min_length} - #{max_length} символов"
      end
    end

    def validate_by_regexp(value, regexp)
      raise "Переданное значение - #{value} - не соответствует regexp: #{regexp}" if value.to_s !~ regexp
    end

    def validate_not_yet_existed(parameter, value, arr)
      raise "Объект с #{parameter} == #{value} уже существует!" if arr.any? do |i|
                                                                     i.instance_variable_get(parameter.to_sym) == value
                                                                   end
    end

    def validate_existed(parameter, value, arr)
      raise "Объекта с #{parameter} == #{value} не существует!" if arr.none? do |i|
                                                                     i.instance_variable_get(parameter.to_sym) == value
                                                                   end
    end
  end
end
