class TestTrain
  @@instances = 0

  def initialize(number, type = :passenger)
    @number = number
    @type = type
    register_instance
  end

  def self.instances 
    @@instances
  end

  private
  def self.increase_instance
    @@instances ||= 0
    @@instances += 1
  end

  def register_instance
    self.class.send :increase_instance
  end
end

tr1 = TestTrain.new("MMM_NUM1")
tr2 = TestTrain.new("MMM_NUM2")
tr3 = TestTrain.new("MMM_NUM3")

puts TestTrain.instances
