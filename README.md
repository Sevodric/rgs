# Ridiculous Generation Simulation

## About

Once upon a time, there was a bored CS student. He wanted to know if a
population could be stable. He decided to fiddle with the lovely Ruby language,
objects and contracts.

**Disclaimer:** I'm not a biologist, mathematician or any kind of reproduction
expert, just a bored student :)

## Usage

Exemple for 10 generations with a starting population of 50 indivdiduals in
which each couple can have a maximum of 4 offsprings:

**Output:**

```
$ ruby rgs.rb 10 50 4
GEN    POP    OFF    F%|M%
---    ---    ---    -----
1      50     2.4    60|40
2      48     2.2    54|46
3      49     2.0    49|51
4      48     1.9    42|58
5      37     1.5    62|38
6      21     2.6    33|67
7      18     1.7    50|50
8      15     2.3    47|53
9      16     2.0    50|50
10     16            38|63

```

**Legend:**

Column | Meaning
------ | --------
`GEN`  | generation number
`POP`  | number of indivuals (not cumulative)
`OFF`  | average of offsprings per couple
`F%\|M%`| sex distribution in percentage

## Observations

In the first phase, I fixed the number of offsprings per couples to a constant.

In the second phase, I let this number vary between 0 and a maximum.

The sex of each offspring is randomly determined.

Number of offsprings | Observations on the population
-------------------- | ------------
fixed n < 5 | eventually goes extinct
fixed n >= 5 | grows indefinitel
random in [0, max < 5] | eventually goes extinct
random in [0, max >= 5] | grows indefinitely

Results eventually are the same in both phases but overall, the population were
quicker to proliferate or go extinct whith a fixed number of offsprings per
couples.

The generation of extinction or the growing rate vary depending on the initial
number of indivuals and the number of offsprings per couple. Lowers values for
these two parameters result in a quicker extinction/grow.

## Conclusion

I didn't succeed in finding parameters such as the population is stable in time.
Enforcing the average of offspring to 2.5 might be a solution (who knows)?

Those observations only reflect the simplicity of this simulation and were not
made in a rigourous and scientific way. Maybe I shall do something more valuable
one day...

The code and features are still to be extended.
