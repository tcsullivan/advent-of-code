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
                         (first)
                         ))))))

(defn fold-point [idx chg pt]
  (cond-> pt (> (get pt idx) chg) (update idx #(- % (* 2 (- % chg))))))

(let [instruction (second input)]
  (->> (first input)
       (map (partial fold-point (first instruction) (second instruction)))
       (distinct)
       (count)
       (println)))

