require 'pry-byebug'

class Elevator

  ELEV_MAX_PERSONS = 20

  attr_reader :buttons, :current_floor

  def initialize(params)
    build_buttons(params[:floors]) # :floors is an array of Floor objects
    @current_floor = rand(params[:floors].count) + 1 # elevator starts on a random floor
  end

  # Returns floor object unless desired floor is current position of elevator
  def go_to_floor(floor_num)
    if floor_num == current_floor
      nil
    else
      @buttons[floor_num]
    end
  end

  private

  # Builds a hash of floor numbers to the corresponding Floor object
  def build_buttons(floors)
    @buttons = Hash.new
    0...floors.count do |i|
      binding.pry
      @buttons[i + 1] = floors[i]
    end
  end

end