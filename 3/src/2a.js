// 2a) Write a query returning the name and number of movies of each director.
// Warning: The director may contain a list of persons.
// You do not need to take care of different names for the same person.
use video;


// Group by directors; add up occurences per director (I think)
db.video_movieDetails.aggregate([
    { $group: { _id: "$director", count: {$sum: 1}}},
    { $sort: { count: -1 }} // Sort descending
])

// Test view -- David Mallet is supposed to have 7 Movies
db.video_movieDetails.find({director: "David Mallet"}, {title: 1, _id: 0})
