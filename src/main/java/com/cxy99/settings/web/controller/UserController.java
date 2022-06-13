package com.cxy99.settings.web.controller;

import com.cxy99.commons.contants.Contants;
import com.cxy99.commons.domain.ReturnObject;
import com.cxy99.commons.utils.DateUtils;
import com.cxy99.settings.domain.User;
import com.cxy99.settings.service.UserService;
import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private  UserService userService;
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "/settings/qx/user/login";
    }
   @RequestMapping("/settings/qx/user/login.do")
   @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
      Map<String,Object> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用service方法查询
       User user= userService.qureyUserByActAndPwd(map);
       System.out.println(user);
       ReturnObject returnObject = new ReturnObject();
       //生产响应信息
       if(user==null){
           //登录失败
           returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
           returnObject.setMessage("用户名或者密码错误");
       }else {//用户名密码合法
//           DateUtils.formateDateTime(new Date());
//           String nowStr = sdf.format(new Date());
           if (DateUtils.formateDateTime(new Date()).compareTo(user.getExpireTime())>0){
               //登录失败账号过期
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
               returnObject.setMessage("账号已过期");
           }else  if (user.getLockState().equals(Contants.RETURN_OBJECT_CODE_FAIL)){
               //登陆失败 账号被锁定
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
               returnObject.setMessage("用户名被锁定");
           }
//           else if (!user.getAllowIps().contains(request.getRemoteAddr())){
////               System.out.println(request.getRemoteAddr().contains(user.getAllowIps()));
////               //登录失败 ip受限
//
////               System.out.println(request.getRemoteAddr());
////               System.out.println(user.getAllowIps());
//               returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
//               returnObject.setMessage("ip不合法");
//           }
           else {
               //登录成功
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
               //吧user对象保存到seesion
               session.setAttribute(Contants.SESSION_USER,user);
               //判断用户是否选定记住密码
               if (isRemPwd.equals("true")){
                   Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                   c1.setMaxAge(10*24*60*60);
                   response.addCookie(c1);
                   Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                   c2.setMaxAge(10*24*60*60);
                   response.addCookie(c2);
               }else {
                   //把没有过期的cookie删除
                   Cookie c1 = new Cookie("loginAct", "1");
                   c1.setMaxAge(0);
                   response.addCookie(c1);
                   Cookie c2 = new Cookie("loginPwd", "1");
                   c2.setMaxAge(0);
                   response.addCookie(c2);
               }
           }
       }
                return returnObject;

    }
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        //清空cookie
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);
//        销毁seesion
        session.invalidate();
        return "redirect:/ ";
    }
}
