package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> queryTranHistoryFroTranId(String tranId);
}
