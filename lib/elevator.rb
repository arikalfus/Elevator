class Elevator

  ELEV_MAX_PERSONS = 20

  attr_reader :buttons, :max_floors
  attr_accessor :current_floor, :moving_direction

  def initialize(params)
    build_buttons(params[:floors]) # :floors is an array of Floor objects
    @moving_direction = :stopped
    @current_floor = params[:current_floor]
  end

  # Returns floor object unless desired floor is current position of elevator
  def go_to_floor(floor_num)
    if floor_num == current_floor
      nil
    else
      @buttons[floor_num]
    end
  end

  def move(direction)
    if direction == :up
      move_up
    elsif direction == :down
      move_down
    elsif direction == :stopped
      # do nothing
    else
      raise ArgumentError, "Direction #{direction} is not known."
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
    if current_floor + 1 >= max_floors
      @moving_direction = :down
      if current_floor + 1 > max_floors
        move('down')
      else
        @current_floor += 1
      end
    end
  end

  def move_down
    @moving_direction = :down
    if current_floor - 1 <= 1
      @moving_direction = :up
      if current_floor + 1 < 0
        move('up')
      else
        @current_floor -= 1
      end
    end
  end

end