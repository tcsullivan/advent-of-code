; Day 1, part 2
; Read a list of numbers from stdin, separated by newlines.
; Count occurances of the current sum being greater than
; the previous, where a sum is that of the current number,
; the previous number, and the next number.
;

(loop [inc-count 0
       buff (repeat 4 (Integer/parseInt (read-line)))
       ]
  (let [next (read-line)
        new-count (if (> (last buff) (first buff))
                    (inc inc-count)
                    inc-count
                    )
        ]
    (if (empty? next)
      (println new-count)
      (recur
        new-count
        (concat
          (rest buff)
          [(Integer/parseInt next)]
          )
        )
      )
    )
  )

