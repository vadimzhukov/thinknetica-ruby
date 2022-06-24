require_relative 'train'

class CargoTrain < Train
  def add_wagon(wagon)
    if wagon.type == :cargo
      super(wagon)
    else
      puts "Грузовой вагон не может быть прицеплен к пассажирскому поезду"
    end
  end
end
