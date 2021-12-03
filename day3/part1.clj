(def counts
  (loop [line (read-line)
         tot (repeat (count line) 0)
         ]
    (if (empty? line)
      tot
      (recur
        (read-line)
        (map + tot (map #(if (= % \1) 1 0) line))
        )
      )
    )
  )

(println counts)

(loop [cnts counts gamma 0 epsilon 0]
  (if (empty? cnts)
    (println (* gamma epsilon))
    (recur
      (rest cnts)
      (if (> (first cnts) 500)
        (inc (* 2 gamma))
        (* 2 gamma)
        )
      (if (< (first cnts) 500)
        (inc (* 2 epsilon))
        (* 2 epsilon)
        )
      )
    )
  )

