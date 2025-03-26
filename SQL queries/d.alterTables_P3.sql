ALTER TABLE hasGenre
ADD CONSTRAINT hasGenrePK PRIMARY KEY (movie_id, genre_id)
ALTER TABLE hasKeywords
ADD CONSTRAINT hasKeywordsPK PRIMARY KEY (movie_id, keywords)
ALTER TABLE belongsTocollection
ADD CONSTRAINT belongsColPK PRIMARY KEY (movie_id, collection_id)
ALTER TABLE hasProductioncompany
ADD CONSTRAINT hasPcPK PRIMARY KEY (movie_id, pc_id)
ALTER TABLE ratings
ADD CONSTRAINT ratingsPK PRIMARY KEY (movie_id, user_id)