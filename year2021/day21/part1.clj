(require 'clojure.string)

(loop [player-positions   (->> (slurp "./in")
                               clojure.string/split-lines
                               (map (comp read-string second #(clojure.string/split % #": ")))
                               (mapv #(drop (dec %) (cycle (range 1 11)))))
       player-scores      (into [] (repeat (count player-positions) 0))
       player-turn        (cycle (range 0 (count player-scores)))
       deterministic-dice (cycle (range 1 101))
       dice-roll-count    0]
  (if-not (every? #(< % 1000) player-scores)
    (println (* dice-roll-count (apply min player-scores)))
    (let [roll         (reduce + (take 3 deterministic-dice))
          turn         (first player-turn)
          new-position (drop roll (get player-positions turn))]
      (recur
        (assoc player-positions turn new-position)
        (update player-scores turn + (first new-position))
        (next player-turn)
        (drop 3 deterministic-dice)
        (+ dice-roll-count 3)))))

