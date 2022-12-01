(def input-map
  (->> (slurp "./in")
       (clojure.string/split-lines)
       (mapv vec)
       (mapv (partial mapv #(- (int %) 48)))
       ))

(defn get-adj [y x]
  (map (partial get-in input-map)
       [[(dec y) x] [(inc y) x] [y (dec x)] [y (inc x)]]))

(->> (for [y (range 0 (count input-map))
           x (range 0 (count (first input-map)))
           :let [height (get-in input-map [y x])]
           :when (every? #(or (nil? %) (< height %))
                         (get-adj y x))]
           (inc height))
     (apply +)
     (println)
     )

