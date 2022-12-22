## Solving part 2 with Maxima

1. Add '$' to the end of each line of input.
2. Replace `root`'s operator with '='.
3. Replace `humn`'s definition with x: `humn: x$`.
4. Load into maxima: `maxima --init-mac=input`
5. Evaluate `root` until `x` is visible: `root: root, eval;`.
6. Solve: `solve(root, x)`.

