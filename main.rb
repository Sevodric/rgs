# frozen_string_literal: true

require_relative 'individual.rb'

def breed_with_fpm(indiv, pop)
  fpm = pop.select { |p| p.compatible?(indiv) }
  indiv.breed(fpm.sample) unless fpm.empty?
end

def match(pop)
  pop.map { |indiv| breed_with_fpm(indiv, pop) }
end

INITIAL_POP = Array.new(5) { Individual.new(Individual::SEXES.sample) }

puts(INITIAL_POP.inspect)
puts(match(INITIAL_POP).inspect)
