// a) Write a query returning all movies directed by “George Lucas”.

use video;

db.video_movieDetails.find({director: "George Lucas"})