(def input (->> (slurp "./in")
                (clojure.string/split-lines)
                (mapv (partial mapv (comp read-string str)))
                (#(for [y (range 0 (count %)) x (range 0 (count (first %)))]
                    {[y x] (get-in % [y x])}))
                (into {})
                ((fn [lst]
                (reduce
                  #(into %1
                     (for [j (range 0 5) i (range 0 5)]
                       {[(+ (first (key %2)) (* 100 j)) (+ (second (key %2)) (* 100 i))]
                        (let [s (+ i j (val %2))] (if (> s 9) (- s 9) s))}))
                  {}
                  lst
                  )))
                (into {})
                ))

(defn min-distance [dist Q]
  (reduce
    #(if (and (not= (dist %2) :inf)
           (or (= :inf (first %1))
               (< (dist %2) (first %1))))
         [(dist %2) %2]
         %1)
    [:inf []]
    Q
    ))

(defn find-neighbors [Q u]
  (filter #(contains? Q %) [(update u 0 inc)
                            (update u 0 dec)
                            (update u 1 inc)
                            (update u 1 dec)]))

(loop [Q (set (keys input))
       dist (-> (zipmap Q (repeat :inf)) (update [0 0] #(do % 0)))]
  (if (empty? Q)
    (println (dist [499 499]))
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
              )))))))

