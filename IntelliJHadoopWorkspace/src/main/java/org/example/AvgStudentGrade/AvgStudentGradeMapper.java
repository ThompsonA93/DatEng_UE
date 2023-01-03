package org.example.AvgStudentGrade;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.io.LongWritable;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class AvgStudentGradeMapper extends Mapper <LongWritable, Text, Text, IntWritable>{

    JSONObject student;
    public void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException
    {
        try{
            student = (JSONObject) JSONValue.parseWithException(value.toString());

            String matNo = "";
            double grade = 0;

            Iterator<JSONObject> sit = ((JSONArray) student.get("results")).iterator();
            System.out.println("Creating student arrays.");
            while(sit.hasNext()){
                JSONObject jo = sit.next();

                matNo = (String) jo.get("matno");
                grade = Double.parseDouble((String) jo.get("grade"));

                System.out.println("Reading Student: " + matNo + " " + grade);
                context.write(new Text(matNo), new DoubleWritable(grade));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
