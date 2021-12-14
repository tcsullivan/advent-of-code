(require '[clojure.string :as str])
(require '[clojure.core.reducers :as r])

(def input (->> (slurp "./in")
                str/split-lines
                ((juxt
                   first
                   (fn [lines]
                     (->> lines
                       (drop 2)
                       (map #(str/split % #" -> "))
                       (flatten)
                       (apply (partial assoc {}))
                       ))))))

(defn handle-pair [pair steps]
  (if (= 0 steps)
    (frequencies (rest pair))
    (let [ins ((second input) pair)
          p1  (handle-pair (str/join [(first pair) ins]) (dec steps))
          p2  (handle-pair (str/join [ins (second pair)]) (dec steps))]
      (reduce
        (fn [r p] (update r (key p) #(if (nil? %) (val p) (+ (val p) %))))
        p1 p2)
      )))

(println
  (reduce
    (fn [tot pair]
      (let [freqs (handle-pair pair 23)]
        (println "Finished pair " pair)
        (reduce
          (fn [r p] (update r (key p) #(if (nil? %) (val p) (+ (val p) %))))
          tot
          freqs)))
    {}
    (for [i (range 0 (dec (count (first input))))]
      (subs (first input) i (+ i 2)))
    ))

