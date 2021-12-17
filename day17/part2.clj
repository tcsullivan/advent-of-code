(def target-area [[169 -68] [206 -108]])
;(def target-area [[20 -5] [30 -10]])
(def initial-pos [0 0])

(defn beyond-target? [[[tbx tby] [tex tey]] [x y]]
  (or (> x tex) (< y tey)))

(defn within-target? [[[tbx tby] [tex tey]] [x y]]
  (and (>= x tbx) (<= x tex) (<= y tby) (>= y tey)))

(defn apply-velocity [[[px py] [vx vy]]]
  [[(+ px vx) (+ py vy)] [(if (pos? vx) (dec vx) 0) (dec vy)]])

(defn path-builder [vel] (iterate apply-velocity [initial-pos vel]))

(defn build-path [target vel]
  (->> (path-builder vel)
       (take-while (comp not (partial beyond-target? target) first))
       (map first)))

(defn path-height [target vel]
  (let [path (build-path target vel)]
    (when (within-target? target (last path))
      (apply max (map second path)))))

; Used to determine best x velocity for highest path
(def tnum-seq (iterate #(do [(apply + %) (inc (second %))]) [0 1]))

(let [[tb te]      target-area
      lowest-x     (second (last (take-while #(< (first %) (first tb)) tnum-seq)))
      lowest-y     (second te)
      valid-paths  (filter (comp some? first)
                    (for [y (range lowest-y 2000)]
                      [(path-height target-area [lowest-x y]) y]))
      highest-path (reduce #(if (> (first %1) (first %2)) %1 %2) valid-paths)]
  (println (first highest-path))
  (println
    (count
      (filter (partial within-target? target-area)
        (let [ys [(second te) (second highest-path)]]
          (for [x (range lowest-x (inc (first te)))
                y (range (apply min ys) (inc (apply max ys)))]
            (last (build-path target-area [x y]))))))))

