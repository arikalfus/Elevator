class Elevator

  ELEV_MAX_PERSONS = 20

  attr_reader :buttons

  def initialize(params)
    button_count = params[:floor_count]
  end

  private

  # Builds a hash of floor numbers to the corresponding Floor object
  def build_buttons(floor_count, floors)
    @buttons = Hash.new
    floor_count.each do |count|
      @buttons[count] = floors[count]
    end
  end

end