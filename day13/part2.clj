(require '[clojure.string :as str])

(def input (->> (slurp "./in")
                (str/split-lines)
                (split-with not-empty)))
(def points (->> (first input)
                 (map #(str/split % #","))
                 (map (partial map read-string))
                 (set)))
(def folds (->> (rest (second input))
                (map #(str/split % #"="))
                (map #(do [(last (first %)) (read-string (second %))]))))

(defn print-grid [pts]
  (doseq [p pts] (println (str/join [(first p) "," (second p)])))
  )

(loop [fds folds pts points]
  (if (empty? fds)
    (print-grid pts)
    (recur
      (rest fds)
      (let [ins (first fds) chg (second ins)]
        (if (= \x (first ins))
          (reduce
            #(conj %1
               (if (< (first %2) chg)
                 %2
                 (seq [(- (first %2) (* 2 (- (first %2) chg))) (second %2)])))
            #{}
            pts)
          (reduce
            #(conj %1
               (if (< (second %2) chg)
                 %2
                 (seq [(first %2) (- (second %2) (* 2 (- (second %2) chg)))])
                 ))
            #{}
            pts)
          )
        )
      )
    )
  )

