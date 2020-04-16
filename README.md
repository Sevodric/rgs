# Ridiculous Generation Simulation

Once upon a time, there was a bored CS student. He wanted to know if a
population could be stable. He decided to fiddle with the lovely Ruby language,
objects and contracts.

**Disclaimer:** I'm not a biologist, mathematician or any kind of reproduction
expert, just a bored student :)

## Usage

Exemple for a study on 10 generations with a starting population of 50
indivdiduals in which each couple can have a maximum of 4 offsprings:

```
$ ruby rgs.rb 10 50 4
GEN POP OFF F%|M%
--- --- --- -----
1   50  2.4 60|40
2   48  2.2 54|46
3   49  2.0 49|51
4   48  1.9 42|58
5   37  1.5 62|38
6   21  2.6 33|67
7   18  1.7 50|50
8   15  2.3 47|53
9   16  2.0 50|50
10  16      38|63

```
