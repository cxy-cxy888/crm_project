package com.cxy99.woekbench.service;

import com.cxy99.woekbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> queryContactsByContactsNameForCreateTran(String ContactsName);
}
