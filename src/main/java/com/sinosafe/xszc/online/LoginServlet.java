package com.sinosafe.xszc.online;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.hf.framework.service.security.CurrentUser;

public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(LoginServlet.class);

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String userCode = CurrentUser.getUser().getUserCode();
		log.debug(userCode);
		response.sendRedirect("http://10.1.109.27:8080/sso");

//		if (null == name || null == pwd || name.equals("") || pwd.equals("")) {
//			resp.sendRedirect("main/mainFrame");
//		} else {
//			HttpSession session = req.getSession();
//			User user = (User) session.getAttribute("user");
//			// 用户是否更换了一个用户名登录
//			if (null == user || !name.equals(user.getName())) {
//				user = new User(name);
//				session.setAttribute("user", user);
//			}
//
//			resp.setContentType("text/html;charset=gb2312");
//			PrintWriter out = resp.getWriter();
//
//			log.debug("欢迎用户<b>" + name + "</b>登录");
//			UserList ul = UserList.getInstance();
//			log.debug("<br>当前在线的用户列表：<br>");
//			Enumeration<String> enums = ul.getUserList();
//			int i = 0;
//			while (enums.hasMoreElements()) {
//				log.debug(enums.nextElement());
//				log.debug("&nbsp;&nbsp;&nbsp;&nbsp;");
//				if (++i == 10) {
//					log.debug("<br>");
//				}
//			}
//			log.debug("<br>当前在线的用户数：" + i);
//			log.debug("<p><a href=logout>退出登录</a>");
//			out.close();
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
