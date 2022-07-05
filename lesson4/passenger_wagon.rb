class PassengerWagon < Wagon
  attr_accessor :occupied_places, :available_places

  def initialize(total_places)
    super(:passenger)
    @total_places = total_places
    @available_places = total_places
    @occupied_places = 0
  end

  def occupy
    if available_places.positive?
      @occupied_places += 1
      @available_places -= 1
    end
  end
end
