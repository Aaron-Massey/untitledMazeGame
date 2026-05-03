The maze should have the following attributes:
- Discontinuous walls
- Hidden corners (for the levers to hide in)
- Tight corridors
- Forking Paths
- 25x25 or 51x51?
- 1 entrance (maybe like a wrought iron gate?)
- 1 exit (locked by the levers)
- At least 3 dead ends
- "Imperfect Maze"


Potentially use:
Kruskal's Algorithm
Eller's Algorithm
Modified Braid Recursive Backtracker (prevent removing all dead ends)

Generate each tile using a bitmask to store the open sides:
1 = +X
2 = -X
4 = +Z
8 = -Z

We can use the separate tile system, defining the rotations with the bitmask and a map script
(using a LUT for tile choice and rotation)


The maze should have the following attributes:
- Discontinuous walls
- Hidden corners (for the levers to hide in)
- Tight corridors
- Forking Paths
- 25x25 or 51x51?
- 1 entrance (maybe like a wrought iron gate?)
- 1 exit (locked by the levers)
- At least 3 dead ends
- "Imperfect Maze"
