class Station
  attr_reader :title, :trains

  def initialize(title)
    @title = title
    @trains = []
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