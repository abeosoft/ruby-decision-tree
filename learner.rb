require_relative 'enumerable'

class Learner

  attr_reader :model

  # leaf_size is an Integer
  # data is a 2d array.
  # The last column of data is the label.
  # Columns other than the last column in data include factors
  # Each row in data represents a sample data point.
  def initialize(leaf_size = 1, data)
    @model = Learner.build_tree(leaf_size, data)
  end

  # Helper method for buid_tree
  # Selects data for the left or right side of a tree based
  # on comparison to a split value.
  def self.select_rows(data, split_index, split_val, side)
    data.select do |row|
      if side == 'left'
        row[split_index] <= split_val
      else
        row[split_index] > split_val
      end
    end
  end

  # Builds a random decision tree
  def self.build_tree(leaf_size, data)
    transposed = data.transpose

    # Stopping case: return a leaf.
    if data.length <= leaf_size ||
      transposed.last.all? { |y| y == transposed.last[0] }
      return [[-1, transposed.last.mean, -1, -1]]
    end

    # Pick a random factor index
    split_index = rand(transposed.length - 1)
    split_val = transposed[split_index].median

    # Prevent a split that would result in an empty left or empty right side.
    if split_val == transposed[split_index].min ||
      split_val == transposed[split_index].max

      split_val = transposed[split_index].mean
    end

    if select_rows(data, split_index, split_val, "left").empty? ||
      select_rows(data, split_index, split_val, "right").empty?

      # Return a leaf if the left or right side of the tree would be empty.
      return [[-1, transposed.last.mean, -1, -1]]
    end

    # Recursively create right and left trees.
    left_tree = self.build_tree(leaf_size, select_rows(data, split_index, split_val, "left"))
    right_tree = self.build_tree(leaf_size, select_rows(data, split_index, split_val, "right"))
    # Create a tree node that is the root of the trees created above.
    root = [[split_index, split_val, 1, left_tree.length + 1]]

    # Return root node + left tree + right tree to recursively build a tree
    root.concat(left_tree).concat(right_tree)
  end

  # A helper method for query
  # Given a sample point 'point', query a random tree (model) for
  # its predicted value.
  def query_helper(point)
    row = 0
    loop do
      row = Integer(row)
      # Stopping case: a leaf has been reached and the
      # predicted value is returned.
      if @model[row][0] == -1
        return @model[row][1]
      elsif point[@model[row][0]] <= @model[row][1]
        # Continue down the left side of the tree representation.
        row += @model[row][2]
      else
        # Continue down the right side.
        row += @model[row][3]
      end
    end
  end

  # points is a 2d array of factors,
  # in which each row is one data 'point' or sample.
  # Returns a 1d array of answers (predicted labels)
  def query(points)
    answers = []
    points.each do |point|
      answers.concat([query_helper(point)])
    end
    answers
  end

# learner end
end
