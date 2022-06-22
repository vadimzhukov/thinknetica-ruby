class Station
  attr_reader :title

  def initialize(title)
    @title = title
    @trains_at_station = []
  end

  def receive_train(train)
    @trains_at_station << train
  end

  def current_trains
    @trains_at_station
  end

  def current_trains_by_type(type)
    @trains_at_station.select {|t| t.type == type}
  end

  def send_train
    if @trains_at_station
      @trains_at_station.pop()
    end
  end

end

class Route
  attr_reader :all_stations

  def initialize(start_station, final_station)
    @all_stations = [start_station, final_station]
  end

  def add_inner_station(station)
    @all_stations.insert(-2, station)
  end

  def delete_inner_station(station)
    @all_stations.delete(station)
  end

  def show_stations
    puts @all_stations
  end
end

class Train
  attr_accessor :speed
  attr_reader :carriage_count, :current_station

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count
    @speed = 0
  end

  def stop 
    self.speed = 0
  end

  def change_carriage(count)
      if self.speed == 0 
        if  count.abs == 1
          @carriage_count += count
        else
          puts "Для отцепления вагона введите -1, для прицепления 1"
        end
      else
        puts "Для изменения количества вагонов поезд должен остановиться"
      end
  end

  def set_route(route)
    @train_route = route
    @current_station = route.all_stations.first
  end

  def move(direction)
    if direction == "forward" 
      if @current_station != @train_route.all_stations.last
        @current_station = @train_route.all_stations[@train_route.all_stations.index(@current_station) + 1]
      else
        puts "Поезд на конечной станции и не может двигаться вперед"
      end 
    end

    if direction == "backward" 
      if@current_station != @train_route.all_stations.first
        @current_station = @train_route.all_stations[@train_route.all_stations.index(@current_station) - 1]
      else
        puts "Поезд на начальной станции и не может двигаться назад"
      end
    end
  end
end

# tests
# balagoe = Station.new("Балагое")
# moscow = Station.new("Москва")
# piter = Station.new("Санкт-Петербург")
# tver = Station.new("Тверь")

# moscow_piter = Route.new(moscow, piter)
# piter_tver = Route.new(piter, tver)

# moscow_piter.add_inner_station(balagoe)

# moscow_piter.add_inner_station(tver)

# piter_tver.add_inner_station(balagoe)

# sapsan = Train.new(666, "Грузовой", 10)
# sapsan.stop
# sapsan.change_carriage(1)
# print sapsan.carriage_count

# sapsan.set_route(moscow_piter)
# sapsan.move("backward")
# puts sapsan.current_station.title