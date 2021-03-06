(require '[clojure.core.reducers :as r])

(def init-field
  [nil
   nil
   (seq [:b :d :d :d])
   nil
   (seq [:b :c :b :a])
   nil
   (seq [:c :b :a :a])
   nil
   (seq [:d :a :c :c])
   nil
   nil])

(defn do-slot [[field energy] idx]
  (let [slot (get field idx)]
    (cond
      ; Moving value out of a room
      (and (seq? slot)
           (not (empty? slot))
           (not (every? #(= % ({2 :a 4 :b 6 :c 8 :d} idx)) slot)))
      (let [open-slots
            (filterv
              #(contains? #{0 1 3 5 7 9 10} %)
              (concat
                (for [i (reverse (range 0 idx))
                      :while (or (nil? (get field i)) (seq? (get field i)))] i)
                (for [i (range idx (count field))
                      :while (or (nil? (get field i)) (seq? (get field i)))] i)))]
        (when-not (empty? open-slots)
          (map
            (fn [os]
              [(-> field
                   (assoc os (first slot))
                   (update idx rest))
               (+ energy (* ({:a 1 :b 10 :c 100 :d 1000} (first slot))
                            (+ (inc (- 4 (count slot))) (Math/abs (- os idx)))))])
            open-slots)))
      ; Moving value into a room
      (and (not (seq? slot)) (some? slot))
      (let [our-room ({:a 2 :b 4 :c 6 :d 8} slot)]
        (if (every? #(or (nil? (get field %)) (seq? (get field %)))
                    (range (inc (min our-room idx)) (max our-room idx)))
          (let [room (get field our-room)]
            (when (or (empty? room) (every? #(= slot %) room))
              [(-> field
                   (assoc idx nil)
                   (update our-room conj slot))
               (+ energy (* ({:a 1 :b 10 :c 100 :d 1000} slot)
                            (+ (Math/abs (- idx our-room)) (- 4 (count room)))))])))))))

(defn winner? [[field q s]]
  (= field
    [nil
     nil
     (seq [:a :a :a :a])
     nil
     (seq [:b :b :b :b])
     nil
     (seq [:c :c :c :c])
     nil
     (seq [:d :d :d :d])
     nil
     nil]))

(defn do-turns [fields]
  (into #{}
    (r/fold
      r/cat
      #(if-let [t (apply do-slot %2)]
         (if (seq? t)
           (reduce r/append! %1 t)
           (r/append! %1 t))
         %1)
      (into [] (for [f fields i (range 0 11)] [f i])))))

(defn play-games [turns tc]
  (println "Games:" (count turns) "Turn:" tc)
  (let [new-turns (do-turns turns)
        winners (filter winner? new-turns)]
    (if (seq winners)
      (map second winners)
      (recur new-turns (inc tc)))))

(->> (play-games #{[init-field 0]} 0)
     sort
     first
     ((partial println "Lowest energy:")))

