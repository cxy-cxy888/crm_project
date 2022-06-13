package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.MarketingActivitiesRemark;
import com.cxy99.woekbench.mapper.MarketingActivitiesRemarkMapper;
import com.cxy99.woekbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ActivityRemarkServiceimpl implements ActivityRemarkService {
    @Autowired
    private MarketingActivitiesRemarkMapper remarkMapper;
    @Override
    public List<MarketingActivitiesRemark> queryActivityRemakFroDetailByActiviityId(String activityId) {
        return remarkMapper.selectActivityRemarkFroDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(MarketingActivitiesRemark remark) {
        return remarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return remarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public int saveEditActivityRemark(MarketingActivitiesRemark remark) {
        return remarkMapper.updateByPrimaryKeySelective(remark);
    }
}
