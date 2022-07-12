# frozen_string_literal: true

# Module allows couting instances of class
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # Module has class-level counting methods
  module ClassMethods
    attr_reader :instances

    private

    def add_instance
      instances ||= 0
      instances + 1
    end
  end

  # Module has instance-level counting methods
  module InstanceMethods
    private

    def register_instance
      self.class.send :add_instance
    end
  end
end
