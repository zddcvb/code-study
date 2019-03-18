package com.yanxi.linux.utils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonUtils {
	private static final ObjectMapper MAPPER = new ObjectMapper();
	/**
	 * list转成json
	 * @param obj
	 * @return
	 */
	public static <T> String listToJson(Object obj) {
		String string = null;
		try {
			string = MAPPER.writeValueAsString(obj);
			return new String(string.getBytes(), "utf-8");
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * json转成list
	 * @param json
	 * @param beanType
	 * @return
	 */
	public static <T> List<T> jsonToList(String json, Class<T> beanType) {
		JavaType javaType = MAPPER.getTypeFactory().constructParametricType(List.class, beanType);
		try {
			List<T> list = MAPPER.readValue(json, javaType);
			return list;
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}
