; Day 2, part 1
; Read a list of instructions from stdin:
;   "down X" increases depth number by X,
;   "up X" decreases depth by X,
;   "forward X" increases xpos by X.
; Print (xpos * depth) after end of data.
;

(require '[clojure.string :as str])

(println
  (keduce *
    (vals
      (reduce
        #(case (first %2)
           "forward" (update %1 :xpos  + (second %2))
           "up"      (update %1 :depth - (second %2))
           "down"    (update %1 :depth + (second %2))
           )
        {:xpos 0 :depth 0}
        (->> (slurp "./in")
             str/split-lines
             (map #(str/split % #" "))
             (map #(update % 1 read-string))
             )))))

