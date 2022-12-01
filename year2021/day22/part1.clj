(require '[clojure.string :as str])

(def input (->> (slurp "./in")
                (str/split-lines)
                (map
                  (fn [line]
                    [(if (str/starts-with? line "on") true false)
                     (->> (str/split line #"[^-\d]+")
                          (rest)
                          (map #(Integer/parseInt %))
                          (partition 2))]))))

(println
  (frequencies
    (vals
      (reduce
        (fn [cmap c]
          (into cmap
            (let [[xx yy zz] (second c)]
              (for [x (range (max -50 (first xx)) (inc (min 50 (second xx))))
                    y (range (max -50 (first yy)) (inc (min 50 (second yy))))
                    z (range (max -50 (first zz)) (inc (min 50 (second zz))))]
                [[x y z] (first c)]))))
        {} input))))

