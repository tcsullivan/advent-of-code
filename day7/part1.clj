(def input
  (->> (slurp "./in") ; "16,1,2,0,4,2,7,1,2,14"
       (#(clojure.string/split % #","))
       (map read-string)
       )
  )

(defn median [lst]
  (let [cnt (count lst)
        hlf (quot cnt 2)
        srt (sort lst)]
    (if (odd? cnt)
      (nth srt hlf)
      (quot (+ (nth srt hlf) (nth srt (dec hlf))) 2)
      )
    )
  )

(println
  (->> input
       (map (partial - (median input)))
       (map #(if (neg? %) (- %) %))
       (apply +)
       )
  )

