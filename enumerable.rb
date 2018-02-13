module Enumerable
  # monkey patch the Ruby Enumerable module
  def sum
    self.inject(:+)
  end

  def mean
    if self.empty?
      raise ArgumentError.new('Cannot find the mean of 0 elements')
    end
    self.sum / self.length.to_f
  end

  def median
    if self.empty?
      raise ArgumentError.new('Cannot find the median of 0 elements')
    end

    sorted = self.sort

    if self.length % 2 != 0
      return sorted[self.length / 2.0]
    else
      return (sorted[self.length / 2.0] + sorted[(self.length / 2.0) - 1]) / 2.0
    end
  end

end
