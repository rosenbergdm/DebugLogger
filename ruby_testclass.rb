#!/usr/bin/env ruby
# encoding: utf-8
# ruby_testclass.rb

require "ruby_logger"

class TestMe
  include DebugLogger
  
  def initialize(logfile, log_flags=[])
    @nums   = [1,1,2,3,5]
    @primes = []
    @max_prime = 1000

    log_init(logfile, log_flags)
  end

  def count_nums
    log_depth_inc
    log_mesg("Counting nums", :Debug)
    
    log_depth_dec
    return @nums.length
  end

  def add_prime(n)
    log_depth_inc
    log_mesg("Attempting to add #{n.to_s}")
    if is_prime(n)
      @primes << n
      log_mesg("Adding #{n.to_s}", :Warning)
    else
      log_mesg("Not adding #{n.to_s}", :Warning)
    end
    log_depth_dec
  end

  def is_prime(n)
    log_depth_inc
    log_mesg("Determining if #{n.to_s} is prime", :Debug)
    res = nil
    if [1,2,3,5,7,9,11,13,17,19,21,23].member? n
      res = 1
      log_mesg("It is")
    else
      log_mesg("It is not")
      res = nil
    end
    log_depth_dec
    return res
  end

end
