package com.cxy99.woekbench.controller;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.domain.ReturnObject;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.commons.utils.UUIDUtils;
import com.cxy99.settings.domain.DicValue;
import com.cxy99.settings.domain.User;
import com.cxy99.settings.service.DicValueService;
import com.cxy99.settings.service.UserService;
import com.cxy99.woekbench.domain.Activity;
import com.cxy99.woekbench.domain.Clue;
import com.cxy99.woekbench.domain.ClueActivityRelation;
import com.cxy99.woekbench.domain.ClueRemark;
import com.cxy99.woekbench.service.ActivityService;
import com.cxy99.woekbench.service.ClueActivityRelationService;
import com.cxy99.woekbench.service.ClueService;
import jdk.internal.org.objectweb.asm.tree.TryCatchBlockNode;
import org.apache.commons.collections4.iterators.ObjectGraphIterator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.awt.image.DataBufferUShort;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        //把数据保存在rrequest阈中
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);
        return "/workbench/clue/index";
    }
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
            clue.setId(UUIDUtils.getUUID());
            clue.setCreateBy(user.getId());
            clue.setCreateTime(DateUtils.formateDateTime(new Date()));
            try {
                int i = clueService.saveCreateClue(clue);
                if (i>0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                    returnObject.setMessage("系统忙请稍候");
                }
            }catch (Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("系统忙请稍候");
            }
            return returnObject;
    }
            @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
            @ResponseBody
            public Object  queryClueByConditionForPage(String fullname,String company,String phone,String mphone,String owner,String state,String source,int pageNo,int pageSize){
                Map<String,Object> map =new HashMap<>();
                map.put("fullname",fullname);
                map.put("company",company);
                map.put("phone",phone);
                map.put("mphone",mphone);
                map.put("owner",owner);
                map.put("state",state);
                map.put("source",source);
                map.put("beginNo",(pageNo-1)*pageSize);
                map.put("pageSize",pageSize);
                List<Clue> clueList = clueService.queryClueByConditionForPage(map);
                int c = clueService.queryClueCountByConditionForPage(map);
                Map<String,Object> retMap=new HashMap<>();
                retMap.put("clueList",clueList);
                retMap.put("count",c);
                return retMap;


            }
            @RequestMapping("/workbench/clue/queryClueById.do")
            public String  queryClueById(String id,HttpServletRequest request){
                Clue clue = clueService.queryClueById(id);
                List<ClueRemark> clueRemarkList = clueService.selectClueRemarkById(id);
                List<Activity> activityList = activityService.queryActivityByClueId(id);
                request.setAttribute("clue",clue);
                request.setAttribute("clueRemarkList",clueRemarkList);
                request.setAttribute("activityList",activityList);
                System.out.println(clue.getCreateBy());
                System.out.println(clue.getNextContactTime());
                return "workbench/clue/detail";
            }
            @RequestMapping("/workbench/clue/queryClueByIdFroEdit.do")
            @ResponseBody
            public Object queryClueByIdFroEdit(String id){
                Clue clue = clueService.queryClueById(id);
                    return clue;
            }
            @RequestMapping("/workbench/clue/editClue.do")
            @ResponseBody
            public Object editClue(Clue clue,HttpSession session){
                ReturnObject returnObject = new ReturnObject();
                User user = (User) session.getAttribute(Contants.SESSION_USER);
                clue.setEditBy(user.getId());
                clue.setEditTime(DateUtils.formateDateTime(new Date()));
                try {
                    int i = clueService.updateEditClue(clue);
                    if (i>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙请稍候");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙请稍候");
                }

                return returnObject;
            }
            @RequestMapping("/workbench/clue/deleteClueByIds.do")
            @ResponseBody
            public Object deleteClueByIds(String[] id){
                ReturnObject returnObject = new ReturnObject();
                try {
                    int i = clueService.deleteClueByIds(id);
                    if (i>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙请稍候");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙请稍候");
                }
                return returnObject;
            }
            @RequestMapping("/workbench/clue/saveClueRemark.do")
            @ResponseBody
            public Object saveClueRemark(String id,String noteContent,HttpSession session){
                ReturnObject returnObject = new ReturnObject();
                User user = (User) session.getAttribute(Contants.SESSION_USER);
                ClueRemark clueRemark = new ClueRemark();
                clueRemark.setClueId(id);
                clueRemark.setNoteContent(noteContent);
                clueRemark.setCreateBy(user.getId());
                clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                clueRemark.setId(UUIDUtils.getUUID());
                clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
                try {
                    int i = clueService.saveClueRemark(clueRemark);
                    if (i>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                        returnObject.setRetData(clueRemark);
                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙请稍候");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙请稍候");
                }
        return  returnObject;
            }
            @RequestMapping("/workbench/clue/updateClueRemark.do")
            @ResponseBody
            public Object updateClueRemark(ClueRemark clueRemark,HttpSession session){
                ReturnObject returnObject = new ReturnObject();
                User user = (User) session.getAttribute(Contants.SESSION_USER);
                clueRemark.setEditBy(user.getId());
                clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
                clueRemark.setEditTime(DateUtils.formateDateTime(new Date()));
                try {
                    int i = clueService.updateClueRemark(clueRemark);
                    if (i>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                        returnObject.setRetData(clueRemark);
                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙请稍候" );
                    }
                }catch (Exception e){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙请稍候" );
                }
                return returnObject;
            }
            @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
            @ResponseBody
            public Object deleteClueRemarkById(String id){
                ReturnObject returnObject = new ReturnObject();
                try {
                    int i = clueService.deleteClueRemark(id);
                    if (i>0) {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙请重试");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙请重试");
                }
                return returnObject;
            }
            @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
            @ResponseBody
            public Object queryActivityForDetailByNameClueId(String activityName,String clueId){
                Map<String,String> map =new HashMap<>();
                System.out.println(activityName);
                map.put("activityName",activityName);
                map.put("clueId",clueId);
                List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
                return  activityList;
            }
            @RequestMapping("/workbench/clue/saveBoud.do")
            @ResponseBody
            public Object saveBoud(String[] activityId,String clueId){
                //封装参数
                ReturnObject returnObject = new ReturnObject();
                ClueActivityRelation clueActivityRelation=null;
                List<ClueActivityRelation> clueActivityRelationList=new ArrayList<>();
                for (String ai:activityId) {
                     clueActivityRelation = new ClueActivityRelation();
                    clueActivityRelation.setActivityId(ai);
                     clueActivityRelation.setClueId(clueId);
                     clueActivityRelation.setId(UUIDUtils.getUUID());
                     clueActivityRelationList.add(clueActivityRelation);
                }
                try {
                    int i = clueActivityRelationService.saveCreateClueActivityRelationByList(clueActivityRelationList);
                    if (i>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                        List<Activity> activityList=activityService.queryActivityFroDetailByIds(activityId);
                        returnObject.setRetData(activityList);
                    }else {
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("请重试");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("请重试");
                }
                return returnObject;


            }
        @RequestMapping("/workbench/clue/saveUnBund.do")
        @ResponseBody
            public Object saveUnBund(ClueActivityRelation relation){
            ReturnObject returnObject = new ReturnObject();
            try {
            int i = clueActivityRelationService.deleteClueActivityRelationByClueIDAndActivityId(relation);
            if (i>0) {
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("请重试");
            }
        }catch (Exception e){
            e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("请重试");
        }
            return  returnObject;
        }
        @RequestMapping("/workbench/clue/toConvert.do")
        public String toConvert(String id,HttpServletRequest request){
            Clue clue = clueService.queryClueById(id);
            List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
            request.setAttribute("clue",clue);
            request.setAttribute("stageList",stageList);
            return "workbench/clue/convert";

        }
        @RequestMapping("/workbench/clue/queryActivityForConvert.do")
        @ResponseBody
        public Object queryActivityForConvert(String activityName,String clueId){
            System.out.println(activityName);
            Map<String,Object> map =new HashMap<>();
            map.put("activityName",activityName);
            map.put("clueId",clueId);
            List<Activity> activityList = activityService.queryActivityFroConvertByNameAndClueId(map);
            return activityList;

        }
        @RequestMapping("/workbench/clue/convertClue.do")
        @ResponseBody
        public Object convertClue(String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran,HttpSession session){
            Map<String,Object> map=new HashMap<>();
            map.put("clueId",clueId);
            map.put("money",money);
            map.put("name",name);
            map.put("expectedDate",expectedDate);
            map.put("stage",stage);
            map.put("activityId",activityId);
            map.put("isCreateTran",isCreateTran);
            map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));
            //调用service方法保存数据
            ReturnObject returnObject=new ReturnObject();
            try {
                clueService.saveConvertClue(map);
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }catch (Exception e){
                e.printStackTrace();
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("请重试");

            }
        return  returnObject;

        }
}
