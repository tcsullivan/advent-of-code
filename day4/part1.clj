(require '[clojure.string :as str])

(def calls
  (map
    #(Integer/parseInt %)
    (-> (read-line)
        (str/split #",")
        )
    )
  )

;(println calls)

(defn read-board []
  (when (not (nil? (read-line)))
    (vec
    (for [x (range 0 5)]
      (-> (read-line)
          (concat " ")
          (str/join)
          (str/trim)
          (str/split #"\s+")
          (#(map (fn [l] (Integer/parseInt l)) %))
          )
      ))
    )
  )

(defn bingo-row? [row]
  (every? nil? row)
  )

(defn bingo? [board]
  (not
    (nil?
      (some
        bingo-row?
        (concat
          board
          (apply mapv vector board)
          )
        )
      )
    )
  )

(defn get-bingo [_board]
  (loop
    [board _board nums calls turns 1]
    (let [new-board (vec (for [r (range 0 5)]
                      (replace {(first nums) nil} (get board r))))]
      (if (bingo? new-board)
        [new-board (first nums) turns]
        (recur new-board (rest nums) (inc turns))
        )
      )
    )
  )

(def best (atom [999 0]))

(loop [board (read-board)]
  (when (not (nil? board))
    (let [bingo (get-bingo board)]
      (when (< (get bingo 2) (first @best))
        (reset! best
                [(get bingo 2)
                 (*
                  (second bingo)
                  (->> (first bingo)
                       (flatten)
                       (filter some?)
                       (apply +)
                       )
                  )]
                )
        )
      )
    (recur (read-board))
    )
  )

(println @best)

