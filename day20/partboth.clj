(require '[clojure.string :as str])

(defn pad-input-map [in-map pad-val]
  (let [pad-row (repeat (+ 4 (count (first in-map))) pad-val)
        pad-side (repeat 2 pad-val)]
    (mapv vec
      (concat
        [pad-row pad-row]
        (mapv #(concat pad-side % pad-side) in-map)
        [pad-row pad-row]))))

(defn get-number [in-map y x]
  (concat (subvec (get in-map (dec y)) (dec x) (+ 2 x))
          (subvec (get in-map y) (dec x) (+ 2 x))
          (subvec (get in-map (inc y)) (dec x) (+ 2 x))))

(defn get-new-pixel [enhance-algo in-map y x]
  (->> (get-number in-map y x)
       str/join
       (#(Integer/parseInt % 2))
       (get enhance-algo)
       {\. 0 \# 1}))

(defn build-output-number-map [enhance-algo in-map]
  (let [pad-val (if (= \# (first enhance-algo)) (first (first in-map)) 0)
        padded-in-map (pad-input-map in-map pad-val)]
    (for [y (range 1 (dec (count padded-in-map)))]
      (for [x (range 1 (dec (count (first padded-in-map))))]
        (get-new-pixel enhance-algo padded-in-map y x)
        ))))

(defn count-lit-pixels [in-map]
  ((frequencies (flatten in-map)) 1))

(let [[enhance-algo in-map]
      (->> (slurp "./in")
           str/split-lines
           ((juxt
           first
           (comp (partial mapv #(mapv {\. 0 \# 1} %))
                 (partial drop 2)))))
      image-output (iterate (partial build-output-number-map enhance-algo) in-map)]
  (println (count-lit-pixels (nth image-output 50))))

