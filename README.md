# Ruby Random Decision Tree

A Ruby implementation of Dr. Adele Cutler's random decision tree algorithm.
The repository includes a dataset on abalone age from the UCI Machine Learning Repository http://archive.ics.uci.edu/ml/datasets/Abalone for testing.

## Instructions for use:
- Clone or download
- In the terminal, run `ruby test_learner.rb [path to csv file] [leaf size]`
  - example using the included data: `ruby test_learner.rb './data/abalone.csv' 10`
- The test script will print the in sample and out of sample correlation and RMSE between actual and predicted values.

## Tree Representation Notes:
- The random tree is represented in a 2d array
  - Each row in the array represents a node in the tree:
  `[factor, split value, left tree start index, right tree start index]`
- leaf_size: The point at which to average remaining data into a leaf. Larger leaf_size results in less overfitting.
