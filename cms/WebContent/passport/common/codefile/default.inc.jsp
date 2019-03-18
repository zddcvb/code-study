<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.io.*" %>
<%
class module extends jpage
{
  private account account;

  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    account = new account(conf);
    account.Init(conf.getNGenre() + "/account");
    account.UserInit();
    String turl = "account/?type=manage";
    if (!account.checkUserLogin()) turl = "account/?type=login";
    PageClose();

    try
    {
      conf.response.sendRedirect(turl);
    }
    catch(Exception e) {}
    return tmpstr;
  }
}
%>