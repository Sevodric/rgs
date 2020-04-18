# Ridiculous Generation Simulation

## About

Once upon a time, there was a bored CS student. He wanted to know if a
population could be stable. He decided to fiddle with the lovely Ruby language,
objects and contracts.

**Disclaimer:** I'm not a biologist, mathematician or any kind of reproduction
expert, just a bored student :)

## Example of usage

For 10 generations with a starting population of 50 indivdiduals in which each
couple can have a maximum of 4 offsprings:

*Possible output:*

```
GEN     POP     AVG     M%|F%   NRR
---     ---     ---     -----   ---
1       50      2.3     62|38   1.1 
2       43      1.6     47|53   0.7 
3       31      2.1     55|45   1.1 
4       30      2.5     50|50   0.9 
5       38      1.9     34|66   0.8 
6       25      1.8     56|44   0.9 
7       20      2.9     50|50   1.4 
8       29      1.9     52|48   0.9 
9       27      1.7     48|52   0.6 
10      22      1.1     36|64   0.5
```

*Legend:*

Column | Meaning
------ | --------
`GEN`  | generation number
`POP`  | number of indivuals (not cumulative)
`OFF`  | average of offsprings per couple
`F%\|M%`| sex distribution in percentage
`NRR` | net reproduction rate

## Tests and observations

### Overview

In the first phase, I fixed the number of offsprings.

In the second phase, I let this number vary between 0 and a maximum.

In the third phase, I implemented the
[net reproduction rate](https://en.wikipedia.org/wiki/Net_reproduction_rate).

The sex of each offspring was always randomly determined.

### First and second phase

Number of offsprings | Observations on the population
-------------------- | ------------
fixed n < 5 | eventually goes extinct
fixed n >= 5 | grows indefinitely
random in [0, max < 5] | eventually goes extinct
random in [0, max >= 5] | grows indefinitely

Results eventually are the same in both phases but overall, the population were
quicker to proliferate or go extinct whith a fixed number of offsprings per
couples.

The generation of extinction or the growing rate vary depending on the initial
number of indivuals and the number of offsprings per couple. Lowers values for
these two parameters result in a quicker extinction/grow.

### Third phase

In this phase, I tried to implement the net reproduction rate of each generation
compared to the one that follows. With my understanding, I hesitated: should I
keep the possibility for couples to have no offsprings? I came to the following
conclusion:

*The simulation doesn't take into account any kind of mortality and the NRR
assumes that surviving daughters will have offsprings. Female mortality before
childbearing years is kind of simulated by the fact that some couples can have
0 offsprings.*

> Replacement level  fertility is said to have been reached when NRR=1.0

The NRR is now in the place,I want to test multiple parameters in a proper way.
I might automate this later.

**[COMING SOON]**

## Conclusion

I didn't succeed in finding parameters such as the population is stable in time.
Enforcing the NRR to 1.0 is yet to be explored. What will then be the average
number of offsprings per couple?

Those observations only reflect the simplicity of this simulation and were not
made in a rigourous and scientific way.

The code and features are still to be extended.

## Bibliography

[Net reproduction rate](https://link.springer.com/referenceworkentry/10.1007%2F978-1-4020-5614-7_2304)
(2008) Net Reproduction Rate (NRR). In: Kirch W. (eds) Encyclopedia of Public Health. Springer, Dordrecht

[Gross reproduction rate](https://link.springer.com/referenceworkentry/10.1007%2F978-1-4020-5614-7_1306)
(2008) Gross Reproduction Rate (GRR). In: Kirch W. (eds) Encyclopedia of Public Health. Springer, Dordrecht
