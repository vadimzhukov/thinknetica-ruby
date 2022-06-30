require_relative 'train'
require_relative 'instance_counter'

class CargoTrain < Train
  include InstanceCounter

  def initialize(number)
    super(number, :cargo)
  
  end

  def add_wagon(wagon)
    if wagon.type == :cargo
      super(wagon)
    else
      puts "Грузовой вагон не может быть прицеплен к пассажирскому поезду"
    end
  end

end
