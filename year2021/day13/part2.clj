(require '[clojure.string :as str])

(def input (->> (slurp "./in")
                (str/split-lines)
                (split-with not-empty)
                ((juxt
                  (fn [lst]
                    (reduce
                      #(conj %1 (mapv read-string (str/split %2 #",")))
                      #{} (first lst)))
                  (fn [lst]
                    (->> (rest (second lst))
                         (map #(-> %
                                   (str/split #"=")
                                   (update 0 (comp {\x 0 \y 1} last))
                                   (update 1 read-string)))
                         ))))))

(defn print-grid [pts]
  (doseq [p pts] (println (str/join [(first p) "," (second p)]))))

(defn fold-point [idx chg pt]
  (cond-> pt (> (get pt idx) chg) (update idx #(- % (* 2 (- % chg))))))

(print-grid
  (apply
    (partial
      reduce
      #(let [ins (first %2)]
         (set (map (partial fold-point (first %2) (second %2)) %1))))
    input
    ))

