// Return all movie titles (video_movies.title) of all movies that were filmed in
// France (video_movieDetails.country).
// The lookup function might be useful: https://docs.mongodb.com/manual/reference/operator/aggregation/lookup/

use video;

// ???
db.video_movieDetails.find({countries: "France"})

// FIXME
db.video_movies([{
    $lookup: {
        from: "video_movieDetails",
        let: {
            movie_title: "$title", movie_country: "$country"
        },
        pipeline: [{
            $match: { $country: "France"}
        }]
    }
}])

