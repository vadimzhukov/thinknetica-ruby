# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'iterators'

# This class describes stations of railway
class Station
  include InstanceCounter
  include Validation
  include Iterators

  TITLE_LENGTH = (1..30).freeze
  class << self
    attr_reader :stations
  end

  attr_reader :title, :trains

  validate :title, :presence
  validate :title, :length, [1, 20]
  validate :title, :not_yet_existed

  @stations = []

  def initialize(title)
    @title = title
    @trains = []
    validate!(self.class.stations)
    register_instance
    self.class.stations << self
  end

  def trains_info
    result = []
    @trains.each { |t| result << "Номер:#{t.number} Тип:#{t.type} Вагоны:#{t.wagons}" }
    result
  end

  def trains_by_type(type)
    @trains.select { |t| t.type == type }.map { |x| [x.number, x.type] }
  end

  def receive_train(train)
    @trains << train
  end

  def send_train
    @trains&.pop
  end
end

#=== tests ====
# @stations = []
# @trains = []

# @stations << Station.new('Moscow')
# @stations << Station.new('Piter')
# @stations << Station.new('Vladivostok')
# @stations << Station.new('Murmansk')
# @stations << Station.new('Ekaterinburg')

# @trains << PassengerTrain.new("Ф12-AC")
# @trains << CargoTrain.new("666-AD")
# @trains << PassengerTrain.new("555-LS")

# @stations[0].receive_train(@trains[0])
# @stations[0].receive_train(@trains[1])
# @stations[3].receive_train(@trains[2])

# tr_info = Proc.new {|tr| puts "Поезд №#{tr.number} Тип:#{tr.type.to_s} Вагонов:#{tr.wagons.size}"}

# @stations[0].iterate_trains(tr_info)
