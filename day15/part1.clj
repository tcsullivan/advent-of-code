(def input (->> (slurp "./in")
                (clojure.string/split-lines)
                (mapv (partial mapv (comp read-string str)))
                (#(for [y (range 0 (count %)) x (range 0 (count (first %)))]
                    {[y x] (get-in % [y x])}))
                (into {})))

(defn min-distance [dist Q]
  (reduce
    #(if (and (not= (dist %2) :inf)
           (or (= :inf (first %1))
               (< (dist %2) (first %1))))
         [(dist %2) %2]
         %1)
    [:inf []] Q))

(defn find-neighbors [Q u]
  (filter #(contains? Q %) [(update u 0 inc)
                            (update u 0 dec)
                            (update u 1 inc)
                            (update u 1 dec)]))

(let [dim (apply max (map first (keys input)))]
  (loop [Q (set (keys input))
         dist (-> (zipmap Q (repeat :inf)) (update [0 0] #(do % 0)))]
    (if (empty? Q)
      (println (dist [dim dim]))
      (let [[u vu] (min-distance dist Q)]
        (recur
          (disj Q vu)
          (loop [d dist f (find-neighbors Q vu)]
            (if (empty? f)
              d
              (recur
                (let [v (first f) alt (+ u (input v))]
                  (if (or (= :inf (dist v)) (< alt (dist v)))
                    (assoc d v alt)
                    d
                    ))
                (rest f)
                ))))))))

