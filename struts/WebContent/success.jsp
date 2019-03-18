<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	You're successfull!
	<s:debug></s:debug>
	<!-- 如果不写value，则直接输出栈顶元素 -->
	<s:property />
	<!-- 若传的是对象，则可以直接写入对象的属性名称，即可获得属性的值 -->
	<s:property value="name" />
	<s:property value="age" />
	<h5>map栈</h5>
	<!-- 直接将数据放置到map栈中，则需要添加#号，然后通过key来获得 -->
	<s:property value="#person.name" />
	<s:property value="#person.age" />
	<h5>域对象</h5>
	<!-- 将数据放置到域对象中，需添加域对象的key，然后得到属性值的key -->
	<s:property value="#request.persons.name" />
	<s:property value="#request.persons.age" />
	<h5>attr</h5>
	<!-- attr属性可以实现从各种域对象中查找数据 -->
	<s:property value="#attr.persons.name" />
	<h5>parameters获取</h5>
	<s:property value="#parameters.id[1]" />
	
	<s:iterator >
	
	</s:iterator>
</body>
</html>