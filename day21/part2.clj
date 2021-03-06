(defn dice-probability-spread [sides rolls]
  (let [sr (range 1 (inc sides))]
    (->> sr
         (iterate #(flatten (for [i sr] (map (partial + i) %))))
         (drop (dec rolls))
         ((comp frequencies first)))))

(def rolls (dice-probability-spread 3 3))

(defn advance-pos [pos roll] (let [n (+ pos roll)] (if (> n 10) (- n 10) n)))

(defn add-roll [state roll p1-turn]
  (let [pos   (if p1-turn :pos1 :pos2)
        score (if p1-turn :score1 :score2)
        new-pos (advance-pos (state pos) roll)]
    (-> state
        (assoc pos new-pos)
        (update score + new-pos))))

(defonce wins (atom [0 0]))

(loop [turn 0 states {{:pos1 4 :score1 0 :pos2 8 :score2 0} 1}]
  (if (empty? states)
    (println (apply max @wins))
    (recur
      (if (= 0 turn) 1 0)
      (reduce
        #(let [kvp (first %2)]
           (if (< ((key kvp) (if (= 0 turn) :score1 :score2)) 21)
             (if (contains? %1 (key kvp))
               (update %1 (key kvp) +' (val kvp))
               (conj %1 kvp))
             (do (swap! wins update turn +' (val kvp)) %1)))
        {}
        (for [s states r rolls]
          {(add-roll (first s) (key r) (= 0 turn)) (*' (second s) (val r))})))))

