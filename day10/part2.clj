(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 1 \] 2 \} 3 \> 4})

(defn check-line [input]
  (loop [in input open '()]
    (if-let [c (first in)]
      (when (or (nil? (#{\} \) \] \>} c)) (= (first open) c))
        (recur
          (rest in)
          (if-let [op (to-closing c)]
            (conj open op)
            (rest open))))
      open
      )))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (comp check-line vec))
     (filter some?)
     (map (partial reduce #(+ (* 5 %1) (to-score %2)) 0))
     (sort)
     (#(nth % (quot (count %) 2)))
     (println))

