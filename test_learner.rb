require_relative 'learner'

# script to test a learner with data

# command to test: ruby test_learner.rb './data/abalone.csv'
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

  learner = Learner.new()
  learner.build_model(data)
  print learner.model

end
