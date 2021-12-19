(require '[clojure.core.reducers :as r])
(require 'clojure.string)

(defn build-scanner-reports [input-lines]
  (loop [scanners [] rem-input input-lines]
    (if (empty? rem-input)
      scanners
      (let [[this nxt] (split-with (comp not empty?) rem-input)]
        (recur
          (->> (rest this)
               (map #(read-string (clojure.string/join ["[" % "]"])))
               (conj scanners))
          (rest nxt))))))

(defn all-orientations [[x y z]]
  (map (fn [[i j k]] [(* x i) (* y j) (* z k)])
       '([1 1 1] [-1 1 1] [1 -1 1] [-1 -1 1] [1 1 -1] [-1 1 -1] [1 -1 -1] [-1 -1 -1])))

(defn group-orientations [lst]
  (for [i (range 0 8)] (map #(nth % i) lst)))

(defn scanner-orientations [scanner]
  (group-orientations (map all-orientations scanner)))

(defn add-coordinate [[a b c] [d e f]] [(+ a d) (+ b e) (+ c f)])

(defn add-coordinate-lists [l1 l2]
  (for [i (range 0 (count l1))]
    (for [j (range 0 (count l2))]
      (add-coordinate (nth l1 i) (nth l2 j)))))

(defn compare-scanners [s1 s2]
  (let [o1 [s1];(scanner-orientations s1)
        o2 (scanner-orientations s2)]
    (for [o o1 p o2]
      (add-coordinate-lists o p))))

(defn check-beacon-coord [scanner coord index]
  (not (empty? (filter #(= coord %) (map #(nth % index) scanner)))))

(defn beacon-coord-match? [req coord compared-scanners]
  (let [cnt (count (first (first compared-scanners)))]
    (< (dec req)
       (reduce
         (fn [tot n]
           (cond-> tot
             (and (< tot req)
                  (reduce
                    #(or %1 %2)
                    (map #(check-beacon-coord % coord n) compared-scanners)))
             inc))
         0
         (range 0 cnt)))))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (build-scanner-reports)
     ((fn [scanners]
       (for [s1i  (range 0 (count scanners))
             s2   (drop (inc s1i) scanners)
             :let [res (compare-scanners (nth scanners s1i) s2)]]
         (let [cnt (count (first (first res)))]
           (into '()
             (r/fold
               r/cat
               (fn [final c]
                 (cond-> final
                         (beacon-coord-match? 4 c res)
                         (r/append! c)))
               (into [] (distinct (nth (iterate (partial reduce concat) res) 2)))))))))
     (println))

