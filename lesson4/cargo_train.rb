# frozen_string_literal: true

require_relative 'train'
require_relative 'instance_counter'

# This class describes trains with type = cargo
class CargoTrain < Train
  include InstanceCounter

  def initialize(number)
    super(number, 'cargo')
  end

  def add_wagon(wagon)
    super(wagon) if wagon.type == :cargo
  end
end
