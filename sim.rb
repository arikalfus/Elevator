require_relative 'lib/simulate'


class Sim

  def self.get_turns
    puts 'How many times would you like to run this simulation? '
    Integer(gets.chomp)
  end

end


number_of_turns = Sim.get_turns

sim = Simulate.new number_of_turns
sim.run