CREATE OR REPLACE PROCEDURE load_dim_date()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_date (date, year, month, day)
    SELECT DISTINCT date, EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date), EXTRACT(DAY FROM date)
    FROM (
        SELECT release_date AS date FROM stage.games
        UNION
        SELECT Date AS date FROM stage.online
        UNION
        SELECT Date AS date FROM stage.price
        UNION
        SELECT timestamp_created AS date FROM stage.reviews
    ) AS all_dates
    WHERE date IS NOT NULL
    ON CONFLICT (date) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_developer()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_developer (name)
    SELECT DISTINCT UNNEST(string_to_array(developer, ';'))
    FROM stage.games
    WHERE developer IS NOT NULL
    ON CONFLICT (name) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_language()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_language (name)
    SELECT DISTINCT language FROM stage.reviews
    ON CONFLICT (name) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_tag()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_tag (name)
    SELECT DISTINCT UNNEST(string_to_array(steamspy_tags, ';'))
    FROM stage.games
    ON CONFLICT (name) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_platform()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_platform (name)
    SELECT DISTINCT UNNEST(string_to_array(platforms, ';'))
    FROM stage.games
    ON CONFLICT (name) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_game()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_game (id, name, required_age, achievements, positive_ratings, negative_ratings, 
                               average_playtime, median_playtime, owners, price, dim_date_id)
    SELECT DISTINCT
        g.appid, g.name, g.required_age, g.achievements, g.positive_ratings, g.negative_ratings, 
        g.average_playtime, g.median_playtime, g.owners, 
        COALESCE(p.initialprice, g.price),  
        d.id
    FROM stage.games g
    JOIN main.dim_date d ON g.release_date = d.date
    LEFT JOIN (
        SELECT DISTINCT ON (appid) appid, initialprice 
        FROM stage.price 
        ORDER BY appid, date ASC 
    ) p ON g.appid = p.appid
    ON CONFLICT (id) DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_developer_game()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_developer_game (dim_developer_id, dim_game_id)
    SELECT DISTINCT d.id, g.id
    FROM stage.games s
    JOIN main.dim_game g ON s.name = g.name
    JOIN main.dim_developer d ON d.name = ANY(string_to_array(s.developer, ';'))
    ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_tag_game()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_tag_game (dim_tag_id, dim_game_id)
    SELECT DISTINCT t.id, g.id
    FROM stage.games s
    JOIN main.dim_game g ON s.name = g.name
    JOIN main.dim_tag t ON t.name = ANY(string_to_array(s.steamspy_tags, ';'))
    ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_dim_platform_game()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.dim_platform_game (dim_platform_id, dim_game_id)
    SELECT DISTINCT p.id, g.id
    FROM stage.games s
    JOIN main.dim_game g ON s.name = g.name
    JOIN main.dim_platform p ON p.name = ANY(string_to_array(s.platforms, ';'))
    ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_fact_review()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.fact_review (
        review_id, recommended, votes_helpful, votes_funny, steam_purchase, 
        playtime_last_two_weeks, playtime_at_review, dim_date_id, dim_language_id, dim_game_id
    )
    SELECT DISTINCT
        r.review_id, 
        r.recommended, 
        CASE 
            WHEN r.votes_helpful > 4000000000 THEN gm.median_helpful 
            ELSE r.votes_helpful 
        END,
        CASE 
            WHEN r.votes_funny > 4000000000 THEN gm.median_funny 
            ELSE r.votes_funny 
        END,
        r.steam_purchase,
        COALESCE(r.author_playtime_last_two_weeks, gm.median_playtime_last_two_weeks),
        COALESCE(r.author_playtime_at_review, gm.median_playtime_at_review),
        d.id, lang.id, g.id
    FROM stage.reviews r
    JOIN main.dim_date d ON r.timestamp_created = d.date
    JOIN main.dim_language lang ON r.language = lang.name
    JOIN main.dim_game g ON r.app_id = g.id
    LEFT JOIN (
        SELECT 
            app_id, 
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY votes_helpful) AS median_helpful,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY votes_funny) AS median_funny,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY author_playtime_last_two_weeks) AS median_playtime_last_two_weeks,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY author_playtime_at_review) AS median_playtime_at_review
        FROM stage.reviews
        GROUP BY app_id
    ) AS gm ON r.app_id = gm.app_id
    ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_fact_game()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO main.fact_game (online, price, discount, dim_date_id, dim_game_id)
    SELECT DISTINCT o.Playercount, p.Finalprice, p.discount, d.id, g.id
    FROM stage.online o
    JOIN main.dim_date d ON o.Date = d.date
    JOIN main.dim_game g ON o.appid = g.id 
    LEFT JOIN stage.price p ON o.appid = p.appid AND o.Date = p.Date
    ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE load_all()
LANGUAGE plpgsql
AS $$
BEGIN
    CALL load_dim_date();
    CALL load_dim_developer();
    CALL load_dim_language();
    CALL load_dim_tag();
    CALL load_dim_platform();
    CALL load_dim_game();
    CALL load_dim_developer_game();
    CALL load_dim_tag_game();
    CALL load_dim_platform_game();
    CALL load_fact_game();
    CALL load_fact_review();
END;
$$;