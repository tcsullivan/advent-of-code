; Day 2, part 2
; Read a list of instructions from stdin:
;   "down X" increases aim number by X,
;   "up X" decreases aim by X,
;   "forward X" increases xpos by X and depth by (aim * X).
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(println
  (apply *
    (map
      (reduce
        #(case (first %2)
           "forward" (-> %1 (update :xpos + (second %2))
                            (update :depth + (* (%1 :aim) (second %2))))
           "up"      (update %1 :aim - (second %2))
           "down"    (update %1 :aim + (second %2)))
        {:xpos 0 :depth 0 :aim 0}
        (->> (slurp "./in")
             str/split-lines
             (map #(str/split % #" "))
             (map #(update % 1 read-string))))
      [:xpos :depth]
      )))

