package com.sinosafe.xszc.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
//http://blog.csdn.net/liuwenbo0920/article/details/7290586/
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
	String hello() default "gege";

	String world();

	int[] array() default { 2, 4, 5, 6 };

	//Enum.TrafficLamp lamp();

	//TestAnnotation lannotation() default @TestAnnotation(value = "ddd");

	Class style() default String.class;
}
