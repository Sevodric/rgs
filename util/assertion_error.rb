# frozen_string_literal: true

# An error indicating the violation of a contract.
class AssertionError < StandardError
  def initialize(msg = '')
    super
  end
end
