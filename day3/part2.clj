(def bitcount 12)
(def input
  (loop [tot []]
    (let [line (read-line)]
      (if (empty? line)
        tot
        (recur (conj tot (Integer/parseInt line 2)))
        )
      )
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
    (loop [l lst r []]
      (if (empty? l)
        r
        (recur
          (rest l)
          (if (= (bit-test (first l) bit) v)
            (conj r (first l))
            r
            )
          )
        )
      )
    )
  )

(loop [bit (dec bitcount) lst0 input lst1 input]
  (if (and (= 1 (count lst0)) (= 1 (count lst1)))
    (println (* (first lst0) (first lst1)))
    (recur
      (dec bit)
      (filterbit lst0 bit (>= (countbit lst0 bit) (/ (count lst0) 2)))
      (filterbit lst1 bit (< (countbit lst1 bit) (/ (count lst1) 2)))
      )
    )
  )

