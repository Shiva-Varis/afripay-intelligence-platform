CREATE TABLE IF NOT EXISTS transactions (
    transaction_id TEXT PRIMARY KEY,
    sender TEXT NOT NULL,
    receiver TEXT NOT NULL,
    amount NUMERIC(15, 2),
    currency TEXT NOT NULL,
    country TEXT NOT NULL,
    channel TEXT NOT NULL,
    status TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_users (
    user_key SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_country (
    country_key SERIAL PRIMARY KEY,
    country TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_currency (
    currency_key SERIAL PRIMARY KEY,
    currency TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_status (
    status_key SERIAL PRIMARY KEY,
    status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_channel (
    channel_key SERIAL PRIMARY KEY,
    channel TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT,
    month INT,
    day INT,
    day_of_week TEXT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_transactions (
    transaction_id  TEXT PRIMARY KEY,
    sender_key INT NOT NULL REFERENCES dim_users(user_key),
    receiver_key INT NOT NULL REFERENCES dim_users(user_key),
    country_key INT NOT NULL REFERENCES dim_country(country_key),
    currency_key INT NOT NULL REFERENCES dim_currency(currency_key),
    status_key INT NOT NULL REFERENCES dim_status(status_key),
    channel_key INT NOT NULL REFERENCES dim_channel(channel_key),
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    amount NUMERIC(15, 2) NOT NULL,
    time TIME NOT NULL
);