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
@total_sim = 0

# Creates a CSV file named after the current parameters of the simulation.
def make_csv_file
  file_name = "result_#{Parameters.duration}_#{Parameters.initial_pop_size}_" \
             "#{Parameters.max_offsprings}"
  if File.exist?(File.join(@sim_dir, file_name + '.csv'))
    file_name += "_#{@discrim}"
    @discrim += 1
  end
  File.join(@sim_dir, file_name + '.csv')
end

# Starts a new simulation with the current parameters and creates the associated
#   CSV file in the simulation directory.
def make_results(duration, initial_pop_size, max_offsprings)
  Parameters.duration = duration
  Parameters.initial_pop_size = initial_pop_size
  Parameters.max_offsprings = max_offsprings
  start_time = Time.new
  file_path = make_csv_file
  print("#{file_path}...")
  Simulation.new.to_csv(file_path)
  puts(" done (#{(Time.new - start_time).round(2)}s)")
  @total_sim += 1
end

puts('[INFO] Generating simulations results...')
@start_time = Time.new

# --- PUT YOUR SIMULATIONS HERE ------------------------------------------------

50.times { make_results(20, 10, 4) }

# ------------------------------------------------------------------------------

puts("#{@total_sim} simulations done (#{(Time.new - @start_time).round(2)}s)")
