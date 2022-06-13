package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList);
    int deleteClueActivityRelationByClueIDAndActivityId(ClueActivityRelation clueActivityRelation);
}
