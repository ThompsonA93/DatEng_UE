// e) Write a query returning all movies with more than one director.
use video;

// Test view over db
db.video_movieDetails.find(
    {},
    {director: 1, title: 1, _id: 0}
)


// Limit view to movies with >1 directors
// Assumption: If there is a comma, there are 2 or more directors
db.video_movieDetails.find(
    {director: {$regex: ","}},
    {director: 1, title: 1, _id: 0}
)