# frozen_string_literal: true

require './util/assertion_error'
require './individual.rb'
require './couple.rb'

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
  pop.each do |p1|
    pop.each do |p2|
      if p1.compatible?(p2)
        couples.push(Couple.new(p1, p2, MAX_PROGENY))
        break
      end
    end
  end
  couples
end

if ARGV.length < 3
  puts('Missing arguments')
  exit
end

INITIAL_POPULATION = Array.new(ARGV[0].to_i) do
  Individual.new(Individual::SEXES.sample)
end
MAX_PROGENY = ARGV[1].to_i
NUMBER_OF_GENERATION = ARGV[2].to_i

generations = { 1 => INITIAL_POPULATION }

(1...NUMBER_OF_GENERATION).each do |i|
  couples = match(generations[i])
  new_generation = []
  couples.each do |c|
    c.breed
    c.progeny.each { |p| new_generation.push(p) }
  end
  generations.store(i + 1, new_generation)
end

generations.each do |gen, pop|
  puts("Population at gen #{gen}: #{pop.length}")
end
