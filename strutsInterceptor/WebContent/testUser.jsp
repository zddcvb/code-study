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
	<s:form action="convert_getConvertList.action" namespace="/">
		<s:textfield name="user"></s:textfield>
		<br />
		<s:checkboxlist list="{' java','c#','php','python'}" name="lists"></s:checkboxlist>
		<s:submit value="submit"></s:submit>
	</s:form>
</body>
</html>