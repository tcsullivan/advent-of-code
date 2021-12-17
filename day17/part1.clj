(def target-area [[169 -8] [206 -108]])
;(def target-area [[20 -5] [30 -10]])
(def initial-pos [0 0])

(defn beyond-target? [[[tbx tby] [tex tey]] [x y]]
  (or (> x tex) (< y tey)))

(defn within-target? [[[tbx tby] [tex tey]] [x y]]
  (and (>= x tbx) (<= x tex) (<= y tby) (>= y tey)))

(defn apply-velocity [[pos vel]]
  [[(+ (first pos) (first vel)) (+ (second pos) (second vel))]
   [(cond-> (first vel) (> (first vel) 0) dec (< (first vel) 0) inc) (dec (second vel))]])

(defn path-builder [vel] (iterate apply-velocity [initial-pos vel]))

(defn build-path [target vel]
  (map first
    (take-while (comp not (partial beyond-target? target) first)
                (path-builder vel))))

(defn path-height [target vel]
  (let [path (build-path target vel)]
    (when (within-target? target (last path))
      (apply max (map second path)))))

(def tnum-seq (iterate #(do [(+ (first %) (second %)) (inc (second %))]) [0 1]))

(let [x (second (last (take-while #(< (first %) (first (first target-area))) tnum-seq)))]
  (println
    (apply max
      (filter some?
        (for [y (range -2000 2000)] (path-height target-area [x y]))))))

