(defn calc-fuel [lst pos]
  (->> lst
       (map
         (comp
           #(/ (* % (inc %)) 2)
           #(Math/abs %)
           (partial - pos)
           )
         )
       (apply +)
       )
  )

(let [input (->> (slurp "./in") ;"16,1,2,0,4,2,7,1,2,14"
                 (#(clojure.string/split % #","))
                 (map read-string)
                 )
      mean (quot (apply + input) (count input))
      ]
  (println (min (calc-fuel input mean)
                (calc-fuel input (inc mean))))
  )

