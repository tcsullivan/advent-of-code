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
                       (map (fn [[pair ltr]]
                              {pair (map str/join [[(first pair) ltr] [ltr (second pair)]])}))
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

(let [polymer (nth growth-seq 40)  
      results (filter pos?
                (map #(Math/ceil (/ % 2))
                  (vals
                    (reduce
                      #(let [k (key %2) v (val %2)] (-> %1 (update (first k) + v) (update (second k) + v)))
                      (zipmap (flatten (map (partial split-at 1) (keys polymer))) (repeat 0))
                      polymer))))]
  (println (- (apply max results) (apply min results))))

