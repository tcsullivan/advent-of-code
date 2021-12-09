(def input-map
  (->> (slurp "./in")
       (clojure.string/split-lines)
       (mapv vec)
       (mapv (partial mapv #(- (int %) 48)))
       ))

(defn compare-heights [a b]
  (if (or (nil? a) (nil? b) (< a b)) 1 0))

(println
  (apply +
      (for [y (range 0 (count input-map))
            x (range 0 (count (first input-map)))]
        (let [height (get-in input-map [y x])]
          (if
            (= 4
               (apply +
                 (map
                   (partial compare-heights height)
                   [
                    (get-in input-map [(dec y) x])
                    (get-in input-map [(inc y) x])
                    (get-in input-map [y (dec x)])
                    (get-in input-map [y (inc x)])
                   ]
                   )
                 )
               )
            (inc height)
            0
            )
          )
        )
    )
  )

