package org.example.AvgStudentGrade;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class AvgStudentGradeReducer extends Reducer <Text, DoubleWritable, Text, DoubleWritable> {
    double sumGrade = 0;
    double countGrade = 0;

    public void reduce(Text key, Iterable<DoubleWritable> values, Reducer.Context context) throws IOException, InterruptedException {
        System.out.println("Reducing on key " + key);
        for(DoubleWritable doubleWritable : values){
            sumGrade = sumGrade + doubleWritable.get();
            countGrade++;
        }
        DoubleWritable avgGrade = new DoubleWritable();
        avgGrade.set(sumGrade / countGrade);
        context.write(key, avgGrade);
    }

}
