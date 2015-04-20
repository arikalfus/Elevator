class Floor

  attr_reader :position, :buttons, :persons

  def initialize(params)
    @position = params[:position] # int position from 0 to n
    @buttons = params[:buttons] # 2D array of up/down buttons
    @persons = params[:persons] || Queue.new # queue of people waiting for an elevator
  end

  def number_of_elevators
    buttons.count
  end

end