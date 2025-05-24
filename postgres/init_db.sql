-- CREATE NON ROOT USER

CREATE USER pipeline_user WITH ENCRYPTED PASSWORD 'Password1234**';
GRANT ALL PRIVILEGES ON DATABASE dw_flights TO pipeline_user;
CREATE SCHEMA STAGING;
CREATE SCHEMA RAW_DATA;
GRANT ALL ON SCHEMA staging,raw_data TO pipeline_user;

-- Create raw_data Tables

CREATE TABLE raw_data.airlines(
    carrier VARCHAR(2),
    name VARCHAR NOT NULL,
    CONSTRAINT p_airline PRIMARY KEY (carrier)
);

CREATE TABLE raw_data.airports(
    faa VARCHAR(3),
    name VARCHAR NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    altitude FLOAT NOT NULL,
    timezone INTEGER NOT NULL,
    dst VARCHAR(1) NOT NULL,
    timezone_name VARCHAR NOT NULL,
    CONSTRAINT p_airport PRIMARY KEY (faa)
);

CREATE TABLE raw_data.planes(
    tailnum VARCHAR(6),
    year INTEGER,
    type VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    model VARCHAR NOT NULL,
    engines INTEGER NOT NULL,
    seats INTEGER NOT NULL,
    speed FLOAT,
    engine VARCHAR NOT NULL,
    CONSTRAINT p_plane PRIMARY KEY (tailnum)
);

CREATE TABLE raw_data.weather(
    origin VARCHAR(3),
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    hour INTEGER NOT NULL,
    temp NUMERIC,
    dewp NUMERIC,
    humid NUMERIC,
    wind_dir FLOAT,
    wind_speed NUMERIC,
    wind_gust NUMERIC,
    precip NUMERIC,
    pressure NUMERIC,
    visib NUMERIC,
    time_hour TIMESTAMPTZ NOT NULL,
    CONSTRAINT p_weather PRIMARY KEY (origin, year, month, day, hour),
    CONSTRAINT fk_airport FOREIGN KEY (origin) REFERENCES raw_data.airports(faa)
);

CREATE TABLE raw_data.flights(
    carrier VARCHAR(2),
    flight INTEGER NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    actual_dep_time INTEGER,
    sched_dep_time INTEGER,
    dep_delay INTEGER,
    actual_arr_time INTEGER,
    sched_arr_time INTEGER,
    arr_delay INTEGER,
    tailnum	VARCHAR(6) NOT NULL,
    origin	VARCHAR(3) NOT NULL,
    dest VARCHAR(3) NOT NULL,
    air_time FLOAT NOT NULL,
    distance FLOAT NOT NULL,
    time_hour TIMESTAMPTZ NOT NULL,
    CONSTRAINT p_flight PRIMARY KEY (carrier, flight, year, month, day, hour, minute),
    CONSTRAINT fk_airline FOREIGN KEY (carrier) REFERENCES raw_data.airlines(carrier),
    CONSTRAINT fk_plane FOREIGN KEY (tailnum) REFERENCES raw_data.planes(tailnum),
    CONSTRAINT fk_origin FOREIGN KEY (origin) REFERENCES raw_data.airports(faa),
    CONSTRAINT fk_dest FOREIGN KEY (dest) REFERENCES raw_data.airports(faa)
);

CREATE TABLE staging.airlines(
    carrier VARCHAR(2),
    name VARCHAR NOT NULL
);

CREATE TABLE staging.airports(
    faa VARCHAR(3),
    name VARCHAR NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    altitude FLOAT NOT NULL,
    timezone INTEGER NOT NULL,
    dst VARCHAR(1) NOT NULL,
    timezone_name VARCHAR NOT NULL
);

CREATE TABLE staging.planes(
    tailnum VARCHAR(6),
    year VARCHAR,
    type VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    model VARCHAR NOT NULL,
    engines INTEGER NOT NULL,
    seats INTEGER NOT NULL,
    speed VARCHAR,
    engine VARCHAR NOT NULL
);

CREATE TABLE staging.weather(
    origin VARCHAR(3),
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    hour INTEGER NOT NULL,
    temp VARCHAR,
    dewp VARCHAR,
    humid VARCHAR,
    wind_dir VARCHAR,
    wind_speed VARCHAR,
    wind_gust VARCHAR,
    precip NUMERIC,
    pressure VARCHAR,
    visib NUMERIC,
    time_hour TIMESTAMPTZ NOT NULL
);

CREATE TABLE staging.flights(
    idx int,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    actual_dep_time INTEGER,
    sched_dep_time INTEGER,
    dep_delay INTEGER,
    actual_arr_time INTEGER,
    sched_arr_time INTEGER,
    arr_delay INTEGER,
    carrier VARCHAR(2),
    flight INTEGER NOT NULL,
    tailnum	VARCHAR(6) NOT NULL,
    origin	VARCHAR(3) NOT NULL,
    dest VARCHAR(3) NOT NULL,
    air_time FLOAT NOT NULL,
    distance FLOAT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    time_hour TIMESTAMPTZ NOT NULL
);


GRANT ALL ON ALL TABLES IN SCHEMA staging,raw_data TO pipeline_user;