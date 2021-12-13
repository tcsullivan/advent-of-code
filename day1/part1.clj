; Day 1, part 1
; Read a list of numbers from stdin, separated by newlines.
; Count occurances of the current number being greater than
; the previous.
;

(as-> (slurp "./in") $
     (clojure.string/split-lines $)
     (map read-string $)
     (reduce
       #(cond-> (assoc %1 0 %2) (> %2 (first %1)) (update 1 inc))
       [(first $) 0]
       (rest $))
     (println (second $)))

