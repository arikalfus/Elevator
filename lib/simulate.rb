require_relative 'building'
require_relative 'elevator'
require_relative 'floor'
require_relative 'person'


class Simulate

  attr_reader :building, :clock_time, :max_turns, :floors, :elevators

  #
  # See #build_simulation for initialization of other instance variables
  #
  def initialize(turns)
    @max_turns = turns
    @clock_time = 0
  end

  def run
    construct_object_params
    (0...@max_turns).each do |i|
      clock_tick
    end
  end

  def clock_tick
    if clock_time == max_turns
      puts "\n\n", 'Simulation complete.'
    else
      @clock_time += 1
      building.start_turn
      to_s
      sleep 1
      clock_tick
    end

  end

  def to_s
    puts 'Turn'
  end


  private

  def construct_object_params
    puts 'Would you like to run an automated simulation, or would you like to manually configure the objects? ([A]utomated/[M]anual): '
    construct_method = gets.chomp
    if construct_method.downcase == 'a'
      auto_construct
    elsif construct_method.downcase == 'm'
      build_manual_construct
    else
      puts "\n", 'You did not enter a valid parameter (A/M). Press ctrl-C if you would like to terminate the program
.', "\n"
      construct_object_params
    end
  end

  # Construct simulation with 3 floors, 1 elevator, and 1 person.
  def auto_construct
    build_simulation({floor_params: [{position: 1, person_params: [{desired_floor: 3}]},
                                     {position: 2},
                                     {position: 3}],
                      num_of_elevators: 1,
                      building: self})
  end

  def build_manual_construct
    # TODO: fill this out
    puts "\n", 'Manual construction is in development and is unavailable at this time! Please restart the application
 and select the "Automated" option.'
  end

  def build_simulation(params)
    @building = Building.new
    floors = build_floors params[:floor_params]
    @floors = floors
    elevators = build_elevators({building: self, num: params[:num_of_elevators]})
    @elevators = elevators

    @building.add_floors floors: @floors
    @building.add_elevators elevators: @elevators
  end

  def build_floors(floor_params)
    floors = Hash.new
    floor_params.each do |floor_param|
      people = build_people floor_param[:person_params]
      floor = Floor.new floor_param.merge({persons: people, building: @building})
      # Add key->value from integer floor num to Floor object for that floor
      floors[floor.position] = floor
    end

    floors
  end

  def build_elevators(elevator_params)
    elevators = Array.new
    (0...elevator_params[:num]).each do |i|
      elevator = Elevator.new elevator_params.merge(elev_num: i, building: @building)
      elevators.push elevator
    end

    elevators
  end

  def build_people(persons_params)
    if persons_params.nil?
      nil
    else
      persons = Array.new
      persons_params.each do |person_param|
        person = Person.new person_param
        persons.push person
      end
      persons
    end
  end

end