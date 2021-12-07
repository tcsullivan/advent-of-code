(defn median [lst]
  (as-> (count lst) $
    (quot $ 2)
    (subvec (vec (sort lst)) (dec $) (inc $))
    (if (even? (count lst)) (apply + $) (second $))
    (quot $ 2)
    )
  )

(as-> (slurp "./in") $ ; "16,1,2,0,4,2,7,1,2,14"
      (clojure.string/split $ #",")
      (mapv read-string $)
      (map (partial - (median $)) $)
      (map #(Math/abs %) $)
      (apply + $)
      (println $)
      )

