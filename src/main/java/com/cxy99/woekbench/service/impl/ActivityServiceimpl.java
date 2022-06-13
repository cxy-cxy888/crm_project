package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.Activity;
import com.cxy99.woekbench.mapper.ActivityMapper;
import com.cxy99.woekbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceimpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionFroPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionFroPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int updataActivityById(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public List<Activity> queryAllActivitys() {
        return activityMapper.selectAllActivitys();
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    @Override
    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityFroDetailById(String id) {
        return activityMapper.selectActivityFroDetailById(id) ;
    }

    @Override
    public List<Activity> queryActivityByClueId(String clueId) {
        return activityMapper.selectActivityByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameClueId(Map<String,String> map) {

        return activityMapper.selectActivityForDetailByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityFroDetailByIds(String[] ids) {
        return activityMapper.selectActivityFroDetailByIds(ids);
    }

    @Override
    public List<Activity> queryActivityFroConvertByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectActivityFroConvertByNameAndClueId(map);
    }

    @Override
    public List<Activity> queryActivityFroCreateTranByActivityName(String activityName) {
        return activityMapper.selectActivityByActivityNameFroTranSave(activityName);
    }
}
