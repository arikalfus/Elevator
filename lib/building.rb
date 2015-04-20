class Building

  attr_reader :elevators, :floors

  def initialize(params)
    @elevators = params[:elevators] # elevator objects in the building
    @floors = params[:floors] # floor objects in the building
  end

  def number_of_elevators
    elevators.count
  end

  def number_of_floors
    floors.count
  end

end