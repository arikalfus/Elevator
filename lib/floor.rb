class Floor

  attr_reader :position, :buttons, :persons

  def initialize(params)
    @position = params[:position] # int position from 1 to n
    @persons = params[:persons] || Hash.new # hash of people waiting for an elevator, keys are up/down and ordered by position of desired floor from current floor
  end

  def start_turn(elevator)
    direction = elevator.moving_direction
    persons[direction].each do |person|
      elevator.board_person person
    end
  end

  # Floors are compared by their position number
  def <=>(other)
    position <=> other.position
  end

  def ==(other)
    position == other.position
  end

end