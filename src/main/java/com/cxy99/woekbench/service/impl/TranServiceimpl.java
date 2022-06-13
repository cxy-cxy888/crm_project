package com.cxy99.woekbench.service.impl;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.commons.utils.UUIDUtils;
import com.cxy99.settings.domain.User;
import com.cxy99.woekbench.domain.Customer;
import com.cxy99.woekbench.domain.FunnelVO;
import com.cxy99.woekbench.domain.Tran;
import com.cxy99.woekbench.domain.TranHistory;
import com.cxy99.woekbench.mapper.CustomerMapper;
import com.cxy99.woekbench.mapper.TranHistoryMapper;
import com.cxy99.woekbench.mapper.TranMapper;
import com.cxy99.woekbench.service.TranService;
import com.fasterxml.jackson.databind.ser.std.UUIDSerializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.lang.ref.PhantomReference;
import java.util.Date;
import java.util.List;
import java.util.Map;
@Service
public class TranServiceimpl implements TranService {
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public void saveCreateTran(Map<String, Object> map) {
        //根据名称查询customerId
        String customerName= (String) map.get("customerName");
        User user=(User)map.get(Contants.SESSION_USER);
        String customerId = customerMapper.selectCustomerIdByName(customerName);
        if (customerId==null){
            Customer customer = new Customer();
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }
        //保存创建交易
        Tran tran=new Tran();
        tran.setStage((String) map.get("stage"));
        tran.setOwner((String)map.get("owner"));
        tran.setType((String)map.get("type"));
        tran.setSource((String)map.get("source"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setName((String) map.get("name"));
        tran.setMoney((String) map.get("money"));
        tran.setId(UUIDUtils.getUUID());
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setDescription((String) map.get("description"));
        tran.setCustomerId(customerId);
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tran.setCreateBy(user.getId());
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setActivityId((String)map.get("activityId"));
        tranMapper.insertTran(tran);
        //保存交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertTranHistory(tranHistory);
    }

    @Override
    public List<Tran> queryAllTranFroPage(Map<String, Object> map) {
        return tranMapper.selectAllTranFroPageByQuery(map);
    }

    @Override
    public Tran queryTranForDetailBy(String id) {
        return tranMapper.selectTranForDetailById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}
