package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.TranRemark;
import com.cxy99.woekbench.mapper.TranRemarkMapper;
import com.cxy99.woekbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranReamrkimpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Override
    public List<TranRemark> queryTranRemarkByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkByTranId(tranId)    ;
    }
}
