;
; Place in new leiningen 'app' template project
;
; Run with `java -Xmx8G -jar ...`
;

(ns hah.core
  (:gen-class))

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

(defn do-slot [[field q s] idx]
  (let [slot (get field idx)]
    (cond
      ; Moving value out of a room
      (and (seq? slot) (not (empty? slot)) (not (every? #(= % ({2 :a 4 :b 6 :c 8 :d} idx)) slot)))
      (let [open-slots
            (filterv
              #(contains? #{0 1 3 5 7 9 10} %)
              (concat
                (for [i (reverse (range 0 idx)) :while (or (nil? (get field i)) (seq? (get field i)))] i)
                (for [i (range idx (count field)) :while (or (nil? (get field i)) (seq? (get field i)))] i)))]
        (when-not (empty? open-slots)
          (map
            (fn [os]
              [(-> field
                   (assoc os (first slot))
                   (update idx rest))
               (conj q [idx os])
               (+ s (* ({:a 1 :b 10 :c 100 :d 1000} (first slot)) (+ (inc (- 4 (count slot))) (Math/abs (- os idx)))))])
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
               (conj q [idx our-room])
               (+ s (* ({:a 1 :b 10 :c 100 :d 1000} slot) (+ (Math/abs (- idx our-room)) (- 4 (count room)))))])))))))

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
  (into []
    (r/fold
      1024
      r/cat
      #(if-let [t (apply do-slot %2)]
         (if (seq? t)
           (reduce r/append! %1 t)
           (r/append! %1 t))
         %1)
      (into [] (for [f fields i (range 0 11)] [f i])))))

(def wins (atom #{}))

(defn play-games [turns tc]
  (println "Games:" (count turns) "Turn:" tc)
  (if (< 500000 (count turns))
    (do
      (println "Splitting...")
      (doseq [p (partition 100000 turns)
              :let [r (play-games (into [] p) tc)]] nil))
    (do
      (let [new-turns (do-turns turns)
            winners (filter winner? new-turns)]
        (if (pos? (count winners))
          (do
            (println "Winner! Turns:" tc)
            (swap! wins #(reduce conj % (map last winners))))
          (when (pos? (count new-turns))
            (recur new-turns (inc tc))))))))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (play-games [[init-field [] 0]] 0)
  (println (first (sort @wins))))

