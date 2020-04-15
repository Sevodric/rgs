# frozen_string_literal: true

require './util/assertion_error.rb'

# An individual, either male or female.
# @inv  SEXES.includes?(sex)
class Individual
  attr_reader :sex

  SEXES = %i[male female].freeze

  # A new individual with the given sex.
  # @pre  SEXES.includes?(sex)
  # @post sex == sex
  def initialize(sex)
    raise AssertionError, 'Invalid sex' unless SEXES.include?(sex)

    @sex = sex
  end

  # Checks if this indivual is biologically compatible with another one.
  def compatible?(ind)
    ind.is_a?(Individual) && ind.sex != @sex
  end
end
