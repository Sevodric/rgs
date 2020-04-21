#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require_relative 'src/simulation.rb'
require_relative 'src/parameters.rb'

RESULTS_DIR = File.join('results')

# Ensures the top level results/raw directory does exist.
FileUtils.mkdir_p(RESULTS_DIR) unless Dir.exist?(RESULTS_DIR)

# Creates the directory for this serie of simulations
time = Time.new
sim_dir_id = "#{time.year}-#{time.month}-#{time.day}_#{time.hour}#{time.min}" \
             "#{time.sec}"
@sim_dir = File.join(RESULTS_DIR, sim_dir_id, 'raw')
FileUtils.mkdir_p(@sim_dir)

@discrim = 1 # In case of multiple even simulations

# Starts a new simulation with the current parameters and creates the associated
#   CSV file in the simulation directory.
def make_results
  start_time = Time.new
  file_name = "result_#{Parameters.duration}_#{Parameters.initial_pop_size}_" \
             "#{Parameters.max_offsprings}"
  if File.exist?(File.join(@sim_dir, file_name + '.csv'))
    file_name += "_#{@discrim}"
    @discrim += 1
  end
  file_path = File.join(@sim_dir, file_name + '.csv')
  print("#{file_path}...")
  Simulation.new.to_csv(file_path)
  puts(" done (#{(Time.new - start_time).round(2)}s)")
end

puts("[INFO] Generating simulations results...")
@start_time = Time.new
@total_sim = 0

# --- PUT YOUR SIMULATIONS HERE ------------------------------------------------

Parameters.duration = 15
Parameters.initial_pop_size = 10000
(3..5).each do |max_off|
 Parameters.max_offsprings = max_off
 make_results
 @total_sim += 1
end

# Parameters.duration = 20
# Parameters.initial_pop_size = 15
# Parameters.max_offsprings = 4
# 20.times do 
#   make_results
#   @total_sim += 1
# end

# ------------------------------------------------------------------------------

puts("#{@total_sim} simulations done (#{(Time.new - @start_time).round(2)}s)")
