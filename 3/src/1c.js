// c) Write a query returning all movies directed by “Jon Brewer” or where the director is unknown (null).

use video;

// Has quite a lot of movies
db.video_movieDetails.find(
    {director: null},
)

// Has only 2 movies
db.video_movieDetails.find(
    {director: "Jon Brewer"},
)

// Run or to combine both
db.video_movieDetails.find(
    {$or: [{director: "Jon Brewer"}, {director: null}]},
    {title: 1, director: 1, _id: 0}
)