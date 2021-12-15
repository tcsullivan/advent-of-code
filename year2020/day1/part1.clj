(require 'clojure.set)

(->> (slurp "./in")
     clojure.string/split-lines
     (map read-string)
     ((juxt set (comp set #(map (partial - 2020) %))))
     (apply clojure.set/intersection)
     (apply *)
     (println))
