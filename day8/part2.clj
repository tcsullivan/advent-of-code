(require '[clojure.string :as str])
(require '[clojure.set :as set])

(defn find-match
  "
  Searches for digit that `has segs-left` segments remaining
  after the segments of `dig-to-cmp` are removed from the
  digits in `cnts` with `grp-to-cmp` segments.
  "
  [segs-left dig-to-cmp cnts grp-to-cmp]
  (second
    (first
      (filter
        #(-> (second %)
             (str/replace (re-pattern (str/join ["[" dig-to-cmp "]"])) "")
             (count)
             (= segs-left)
             )
        (filterv #(= (first %) grp-to-cmp) cnts)
        )
      )
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
        (assoc $ 3 (find-match 2 ($ 7) counts 5))
        (assoc $ 2 (find-match 3 ($ 4) counts 5))
        (assoc $ 5 (find-match 2 ($ 2) counts 5))
        (assoc $ 0 (find-match 2 ($ 5) counts 6))
        (assoc $ 9 (find-match 2 ($ 4) counts 6))
        (assoc $ 6 (find-match 4 ($ 7) counts 6))
        )
    )
  )

(loop [sum 0]
  (let [rl (read-line)]
    (if (empty? rl)
      (println sum)
      (let [line (as-> rl $
                   (str/split $ #" ")
                   (mapv (comp str/join sort) $)
                   )
            number (subvec line 11 15)
            decoder (set/map-invert (determine-digits line))]
        (recur (->> number
                    (map (comp str decoder))
                    (str/join)
                    (#(Integer/parseInt %))
                    (+ sum)
                    )
               )
        )
      )
    )
  )

