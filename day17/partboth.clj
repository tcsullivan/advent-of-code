(def target-area [[169 -68] [206 -108]])
;(def target-area [[20 -5] [30 -10]])
(def initial-pos [0 0])

(defn beyond-target? [[[tbx tby] [tex tey]] [x y]]
  (or (> x tex) (< y tey)))

(defn within-target? [[[tbx tby] [tex tey]] [x y]]
  (and (>= x tbx) (<= x tex) (<= y tby) (>= y tey)))

(defn apply-velocity [[[px py] [vx vy]]]
  [[(+ px vx) (+ py vy)] [(cond-> vx (pos? vx) dec) (dec vy)]])

(defn build-path [target vel]
  (->> (iterate apply-velocity [initial-pos vel])
       (take-while (comp not (partial beyond-target? target) first))
       (mapv first)))

(defn path-height [target vel]
  (let [path (build-path target vel)]
    (when (within-target? target (last path))
      (apply max (map second path)))))

; Used to determine best x velocity for highest path
(def tnum-seq (iterate #(do [(apply + %) (inc (second %))]) [0 1]))

(let [[tb te]      target-area
      lowest-x     (second (last (take-while #(< (first %) (first tb)) tnum-seq)))
      highest-y    (dec (Math/abs (second te)))]
  (println
    (path-height target-area [lowest-x highest-y])
    (count
      (filter (partial within-target? target-area)
        (for [x (range lowest-x (inc (first te)))
              y (range (second te) (inc highest-y))]
          (last (build-path target-area [x y])))))))

