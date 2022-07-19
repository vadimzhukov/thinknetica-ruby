# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# This class is a main application workflow it also consists methods covering user inputs and provides output
class Main
  MENU_FIRST_ITEM = 0
  MENU_LAST_ITEM = 16
  EXIT_ACTION = 99

  attr_reader :exit_action_num, :menu

  MENU = [
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
    { number: 14, message: 'Список поездов на станции', action: :show_trains_on_station },
    { number: 15, message: 'Список вагонов поезда', action: :show_train_with_wagons },
    { number: 16, message: 'Занять место/ объем в вагоне', action: :occupy_wagon },
    { number: 99, message: 'Завершить выполнение программы', action: :exit }
  ].freeze

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @wagons = []
    @menu = MENU
    @exit_action_num = EXIT_ACTION
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
      return action_num if (action_num >= MENU_FIRST_ITEM && action_num <= MENU_LAST_ITEM) || action_num == EXIT_ACTION
    end
  end

  def get_action(action_num)
    menu_item = @menu.find do |m|
      m[:number] == action_num
    end
    menu_item[:action]
  end

  def input_of_action(message)
    puts message
    gets.chomp
  end

  def create_station
    title = input_of_action('Введите название станции')
    @stations << Station.new(title)
    show_stations
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  def create_train
    number = input_of_action('Введите номер поезда в формате <abc-de> состоящий из букв либо цифр')
    type = input_of_action('Введите тип поезда (passenger/cargo)').to_sym
    train = case type
            when :passenger then PassengerTrain.new(number)
            when :cargo then CargoTrain.new(number)
              else
                raise "Некорректно указан тип поезда"
            end
    @trains << train
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  def create_route
    puts 'Текущие станции:'
    @stations.each { |s| puts s.title }
    first_station = choose_station
    last_station = choose_station
    @routes << Route.new(first_station, last_station)
    show_routes
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
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
    route = choose_route
    act = input_of_action('Добавить (+) или удалить (-) станцию?')
    act == '+' ? add_station_to_route(route) : remove_station_from_route(route)
    show_routes
  end

  def set_route
    train = choose_train
    route = choose_route
    train.route=(route)
    puts "Поезд #{train.number} на маршруте #{route.number}"
  end

  def move_forward
    train = choose_train
    train.move_forward
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  def move_backward
    train = choose_train
    train.move_backward
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  def add_wagon
    train = choose_train
    wagon = create_wagon(train.type)
    train.add_wagon(wagon)
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  def create_wagon(type)
    case type
    when :passenger
      puts 'Введите количество мест вагона'
      places = gets.chomp
      PassengerWagon.new(places)
    when :cargo
      puts 'Введите максимальный объем вагона'
      volume = gets.chomp
      CargoWagon.new(volume)
    end
  end

  def remove_wagon
    train = choose_train
    train.remove_wagon
  end

  #===== Procs ============
  def trains_info
    proc do |tr|
      puts "Поезд №#{tr.number} Тип:#{tr.type} Вагонов:#{tr.wagons.size}"
    end
  end

  def wagons_info
    proc do |w|
      print "№ #{w.number}, тип: #{w.type}, "
      puts "мест свободно|занято: #{w.available_places}|#{w.occupied_places}"
    end
  end

  def trains_with_wagons_info
    proc do |tr|
      puts "Поезд №#{tr.number} Тип:#{tr.type} Вагонов:#{tr.wagons.size}"
      puts 'Вагоны поезда: '
      tr.iterate_wagons(wagons_info)
    end
  end

  #===============================

  def show_stations_with_trains
    puts 'Список станций c поездами:'
    @stations.each do |s|
      puts "Станция: #{s.title} / Поезда на станции:"
      s.iterate_trains(trains_with_wagons_info)
    end
  end

  def show_stations
    puts 'Список станций:'
    @stations.each { |s| puts s.title }
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each { |t| puts "№ #{t.number} - #{t.type}, #{t.wagons.size} вагона(ов)" }
  end

  def show_routes
    puts 'Список маршрутов:'
    @routes.each { |r| puts "#{r.number}: #{r.show_stations}" }
  end

  def show_trains_on_station(station = choose_station)
    puts station.title
    station.iterate_trains(trains_info)
  end

  def show_train_with_wagons(train = choose_train)
    train.iterate_wagons(wagons_info)
  end

  def occupy_wagon
    train = choose_train
    wagon = choose_wagon
    puts 'Введите количество мест/ объем загрузки вагона'
    places = gets.chomp
    wagon.occupy(places)
    show_train_with_wagons(train)
  end

  #=========== Private methods ========================

  private

  def choose_train
    show_trains
    train_number = input_of_action('Выберите номер поезда:').to_s
    @trains.find { |t| t.number == train_number }
  end

  def choose_route
    show_routes
    route_number = input_of_action('Введите номер маршрута').to_i
    @routes.find { |r| r.number == route_number }
  end

  def choose_station
    station_title = input_of_action('Введите название станции:')
    @stations.find { |s| s.title == station_title }
  end

  def choose_wagon(train = choose_train)
    return nil if train.wagons.empty?

    show_train_with_wagons(train)
    puts 'Введите номер вагона'
    wagon_number = gets.chomp.to_i
    train.wagons.find { |w| w.number == wagon_number }
  rescue StandardError => e
    puts "Зафиксирована ошибка ввода: #{e.message}.\nПовторите ввод "
    retry
  end

  #========== Test data ===================
  def seed
    @stations << Station.new('Moscow')
    @stations << Station.new('Piter')
    # @stations << Station.new('Vladivostok')
    # @stations << Station.new('Murmansk')
    # @stations << Station.new('Ekaterinburg')

    @trains << PassengerTrain.new('Ф12-AC')
    @trains[0].add_wagon(PassengerWagon.new(36))
    @trains[0].add_wagon(PassengerWagon.new(32))
    @trains[0].add_wagon(PassengerWagon.new(32))

    @trains << CargoTrain.new('666-AD')
    @trains[1].add_wagon(CargoWagon.new(10))
    @trains[1].add_wagon(CargoWagon.new(20))
    @trains[1].add_wagon(CargoWagon.new(30))
    @trains[1].add_wagon(CargoWagon.new(40))

    @trains << PassengerTrain.new('55S-LS')
    @trains[2].add_wagon(PassengerWagon.new(36))
    @trains[2].add_wagon(PassengerWagon.new(32))
    @trains[2].add_wagon(PassengerWagon.new(32))

    @routes << Route.new(@stations[0], @stations[1])
    # @routes << Route.new(@stations[0], @stations[2])
    # @routes << Route.new(@stations[3], @stations[4])

    @trains[0].route = (@routes[0])
    # @trains[1].route = (@routes[1])
    # @trains[2].route = (@routes[2])
  end
  #======================================
end

game = Main.new
game.start
#============= main loop ==============
loop do
  action_num = game.action_input
  break if action_num == game.exit_action_num

  action = game.get_action(action_num)
  puts "--- #{game.menu.find { |m| m[:number] == action_num }[:message]} ---"
  game.send(action)
end
#======================================
