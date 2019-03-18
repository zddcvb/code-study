<%@ page import = "jtbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage.default", "tpl");
    String tgenre = "";
    //********************************************************************************//
    String tATGenre = conf.getActiveGenre("category", conf.getActualRouteB("./"));
    if (!cls.isEmpty(tATGenre))
    {
      String[] tATGenreAry = tATGenre.split(Pattern.quote("|"));
      for (int ti = 0; ti < tATGenreAry.length; ti ++)
      {
        String[][] tAry = conf.jt.itakes("global." + tATGenreAry[ti] + ":category.all", "cfg");
        for (int tis = 0; tis < tAry.length; tis ++)
        {
          if (!cls.getString(tAry[tis][0]).equals("&hidden"))
          {
            tgenre = encode.htmlencode(tATGenreAry[ti]);
            break;
          }
        }
        if (!cls.isEmpty(tgenre)) break;
      }
    }
    //********************************************************************************//
    tmpstr = tmpstr.replace("{$genre}", tgenre);
    tmpstr = conf.jt.creplace(tmpstr);
    PageClose();
    return tmpstr;
  }
}
%>