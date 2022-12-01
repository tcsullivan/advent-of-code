(require '[clojure.string :as str])

(def calls
  (->> (read-line)
       (#(str/split % #","))
       (map #(Integer/parseInt %))
       )
  )

(defn read-board []
  (when (some? (read-line))
    (mapv
        (fn [line] (->> line
            (str/join)
            (str/trim)
            (#(str/split % #"\s+"))
            (map #(Integer/parseInt %))
            )
          )
        (repeatedly 5 read-line)
        )
    )
  )

(defn bingo? [board]
  (some?
    (some
      #(every? nil? %)
      (concat board (apply mapv vector board))
      )
    )
  )

(defn bingo-mark [board n]
  (mapv (partial replace {n nil}) board)
  )

(defn get-bingo [init-board]
  (loop [board init-board nums calls turns 1]
    (let [new-board (bingo-mark board (first nums))]
      (if (bingo? new-board)
        [new-board (first nums) turns]
        (recur new-board (rest nums) (inc turns))
        )
      )
    )
  )

(loop [best [0 0] board (read-board)]
  (if (nil? board)
    (println best)
    (let [bingo (get-bingo board)]
      (recur
        (if (> (get bingo 2) (first best))
          [(get bingo 2)
           (->> (first bingo)
                (flatten)
                (filter some?)
                (apply +)
                (* (second bingo))
                )
           ]
          best
          )
        (read-board)
        )
      )
    )
  )

