package com.cxy99.woekbench.controller;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.domain.ReturnObject;
import com.cxy99.settings.domain.DicValue;
import com.cxy99.settings.domain.User;
import com.cxy99.settings.service.DicValueService;
import com.cxy99.settings.service.UserService;
import com.cxy99.woekbench.domain.*;
import com.cxy99.woekbench.mapper.CustomerMapper;
import com.cxy99.woekbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){

        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("transactionTypeList",transactionTypeList);
       request.setAttribute("sourceList",sourceList);
       request.setAttribute("stageList",stageList);
       return "workbench/transaction/index";
    }
    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("stageList",stageList);
        return "workbench/transaction/save";
    }
    @Autowired
    private ActivityService activityService;
    @RequestMapping("/workbench/transaction/findActivityAll.do")
    @ResponseBody
    public Object findActivityAll(String activityName){

        List<Activity> activityList = activityService.queryActivityFroCreateTranByActivityName(activityName);
        return activityList;
    }

    @Autowired
    private ContactsService contactsService;
    @RequestMapping("/workbench/transaction/findContactsAll.do")
    @ResponseBody
    public Object findContactsAll(String contactsName){
        List<Contacts> contactsList = contactsService.queryContactsByContactsNameForCreateTran(contactsName);
        return contactsList;
    }
    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){

        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        System.out.println(possibility.getString("资质审查"));
        System.out.println(stageValue+"wwwwwwwwwwwwwwwwwww");
        String possibilityString = possibility.getString(stageValue);

        System.out.println(possibilityString);
        return possibilityString;

    }
    @Autowired
    private CustomerService customerService;
    @RequestMapping("/workbench/transaction/queryCustomerAllByLikeName.do")
    @ResponseBody
    public Object queryCustomerAllByLikeName(){
        List<String> customerNameList = customerService.queryCustomerNameAll();
        return customerNameList;
    }
    @Autowired
    private TranService tranService;
    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
        map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));
        ReturnObject returnObject = new ReturnObject();
        try{
            tranService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){

            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("请稍候");
        }
      return returnObject;
    }
    @RequestMapping("/workbench/transaction/queryAllTranForPage.do")
    @ResponseBody
    public Object queryAllTranForPage(String name,String owner,String customerName,String stage,String type,String source,String contactsName,int pageNo,int pageSize){
        Map<String,Object> map =new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsName",contactsName);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Tran> tranList = tranService.queryAllTranFroPage(map);
        return tranList;
    }
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;
    @RequestMapping("/workbench/transaction/detailTran.do")
    public String detailTran(String id,HttpServletRequest request){
        //调用service的方法
        Tran tran = tranService.queryTranForDetailBy(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryFroTranId(id);
        //查询可能性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibilityString = bundle.getString(tran.getStage());
        tran.setPossibility(possibilityString);
        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarkList",tranRemarkList);
        request.setAttribute("tranHistoryList",tranHistoryList);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("stageList",stageList);

        return "workbench/transaction/detail";

    }



}
