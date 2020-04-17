# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './generation.rb'

# A simulation of the evolution of a population.
class Simulation
  def initialize(initial_pop_nb, duration)
    unless initial_pop_nb >= 0 && duration >= 0
      raise AssertionError
    end
    @duration = duration
    initial_pop = Array.new(initial_pop_nb) do
      Individual.new(Individual::SEXES.sample)
    end
    @generations = [Generation.new(initial_pop)]
  end

  def start
    (0...@duration).each do |i|
      @generations[i + 1] = Generation.new(@generations[i].offsprings)
    end
    show
  end

  def show
    puts("GEN\tPOP\tCPL\tOFF\tAVG\tM%|F%\tNNR")
    puts("---\t---\t---\t---\t---\t-----\t---")
    @generations.each_with_index do |gen, i|
      break if i == @generations.length - 1
      print("#{i + 1}\t")
      unless i >= @generations.length
        gen.nnr = Generation::compute_nnr(gen, @generations[i + 1])
      end
      gen.display_details
    end
  end
end
