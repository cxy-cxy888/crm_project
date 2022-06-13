package com.cxy99.woekbench.service.impl;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.commons.utils.UUIDUtils;
import com.cxy99.settings.domain.User;
import com.cxy99.woekbench.domain.*;
import com.cxy99.woekbench.mapper.*;
import com.cxy99.woekbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServicrimpl implements ClueService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ClueMapper clueMapper;
    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map map) {
        return clueMapper.selectAllClueByConditionForPage(map);
    }

    @Override
    public int queryClueCountByConditionForPage(Map map) {
        return clueMapper.selectClueCountByConditionFroPage(map);
    }

    @Override
    public Clue queryClueById(String id) {
        Clue clue = clueMapper.selectClueById(id);
        System.out.println(clue.toString());
        System.out.println(clue.getNextContactTime());

        return clueMapper.selectClueById(id);
    }

    @Override
    public int updateEditClue(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public List<ClueRemark> selectClueRemarkById(String id) {
        return clueRemarkMapper.selectClueRemarkById(id);
    }

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insert(clueRemark);
    }

    @Override
    public int updateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }

    @Override
    public int deleteClueRemark(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        //根据id查询数据
        String clueId= (String) map.get("clueId");
        User user = (User) map.get(Contants.SESSION_USER);
        String isCreateTran= (String) map.get("isCreateTran");
        Clue clue = clueMapper.selectClueByIdZhuanhuan(clueId);
        Customer customer = new Customer();
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setId(UUIDUtils.getUUID());
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertCustomer(customer);

        Contacts contacts = new Contacts();
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contactsMapper.insertContacts(contacts);
        
        //
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        if (clueRemarkList!=null&&clueRemarkList.size()>0){
            CustomerRemark customerRemark =null;
            ContactsRemark contactsRemark=null;
            List<CustomerRemark> customerRemarkList=new ArrayList<>();
            List<ContactsRemark> contactsRemarkList=new ArrayList<>();
            for (ClueRemark clueRemark:clueRemarkList) {
                customerRemark=new CustomerRemark();
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);
                contactsRemark = new ContactsRemark();
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemarkList.add(contactsRemark);

            }
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }
            //
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);

        //
        if (clueActivityRelationList!=null&&clueActivityRelationList.size()>0){
            ContactsActivityRelation contactsActivityRelation=null;
            List<ContactsActivityRelation> contactsActivityRelationList=new ArrayList<>();
            for(ClueActivityRelation clueActivityRelation:clueActivityRelationList){
                contactsActivityRelation=new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }
        //需要创建交易则填入一个交易信息
        if ("true".equals(isCreateTran)){
            Tran tran=new Tran();
            tran.setActivityId((String) map.get("activityId"));
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formateDateTime(new Date()));
            tran.setCustomerId(customer.getId());
            tran.setExpectedDate((String) map.get("expectedDate"));
            tran.setId(UUIDUtils.getUUID());
            tran.setMoney((String) map.get("money"));
            tran.setName((String) map.get("name"));
            tran.setOwner(user.getId());
            tran.setStage((String) map.get("stage"));
            tranMapper.insertTran(tran);

           if (clueRemarkList!=null&&clueRemarkList.size()>0){
               TranRemark tranRemark=null;
               List<TranRemark> tranRemarkList=new ArrayList<>();
               for(ClueRemark clueRemark:clueRemarkList){
                   tranRemark=new TranRemark();
                   tranRemark.setCreateBy(clueRemark.getCreateBy());
                   tranRemark.setCreateTime(clueRemark.getCreateTime());
                   tranRemark.setEditBy(clueRemark.getEditBy());
                   tranRemark.setEditFlag(clueRemark.getEditFlag());
                   tranRemark.setEditTime(clueRemark.getEditTime());
                   tranRemark.setId(UUIDUtils.getUUID());
                   tranRemark.setNoteContent(clueRemark.getNoteContent());
                   tranRemark.setTranId(tran.getId());
                   tranRemarkList.add(tranRemark);

               }
               tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
           }

        }

            clueRemarkMapper.deleteClueRemarkByClueId(clueId);
            clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
            clueMapper.deleteClueById(clueId);


    }
}
