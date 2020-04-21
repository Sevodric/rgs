#!/usr/bin/env python3

import sys
import time
import numpy as np
import matplotlib.pyplot as plt

from pathlib import Path

# Exit if no argument is given
if len(sys.argv) < 2:
    print('[ERROR] No directory to analyze')
    exit()

# Columns numbers in CSV files
cols = {'gen': 0, 'pop': 1, 'male': 2, 'female': 3, 'avg_off': 4, 'nrr': 4}

sim_dir = Path(sys.argv[1])

# The directory containing all the CSV
sim_raw_dir = Path(sim_dir / 'raw')

# The directory in which will be put the graphs
sim_graph_dir = Path(sim_dir / 'graph')
Path.mkdir(sim_graph_dir)

print('[INFO] Creating graphs from CSV...')
g_start_time = time.time()
total_graphs = 0

for file in sim_raw_dir.iterdir():
    if not file.suffix != 'csv':
        print('[ERROR] Not a CSV file')
        continue

    print(str(sim_graph_dir / (file.stem + '.png')) + '...', end='')
    start_time = time.time()
    result = np.loadtxt(file, delimiter=',')

    params = file.stem.split('_')
    title = ('Evolution of a population on ' + params[1] + ' generations '
            '(initial pop: ' + params[2] + ', max offsprings: ' +
            params[3] + ')')

    # Main figure
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(nrows=2, ncols=2,
            figsize=(12, 9))
    fig.suptitle(title)
    # X axis
    x = result[:, cols['gen']]

    # Population axis
    ax1.bar(x, result[:, cols['pop']], label='pop', color='tab:purple')
    ax1.xaxis.set_ticks(result[:, cols['gen']])
    ax1.set_ylabel('Number of individuals')
    ax1.set_xlabel('Generation')
    ax1.legend(loc='upper right')
    ax1.grid(alpha=0.3)

    # Sex repartition axis
    ax2.bar(x, result[:, cols['male']], label='male %', color='tab:blue')
    ax2.bar(x, result[:, cols['female']], bottom=result[:, cols['male']],
            label='female %', color='tab:red')
    ax2.xaxis.set_ticks(result[:, cols['gen']])
    ax2.set_ylabel('Sex distribution')
    ax2.set_xlabel('Generation')
    ax2.legend(loc='upper right')

    # Average offsprings axis
    ax3.bar(x, result[:, cols['avg_off']], label='avg off', color='tab:green')
    ax3.xaxis.set_ticks(result[:, cols['gen']])
    ax3.set_ylabel('Average number of offsprings')
    ax3.set_xlabel('Generation')
    ax3.legend(loc='upper right')
    ax3.grid(alpha=0.3)

    # NRR axis
    x = result[:14, cols['gen']]
    ax4.step(x, result[0:14, cols['nrr']], label='nrr', color='tab:orange')
    ax4.xaxis.set_ticks(result[:, cols['gen']])
    ax4.set_ylabel('NRR')
    ax4.set_xlabel('Generation')
    ax4.legend(loc='upper right')
    ax4.grid(alpha=0.3)

    # Save the fig as a png and exit
    fig.savefig(sim_graph_dir / (file.stem + '.png'))
    plt.close(fig)
    total_graphs += 1
    print(' done (' + str(round(time.time() - start_time, 2)) + 's)')

print(str(total_graphs) + ' graphs created (' +
        str(round(time.time() - g_start_time, 2)) + 's)')
