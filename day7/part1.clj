(defn median [lst]
  (let [cnt (count lst)
        hlf (quot cnt 2)
        srt (sort lst)]
    (cond->> (nth srt hlf)
      (even? cnt)
      (+ (nth srt (dec hlf)))
      :true
      (#(quot % 2))
      )
    )
  )

(->> (slurp "./in") ; "16,1,2,0,4,2,7,1,2,14"
     (#(clojure.string/split % #","))
     (map read-string)
     (#(map (partial - (median %)) %))
     (map #(Math/abs %))
     (apply +)
     (println)
     )

