// 2b) Rename the director Roland Emmerich to R. Emmerich. Be sure to update all his movies.

// 3 Movies
db.video_movieDetails.find(
    {director: "Roland Emmerich"},
    {_id: 0, title: 1, director: 1}
)

// Update Director name
db.video_movieDetails.updateMany(
    {director: "Roland Emmerich"},
    {$set: {director: "R. Emmerich"}}
)

db.video_movieDetails.find(
    {director: "R. Emmerich"},
    {_id: 0, title: 1, director: 1}
)

// Revert update director name for later showcasing
db.video_movieDetails.updateMany(
    {director: "R. Emmerich"},
    {$set: {director: "Roland Emmerich"}}
)