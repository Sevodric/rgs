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
    show
  end

  # Displays the results of the simulation on the standard output.
  def show
    puts("GEN\tPOP\tAVG\tM%|F%\tNRR")
    puts("---\t---\t---\t-----\t---")
    @generations.each_with_index do |gen, i|
      break if i == @generations.length - 1

      print("#{i + 1}\t")
      unless i >= @generations.length
        gen.nrr = Generation.compute_nrr(gen, @generations[i + 1])
      end
      gen.display_details
    end
  end
end
