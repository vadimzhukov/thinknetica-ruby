class Route
  attr_reader :stations, :number

  @@counter = 0 

  def initialize(start_station, final_station)
    @stations = [start_station, final_station]
    @@counter += 1
    @number = @@counter
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    if @stations.any?(station)
      @stations.delete(station)
    else
      puts "Такой станции нет на маршруте"
      false
    end
  end

  def show_stations
    station_titles = []
    @stations.each{|s| station_titles << s.title}
    station_titles
  end
end