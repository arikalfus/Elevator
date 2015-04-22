class Elevator

  ELEV_MAX_PERSONS = 20
  ELEV_RESTING_FLOOR = 1

  attr_reader :buttons, :max_floors, :current_floor, :moving_direction

  def initialize(params)
    build_buttons(params[:floors]) # :floors is an array of Floor objects
    @moving_direction = :stopped
    @current_floor = params[:current_floor]
  end

  def start_turn
    if @moving_direction == :stopped
      @moving_direction = :up
      move
    else
      move
    end
  end

  # Returns floor object unless desired floor is current position of elevator
  def go_to_floor(floor_num)
    if floor_num == current_floor
      nil
    else
      @buttons[floor_num]
    end
  end

  def move
    if moving_direction == :up
      move_up
    elsif moving_direction == :down
      move_down
    # if moving_direction is :stopped, do nothing
    end
  end

  private

  # Builds a hash of floor numbers to the corresponding Floor object
  def build_buttons(floors)
    @buttons = Hash.new
    (0...floors.count).each do |i|
      @buttons[i + 1] = floors[i]
    end

    @max_floors = @buttons.keys.count
  end

  def move_up
    @moving_direction = :up
    if current_floor + 1 == max_floors
      @moving_direction = :down
      @current_floor += 1
    end
  end

  def move_down
    @moving_direction = :down
    if current_floor - 1 == ELEV_RESTING_FLOOR
      @moving_direction = :stopped
      @current_floor -= 1
    end
  end

end