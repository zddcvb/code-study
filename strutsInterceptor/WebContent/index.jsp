<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<s:form action="interceptor_login.action">
		用户名：<s:textfield name="username"></s:textfield>
		<br />
		密码：<s:password name="password"></s:password>
		<br />
		<s:submit value="submit"></s:submit>
	</s:form>
	<s:if test="#message!=null">
		<s:property value="#message" />
	</s:if>
	<s:actionerror/>
</body>
</html>