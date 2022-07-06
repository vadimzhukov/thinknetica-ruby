class PassengerWagon < Wagon
  def initialize(total_places)
    super(:passenger, total_places)
  end

  def occupy
    if available_places.positive?
      @occupied_places += 1
      @available_places -= 1
    end
  end
end
