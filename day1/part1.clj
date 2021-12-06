; Day 1, part 1
; Read a list of numbers from stdin, separated by newlines.
; Count occurances of the current number being greater than
; the previous.
;

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map read-string)
     (reduce
       #(update [%2 (second %1)] 1 (partial + (if (> %2 (first %1)) 1 0)))
       [999999 0]
       )
     (second)
     (println)
     )

