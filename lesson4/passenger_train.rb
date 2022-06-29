require_relative 'train'
require_relative 'instance_counter'

class PassengerTrain < Train
  include InstanceCounter

  def initialize(number)
    super(number, :passenger)
  end

  def add_wagon(wagon)
    if wagon.type == :passenger
      super(wagon)
    else
      puts "Грузовой вагон не может быть прицеплен к пассажирскому поезду"
    end
  end
  
end
