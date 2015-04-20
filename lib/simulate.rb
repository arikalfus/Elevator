class Simulate

  def initialize(params)
    @turns = params[:turns]
    @clock_time = 0

    build_simulation(params)
  end

  def clock_tick

  end



  private

  def build_simulation(params)
    @building = Building.new params[:@building_params]
  end

end