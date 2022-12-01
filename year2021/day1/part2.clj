; Day 1, part 2
; Read a list of numbers from stdin, separated by newlines.
; Count occurances of the current sum being greater than
; the previous, where a sum is that of the current number,
; the previous number, and the next number.
;

(let [input (->> (slurp "./in")
                 clojure.string/split-lines
                 (mapv read-string))]
  (println
    (count
      (filter #(< (get input %) (get input (+ % 3)))
        (range 0 (- (count input) 3))))))

