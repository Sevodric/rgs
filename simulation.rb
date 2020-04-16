# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'

# A simulation of the evolution of a given population.
class Simulation
  # A new simulation with the given parameters.
  # @pre  pop_number >= 0 && max_progeny >= 0 && duration >= 0
  def initialize(pop_number, max_progeny, duration)
    unless pop_number >= 0 && max_progeny >= 0 && duration >= 0
      raise AssertionError, 'dude wtf t(°^°t)'
    end

    @generations = { 1 => [] }
    pop_number.times do
      @generations[1].push(Individual.new(Individual::SEXES.sample))
    end
    @max_progeny = max_progeny
    @duration = duration
  end

  # Start the simulation
  def start
    (1...@duration).each do |i|
      couples = match(@generations[i])
      new_generation = []
      couples.each do |c|
        c.breed
        c.progeny.each { |p| new_generation.push(p) }
      end
      @generations.store(i + 1, new_generation)
    end
    describe
  end

  private

  # Returns an array of couples made from the given population of individual.
  # @pre
  #     pop.each { |i| i.is_a?(Individual) }
  # @post
  #     result.each { |c| c.is_a?(Couple) }
  def match(pop)
    unless pop.each { |i| i.is_a?(Individual) }
      raise AssertionError, 'Invalid population'
    end

    couples = []
    pop.each do |ind|
      mate = pop.select { |i| i.compatible?(ind) }.first
      couples.push(Couple.new(ind, mate, MAX_PROGENY)) unless mate.nil?
    end
    couples
  end

  # Displays informations for each generation of the simulation.
  def describe
    @generations.each do |gen, pop|
      puts("Population at gen #{gen}: #{pop.length}")
    end
  end
end
