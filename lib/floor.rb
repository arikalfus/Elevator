class Floor

  attr_reader :position, :waiting_line, :building, :waiting_count, :inhabitants

  def initialize(params)

    @building = params[:building]
    @position = params[:position] # int position from 1 to n
    # hash of people waiting for an elevator, keys are up/down and values are arrays of Persons
    @waiting_line = params[:waiting_line] || { up: [], down: [] }
    @inhabitants = Array.new
    calc_waiting_count

  end

  # add Person object to this floor in the correct queue
  def add_person(person)
    current_position = position <=> person.desired_floor
    if current_position == 1 # person is above their desired floor
      waiting_line[:down].push person
      @waiting_count += 1
      building.log_pickup_request position

    elsif current_position == -1 # person is below their desired floor
      waiting_line[:up].push person
      @waiting_count += 1
      building.log_pickup_request position

    else # person belongs to this floor
      @inhabitants.push person
    end
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

    waiting = get_waiting direction
    waiting.slice! 0...num_boarded
    @waiting_line[direction] = waiting
    @waiting_count -= num_boarded

    # Send notice to @building to remove this floor's pickup request
    @building.remove_pickup_request(position) if waiting_line[direction].empty?

  end

  # Returns an array of Persons waiting for an elevator going direction
  def get_waiting(direction)
    waiting_line[direction]
  end

  # Returns number of people waiting for an elevator
  def count_line
    waiting_count
  end

  # Returns number of inhabitants on floor
  def inhabitant_count
    inhabitants.count
  end

  # Floors are compared by their position number
  def <=>(other)
    position <=> other.position
  end

  def ==(other)
    position == other.position
  end

  # Displays helpful details about the Floor's current state
  def to_s
    %Q(
    Floor #{position}:
      Inhabitants: #{inhabitants.count}
      Total people waiting for elevators: #{waiting_count}
        - Waiting for 'up' elevator: #{waiting_line[:up].count}
        - Waiting for 'down' elevator: #{waiting_line[:down].count}
         )
  end

  private

  # Calculate how many people are waiting for an elevator on this floor
  def calc_waiting_count
    @waiting_count = 0
    waiting_line.values.each { |array| array.each { @waiting_count += 1 } }
    building.log_pickup_request(position) if waiting_count > 0
  end

end