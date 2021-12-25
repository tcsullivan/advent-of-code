(require '[clojure.string :as str])

(defn cucumber-step-east [cuc-map]
  (for [cuc-row cuc-map]
    (let [shifted-cuc (str/replace cuc-row #">\." ".>")]
      (if (and (= \> (last cuc-row)) (= \. (first cuc-row)))
        (-> shifted-cuc
            (str/replace #">$" ".")
            (str/replace #"^\." ">"))
        shifted-cuc))))

(defn cucumber-step-south [cuc-map]
  (let [extra-cuc-map
        (conj (vec (cons (last cuc-map) cuc-map)) (first cuc-map))
        new-extra-cuc-map
        (for [y (reverse (range 1 (count extra-cuc-map)))]
          (str/join
            (for [x (range 0 (count (first cuc-map)))]
              (cond
                (and (= \. (get-in extra-cuc-map [y x])) (= \v (get-in extra-cuc-map [(dec y) x])))
                \v
                (and (= \v (get-in extra-cuc-map [y x])) (= \. (get-in extra-cuc-map [(inc y) x])))
                \.
                :else
                (get-in extra-cuc-map [y x])))))]
    (into [] (reverse (rest new-extra-cuc-map)))))

(defn cucumber-seq [cuc-map-init]
  (iterate (comp cucumber-step-south cucumber-step-east) cuc-map-init))

(def input (->> (slurp "./in")
                (str/split-lines)
                (vec)))

(loop [cuc-hist '() cuc-list (cucumber-seq input)]
  (let [next-cuc (first cuc-list)]
    (if (or (nil? next-cuc) (= (first cuc-hist) next-cuc))
      (println "Cucs are stuck! Steps:" (count cuc-hist))
      (recur (conj cuc-hist next-cuc) (rest cuc-list)))))

