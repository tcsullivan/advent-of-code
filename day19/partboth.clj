(require '[clojure.core.reducers :as r])
(require 'clojure.string)

(defn build-scanner-reports
  "Splits slurped, split-lines'd input by scanner."
  [input-lines]
  (loop [scanners [] rem-input input-lines]
    (if (empty? rem-input)
      scanners
      (let [[this nxt] (split-with (comp not empty?) rem-input)]
        (recur
          (->> (rest this)
               (map #(read-string (clojure.string/join ["[" % "]"])))
               (conj scanners))
          (rest nxt))))))

(defn point-add      [[a b c] [d e f]] [(+ a d) (+ b e) (+ c f)])

(defn orient [[x y z] [[a b c] [d e f] [g h i]]]
  [(+ (* x a) (* y d) (* z g)) (+ (* x b) (* y e) (* z h)) (+ (* x c) (* y f) (* z i))])

(defn scanner-orientation [report or-index]
  (let [or-vec [[[1 0 0]  [0 1 0]  [0 0 1]]
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
                [[0 1 0]  [0 0 -1] [-1 0 0]]]
        chosen (get or-vec or-index)]
    (map #(orient (map - %) chosen) report)))

(defn scanner-orientations
  "Builds list of scanner reports adjusted for all possible orientations."
  [report]
  (for [or-vec [[[1 0 0]  [0 1 0]  [0 0 1]]
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
                [[0 1 0]  [0 0 -1] [-1 0 0]]]]
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
  (let [potential-links (as-> (scanner-build-potential-links s1 s2) $
                              (for [i (range 0 (count $))] [i (nth $ i)]))]
    (filter some?
      (map
        (fn [[orientation link]]
          (let [distinct-points (into [] (distinct (reduce concat link)))
                link-results
                (into '()
                  (r/fold (quot (count distinct-points) 16) r/cat
                    (fn [pcoll point]
                      (if-not (empty? pcoll)
                        pcoll
                        (let [occurrance-count (reduce
                                                 #(cond-> %1
                                                    (not (empty? (filter (partial = point) %2)))
                                                    inc)
                                                 1 link)]
                          (cond-> pcoll (> occurrance-count 11) (r/append! point)))))
                    distinct-points))]
            (when (not (empty? link-results))
              [orientation (first link-results)])))
        (into [] potential-links)))))

(defn scanner-merge
  "Merges the report of linked scanner s2 into scanner s1."
  [s1 s2 s2-or s2-coord]
  (let [s2-ored (scanner-orientation s2 s2-or)]
    (distinct (concat s1 (map #(point-add s2-coord (map - %)) s2-ored)))))

(def reports (->> (slurp "./in")
                  (clojure.string/split-lines)
                  (build-scanner-reports)
                  (vec)))

(let [[beacon-count scanner-coords]
      (loop [new-reps reports sc-coords '([0 0 0]) i (range 1 (count reports))]
        (println "Trying" (first i) (map count new-reps))
        (if (nil? (first i))
          ; reached end (uh oh?)
          [(count new-reps) sc-coords]
          ; scan for links to report i
          (let [found (scanner-find-connection (first new-reps)
                                               (get new-reps (first i)))]
            (if (empty? found)
              ; no match, move to next i
              (recur new-reps sc-coords (rest i))
              (do (println "  Found" found)
              (recur
                (-> new-reps
                  ; replace index zero with merged report
                  (assoc 0 (scanner-merge (first new-reps)
                                          (get new-reps (first i))
                                          (first (first found))
                                          (second (first found))))
                  ; remove report we pulled from
                  (#(concat (subvec % 0 (first i))
                            (subvec % (inc (first i)))))
                  ; back to vector
                  (vec))
                (conj sc-coords (second (first found)))
                ; begin new scan
                (range 1 (count new-reps))))))))]
  (println "Part 1:" beacon-count)
  (println "Part 2:"
    (apply max
      (for [p1 scanner-coords p2 scanner-coords :when (not= p1 p2)]
        (apply + (map #(Math/abs %) (point-add (map - p1) p2)))))))

