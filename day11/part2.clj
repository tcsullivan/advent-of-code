(defonce input (->> (slurp "./in")
                    (clojure.string/split-lines)
                    (map (partial map #(- (int %) 48)))
                    (atom)
                    ))
(defonce blinks (atom 0))

(defn get-adj [y x]
  (filter #(some? (get-in @input %))
         [[(dec y) (dec x)] [(dec y) x] [(dec y) (inc x)]
          [y (dec x)] [y (inc x)]
          [(inc y) (dec x)] [(inc y) x] [(inc y) (inc x)]]
         ))

(defn apply-incs [] (mapv (partial mapv inc) @input))

(defn next-step []
  (reset! input (apply-incs))
  (loop [y 0 x 0]
    (cond
      (> (get-in @input [y x]) 9)
      (do
        (doseq [p (get-adj y x)]
          (reset! input (update-in @input p #(if (pos? %) (inc %) %))))
        (reset! input (update-in @input [y x] (fn [x] 0)))
        (reset! blinks (inc @blinks))
        (recur 0 0))
      (< x (dec (count (first @input))))
      (recur y (inc x))
      (< y (dec (count @input)))
      (recur (inc y) 0)
      )
    )
  @input
  )

(loop [cnt 0]
  (if (= 0 (apply + (flatten @input)))
    (println cnt)
    (do (next-step) (recur (inc cnt)))))

