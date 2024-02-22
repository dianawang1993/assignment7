SELECT * FROM card_holder;
SELECT * FROM credit_card;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transaction;

---Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.
---How can you isolate (or group) the transactions of each cardholder?
SELECT card_holder.name AS "Card Holder", COUNT(transaction.id) AS "Transactions" 
FROM transaction 
JOIN credit_card ON credit_card.card = transaction.card 
JOIN card_holder ON card_holder.id =credit_card.id_card_holder
GROUP BY "Card Holder" 
ORDER BY "Transactions" DESC;
---Count the transactions that are less than $2.00 per cardholder.
SELECT card AS "Card Number", COUNT(amount) AS "Count of Sub $2 Transactions"
FROM transaction
WHERE amount < 2.00
GROUP BY card
ORDER BY "Count of Sub $2 Transactions" DESC;
---Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.

---What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT id, amount, date :: timestamp :: date AS "Date", date :: timestamp :: time AS "Time"
FROM transaction
WHERE date :: timestamp :: time > '07:00:00' AND date :: timestamp :: time < '09:00:00'
ORDER BY amount DESC
LIMIT 100;

---Do you see any anomalous transactions that could be fraudulent?
SELECT id, amount, date :: timestamp :: date AS "Date", date :: timestamp :: time AS "Time"
FROM transaction
WHERE amount < 2 AND date :: timestamp :: time > '07:00:00' AND date :: timestamp :: time < '09:00:00'
ORDER BY amount DESC;

---Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
---If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
SELECT *
FROM transaction
WHERE amount < 2 AND date :: timestamp :: time > '07:00:00' AND date :: timestamp :: time < '09:00:00';

---What are the top 5 merchants prone to being hacked using small transactions?
SELECT merchant.name, COUNT(transaction.id_merchant) AS "Number of Transactions"
FROM transaction
JOIN merchant ON transaction.id_merchant  = merchant.id
WHERE transaction.amount < 2
GROUP BY merchant.name
ORDER BY "Number of Transactions" DESC
LIMIT 5;

---The two most important customers of the firm may have been hacked. Verify if there are any fraudulent transactions in their history. For privacy reasons, you only know that their cardholder IDs are 2 and 18.

SELECT card_holder.id AS "cardholder", transaction.date AS "hour",  transaction.amount AS "amount"
FROM transaction
JOIN credit_card on credit_card.card = transaction.card
JOIN card_holder on card_holder.id = credit_card.id_card_holder
WHERE card_holder.id = 2 or card_holder.id = 18;

SELECT EXTRACT(MONTH FROM transaction.date) AS "month", EXTRACT(DAY FROM transaction.date) AS "day", transaction.amount AS "amount"
FROM transaction
JOIN credit_card on credit_card.card = transaction.card
JOIN card_holder on card_holder.id = credit_card.id_card_holder
WHERE card_holder.id = 25 
AND  EXTRACT(MONTH FROM transaction.date) <= 6;

SELECT card_holder.id AS "cardholder", transaction.date AS "hour",  transaction.amount AS "amount"
FROM transaction
JOIN credit_card on credit_card.card = transaction.card
JOIN card_holder on card_holder.id = credit_card.id_card_holder;

