;
;
; Put into a lein project so that you can pass Java more RAM (e.g. -Xmx15G)
; https://www.reddit.com/r/adventofcode/comments/riqtwx/2021_day_17_day_17_part_3/
;
;

(require '[clojure.core.reducers :as r])

(def target-area [[20000 -5000] [30000 -10000]])
(def initial-pos [0 0])

(defn beyond-target? [[[tbx tby] [tex tey]] [x y]]
  (or (> x tex) (< y tey)))

(defn within-target? [[[tbx tby] [tex tey]] [x y]]
  (and (>= x tbx) (<= x tex) (<= y tby) (>= y tey)))

(defn apply-velocity [[[px py] [vx vy]]]
  [[(+ px vx) (+ py vy)] [(cond-> vx (pos? vx) dec) (dec vy)]])

(defn take-last-while [pred coll]
  (loop [v (first coll) r (rest coll)]
    (if (not (pred (first r)))
      v
      (recur (first r) (rest r)))))

(defn build-path [target vel]
  (->> (iterate apply-velocity [initial-pos vel])
       (take-last-while (comp not (partial beyond-target? target) first))
       (first)))

; Used to determine best x velocity for highest path
(def tnum-seq (iterate #(do [(apply + %) (inc (second %))]) [0 1]))

(let [[tb te]      target-area
      lowest-x     (second (last (take-while #(< (first %) (first tb)) tnum-seq)))
      highest-y    (dec (Math/abs (second te)))]
  (->> (for [y (range (second te) (inc highest-y))
             x (range lowest-x (inc (first te)))] [x y])
       (#(do (println "Generated xy pairs...") %))
       (#(do (println "Total: " (* (- highest-y (second te)) (- (inc highest-y) lowest-x))) %))
       (partition 1000000)
       (#(do (println "Prepared partitions...") %))
       (reduce
          (fn [sum nlst]
            (println sum)
            (+ sum
              (r/fold +
                (r/monoid
                  (fn [tot xy]
                    (cond-> tot
                      (within-target? target-area (build-path target-area xy))
                      inc))
                  (constantly 0))
                (into [] nlst))))
           0)
       (println)))

