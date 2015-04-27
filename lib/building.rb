class Building

  attr_reader :elevators, :floors

  def initialize
    @floors = Hash.new
    @elevators = Array.new
  end

  def build_floors(params)
    @floors = params[:floors]
  end

  def build_elevators(params)
    @elevators = params[:elevators]
  end

  def number_of_elevators
    elevators.nil? ? raise(Exception,'No elevators exist! You should run the Building#build_elevators method.') :
        elevators.count
  end

  def number_of_floors
    floors.nil? ? raise(Exception, 'No floors exist! You should run the Building#build_floors method.') : floors.keys
                                                                                                            .count
  end

  def start_turn
    # TODO: get floor requests, new people requesting elevator?

    elevators.each do |elevator|
      num_boarded = elevator.start_turn
      floor.update_waiting_line num_boarded elevator.moving_direction
    end

    to_s
  end

  # Returns floor object corresponding to floor number
  def floor(num)
    floors[num]
  end

  def to_s
    #TODO: This
  end

end