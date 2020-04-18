# frozen_string_literal: true

require './util/assertion_error'
require './generation.rb'
require './parameters.rb'

# A simulation of the evolution of a population.
class Simulation
  # A new simulation
  # @pre
  #   Parameters.valid?
  def initialize
    unless Parameters.valid?
      raise AssertionError, 'invalid simulation parameters'
    end

    @generations = [Generation.new_initial_pop]
  end

  # Starts the simulation and displays the results on the standard output.
  def start
    (0...Parameters.duration).each do |i|
      @generations[i + 1] = Generation.new(@generations[i].offsprings)
    end
    compute_nnrs
    show
  end

  private

  def compute_nnrs
    @generations.each_with_index do |gen, i|
      gen.compute_nrr(@generations[i + 1]) unless i >= @generations.length - 1
    end
  end

  # Displays the results of the simulation on the standard output.
  def show
    display_column_titles
    (1...@generations.length).each do |i|
      print(format("%5d", i))
      puts(@generations[i - 1].formatted_infos)
    end
  end

  def display_column_titles
    fw = Parameters::FORMAT_WIDTH
    puts(format("%#5s%#{fw}s%#{fw}s%#{fw}s%#{fw}s%#{fw}s", 'GEN',
         'POP', 'MALE%', 'FEMALE%', 'AVG OFF', 'NRR'))
    ((fw * 5) + 5).times { print('-') }
    print("\n")
  end
end
