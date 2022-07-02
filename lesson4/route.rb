require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :number

  @@counter = 0

  def initialize(start_station, final_station)
    validate_not_nil(start_station)
    validate_not_nil(final_station)
    validate_existed("@title", start_station.title, Station.stations)
    validate_existed("@title", final_station.title, Station.stations)
    
    @stations = [start_station, final_station]
    @@counter += 1
    @number = @@counter
    register_instance
  end

  def valid?
    validate_not_nil(@stations.first)
    validate_not_nil(@stations.last)
    validate_existed("@title", @stations.first, Station.stations)
    validate_existed("@title", @stations.first, Station.stations)
    true
  rescue
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
    @stations.each{|s| station_titles << s.title}
    station_titles
  end
end