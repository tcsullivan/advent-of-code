(require '[clojure.string :as str])

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

(defn grow-polymer [polymer insertion-rules]
  (str/join
    (cons
      (first polymer)
      (mapcat (juxt insertion-rules second)
        (for [i (range 0 (dec (count polymer)))]
          (subs polymer i (+ i 2)))))))

(def growth-seq (iterate #(grow-polymer % (second input)) (first input)))

(let [freqs (vals (frequencies (nth growth-seq 10)))]
  (println (- (apply max freqs) (apply min freqs))))

