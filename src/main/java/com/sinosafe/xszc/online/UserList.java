package com.sinosafe.xszc.online;

import java.util.Vector;
import java.util.Enumeration;


public class UserList {
	private Vector<String> v;
	private static final UserList onLineInfo = new UserList();

	private UserList() {
		// 同步
		v = new Vector<String>();
	}

	// 单例
	public static UserList getInstance() {
		return onLineInfo;
	}

	public void addUser(String name) {
		if (name != null)
			v.addElement(name);
	}

	public void removeUser(String name) {
		if (name != null)
			v.remove(name);
	}

	public Enumeration<String> getUserList() {
		return v.elements();
	}

	public int getUserCount() {
		return v.size();
	}
}
