// Return all movie titles (video_movies.title) of all movies that were filmed in
// France (video_movieDetails.country).
// The lookup function might be useful: https://docs.mongodb.com/manual/reference/operator/aggregation/lookup/

use video;


db.video_movies.find()

db.video_movieDetails.find()

// ???
db.video_movieDetails.find({countries: "France"})

// Using lookup
/*
{
   $lookup:
     {
       from: <collection to join>,
       localField: <field from the input documents>,
       foreignField: <field from the documents of the "from" collection>,
       as: <output array field>
     }
}
SELECT *, <output array field>
FROM collection
WHERE <output array field> IN (
   SELECT *
   FROM <collection to join>
   WHERE <foreignField> = <collection.localField>
);
*/
// Aggregate the Moviedetails
db.video_movies.aggregate([{
    $lookup: {
        localField: "title",
        from: "video_movieDetails",
        foreignField: "title",
        as: "movieDetails_lookup"
    }
}])

// Select from aggregated Array where Country = France
db.video_movies.aggregate([{
    $lookup: {
        localField: "title",
        from: "video_movieDetails",
        foreignField: "title",
        as: "movieDetails_lookup",
        let: { title: "$title", country: "$country"},
        pipeline: [{
            $match: {
                $expr: {
                    country: "France"
                }
            }
        }]
    }
}])