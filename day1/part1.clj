; Day 1, part 1
; Read a list of numbers from stdin, separated by newlines.
; Count occurances of the current number being greater than
; the previous.
;

(loop [inc-count 0
       prev (Integer/parseInt (read-line))
       ]
  (let [input (read-line)]
    (if (not (empty? input))
      (let [depth (Integer/parseInt input)]
        (recur
          (if (> depth prev) (inc inc-count) inc-count)
          depth
          )
        )
      (println inc-count)
      )
    )
  )

