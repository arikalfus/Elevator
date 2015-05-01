require_relative 'lib/simulate'


class Sim

  # Prompt console for number of turns to run simulation
  def self.get_turns
    print 'How many times would you like to run this simulation? '
    Integer(gets.chomp)
  end

end


number_of_turns = Sim.get_turns

sim = Simulate.new number_of_turns
sim.run