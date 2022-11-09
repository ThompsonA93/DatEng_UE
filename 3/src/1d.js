// d) Write a query returning all movies directed by “Curt McDowell” in 1980.
use video;

// Lookup Curt McDowell
db.video_movieDetails.find(
    {director: "Curt McDowell"},
)

// Lookup Movies in 1980
db.video_movieDetails.find(
    {year: 1980},
)

// Run and to combine both
db.video_movieDetails.find(
    {$and: [{director: "Curt McDowell"}, {year: 1980}]},
    {title: 1, director: 1, year: 1, _id: 0}
)