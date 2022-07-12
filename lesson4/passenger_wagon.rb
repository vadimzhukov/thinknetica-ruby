# frozen_string_literal: true

# This class describes wagons of trains with type = cargo
class PassengerWagon < Wagon
  def initialize(total_places)
    super(:passenger, total_places)
  end

  def occupy
    return unless available_places.positive?

    @occupied_places += 1
    @available_places -= 1
  end
end
