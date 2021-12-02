; Day 2, part 2
; Read a list of instructions from stdin:
;   "down X" increases aim number by X,
;   "up X" decreases aim by X,
;   "forward X" increases xpos by X and depth by (aim * X).
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(loop [xpos 0 depth 0 aim 0]
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
          (if (= (first ins) "forward")
            (+ depth (* aim n))
            depth
            )
          (case (first ins)
            "down" (+ aim n)
            "up" (- aim n)
            aim)
          )
        )
      )
    )
  )

