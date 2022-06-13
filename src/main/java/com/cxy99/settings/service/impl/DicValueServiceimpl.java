package com.cxy99.settings.service.impl;

import com.cxy99.settings.domain.DicValue;
import com.cxy99.settings.mapper.DicValueMapper;
import com.cxy99.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service("DicValueService")
public class DicValueServiceimpl implements DicValueService {
    @Autowired
   private   DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
