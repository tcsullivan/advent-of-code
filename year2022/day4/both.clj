(defn within [n b e] (and (>= n b) (<= n e)))

(defn part1pred [lst]
  (or (and (>= (nth lst 0) (nth lst 2)) (<= (nth lst 1) (nth lst 3)))
      (and (>= (nth lst 2) (nth lst 0)) (<= (nth lst 3) (nth lst 1)))))

(defn part2pred [lst]
  (or (within (nth lst 0) (nth lst 2) (nth lst 3))
      (within (nth lst 1) (nth lst 2) (nth lst 3))
      (within (nth lst 2) (nth lst 0) (nth lst 1))
      (within (nth lst 3) (nth lst 0) (nth lst 1))))

(def count-filtered (comp println count filter))

(def elf-pairs
  (->> (slurp "input")
       (#(clojure.string/split % #"[^\d]"))
       (map read-string)
       (partition 4)))

(count-filtered part1pred elf-pairs)
(count-filtered part2pred elf-pairs)

