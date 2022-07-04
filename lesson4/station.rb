require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  TITLE_LENGTH = (1..30)
  attr_reader :title

  @@stations = []

  def initialize(title)
    @title = title
    validate!
    @trains = []
    register_instance
    @@stations << self
  end

  def validate!
    validate_not_nil(title)
    validate_length(title, TITLE_LENGTH.first, TITLE_LENGTH.last)
    validate_not_yet_existed("@title", title, @@stations)
  end

  def valid?
    validate!
    true
    rescue
      false
  end

  def self.stations
    @@stations
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
  end

  def send_train
    if @trains
      @trains.pop()
    end
  end

end