# frozen_string_literal: true

require './individual.rb'
require './couple.rb'

x = Individual.new(:male)
y = Individual.new(:female)

c = Couple.new(x, y)
c.breed
puts(c.inspect)
