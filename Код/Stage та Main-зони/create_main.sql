DROP SCHEMA IF EXISTS main CASCADE;

CREATE SCHEMA main;

CREATE TABLE main.dim_date (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL
);

CREATE TABLE main.dim_developer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE main.dim_language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE main.dim_tag (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE main.dim_platform (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE main.dim_game (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    required_age INT NOT NULL,
    achievements INT NOT NULL,
    positive_ratings INT NOT NULL,
    negative_ratings INT NOT NULL,
    average_playtime INT NOT NULL,
    median_playtime INT NOT NULL,
    owners INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    dim_date_id INT NOT NULL REFERENCES main.dim_date(id)
);

CREATE TABLE main.dim_platform_game (
    dim_platform_id INT NOT NULL REFERENCES main.dim_platform(id),
    dim_game_id INT NOT NULL REFERENCES main.dim_game(id),
    PRIMARY KEY (dim_platform_id, dim_game_id)
);

CREATE TABLE main.dim_tag_game (
    dim_tag_id INT NOT NULL REFERENCES main.dim_tag(id),
    dim_game_id INT NOT NULL REFERENCES main.dim_game(id),
    PRIMARY KEY (dim_tag_id, dim_game_id)
);

CREATE TABLE main.dim_developer_game (
    dim_developer_id INT NOT NULL REFERENCES main.dim_developer(id),
    dim_game_id INT NOT NULL REFERENCES main.dim_game(id),
    PRIMARY KEY (dim_developer_id, dim_game_id)
);

CREATE TABLE main.fact_game (
    online INT NOT NULL, 
    price DECIMAL(10, 2), -- NULLABLE because not every game that has online (for date) has price, but every game that has price (for date) has online
    discount INT,
    dim_date_id INT NOT NULL REFERENCES main.dim_date(id),
    dim_game_id INT NOT NULL REFERENCES main.dim_game(id), 
    PRIMARY KEY (dim_date_id, dim_game_id)
);

CREATE TABLE main.fact_review (
    review_id INT PRIMARY KEY, 
    recommended BOOLEAN NOT NULL,
    votes_helpful INT NOT NULL,
    votes_funny INT NOT NULL,
    steam_purchase BOOLEAN NOT NULL,
    playtime_last_two_weeks DECIMAL(10,1) NOT NULL,
    playtime_at_review DECIMAL(10,1) NOT NULL,
    dim_date_id INT NOT NULL REFERENCES main.dim_date(id),
    dim_language_id INT NOT NULL REFERENCES main.dim_language(id),
    dim_game_id INT NOT NULL REFERENCES main.dim_game(id)
);