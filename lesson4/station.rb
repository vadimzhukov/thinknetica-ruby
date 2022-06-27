class Station
  attr_reader :title

  def initialize(title)
    @title = title
    @trains = []
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