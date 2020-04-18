# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'

# A generation of individuals forming couples.
# @inv
#   individuals.each { |i| i.is_a?(Individual) }
#   && offsprings.each { |i| i.is_a?(Individual) }
#   && nrr >= 0.0
class Generation
  attr_reader :offsprings, :individuals
  attr_accessor :nrr

  # A new generation formed with new indivuals whose sex is randomly determined.
  # @pre
  #   Parameters.initial_pop_size >= 0
  # @post
  #   individuals.length == Parameters.initial_pop_size
  #   && individuals.each { |i| i.is_a?(Individual) }
  #   && offsprings.each { |o| o.is_a?(Individual) }
  #   && nrr == 0.0
  def self.new_initial_pop
    unless Parameters.initial_pop_size >= 0
      raise AssertionError.new, 'negative initial population'
    end

    initial_pop = Array.new(Parameters.initial_pop_size) do
      Individual.new(Individual::SEXES.sample)
    end
    new(initial_pop)
  end

  # Returns the number of mothers in the given generations.
  # @post
  #   0 <= result < gen.individuals.length
  def self.mothers_count(gen)
    gen.individuals.select { |i| i.paired? && i.sex == :female }.length
  end

  # Returns the net reproduction rate for the two given generations.
  # @post
  #   result >= 0.0
  def self.compute_nrr(parent_gen, off_gen)
    if parent_gen.individuals.empty? || off_gen.individuals.empty?
      0
    else
      (mothers_count(off_gen) / mothers_count(parent_gen).to_f).round(1)
    end
  end

  # A new generation made from the given population.
  # @post
  #   individuals.length == pop.length
  #   && individuals.each { |i| i.is_a?(Individual) }
  #   && offsprings.each { |o| o.is_a?(Individual) }
  #   && nrr == 0.0
  def initialize(pop)
    @individuals = pop
    @couples = make_couples
    @offsprings = make_offsprings
    @nrr = 0.0
  end

  # Displays formatted details about this generation.
  def display_details
    puts("#{@individuals.length}\t#{avg_offsprings}\t" \
         "#{sex_percentage(:male)}|#{sex_percentage(:female)}\t#{@nrr}\t")
  end

  private

  # Returns an array of couples made from the individuals in this generation.
  # @post
  #   result.each { |c| c.is_a?(Couple) }
  def make_couples
    return [] if @individuals.empty?

    couples = []
    males = @individuals.select { |i| i.sex == :male }
    females = @individuals.select { |i| i.sex == :female }
    n = [males.length, females.length].min
    (0...n).each { |i| couples << Couple.new(males[i], females[i]) }
    couples
  end

  # Returns an array of offsprings of the couples in this generation.
  # @post
  #   result.each { |i| i.is_a?(Individual) }
  def make_offsprings
    offsprings = []
    @couples.each do |cpl|
      cpl.breed
      offsprings << cpl.offsprings
    end
    offsprings.flatten
  end

  # Returns the average number of offsprings per couples in this generation.
  # @post
  #   0.0 <= resutlt <= Parameters.max_offsprings
  def avg_offsprings
    if @couples.empty?
      0
    else
      (@offsprings.length / @couples.length.to_f).round(1)
    end
  end

  # Returns the percentage of individuals of the given sex in this generation.
  # @pre
  #   Individual::SEXES.include?(sex)
  # @post
  #   0.0 <= retult <= 100.0
  def sex_percentage(sex)
    raise AssertionError, 'unkown sex' unless Individual::SEXES.include?(sex)

    if @individuals.empty?
      0
    else
      tot = @individuals.select { |i| i.sex == sex }.length
      (tot / @individuals.length.to_f * 100).round
    end
  end
end
