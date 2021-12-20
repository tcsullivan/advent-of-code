(require '[clojure.core.reducers :as r])
(require 'clojure.string)

(def orientation-vectors
  [[[1 0 0]  [0 1 0]  [0 0 1]]
   [[1 0 0]  [0 0 -1] [0 1 0]]
   [[1 0 0]  [0 -1 0] [0 0 -1]]
   [[1 0 0]  [0 0 1]  [0 -1 0]]
   [[-1 0 0] [0 -1 0] [0 0 1]]
   [[-1 0 0] [0 0 -1] [0 -1 0]]
   [[-1 0 0] [0 1 0]  [0 0 -1]]
   [[-1 0 0] [0 0 1]  [0 1 0]]
   [[0 0 -1] [1 0 0]  [0 -1 0]]
   [[0 1 0]  [1 0 0]  [0 0 -1]]
   [[0 0 1]  [1 0 0]  [0 1 0]]
   [[0 -1 0] [1 0 0]  [0 0 1]]
   [[0 0 1]  [-1 0 0] [0 -1 0]]
   [[0 1 0]  [-1 0 0] [0 0 1]]
   [[0 0 -1] [-1 0 0] [0 1 0]]
   [[0 -1 0] [-1 0 0] [0 0 -1]]
   [[0 -1 0] [0 0 -1] [1 0 0]]
   [[0 0 1]  [0 -1 0] [1 0 0]]
   [[0 1 0]  [0 0 1]  [1 0 0]]
   [[0 0 -1] [0 1 0]  [1 0 0]]
   [[0 0 1]  [0 1 0]  [-1 0 0]]
   [[0 -1 0] [0 0 1]  [-1 0 0]]
   [[0 0 -1] [0 -1 0] [-1 0 0]]
   [[0 1 0]  [0 0 -1] [-1 0 0]]])

(defn build-scanner-reports
  "Splits slurped, split-line'd input by scanner."
  [input-lines]
  (loop [scanners [] rem-input input-lines]
    (if (empty? rem-input)
      scanners
      (let [[this nxt] (split-with (comp not empty?) rem-input)]
        (recur (->> (rest this)
                    (map #(read-string (clojure.string/join ["[" % "]"])))
                    (conj scanners))
               (rest nxt))))))

(defn point-add [[a b c] [d e f]] [(+ a d) (+ b e) (+ c f)])

(defn orient [[x y z] [[a b c] [d e f] [g h i]]]
  [(+ (* x a) (* y d) (* z g)) (+ (* x b) (* y e) (* z h)) (+ (* x c) (* y f) (* z i))])

(defn scanner-orientation [report or-index]
  (map #(orient (map - %) (get orientation-vectors or-index)) report))

(defn scanner-orientations
  "Builds list of scanner reports adjusted for all possible orientations."
  [report]
  (for [or-vec orientation-vectors]
    (map #(orient (map - %) or-vec) report)))

(defn scanner-build-potential-links
  "Builds a list for each s2 orientation that contains lists of each s1 point
   added to the corresponding s2 point."
  [s1 s2]
  (for [s2-or (scanner-orientations s2)]
    (for [i (range 0 (count s1))]
      (for [j (range 0 (count s2-or))]
        (point-add (nth s1 i) (nth s2-or j))))))

(defn scanner-find-connection
  "Attempt to determine if s1 and s2 are linked through common beacons."
  [s1 s2]
  (loop [potential-links (as-> (scanner-build-potential-links s1 s2) $
                               (for [i (range 0 (count $))] [i (nth $ i)])
                               (into [] $))]
    (when-let [[orientation link] (first potential-links)]
      (if-let [match (first (drop-while #(< (val %) 12) (frequencies (reduce concat link))))]
        [orientation (key match)]
        (recur (rest potential-links))))))

(defn scanner-merge
  "Merges the report of linked scanner s2 into scanner s1."
  [s1 s2 s2-or s2-coord]
  (vec (into (set s1) (map #(point-add s2-coord (map - %)) (scanner-orientation s2 s2-or)))))

(let [[beacon-count scanner-coords]
      (loop [new-reps  (->> (slurp "./in") clojure.string/split-lines build-scanner-reports)
             sc-coords '([0 0 0])
             next-reps (rest new-reps)]
        (if-let [next-rep (first next-reps)]
          (if-let [[found-or found-coord] (scanner-find-connection (first new-reps) next-rep)]
            (let [new-base    (scanner-merge (first new-reps) next-rep found-or found-coord)
                  newest-reps (->> (assoc new-reps 0 new-base) (filterv (partial not= next-rep)))]
              (println "found" found-coord)
              (recur newest-reps (conj sc-coords found-coord) (rest newest-reps)))
            (recur new-reps sc-coords (rest next-reps)))
          [(count (first new-reps)) sc-coords]))]
  (println "Part 1:" beacon-count)
  (println "Part 2:"
    (apply max
      (for [p1 scanner-coords p2 scanner-coords :when (not= p1 p2)]
        (apply + (map #(Math/abs %) (point-add (map - p1) p2)))))))

