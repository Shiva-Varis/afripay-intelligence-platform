INSERT INTO dim_users(full_name)
SELECT DISTINCT full_name
FROM (
	SELECT sender AS full_name FROM transactions
	UNION
	SELECT receiver AS full_name FROM transactions
);

INSERT INTO dim_country(country)
SELECT DISTINCT country
FROM transactions;

INSERT INTO dim_currency(currency)
SELECT DISTINCT currency
FROM transactions;

INSERT INTO dim_status(status)
SELECT DISTINCT status
FROM transactions;

INSERT INTO dim_channel(channel)
SELECT DISTINCT channel
FROM transactions;

INSERT INTO dim_date(date_key, full_date, year, month, day, day_of_week, is_weekend)
SELECT
	TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_key,
	d AS full_date,
	EXTRACT(YEAR FROM d)::INTEGER AS year,
	EXTRACT(MONTH FROM d)::INTEGER AS month,
	EXTRACT(DAY FROM d)::INTEGER AS day,
	TO_CHAR(d, 'Day') AS day_of_week,
	CASE WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series('2020-01-01'::date, '2030-12-31'::date, '1 day'::interval) AS d;

INSERT INTO fact_transactions(transaction_id, sender_key, receiver_key, country_key, currency_key, status_key, channel_key, date_key, amount, time)
SELECT t.transaction_id, s.user_key, r.user_key, c.country_key, cu.currency_key, st.status_key, ch.channel_key, d.date_key, t.amount, t.timestamp::time
FROM transactions t
JOIN dim_users s ON t.sender = s.full_name
JOIN dim_users r ON t.receiver = r.full_name
JOIN dim_country c ON t.country = c.country
JOIN dim_currency cu ON t.currency = cu.currency
JOIN dim_status st ON t.status = st.status
JOIN dim_channel ch ON t.channel = ch.channel
JOIN dim_date d ON t.timestamp::date = d.full_date;

SELECT * FROM fact_transactions;