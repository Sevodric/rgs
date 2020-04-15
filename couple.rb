# frozen_string_literal: true

require './individual.rb'

# A couple of two individuals that can reproduce.
# @inv  members.length == 2 && members.each { |m| m.is_a?(Individual) }
#       && 0 <= progeny.length <= MAX_PROGENY
#       && progeny.each { |p| p.is_a?(Individual) }
class Couple
  attr_reader :members, :progeny

  MAX_PROGENY = 2

  # A new couple formed of two indivuals.
  # @pre  ind_a.compatible?(ind_b)
  # @post members.include(ind_a) && members.include?(ind_b)
  #       && progeny.length == 0
  def initialize(ind_a, ind_b)
    @members = [ind_a, ind_b]
    @progeny = []
  end

  # Makes the couple reproduce.
  #
  # Offsprings' sex are determined randomly.
  # @post progeny.length == MAX_PROGENY
  def breed
    MAX_PROGENY.times { @progeny << Individual.new(Individual::SEXES.sample) }
  end
end
