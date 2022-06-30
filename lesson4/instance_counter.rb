module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    

    private
    attr_writer :instances
    def add_instance
      self.instances ||= 0
      self.instances += 1
    end
  end

  module InstanceMethods
    private
    def register_instance
      self.class.send :add_instance
    end
  end
end
