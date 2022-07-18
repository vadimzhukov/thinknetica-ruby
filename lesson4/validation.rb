# frozen_string_literal: true

# This module has methods to validate different values for classes and instances
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # This module validates instances of class
  module ClassMethods
    def validations
      @validations ||= []
    end
  
    def validate(attribute, validation_type, validation_mask = nil)
      validations.push({attr: attribute, type: validation_type, mask: validation_mask})
    end
  end

  # This module validates parameters of instances
  module InstanceMethods

    def validate!
      self.class.validations.each do |hash|
        inst_attr_val = self.instance_variable_get("@#{hash[:attr]}")
        case hash[:type]
        when :presence
          raise "=== Error: #{hash[:attr]} is nil ===" if inst_attr_val == nil 
          raise "=== Error: #{hash[:attr]} is empty ===" if inst_attr_val.to_s == ""
        when :format
          raise "=== Error: #{hash[:attr]} does not fit regexp: #{hash[:mask]} ===" if inst_attr_val.to_s !~ hash[:mask]
        when :type
          raise "=== Error: #{hash[:attr]} has different class #{inst_attr_val.class} than #{hash[:mask]} ===" if inst_attr_val.class.to_s != hash[:mask].to_s 
        end
      end
    end
  
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    # #===== Deprecated =====
    # def validate_not_nil(value)
    #   raise 'Передано некорректное пустое значение/ введенный объект не найден' if value.nil?
    # end

    

    # def validate_by_regexp(value, regexp)
    #   raise "Переданное значение - #{value} - не соответствует regexp: #{regexp}" if value.to_s !~ regexp
    # end

    # #=======================
    def validate_length(value, min_length, max_length)
      if value.to_s.length > max_length || value.to_s.length < min_length
        raise "Длина значения - #{value} - некорректна, должна быть в интервале #{min_length} - #{max_length} символов"
      end
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
