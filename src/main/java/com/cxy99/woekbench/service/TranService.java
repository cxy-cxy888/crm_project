package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.FunnelVO;
import com.cxy99.woekbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    void saveCreateTran(Map<String,Object> map);
    List<Tran> queryAllTranFroPage(Map<String,Object> map);
    Tran queryTranForDetailBy(String id);
    List<FunnelVO> queryCountOfTranGroupByStage();
}
