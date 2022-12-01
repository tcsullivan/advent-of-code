(require '[clojure.string :as str])

(->> (read-line)
     (#(str/split % #","))
     (map read-string)
     (reduce #(update %1 %2 inc) (vec (repeat 9 0)))
     (iterate
       #(let [nf (conj (vec (rest %)) (first %))]
          (update nf 6 (partial + (get nf 8)))
          )
       )
     (#(nth % 256))
     (apply +)
     (println)
     )

; ->> read input from stdin
;     split input string by commas
;     convert string array into number array
;     reduce to frequency counts
;     create iterator that returns next day's counts
;     get 256th iteration
;     sum all frequency counts
;     print results

