package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.Customer;
import com.cxy99.woekbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<Customer> queryCustomerByDetailFroPage(Map<String,Object> map);
    int queryCustomerCountFroPage(Map<String,Object> map);
    int createCustomer(Customer customer);
    Customer queryCustomerById(String id);
    int saveEditCustomer(Customer customer);
    int deleteCustomerByIds(String[] ids);
    List<String> queryCustomerNameAll();
    String queryCustomerIdByName(String name);
}
