require_relative 'train'

class PassengerTrain < Train
  def add_wagon(wagon)
    if wagon.type == :passenger
      super(wagon)
    else
      puts "Грузовой вагон не может быть прицеплен к пассажирскому поезду"
    end
  end
end
