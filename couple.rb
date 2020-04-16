# frozen_string_literal: true

require './util/assertion_error.rb'
require './individual.rb'

# A couple of two individuals that can reproduce.
# @inv  members.length == 2 && members.each { |m| m.is_a?(Individual) }
#       && 0 <= progeny.length <= max_progeny
#       && progeny.each { |p| p.is_a?(Individual) }
class Couple
  attr_reader :members, :progeny, :max_progeny

  # A new couple formed by two indivuals.
  # @pre  ind_a.compatible?(ind_b)
  # @post members.include(ind_a) && members.include?(ind_b)
  #       && progeny.empty?
  #       && ind_a.paired? && ind_b.paired?
  def initialize(ind_a, ind_b, max_progeny)
    unless ind_a.compatible?(ind_b)
      raise AssertionError, 'Incompatible individuals'
    end

    @members = [ind_a, ind_b]
    @max_progeny = max_progeny
    @progeny = []
    ind_a.couple = self
    ind_b.couple = self
  end

  # Makes the couple reproduce.
  #
  # Offsprings' sex are determined randomly.
  # @post progeny.length == rand(0, max_progeny)
  def breed
    rand(0..@max_progeny).times do
      @progeny.push(Individual.new(Individual::SEXES.sample))
    end
  end
end
