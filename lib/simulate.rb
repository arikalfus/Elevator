require 'require_all'

require_all 'building', 'elevator', 'floor', 'person'


class Simulate

  attr_reader :building, :clock_time, :max_turns

  def initialize(params)
    @max_turns = params[:turns]
    @clock_time = 0

    build_simulation(params)
  end

  def clock_tick
    if clock_time == max_turns
      puts "\n", 'Simulation complete.'
    else
      @clock_time += 1
      run_sim
    end

  end


  private

  def build_simulation(params)
    floors = build_floors params[:floor_params]
    elevators = build_elevators params[:elevator_params]


    @building = Building.new params[:@building_params]
  end

  def build_floors(floor_params)
    floors = Array.new
    people = build_people floor_params[:persons_params]
    floor_params[:floors].each do |floor_param|
      floor = Floor.new floor_param
      floors.push floor
    end

    floors
  end

  def build_elevators(elevator_params)
    elevators = Array.new
    elevator_params.each do |elevator_param|
      elevator = Elevator.new elevator_param
      elevators.push elevator
    end
  end

  def build_people(persons_params)
    persons = Array.new
    persons_params.each do |person_param|
      person = Person.new person_param
      persons.push person
    end
  end

  def run_sim
    building.start_turn
  end

end