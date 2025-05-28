(deftemplate tariff
    (slot id (type INTEGER))
    (slot name (type STRING))
    (slot price (type NUMBER))
    (slot internet (allowed-symbols unlimited) (type SYMBOL NUMBER))
    (slot calls (allowed-symbols unlimited) (type SYMBOL NUMBER))
    (slot sms (type SYMBOL NUMBER))
)

(deffacts tariffs
    (tariff (id 1) (name "Безлимитный") (price 500) (internet unlimited) (calls unlimited) (sms unlimited))
    (tariff (id 2) (name "Эконом") (price 200) (internet 5) (calls 200) (sms 50))
    (tariff (id 3) (name "Минимум") (price 100) (internet 1) (calls 50) (sms 20))
    (tariff (id 4) (name "Супернет") (price 350) (internet 30) (calls unlimited) (sms 100))
)

; Поиск по цене
(defrule recommend_by_price
    (need price ?p&:(> ?p 0))
    (tariff (id ?id) (name ?name) (price ?price_val))
    (test (<= ?price_val ?p))
    =>
    (assert (recommend tariff_id ?id))
    (printout t "DEBUG: Проверяю тариф " ?name ", цена: " ?price_val ", бюджет: " ?p crlf)
    (printout t "✅ Рекомендуется тариф: " ?name " (по цене)" crlf)
)