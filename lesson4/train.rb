# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'iterators'

# This class describes trains its common attributes and its common behavior
class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Iterators

  NUMBER_LENGTH = (1..10).freeze

  @@trains = []

  class << self
    attr_accessor :trains
  end

  attr_accessor :speed
  attr_reader :wagons, :current_station, :number, :type

  validate :number, :presence
  validate :number, :format, /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i
  validate :type, :presence
  validate :type, :format, /^(passenger|cargo)$/

  def initialize(number, type)
    @number = number
    @type = type.to_sym
    validate!
    @speed = 0
    @wagons = []
    @@trains << self
    register_instance
  end

  def self.find(number)
    @@trains.find { |t| t.number == number }
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    if speed.zero?
      @wagons << wagon
    else
      puts 'Для прицепления вагона поезд должен остановиться'
    end
  end

  def remove_wagon
    if speed.zero?
      if @wagons.size.positive?
        @wagons.pop
      else
        puts 'В поезде нет вагонов'
      end
    else
      puts 'Для отцепления вагона поезд должен остановиться'
    end
  end

  def route=(route)
    @route = route
    @current_station = route.stations.first
    @current_station.receive_train(self)
  end

  def move_forward
    unless last_station?(@current_station, @route)
      @current_station = @route.stations[@route.stations.index(@current_station) + 1]
      @current_station.receive_train(self)
    end
  end

  def move_backward
    unless first_station?(@current_station, @route)
      @current_station = @route.stations[@route.stations.index(@current_station) - 1]
      @current_station.receive_train(self)
    end
  end

  def iterate_wagons(block)
    wagons.each { |w| block.call(w) }
  end

  #==========#
  private

  # метод используется только для метода класса move
  def last_station?(current_station, route)
    current_station == route.stations.last
  end

  # метод используется только для метода класса move
  def first_station?(current_station, route)
    current_station == route.stations.first
  end
end
