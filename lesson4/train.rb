# train.rb
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  FORWARD = :forward
  BACKWARD = :backward
  NUMBER_LENGTH = (1..10)

  attr_accessor :speed
  attr_reader :wagons, :current_station, :number, :type

  @@trains = []

  def initialize(number, type)
    validate_not_nil(number)
    validate_length(number, NUMBER_LENGTH.first, NUMBER_LENGTH.last)
    validate_not_yet_existed("@number", number, @@trains)
    validate_by_regexp(type, /^(passenger|cargo)$/)
    validate_by_regexp(number, /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i)

    @number = number
    @type = type.to_sym
    @speed = 0
    @wagons = []
    @@trains << self
    register_instance
  end

  def valid?
    validate_not_nil(self.number)
    validate_length(self.number, NUMBER_LENGTH.first, NUMBER_LENGTH.last)
    validate_by_regexp(self.type, /^(passenger|cargo)$/)
    true
    rescue
      false
  end

  def self.find(number)
    @@trains.find { |t| t.number == number }
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    if speed == 0
      @wagons << wagon
      puts "К поезду #{number} прицеплен вагон, общее количество вагонов: #{wagons.size}"
    else
      puts 'Для прицепления вагона поезд должен остановиться'
    end
  end

  def remove_wagon
    if speed == 0
      if @wagons.size > 0
        @wagons.pop
        puts "От поезда #{number} отцеплен вагон, общее количество вагонов: #{wagons.size}"
      else
        puts 'В поезде нет вагонов'
      end
    else
      puts 'Для отцепления вагона поезд должен остановиться'
    end
  end

  def set_route(route)
    @route = route
    @current_station = route.stations.first
  end

  def move(direction)
    if direction == FORWARD
      if !last_station?(@current_station, @route)
        @current_station = @route.stations[@route.stations.index(@current_station) + 1]
        @current_station.receive_train(self)
      end
    end

    if direction == BACKWARD
      if !first_station?(@current_station, @route)
        @current_station = @route.stations[@route.stations.index(@current_station) - 1]
        @current_station.receive_train(self)
      end
    end
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
