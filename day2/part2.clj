; Day 2, part 2
; Read a list of instructions from stdin:
;   "down X" increases aim number by X,
;   "up X" decreases aim by X,
;   "forward X" increases xpos by X and depth by (aim * X).
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(loop [data {:xpos 0 :depth 0 :aim 0}]
  (let [input (read-line)]
    (if (empty? input)
      (println (apply * (map data [:xpos :depth])))
      (let [ins (str/split input #" ")
            n (Integer/parseInt (second ins))
            ]
        (recur
          (case (first ins)
            "forward" (-> data
                          (update-in [:xpos] + n)
                          (update-in [:depth] + (* (data :aim) n))
                          )
            "up" (update-in data [:aim] - n)
            "down" (update-in data [:aim] + n)
            )
          )
        )
      )
    )
  )

