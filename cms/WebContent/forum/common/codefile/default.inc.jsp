<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private Boolean PP_CheckPopedom(String argPopedom)
  {
    Boolean tBoolean = true;
    String tPopedom = argPopedom;
    if (!cls.isEmpty(tPopedom))
    {
      tBoolean = false;
      String tUserGroup = cls.toString(account.getUserInfo("group"));
      if (cls.cinstr(tPopedom, tUserGroup, ",")) tBoolean = true;
    }
    return tBoolean;
  }

  private String PP_FormatTopic(String argTopic, String argColor, String argStrong, String argKeyword)
  {
    String tmpstr = "";
    String tTopic = argTopic;
    String tColor = argColor;
    String tStrong = argStrong;
    String tKeyword = argKeyword;
    tmpstr = tTopic;
    if (!cls.isEmpty(tKeyword)) tmpstr = tmpstr.replace(tKeyword, "<span class=\"highlight\">" + tKeyword + "</span>");
    if (!cls.isEmpty(tColor)) tmpstr = "<font color=\"" + tColor + "\">" + tmpstr + "</font>";
    if (tStrong.equals("1")) tmpstr = "<strong>" + tmpstr + "</strong>";
    return tmpstr;
  }

  private String PP_FormatLastTime(String argTime)
  {
    String tmpstr = "";
    String tTime = argTime;
    Long tTimeStamp = cls.getUnixStamp(tTime);
    Long tnTimeStamp = cls.getUnixStamp();
    Long tSecond = tnTimeStamp - tTimeStamp;
    if (tSecond < 60) tmpstr = cls.toString(tSecond) + conf.jt.itake("default.time-p-0", "lng");
    else if (tSecond >= 60 && tSecond < 3600) tmpstr = cls.toString(tSecond / 60) + conf.jt.itake("default.time-p-1", "lng");
    else if (tSecond >= 3600 && tSecond < 86400) tmpstr = cls.toString(tSecond / 3600) + conf.jt.itake("default.time-p-2", "lng");
    else if (tSecond >= 86400 && tSecond < 2592000) tmpstr = cls.toString(tSecond / 86400) + conf.jt.itake("default.time-p-3", "lng");
    else if (tSecond >= 2592000 && tSecond < 31536000) tmpstr = cls.toString(tSecond / 2592000) + conf.jt.itake("default.time-p-4", "lng");
    else tmpstr = cls.toString(tSecond / 31536000) + conf.jt.itake("default.time-p-5", "lng");
    return tmpstr;
  }

  private String PP_GetTopicIcon(String argHTop, String argTop, String argLock, String argElite, String argCount)
  {
    String tmpstr = "normal";
    String tHTop = argHTop;
    String tTop = argTop;
    String tLock = argLock;
    String tElite = argElite;
    String tCount = argCount;
    int tCountNum = cls.getNum(tCount, 0);
    if (tHTop.equals("1")) tmpstr = "htop";
    else if (tTop.equals("1")) tmpstr = "top";
    else if (tLock.equals("1")) tmpstr = "lock";
    else if (tElite.equals("1")) tmpstr = "elite";
    else if (tCountNum > 200) tmpstr = "hot";
    return tmpstr;
  }

  private String PP_GetTopHtml(String argClass)
  {
    String tmpstr = "";
    String tClass = argClass;
    String tNLng = conf.getNLng();
    tmpstr = conf.jt.itake("default.data_top", "tpl");
    tmpstr = tmpstr.replace("{$-inavigation}", PP_GetFaCatHtml(conf.jt.itake("default.data_fa_category", "tpl"), cls.getNum(tNLng, 0), cls.getNum(tClass, 0)));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String PP_GetFootHtml()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.data_foot", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String PP_GetFaCatHtml(String argTpl, Integer argLng, Integer argFid)
  {
    String tTpl = argTpl;
    Integer tLng = argLng;
    Integer tId = argFid;
    Integer tmpId = 0;
    String tmpstr = tTpl;
    String tmpastr, tmprstr, tmptstr;
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    do
    {
      tmpId = tId;
      String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tmpId;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")))));
        tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")))));
        tmptstr = tmptstr.replace("{$fid}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid")))));
        tId = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"))), 0);
        if (tId != 0) tmprstr = tmptstr + tmprstr;
      }
    }
    while (tId != 0);
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    String tKeyword = cls.getSafeString(conf.getRequestParameter("keyword"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
      String tForumID = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")));
      String tForumIType = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "itype")));
      String tForumPopedom = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "popedom")));
      if (!PP_CheckPopedom(tForumPopedom)) tmpstr = conf.common.webMessages(conf.jt.itake("default.popedom-error-1", "lng"), "-1");
      else
      {
        tmpstr = conf.jt.itake("default.list", "tpl");
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@}");
        tmptstr = tmpastr;
        //****************************************************************************//
        String tmp2astr, tmp2rstr, tmp2tstr;
        tmp2rstr = "";
        tmp2astr = cls.ctemplate(tmptstr, "{@@}");
        String tsqlstr2 = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "=" + tForumID + " order by " + cls.cfnames(tfpre, "order") + " asc";
        Object[] tArys2 = tDbc.getDataAry(tsqlstr2);
        if (tArys2 != null)
        {
          for (int tis2 = 0; tis2 < tArys2.length; tis2 ++)
          {
            tmp2tstr = tmp2astr;
            String tnForumStateString = "0";
            String tnForumNumNoteNewString = "0";
            Object[][] tAry2 = (Object[][])tArys2[tis2];
            String tnForumIType = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "itype")));
            String tnForumPopedom = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "popedom")));
            String tnForumNumNoteNew = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "num_note_new")));
            String tnForumLastTime = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "last_time")));
            if (cls.formatDate(tnForumLastTime, 1).equals(cls.formatDate(cls.getDate(), 1)))
            {
              tnForumStateString = "1";
              tnForumNumNoteNewString = tnForumNumNoteNew;
            }
            for (int ti2 = 0; ti2 < tAry2.length; ti2 ++)
            {
              tAry2[ti2][0] = (Object)cls.getLRStr((String)tAry2[ti2][0], tfpre, "rightr");
              tmp2tstr = tmp2tstr.replace("{$-" + cls.toString(tAry2[ti2][0]) + "}", encode.htmlencode(cls.toString(tAry2[ti2][1])));
            }
            conf.rsbAry = tAry2;
            //**************************************************************//
            String tmp3astr, tmp3rstr, tmp3tstr;
            tmp3rstr = "";
            tmp3astr = cls.ctemplate(tmp2tstr, "{@@@}");
            tmp3tstr = tmp3astr;
            if (PP_CheckPopedom(tnForumPopedom))
            {
              if (!tnForumIType.equals("99")) tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "left");
              else tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "right");
            }
            else
            {
              tnForumStateString = "2";
              tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "right");
            }
            tmp3rstr += tmp3tstr;
            tmp2tstr = cls.ctemplates(tmp2tstr, "{@@@}", tmp3rstr);
            //**************************************************************//
            tmp2tstr = tmp2tstr.replace("{$-p-state}", tnForumStateString);
            tmp2tstr = tmp2tstr.replace("{$-p-num_note_new}", tnForumNumNoteNewString);
            tmp2tstr = conf.jt.creplace(tmp2tstr);
            tmp2rstr += tmp2tstr;
          }
        }
        if (cls.isEmpty(tmp2rstr)) tmptstr = "";
        else tmptstr = cls.ctemplates(tmptstr, "{@@}", tmp2rstr);
        //****************************************************************************//
        tmprstr += tmptstr;
        tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
        //############################################################################//
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{~}");
        tmptstr = tmpastr;
        if (tForumIType.equals("99")) tmptstr = "";
        else
        {
          String tmp4astr, tmp4rstr, tmp4tstr;
          tmp4rstr = "";
          tmp4astr = cls.ctemplate(tmptstr, "{~~}");
          tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
          tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
          tidfield = cls.cfnames(tfpre, "id");
          String tsqlstr4 = "select * from " + tdatabase + " where (" + cls.cfnames(tfpre, "htop") + "=1 or " + cls.cfnames(tfpre, "class") + "=" + tClass + ") and " + cls.cfnames(tfpre, "fid") + "=0 and " + cls.cfnames(tfpre, "hidden") + "=0";
          if (!cls.isEmpty(tKeyword)) tsqlstr4 += " and " + cls.cfnames(tfpre, "topic") + " like '%" + tKeyword + "%'";
          tsqlstr4 += " order by " + cls.cfnames(tfpre, "htop") + " desc," + cls.cfnames(tfpre, "top") + " desc," + cls.cfnames(tfpre, "last_time") + " desc";
          pagi pagi;
          pagi = new pagi(conf);
          pagi.sqlstr = tsqlstr4;
          pagi.pagenum = tpage.longValue();
          pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
          pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
          pagi.Init();
          Object[] tArys4 = pagi.getDataAry();
          if (tArys4 != null)
          {
            for (int tis = 0; tis < tArys4.length; tis ++)
            {
              tmp4tstr = tmp4astr;
              Object[][] tAry4 = (Object[][])tArys4[tis];
              for (int ti = 0; ti < tAry4.length; ti ++)
              {
                tAry4[ti][0] = (Object)cls.getLRStr((String)tAry4[ti][0], tfpre, "rightr");
                tmp4tstr = tmp4tstr.replace("{$-" + cls.toString(tAry4[ti][0]) + "}", encode.htmlencode(cls.toString(tAry4[ti][1])));
              }
              String t4PNewClass = "hidden";
              Long t4nTimeStamp = cls.getUnixStamp();
              Long t4TimeStamp = cls.getNum64(cls.toString(tDbc.getValue(tAry4, "timestamp")));
              if (t4nTimeStamp - t4TimeStamp < 86400) t4PNewClass = "absmiddle";
              tmp4tstr = tmp4tstr.replace("{$-p-new-class}", t4PNewClass);
              tmp4tstr = tmp4tstr.replace("{$-p-topic}", PP_FormatTopic(encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "topic"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "color"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "strong"))), encode.htmlencode(tKeyword)));
              tmp4tstr = tmp4tstr.replace("{$-p-icon}", PP_GetTopicIcon(encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "htop"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "top"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "lock"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "elite"))), encode.htmlencode(cls.toString(tDbc.getValue(tAry4, "count")))));
              tmp4tstr = tmp4tstr.replace("{$-p-last-time}", PP_FormatLastTime(cls.toString(tDbc.getValue(tAry4, "last_time"))));
              conf.rscAry = tAry4;
              tmp4rstr += tmp4tstr;
            }
          }
          tmptstr = cls.ctemplates(tmptstr, "{~~}", tmp4rstr);
          tmptstr = tmptstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
          tmptstr = tmptstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
          String tPagiURL = conf.common.pagi(cls.toString(pagi.pagenum), cls.toString(pagi.pagenums), conf.common.iurl("type=page;key=" + cls.toString(tClass) + ";page=[~page]"), "cutepage");
          if (!cls.isEmpty(tKeyword)) tPagiURL = conf.common.pagi(cls.toString(pagi.pagenum), cls.toString(pagi.pagenums), encode.htmlencode(conf.getNURLPre() + conf.getNURI() + "?type=list&class=" + cls.toString(tClass) + "&keyword=" + conf.urlencode(tKeyword) + "&page=[~page]"), "cutepage");
          tmptstr = tmptstr.replace("{$pagi.url}", tPagiURL);
        }
        tmprstr += tmptstr;
        tmpstr = cls.ctemplates(tmpstr, "{~}", tmprstr);
        tmpstr = tmpstr.replace("{$-genre}", tNGenre);
        tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
        tmpstr = tmpstr.replace("{$-class}", cls.toString(tClass));
        tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
        tmpstr = conf.jt.creplace(tmpstr);
      }
    }
    else tmpstr = conf.common.webMessage(conf.jt.itake("default.notexist-error-1", "lng"));
    return tmpstr;
  }

  private String Module_Detail()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    Integer tCtPage = cls.getNum(conf.getRequestParameter("ctpage"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfieldT = cls.cfnames(tfpreT, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + "," + tdatabaseT + " where " + tdatabaseT + "." + cls.cfnames(tfpreT, "fid") + "=0 and " + tdatabaseT + "." + cls.cfnames(tfpreT, "hidden") + "=0 and " + tdatabaseT + "." + tidfieldT + "=" + tId + " and " + tdatabaseT + "." + cls.cfnames(tfpreT, "class") + "=" + tdatabase + "." + tidfield;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "topic"))));
      String tForumLock = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "lock")));
      String tForumVoteId = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "voteid")));
      String tForumIType = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "itype")));
      String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
      String tForumPopedom = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "popedom")));
      Integer tClass = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "class"))), 0);
      if (tForumIType.equals("1") && !cls.cinstr(tForumManager, account.nusername, ",")) tForumLock = "1";
      if (!PP_CheckPopedom(tForumPopedom)) tmpstr = conf.common.webMessages(conf.jt.itake("default.popedom-error-1", "lng"), "-1");
      else
      {
        tDbc.Execute("update " + tdatabaseT + " set " + cls.cfnames(tfpreT, "count") + "=" + cls.cfnames(tfpreT, "count") + "+1 where " + tidfieldT + "=" + tId);
        tmpstr = conf.jt.itake("default.detail", "tpl");
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@vote@}");
        if (!tForumVoteId.equals("0"))
        {
          int tVoteCount = 0;
          String[][] tVoteAry = null;
          String tVoteTopic = "";
          String tVoteType = "";
          String tVoteDay = "";
          String tVoteTime = "";
          String tVoteEndTime = "";
          String tdatabaseVt = cls.getString(conf.jt.itake("config.ndatabase-vote", "cfg"));
          String tfpreVt = cls.getString(conf.jt.itake("config.nfpre-vote", "cfg"));
          String tidfieldVt = cls.cfnames(tfpreVt, "id");
          String tdatabaseVtd = cls.getString(conf.jt.itake("config.ndatabase-vote-data", "cfg"));
          String tfpreVtd = cls.getString(conf.jt.itake("config.nfpre-vote-data", "cfg"));
          String tidfieldVtd = cls.cfnames(tfpreVtd, "id");
          String tsqlstrVt = "select * from " + tdatabaseVt + "," + tdatabaseVtd + " where " + tdatabaseVt + "." + tidfieldVt + "=" + tdatabaseVtd + "." + cls.cfnames(tfpreVtd, "fid") + " and " + tdatabaseVt + "." + tidfieldVt + "=" + cls.getNum(tForumVoteId, 0);
          Object[] tArysVt = tDbc.getDataAry(tsqlstrVt);
          if (tArysVt != null)
          {
            for (int tis = 0; tis < tArysVt.length; tis ++)
            {
              Object[][] tAryVt = (Object[][])tArysVt[tis];
              if (tis == 0)
              {
                tVoteTopic = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "topic")));
                tVoteType = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "type")));
                tVoteTime = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "time")));
                tVoteDay = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "day")));
                if (tVoteDay.equals("-1")) tVoteEndTime = conf.jt.itake("default.vote-noexp", "lng");
                else tVoteEndTime = cls.formatUnixStampDate(cls.getUnixStamp(tVoteTime) + (cls.getNum64(tVoteDay) * 86400));
              }
              String[][] tmpAry = new String[1][3];
              tmpAry[0][0] = cls.toString(tDbc.getValue(tAryVt, tidfieldVtd));
              tmpAry[0][1] = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVtd, "topic")));
              tmpAry[0][2] = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVtd, "count")));
              tVoteCount += cls.getNum(cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVtd, "count"))), 0);
              tVoteAry = cls.mergeAry(tVoteAry, tmpAry);
            }
          }
          if (tVoteAry != null)
          {
            tmptstr = tmpastr;
            String tmp2astr, tmp2rstr, tmp2tstr;
            tmp2rstr = "";
            tmp2astr = cls.ctemplate(tmptstr, "{@vote@data@}");
            for (int tis = 0; tis < tVoteAry.length; tis ++)
            {
              tmp2tstr = tmp2astr;
              int tCPerNum = cls.getNum(cls.cper(cls.getNum(tVoteAry[tis][2], 0), tVoteCount), 0);
              String tCPerNumD = "block";
              if (tCPerNum == 0) tCPerNumD = "none";
              tmp2tstr = tmp2tstr.replace("{$-o-id}", encode.htmlencode(tVoteAry[tis][0]));
              tmp2tstr = tmp2tstr.replace("{$-o-topic}", encode.htmlencode(tVoteAry[tis][1]));
              tmp2tstr = tmp2tstr.replace("{$-o-per}", encode.htmlencode(cls.toString(tCPerNum)));
              tmp2tstr = tmp2tstr.replace("{$-o-per-d}", encode.htmlencode(tCPerNumD));
              tmp2rstr += tmp2tstr;
            }
            tmptstr = cls.ctemplates(tmptstr, "{@vote@data@}", tmp2rstr);
            tmptstr = tmptstr.replace("{$-id}", encode.htmlencode(tForumVoteId));
            tmptstr = tmptstr.replace("{$-topic}", encode.htmlencode(tVoteTopic));
            tmptstr = tmptstr.replace("{$-type}", encode.htmlencode(tVoteType.equals("0") ? "radio": "checkbox"));
            tmptstr = tmptstr.replace("{$-day}", encode.htmlencode(tVoteDay));
            tmptstr = tmptstr.replace("{$-count}", encode.htmlencode(cls.toString(tVoteCount)));
            tmptstr = tmptstr.replace("{$-endtime}", encode.htmlencode(tVoteEndTime));
            tmprstr += tmptstr;
          }
        }
        tmpstr = cls.ctemplates(tmpstr, "{@vote@}", tmprstr);
        //****************************************************************************//
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@}");
        String tsqlstrT = "select * from " + tdatabaseT + " where " + cls.cfnames(tfpreT, "hidden") + "=0 and (" + cls.cfnames(tfpreT, "fid") + "=" + tId + " or " + tidfieldT + "=" + tId + ")  order by " + cls.cfnames(tfpreT, "fid") + " asc," + cls.cfnames(tfpreT, "time") + " asc";
        pagi pagi;
        pagi = new pagi(conf);
        pagi.sqlstr = tsqlstrT;
        pagi.pagenum = tCtPage.longValue();
        pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
        pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize-2", "cfg"));
        pagi.Init();
        Object[] tArysT = pagi.getDataAry();
        if (tArysT != null)
        {
          for (int tis = 0; tis < tArysT.length; tis ++)
          {
            tmptstr = tmpastr;
            Object[][] tAryT = (Object[][])tArysT[tis];
            String tAuid = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "auid")));
            String tAuthor = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "author")));
            String tEditUserName = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "edit_username")));
            String tEditTime = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "edit_time")));
            for (int ti = 0; ti < tAryT.length; ti ++)
            {
              tAryT[ti][0] = (Object)cls.getLRStr((String)tAryT[ti][0], tfpreT, "rightr");
              tmptstr = tmptstr.replace("{$-" + cls.toString(tAryT[ti][0]) + "}", encode.htmlencode(cls.toString(tAryT[ti][1])));
            }
            conf.rsbAry = tAryT;
            String tEditInfo = "";
            if (!cls.isEmpty(tEditUserName))
            {
              tEditInfo = conf.jt.itake("default.txt-edit-info", "lng");
              tEditInfo = tEditInfo.replace("[username]", tEditUserName);
              tEditInfo = tEditInfo.replace("[time]", cls.formatDate(tEditTime));
            }
            String tAuthorFaceURLString = "";
            String tAuthorFace = cls.toString(account.getUserInfo("face", tAuid));
            String tAuthorFaceU = cls.toString(account.getUserInfo("face_u", tAuid));
            String tAuthorFaceURL = cls.toString(account.getUserInfo("face_url", tAuid));
            if (tAuthorFaceU.equals("1")) tAuthorFaceURLString = tAuthorFaceURL;
            else tAuthorFaceURLString = conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/" + conf.imagesRoute + "/face/" + tAuthorFace + ".gif";
            tmptstr = tmptstr.replace("{$-p-floor}", cls.toString(((pagi.pagenum - 1) * pagi.pagesize) + tis + 1));
            tmptstr = tmptstr.replace("{$-p-edit-info}", encode.htmlencode(tEditInfo));
            tmptstr = tmptstr.replace("{$-author-face}", encode.htmlencode(tAuthorFaceURLString));
            tmptstr = tmptstr.replace("{$-author-group}", encode.htmlencode(cls.toString(account.getUserInfo("group", tAuid))));
            tmptstr = tmptstr.replace("{$-author-email}", encode.htmlencode(cls.toString(account.getUserInfo("email", tAuid))));
            tmptstr = tmptstr.replace("{$-author-integral}", encode.htmlencode(cls.toString(account.getUserInfo("integral", tAuid))));
            tmptstr = tmptstr.replace("{$-author-time}", encode.htmlencode(cls.toString(account.getUserInfo("time", tAuid))));
            tmptstr = tmptstr.replace("{$-author-sign}", encode.htmlencode(cls.toString(account.getUserInfo("sign", tAuid))));
            tmptstr = tmptstr.replace("{$-p-account-pm-url}", conf.getActualRoute(cls.getLRStr(conf.jt.itake("config.naccount", "cfg"), "/", "leftr")) + "/message/?type=manage&amp;mtype=add&amp;ruusername=" + conf.urlencode(tAuthor));
            tmptstr = conf.jt.creplace(tmptstr);
            tmprstr += tmptstr;
          }
        }
        tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
        String tnUserReply = "1";
        if (tForumLock.equals("1") || cls.isEmpty(account.nusername)) tnUserReply = "0";
        tmpstr = conf.common.crValcodeTpl(tmpstr);
        tmpstr = conf.common.crValHtml(tmpstr, tnUserReply, "{@reply@}");
        tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
        tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
        //****************************************************************************//
        String tnBackurlCtPage = cls.toString(pagi.pagenums);
        if (!cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg")).equals(pagi.rscount))
        {
          if ((pagi.rscount % pagi.pagesize) == 0) tnBackurlCtPage = cls.toString(pagi.pagenums + 1);
        }
        tmpstr = tmpstr.replace("{$-backurl-ctpage}", tnBackurlCtPage);
        //****************************************************************************//
        tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
        tmpstr = tmpstr.replace("{$-nusername}", encode.htmlencode(account.nusername));
        //****************************************************************************//
        tmpstr = tmpstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "id")))));
        tmpstr = tmpstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "topic")))));
        tmpstr = tmpstr.replace("{$class}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "class")))));
        tmpstr = tmpstr.replace("{$time}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "time")))));
        tmpstr = conf.jt.creplace(tmpstr);
      }
    }
    return tmpstr;
  }

  private String Module_Release()
  {
    String tmpstr = "";
    String tNLng = conf.getNLng();
    Integer tVote = cls.getNum(conf.getRequestParameter("vote"), -1);
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("default.login-error-1", "lng"), conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      long tNowUnixStamp = cls.getUnixStamp();
      String tUserRegTime = cls.toString(account.getUserInfo("time"));
      long tUserRegTimeUnixStamp = cls.getUnixStamp(tUserRegTime);
      long tNewUserReleaseTimeout = cls.getNum(conf.jt.itake("config.new_user_release_timeout", "cfg"), 0).longValue();
      if (tNowUnixStamp - tUserRegTimeUnixStamp < tNewUserReleaseTimeout) tmpstr = conf.common.webMessages(conf.jt.itake("default.release-error-1", "lng").replace("[timeout]", cls.toString(tNewUserReleaseTimeout)), "-1");
      else
      {
        String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
        String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
        String tidfield = cls.cfnames(tfpre, "id");
        dbc tDbc = db.newInstance(conf);
        String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "itype") + "<>99 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
        Object[] tArys = tDbc.getDataAry(tsqlstr);
        if (tArys != null)
        {
          Object[][] tAry = (Object[][])tArys[0];
          conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
          String tForumIType = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "itype")));
          String tForumPopedom = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "popedom")));
          String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
          if (!PP_CheckPopedom(tForumPopedom)) tmpstr = conf.common.webMessages(conf.jt.itake("default.popedom-error-1", "lng"), "-1");
          else
          {
            if (tForumIType.equals("0") || (tForumIType.equals("1") && cls.cinstr(tForumManager, account.nusername, ",")))
            {
              tmpstr = conf.jt.itake("default.release", "tpl");
              for (int ti = 0; ti < tAry.length; ti ++)
              {
                tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
                tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
              }
              conf.rsAry = tAry;
              String tnUserUpload = conf.jt.itake("config.user_upload", "cfg");
              tmpstr = conf.common.crValcodeTpl(tmpstr);
              tmpstr = conf.common.crValHtml(tmpstr, cls.toString(tVote), "{@vote@}");
              tmpstr = conf.common.crValHtml(tmpstr, tnUserUpload, "{@user_upload@}");
              tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
              tmpstr = tmpstr.replace("{$-nusername}", encode.htmlencode(account.nusername));
              tmpstr = conf.jt.creplace(tmpstr);
            }
            else tmpstr = conf.common.webMessages(conf.jt.itake("default.release-error-2", "lng"), "-1");
          }
        }
        else tmpstr = conf.common.webMessages(conf.jt.itake("default.notexist-error-1", "lng"), "-1");
      }
    }
    return tmpstr;
  }

  public String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("default.login-error-1", "lng"), conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + tidfield + "=" + tId;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        conf.cntitle((String)tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")));
        String tTopicAuid = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "auid")));
        Integer tClass = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "class"))), 0);
        if (!tTopicAuid.equals(account.nuserid)) tmpstr = conf.common.webMessages(conf.jt.itake("default.edit-error-1", "lng"), "-1");
        else
        {
          tmpstr = conf.jt.itake("default.edit", "tpl");
          for (int ti = 0; ti < tAry.length; ti ++)
          {
            tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
            tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
          }
          conf.rsAry = tAry;
          tmpstr = conf.common.crValcodeTpl(tmpstr);
          String tnUserUpload = conf.jt.itake("config.user_upload", "cfg");
          tmpstr = conf.common.crValHtml(tmpstr, tnUserUpload, "{@user_upload@}");
          tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
          tmpstr = tmpstr.replace("{$-nusername}", encode.htmlencode(account.nusername));
          tmpstr = conf.jt.creplace(tmpstr);
        }
      }
    }
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "=0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " order by " + cls.cfnames(tfpre, "order") + " asc";
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        tmptstr = tmpastr;
        Object[][] tAry = (Object[][])tArys[tis];
        String tForumID = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")));
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        //****************************************************************************//
        String tmp2astr, tmp2rstr, tmp2tstr;
        tmp2rstr = "";
        tmp2astr = cls.ctemplate(tmptstr, "{@@}");
        String tsqlstr2 = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "=" + tForumID + " order by " + cls.cfnames(tfpre, "order") + " asc";
        Object[] tArys2 = tDbc.getDataAry(tsqlstr2);
        if (tArys2 != null)
        {
          for (int tis2 = 0; tis2 < tArys2.length; tis2 ++)
          {
            tmp2tstr = tmp2astr;
            String tnForumStateString = "0";
            String tnForumNumNoteNewString = "0";
            Object[][] tAry2 = (Object[][])tArys2[tis2];
            String tnForumIType = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "itype")));
            String tnForumPopedom = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "popedom")));
            String tnForumNumNoteNew = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "num_note_new")));
            String tnForumLastTime = cls.toString(tDbc.getValue(tAry2, cls.cfnames(tfpre, "last_time")));
            if (cls.formatDate(tnForumLastTime, 1).equals(cls.formatDate(cls.getDate(), 1)))
            {
              tnForumStateString = "1";
              tnForumNumNoteNewString = tnForumNumNoteNew;
            }
            for (int ti2 = 0; ti2 < tAry2.length; ti2 ++)
            {
              tAry2[ti2][0] = (Object)cls.getLRStr((String)tAry2[ti2][0], tfpre, "rightr");
              tmp2tstr = tmp2tstr.replace("{$-" + cls.toString(tAry2[ti2][0]) + "}", encode.htmlencode(cls.toString(tAry2[ti2][1])));
            }
            conf.rsbAry = tAry2;
            //**************************************************************//
            String tmp3astr, tmp3rstr, tmp3tstr;
            tmp3rstr = "";
            tmp3astr = cls.ctemplate(tmp2tstr, "{@@@}");
            tmp3tstr = tmp3astr;
            if (PP_CheckPopedom(tnForumPopedom))
            {
              if (!tnForumIType.equals("99")) tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "left");
              else tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "right");
            }
            else
            {
              tnForumStateString = "2";
              tmp3tstr = cls.getLRStr(tmp3tstr, "{@-@-@}", "right");
            }
            tmp3rstr += tmp3tstr;
            tmp2tstr = cls.ctemplates(tmp2tstr, "{@@@}", tmp3rstr);
            //**************************************************************//
            tmp2tstr = tmp2tstr.replace("{$-p-state}", tnForumStateString);
            tmp2tstr = tmp2tstr.replace("{$-p-num_note_new}", tnForumNumNoteNewString);
            tmp2tstr = conf.jt.creplace(tmp2tstr);
            tmp2rstr += tmp2tstr;
          }
        }
        tmptstr = cls.ctemplates(tmptstr, "{@@}", tmp2rstr);
        //****************************************************************************//
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml("0"));
    tmpstr = tmpstr.replace("{$-footHtml}", PP_GetFootHtml());
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    account = new account(conf);
    account.Init(conf.jt.itake("config.naccount", "cfg"));
    account.UserInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("list")) tmpstr = Module_List();
    else if (tType.equals("detail")) tmpstr = Module_Detail();
    else if (tType.equals("release")) tmpstr = Module_Release();
    else if (tType.equals("edit")) tmpstr = Module_Edit();
    else tmpstr = Module_Default();

    PageClose();
    return tmpstr;
  }
}
%>