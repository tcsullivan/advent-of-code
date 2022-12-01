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
                    (->> (second lst)
                         (drop 1)
                         (map #(-> %
                                   (str/split #"=")
                                   (update 0 (comp {\x 0 \y 1} last))
                                   (update 1 read-string)))
                         ))))))

(defn fold-point [idx chg pt]
  (cond-> pt (> (get pt idx) chg) (update idx #(- % (* 2 (- % chg))))))

(defn print-grid [pts]
  (let [xmax (inc (apply max (map first pts)))
        ymax (inc (apply max (map second pts)))]
    (doseq [y (range 0 ymax)]
      (println
        (str/join
          (for [x (range 0 xmax)] (if (contains? pts [x y]) \@ \ ))
          )))))

; Part 1
(let [instruction (first (second input))]
  (->> (first input)
       (map (partial fold-point (first instruction) (second instruction)))
       (distinct)
       (count)
       (println)))

; Part 2
(print-grid
  (apply
    (partial
      reduce
      #(let [ins (first %2)]
         (set (map (partial fold-point (first %2) (second %2)) %1))))
    input
    ))

