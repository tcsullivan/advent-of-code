(def input
  (->> (slurp "./in") ;"16,1,2,0,4,2,7,1,2,14"
       (#(clojure.string/split % #","))
       (map read-string)
       )
  )

(defn mean [lst]
  (quot (apply + lst) (count lst))
  )

(defn calc-fuel [lst meen]
  (->> input
       (map (partial - meen))
       (map #(if (neg? %) (- %) %))
       (map #(apply + (range 1 (inc %))))
       (apply +)
       )
  )

(println (min (calc-fuel input (mean input))
              (calc-fuel input (inc (mean input)))))

