class Building

  attr_reader :elevators, :floors

  def initialize(params)
    @elevators = params[:elevators] # elevator objects in the building
    @floors = params[:floors] # hash of floor objects in the building
  end

  def number_of_elevators
    elevators.count
  end

  def number_of_floors
    floors.count
  end

  def start_turn
    # get floor requests, new people requesting elevator?

    elevators.each do |elevator|
      elevator.start_turn
      cur_floor = elevator.current_floor
      floor = floors[cur_floor]
      floor.start_turn(elevator)
    end
  end

end