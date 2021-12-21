(require '[clojure.string :as str])

(defn pad-input-map [in-map pad-val]
  (let [ly (count in-map) lx (count (first in-map))
        sy (+ 4 ly) sx (+ 4 lx)
        buffer (byte-array (repeat (* sy sx) pad-val))]
    (doseq [y (range 0 ly) x (range 0 lx)]
      (aset-byte buffer (+ (* sx (+ 2 y)) 2 x) (get-in in-map [y x])))
    (mapv vec (partition sx buffer))))

(defn get-number [in-map y x]
  (map (partial get-in in-map)
       [[(dec y) (dec x)] [(dec y) x] [(dec y) (inc x)]
        [y (dec x)]       [y x]       [y (inc x)]
        [(inc y) (dec x)] [(inc y) x] [(inc y) (inc x)]]))

(defn get-new-pixel [enhance-algo in-map y x]
  (->> (get-number in-map y x)
       (reduce #(cond-> (* 2 %1) (= 1 %2) inc) 0)
       (get enhance-algo)))

(defn build-output-number-map [enhance-algo in-map]
  (let [pad-val (if (pos? (first enhance-algo)) (first (first in-map)) 0)
        padded-in-map (pad-input-map in-map pad-val)]
    (->> (for [y (range 1 (dec (count padded-in-map)))]
           (future
             (mapv (partial get-new-pixel enhance-algo padded-in-map y)
                   (range 1 (dec (count (first padded-in-map)))))))
         (mapv deref))))

(defn count-lit-pixels [in-map] ((frequencies (flatten in-map)) 1))

(let [[enhance-algo in-map]
      (->> (slurp "./in")
           str/split-lines
           ((juxt (comp (partial mapv {\. 0 \# 1}) first)
                  (comp (partial mapv #(mapv {\. 0 \# 1} %)) (partial drop 2)))))
      image-output (iterate (partial build-output-number-map enhance-algo) in-map)]
  (println "Part 1:" (count-lit-pixels (nth image-output 2)))
  (println "Part 2:" (count-lit-pixels (nth image-output 50))))

(shutdown-agents)

