package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.CustomerRemark;
import com.cxy99.woekbench.mapper.CustomerRemarkMapper;
import com.cxy99.woekbench.service.CustomerRemarkService;
import com.cxy99.woekbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CustomerRemarkServiceimpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public List<CustomerRemark> queryCustomerRemarkByIdForDetail(String id) {
        return customerRemarkMapper.queryCustomerByIdFroDetail(id);
    }
}
