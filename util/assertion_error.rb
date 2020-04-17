# frozen_string_literal: true

# An error indicating the violation of a contract.
class AssertionError < ArgumentError
  def initialize(msg = '')
    if msg.empty?
      super('precondition violation')
    else
      super('precondition violation (' + msg + ')')
    end
  end
end
