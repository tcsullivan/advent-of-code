(require '[clojure.core.reducers :as r])
(require '[clojure.string :as str])

(def input (->> (slurp "./in")
                (str/split-lines)
                (map
                  (fn [line]
                    [(if (str/starts-with? line "on") true false)
                     (->> (str/split line #"[^-\d]+")
                          (rest)
                          (map #(Integer/parseInt %))
                          (partition 2)
                          (mapv vec))]))
                (reverse)))

(defn build-coord-list [coords idx]
  (->> coords
       (map #(update (get (second %) idx) 1 inc))
       (flatten)
       (sort)
       (vec)))

(defn filter-coord-list [coords idx v]
  (filter
    #(let [[p0 p1] (get (second %) idx)]
       (and (<= p0 v) (<= v p1)))
    coords))

(def xs (build-coord-list input 0))
(def ys (build-coord-list input 1))
(def zs (build-coord-list input 2)) 

(defonce on-count (atom 0))

(loop [x xs]
  (when-not (empty? (rest x))
    (println "x=" (first x))
    (let [inputx (filter-coord-list input 0 (first x))]
      (swap! on-count +
        (r/fold
          32
          +
          (fn [onc2 iy]
            (let [inputy (filter-coord-list inputx 1 (get ys iy))]
              (+ onc2
                (reduce
                  (fn [onc iz]
                    (let [inputz (first (filter-coord-list inputy 2 (get zs iz)))]
                      (cond-> onc
                        (first inputz)
                        (+ (* (- (second x) (first x))
                              (- (get ys (inc iy)) (get ys iy))
                              (- (get zs (inc iz)) (get zs iz)))))))
                  0
                  (range 0 (dec (count zs)))))))
          (into [] (range 0 (dec (count ys))))))
      (recur (rest x)))))

(println @on-count)

