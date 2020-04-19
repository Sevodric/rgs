# frozen_string_literal: true

require './util/assertion_error'
require './src/generation.rb'
require './src/parameters.rb'

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
    start
  end

  # Starts the simulation and displays the results on the standard output.
  def start
    (1...Parameters.duration).each do |i|
      @generations[i] = Generation.new(@generations[i - 1].offsprings, i + 1)
    end
    compute_nnrs
  end

  # Displays the results of the simulation on the standard output.
  def show
    display_column_titles
    @generations.each do |gen|
      puts(gen.formatted_infos)
    end
  end

  def to_csv(file)
    @generations.each do |gen|
      gen.to_csv(file)
    end
  end

  private

  def compute_nnrs
    (0...(@generations.length - 1)).each do |i|
      @generations[i].compute_nrr(@generations[i + 1])
    end
  end

  def display_column_titles
    fw = Parameters::FORMAT_WIDTH
    puts(format("%5s%#{fw}s%#{fw}s%#{fw}s%#{fw}s%#{fw}s", 'GEN',
                'POP', 'MALE%', 'FEMALE%', 'AVG OFF', 'NRR'))
    ((fw * 5) + 5).times { print('-') }
    print("\n")
  end
end
