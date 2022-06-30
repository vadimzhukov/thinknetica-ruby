require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'

class Main
  MENU_FIRST_ITEM = 0
  MENU_LAST_ITEM = 13
  EXIT_ACTION = 99

  attr_reader :MENU_FIRST_ITEM, :MENU_LAST_ITEM, :EXIT_ACTION, :menu

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @wagons = []
    @menu = [
      { number: 0, message: 'Список команд', action: :show_menu },
      { number: 1, message: 'Создать станцию', action: :create_station },
      { number: 2, message: 'Создать поезд', action: :create_train },
      { number: 3, message: 'Создать маршрут', action: :create_route },
      { number: 4, message: 'Управлять станциями на маршруте (добавлять, удалять)',
        action: :add_remove_station_to_route },
      { number: 5, message: 'Назначить маршрут поезду', action: :set_route },
      { number: 6, message: 'Добавить вагон к поезду', action: :add_wagon },
      { number: 7, message: 'Отцепить вагон от поезда', action: :remove_wagon },
      { number: 8, message: 'Перемеcтить поезд по маршруту вперед', action: :move_forward },
      { number: 9, message: 'Перемеcтить поезд по маршруту назад', action: :move_backward },
      { number: 10, message: 'Просмотреть список станций и список поездов на станции',
        action: :show_stations_with_trains },
      { number: 11, message: 'Список станций', action: :show_stations },
      { number: 12, message: 'Список поездов', action: :show_trains },
      { number: 13, message: 'Список маршрутов', action: :show_routes },
      { number: 99, message: 'Завершить выполнение программы', action: :exit }
    ]
  end

  def start
    seed
    show_menu
  end

  def show_menu
    @menu.each do |item|
      puts "#{item[:number]}: #{item[:message]}"
    end
  end

  def action_input
    loop do
      print 'выполнить команду: '
      action_num = gets.chomp.to_i
      if (action_num >= MENU_FIRST_ITEM && action_num <= MENU_LAST_ITEM) || action_num == EXIT_ACTION
        return action_num
      else
        puts "Введите номер действия от #{MENU_FIRST_ITEM} до #{MENU_LAST_ITEM}"
      end
    end
  end

  def get_action(action_num)
    menu_item = @menu.find do |m|
      m[:number] == action_num
    end
    menu_item[:action]
  end

  def show_stations
    puts 'Список станций:'
    @stations.each { |s| puts s.title }
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each { |t| puts "#{t.number} #{t.type} #{t.wagons}" }
  end

  def show_routes
    puts 'Список маршрутов:'
    @routes.each { |r| puts "#{r.number}: #{r.show_stations}" }
  end

  def create_station
    title = input_of_action('Введите название станции')
    @stations << Station.new(title)
    show_stations
  end

  def create_train
    number = input_of_action('Введите номер поезда')
    type = input_of_action('Введите тип поезда (passenger/cargo)')
    if type.to_sym == :passenger
      @trains << PassengerTrain.new(number)
    elsif type.to_sym == :cargo
      @trains << CargoTrain.new(number)
    end
    show_trains
  end

  def create_route
    puts 'Текущие станции:'
    @stations.each { |s| puts s.title }
    first_station_name = input_of_action('Введите название начальной станции маршрута из доступных')
    last_station_name = input_of_action('Введите название конечной станции маршрута из доступных')
    @routes << Route.new(@stations.find { |s| s.title == first_station_name }, @stations.find do |s|
                                                                                 s.title == last_station_name
                                                                               end)
    show_routes
  end

  def add_station_to_route(route)
    show_stations
    station = choose_station
    route.add_station(station)
  end

  def remove_station_from_route(route)
    station_to_remove = input_of_action('Введите название станции')
    route.delete_station(station_to_remove)
  end

  def add_remove_station_to_route
    show_routes
    route = choose_route
    act = input_of_action('Добавить (+) или удалить (-) станцию?')
    act == '+' ? add_station_to_route(route) : remove_station_from_route(route)
    show_routes
  end

  def set_route
    train = choose_train
    route = choose_route
    train.set_route(route)
    puts "Поезд #{train.number} на маршруте #{route.number}"
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
    puts 'Список станций c поездами:'
    @stations.each { |s| puts "#{s.title} / поезда на станции: #{s.trains}" }
  end

  #===================================

  private

  def input_of_action(message)
    puts message
    input = gets.chomp
  end

  def choose_train
    show_trains
    train_number = input_of_action('Выберите номер поезда:').to_i
    train = @trains.find { |t| t.number == train_number }
  end

  def choose_route
    show_routes
    route_number = input_of_action('Введите номер маршрута').to_i
    route = @routes.find { |r| r.number == route_number }
  end

  def choose_station
    station_title = input_of_action('Введите название станции:')
    station = @stations.find { |s| s.title == station_title }
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

  #========== Test data ===================
  def seed
    @stations << Station.new('Moscow')
    @stations << Station.new('Piter')
    @stations << Station.new('Vladivostok')
    @stations << Station.new('Murmansk')
    @stations << Station.new('Ekaterinburg')

    @trains << PassengerTrain.new(0o01)
    @trains << CargoTrain.new(0o02)
    @trains << PassengerTrain.new(0o03)

    @routes << Route.new(@stations[0], @stations[1])
    @routes << Route.new(@stations[0], @stations[2])
    @routes << Route.new(@stations[3], @stations[4])

    @stations[0].receive_train(@trains[0])
    @stations[0].receive_train(@trains[1])
    @stations[3].receive_train(@trains[2])

    @trains[0].set_route(@routes[0])
    @trains[1].set_route(@routes[1])
    @trains[2].set_route(@routes[2])
  end
end

game = Main.new
game.start
#============= main loop ==============
while true
  action_num = game.action_input
  break if action_num == game.EXIT_ACTION

  action = game.get_action(action_num)
  puts "--- #{game.menu.find { |m| m[:number] == action_num }[:message]} ---"
  game.send(action)
end
#======================================
