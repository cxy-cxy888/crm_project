package com.cxy99.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class HSSFUtils {
    public static String getCellValueForStr(HSSFCell cell){
        String ref="";
        if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
            ref=cell.getStringCellValue();
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
            ref=cell.getNumericCellValue()+"";
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN){
            ref=cell.getBooleanCellValue()+"";
        }else if (cell.getCellType()== HSSFCell.CELL_TYPE_FORMULA){
            ref=cell.getCellFormula();
        }else {
            ref="";
        }
        return ref;
    }
}
