// h) Write a query returning all movies where Will Smith and Martin Lawrence played together that won at least 3 awards.
use video;

// Select awards
db.video_movieDetails.find(
    {"awards.wins": 3},
    {actors: 1, title: 1, awards:1, _id: 0}
)

// Select awards with 3+
db.video_movieDetails.find(
    {"awards.wins": {$gt: 3}},
    {actors: 1, title: 1, awards:1, _id: 0}
)

// Will Smith + Martin Lawrence (f.) )
db.video_movieDetails.find(
    {$and: [{actors: "Will Smith"}, {actors: "Martin Lawrence"}]},
    {actors: 1, title: 1, awards:1, _id: 0}
)

db.video_movieDetails.find(
    {$and: [{actors: "Will Smith"}, {actors: "Martin Lawrence"}, {"awards.wins": {$gt: 3}}]},
    {actors: 1, title: 1, awards:1, _id: 0}
)
