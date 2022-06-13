package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.Customer;
import com.cxy99.woekbench.domain.CustomerRemark;
import com.cxy99.woekbench.mapper.CustomerMapper;
import com.cxy99.woekbench.mapper.CustomerRemarkMapper;
import com.cxy99.woekbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceimpl implements CustomerService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<Customer> queryCustomerByDetailFroPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByDetailFroPage(map);
    }

    @Override
    public int queryCustomerCountFroPage(Map<String, Object> map) {
        return customerMapper.selectCustomerCountFroPage(map);
    }

    @Override
    public int createCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerByCustomerId(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateByPrimaryKey(customer);
    }

    @Override
    public int deleteCustomerByIds(String[] ids) {
        return customerMapper.deleteCustomerByIds(ids)  ;
    }

    @Override
    public List<String> queryCustomerNameAll() {
        return customerMapper.selectAllCustomerName();
    }

    @Override
    public String queryCustomerIdByName(String name) {
        return customerMapper.selectCustomerIdByName(name);
    }


}
