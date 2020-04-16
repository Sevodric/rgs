# frozen_string_literal: true

require './util/assertion_error.rb'

# An individual, either male or female.
# @inv  SEXES.includes?(sex)
#       paired? == (couple != nil)
class Individual
  attr_reader :sex, :couple
  attr_writer :couple

  SEXES = %i[male female].freeze

  # A new individual with the given sex.
  # @pre  SEXES.includes?(sex)
  # @post sex == sex
  #       && couple.nil?
  def initialize(sex)
    raise AssertionError, 'Invalid sex' unless SEXES.include?(sex)

    @sex = sex
    @couple = nil
  end

  # Checks if this individual forms a couple with another one.
  def paired?
    @couple != nil
  end

  # Checks if this indivual is compatible with another one.
  def compatible?(ind)
    ind.is_a?(Individual) && ind.sex != @sex && !paired? && !ind.paired?
  end

  # Returns a human readable string representation of this individual.
  def describe
    "#{self} sex:#{sex} paired?:#{paired?} couple:#{couple}"
  end
end
