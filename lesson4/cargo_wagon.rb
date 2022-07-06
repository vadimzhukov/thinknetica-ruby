class CargoWagon < Wagon
  def initialize(total_volume)
    super(:cargo, total_volume)
  end

  def occupy(volume)
    if available_places >= volume
      @occupied_spaces += volume
      @available_volume -= volume
    end
  end
end
