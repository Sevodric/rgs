# frozen_string_literal: true

# The parameters of the simulation
module Parameters
  class << self
    attr_accessor :duration, :initial_pop_size, :max_offsprings

    # Cheks if all the parameters are valid for the simulation.
    def valid?
      duration >= 0 && initial_pop_size >= 0 && max_offsprings >= 0
    end
  end
end
