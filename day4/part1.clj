(->> (slurp "input")
    (#(clojure.string/split % #"[^0-9]"))
    (map read-string)
    (partition 4)
    (map
      #(or (and (>= (first %) (nth % 2))
                (<= (second %) (nth % 3)))
           (and (>= (nth % 2) (first %))
                (<= (nth % 3) (second %)))))
    (filter true?)
    count
    println)
