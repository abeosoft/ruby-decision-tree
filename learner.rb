require_relative 'enumerable'

class Learner

  attr_reader :model

  def initialize(leaf_size = 1)
    @leaf_size = leaf_size
    @model
  end

  # Takes a 2d array data
  def build_model(data)
    @model = build_tree(data)
  end

  # Takes a 2d array of data
  def query(points)
    answers = []
    points.each do |point|
      answers.concat([query_helper(point)])
    end
    answers
  end

  private

  def select_rows(data, split_index, split_val, side)
    data.select do |row|
      if side == 'left'
        row[split_index] <= split_val
      else
        row[split_index] > split_val
      end
    end
  end

  # each row = [node, factor, split_val, left, right]
  # build a random decision tree
  def build_tree(data)
    transposed = data.transpose

    if data.length <= @leaf_size ||
      transposed.last.all? { |y| y == transposed.last[0] }
      return [[-1, transposed.last.mean, -1, -1]]
    end

    # pick a random feature index
    split_index = rand(transposed.length - 1)
    split_val = transposed[split_index].median

    # prevent a bad split
    if split_val == transposed[split_index].min ||
      split_val == transposed[split_index].max

      split_val = transposed[split_index].mean
    end

    if select_rows(data, split_index, split_val, "left").empty? ||
      select_rows(data, split_index, split_val, "right").empty?

      # return a leaf if one side would be empty
      return [[-1, transposed.last.mean, -1, -1]]
    end

    left_tree = build_tree(select_rows(data, split_index, split_val, "left"))
    right_tree = build_tree(select_rows(data, split_index, split_val, "right"))
    root = [[split_index, split_val, 1, left_tree.length]]
    # return root node + left tree + right tree to recursively make a tree
    root.concat(left_tree).concat(right_tree)
  end

  def query_helper(point)
    row = 0
    loop do
      row = Integer(row)
      if @model[row][0] == -1
        return @model[row][1]
      elsif point[@model[row][0]] <= @model[row][1]
        # puts 'left'
        row += @model[row][2]
      else
        # puts 'right'
        row += @model[row][3]
      end
    end
  end

# class end
end
