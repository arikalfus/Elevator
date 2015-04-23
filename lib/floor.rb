class Floor

  attr_reader :position, :persons

  def initialize(params)
    @position = params[:position] # int position from 1 to n
    @persons = params[:persons] || Hash.new # hash of people waiting for an elevator, keys are up/down and values are arrays of Persons ordered by position of desired floor from current floor
  end

  #
  def start_turn(elevator)

    direction = elevator.moving_direction
    num_boarded = board_elevator elevator
    update_waiting_line num_boarded, direction

  end

  def add_person(person)

    current_position = position <=> person.desired_floor
    if current_position > 1 # person is above their desired floor
      persons[:down].push person
    elsif current_position < 1 # person is below their desired floor
      persons[:up].push person
    end

  end

  def floor_num
    position
  end

  # Floors are compared by their position number
  def <=>(other)
    position <=> other.position
  end

  def ==(other)
    position == other.position
  end

  private

  def board_elevator(elevator)
    elevator.board
  end

  def update_waiting_line(num_boarded, direction)

    waiting_line = persons[direction]
    waiting_line.slice num_boarded
    persons[direction] = waiting_line

  end

end