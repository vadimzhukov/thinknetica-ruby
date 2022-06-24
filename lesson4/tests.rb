require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'


# initial test data
# Станции
bologoe = Station.new("Бологое")
moscow = Station.new("Москва")
piter = Station.new("Санкт-Петербург")
tver = Station.new("Тверь")

# маршруты
moscow_piter = Route.new(moscow, piter)
piter_tver = Route.new(piter, tver)

#доп станции на маршрутах
moscow_piter.add_station(bologoe)
moscow_piter.add_station(tver)
piter_tver.add_station(bologoe)

# 1 тестовый поезд
sapsan = PassengerTrain.new(666, :passenger)
sapsan.set_route(moscow_piter)

# 2 тестовый поезд
lastochka = PassengerTrain.new(555, :passenger)
lastochka.set_route(piter_tver)

#3 тестовый поезд
cargo_tr = CargoTrain.new(444, :cargo)
cargo_tr.set_route(moscow_piter)

# вагоны
p_wagons = []
c_wagons = []

# ========================= tests ========================#
5.times do
  wagon = Wagon.new(:passenger)
  p_wagons << wagon
end
7.times do
  c_wagons << Wagon.new(:cargo)
end


sapsan.add_wagon(p_wagons[0])

sapsan.move(:forward)

lastochka.move(:forward)
lastochka.move(:forward)

5.times do |i|
  cargo_tr.add_wagon(c_wagons[i-1])
end

3.times do
  cargo_tr.remove_wagon
end


cargo_tr.move(:forward)

puts "Пассажирские поезда на станции Бологое : #{bologoe.trains_by_type(:passenger)}"
puts "Грузовые поезда на станции Бологое : #{bologoe.trains_by_type(:cargo)}"