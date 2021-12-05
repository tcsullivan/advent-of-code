(require '[clojure.string :as str])

(def bitcount 12)
(def input
  (->> "./in"
      (slurp)
      (str/split-lines)
      (map #(Integer/parseInt % 2))
      )
  )

(defn countbit [lst bit]
  (->> lst
       (map #(if (bit-test % bit) 1 0))
       (apply +)
       )
  )

(defn filterbit [lst bit v]
  (if (= 1 (count lst))
    lst
    (filter #(= (bit-test % bit) v) lst)
    )
  )

(loop [bit (dec bitcount) lst0 input lst1 input]
  (if (and (= 1 (count lst0)) (= 1 (count lst1)))
    (println (map * lst0 lst1))
    (recur
      (dec bit)
      (filterbit lst0 bit (>= (countbit lst0 bit) (/ (count lst0) 2)))
      (filterbit lst1 bit (< (countbit lst1 bit) (/ (count lst1) 2)))
      )
    )
  )

