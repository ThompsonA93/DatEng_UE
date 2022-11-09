// f) Write a query returning all movies where Will Smith and Martin Lawrence played together.
use video;

// Test view #1 over db
db.video_movieDetails.find(
    {actors: "Will Smith"},
    {actors: 1, title: 1, _id: 0}
)

// Test view #2 over db
db.video_movieDetails.find(
    {actors: "Martin Lawrence"},
    {actors: 1, title: 1, _id: 0}
)

// Combine both
db.video_movieDetails.find(
    {$and: [{actors: "Will Smith"}, {actors: "Martin Lawrence"}]},
    {actors: 1, title: 1, _id: 0}
)