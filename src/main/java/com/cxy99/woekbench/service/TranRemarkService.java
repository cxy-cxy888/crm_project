package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {
    List<TranRemark> queryTranRemarkByTranId(String tranId);
}
