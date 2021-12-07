(defn calc-fuel [lst pos]
  (reduce #(as-> %2 $
             (- pos $)
             (Math/abs $)
             (/ (* $ (inc $)) 2)
             (+ %1 $)
             )
          0 lst
          )
  )

(let [input (as-> (slurp "./in") $ ;"16,1,2,0,4,2,7,1,2,14"
                  (clojure.string/split $ #",")
                  (map read-string $)
                  )
      mean (quot (apply + input) (count input))]
  (println (min (calc-fuel input mean)
                (calc-fuel input (inc mean))))
  )

