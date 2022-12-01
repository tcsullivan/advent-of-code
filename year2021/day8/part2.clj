(require '[clojure.string :as str])
(require '[clojure.set :as set])

(defn find-match
  "
  Searches for digit that `has segs-left` segments remaining
  after the segments of `dig-to-cmp` are removed from the
  digits in `cnts` with `grp-to-cmp` segments.
  "
  [segs-left dig-to-cmp cnts grp-to-cmp]
  (as-> cnts $
    (filterv #(= (first %) grp-to-cmp) $)
    (filterv
      #(-> (second %)
           (str/replace (re-pattern (str/join ["[" dig-to-cmp "]"])) "")
           (count)
           (= segs-left)
           )
      $
      )
    (get-in $ [0 1])
    )
  )

(defn determine-digits [line]
  (let [counts (mapv #(do [(count %) %]) (take 10 line))
        mcounts (into {} counts)]
    (as-> {} $
        (assoc $ 1 (mcounts 2)
                 4 (mcounts 4)
                 7 (mcounts 3)
                 8 (mcounts 7)
                 )
        (assoc $ 3 (find-match 2 ($ 7) counts 5)
                 6 (find-match 4 ($ 7) counts 6)
                 2 (find-match 3 ($ 4) counts 5)
                 9 (find-match 2 ($ 4) counts 6)
                 )
        (assoc $ 5 (find-match 2 ($ 2) counts 5))
        (assoc $ 0 (find-match 2 ($ 5) counts 6))
        )
    )
  )

(println
  (reduce
    (fn [sum input]
      (let [line (as-> input $
                   (str/split $ #" ")
                   (mapv (comp str/join sort) $)
                   )
            number (subvec line 11 15)
            decoder (set/map-invert (determine-digits line))]
        (->> number
             (map (comp str decoder))
             (str/join)
             (#(Integer/parseInt %))
             (+ sum)
             )
        )
      )
    0
    (str/split-lines (slurp "./in"))
    )
  )

