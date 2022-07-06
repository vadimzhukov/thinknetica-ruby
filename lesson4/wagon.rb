require_relative 'wagon'

class Wagon
  include Manufacturer
 
  attr_reader :type, :number, :occupied_places, :total_places

  @instances = 0

  def initialize(type, total_places)
    @total_places = total_places.to_f
    @occupied_places = 0
    @type = type.to_sym
    register_instance
    @number = self.class.instances
  end

  def self.instances
    @instances
  end

  def available_places
    @total_places - @occupied_places
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
