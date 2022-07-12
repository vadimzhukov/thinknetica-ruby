# frozen_string_literal: true

# This class describes wagons of trains with type = cargo
class CargoWagon < Wagon
  def initialize(total_volume)
    super(:cargo, total_volume)
  end

  def occupy(volume)
    return unless available_places >= volume

    @occupied_spaces += volume
    @available_volume -= volume
  end
end
