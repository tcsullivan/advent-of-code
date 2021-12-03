; Day 2, part 2
; Read a list of instructions from stdin:
;   "down X" increases depth number by X,
;   "up X" decreases depth by X,
;   "forward X" increases xpos by X.
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(loop [data {:xpos 0 :depth 0}]
  (let [input (read-line)]
    (if (empty? input)
      (println (apply * (vals data)))
      (let [ins (str/split input #" ")
            n (Integer/parseInt (second ins))
            ]
        (recur
          (apply (partial update-in data)
            (case (first ins)
              "forward" [[:xpos] + n]
              "up" [[:depth] - n]
              "down" [[:depth] + n]
              )
            )
          )
        )
      )
    )
  )

