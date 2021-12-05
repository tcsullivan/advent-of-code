(require '[clojure.string :as str])

(defn read-coords []
  (let [line (read-line)]
    (when (not (empty? line))
      (mapv
        #(Integer/parseInt %)
        (str/split
          line
          #"[^\d]+"
          )
        )
      )
    )
  )

(defn read-all-coords []
  (loop [cds [] c (read-coords)]
    (if (empty? c)
      cds
      (recur
        (conj cds c)
        (read-coords)
        )
      )
    )
  )

(defn mark-coord [cmap x y]
  (update cmap y #(update % x inc))
  )

(defn mark-coords [cmap x1 y1 x2 y2]
  (cond
    (= y1 y2)
    (reduce
      #(mark-coord %1 %2 y1)
      cmap
      (range (min x1 x2) (inc (max x1 x2)))
      )
    (= x1 x2)
    (reduce
      #(mark-coord %1 x1 %2)
      cmap
      (range (min y1 y2) (inc (max y1 y2)))
      )
    :else
    cmap
    )
  )

(defn empty-map []
  (vec
    (repeat 1000
      (vec (repeat 1000 0))
      )
    )
  )

(def finished-map
  (reduce
    #(apply (partial mark-coords %1) %2)
    (empty-map)
    (read-all-coords)
    )
  )

(->> finished-map
    (flatten)
    (map dec)
    (filter pos?)
    (count)
    (println)
    )

