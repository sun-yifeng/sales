package com.sinosafe.xszc.notice.service;

import java.util.Calendar;

public class DateUtils {

	/**
	 * 取这周的周一
	 */
	public static Calendar getMonday(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		return cal;

	}

	/**
	 * 取下周的周一 
	 */
	public static Calendar getNextMonday(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		cal.add(Calendar.DAY_OF_WEEK, 7);
		return cal;

	}

	public static Calendar getMonth(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_MONTH, 1);
		return cal;

	}

	/**
	 * 取下周的周一 
	 */
	public static Calendar getNextMonth(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.add(Calendar.MONTH, 1);
		return cal;

	}

	/**
	 * 取这周的周一 
	 */
	public static Calendar getYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_YEAR, 1);
		return cal;

	}

	/**
	 * 取下周的周一
	 */
	public static Calendar getNextYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.setFirstDayOfWeek(Calendar.MONDAY); // 以周1为首日

		cal.set(Calendar.DAY_OF_YEAR, 1);
		cal.add(Calendar.YEAR, 1);
		return cal;

	}

	/**
	 * 取这半年
	 */
	public static Calendar getHalfYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		int month = (cal.get(Calendar.MONTH)) + 1;

		cal.set(Calendar.DAY_OF_YEAR, 1);

		if (month >= 6) {
			cal.add(Calendar.MONTH, 6);
		}

		return cal;

	}

	/**
	 * 取下半年 
	 */
	public static Calendar getNextHalfYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		int month = (cal.get(Calendar.MONTH)) + 1;

		cal.set(Calendar.DAY_OF_YEAR, 1);

		if (month >= 6) {
			cal.add(Calendar.MONTH, 6);
		}
		cal.add(Calendar.MONTH, 6);
		return cal;

	}

	/**
	 * 取这半年 
	 */
	public static Calendar getQuarYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		int month = (cal.get(Calendar.MONTH)) + 1;
		cal.set(Calendar.DAY_OF_YEAR, 1);

		if (month >= 9) {
			cal.add(Calendar.MONTH, 9);
		} else if (month >= 6) {
			cal.add(Calendar.MONTH, 6);
		} else if (month >= 3) {
			cal.add(Calendar.MONTH, 3);
		}
		return cal;

	}

	/**
	 * 取下半年
	 */
	public static Calendar getNextQuarYear(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		int month = (cal.get(Calendar.MONTH)) + 1;
		cal.set(Calendar.DAY_OF_YEAR, 1);

		if (month >= 9) {
			cal.add(Calendar.MONTH, 9);
		} else if (month >= 6) {
			cal.add(Calendar.MONTH, 6);
		} else if (month >= 3) {
			cal.add(Calendar.MONTH, 3);
		}

		cal.add(Calendar.MONTH, 3);

		return cal;

	}

	/**
	 * 取这半年
	 */
	public static Calendar getDay(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}
		return cal;

	}

	/**
	 * 取下半年
	 */
	public static Calendar getNextDay(Calendar date) {
		Calendar cal;
		if (date == null) {
			cal = Calendar.getInstance();
		} else {
			cal = date;
		}

		cal.add(Calendar.DATE, 1);
		return cal;

	}

}
