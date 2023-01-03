package org.example.AvgStudentGrade;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

/**
 *
 */
public class AvgStudentGradeCount {
    public static void main(String[] args) throws Exception
    {
        Configuration conf = new Configuration();
        String[] pathArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if (pathArgs.length < 2)
        {
            System.err.println("MR Project Usage: wordcount <input-path> [...] <output-path>");
            System.exit(2);
        }
        Job job = Job.getInstance(conf, "avgStudentGrade");

        job.setJarByClass(AvgStudentGradeCount.class);
        job.setMapperClass(AvgStudentGradeMapper.class);
        job.setReducerClass(AvgStudentGradeReducer.class);

        job.setInputFormatClass(KeyValueTextInputFormat.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);

        FileInputFormat.addInputPath(job, new Path(pathArgs[pathArgs.length - 2]));
        FileOutputFormat.setOutputPath(job, new Path(pathArgs[pathArgs.length - 1]));

        int result = job.waitForCompletion(true) ? 0 : 1;
        System.exit(result);
    }
}
