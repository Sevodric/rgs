# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'

# A simulation of the evolution of a population.
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
  # @pre  pop.each { |i| i.is_a?(Individual) }
  # @post result.each { |c| c.is_a?(Couple) }
  def match(pop)
    couples = []
    pop.each do |ind|
      mate = pop.select { |i| i.compatible?(ind) }.first
      couples.push(Couple.new(ind, mate, MAX_PROGENY)) unless mate.nil?
    end
    couples
  end

  # Displays informations for each generation of the simulation.
  def describe
    puts("GEN\tPOP\tOFF\tF%|M%")
    puts("---\t---\t---\t-----")
    @generations.each do |gen, pop|
      print("#{gen}\t")
      print("#{pop.length}\t")
      print("#{average_progeny(pop)}\t")
      print("#{sex_percentage(pop, :female)}|#{sex_percentage(pop, :male)}\n")
    end
  end

  # Returns the average number of offsprings/couple for the given population.
  #
  # The result is given with a precision of 1 decimal digit.
  # @pre  pop.each { |i| i.is_a?(Individual }
  # @post 0 <= result <= @max_progeny
  def average_progeny(pop)
    couples = couples_from(pop)
    tot_progeny = 0
    couples.each { |c| tot_progeny += c.progeny.length }
    (tot_progeny / couples.length.to_f).round(1) unless couples.empty?
  end

  # Returns an array containing all couples contained in the given population.
  # @pre  pop.each { |i| i.is_a?(Individual }
  # @post result.each { |r| r.is_a?(Couple) }
  def couples_from(pop)
    couples = []
    pop.each do |i|
      couples.push(i.couple) if i.paired? && !couples.include?(i.couple)
    end
    couples
  end

  # Returns the percentage of individuals of the given sex in a population.
  # @pre  pop.each { |i| i.is_a?(Individual } && Individual::SEXES.include?(sex)
  # @post 0 <= result <= 100
  def sex_percentage(pop, sex)
    tot = 0
    pop.each { |i| tot += 1 if i.sex == sex }
    (tot / pop.length.to_f * 100).round
  end
end
