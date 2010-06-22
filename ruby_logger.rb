#!/usr/bin/env ruby
# encoding: utf-8
# ruby_logger.rb


class LoggerException < StandardError
end

class LoggerDepthException < LoggerException
end


module DebugLogger
  attr :log_depth
  attr :log_logfile
  attr :log_flags
  attr :log_stream
  
  def log_init(logfile=nil, logflags=[])
    @log_depth   = 0
    @log_logfile = logfile
    @log_flags   = []
    if logflags.member? :Log
      @log_flags << :Log
    end
    if logflags.member? :Debug
      @log_flags << :Debug
    end
    @log_stream  = nil

  end

  def log_depth_inc
    @log_depth += 1
  end

  def log_depth_dec
    if @log_depth > 0
      @log_depth -= 1
    else
      raise(LoggerDepthException, "Cannot decrease log depth below zero")
    end
  end

  def log_openstream
    if !(@log_flags.member? :StreamOpen)
      @log_stream = File.open(@log_logfile, "a")
      @log_flags << :StreamOpen
    else
      log_mesg('Attempting to open already open logstream', :Warning)
    end
  end

  def log_closestream
    if @log_flags.member? :StreamOpen
      @log_stream.close
      @log_stream = nil
      @log_flags.delete :StreamOpen
    else
      log_mesg('Attempting to close an unopened or already closed logstream', :Warning)
    end
  end

  def log_mesg(mesg, level=:Debug)
    mesg_content = ""
    for ii in 1..@log_depth
      mesg_content += "  "
    end

    mesg_content += (level.to_s + ": " + mesg)

    if @log_flags.member? :Debug
      puts mesg_content
    end

    if @log_flags.member? :Log
      if @log_flags.member? :StreamOpen
        @log_stream.puts mesg_content
      else
        log_openstream
        @log_stream.puts mesg_content
        log_closestream
      end
    end
  end
end
