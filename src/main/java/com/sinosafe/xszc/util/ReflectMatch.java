package com.sinosafe.xszc.util;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class ReflectMatch {
	// 封装属性
	private Map<String, Field> fieldMap = new HashMap<String, Field>();
	// 封装属性的set方法
	private Map<String, Method> methodMap = new HashMap<String, Method>();

	public Object setValue(Object c, @SuppressWarnings("rawtypes") Map values) {
		Object obj = null;
		try {
			Field[] fields = c.getClass().getDeclaredFields();

			Method[] methods = c.getClass().getDeclaredMethods();
			String meth = "";
			for (Field field : fields) {
				String attri = field.getName();
				fieldMap.put(attri.toLowerCase(), field);
				for (Method method : methods) {
					meth = method.getName();
					// 匹配set方法
					if (meth != null && "set".equals(meth.substring(0, 3)) && Modifier.isPublic(method.getModifiers())
							&& ("set" + Character.toUpperCase(attri.charAt(0)) + attri.substring(1)).equals(meth)) {
						methodMap.put(attri.toLowerCase(), method);
						break;
					}
				}
			}

			// 2、属性赋值
			for (Iterator it = values.keySet().iterator(); it.hasNext();) {
				String name = (String) it.next();
				String value = (String) values.get(name);

				if (value == null)
					continue;
				value = value.trim();
				name = name.trim();

				Field field = fieldMap.get(name.toLowerCase());
				if (field == null)
					continue;
				Method method = methodMap.get(name.toLowerCase());
				if (method == null)
					continue;
				obj = fill(c, field, method, value);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

	/**
	 * 将字符串值转换为合适的值填充到对象的指定域
	 * 
	 * <pre>
	 * @param bean 被填充的java bean
	 * @param field 需要填充的域
	 * @param value 字符串值
	 */
	public static Object fill(Object bean, Field field, Method method, String value) {
		Object obj = null;
		if (value == null || "null".equalsIgnoreCase(value))
			return null;

		try {
			Object[] oo = new Object[1];

			String type = field.getType().getName();

			if ("java.lang.String".equals(type)) {
				oo[0] = value;
			} else if ("java.lang.Integer".equals(type)) {
				if (value.length() > 0)
					oo[0] = Integer.valueOf(value);
			} else if ("java.lang.Float".equals(type)) {
				if (value.length() > 0)
					oo[0] = Float.valueOf(value);
			} else if ("java.lang.Double".equals(type)) {
				if (value.length() > 0)
					oo[0] = Double.valueOf(value);
			} else if ("java.math.BigDecimal".equals(type)) {
				if (value.length() > 0)
					oo[0] = new BigDecimal(value);
			} else if ("java.util.Date".equals(type)) {
				if (value.length() > 0) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");
					Date date = new Date();
					oo[0] = sdf.format(date.getDate());
				}
			} else if ("java.sql.Timestamp".equals(type)) {
				// if (value.length() > 0) oo[0] = DateTimeUtil.create(value,
				// "yyyy-mm-dd hh:mi:ss").toTimestamp();
			} else if ("java.lang.Boolean".equals(type)) {
				if (value.length() > 0)
					oo[0] = Boolean.valueOf(value);
			} else if ("java.lang.Long".equals(type)) {
				if (value.length() > 0)
					oo[0] = Long.valueOf(value);
			}

			obj = method.invoke(bean, oo);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

	/**
	 * 将一个 JavaBean 对象转化为一个 Map
	 * 
	 * <pre>
	 * @param bean 要转化的JavaBean 对象
	 * @return 转化出来的 Map 对象
	 * @throws IntrospectionException 如果分析类属性失败
	 * @throws IllegalAccessException  如果实例化 JavaBean 失败
	 * @throws InvocationTargetException 如果调用属性的 setter 方法失败
	 * </pre>
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map convertBean(Object bean) throws IntrospectionException, IllegalAccessException, InvocationTargetException {
		Class type = bean.getClass();
		Map returnMap = new HashMap();
		BeanInfo beanInfo = Introspector.getBeanInfo(type);

		PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
		for (int i = 0; i < propertyDescriptors.length; i++) {
			PropertyDescriptor descriptor = propertyDescriptors[i];
			String propertyName = descriptor.getName();
			if (!propertyName.equals("class")) {
				Method readMethod = descriptor.getReadMethod();
				Object result = readMethod.invoke(bean, new Object[0]);
				if (result != null) {
					returnMap.put(propertyName, result);
				} else {
					returnMap.put(propertyName, "");
				}
			}
		}
		return returnMap;
	}
}
