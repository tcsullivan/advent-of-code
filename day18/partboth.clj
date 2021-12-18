(require '[clojure.core.reducers :as r])
(require '[clojure.set :as set])
(require '[clojure.zip :as z])

(defn zip-depth [loc]
  (loop [l loc d 0] (if (nil? l) d (recur (z/up l) (inc d)))))

(defn zip-prev-num [loc]
  (loop [l loc]
    (if-let [prev (z/prev l)]
      (if (not (z/branch? prev))
        prev
        (recur prev)))))

(defn zip-next-num [loc]
  (loop [l loc]
    (if-let [nxt (z/next l)]
      (if (not (z/branch? nxt))
        (when (some? (z/node nxt)) nxt)
        (recur nxt)))))

(defn snailfish-explode [tree]
  (loop [node (z/vector-zip tree)]
    (if (z/end? node)
      node
      (if (and (z/branch? node)
               (= 2 (count (z/children node)))
               (and (not (z/branch? (z/down node))) (not (z/branch? (z/next (z/down node)))))
               (> (zip-depth node) 5))
        (let [children (z/children node)
              nnode    (z/replace node 0)]
          (if-let [prev (zip-prev-num nnode)]
            (z/root
              (let [new-prev (z/edit prev + (first children))]
                (if-let [nxt (nth (iterate zip-next-num new-prev) 2)]
                  (z/edit nxt + (second children))
                  new-prev)))
            (when-let [nxt (zip-next-num nnode)]
              (z/root (z/edit nxt + (second children))))))
        (recur (z/next node))))))

(defn snailfish-split [tree]
  (loop [node (z/vector-zip tree)]
    (if (or (z/end? node) (nil? (z/node node)))
      node
      (if (and (not (z/branch? node)) (> (z/node node) 9))
        (z/root
          (z/replace node
            (z/make-node node (z/node node)
              (map long [(Math/floor (/ (z/node node) 2))
                         (Math/ceil (/ (z/node node) 2))]))))
        (recur (z/next node))))))

(defn snailfish-magnitude [ntree]
    (if (= 2 (count (z/children ntree)))
      (let [cl (z/down ntree) cr (z/right cl)]
        (+ (* 3 (if (z/branch? cl) (snailfish-magnitude cl) (z/node cl)))
           (* 2 (if (z/branch? cr) (snailfish-magnitude cr) (z/node cr)))))
      (loop [node (z/down ntree) sum 0]
        (if (nil? node)
          sum
          (recur (z/right node)
                 (+ sum (if (z/branch? node) (snailfish-magnitude node) (z/node node))))))))

(defn snailfish-solve [add-list]
  (snailfish-magnitude
    (loop [result     (z/vector-zip (vec (take 2 add-list)))
           next-input (drop 2 add-list)]
      (let [explode (snailfish-explode result)]
        (if (nil? (second explode))
          (recur explode next-input)
          (let [splt (snailfish-split result)]
            (if (nil? (second splt))
              (recur splt next-input)
              (if (empty? next-input)
                result
                (recur (z/vector-zip
                         [(vec (z/children result)) (first next-input)])
                       (rest next-input))))))))))

; Build input list
(def input (->> (slurp "./in")
                clojure.string/split-lines
                (map read-string)))

; Part 1
(println (snailfish-solve input))

; Part 2
(->> (for [in input in2 input :when (not= in in2)] [in in2])
     (vec)
     (r/map snailfish-solve)
     (r/fold (r/monoid max (constantly 0)))
     (println))

