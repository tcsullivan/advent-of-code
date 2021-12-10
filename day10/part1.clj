(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 3 \] 57 \} 1197 \> 25137})

(defn check-line [input]
  (loop [in input open '()]
    (cond
      (empty? in)
      nil
      (and (contains? #{\} \) \] \>} (first in))
           (not= (to-closing (first open)) (first in)))
      (first in)
      :else
      (recur
        (rest in)
        (if (contains? #{\{ \( \[ \<} (first in))
          (conj open (first in))
          (rest open)
          )))))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (comp to-score check-line vec))
     (filter some?)
     (apply +)
     (println))

