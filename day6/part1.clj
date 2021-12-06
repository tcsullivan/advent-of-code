(require '[clojure.string :as str])

(def fish-init
  (->> (read-line)
       (#(str/split % #","))
       (map #(Integer/parseInt %))
       (vec)
       )
  )

(defn cycle-day [fish]
  (flatten
    (for [f (map dec fish)]
      (if (neg? f) [6 8] f)
      )
    )
  )

(println (count (nth (iterate cycle-day fish-init) 80)))

