(defn get-adj [in y x]
  (filter
    #(some? (get-in in %))
    [[(dec y) (dec x)] [(dec y) x] [(dec y) (inc x)]
     [y (dec x)] [y (inc x)]
     [(inc y) (dec x)] [(inc y) x] [(inc y) (inc x)]]
    ))

(defn apply-incs [in] (mapv (partial mapv inc) in))

(defn next-step [indata]
  (loop [in (apply-incs (indata :grid)) bl (indata :blinks) y 0 x 0]
    (cond
      (> (get-in in [y x]) 9)
      (do
        (recur
          (-> (reduce
                (fn [i n] (update-in i n #(cond-> % (pos? %) inc)))
                in
                (get-adj in y x))
              (update-in [y x] #(do % 0)))
          (inc bl)
          0 0))
      (< x (dec (count (first in))))
      (recur in bl y (inc x))
      (< y (dec (count in)))
      (recur in bl (inc y) 0)
      :else
      {:grid in :blinks bl}
      )
    )
  )

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (partial map #(- (int %) 48)))
     (assoc {} :blinks 0 :grid)
     (iterate next-step)
     (#(nth % 100))
     (#(println (% :blinks))))

