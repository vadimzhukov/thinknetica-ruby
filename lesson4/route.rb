# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

# This class describes routes for railway
class Route
  include InstanceCounter
  include Validation

  class << self
    attr_accessor :counter
  end

  attr_reader :stations, :number

  @counter = 0

  def initialize(start_station, final_station)
    @stations = [start_station, final_station]
    validate!
    self.class.counter += 1
    @number = self.class.counter
    register_instance
  end

  def validate!
    validate_not_nil(stations.first)
    validate_not_nil(stations.last)
    validate_existed('@title', stations.first.title, Station.stations)
    validate_existed('@title', stations.last.title, Station.stations)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    if @stations.any?(station)
      @stations.delete(station)
    else
      false
    end
  end

  def show_stations
    station_titles = []
    @stations.each { |s| station_titles << s.title }
    station_titles
  end
end
