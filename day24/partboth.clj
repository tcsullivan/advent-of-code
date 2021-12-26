(require '[clojure.string :as str])

; The given program operates on a base-26 stack, either pushing or
; (conditionally) popping values. This code extracts those operations
; from the input, then works through them to determine the highest
; and lowest values that produce an output of zero.
; See the .md file in this directory for more info.

(def program (->> (slurp "./in")
                  str/split-lines
                  (map #(str/split % #"\s+"))
                  (partition 18)
                  (map (fn [step]
                    (if (= "1" (last (nth step 4)))
                      [:push (read-string (last (nth step 15)))]
                      [:pop (read-string (last (nth step 5)))])
                    ))))

(defn program-index [prog] (- 14 (count prog)))

(loop [numbers (vec (repeat 2 (vec (repeat 14 0))))
       stack '()
       prog program]
  (if-let [step (first prog)]
    (if (= :push (first step))
      (recur numbers
             (conj stack [(program-index prog) (second step)])
             (rest prog))
      (let [i2     (program-index prog)
            [i1 v] (first stack)
            diff   (+ v (second step))]
        (recur
          [(if (neg? diff)
             (-> (first numbers) (assoc i1 9) (assoc i2 (+ 9 diff)))
             (-> (first numbers) (assoc i2 9) (assoc i1 (- 9 diff))))
           (if (neg? diff)
             (-> (second numbers) (assoc i2 1) (assoc i1 (- 1 diff)))
             (-> (second numbers) (assoc i1 1) (assoc i2 (+ 1 diff))))]
          (rest stack) (rest prog))))
  (println (map str/join numbers))))

