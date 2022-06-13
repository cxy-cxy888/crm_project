package com.cxy99.woekbench.controller;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.domain.ReturnObject;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.commons.utils.UUIDUtils;
import com.cxy99.settings.domain.User;
import com.cxy99.settings.mapper.UserMapper;
import com.cxy99.settings.service.UserService;
import com.cxy99.settings.service.impl.UserServiceimpl;
import com.cxy99.woekbench.domain.Contacts;
import com.cxy99.woekbench.domain.Customer;
import com.cxy99.woekbench.domain.CustomerRemark;
import com.cxy99.woekbench.mapper.CustomerMapper;
import com.cxy99.woekbench.mapper.CustomerRemarkMapper;
import com.cxy99.woekbench.service.CustomerRemarkService;
import com.cxy99.woekbench.service.CustomerService;
import com.sun.org.apache.bcel.internal.generic.I2F;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        System.out.println("hot-fix");
        return "workbench/customer/index";

    }

    @RequestMapping("/workbench/customer/queryCustomerForPage.do")
    @ResponseBody
    public Object   queryCustomerForPage(int pageNo,int pageSize,String name,String owner,String phone,String website){
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("pageSize",pageSize);
        map.put("beginNo",(pageNo-1)*pageSize);
        List<Customer> customerList = customerService.queryCustomerByDetailFroPage(map);
        int totalRows = customerService.queryCustomerCountFroPage(map);

        Map<String,Object> retMap=new HashMap<>();
        retMap.put("customerList",customerList);
        retMap.put("totalRows",totalRows);
        return retMap;

    }
    @RequestMapping("/workbench/customer/createCustomer.do")
    @ResponseBody
    public Object createCustomer(Customer customer, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        customer.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = customerService.createCustomer(customer);
            if (i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("请稍候");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("请稍候");
        }
        return returnObject;

    }
    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id){
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }
        @RequestMapping("/workbench/customer/saveEditCustomer.do")
        @ResponseBody
    public Object saveEditCustomer(Customer customer,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formateDateTime(new Date()));
        try {

            int i = customerService.saveEditCustomer(customer);
            if (i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("更新失败请重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("更新失败请重试");
        }
        return returnObject;
    }
    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    @ResponseBody
    public Object   deleteCustomerByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = customerService.deleteCustomerByIds(id);
            if (i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙请稍候");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙请稍候");
        }
        return returnObject;
    }
    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detailCustomer(String id,HttpServletRequest request){
        Customer customer = customerService.queryCustomerById(id);
        request.setAttribute("customer",customer);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkByIdForDetail(id);
        request.setAttribute("customerRemarkList",customerRemarkList);
        return  "workbench/customer/detail";
    }
}
