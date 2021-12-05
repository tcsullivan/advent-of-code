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

(defn mark-coord [cmap x y]
  (vec
    (for [c (range 0 (count cmap))]
      (if (= c y)
        (vec
          (for [r (range 0 (count cmap))]
            (if (= r x)
              (inc (get (get cmap c) r))
              (get (get cmap c) r)
              )
            )
          )
        (get cmap c)
        )
      )
    )
  )

(defn mark-coords [cmap x1 y1 x2 y2]
  (cond
    (= y1 y2)
    (loop [cm cmap x (range (min x1 x2) (inc (max x1 x2)))]
      (if (empty? x)
        cm
        (recur
          (mark-coord cm (first x) y1)
          (rest x)
          )
        )
      )
    (= x1 x2)
    (loop [cm cmap y (range (min y1 y2) (inc (max y1 y2)))]
      (if (empty? y)
        cm
        (recur
          (mark-coord cm x1 (first y))
          (rest y)
          )
        )
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
  (loop [cmap (empty-map) coord (read-coords)]
    (if (empty? coord)
      cmap
      (recur
        (apply (partial mark-coords cmap) coord)
        (read-coords)
        )
      )
    )
  )

(->> finished-map
    (flatten)
    (map dec)
    (filter pos?)
    (count)
    (println)
    )

