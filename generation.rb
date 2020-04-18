# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'
require './parameters.rb'

# A generation of individuals forming couples.
# @inv
#   individuals.each { |i| i.is_a?(Individual) }
#   && offsprings.each { |i| i.is_a?(Individual) }
#   && 0 <= mothers_count < individuals.length
class Generation
  attr_reader :offsprings, :individuals, :mothers_count

  # A new generation formed with new indivuals whose sex is randomly determined.
  # @pre
  #   Parameters.initial_pop_size >= 0
  # @post
  #   individuals.length == Parameters.initial_pop_size
  def self.new_initial_pop
    initial_pop = Array.new(Parameters.initial_pop_size) do
      Individual.new(Individual::SEXES.sample)
    end
    new(initial_pop)
  end

  # A new generation made from the given population.
  # @post
  #   individuals.length == pop.length
  def initialize(pop)
    unless Parameters.initial_pop_size >= 0
      raise AssertionError.new, 'negative initial population'
    end

    @mothers_count = 0
    @nrr = 0.0
    @individuals = pop
    @couples = make_couples
    @offsprings = make_offsprings
  end

  # Sets the net reproduction rate for the this generation and the given one.
  def compute_nrr(off_gen)
    return if individuals.empty? || off_gen.individuals.empty?

    @nrr = (off_gen.mothers_count / @mothers_count.to_f)
           .round(Parameters::FLOAT_PRECISION)
  end

  # Displays formatted details about this generation.
  def formatted_infos
    fw = Parameters::FORMAT_WIDTH
    fp = Parameters::FLOAT_PRECISION
    format("%#{fw}.#{fp}d%#{fw}.#{fp}f%#{fw}.#{fp}f%#{fw}.#{fp}f%#{fw}.#{fp}f",
           @individuals.length, sex_percentage(:male), sex_percentage(:female),
           avg_offsprings, @nrr)
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
      unless cpl.offsprings.empty?
        offsprings << cpl.offsprings
        @mothers_count += 1
      end
    end
    offsprings.flatten
  end

  # Returns the average number of offsprings per couples in this generation.
  # @post
  #   0.0 <= result <= Parameters.max_offsprings
  def avg_offsprings
    return 0.0 if @couples.empty?

    (@offsprings.length / @couples.length.to_f)
      .round(Parameters::FLOAT_PRECISION)
  end

  # Returns the percentage of individuals of the given sex in this generation.
  # @pre
  #   Individual::SEXES.include?(sex)
  # @post
  #   0.0 <= result <= 100.0
  def sex_percentage(sex)
    return 0.0 if @individuals.empty?

    tot = @individuals.select { |i| i.sex == sex }.length
    (tot / @individuals.length.to_f * 100).round(Parameters::FLOAT_PRECISION)
  end
end
