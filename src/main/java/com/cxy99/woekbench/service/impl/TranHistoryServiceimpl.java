package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.TranHistory;
import com.cxy99.woekbench.mapper.TranHistoryMapper;
import com.cxy99.woekbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranHistoryServiceimpl implements TranHistoryService {
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public List<TranHistory> queryTranHistoryFroTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryByTranId(tranId);
    }
}
