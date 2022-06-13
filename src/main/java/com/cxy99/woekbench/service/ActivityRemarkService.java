package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.MarketingActivitiesRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<MarketingActivitiesRemark> queryActivityRemakFroDetailByActiviityId(String activityId);
    int saveCreateActivityRemark(MarketingActivitiesRemark remark);
    int deleteActivityRemarkById(String id);
    int saveEditActivityRemark(MarketingActivitiesRemark remark);
}
