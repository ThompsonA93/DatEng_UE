package org.example.BestCourseGrade;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.util.StringTokenizer;

public class BestCourseGradeMapper extends Mapper <LongWritable, Text, Text, IntWritable>{
    private Text wordToken = new Text();

    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException
    {
        StringTokenizer tokens = new StringTokenizer(value.toString()); //Dividing String into tokens
        while (tokens.hasMoreTokens())
        {
            wordToken.set(tokens.nextToken());
            context.write(wordToken, new IntWritable(1));
        }
    }
}
