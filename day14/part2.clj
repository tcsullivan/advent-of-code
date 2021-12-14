(require '[clojure.string :as str])

(def input (->> (slurp "./in2")
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

(def blank-map
  (reduce
    #(assoc %1 %2 0)
    {}
    (keys (second input))))

(defn grow-polymer [polymer insertion-rules]
  (reduce
    (fn [res pair]
      (let [pk (key pair)
            p1 (str/join [(first pk) (insertion-rules pk)])
            p2 (str/join [(insertion-rules pk) (second pk)])]
        (-> res (update p1 + (val pair)) (update p2 + (val pair)))
        ))
    blank-map
    (filter #(pos? (val %)) polymer)
    ))

(def growth-seq
  (iterate
    #(grow-polymer % (second input))
    (reduce
      #(update %1 %2 inc)
      blank-map
      (for [i (range 0 (dec (count (first input))))]
              (subs (first input) i (+ i 2))))))

(let [results
  (map #(Math/ceil (/ % 2))
    (vals
      (reduce
        (fn [r p] (-> r
                      (update (first (key p)) #(if (nil? %) (val p) (+ % (val p))))
                      (update (second (key p)) #(if (nil? %) (val p) (+ % (val p))))))
        {}
        (nth growth-seq 40))))]
  (println (- (apply max results) (apply min results))))

