/**
 * Project Name:fastPlat
 * File Name:SysLog.java
 * Package Name:com.fast.base
 * Date:2015年3月5日下午11:20:17
 * Copyright (c) 2015, lsflu@126.com All Rights Reserved.
 *
*/

package com.sinosafe.xszc.main.service;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * ClassName:SysLog <br/>
 * 用途:用于controlller方法拦截时的说明其它用途<br/>
 * 开发人员：lushuifa  http://lushuifa.iteye.com/
 * 邮箱:lsflu@126.com
 * @version  
 * @since    JDK 1.6
 * @see
 * Date:     2015年3月5日 下午11:20:17 <br/> 	 
 */
@Target({java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.FIELD,java.lang.annotation.ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface VisitDesc {

	/**
	 * 简要说明: 该方法或者类是做什么用的 <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月22日 上午8:52:50 </pre>
	 */
	String label() default "";
	
	/**
	 * 简要说明:操作类型 【1、增加  2、删除  3、修改 4、查询   】  <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月22日 上午8:52:50 </pre>
	 */
	int actionType() default 1;
	
	/**
	 * 简要说明:是否用于访问记录，默认为false则为需要进行访问记录监控,为true,该方法不纳入访问监控中  <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月22日 上午8:52:50 </pre>
	 */
	boolean hidden() default false;
   
}

