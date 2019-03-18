package com.yanxi.demo.controller;

import org.springframework.core.convert.converter.Converter;
import org.springframework.format.annotation.NumberFormat;
import org.springframework.stereotype.Component;
@Component
public class MyConversion implements Converter<String, Number>{
	@NumberFormat
	/**
	 * 具体的转换实现
	 */
	public Number convert(String source) {
		return null;
	}
}
