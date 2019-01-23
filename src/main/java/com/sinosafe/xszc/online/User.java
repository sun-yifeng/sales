package com.sinosafe.xszc.online;

import javax.servlet.http.HttpSessionBindingListener;
import javax.servlet.http.HttpSessionBindingEvent;

public class User implements HttpSessionBindingListener {
	private String name;
	private UserList ul = UserList.getInstance();

	public User() {
	}

	public User(String name) {
		this.name = name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	/*
	 * 当User对象加入到Session中时，Servlet容器将调用valueBound()方法，我们将用户的名字保存到用户列表中。
	 */
	public void valueBound(HttpSessionBindingEvent event) {
		ul.addUser(name);
	}

	/*
	 * 当User对象从Session中被删除时，Servlet容器将调用valueUnbound()方法，我们从用户列表中删除该用户
	 */
	public void valueUnbound(HttpSessionBindingEvent event) {
		ul.removeUser(name);
	}
}
