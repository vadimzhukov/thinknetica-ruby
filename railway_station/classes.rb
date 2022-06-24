class Station
  attr_reader :title

  def initialize(title)
    @title = title
    @trains_at_station = []
  end

  def receive_train(train)
    @trains_at_station << train
    puts "Поезд #{train.number} прибыл на станцию #{@title}"
  end

  def current_trains
    @trains_at_station
  end

  def current_trains_by_type(type)
    @trains_at_station.select{|t| t.type == type}.map{|x| [x.number, x.type, x.carriage_count]}
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
  attr_reader :carriage_count, :current_station, :number, :type

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
        @current_station.receive_train(self)
      else
        puts "Поезд на конечной станции и не может двигаться вперед"
      end 
    end

    if direction == "backward" 
      if @current_station != @train_route.all_stations.first
        @current_station = @train_route.all_stations[@train_route.all_stations.index(@current_station) - 1]
        @current_station.receive(self)
      else
        puts "Поезд на начальной станции и не может двигаться назад"
      end
    end
  end
end

# tests
# # Станции
# balagoe = Station.new("Балагое")
# moscow = Station.new("Москва")
# piter = Station.new("Санкт-Петербург")
# tver = Station.new("Тверь")

# # маршруты
# moscow_piter = Route.new(moscow, piter)
# piter_tver = Route.new(piter, tver)

# #доп станции на маршрутах
# moscow_piter.add_inner_station(balagoe)
# moscow_piter.add_inner_station(tver)
# piter_tver.add_inner_station(balagoe)

# # 1 тестовый поезд
# sapsan = Train.new(666, "Пасажирский", 10)
# sapsan.change_carriage(1)
# sapsan.set_route(moscow_piter)
# sapsan.move("forward")

# # 2 тестовый поезд
# lastochka = Train.new(555, "Пасажирский", 15)
# lastochka.set_route(piter_tver)

# lastochka.move("forward")
# lastochka.move("forward")

# #3 тестовый поезд
# tyagach = Train.new(444, "Грузовой", 40)

# tyagach.set_route(moscow_piter)
# 5.times do
#   tyagach.change_carriage(-1)
# end

# tyagach.move("forward")

# puts "Пассажирские поезда на станции Балагое : #{balagoe.current_trains_by_type("Пасажирский")}"
# puts "Грузовые поезда на станции Балагое : #{balagoe.current_trains_by_type("Грузовой")}"