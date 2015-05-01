require_relative 'building'
require_relative 'elevator'
require_relative 'floor'
require_relative 'person'


class Simulate

  attr_reader :clock_time, :max_turns

  #
  # See #build_simulation for initialization of other instance variables
  #
  def initialize(turns)
    @max_turns = turns
    @clock_time = 0
  end

  def run
    construct_object_params
    (0...max_turns).each { |_| clock_tick }
  end

  def clock_tick
    if clock_time == max_turns
      puts "\n\n", 'Simulation complete.'
    else
      @clock_time += 1
      @building.start_turn
      to_s
      sleep 1
      clock_tick
    end

  end

  # TODO: This
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

    build_simulation(floor_params: [{position: 1, waiting_line: {up: [Person.new(desired_floor: 3)], down: []}, building: @building},
                                     {position: 2, building: @building},
                                     {position: 3}, building: @building],
                     num_of_elevators: 1)
  end

  def build_manual_construct
    # TODO: fill this out
    puts "\n", 'Manual construction is in development and is unavailable at this time! Please restart the application
 and select the "Automated" option.'
  end

  def build_simulation(params)
    @building = Building.new
    floors = build_floors params[:floor_params]
    @building.add_floors floors: floors

    elevators = build_elevators params.merge(building: @building)
    @building.add_elevators elevators: elevators
  end

  # Constructs floors as a hash from floor_num => Floor
  def build_floors(floor_params)
    floors = Hash.new
    floor_params.each do |floor_param|
      floor = Floor.new floor_param
      # Add key->value from integer floor num to Floor object for that floor
      floors[floor.position] = floor
    end

    floors
  end

  # Constructs elevators and places them in an array
  def build_elevators(elevator_params)
    elevators = Array.new
    (1..elevator_params[:num_of_elevators]).each do |i|
      elevator = Elevator.new elevator_params.merge(elev_num: i)
      elevators.push elevator
    end

    elevators
  end

  # Constructs Persons and places them in an array
  def build_people(persons_params)
    persons = Array.new
    persons_params.each do |person_param|
      person = Person.new person_param
      persons.push person
    end
    persons
  end

end