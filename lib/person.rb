class Person

  attr_reader :desired_floor

  def initialize(params)
    @desired_floor = params[:desired_floor]
  end

  def <=>(other)
    desired_floor <=> other.desired_floor
  end

end