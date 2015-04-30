require 'pry-byebug'

class Floor

  attr_reader :position, :persons, :building

  def initialize(params)
    @position = params[:position] # int position from 1 to n
    @persons = params[:persons] || { up: [], down: [] } # hash of people waiting for an elevator, keys are up/down and values are arrays of Persons
    @building = params[:building]
  end

  # add Person object to this floor in the correct queue
  def add_person(person)
    current_position = position <=> person.desired_floor
    if current_position == 1 # person is above their desired floor
      persons[:down].push person
    elsif current_position == -1 # person is below their desired floor
      persons[:up].push person
    # else, person is on their desired floor, person 'disappears'
    end

    building.log_pickup_request position
  end

  # Add an array of persons to the floor
  #
  # see #add_person
  def arrive(persons_array)
    persons_array.each do |person|
      add_person person
    end
  end

  # Remove Persons from appropriate queue after boarding an Elevator
  def update_waiting_line(num_boarded, direction)

    waiting_line = get_waiting direction
    waiting_line.slice! 0...num_boarded
    @persons[direction] = waiting_line

  end

  # Returns an array of Persons waiting for an elevator going direction
  def get_waiting(direction)
    persons[direction]
  end

  # Returns number of people waiting for an elevator
  def count_line
    num = 0
    persons.values.each { |array| array.each { |_| num += 1} }
    num
  end

  # Floors are compared by their position number
  def <=>(other)
    position <=> other.position
  end

  def ==(other)
    position == other.position
  end

end