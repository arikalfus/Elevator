class Elevator

  ELEV_MAX_PERSONS = 20
  ELEV_RESTING_FLOOR = 1

  attr_reader :building, :max_floors, :current_floor, :passengers, :passenger_count, :number
  attr_accessor :moving_direction

  def initialize(params)

    @number = params[:elev_num]
    @building = params[:building]
    @max_floors = building.number_of_floors
    @moving_direction = :stopped
    @current_floor = ELEV_RESTING_FLOOR
    build_passenger_hash

  end

  # Elevator boards, moves to a new floor, and un-boards
  def start_turn
    move
    exit_elevator
  end

  # Elevator moves up/down based on current moving_direction
  def move

    if moving_direction == :up
      if read_passenger_desires
        move_up
      else
        @moving_direction = :down
        move
      end

    elsif moving_direction == :down
      move_down

    elsif moving_direction == :stopped
      begin_moving

    else
      raise Exception, 'Moving direction is set to an invalid symbol:', moving_direction
    end

  end

  # Passengers from floor are boarded onto elevator
  def board(floor)

    boarded = 0

    unless moving_direction == :stopped
      waiting_line = floor.get_waiting moving_direction

      # Board each person onto the elevator
      waiting_line.each do |person|
        unless passenger_count == ELEV_MAX_PERSONS
          board_person person
          boarded += 1
        end
      end

      # remove boarded Persons from floor's waiting line
      floor.update_waiting_line boarded, moving_direction
    end

  end

  #
  def exit_elevator
    persons_exiting = passengers[current_floor]
    @passenger_count -= persons_exiting.count
    # Add exiting passengers to current floor
    building.floor(current_floor).arrive persons_exiting
    @passengers[current_floor].clear
  end

  # Passengers are inserted into passengers array ordered by what floor they want to get off at
  def board_person(person)
    @passengers[person.desired_floor].push person
    @passenger_count += 1
  end

  # Returns passengers as an array
  def get_passengers
    passengers.values.flatten
  end

  def to_s
    %Q(
    Elevator #{number}:
      Passengers: #{passenger_count} of maximum #{ELEV_MAX_PERSONS} people
      Current floor: #{current_floor}
      Moving #{moving_direction}
      Resting floor is Floor #{ELEV_RESTING_FLOOR}
         )
  end

  # ---------
  # Private methods below
  # ---------

  private

  # Passengers are stored in a hash where each key is a floor number corresponding to an array of passengers desiring that floor
  def build_passenger_hash
    @passengers = Hash.new
    (1..@max_floors).each { |i| @passengers[i] = Array.new }
    @passenger_count = 0
  end

  def move_up

    @moving_direction = :down if current_floor + 1 == max_floors

    if current_floor == max_floors
      @moving_direction = :down
      move
    else
      board building.floor(current_floor)
      @current_floor += 1
    end

  end

  def move_down

    @moving_direction = :stopped if current_floor - 1 == ELEV_RESTING_FLOOR or current_floor == ELEV_RESTING_FLOOR

    # A call to #move_down when on ELEV_RESTING_FLOOR does nothing
    unless current_floor == ELEV_RESTING_FLOOR
      board building.floor(current_floor)
      @current_floor -= 1
    end

  end

  # Method should only be called if elevator is at ELEV_RESTING_FLOOR
  def begin_moving
    @moving_direction = :up
    move
  end

  # Checks if any passengers want to get off on a higher floor
  def read_passenger_desires

    ((current_floor + 1)..max_floors).each { |floor_num| return true if check_desires floor_num }

    # After checking if any passengers need to go up, ask building if anyone above current floor is waiting for an elevator
    building.check_pickup_requests current_floor

  end

  # Checks if any passengers want to get off at floor floor_num
  def check_desires(floor_num)
    true unless passengers[floor_num].empty?
  end

end