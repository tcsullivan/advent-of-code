(def input (->> (slurp "./in")
                (clojure.string/split-lines)
                (mapv (partial mapv (comp read-string str)))
                (#(for [y (range 0 (count %)) x (range 0 (count (first %)))]
                    {[y x] (get-in % [y x])}))
                (into {})))

(def dim (apply max (map first (keys input))))

(defn find-neighbors [u]
  (filter #(contains? input %) [(update u 0 inc)
                                (update u 0 dec)
                                (update u 1 inc)
                                (update u 1 dec)]))

(loop [dist (zipmap (keys input) (repeat ##Inf))
       Q    {[0 0] 0}]
  (if (empty? Q)
    (println (dist [dim dim]))
    (let [[u distu] (first Q)
          NN (reduce
               #(let [dv (+ distu (input %2))]
                  (cond-> %1
                    (> ((first %1) %2) dv)
                    (-> (update 0 assoc %2 dv)
                        (update 1 assoc %2 dv))))
               [dist {}]
               (find-neighbors u))]
      (recur (first NN) (sort-by val < (into (rest Q) (second NN)))))))

