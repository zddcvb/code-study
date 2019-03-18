<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.*" %>
<%
class module extends jpage
{
  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    String tkeyword = cls.getSafeString(conf.getRequestParameter("keyword"));
    tmpstr = conf.jt.itake("default.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tsqlstr = "select * from (";
    String tnsearch = cls.getString(conf.jt.itake("config.nsearch", "cfg"));
    String[] tnsearchAry = tnsearch.split(Pattern.quote(","));
    for (int ti = 0; ti < tnsearchAry.length; ti ++)
    {
      String tnGenreAryString = tnsearchAry[ti];
      String tdatabase = cls.getString(conf.jt.itake("global." + tnGenreAryString + ":config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("global." + tnGenreAryString + ":config.nfpre", "cfg"));
      if (!cls.isEmpty(tdatabase)) tsqlstr += "select " + cls.cfnames(tfpre, "id") + " as un_id," + cls.cfnames(tfpre, "topic") + " as un_topic," + cls.cfnames(tfpre, "time") + " as un_time,'" + tnGenreAryString + "' as un_genre from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "lng") + "=" + cls.getNum(conf.getNLng(), 0) + "  union all ";
    }
    if (tsqlstr.indexOf(" union all ") != -1)  tsqlstr = cls.getLRStr(tsqlstr, " union all ", "leftr");
    tsqlstr +=") t0 where un_topic like '%" + tkeyword + "%'";
    tsqlstr += " order by un_time desc";
    pagi pagi;
    pagi = new pagi(conf);
    pagi.sqlstr = tsqlstr;
    pagi.pagenum = tpage.longValue();
    pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
    pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
    pagi.Init();
    Object[] tArys = pagi.getDataAry();
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        tmptstr = tmpastr;
        Object[][] tAry = (Object[][])tArys[tis];
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], "un_", "rightr");
          tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        tmptstr = conf.jt.creplace(tmptstr);
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    if (cls.isEmpty(tmpstr)) tmpstr = Module_List();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));
    String tmpstr = "";
    tmpstr = Module_Default();
    PageClose();
    return tmpstr;
  }
}
%>