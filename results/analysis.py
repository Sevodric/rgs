import sys
from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt

# Exit if no argument is given
if len(sys.argv) < 2:
    print('[ERROR] No directory')
    exit()

GRAPH_DIR = Path.cwd() / 'results' / 'graph'

if not Path.exists(GRAPH_DIR) or not Path.is_dir(GRAPH_DIR):
    Path.mkdir(GRAPH_DIR)

# Columns numbers in CSV files
GEN = 0
POP = 1
MALE = 2
FEMALE = 3
AVG_OFF = 4
NRR = 5

directory = Path(sys.argv[1])
Path.mkdir(GRAPH_DIR / directory.name)

for file in directory.iterdir():
    # Exit if the file in not a CSV file
    if not file.suffix != 'csv':
        print('[ERROR] Not a CSV file')
        exit()

    print('Creating ' + str(GRAPH_DIR / directory.name / (file.stem + '.png')) +
            '...')

    # Load the file
    result = np.loadtxt(file, delimiter=',')

    # Main figure
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(nrows=2, ncols=2,
            figsize=(12, 9))

    # X axis
    x = result[:, GEN]

    # Population axis
    ax1.bar(x, result[:, POP], label='pop', color='tab:purple')
    ax1.xaxis.set_ticks(result[:, GEN])
    ax1.set_ylabel('Number of individuals')
    ax1.set_xlabel('Generation')
    ax1.legend(loc='upper right')
    ax1.grid(alpha=0.3)

    # Sex repartition axis
    ax2.bar(x, result[:, MALE], label='male %', color='tab:blue')
    ax2.bar(x, result[:, FEMALE], bottom=result[:, MALE], label='female %',
            color='tab:red')
    ax2.xaxis.set_ticks(result[:, GEN])
    ax2.set_ylabel('Sex distribution')
    ax2.set_xlabel('Generation')
    ax2.legend(loc='upper right')

    # Average offsprings axis
    ax3.bar(x, result[:, AVG_OFF], label='avg off', color='tab:green')
    ax3.xaxis.set_ticks(result[:, GEN])
    ax3.set_ylabel('Average number of offsprings')
    ax3.set_xlabel('Generation')
    ax3.legend(loc='upper right')
    ax3.grid(alpha=0.3)

    # NRR axis
    x = result[:14, GEN]
    ax4.step(x, result[0:14, NRR], label='nrr', color='tab:orange')
    ax4.xaxis.set_ticks(result[:, GEN])
    ax4.axis([0, 15, 0, 2])
    ax4.set_ylabel('NRR')
    ax4.set_xlabel('Generation')
    ax4.legend(loc='upper right')
    ax4.grid(alpha=0.3)

    # Save the fig as a png and exit
    fig.savefig(GRAPH_DIR / directory.name / (file.stem + '.png'))
    plt.close(fig)
    print('done')
