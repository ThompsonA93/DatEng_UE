// g) Write a query returning all movies where Will Smith or Martin Lawrence played in, but not both.
use video;

// Test view #1 over db
db.video_movieDetails.find(
    {actors: "Will Smith"},
    {actors: 1, title: 1, _id: 0}
)

// Will Smith but not Martin Lawrence
db.video_movieDetails.find(
    {$and: [{actors: "Will Smith"}, {actors: {$ne: "Martin Lawrence"}}]},
    {actors: 1, title: 1, _id: 0}
)

// Will Smith and not Martin Lawrence OR Martin Lawrence and not Will Smith
db.video_movieDetails.find(
    {$or: [
        {$and: [{actors: "Will Smith"}, {actors: {$ne: "Martin Lawrence"}}]},
        {$and: [{actors: "Martin Lawrence"}, {actors: {$ne: "Will Smith"}}]},
        ]
    },
    {actors: 1, title: 1, _id: 0}
)
