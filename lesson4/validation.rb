# frozen_string_literal: true
require 'pry'

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
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!(options = nil)
      source = self.class.superclass == Object ? self.class : self.class.superclass
      checks = source.instance_variable_get("@validations")
      
      checks.each do |hash|
        val = self.instance_variable_get("@#{hash[:attr]}")
        option = hash[:mask] ? hash[:mask] : options
        send("validate_#{hash[:type].to_s}".to_sym, hash[:attr],  val, option)
      end
    end
  
    def validate_presence(name, value, _)
      raise "=== Error: #{name} value is nil ===" if value == nil 
      raise "=== Error: #{name} value is empty ===" if value.to_s == ""
    end

    def validate_format(name, value, regexp_mask)
      raise "=== Error: #{name} value #{value} does not fit regexp: #{regexp_mask.to_s} ===" if value.to_s !~ regexp_mask
    end

    def validate_type(name, value, type)
      raise "=== Error: #{name} value #{value} has different class #{value.class} than #{type} ===" if value.class.to_s != type.to_s 
    end

    def validate_length(name, value, mask)
      raise "=== Error: Length #{value} is wrong, should be between #{mask.first}-#{mask.last}" unless value.to_s.length.between?(mask.first, mask.last)
    end

    def validate_not_yet_existed(name, value, arr)
      raise "=== Error: Object with #{name} == #{value} is already exist!" if arr.any? do |i|
                                                                     i.instance_variable_get("@#{name}") == value
                                                                   end
    end

    def validate_existed(name, value, arr)
      raise "=== Error: Object with #{name} == #{value} does not exist!" if arr.none? do |i|
                                                                     i.instance_variable_get("@#{name}") == value
                                                                   end
    end
  end
end
