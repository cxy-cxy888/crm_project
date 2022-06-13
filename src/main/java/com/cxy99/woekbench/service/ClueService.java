package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.Clue;
import com.cxy99.woekbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map map);

    int queryClueCountByConditionForPage(Map map);

    Clue queryClueById(String id);
    int updateEditClue(Clue clue);
    int deleteClueByIds(String[] ids);

    List<ClueRemark> selectClueRemarkById(String id);

    int saveClueRemark(ClueRemark clueRemark);

    int updateClueRemark(ClueRemark clueRemark);
    int deleteClueRemark(String id);

    void saveConvertClue(Map<String,Object> map);

}
