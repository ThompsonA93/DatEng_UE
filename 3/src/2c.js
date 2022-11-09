// Return all movie titles (video_movies.title) of all movies that were filmed in
// France (video_movieDetails.country).
// The lookup function might be useful: https://docs.mongodb.com/manual/reference/operator/aggregation/lookup/

use video;

// ???
db.video_movieDetails.find({countries: "France"})

// Stackoverflowed++?
db.video_movies.aggregate([{
    $lookup: {
        from: 'movie_details',
        foreignField: 'imdb.id',
        localField: 'imdb',
        as: 'details'
    }
},{
    $project: {
        title: 1,
        countries: {
            "$arrayElemAt": ["$details.countries", 0]
        },
    }
},{
    $match: {
        "countries": "France"
    }
},{ 
    $project: {
        title: 1,
        _id: 0
    }
}])