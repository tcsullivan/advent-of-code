(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 3 \] 57 \} 1197 \> 25137})

(defn check-line [input]
  (loop [open [] in input]
    (cond
      (empty? in)
      nil
      (and (contains? #{\} \) \] \>} (first in))
           (not= (to-closing (first open)) (first in)))
      (first in)
      :else
      (recur
        (if (contains? #{\{ \( \[ \<} (first in))
          (concat [(first in)] open)
          (rest open))
        (rest in)
        ))))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (mapv vec)
     (mapv check-line)
     (filter some?)
     (mapv to-score)
     (apply +)
     (println))

