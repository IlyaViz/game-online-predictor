COPY stage.games (appid, name, release_date, developer, platforms, required_age, steamspy_tags, achievements, positive_ratings, negative_ratings, average_playtime, median_playtime, owners, price)
FROM 'c:/Users/User/Desktop/data/games.csv'
DELIMITER ','
CSV HEADER;

COPY stage.online (appid, Playercount, Date)
FROM 'c:/Users/User/Desktop/data/online.csv'
DELIMITER ','
CSV HEADER;

COPY stage.price (appid, Initialprice, Finalprice, Discount, Date)
FROM 'c:/Users/User/Desktop/data/price.csv'
DELIMITER ','
CSV HEADER;

COPY stage.reviews (app_id, review_id, language, timestamp_created, recommended, votes_helpful, votes_funny, steam_purchase, author_playtime_last_two_weeks, author_playtime_at_review)
FROM 'c:/Users/User/Desktop/data/reviews.csv'
DELIMITER ','
CSV HEADER;