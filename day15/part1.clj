(require '[clojure.core.reducers :as r])

(def input (->> (slurp "./in")
                (clojure.string/split-lines)
                (mapv (partial mapv (comp read-string str)))
                (#(for [y (range 0 (count %)) x (range 0 (count (first %)))]
                    {[y x] (get-in % [y x])}))
                (into {})))

(defn min-distance [dist Q]
  (r/fold
    (r/monoid
      #(if (< (first %1) (first %2)) %1 %2)
      (constantly [##Inf []]))
    (r/monoid
      #(if (< (first %1) (dist %2)) %1 [(dist %2) %2])
      (constantly [##Inf []]))
    (r/filter
      (partial contains? dist)
      (apply vector Q))))

(defn find-neighbors [Q u]
  (filter #(contains? Q %) [(update u 0 inc)
                            (update u 0 dec)
                            (update u 1 inc)
                            (update u 1 dec)]))

(let [dim (apply max (map first (keys input)))]
  (loop [Q (apply sorted-set (keys input))
         dist (assoc (hash-map) [0 0] 0)]
    (when (= 0 (rem (count Q) 500)) (println (count Q)))
    (if (empty? Q)
      (println (dist [dim dim]))
      (let [[u vu] (min-distance dist Q)]
        (recur
          (disj Q vu)
          (reduce
            #(let [alt (+ u (input %2))]
               (cond-> %1
                 (or (not (contains? dist %2)) (< alt (dist %2)))
                 (assoc %2 alt)))
            dist
            (find-neighbors Q vu)))))))

