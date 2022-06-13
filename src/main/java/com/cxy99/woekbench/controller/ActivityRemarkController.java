package com.cxy99.woekbench.controller;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.domain.ReturnObject;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.commons.utils.UUIDUtils;
import com.cxy99.settings.domain.User;
import com.cxy99.woekbench.domain.MarketingActivitiesRemark;
import com.cxy99.woekbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(MarketingActivitiesRemark remark, HttpSession session ){
        ReturnObject returnObject = new ReturnObject();
        User user= (User) session.getAttribute(Contants.SESSION_USER);
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        try {
            int i = activityRemarkService.saveCreateActivityRemark(remark);
            if (i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙请稍候重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙请稍候重试");
        }

        return  returnObject;

    }
    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public  Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityRemarkService.deleteActivityRemarkById(id);
            if (i>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙请稍候");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙请稍候");
        }
     return  returnObject;

    }
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    @ResponseBody
    public Object saveEditActivityRemark(MarketingActivitiesRemark remark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try {
            int i = activityRemarkService.saveEditActivityRemark(remark);
            if (i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙请重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙请重试");
        }
        return  returnObject;

    }
}
