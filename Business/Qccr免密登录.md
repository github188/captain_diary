


``` java
/*
* Copyright (c) 2015-2018 SHENZHEN  SCIENCE AND TECHNOLOGY DEVELOP CO., LTD. All rights reserved.  
*
* 注意：本内容仅限于深圳市研发有限公司内部传阅，禁止外泄以及用于其他的商业目的 
*/
package com.jst.app.controller.qccr;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jst.app.bean.Result;
import com.jst.app.bo.BaseBo;
import com.jst.app.common.enums.ReturnCodeEnum;
import com.jst.app.controller.BaseController;
import com.jst.app.util.GetParamConfig;
import com.jst.app.util.HttpUtil;
import com.jst.prodution.constants.ApiConstants;
import com.jst.prodution.member.serviceBean.LoginBean;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;

@Api(value = "从首页进入汽车超人接口")
@RestController
@RequestMapping("/qccr")
public class QccrController extends BaseController {
	  private final static Logger log = LoggerFactory.getLogger(QccrController.class);
	  @Resource
		private RedisTemplate<String, LoginBean> redisLogTemplate;
	    @ApiOperation(value="进入汽车超人轮胎H5页面", notes="http://ip:port/app/swagger-ui.html")
	    @ApiImplicitParams({
	    @ApiImplicitParam(name = "SESSIONNO", value = "登录的SESSIONNO", required = true, paramType = "header" , dataType = "String")
	    })
	    @RequestMapping(value = "/tyres", method = RequestMethod.POST)
	    @ResponseBody
	    public Result tyres(HttpServletRequest request, @RequestBody BaseBo bo) {
	    	log.info("-----请求汽车超人轮胎页面------------");
	        Result result = new Result();
	        String SESSIONNO = request.getHeader("SESSIONNO") ;
			LoginBean bean = selUserid5(SESSIONNO) ;
			if(null == bean){
				return new Result(ReturnCodeEnum.NO_LOGIN.getCode(), ReturnCodeEnum.NO_LOGIN.getDesc());
			}
			log.info("LoginBean:{}",JSON.toJSONString(bean));
			TreeMap<String,String> tMap  = new TreeMap<String,String>();
			tMap.put("username", bean.getMobile());
			tMap.put("timestamp", System.currentTimeMillis()+"");
			tMap.put("app_key", GetParamConfig.getParam("qccrAppKey"));
			tMap.put("thirduser_id",bean.getUserId());
			tMap.put("sign", QccrHelper.getSign(tMap));
			log.info("登录请求报文：【{}】",tMap);
			Map<String,String> dataMap = null;
			try {
				String retStr = HttpUtil.post(GetParamConfig.getParam("qccrRequestPathContextUrl")+"/user/login", tMap, 30, "UTF-8", null);
				log.info("汽车超人返回登录信息：【{}】",retStr);
				JSONObject jo = JSON.parseObject(retStr);
				if("0".equals(jo.get("code")+"")){
					String qccrSessionId = (JSON.parseObject(jo.get("info").toString())).get("session_id").toString();
					dataMap = new HashMap<String,String>();
					dataMap.put("url",GetParamConfig.getParam("qccrTyresPage")+"?app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					//put LoginBean into redis(qccrAppKey as key)，get it before pay
					bean.setToken(SESSIONNO);
					redisLogTemplate.opsForValue().set(ApiConstants.QCCR_PREFIX+qccrSessionId, bean);
				}else{
					result.setResType(ReturnCodeEnum.FAIL.getCode());
					result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				}
				result.setData(dataMap);
			} catch (IOException e) {
				result.setResType(ReturnCodeEnum.FAIL.getCode());
				result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				e.printStackTrace();
			}
			log.info("返回报文：【{}】",result);
	        return result;
	    }

	    @ApiOperation(value="进入汽车超人保养H5页面", notes="http://ip:port/app/swagger-ui.html")
	    @ApiImplicitParams({
	    @ApiImplicitParam(name = "SESSIONNO", value = "登录的SESSIONNO", required = true, paramType = "header" , dataType = "String")
	    })
	    @RequestMapping(value = "/maintain", method = RequestMethod.POST)
	    @ResponseBody
	    public Result maintain(HttpServletRequest request, @RequestBody BaseBo bo) {
	    	log.info("-----请求汽车超人保养页面------------");
	        Result result = new Result();
	        String SESSIONNO = request.getHeader("SESSIONNO") ;
			LoginBean bean = selUserid5(SESSIONNO) ;
			if(null == bean){
				return new Result(ReturnCodeEnum.NO_LOGIN.getCode(), ReturnCodeEnum.NO_LOGIN.getDesc());
			}
			log.info("LoginBean:{}",JSON.toJSONString(bean));
			TreeMap<String,String> tMap  = new TreeMap<String,String>();
//			tMap.put("source", source);
			tMap.put("username", bean.getMobile());
			tMap.put("timestamp", System.currentTimeMillis()+"");
			tMap.put("app_key", GetParamConfig.getParam("qccrAppKey"));
			tMap.put("thirduser_id",bean.getUserId());
			tMap.put("sign", QccrHelper.getSign(tMap));
			log.info("登录请求报文：【{}】",tMap);
			Map<String,String> dataMap = null;
			try {
				String retStr = HttpUtil.post(GetParamConfig.getParam("qccrRequestPathContextUrl")+"/user/login", tMap, 30, "UTF-8", null);
				log.info("汽车超人返回登录信息：【{}】",retStr);
				JSONObject jo = JSON.parseObject(retStr);
				if("0".equals(jo.get("code")+"")){
					String qccrSessionId = (JSON.parseObject(jo.get("info").toString())).get("session_id").toString();
					dataMap = new HashMap<String,String>();
					dataMap.put("url",GetParamConfig.getParam("qccrMaintainPage")+"?app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					//put LoginBean into redis(qccrAppKey as key)，get it before pay
					bean.setToken(SESSIONNO);
					redisLogTemplate.opsForValue().set(ApiConstants.QCCR_PREFIX+qccrSessionId, bean);
					
					
				}else{
					result.setResType(ReturnCodeEnum.FAIL.getCode());
					result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				}
				result.setData(dataMap);
			} catch (IOException e) {
				result.setResType(ReturnCodeEnum.FAIL.getCode());
				result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				e.printStackTrace();
			}
			log.info("return info:"+result);
	        return result;
	    }
	    
	    @ApiOperation(value="进入汽车超人车品商城H5页面", notes="http://ip:port/app/swagger-ui.html")
	    @ApiImplicitParams({
	    @ApiImplicitParam(name = "SESSIONNO", value = "登录的SESSIONNO", required = true, paramType = "header" , dataType = "String")
	    })
	    @RequestMapping(value = "/autoGoods", method = RequestMethod.POST)
	    @ResponseBody
	    public Result autoGoods(HttpServletRequest request, @RequestBody BaseBo bo) {
	    	log.info("-----请求汽车超人车品商城页面------------");
	        Result result = new Result();
	        String SESSIONNO = request.getHeader("SESSIONNO") ;
			LoginBean bean = selUserid5(SESSIONNO) ;
			if(null == bean){
				return new Result(ReturnCodeEnum.NO_LOGIN.getCode(), ReturnCodeEnum.NO_LOGIN.getDesc());
			}
			log.info("LoginBean:{}",JSON.toJSONString(bean));
			TreeMap<String,String> tMap  = new TreeMap<String,String>();
//			tMap.put("source", source);
			tMap.put("username", bean.getMobile());
			tMap.put("timestamp", System.currentTimeMillis()+"");
			tMap.put("app_key", GetParamConfig.getParam("qccrAppKey"));
			tMap.put("thirduser_id",bean.getUserId());
			tMap.put("sign", QccrHelper.getSign(tMap));
			log.info("登录请求报文：【{}】",tMap);
			Map<String,String> dataMap = null;
			try {
				
				String retStr = HttpUtil.post(GetParamConfig.getParam("qccrRequestPathContextUrl")+"/user/login", tMap, 30, "UTF-8", null);
				log.info("汽车超人返回登录信息：【{}】",retStr);
				JSONObject jo = JSON.parseObject(retStr);
				if("0".equals(jo.get("code")+"")){
					String qccrSessionId = (JSON.parseObject(jo.get("info").toString())).get("session_id").toString();
					dataMap = new HashMap<String,String>();
					dataMap.put("url",GetParamConfig.getParam("qccrAutoGoods")+"?app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					//put LoginBean into redis(qccrAppKey as key)，get it before pay
					bean.setToken(SESSIONNO);
					redisLogTemplate.opsForValue().set(ApiConstants.QCCR_PREFIX+qccrSessionId, bean);
				}else{
					result.setResType(ReturnCodeEnum.FAIL.getCode());
					result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				}
				result.setData(dataMap);
			} catch (IOException e) {
				result.setResType(ReturnCodeEnum.FAIL.getCode());
				result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				e.printStackTrace();
			}
			log.info("返回报文：【{}】",result);
	        return result;
	    }
	    
	    
	    /**
	     * //qccrWashCar
	     * @param request
	     * @param bo
	     * @return
	     */
	    
	    @ApiOperation(value="进入汽车超人车品商城H5页面", notes="http://ip:port/app/swagger-ui.html")
	    @ApiImplicitParams({
	    @ApiImplicitParam(name = "SESSIONNO", value = "登录的SESSIONNO", required = true, paramType = "header" , dataType = "String")
	    })
	    @RequestMapping(value = "/washCar", method = RequestMethod.POST)
	    @ResponseBody
	    public Result washCar(HttpServletRequest request, @RequestBody BaseBo bo) {
	    	log.info("-----请求汽车超人洗车页面------------");
	        Result result = new Result();
	        String SESSIONNO = request.getHeader("SESSIONNO") ;
			LoginBean bean = selUserid5(SESSIONNO) ;
			if(null == bean){
				return new Result(ReturnCodeEnum.NO_LOGIN.getCode(), ReturnCodeEnum.NO_LOGIN.getDesc());
			}
			log.info("LoginBean:{}",JSON.toJSONString(bean));
			TreeMap<String,String> tMap  = new TreeMap<String,String>();
//			tMap.put("source", source);
			tMap.put("username", bean.getMobile());
			tMap.put("timestamp", System.currentTimeMillis()+"");
			tMap.put("app_key", GetParamConfig.getParam("qccrAppKey"));
			tMap.put("thirduser_id",bean.getUserId());
			tMap.put("sign", QccrHelper.getSign(tMap));
			log.info("登录请求报文：【{}】",tMap);
			Map<String,String> dataMap = null;
			try {
				
				String retStr = HttpUtil.post(GetParamConfig.getParam("qccrRequestPathContextUrl")+"/user/login", tMap, 30, "UTF-8", null);
				log.info("汽车超人返回登录信息：【{}】",retStr);
				JSONObject jo = JSON.parseObject(retStr);
				if("0".equals(jo.get("code")+"")){
					String qccrSessionId = (JSON.parseObject(jo.get("info").toString())).get("session_id").toString();
					dataMap = new HashMap<String,String>();
					dataMap.put("url",GetParamConfig.getParam("qccrWashCar")+"?app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					//put LoginBean into redis(qccrAppKey as key)，get it before pay
					bean.setToken(SESSIONNO);
					redisLogTemplate.opsForValue().set(ApiConstants.QCCR_PREFIX+qccrSessionId, bean);
				}else{
					result.setResType(ReturnCodeEnum.FAIL.getCode());
					result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				}
				result.setData(dataMap);
			} catch (IOException e) {
				result.setResType(ReturnCodeEnum.FAIL.getCode());
				result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				e.printStackTrace();
			}
			log.info("返回报文：【{}】",result);
	        return result;
	    }
	    
	    
	    /**
	     * //qccrWashCar
	     * @param request
	     * @param bo
	     * @return
	     */
	    
	    @ApiOperation(value="进入汽车超人车品商城H5页面", notes="http://ip:port/app/swagger-ui.html")
	    @ApiImplicitParams({
	    @ApiImplicitParam(name = "SESSIONNO", value = "登录的SESSIONNO", required = true, paramType = "header" , dataType = "String")
	    })
	    @RequestMapping(value = "/indexQccrUrls", method = RequestMethod.POST)
	    @ResponseBody
	    public Result IndexQccrUrls(HttpServletRequest request, @RequestBody BaseBo bo) {
	    	log.info("-----首页请求汽车超人详情页------------");
	        Result result = new Result();
	        String SESSIONNO = request.getHeader("SESSIONNO") ;
			LoginBean bean = selUserid5(SESSIONNO) ;
			if(null == bean){
				return new Result(ReturnCodeEnum.NO_LOGIN.getCode(), ReturnCodeEnum.NO_LOGIN.getDesc());
			}
			log.info("LoginBean:{}",JSON.toJSONString(bean));
			TreeMap<String,String> tMap  = new TreeMap<String,String>();
//			tMap.put("source", source);
			tMap.put("username", bean.getMobile());
			tMap.put("timestamp", System.currentTimeMillis()+"");
			tMap.put("app_key", GetParamConfig.getParam("qccrAppKey"));
			tMap.put("thirduser_id",bean.getUserId());
			tMap.put("sign", QccrHelper.getSign(tMap));
			log.info("登录请求报文：【{}】",tMap);
			Map<String,String> dataMap = null;
			try {
				
				String retStr = HttpUtil.post(GetParamConfig.getParam("qccrRequestPathContextUrl")+"/user/login", tMap, 30, "UTF-8", null);
				log.info("汽车超人返回登录信息：【{}】",retStr);
				JSONObject jo = JSON.parseObject(retStr);
				if("0".equals(jo.get("code")+"")){
					String qccrSessionId = (JSON.parseObject(jo.get("info").toString())).get("session_id").toString();
					dataMap = new HashMap<String,String>();
					dataMap.put("url1",GetParamConfig.getParam("indexQccr1")+"&app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					dataMap.put("url2",GetParamConfig.getParam("indexQccr2")+"&app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					dataMap.put("url3",GetParamConfig.getParam("indexQccr3")+"&app_key="+
							GetParamConfig.getParam("qccrAppKey")+"&session_id="+qccrSessionId);
					//put LoginBean into redis(qccrAppKey as key)，get it before pay
					bean.setToken(SESSIONNO);
					redisLogTemplate.opsForValue().set(ApiConstants.QCCR_PREFIX+qccrSessionId, bean);
				}else{
					result.setResType(ReturnCodeEnum.FAIL.getCode());
					result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				}
				result.setData(dataMap);
			} catch (IOException e) {
				result.setResType(ReturnCodeEnum.FAIL.getCode());
				result.setMsgContent(ReturnCodeEnum.FAIL.getDesc());
				e.printStackTrace();
			}
			log.info("返回报文：【{}】",result);
	        return result;
	    }
	    
	    
	    
	    


		
	    
}


```
