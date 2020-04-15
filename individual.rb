# frozen_string_literal: true

require_relative 'assertion_error.rb'

# An individual that can reproduce with another individual of the opposite sex.
# @inv
#     SEXES.include?(@sex)
#     && 0 <= @progeny.length <= MAX_PROGENY
#     && self.compatible?(x) <==> ((@mate == x.mate.nil?) && @sex != x.sex)
#     && self.compatible?(x) <==> x.compatible(self)
class Individual
  attr_reader :sex, :mate, :progeny
  attr_writer :mate, :progeny

  MAX_PROGENY = 2
  SEXES = %i[female male].freeze

  # A new individual with the given sex.
  # @pre
  #     SEXES.include?(sex)
  # @post
  #     @sex == sex
  #     && @mate.nil?
  #     && @progeny.length == 0
  def initialize(sex)
    raise AssertionError.new, 'Unknown sex' unless SEXES.include?(sex)

    @sex = sex
    @mate = nil
    @progeny = []
  end

  # Forms a couple with another individual and give birth to MAX_PROGENY new
  # individuals.
  # @pre
  #     self.compatible?(indiv)
  # @post
  #     @mate == indiv && indiv.mate == self
  #     && @progeny.each { |p| p.is_a?(Individual) }
  #     && @progeny.length == MAX_PROGENY && indiv.progeny == @progeny
  def breed(indiv)
    raise AssertionError.new, 'Incompatible mate' unless compatible?(indiv)

    @mate = indiv
    MAX_PROGENY.times { @progeny << Individual.new(SEXES.sample) }
    indiv.mate = self
    indiv.progeny = @progeny
  end

  # Checks if self is compatible for mating with indiv.
  # @pre
  #     indiv.is_a?(Individual)
  def compatible?(indiv)
    raise AssertionError.new, 'Not an Individual' unless indiv.is_a?(Individual)

    @mate.nil? && indiv.mate.nil? && indiv.sex != @sex
  end
end
