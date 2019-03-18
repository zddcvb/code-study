<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private account account;
  private upfiles upfiles;

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

  private Boolean PP_CheckContinuousInsert(String argUserId)
  {
    Boolean tBoolean = false;
    Integer tUserId = cls.getNum(argUserId, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    long tTimeoutUnixStamp = cls.getUnixStamp() - 5;
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "auid") + "=" + tUserId + " and " + cls.cfnames(tfpre, "timestamp") + ">" + tTimeoutUnixStamp;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null) tBoolean = true;
    return tBoolean;
  }

  private Boolean PP_CheckBlacklist(Integer argClass)
  {
    Boolean tBoolean = false;
    Integer tClass = argClass;
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-blacklist", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-blacklist", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "uid") + "=" + tnuserid + " and " + cls.cfnames(tfpre, "fid") + "=" + tClass;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null) tBoolean = true;
    return tBoolean;
  }

  private Boolean PP_CheckReplyFid(Integer argClass, Integer argFid)
  {
    Boolean tBoolean = false;
    Integer tClass = argClass;
    Integer tFid = argFid;
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lock") + "=0 and " + cls.cfnames(tfpre, "class") + "=" + tClass + " and " + tidfield + "=" + tFid;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null) tBoolean = true;
    return tBoolean;
  }

  private String Module_Action_Vote()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    if (!account.checkUserLogin()) tmpstr = conf.jt.itake("default.login-error-1", "lng");
    else
    {
      String tVotes = cls.getString(conf.getRequestUsParameters("votes"));
      if (cls.isEmpty(tVotes)) tmpstr = conf.jt.itake("default.vote-error-1", "lng");
      else
      {
        String tdatabaseVt = cls.getString(conf.jt.itake("config.ndatabase-vote", "cfg"));
        String tfpreVt = cls.getString(conf.jt.itake("config.nfpre-vote", "cfg"));
        String tidfieldVt = cls.cfnames(tfpreVt, "id");
        dbc tDbc = db.newInstance(conf);
        String tsqlstrVt = "select * from " + tdatabaseVt + " where " + tidfieldVt + "=" + tId;
        Object[] tArysVt = tDbc.getDataAry(tsqlstrVt);
        if (tArysVt != null)
        {
          Object[][] tAryVt = (Object[][])tArysVt[0];
          String tVoteTime = cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "time")));
          Integer tVoteDay = cls.getNum(cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "day"))), 0);
          Integer tVoteType = cls.getNum(cls.toString(tDbc.getValue(tAryVt, cls.cfnames(tfpreVt, "type"))), 0);
          if (!tVoteDay.equals(-1))
          {
            long tVoteNStamp = cls.getUnixStamp();
            long tVoteEndStamp = cls.getUnixStamp(tVoteTime) + (cls.getNum64(cls.toString(tVoteDay)) * 86400);
            if (tVoteNStamp > tVoteEndStamp) tmpstr = conf.jt.itake("default.vote-error-3", "lng");
          }
          if (cls.isEmpty(tmpstr))
          {
            if (tVoteType.equals(0))
            {
              if (cls.getNum(tVotes, 0).equals(0)) tmpstr = conf.jt.itake("default.vote-error-4", "lng");
            }
            else
            {
              if (!cls.cidary(tVotes)) tmpstr = conf.jt.itake("default.vote-error-4", "lng");
            }
          }
        }
        else tmpstr = conf.jt.itake("default.vote-error-2", "lng");
        //****************************************************************************//
        if (cls.isEmpty(tmpstr))
        {
          String tdatabaseVtv = cls.getString(conf.jt.itake("config.ndatabase-vote-voter", "cfg"));
          String tfpreVtv = cls.getString(conf.jt.itake("config.nfpre-vote-voter", "cfg"));
          String tidfieldVtv = cls.cfnames(tfpreVtv, "id");
          String tUserIP = cls.getSafeString(conf.getRemortIP());
          String tsqlstrVtv = "select * from " + tdatabaseVtv + " where " + cls.cfnames(tfpreVtv, "fid") + "=" + tId + " and " + cls.cfnames(tfpreVtv, "ip") + "='" + tUserIP + "'";
          Object[] tArysVtv = tDbc.getDataAry(tsqlstrVtv);
          if (tArysVtv != null) tmpstr = conf.jt.itake("default.vote-error-5", "lng");
          else
          {
            if (cls.cidary(tVotes))
            {
              tsqlstrVtv = "insert into " + tdatabaseVtv + " (";
              tsqlstrVtv += cls.cfnames(tfpreVtv, "fid") + ",";
              tsqlstrVtv += cls.cfnames(tfpreVtv, "ip") + ",";
              tsqlstrVtv += cls.cfnames(tfpreVtv, "username") + ",";
              tsqlstrVtv += cls.cfnames(tfpreVtv, "data") + ",";
              tsqlstrVtv += cls.cfnames(tfpreVtv, "time");
              tsqlstrVtv += ") values (";
              tsqlstrVtv += tId + ",";
              tsqlstrVtv += "'" + cls.getLeft(encode.addslashes(tUserIP), 50) + "',";
              tsqlstrVtv += "'" + cls.getLeft(encode.addslashes(account.nusername), 50) + "',";
              tsqlstrVtv += "'" + cls.getLeft(encode.addslashes(tVotes), 255) + "',";
              tsqlstrVtv += "'" + cls.getDate() + "'";
              tsqlstrVtv += ")";
              tDbc.Execute(tsqlstrVtv);
              String tdatabaseVtd = cls.getString(conf.jt.itake("config.ndatabase-vote-data", "cfg"));
              String tfpreVtd = cls.getString(conf.jt.itake("config.nfpre-vote-data", "cfg"));
              String tidfieldVtd = cls.cfnames(tfpreVtd, "id");
              String tsqlstrVtd = "update " + tdatabaseVtd + " set " + cls.cfnames(tfpreVtd, "count") + "=" + cls.cfnames(tfpreVtd, "count") + "+1 where " + cls.cfnames(tfpreVtd, "fid") + "=" + tId + " and " + tidfieldVtd + " in (" + tVotes + ")";
              int tstateVtdNum = tDbc.Executes(tsqlstrVtd);
              if (tstateVtdNum != -101) tmpstr = conf.jt.itake("default.vote-done", "lng");
              else tmpstr = conf.jt.itake("default.vote-error-6", "lng");
            }
            else tmpstr = conf.jt.itake("default.vote-error-4", "lng");
          }
        }
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Release()
  {
    String tmpstr = "";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tFid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    Integer tClass = cls.getNum(conf.getRequestUsParameter("class"), -1);
    if (!account.checkUserLogin()) tmpstr = conf.jt.itake("default.login-error-1", "lng");
    else
    {
      long tNowUnixStamp = cls.getUnixStamp();
      String tUserRegTime = cls.toString(account.getUserInfo("time"));
      long tUserRegTimeUnixStamp = cls.getUnixStamp(tUserRegTime);
      long tNewUserReleaseTimeout = cls.getNum(conf.jt.itake("config.new_user_release_timeout", "cfg"), 0).longValue();
      if (tNowUnixStamp - tUserRegTimeUnixStamp < tNewUserReleaseTimeout) tmpstr = conf.jt.itake("default.release-error-1", "lng").replace("[timeout]", cls.toString(tNewUserReleaseTimeout));
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
          String tForumIType = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "itype")));
          String tForumPopedom = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "popedom")));
          String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
          String tForumLastTime = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "last_time")));
          Integer tForumNumNoteNew = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "num_note_new"))), 0);
          if (!PP_CheckPopedom(tForumPopedom)) tmpstr = conf.jt.itake("default.popedom-error-1", "lng");
          else
          {
            if (tForumIType.equals("0") || (tForumIType.equals("1") && cls.cinstr(tForumManager, account.nusername, ",")))
            {
              Integer tVoteID = 0;
              //****************************************************************************//
              String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
              if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
              //****************************************************************************//
              if (cls.isEmpty(tmpstr))
              {
                String tTopic = cls.getString(conf.getRequestUsParameter("topic")).trim();
                if (cls.isEmpty(tTopic)) tmpstr = conf.jt.itake("default.release-error-3", "lng");
              }
              //****************************************************************************//
              if (cls.isEmpty(tmpstr) && PP_CheckBlacklist(tClass)) tmpstr = conf.jt.itake("default.release-error-4", "lng");
              //****************************************************************************//
              if (cls.isEmpty(tmpstr) && !tFid.equals(0))
              {
                if (!PP_CheckReplyFid(tClass, tFid)) tmpstr = conf.jt.itake("default.release-error-5", "lng");
              }
              //****************************************************************************//
              if (cls.isEmpty(tmpstr))
              {
                if (PP_CheckContinuousInsert(account.nuserid)) tmpstr = conf.jt.itake("default.release-error-8", "lng");
              }
              //****************************************************************************//       
              if (cls.isEmpty(tmpstr) && tFid.equals(0))
              {
                String[] tVotesAry = null;
                String tVotesString = "";
                String tVotesSpString = "$|:|$";
                int tVotesNum = cls.getNum(conf.getRequestUsParameter("votesnum"), 0);
                if (tVotesNum > 0)
                {
                  for (int tvi = 0; tvi <= tVotesNum; tvi ++)
                  {
                    String tVotesTopic = cls.getString(conf.getRequestUsParameter("votes_topic_" + tvi)).trim();
                    if (!cls.isEmpty(tVotesTopic)) tVotesString += tVotesTopic + tVotesSpString;
                  }
                }
                if (!cls.isEmpty(tVotesString))
                {
                  tVotesString = cls.getLRStr(tVotesString, tVotesSpString, "leftr");
                  tVotesAry = tVotesString.split(Pattern.quote(tVotesSpString));
                }
                if (tVotesAry != null)
                {
                  int tMaxVoteOption = cls.getNum(conf.jt.itake("config.nmax_vote_option", "cfg"), 0);
                  if (tVotesAry.length > tMaxVoteOption) tmpstr += conf.jt.itake("default.release-error-6", "lng").replace("[max]", cls.toString(tMaxVoteOption));
                  else
                  {
                    String tdatabaseVt = cls.getString(conf.jt.itake("config.ndatabase-vote", "cfg"));
                    String tfpreVt = cls.getString(conf.jt.itake("config.nfpre-vote", "cfg"));
                    String tidfieldVt = cls.cfnames(tfpreVt, "id");
                    String tsqlstrVt = "insert into " + tdatabaseVt + " (";
                    tsqlstrVt += cls.cfnames(tfpreVt, "topic") + ",";
                    tsqlstrVt += cls.cfnames(tfpreVt, "type") + ",";
                    tsqlstrVt += cls.cfnames(tfpreVt, "time") + ",";
                    tsqlstrVt += cls.cfnames(tfpreVt, "day");
                    tsqlstrVt += ") values (";
                    tsqlstrVt += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
                    tsqlstrVt += cls.getNum(conf.getRequestUsParameter("vote_type"), 0) + ",";
                    tsqlstrVt += "'" + cls.getDate() + "',";
                    tsqlstrVt += cls.getNum(conf.getRequestUsParameter("vote_day"), 0);
                    tsqlstrVt += ")";
                    int tstateVtNum = tDbc.Executes(tsqlstrVt);
                    if (tstateVtNum != -101)
                    {
                      tVoteID = conf.common.getTopID(tdatabaseVt, tidfieldVt);
                      String tdatabaseVtd = cls.getString(conf.jt.itake("config.ndatabase-vote-data", "cfg"));
                      String tfpreVtd = cls.getString(conf.jt.itake("config.nfpre-vote-data", "cfg"));
                      String tidfieldVtd = cls.cfnames(tfpreVtd, "id");
                      for (int tvi = 0; tvi < tVotesAry.length; tvi ++)
                      {
                        String tsqlstrVtd = "insert into " + tdatabaseVtd + " (";
                        tsqlstrVtd += cls.cfnames(tfpreVtd, "topic") + ",";
                        tsqlstrVtd += cls.cfnames(tfpreVtd, "fid") + ",";
                        tsqlstrVtd += cls.cfnames(tfpreVtd, "vid");
                        tsqlstrVtd += ") values (";
                        tsqlstrVtd += "'" + cls.getLeft(encode.addslashes(tVotesAry[tvi]), 50) + "',";
                        tsqlstrVtd += tVoteID + ",";
                        tsqlstrVtd += tvi;
                        tsqlstrVtd += ")";
                        tDbc.Execute(tsqlstrVtd);
                      }
                    }
                    else tmpstr = conf.jt.itake("default.release-error-7", "lng");
                  }
                }
              }
              //****************************************************************************//
              if (cls.isEmpty(tmpstr))
              {
                String tDateNow = cls.getDate();
                String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
                String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
                String tidfieldT = cls.cfnames(tfpreT, "id");
                String tsqlstrT = "insert into " + tdatabaseT + " (";
                tsqlstrT += cls.cfnames(tfpreT, "topic") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "class") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "fid") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "icon") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "author") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "auid") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "authorip") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "content") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "content_files") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "voteid") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "time") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "timestamp") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "last_username") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "last_time") + ",";
                tsqlstrT += cls.cfnames(tfpreT, "lng");
                tsqlstrT += ") values (";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
                tsqlstrT += tClass + ",";
                tsqlstrT += tFid + ",";
                tsqlstrT += cls.getNum(conf.getRequestUsParameter("icon"), 0) + ",";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(account.nusername), 50) + "',";
                tsqlstrT += cls.getNum(account.nuserid, 0) + ",";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(conf.getRemortIP()), 50) + "',";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(conf.common.repathencode(conf.getRequestUsParameter("content"))), 10000) + "',";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("content_files")), 10000) + "',";
                tsqlstrT += tVoteID + ",";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(tDateNow), 50) + "',";
                tsqlstrT += cls.getUnixStamp() + ",";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(account.nusername), 50) + "',";
                tsqlstrT += "'" + cls.getLeft(encode.addslashes(tDateNow), 50) + "',";
                tsqlstrT += cls.getNum(tNLng, 0);
                tsqlstrT += ")";
                int tstateTNum = tDbc.Executes(tsqlstrT);
                if (tstateTNum != -101)
                {
                  int tTopTID = conf.common.getTopID(tdatabaseT, tidfieldT);
                  upfiles.UpdateDatabaseNote(tNGenre, conf.getRequestUsParameter("content_files"), "content_files", tTopTID);
                  if (!cls.formatDate(tForumLastTime, 1).equals(cls.formatDate(cls.getDate(), 1))) tForumNumNoteNew = 1;
                  else tForumNumNoteNew = tForumNumNoteNew + 1;
                  tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "num_note") + "=" + cls.cfnames(tfpre, "num_note") + "+1," + cls.cfnames(tfpre, "num_note_new") + "=" + tForumNumNoteNew + "," + cls.cfnames(tfpre, "last_time") + "='" + cls.getLeft(encode.addslashes(tDateNow), 50) + "' where " + tidfield + "=" + tClass);
                  if (tFid.equals(0))
                  {
                    tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "num_topic") + "=" + cls.cfnames(tfpre, "num_topic") + "+1," + cls.cfnames(tfpre, "last_topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "'," + cls.cfnames(tfpre, "last_topic_id") + "=" + tTopTID + "," + cls.cfnames(tfpre, "last_topic_time") + "='" + cls.getLeft(encode.addslashes(tDateNow), 50) + "' where " + tidfield + "=" + tClass);
                    int tnIntTopic = cls.getNum(conf.jt.itake("config.nint_topic", "cfg"), 0);
                    account.updateProperty("integral", cls.toString(tnIntTopic), "0");
                    tmpstr = "<!--200-->" + conf.getActualRoute(tNGenre) + "/" + conf.common.iurl("type=detail;key=" + tTopTID + ";time=" + tDateNow);
                  }
                  else
                  {
                    tDbc.Execute("update " + tdatabaseT + " set " + cls.cfnames(tfpreT, "reply") + "=" + cls.cfnames(tfpreT, "reply") + "+1," + cls.cfnames(tfpreT, "last_username") + "='" + cls.getLeft(encode.addslashes(account.nusername), 50) + "'," + cls.cfnames(tfpreT, "last_time") + "='" + cls.getLeft(encode.addslashes(tDateNow), 50) + "' where " + tidfieldT + "=" + tFid);
                    int tnIntReply = cls.getNum(conf.jt.itake("config.nint_reply", "cfg"), 0);
                    account.updateProperty("integral", cls.toString(tnIntReply), "0");
                    tmpstr = "<!--200-->" + encode.htmlencode(conf.getRequestUsParameter("backurl"));
                  }
                }
                else tmpstr = conf.jt.itake("default.release-error-7", "lng");
              }
              //****************************************************************************//
            }
            else tmpstr = conf.jt.itake("default.release-error-2", "lng");
          }
        }
        else tmpstr = conf.jt.itake("default.notexist-error-1", "lng");
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    if (!account.checkUserLogin()) tmpstr = conf.jt.itake("default.login-error-1", "lng");
    else
    {
      String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
      if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
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
          String tRedirectTopicId = cls.toString(tId);
          String tRedirectTopicTime = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "time")));
          String tTopicFid = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid")));
          String tTopicAuid = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "auid")));
          if (!tTopicFid.equals("0"))
          {
            tRedirectTopicId = tTopicFid;
            String tsqlstrRdt = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + tidfield + "=" + cls.getNum(tRedirectTopicId, 0);
            Object[] tArysRdt = tDbc.getDataAry(tsqlstrRdt);
            if (tArysRdt != null)
            {
              Object[][] tAryRdt = (Object[][])tArysRdt[0];
              tRedirectTopicTime = cls.toString(tDbc.getValue(tAryRdt, cls.cfnames(tfpre, "time")));
            }
          }
          if (!tTopicAuid.equals(account.nuserid)) tmpstr = conf.jt.itake("default.edit-error-1", "lng");
          else
          {
            tsqlstr = "update " + tdatabase + " set ";
            tsqlstr += cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
            tsqlstr += cls.cfnames(tfpre, "icon") + "=" + cls.getNum(conf.getRequestUsParameter("icon"), 0) + ",";
            tsqlstr += cls.cfnames(tfpre, "content") + "='" + cls.getLeft(encode.addslashes(conf.common.repathencode(conf.getRequestUsParameter("content"))), 100000) + "',";
            tsqlstr += cls.cfnames(tfpre, "content_files") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("content_files")), 10000) + "',";
            tsqlstr += cls.cfnames(tfpre, "edit_username") + "='" + cls.getLeft(encode.addslashes(account.nusername), 50) + "',";
            tsqlstr += cls.cfnames(tfpre, "edit_time") + "='" + cls.getDate() + "'";
            tsqlstr += " where " + tidfield + "=" + tId;
            int tstateNum = tDbc.Executes(tsqlstr);
            if (tstateNum != -101)
            {
              upfiles.UpdateDatabaseNote(tNGenre, conf.getRequestUsParameter("content_files"), "content_files", tId);
              tmpstr = "<!--200-->" + conf.getActualRoute(tNGenre) + "/" + conf.common.iurl("type=detail;key=" + tRedirectTopicId + ";time=" + tRedirectTopicTime);
            }
            else tmpstr = conf.jt.itake("default.edit-error-4", "lng");
          }
        }
        else tmpstr = conf.jt.itake("default.edit-error-3", "lng");
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("vote")) tmpstr = Module_Action_Vote();
    else if (tAtype.equals("release")) tmpstr = Module_Action_Release();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("upload"))
    {
      String tnUserUpload = conf.jt.itake("config.user_upload", "cfg");
      if (tnUserUpload.equals("1")) tmpstr = upfiles.uploadFiles("file1", 0, account.nusername);
    }
    return tmpstr;
  }

  private String Module_Votes_Add()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    tmpstr = conf.jt.itake("default-interface.votes_add", "tpl");
    tmpstr = tmpstr.replace("{$id}", cls.toString(tId));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Votes()
  {
    String tmpstr = "";
    String tUtype = cls.getString(conf.getRequestUsParameter("utype"));
    if (tUtype.equals("add")) tmpstr = Module_Votes_Add();
    return tmpstr;
  }

  private String Module_LoadReply()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    tmpstr = conf.common.itransfer("tpl=default-interface.loadreply;type=new;topx=5;lng=-100;osql= and " + cls.cfnames(tfpreT, "fid") + "=" + tId);
    if (cls.isEmpty(tmpstr)) tmpstr = conf.jt.itake("default.notexist-error-2", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_LoadQuote()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfieldT = cls.cfnames(tfpreT, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + "," + tdatabaseT + " where " + tdatabaseT + "." + cls.cfnames(tfpreT, "hidden") + "=0 and " + tdatabaseT + "." + tidfieldT + "=" + tId + " and " + tdatabaseT + "." + cls.cfnames(tfpreT, "class") + "=" + tdatabase + "." + tidfield;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      String tForumPopedom = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "popedom")));
      if (PP_CheckPopedom(tForumPopedom))
      {
        tmpstr += "[quote]";
        tmpstr += "[b]" + encode.encodeHtml(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "author")))) + " " + conf.jt.itake("default.txt-release", "lng") + " " + encode.encodeHtml(cls.formatDate(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "time"))))) + "[/b][br]";
        tmpstr += encode.encodeHtml(conf.common.repathdecode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "content")))));
        tmpstr += "[/quote][br]";
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();
    account = new account(conf);
    account.Init(conf.jt.itake("config.naccount", "cfg"));
    account.UserInit();
    upfiles = new upfiles(conf);

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));
    if (tType.equals("action")) tmpstr = Module_Action();
    else if (tType.equals("votes")) tmpstr = Module_Votes();
    else if (tType.equals("loadreply")) tmpstr = Module_LoadReply();
    else if (tType.equals("loadquote")) tmpstr = Module_LoadQuote();
    else if (tType.equals("upload")) tmpstr = upfiles.uploadHTML("upload-html-2");
    PageClose();
    return tmpstr;
  }
}
%>