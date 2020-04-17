# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'

# A generation of individuals forming couples.
# @inv  
class Generation
  attr_reader :offsprings, :individuals
  attr_accessor :nnr

  def self.compute_nnr(parent_gen, off_gen)
    if parent_gen.individuals.empty? || off_gen.individuals.empty?
      0
    else
      tot_mothers = 0
      parent_gen.individuals.each do |i|
        tot_mothers += 1 if i.paired? && i.sex == :female
      end
      tot_daughters = 0
      off_gen.individuals.each do |i|
        tot_daughters += 1 if i.paired? && i.sex == :female
      end
      (tot_daughters / tot_mothers.to_f).round(1)
    end
  end

  def initialize(pop)
    @individuals = pop
    @couples = make_couples
    @offsprings = make_offsprings
    @avg_offsprings = compute_avg_offsprings
    @male_percentage = compute_sex_percentage(:male)
    @female_percentage = compute_sex_percentage(:female)
    @nrr = -1
  end

  def display_details
    puts("#{@individuals.length}\t#{@couples.length}\t#{@offsprings.length}\t"\
        "#{@avg_offsprings}\t#{@male_percentage}|#{@female_percentage}\t" \
        "#{@nnr}")
  end

  private

  def make_couples
    couples = []
    @individuals.each do |ind|
      mate = @individuals.select { |i| i.compatible?(ind) }.first
      couples.push(Couple.new(ind, mate)) unless mate.nil?
    end
    couples
  end

  def make_offsprings
    offsprings = []
    @couples.each do |cpl|
      cpl.breed
      cpl.offsprings.each { |off| offsprings << off }
    end
    offsprings
  end

  def compute_avg_offsprings
    if @couples.empty?
      0
    else
      (@offsprings.length / @couples.length.to_f).round(1)
    end
  end

  def compute_sex_percentage(sex)
    if @individuals.empty?
      0
    else
      tot = 0
      @individuals.each { |i| tot += 1 if i.sex == sex }
      (tot / @individuals.length.to_f * 100).round
    end
  end
end
