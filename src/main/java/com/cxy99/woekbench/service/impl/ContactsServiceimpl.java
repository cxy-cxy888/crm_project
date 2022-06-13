package com.cxy99.woekbench.service.impl;

import com.cxy99.woekbench.domain.Contacts;
import com.cxy99.woekbench.mapper.ContactsMapper;
import com.cxy99.woekbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsServiceimpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsByContactsNameForCreateTran(String contactsName) {
        return contactsMapper.selectContactsByContactsNameFroCreateTran(contactsName);
    }
}
