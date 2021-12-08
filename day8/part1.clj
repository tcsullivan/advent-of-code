(require '[clojure.string :as str])

(loop [sum 0]
  (let [line (read-line)]
    (if (empty? line)
      (println sum)
      (recur
        (+
         sum
         (reduce
           #(let [c (count %2)]
              (if (or (= 2 c) (= 3 c) (= 4 c) (= 7 c))
                (inc %1)
                %1
                )
             )
           0
           (subvec
             (mapv (comp str/join sort) (str/split line #" "))
             11 15
             )
           )
         )
        )
      )
    )
  )

