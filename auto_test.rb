# frozen_string_literal: true

require './src/simulation.rb'
require './src/parameters.rb'

@results_dir = 'results'
@simul_dir = File.join(@results_dir, 'default')

# Creates, in the results directory, a new directory whose name starts with the
#   optional given discriminant followed by the current date and time.
def make_dir(dis = '')
  time = Time.new
  @simul_dir = "#{dis}#{time.year}-#{time.month}-#{time.day}_" \
              "#{time.hour}#{time.min}#{time.sec}"
  Dir.mkdir(File.join(@results_dir, @simul_dir))
end

# Starts a new simulation with the current parameters and creates the associated
#   CSV file in the current simulation directory.
def make_results
  start_time = Time.new.to_i
  filename = "result_#{Parameters.duration}_#{Parameters.initial_pop_size}_" \
             "#{Parameters.max_offsprings}.csv"
  path = File.join(@results_dir, @simul_dir, filename)
  print("#{path}...")
  Simulation.new.to_csv(path)
  puts(" done (#{Time.new.to_i - start_time}s)")
end

puts('[INFO] Generating simulations results...')
@g_start_time = Time.new.to_i
@total_sim = 0

# initial_pop_size (100..1000).step(100)
# max_offsprings = 4
Parameters.duration = 15
Parameters.max_offsprings = 4
make_dir
(100..1000).step(100).each do |ips|
  (3..6).each do |max_off|
    Parameters.initial_pop_size = ips
    Parameters.max_offsprings = max_off
    make_results
    @total_sim += 1
  end
end

puts("#{@total_sim} simulations done (#{Time.new.to_i - @g_start_time}s)")
