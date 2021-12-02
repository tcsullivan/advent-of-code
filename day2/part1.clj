; Day 2, part 2
; Read a list of instructions from stdin:
;   "down X" increases depth number by X,
;   "up X" decreases depth by X,
;   "forward X" increases xpos by X.
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(loop [xpos 0 depth 0]
  (let [input (read-line)]
    (if (empty? input)
      (println (* xpos depth))
      (let [ins (str/split input #" ")
            n (Integer/parseInt (second ins))
            ]
        (recur
          (if (= (first ins) "forward")
            (+ xpos n)
            xpos
            )
          (case (first ins)
            "up" (- depth n)
            "down" (+ depth n)
            depth
            )
          )
        )
      )
    )
  )

