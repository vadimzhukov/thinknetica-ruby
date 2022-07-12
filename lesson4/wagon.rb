# frozen_string_literal: true

require_relative 'wagon'

# This class describes wagon and its behavior
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

  class << self
    attr_reader :instances
  end

  def available_places
    @total_places - @occupied_places
  end

  def self.increase_instance
    @instances ||= 0
    @instances += 1
  end

  private

  attr_writer :number

  def register_instance
    self.class.send :increase_instance
  end
end
