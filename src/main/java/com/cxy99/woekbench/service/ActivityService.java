package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.Activity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


public interface ActivityService {
    int saveCreateActivity(Activity activity);
    List<Activity> queryActivityByConditionFroPage(Map<String,Object> map);
    int queryCountOfActivityByCondition(Map<String,Object> map);
    int deleteActivityByIds(String[] ids);
    Activity queryActivityById(String id);
    int updataActivityById(Activity activity);
    List<Activity> queryAllActivitys();
    List<Activity> queryActivityByIds(String[] ids);
    int saveCreateActivityByList(List<Activity> activityList);
    Activity queryActivityFroDetailById(String id);
    List<Activity> queryActivityByClueId(String clueId);
    List<Activity> queryActivityForDetailByNameClueId(Map<String,String> map);
    List<Activity> queryActivityFroDetailByIds(String[] ids);
    List<Activity> queryActivityFroConvertByNameAndClueId(Map<String,Object> map);
    List<Activity> queryActivityFroCreateTranByActivityName(String activityName);
}
