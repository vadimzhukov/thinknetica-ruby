class CargoWagon < Wagon
  attr_accessor :occupied_volume, :available_volume

  def initialize(total_volume)
    super(:cargo)
    @total_volume = total_volume.to_f
    @available_volume = total_volume.to_f
    @occupied_volume = 0
  end

  def occupy
    if available_volume.positive?
      @occupied_volume += 1
      @available_volume -= 1
    end
  end
end
