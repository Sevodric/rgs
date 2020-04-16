# frozen_string_literal: true

require './simulation.rb'

if ARGV.length < 3
  puts('Missing arguments')
  exit
end

DURATION = ARGV[0].to_i
INITIAL_POP_NUMBER = ARGV[1].to_i
MAX_PROGENY = ARGV[2].to_i

Simulation.new(INITIAL_POP_NUMBER, MAX_PROGENY, DURATION).start
