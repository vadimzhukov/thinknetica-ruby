require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'

$routes = []
$trains = []
$stations = []
$wagons = []

def instructions
  puts "=============================\n" +
  "Система управления железной дорогой. Введите цифру для выполнения действия: \n" +
  "0: Список команд\n" +
  "1: Создать станцию\n" +
  "2: Создать поезд\n" +
  "3: Создать маршрут\n" +
  "4: Управлять станциями на маршруте (добавлять, удалять)\n" +
  "5: Назначить маршрут поезду\n" +
  "6: Добавить вагон к поезду\n" +
  "7: Отцепить вагон от поезда\n" +
  "8: Перемеcтить поезд по маршруту вперед\n" +
  "9: Перемеcтить поезд по маршруту назад\n" +
  "10: Просмотреть список станций и список поездов на станции\n" + 
  "11: Список станций\n" +
  "12: Список поездов\n" +
  "13: Список маршрутов\n" +
  "99: Завершить выполнение\n"
end

def show_stations
  puts "Список станций:"
  $stations.each{|s| puts s.title}
end

def show_trains
  puts "Список поездов:"
  $trains.each{|t| puts "#{t.number} #{t.type} #{t.wagons}"}
end

def show_routes
  puts "Список маршрутов:"
  $routes.each{|r| puts "#{r.number}: #{r.show_stations}"}
end

def choose_train
  show_trains
  puts "Выберите номер поезда:"
  train_number = gets.chomp.to_i
  train = $trains.find{|t| t.number == train_number}
end

def choose_route
  show_routes
  puts "Введите номер маршрута"
  route_number = gets.chomp.to_i
  route = $routes.find{|r| r.number == route_number}
end

def choose_station
  puts "Введите название станции:"
  station_title = gets.chomp
  station = $stations.find{|s| s.title == station_title}
end

def create_station
  puts "Введите название станции"
    title = gets.chomp
    $stations << Station.new(title)
    show_stations
end

def create_train
  puts "Введите номер поезда"
    number = gets.chomp.to_i
    puts "Введите тип поезда (passenger/cargo)"
    type = gets.chomp.to_sym
    if type == :passenger
      $trains << PassengerTrain.new(number, type)
    elsif type == :cargo
      $trains << CargoTrain.new(number, type)
    end
    show_trains
end

def create_route
  puts "Текущие станции:"
  $stations.each{|s| puts s.title}
  puts "Выберите начальную и конечную станции, введите их названия через запятую"
  first, last = gets.chomp.split(", ")
  first_station = $stations.find{|s| s.title == first}
  last_station = $stations.find{|s| s.title == last}
  $routes << Route.new(first_station, last_station)
  show_routes
end

def add_station_to_route(route)
  show_stations
  station = choose_station
  route.add_station(station)
end

def remove_station_from_route(route)
  puts "Введите название станции"
  station_to_remove = $stations.find{|s| s.title == gets.chomp.to_s}
  route.delete_station(station_to_remove)
end

def add_remove_station_to_route
  show_routes
  route = choose_route
  puts "Добавить (+) или удалить (-) станцию?"
  act = gets.chomp.to_s
  act == "+" ? add_station_to_route(route) : remove_station_from_route(route)
  show_routes
end

def set_route
  train = choose_train
  route = choose_route
  train.set_route(route)
  puts "Поезд #{train.number} на маршруте #{route.number}"
end

def add_wagon
  train = choose_train
  wagon = Wagon.new(train.type)
  train.add_wagon(wagon)
end

def remove_wagon
  train = choose_train
  train.remove_wagon
end

def move_forward
  train = choose_train
  train.move(:forward)
end

def move_backward
  train = choose_train
  train.move(:backward)
end

def show_stations_with_trains
  puts "Список станций c поездами:"
  $stations.each{|s| puts "#{s.title} / поезда на станции: #{s.trains}"}
end



#==== Исполняем выбранное действие =====
def do_action(action)
  case action
  when 0
    instructions
  when 1
    create_station
  when 2
    create_train
  when 3
    create_route
  when 4
    add_remove_station_to_route
  when 5
    set_route
  when 6
    add_wagon
  when 7
    remove_wagon
  when 8
    move_forward
  when 9
    move_backward
  when 10
    show_stations_with_trains
  when 11
    show_stations
  when 12
    show_trains
  when 13
    show_routes
  end
end


#========= Тестовые исходные данные ============
def seed
  $stations << Station.new("Moscow")
  $stations << Station.new("Piter")
  $stations << Station.new("Vladivostok")
  $stations << Station.new("Murmansk")
  $stations << Station.new("Ekaterinburg")
  
  $trains << PassengerTrain.new(001, :passenger)
  $trains << CargoTrain.new(002, :cargo)
  $trains << PassengerTrain.new(003, :passenger)

  $routes << Route.new($stations[0], $stations[1])
  $routes << Route.new($stations[0], $stations[2])
  $routes << Route.new($stations[3], $stations[4])

  $stations[0].receive_train($trains[0])
  $stations[0].receive_train($trains[1])
  $stations[3].receive_train($trains[2])

  $trains[0].set_route($routes[0])
  $trains[1].set_route($routes[1])
  $trains[2].set_route($routes[2])
  
end

#==== Загрузка исходных тестовых данных ========
seed
#==== Основной цикл исполнения =========
instructions

while true
  print "выполнить команду: "
  action = gets.chomp.to_i
  break if action == 99
  if action < 0 || action > 13
    puts "Введите код действия от 1 до 10"
  else
    do_action(action)
  end
end
