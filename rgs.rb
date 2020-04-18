# frozen_string_literal: true

require './simulation.rb'
require './parameters.rb'

if ARGV.length < 3
  puts('Missing arguments')
  exit
end

Parameters.duration = ARGV[0].to_i
Parameters.initial_pop_size = ARGV[1].to_i
Parameters.max_offsprings = ARGV[2].to_i

unless Parameters.valid?
  raise AssertionError.new, 'invalid simulation parameters'
end

Simulation.new.start
