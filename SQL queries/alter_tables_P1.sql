ALTER TABLE movie
    ADD CONSTRAINT movie_pk
    PRIMARY KEY (id);
ALTER TABLE genre
    ADD CONSTRAINT genre_pk
    PRIMARY KEY (id);
ALTER TABLE productioncompany
    ADD CONSTRAINT productioncompany_pk
    PRIMARY KEY (id);
ALTER TABLE collection
    ADD CONSTRAINT collection_pk
    PRIMARY KEY (id);
ALTER TABLE keyword
    ADD CONSTRAINT keyword_pk
    PRIMARY KEY (id);
ALTER TABLE movie_cast
    ADD CONSTRAINT movie_cast_pk
    PRIMARY KEY (cid);
ALTER TABLE movie_crew
    ADD CONSTRAINT movie_crew_pk
    PRIMARY KEY (cid);
ALTER TABLE ratings
    ADD CONSTRAINT ratingsFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE belongsTocollection
    ADD CONSTRAINT btConnectionFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE hasGenre
    ADD CONSTRAINT hasGenreFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE hasProductioncompany
    ADD CONSTRAINT hasProdCompFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE hasKeywords
    ADD CONSTRAINT hasKeywordsFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE movie_cast
    ADD CONSTRAINT castFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE movie_crew
    ADD CONSTRAINT crewFK_movieid 
    FOREIGN KEY (movie_id)
    REFERENCES movie(id);
ALTER TABLE hasGenre
    ADD CONSTRAINT genre_idFK
    FOREIGN KEY (genre_id)
    REFERENCES genre(id);
ALTER TABLE hasProductioncompany
    ADD CONSTRAINT prodcompany_idFK
    FOREIGN KEY (pc_id)
    REFERENCES productioncompany(id);
ALTER TABLE belongsTocollection
    ADD CONSTRAINT collection_idFK
    FOREIGN KEY (collection_id)
    REFERENCES collection(id);
ALTER TABLE hasKeywords
    ADD CONSTRAINT keywords_idFK
    FOREIGN KEY (keywords)
    REFERENCES keyword(id);