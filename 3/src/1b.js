// a.) Write a query returning all movies directed by “George Lucas”.
// b) Like a) but only return the title and no other info.

use video;

db.video_movieDetails.find({director: "George Lucas"}, {title: 1, _id: 0})