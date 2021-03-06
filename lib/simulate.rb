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

  # Run a simulation for max_turns turns
  def run
    construct_object_params # construct the objects needed for the simulation
    print_start # Print starting positions of floors, persons, and elevators
    (0...max_turns).each { clock_tick }
  end

  # Run one turn of the simulation
  def clock_tick
    @clock_time += 1

    # 1/3 chance to randomly add a new person on a random floor
    new_person = Random.rand(1.0)
    generate_person if new_person >= 0.66

    @building.start_turn
    to_s
    sleep 1

    puts "\n", '-----------------', 'Simulation complete.' if clock_time == max_turns
  end

  # Print out the current state of the simulation
  def to_s

    puts "Turn #{clock_time}:"
    # Print a row for each floor
    (1..@building.number_of_floors).reverse_each do |i|
      # Print a column for each elevator
      @building.elevators.each do |elevator|
        print '|'
        # Print an elevator if the elevator is on floor i
        if elevator.current_floor == @building.floors[i].position
          print "[#{elevator.passenger_count}]"
        else
          print '[ ]'
        end
      end
      print '|  '
      # Print out floor information
      print "[#{@building.floors[i].waiting_count}]"
      print "[#{@building.floors[i].inhabitant_count}]"
      puts "\n"
    end
    puts "\n"

  end


  private

  # Prompt for type of object construction
  #
  # NOTE: Only automated configuration is available right now
  def construct_object_params
    print 'Would you like to run an automated simulation, or would you like to manually configure the objects?
([A]utomated/[M]anual): '
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

    build_simulation(floor_params: [{position: 1, waiting_line: {up: [Person.new(desired_floor: 3)], down: []}},
                                    {position: 2},
                                    {position: 3, waiting_line: {up: [Person.new(desired_floor: 5)], down: []}},
                                    {position: 4},
                                    {position: 5, waiting_line: {up: [], down: [Person.new(desired_floor: 1), Person.new(desired_floor: 3)]}}],
                     num_of_elevators: 2)
  end

  # Not implemented due to time constraints.
  #
  # TODO: Prompt for number of floors, elevators, number of people waiting for an elevator on each floor
  def build_manual_construct
    abort "\nManual construction is not available at this time. Please restart the application
 and select the 'Automated' option."
  end

  # Build the components of the simulation - the building, floors, and elevators
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
      floor = Floor.new floor_param.merge(building: @building)
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

  # Print the starting location of the simulation
  def print_start
    to_s
    sleep 1.5
  end

  # Randomly generate a person on a random floor
  def generate_person
    rand_floor = rand(@building.number_of_floors) + 1
    person = Person.new(desired_floor: rand_floor)
    rand_start_floor = rand(@building.number_of_floors) + 1


    @building.floors[rand_start_floor].add_person person
  end

end