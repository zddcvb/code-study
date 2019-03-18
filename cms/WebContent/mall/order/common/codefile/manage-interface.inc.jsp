<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private admin admin;

  private String PP_Get_Products_Topic(String argID)
  {
    String tmpstr = "";
    Integer tid = cls.getNum(argID, 0);
    String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
    String tdatabase = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"));
      tmpstr += "[" + (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "snum")) + "]";
      tmpstr = encode.htmlencode(tmpstr);
    }
    if (cls.isEmpty(tmpstr)) tmpstr = conf.jt.itake("manage.topic_error_1", "lng");
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    //********************************************************************************//
    String tolist = "";
    Integer tolistnum = cls.getNum(conf.getRequestUsParameter("olistnum"), 0);
    for(int ti = 0; ti < tolistnum; ti ++)
    {
      Integer tolist_id = cls.getNum(conf.getRequestUsParameter("olist_id_" + ti), 0);
      Integer tolist_num = cls.getNum(conf.getRequestUsParameter("olist_num_" + ti), 0);
      Double tolist_price = cls.getDouble(conf.getRequestUsParameter("olist_price_" + ti));
      if (tolist_id != 0 && tolist_num != 0) tolist += tolist_id + "|:|" + tolist_num + "|:|" + tolist_price + "|-|";
    }
    if (!cls.isEmpty(tolist)) tolist = cls.getLRStr(tolist, "|-|", "leftr");
    //********************************************************************************//
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "update " + tdatabase + " set ";
    tsqlstr += cls.cfnames(tfpre, "olist") + "='" + cls.getLeft(encode.addslashes(tolist), 10000) + "',";
    tsqlstr += cls.cfnames(tfpre, "totalprice") + "=" + cls.getDouble(conf.getRequestUsParameter("totalprice"), 0.0) + ",";
    tsqlstr += cls.cfnames(tfpre, "name") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "address") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("address")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "zipcode") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("zipcode")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "phone") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("phone")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "email") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "remark") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("remark")), 10000) + "',";
    tsqlstr += cls.cfnames(tfpre, "state") + "=" + cls.getNum(conf.getRequestUsParameter("state"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "time") + "='" + cls.getDate(conf.getRequestUsParameter("time")) + "'";
    tsqlstr += " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    return tmpstr;
  }

  private String Module_Olist_Add()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    tmpstr = conf.jt.itake("manage-interface.olist_add", "tpl");
    tmpstr = tmpstr.replace("{$id}", cls.toString(tId));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Olist_Edit()
  {
    String tmpstr = "";
    String tmpoutstr = "";
    Integer tFid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tFid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("manage-interface.olist_edit", "tpl");
      int ti = 0;
      String tOlist = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "olist"));
      if (!cls.isEmpty(tOlist))
      {
        String[] tOlistAry = tOlist.split(Pattern.quote("|-|"));
        for (int tis = 0; tis < tOlistAry.length; tis ++)
        {
          String tval = tOlistAry[tis];
          if (!cls.isEmpty(tval))
          {
            String[] tvalAry = tval.split(Pattern.quote("|:|"));
            if (tvalAry.length == 3)
            {
              ti += 1;
              String tmptstr = tmpstr;
              tmptstr = tmptstr.replace("{$id}", cls.toString(ti));
              tmptstr = tmptstr.replace("{$pid}", encode.htmlencode(tvalAry[0]));
              tmptstr = tmptstr.replace("{$num}", encode.htmlencode(tvalAry[1]));
              tmptstr = tmptstr.replace("{$price}", encode.htmlencode(tvalAry[2]));
              tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(PP_Get_Products_Topic(tvalAry[0])));
              tmpoutstr += tmptstr;
            }
          }
        }
      }
    }
    tmpoutstr = conf.jt.creplace(tmpoutstr);
    tmpoutstr = conf.ajaxPreContent + tmpoutstr;
    return tmpoutstr;
  }

  private String Module_Olist()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("otype"));
    if (tAtype.equals("add")) tmpstr = Module_Olist_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Olist_Edit();
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("manage-interface.edit", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = conf.jt.creplace(tmpstr);
    }
    else tmpstr = conf.jt.itake("global.lng_common.edit-404", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    Integer tpage = cls.getNum(conf.getRequestUsParameter("page"));
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where 1=1";
    if (tfield.equals("orderid")) tsqlstr += " and " + cls.cfnames(tfpre, "orderid") + " like '%" + tkeyword + "%'";
    if (tfield.equals("state")) tsqlstr += " and " + cls.cfnames(tfpre, "state") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("id")) tsqlstr += " and " + cls.cfnames(tfpre, "id") + "=" + cls.getNum(tkeyword);
    tsqlstr += " order by " + cls.cfnames(tfpre, "time") + " desc";
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
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();

    String tmpstr = "";

    admin = new admin(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("olist")) tmpstr = Module_Olist();
      else if (tType.equals("edit")) tmpstr = Module_Edit();
      else if (tType.equals("list")) tmpstr = Module_List();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>