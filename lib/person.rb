class Person

  attr_reader :desired_floor

  # We only care about the floor a Person wants to go to
  def initialize(params)
    @desired_floor = params[:desired_floor]
  end

  def <=>(other)
    desired_floor <=> other.desired_floor
  end

end