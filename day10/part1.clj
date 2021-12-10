(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 3 \] 57 \} 1197 \> 25137})

(defn check-line [input]
  (loop [in input open '()]
    (when-let [c (first in)]
      (if (some->> (#{\} \) \] \>} c) (not= (first open)))
        c
        (recur
          (rest in)
          (if-let [op (to-closing c)]
            (conj open op)
            (rest open)
            ))))))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (comp to-score check-line vec))
     (filter some?)
     (apply +)
     (println))

