#用于赛普集团的信息查询
#* @post /casAccountDetail_query
casAccountDetail_query <- function(
                     FToken ,
                     FDate='2022-12-01',
                     FAccountNO ='467677162516'
                    
) {
   FToken = as.character(FToken)
   flag = tsda::odbc_checkToken(token =FToken )
   if(flag){
      #口令正常
      conn = tsda::odbc_getConn(token = FToken)
      sql <- paste0("SELECT
      [FRecordDate]  as 交易日期,
      [FAccountName] as 公司
	      ,[FBankName] as 银行
	    ,[FAccountNO] as 账号,
		   b.FName as 交易类型,
	 [FTradeTime]   as 交易时间,
      [FAmount]  as 交易金额,
	   [FAmount]* b.FValue as 收支金额
	   ,[FOppAccountName] as 对方名称
      ,[FOppOpenBankName] as 对方银行
	      ,[FOppAccountNO] as 对方账号
      ,[FSerialNO]   as 单据编号
      ,[FDigest]   as 摘要
	   ,[FPurpose]  as 备注
  FROM  [RDS_CAS_ODS_Transaction] a
  inner join RDS_CAS_ODS_tradeType b
  on a.FTradeType = b.FTradeType
  where a.FRecordDate ='",FDate,"'
  and a.FAccountNO ='",FAccountNO,"'
  order by a.FTradeTime")
      
      
      res = tryCatch({
          data = tsda::sql_select(conn = conn,sql_str = sql)
         list(status ='true',data=data,error='')

      }, error = function(e){
         list(status ='false',data="查询异常",error=as.character(e))

      })
   }else{
      #口令异常
      res = list(status ='false',data="授权异常",error='FToken异常,请与管理员联系')
   }


   res


}


