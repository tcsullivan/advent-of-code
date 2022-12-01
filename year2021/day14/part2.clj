(require '[clojure.string :as str])

(def input (->> (slurp "./in")
                str/split-lines
                ((juxt
                   #(let [init-polymer (first %)]
                      (for [i (range 0 (dec (count init-polymer)))]
                        (subs init-polymer i (+ i 2))))
                   (fn [lines]
                     (->> lines
                       (drop 2)
                       (map #(str/split % #" -> "))
                       (map (fn [[[a b] c]]
                         {(str/join [a b]) (map str/join [[a c] [c b]])}))
                       (reduce into)
                       ))))))

(def blank-map (zipmap (keys (second input)) (repeat 0)))

(defn grow-polymer [polymer insertion-rules]
  (reduce
    #(let [[p1 p2] (insertion-rules (key %2)) v (val %2)]
       (-> %1 (update p1 + v) (update p2 + v)))
    blank-map
    (filter (comp pos? val) polymer)))

(def growth-seq
  (iterate #(grow-polymer % (second input))
           (reduce #(update %1 %2 inc) blank-map (first input))))

(let [final-polymer (nth growth-seq 40) 
      letter-counts (reduce
                      (fn [r [k v]] (-> r (update (first k) + v) (update (second k) + v)))
                      (zipmap (str/join (keys final-polymer)) (repeat 0))
                      final-polymer)
      unique-counts (filter pos? (map #(Math/ceil (/ (val %) 2)) letter-counts))]
  (println (- (apply max unique-counts) (apply min unique-counts))))

