require_relative 'train'
require_relative 'instance_counter'

class PassengerTrain < Train
  include InstanceCounter

  def initialize(number)
    super(number, "passenger")
  end

  def add_wagon(wagon)
      super(wagon) if wagon.type == "passenger"
  end
  
end
