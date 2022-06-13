package com.cxy99.commons.utils;
//对日期类型进行处理的工具类

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public static String formateDateTime(Date date){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
         String datestr=sdf.format(date);
        return datestr;
        //对指定的日期进行格式化
    }
}
