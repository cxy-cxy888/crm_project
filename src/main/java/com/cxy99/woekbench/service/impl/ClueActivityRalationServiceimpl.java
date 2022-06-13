package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.ClueActivityRelation;
import com.cxy99.woekbench.mapper.ClueActivityRelationMapper;
import com.cxy99.woekbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ClueActivityRalationServiceimpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Override
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelationList(clueActivityRelationList);
    }

    @Override
    public int deleteClueActivityRelationByClueIDAndActivityId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndActivityId(clueActivityRelation);
    }

}
