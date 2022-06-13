package com.cxy99.settings.service;

import com.cxy99.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User qureyUserByActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();
}
