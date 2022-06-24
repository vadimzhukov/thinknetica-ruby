class Train
  FORWARD = :forward
  BACKWARD = :backward

  attr_accessor :speed
  attr_reader :wagons, :current_station, :number, :type

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
  end

  def stop 
    self.speed = 0
  end

  def add_wagon(wagon)
      if self.speed == 0 
          @wagons << wagon
          puts "К поезду #{self.number} прицеплен вагон, общее количество вагонов: #{wagons.size}"
      else
        puts "Для прицепления вагона поезд должен остановиться"
      end
  end

  def remove_wagon
    if self.speed == 0
      if @wagons.size > 0 
        @wagons.pop
        puts "От поезда #{self.number} отцеплен вагон, общее количество вагонов: #{wagons.size}"
      else
        puts "В поезде нет вагонов"
      end
    else
      puts "Для отцепления вагона поезд должен остановиться"
    end
end

  def set_route(route)
    @route = route
    @current_station = route.stations.first
  end

  def move(direction)
    if direction == FORWARD 
      if !last_station?(@current_station, @route)
        @current_station = @route.stations[@route.stations.index(@current_station) + 1]
        @current_station.receive_train(self)
      else
        puts "Поезд на конечной станции и не может двигаться вперед"
      end 
    end

    if direction == BACKWARD 
      if !first_station?(@current_station, @route)
        @current_station = @route.stations[@route.stations.index(@current_station) - 1]
        @current_station.receive_train(self)
      else
        puts "Поезд на начальной станции и не может двигаться назад"
      end
    end
  end


#==========#
  private

  #метод используется только для метода класса move
  def last_station?(current_station, route)
    current_station == route.stations.last
  end

  #метод используется только для метода класса move
  def first_station?(current_station, route)
    current_station == route.stations.first
  end
end