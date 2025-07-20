CREATE DATABASE data_analysis;

DROP SCHEMA IF EXISTS stage CASCADE;

CREATE SCHEMA stage;

CREATE TABLE stage.games (
    appid BIGINT,
    name VARCHAR(255),
    release_date DATE,
    developer VARCHAR(255),
    platforms VARCHAR(255),
    required_age BIGINT,
    steamspy_tags VARCHAR(255),
    achievements BIGINT,
    positive_ratings BIGINT,
    negative_ratings BIGINT,
    average_playtime BIGINT,
    median_playtime BIGINT,
    owners BIGINT,
    price DECIMAL(10, 2)
);

CREATE TABLE stage.online (
    appid BIGINT,
    Playercount BIGINT,
    Date DATE
);

CREATE TABLE stage.price (
    appid BIGINT,
    Initialprice DECIMAL(10, 2),
    Finalprice DECIMAL(10, 2),
    Discount BIGINT,
    Date DATE
);

CREATE TABLE stage.reviews (
    app_id BIGINT,
    review_id BIGINT,
    language VARCHAR(255),
    timestamp_created DATE,
    recommended BOOLEAN,
    votes_helpful BIGINT,
    votes_funny BIGINT,
    steam_purchase BOOLEAN,
    author_playtime_last_two_weeks DECIMAL(10, 1),
    author_playtime_at_review DECIMAL(10, 1)
);