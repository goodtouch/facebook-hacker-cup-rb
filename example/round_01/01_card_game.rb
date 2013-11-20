# Hello! Feel free to scroll down to the interesting part to start hacking (you should recognize it)!

# Namespacing your helper methods (defined later in this file).
module Helpers; end
# Namespacing helpers to parse STDING (defined later in this file).
module ParseInput; end

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

# Problem constants (if any).
MOD = 1000000007

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
  # Memoize binominal coefficients
  def binominal_coef(max_n)
    @bin ||= []
    @bin[0] ||= []
    @bin[0][0] = 1
    1.upto(max_n) do |n|
      @bin[n] ||= []
      @bin[n][0] = 1
      @bin[n][n] = 1
      1.upto(n-1) do |k|
        @bin[n][k] ||= @bin[n-1][k] + @bin[n-1][k-1]
        if @bin[n][k] >= MOD
          @bin[n][k] -= MOD
        end
      end
    end
  end
end

# Implement one or more algorithms to solve the problem as methods of this class.
# Name the method(s) like this: "algo_#{i}", where `i` is an Integer starting from 1.
# Guard will then benchmark all your algorithms through the provided input file.
class Runner < BaseRunner
  bench_timeout 3  # timeout in seconds (only used by Guard when benchmarking various algorithms).
  default_algo  2  # unless provided by the ENV['ALGO'] variable, use the `algo_#{default_algo}` method.

  # Public: Parse test cases from input and put them in the `@tests` Array.
  # Each test should be an Hash defining inputs for the test case.
  def parse_input
    num_tests = readln_int
    @tests = []

    num_tests.times do |test_case|
      t = {}
      t[:n], t[:k] = readln_int_a
      t[:a] = readln_int_a
      @tests << t
    end
  end

  # Compute the solution of a test case.
  #
  # t - the Hash containing inputs for the test_case.
  #
  # Returns the solution for the test case.
  #
  # Naive algo.
  def algo_1(t)
    n, k, a = t[:n], t[:k], t[:a]

    resp = a.combination(k).inject(0){|m, e| m + e.max} % MOD
    return resp
  end

  # Reduced complexity: Don't compute all combinations.
  # Warm up a cache of binominal coefficients and use it to compute the number of time each interesting value appears.
  def algo_2(t)
    n, k, a = t[:n], t[:k], t[:a]

    binominal_coef(n)
    a.sort!
    resp = 0
    ((k-1)..(n-1)).each do |i|
      resp += (a[i] % MOD) * @bin[i][k-1]
      resp = resp % MOD
    end
    return resp
  end

  # Public: Format and output the return value of an algorithm.
  #
  # value   - The return value of an `algo_#{i}` method.
  # options - The Hash options used to format the value (default: {index: i}):
  #           :index - The Integer index of the test case (in the `@tests` Array)
  #                    that produced the value (automatically merged in BaseRunner#run).
  def format(value, opts = {})
    if opts[:index]
      puts "Case ##{opts[:index]+1}: #{value}"
    else
      super
    end
  end
end

if ENV['QUERY_OPTIONS']
  puts "#{Runner.algos.size} #{Runner.bench_timeout}"
  exit 0
else
  r = Runner.new
  r.parse_input
  r.run(ENV['ALGO'])
end
