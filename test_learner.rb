require_relative 'learner'

# script to test a learner with data

# helper methods

def rmse(testY, predictedY)
  # calculate the root mean square error
  # takes two arrays
  err = testY.subtract(predictedY)
  rmse = Math.sqrt(err.sum_of_squares / Float(testY.length))
  rmse
end

def corr(testY, predictedY)
  # calculate the Pearson correlation coefficient
  # formula from http://www.stat.wmich.edu/s216/book/node122.html
  numerator = predictedY.multiply(testY).sum - ((predictedY.sum * testY.sum)/Float(testY.length))

  test_denom = testY.sum_of_squares - ((testY.sum ** 2) / Float(testY.length))
  pred_denom = predictedY.sum_of_squares - ((predictedY.sum ** 2) / Float(predictedY.length))
  denominator = Math.sqrt(test_denom * pred_denom)

  corr_coeff = numerator / denominator
  corr_coeff
end

# terminal command to test:
# ruby test_learner '[./datafile]' leaf_size
# example: ruby test_learner.rb './data/abalone.csv' 10
if $PROGRAM_NAME == __FILE__
  filename = ARGV[0]
  rows = File.readlines(filename).map(&:chomp)
  data = rows.map do |row|
    nums = row.split(",").map do |char|
      if char =~ /[A-Za-z]/
        # make letter code into float
        Float(char.sum / 100.0)
      else
        Float(char)
      end
    end
  end

  # test the corr method
  # should be .866
  # x = [1, 3, 4, 4]
  # y = [2, 5, 5, 8]
  # puts corr(x, y)

  train_data = data[0...(data.length*0.4)]
  test_data = data[data.length*0.4...data.length]

  if ARGV[1]
    learner = Learner.new(leaf_size = Integer(ARGV[1]), train_data)
    puts ARGV[1]
  else
    learner = Learner.new(train_data)
  end

  trainY = learner.query(train_data)
  trainY_predicted = train_data.transpose.last

  testY = learner.query(test_data)
  testY_predicted = test_data.transpose.last
  puts 'RMSE in sample:'
  puts rmse(testY, testY_predicted)
  puts 'Correlation Coefficient in sample:'
  puts corr(testY, testY_predicted)


  puts 'RMSE out of sample:'
  puts rmse(trainY, train_data.transpose.last)
  puts 'Correlation Coefficient in sample:'
  puts corr(trainY, trainY_predicted)

end
