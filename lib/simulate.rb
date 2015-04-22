require 'require_all'
require 'pry-byebug'

require_rel '*'


class Simulate

  attr_reader :building, :clock_time, :max_turns

  def initialize(params)
    @max_turns = params[:turns]
    @clock_time = 0

    build_simulation(params)
  end

  def self.run(num_turns)
    params = construct_object_params
    params[:turns] = num_turns
    initialize params
    (0...num_turns).each do |i|
      clock_tick
    end
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

  def self.construct_object_params
    puts 'Would you like to run an automated simulation, or would you like to manually configure the objects? ([A]utomated/[M]anual): '
    construct_method = gets.chomp
    if construct_method.downcase == 'a'
      auto_construct
    elsif construct_method.downcase == 'm'
      build_manual_construct
    else
      puts "\n", 'You did not enter a valid parameter (A/M). Press ctrl-C if you would like to terminate the program.'
      construct_object_params
    end
  end

  # Construct simulation with 3 floors, 1 elevator, and 1 person.
  def self.auto_construct
    build_simulation({floor_params: [{position: 1, person_params: [{desired_floor: 2}]},
                                     {position: 2},
                                     {position: 3}],
                      num_of_elevators: 1})
  end

  def self.build_manual_construct

  end

  def self.build_simulation(params)
    floors = build_floors params[:floor_params]
    elevators = build_elevators({floors: floors, num: params[:num_of_elevators]})

    @building = Building.new({floors: floors, elevators: elevators})
  end

  def self.build_floors(floor_params)
    floors = Hash.new
    floor_params.each do |floor_param|
      people = build_people floor_param[:person_params]
      floor = Floor.new floor_param.merge({persons: people})
      # Add key->value from integer floor num to Floor object for that floor
      floors[floor.position] = floor
    end

    floors
  end

  def self.build_elevators(elevator_params)
    elevators = Array.new
    (0...elevator_params[:num]).each do |i|
      elevator = Elevator.new elevator_params[:floors]
      elevators.push elevator
    end
  end

  def self.build_people(persons_params)
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