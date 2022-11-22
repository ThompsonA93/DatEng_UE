/** 1b_JSQONImport.sql **/
DROP TABLE IF EXISTS json_aau_corses;
DROP TABLE IF EXISTS json_aau_metadata;

CREATE TABLE json_aau_corses(
    data jsonb
)

CREATE TABLE json_aau_metadata(
    data jsonb
)