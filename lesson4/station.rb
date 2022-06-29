require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :title

  @@stations = []

  def initialize(title)
    @title = title
    @trains = []
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def trains
    result = []
    @trains.each{|t| result << "Номер:#{t.number} Тип:#{t.type} Вагоны:#{t.wagons}"}
    result
  end

  def trains_by_type(type)
    @trains.select{|t| t.type == type}.map{|x| [x.number, x.type]}
  end

  def receive_train(train)
    @trains << train
    puts "Поезд #{train.number} прибыл на станцию #{@title}"
  end

  def send_train
    if @trains
      @trains.pop()
    end
  end

end