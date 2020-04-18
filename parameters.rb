# frozen_string_literal: true

# The parameters of the simulation
module Parameters
  FORMAT_WIDTH = 10
  FLOAT_PRECISION = 3

  class << self
    attr_accessor :duration, :initial_pop_size, :max_offsprings

    # Cheks if all the parameters are valid for the simulation.
    def valid?
      duration >= 0 && initial_pop_size >= 0 && max_offsprings >= 0
    end
  end
end
