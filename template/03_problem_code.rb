# Hello there! Feel free to scroll down to the interesting part!
# (You should recognize it)

# Usage:
# cat input_file.in | ruby this_file.rb
#
# Customize used algorithm with:
#
# cat XX_input_file.in | ALGO=2 ruby XX_this_file.rb
#
# Or use Guard to automatically benchmark all algorithms each time the file is saved:
# (must be in the root directory)
#
# bundle install
# bundle exec guard start -i

# TL;DR: You can jump to the `class Runner < BaseRunner` definition below
# and start hacking by filling the FIXME and removing the `raise`!

# Namespacing your helper methods (defined later in this file).
module Helpers; end
# Namespacing helpers to parse STDING (defined later in this file).
module ParseInput; end

# Namespacing your helper methods (defined later in this file).
module Helpers; end

# Internal: The base class that will run the test cases provided as input and output the formated solution.
# It also defines some class methods to customize the behavior of the inherited Runner
# (see the Runner class below).
# NOTE: You should not have to edit this Class.
class BaseRunner
  include ParseInput
  include Helpers

  class << self
    # Public: Integer index of the algo to use when the env variable ALGO is not set.
    # Runner.new.run will call the "algo_#{i}" method.
    def default_algo(i=nil); i ? @@default_algo = i : @@default_algo || 1; end

    # Public: Integer number of seconds than Guard should wait while benchmarking an algorithm
    # (used only when auto benchmarking locally to prevent loosing time).
    def bench_timeout(bt=nil); bt ? @@bench_timeout = bt : @@bench_timeout; end

    # Internal: Integer number of seconds to wait before timeouting an algorithm
    # (used ONLY by Guard while benchmarking various algorithms).
    def algos; instance_methods.grep(/algo_[0-9]+/); end
  end

  # Internal: Iterate through test cases using a specific algorithm.
  #
  # algo    - The Integer index of the algo to run (default: BaseRunner.default_algo).
  #           The method used is guessed to be `algo_#{i}`
  # options - The Hash options used to customize the output (default: {}):
  def run(algo = nil, options = {})
    if algo.nil? || algo.empty?
      algo = self.class.default_algo
    end
    method = "algo_#{algo}"

    @tests.each_with_index{ |test_case, i| format(send(method, test_case), options.merge(index: i)) }
  end

  # Public: Format and output the return value of an algorithm.
  # Feel free to override this method in the inherited Class.
  #
  # value   - The return value of an `algo_#{i}` method.
  # options - The Hash options used to format the value (default: {index: i}):
  #           :index - The Integer index of the test case (in the `@tests` Array)
  #                    that produced the value (automatically merged in BaseRunner#run).
  def format(value, options)
    puts response.to_s
  end
end



#######################################
#                                     #
# This is where the fun stuff begin ! #
#                                     #
#######################################

# Uncomment to enable debugging.
# require 'pry'

# Define problem constants here (if any).
# Example:
#
# Public: Integer modulo specified in the problem.
# MOD = 1000000007

# Some helper methods to parse STDIN.
# You can add your own here if needed.
module ParseInput
  # Public: Read a line and return the String.
  def readln; STDIN.readline; end

  # Public: Read a line and return an Array of Integers.
  def readln_int_a; readln.split(' ').map(&:to_i); end

  # Public: Read a line and return a single Integer.
  def readln_int; readln.to_i; end
end

# You can define some helpers here (like tree implementation, mathematical
# helpers etc...) that you'll use in your algorithms.
# (This module will be included in your Runner class)
module Helpers
  # Example:
  # Dynamically compute and memoize binominal coefficients
  # def binominal_coef(max_n)
  #   ...
  # end
end

# Implement one or more algorithms to solve the problem as methods of this class.
# Name the method(s) like this: "algo_#{i}", where `i` is an Integer starting from 1.
# Guard will then benchmark all your algorithms through the provided input file.
class Runner < BaseRunner
  bench_timeout 10 # timeout in seconds (only used by Guard when benchmarking various algorithms).
  default_algo  1  # unless provided by the ENV['ALGO'] variable, use the `algo_#{default_algo}` method.

  # Public: Parse test cases from input and put them in the `@tests` Array.
  # Each test should be an Hash defining the arguments for the test case.
  # FIXME: Parse input, add test cases to `@tests` and remove the raise!
  def parse_input
    @tests = []
    # Example:
    # num_tests = readln_int

    # num_tests.times do |test_case|
    #   t = {}
    #   Example:
    #   t[:speed], t[:wind] = readln_int_a
    #   t[:waves] = readln_int_a
    #
    #   @tests << t
    # end

    raise "Implements me to parse input!"
  end

  # Compute the solution of a test case.
  #
  # t - the Hash containing inputs for the test_case.
  #
  # Returns the solution for the test case.
  # FIXME: Implement at least an algoritm and return the solution for an input test case!
  def algo_1(t)
    # Example:
    # speed, wind, waves = t[:speed], t[:wind], t[:waves]

    # resp = waves.inject(0){|m, wave| m + speed - wind - wavw} % MOD
    # return resp

    raise "Implements at least an algorithm to solve the problem!"
  end

  # You can other algorithms if you want!
  # def algo_2(t)
  # end

  # Public: Format and output the return value of an algorithm.
  #
  # value   - The return value of an `algo_#{i}` method.
  # options - The Hash options used to format the value (default: {index: i}):
  #           :index - The Integer index of the test case (in the `@tests` Array)
  #                    that produced the value (automatically merged in BaseRunner#run).
  # FIXME: Format the output value!.
  def format(value, options = {})
    # Example:
    # puts "Case ##{options[:index]}: #{value}"
    raise "Format the output value!"
  end
end

# Run everything (or introspect options for Guards)
# You should not have to edit this!
if ENV['QUERY_OPTIONS']
  puts "#{Runner.algos.size} #{Runner.bench_timeout}"
  exit 0
else
  r = Runner.new
  r.parse_input
  r.run(ENV['ALGO'])
end
