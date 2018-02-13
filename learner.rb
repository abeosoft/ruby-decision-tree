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

  def query

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
    # puts "LAST"
    # puts transposed.last
    # puts "data"
    # puts data[0]
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
    root = [[-1, transposed.last.mean, 1, left_tree.length]]
    # return root node + left tree + right tree to recursively make a tree
    root.concat(left_tree).concat(right_tree)
  end

  def query_help
  end

end
