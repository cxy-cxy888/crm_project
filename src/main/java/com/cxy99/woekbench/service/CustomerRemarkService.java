package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkByIdForDetail(String id);
}
