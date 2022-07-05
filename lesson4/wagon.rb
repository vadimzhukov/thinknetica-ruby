require_relative 'wagon'

class Wagon
  include Manufacturer
 
  attr_reader :type, :number

  @instances = 0

  def initialize(type)
    @type = type.to_sym
    register_instance
    @number = self.class.instances
  end

  def self.instances
    @instances
  end

  private
  attr_writer :number

  def self.increase_instance
    @instances ||= 0
    @instances += 1
    
  end

  def register_instance
    self.class.send :increase_instance
  end
  
end
