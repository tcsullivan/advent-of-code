(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 1 \] 2 \} 3 \> 4})

(defn check-line [input]
  (loop [open [] in input]
    (cond
      (empty? in)
      (map to-closing open)
      (and (contains? #{\} \) \] \>} (first in))
           (not= (to-closing (first open)) (first in)))
      nil
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
     (mapv (partial reduce #(+ (* 5 %1) (to-score %2)) 0))
     (sort)
     (#(get (vec %) (quot (count %) 2)))
     (println)
     )

