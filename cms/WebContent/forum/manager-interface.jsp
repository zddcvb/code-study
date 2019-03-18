<%@ page contentType = "text/html;charset=utf-8" %>
<%@ include file = "common/codefile/manager-interface.inc.jsp" %>
<%
out.clear();
module module = new module();
module.Init(request, response);
String nOutput = module.getOutput();
module.PagePrint(nOutput);
%>
