<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;
  private upfiles upfiles;

  public String PP_selClass(String argStrings)
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tStrings = argStrings;
    String tLng = cls.getParameter(tStrings, "lng");
    String tFid = cls.getParameter(tStrings, "fid");
    Integer tClass = cls.getNum(cls.getParameter(tStrings, "class"), 0);
    Integer tInum = cls.getNum(cls.getParameter(tStrings, "inum"), 0);
    tmpstr = conf.jt.itake("global.tpl_common.sel-class", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + cls.getNum(tLng, 0) + " and " + cls.cfnames(tfpre, "fid") + "=" + cls.getNum(tFid, 0);
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      tInum += 1;
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        Object[][] tAry = (Object[][])tArys[tis];
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")))));
        tmptstr = tmptstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")))));
        if (tClass != cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id"))), 0)) tmptstr = tmptstr.replace("{$-selected}", "");
        else tmptstr = tmptstr.replace("{$-selected}", "selected=\"selected\"");
        tmptstr = tmptstr.replace("{$-prestr}", cls.getRepeatedString(conf.jt.itake("global.lng_common.sys-spsort", "lng"), tInum));
        tmptstr = tmptstr.replace("{$-child}", PP_selClass("lng=" + tLng + ";class=" + tClass + ";inum=" + tInum + ";fid=" + cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id"))), 0)));
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Action_Selslng()
  {
    String tmpstr = "";
    String tlng = cls.getString(conf.getRequestUsParameter("lng"));
    if (!cls.isEmpty(tlng))
    {
      tmpstr = "200";
      cookies.setAttribute(conf, conf.getAppKey("admin-slng"), tlng);
    }
    else
    {
      tmpstr = admin.selslng();
      tmpstr = conf.ajaxPreContent + tmpstr;
    }
    return tmpstr;
  }

  private String Module_Action_Batch1()
  {
    String tmpstr = "";
    Integer tClass1 = cls.getNum(conf.getRequestUsParameter("class1"), 0);
    Integer tClass2 = cls.getNum(conf.getRequestUsParameter("class2"), 0);
    String tCondition = cls.getString(conf.getRequestUsParameters("condition"));
    String tStarttime = cls.getString(conf.getRequestUsParameters("starttime"));
    String tEndtime = cls.getString(conf.getRequestUsParameters("endtime"));
    String tAuthor = cls.getSafeString(conf.getRequestUsParameters("author"));
    Long tStarttimeUnixStamp = cls.getUnixStamp(tStarttime);
    Long tEndtimeUnixStamp = cls.getUnixStamp(tEndtime);
    if (tEndtimeUnixStamp >= tStarttimeUnixStamp)
    {
      String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
      String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
      String tidfieldT = cls.cfnames(tfpreT, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstrT = "select " + tidfieldT + " from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "fid") + "=0 and " + cls.cfnames(tfpreT, "class") + "=" + tClass1;
      String tConditionSql = "";
      if (cls.cinstr(tCondition, "htop", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "htop") + "=1";
      if (cls.cinstr(tCondition, "top", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "top") + "=1";
      if (cls.cinstr(tCondition, "elite", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "elite") + "=1";
      if (cls.cinstr(tCondition, "lock", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "lock") + "=1";
      if (cls.cinstr(tCondition, "hidden", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "hidden") + "=1";
      if (!cls.isEmpty(tConditionSql)) tsqlstrT += " and (" + cls.getLRStr(tConditionSql, " or ", "rightr") + ")";
      tsqlstrT += " and " + cls.cfnames(tfpreT, "timestamp") + ">=" + tStarttimeUnixStamp + " and " + cls.cfnames(tfpreT, "timestamp") + "<=" + tEndtimeUnixStamp;
      if (!cls.isEmpty(tAuthor)) tsqlstrT += " and " + cls.cfnames(tfpreT, "author") + "='" + tAuthor + "'";
      Object[] tArysT = tDbc.getDataAry(tsqlstrT);
      if (tArysT != null)
      {
        for (int tis = 0; tis < tArysT.length; tis ++)
        {
          Object[][] tAryT = (Object[][])tArysT[tis];
          Integer tNRTid = cls.getNum(cls.toString(tDbc.getValue(tAryT, tidfieldT)), 0);
          tDbc.Execute("update " + tdatabaseT + " set " + cls.cfnames(tfpreT, "class") + "=" + tClass2 + " where (" + tidfieldT + "=" + tNRTid + " or " + cls.cfnames(tfpreT, "fid") + "=" + tNRTid + ")");
        }
      }
      tmpstr = conf.jt.itake("manage_batchprocessing.submit-done", "lng");
    }
    else tmpstr = conf.jt.itake("manage_batchprocessing.submit-error-1", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Batch2()
  {
    String tmpstr = "";
    Integer tClass = cls.getNum(conf.getRequestUsParameter("class"), 0);
    String tCondition = cls.getString(conf.getRequestUsParameters("condition"));
    String tStarttime = cls.getString(conf.getRequestUsParameters("starttime"));
    String tEndtime = cls.getString(conf.getRequestUsParameters("endtime"));
    String tAuthor = cls.getSafeString(conf.getRequestUsParameters("author"));
    Long tStarttimeUnixStamp = cls.getUnixStamp(tStarttime);
    Long tEndtimeUnixStamp = cls.getUnixStamp(tEndtime);
    if (tEndtimeUnixStamp >= tStarttimeUnixStamp)
    {
      String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
      String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
      String tidfieldT = cls.cfnames(tfpreT, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstrT = "select " + tidfieldT + " from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "fid") + "=0 and " + cls.cfnames(tfpreT, "class") + "=" + tClass;
      String tConditionSql = "";
      if (cls.cinstr(tCondition, "htop", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "htop") + "=1";
      if (cls.cinstr(tCondition, "top", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "top") + "=1";
      if (cls.cinstr(tCondition, "elite", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "elite") + "=1";
      if (cls.cinstr(tCondition, "lock", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "lock") + "=1";
      if (cls.cinstr(tCondition, "hidden", ",")) tConditionSql += " or " + cls.cfnames(tfpreT, "hidden") + "=1";
      if (!cls.isEmpty(tConditionSql)) tsqlstrT += " and (" + cls.getLRStr(tConditionSql, " or ", "rightr") + ")";
      tsqlstrT += " and " + cls.cfnames(tfpreT, "timestamp") + ">=" + tStarttimeUnixStamp + " and " + cls.cfnames(tfpreT, "timestamp") + "<=" + tEndtimeUnixStamp;
      if (!cls.isEmpty(tAuthor)) tsqlstrT += " and " + cls.cfnames(tfpreT, "author") + "='" + tAuthor + "'";
      Object[] tArysT = tDbc.getDataAry(tsqlstrT);
      if (tArysT != null)
      {
        for (int tis = 0; tis < tArysT.length; tis ++)
        {
          Object[][] tAryT = (Object[][])tArysT[tis];
          Integer tNRTid = cls.getNum(cls.toString(tDbc.getValue(tAryT, tidfieldT)), 0);
          int tstateNum = conf.common.dataDelete(tdatabaseT, tidfieldT, cls.toString(tNRTid));
          if (tstateNum != -101)
          {
            upfiles.DeleteDatabaseNote(conf.getNGenre(), cls.toString(tNRTid));
            String tsqlstrT2 = "select * from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "fid") + "=" + tNRTid;
            Object[] tArysT2 = tDbc.getDataAry(tsqlstrT2);
            if (tArysT2 != null)
            {
              for (int tis2 = 0; tis2 < tArysT2.length; tis2 ++)
              {
                Object[][] tAryT2 = (Object[][])tArysT2[tis2];
                String tFidId2 = cls.toString(tDbc.getValue(tAryT2, tidfieldT));
                int tstateNum2 = conf.common.dataDelete(tdatabaseT, tidfieldT, tFidId2);
                if (tstateNum2 != -101) upfiles.DeleteDatabaseNote(conf.getNGenre(), tFidId2);
              }
            }
          }
        }
      }
      tmpstr = conf.jt.itake("manage_batchprocessing.submit-done", "lng");
    }
    else tmpstr = conf.jt.itake("manage_batchprocessing.submit-error-1", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Batch3()
  {
    String tmpstr = "";
    Integer tClass = cls.getNum(conf.getRequestUsParameter("class"), 0);
    String tCondition = cls.getString(conf.getRequestUsParameters("condition"));
    if (!cls.isEmpty(tCondition))
    {
      String tDateNow = cls.formatDate(cls.getDate(), 1);
      Long tDateNowUnixStamp = cls.getUnixStamp(tDateNow + " 00:00:00");
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
      String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
      String tidfieldT = cls.cfnames(tfpreT, "id");
      dbc tDbc = db.newInstance(conf);
      if (cls.cinstr(tCondition, "num_note_new", ",")) tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "num_note_new") + "=(select count(*) from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "class") + "=" + tClass + " and " + cls.cfnames(tfpreT, "timestamp") + ">=" + tDateNowUnixStamp + ") where " + tidfield + "=" + tClass);
      if (cls.cinstr(tCondition, "num_topic", ",")) tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "num_topic") + "=(select count(*) from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "class") + "=" + tClass + " and " + cls.cfnames(tfpreT, "fid") + "=0) where " + tidfield + "=" + tClass);
      if (cls.cinstr(tCondition, "num_note", ",")) tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "num_note") + "=(select count(*) from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "class") + "=" + tClass + ") where " + tidfield + "=" + tClass);
      String tsqlstrT = "select * from " + tdatabaseT + " where " + tidfieldT + "=(select max(" + tidfieldT + ") from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "hidden") + "=0 and " + cls.cfnames(tfpreT, "fid") + "=0 and " + cls.cfnames(tfpreT, "class") + "=" + tClass + ")";
      Object[] tArysT = tDbc.getDataAry(tsqlstrT);
      if (tArysT != null)
      {
        Object[][] tAryT = (Object[][])tArysT[0];
        String tLastTopic = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "topic")));
        String tLastTopicTime = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "time")));
        Integer tLastTopicID = cls.getNum(cls.toString(tDbc.getValue(tAryT, tidfieldT)), 0);
        tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "last_topic") + "='" + cls.getLeft(encode.addslashes(tLastTopic), 255) + "'," + cls.cfnames(tfpre, "last_topic_time") + "='" + cls.getDate(tLastTopicTime) + "'," + cls.cfnames(tfpre, "last_topic_id") + "=" + tLastTopicID + " where " + tidfield + "=" + tClass);
      }
      tmpstr = conf.jt.itake("manage_batchprocessing.submit-done", "lng");
    }
    else tmpstr = conf.jt.itake("manage_batchprocessing.submit-done", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("selslng")) tmpstr = Module_Action_Selslng();
    else if (tAtype.equals("batch1")) tmpstr = Module_Action_Batch1();
    else if (tAtype.equals("batch2")) tmpstr = Module_Action_Batch2();
    else if (tAtype.equals("batch3")) tmpstr = Module_Action_Batch3();
    return tmpstr;
  }

  private String Module_Batch1()
  {
    String tmpstr = "";
    String tNGenre = conf.getNGenre();
    tmpstr = conf.jt.itake("manage_batchprocessing-interface.batch1", "tpl");
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
    tmpstr = tmpstr.replace("{$-class-option}", PP_selClass("lng=" + admin.slng + ";fid=0"));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Batch2()
  {
    String tmpstr = "";
    String tNGenre = conf.getNGenre();
    tmpstr = conf.jt.itake("manage_batchprocessing-interface.batch2", "tpl");
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
    tmpstr = tmpstr.replace("{$-class-option}", PP_selClass("lng=" + admin.slng + ";fid=0"));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Batch3()
  {
    String tmpstr = "";
    String tNGenre = conf.getNGenre();
    tmpstr = conf.jt.itake("manage_batchprocessing-interface.batch3", "tpl");
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
    tmpstr = tmpstr.replace("{$-class-option}", PP_selClass("lng=" + admin.slng + ";fid=0"));
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
    upfiles = new upfiles(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("batch1")) tmpstr = Module_Batch1();
      else if (tType.equals("batch2")) tmpstr = Module_Batch2();
      else if (tType.equals("batch3")) tmpstr = Module_Batch3();
      else tmpstr = Module_Batch1();
    }

    PageClose();

    return tmpstr;
  }
}
%>