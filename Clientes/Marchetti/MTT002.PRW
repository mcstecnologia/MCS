#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MTT002
Relatorio do CIAP - Marchetti
@type function
@version  
@author MCS Tecnologia
@since 5/27/2026
@return variant, return_description
/*/
User Function MTT002()
	**********************

	SetPrvt("CPERG,AREGISTROS,I,J,CSAVCUR1,CSAVROW1")
	SetPrvt("CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT,CBCONT,CABEC1")
	SetPrvt("CABEC2,CABEC3,WNREL,NORDEM,TAMANHO,LIMITE")
	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NOMEPROG,NLASTKEY,M_PAG,ASTRU,CARQ,LFEZ")
	SetPrvt("NULTIMA,NTOTVAL,NTOTEST,NLIN,")

	cPerg := "MTT002"
	aRegistros := {}


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Define Variaveis                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
	CbCont  :="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
	nOrdem  :=0
	tamanho :="M"  //M=132 colunas, P=80 colunas, G=220 colunas
	limite  :=132
	titulo  :="RELATORIO CIAP - Marchetti"
	cDesc1  :="Imprimir relatorio CIAP totalizando"
	cDesc2  :="por data"
	cDesc3  :=""
	cString :="SFA"
	CbTxt   := SPACE(10)
	cbcont  := 0
	aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nomeprog:="MTT002"
	nLastKey:= 0
	nLin    := 80
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Salva a Integridade dos dados de Saida                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Cabec1  := "Codigo Tot  Data        Nr.NF     Fornecerdor                 Valor        Valor      Saldo Ю  Apropriacao        Curto        Longo"
	Cabec2  := "       Parc                                                    ICMS   Apropriado    Apropriar          Mes        Prazo        Prazo"

	cSavCor1 := SetColor("bg+/b,,,")

	wnrel    := "MTT002"

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	m_pag    := 1

	pergunte(cperg,.F.)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Envia controle para a funcao SETPRINT                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	If LastKey() == 27 .or. nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If LastKey() == 27 .OR. nLastKey == 27
		Return
	Endif

	RptStatus({|| RptDetail()})
Return

Static Function RptDetail()
	****************************************************
	Local nResidual	:= 0
	Local nFator	:= 0
	/*
	cQuery	:= ""
	cQuery	+= "SELECT FA.FA_CODIGO, A2.A2_NOME, "
	cQuery	+= "( "
	cQuery	+= "  SELECT SUM(FA_VALOR) FROM "+RetSqlName("SFA")+" "
	cQuery	+= "  WHERE D_E_L_E_T_ <> '*'  AND FA_FILIAL = '"+xFilial("SFA")+"' "
	cQuery	+= "  AND FA_CODIGO = FA.FA_CODIGO AND FA_TIPO = '1' "
	cQuery	+= ") TOTALACUM, "
	cQuery	+= "SUM(FA.FA_VALOR) MES, F9.F9_VALICMS VALICMS, F9.F9_DESCRI,F9.F9_DTENTNE DTENTNE, F9.F9_DOCNFE DOCNFE "
	cQuery	+= "FROM "+RetSqlName("SFA")+" FA, "
	cQuery	+=        +RetSqlName("SF9")+" F9, "
	cQuery	+=         RetSqlName("SA2")+" A2 "
	cQuery	+= "WHERE FA.D_E_L_E_T_ <> '*'  AND FA.FA_FILIAL = '"+xFilial("SFA")+"' "
	cQuery	+= "AND A2.D_E_L_E_T_ <> '*'  AND A2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQuery	+= "AND FA.FA_CODIGO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND FA.FA_TIPO = '1' "
	cQuery	+= "AND FA.FA_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery	+= "AND FA.FA_CODIGO = F9.F9_CODIGO AND F9.F9_FILIAL = '"+xFilial("SF9")+"' AND F9.D_E_L_E_T_ <> '*' "//AND F9.F9_DOCNFE='063063' " 
	cQuery  += "AND F9.F9_FORNECE+F9.F9_LOJAFOR = A2.A2_COD+A2.A2_LOJA "
	cQuery	+= "GROUP BY FA.FA_CODIGO, F9.F9_DESCRI, F9.F9_VALICMS, F9.F9_DTENTNE, F9.F9_DOCNFE, A2.A2_NOME "
	cQuery	+= "ORDER BY FA.FA_CODIGO " 
	*/

	cQuery	:= "SELECT FA.FA_CODIGO, A2.A2_NOME,F9.F9_VALICMS VALICMS,F9.F9_QTDPARC AS QTDPARC,FA.FA_VALOR AS MES, "
	cQuery	+= "(SELECT COUNT(*)      FROM "+ RetSqlName("SFA") +" WHERE D_E_L_E_T_ <> '*' AND FA_FILIAL = '"+xFilial("SFA")+"' AND FA_CODIGO = FA.FA_CODIGO AND FA_TIPO = FA.FA_TIPO AND FA_DATA BETWEEN F9.F9_DTINIUT AND '"+DTOS(mv_par02)+"') AS TOTPARC, "
	cQuery	+= "(SELECT SUM(FA_VALOR) FROM "+ RetSqlName("SFA") +" WHERE D_E_L_E_T_ <> '*' AND FA_FILIAL = '"+xFilial("SFA")+"' AND FA_CODIGO = FA.FA_CODIGO AND FA_TIPO = FA.FA_TIPO AND FA_DATA BETWEEN F9.F9_DTINIUT AND '"+DTOS(mv_par02)+"') AS TOTALACUM, "
	cQuery	+= "F9.F9_DESCRI,F9.F9_DTINIUT DTINIUT,F9.F9_DOCNFE DOCNFE,F9.F9_SLDPARC AS SLDPARC,F9.F9_BAIXAPR AS BAIXAPR,FA.FA_FATOR AS FATOR "
	cQuery	+= "FROM "+	RetSqlName("SF9")+" F9, "
	cQuery	+= 			RetSqlName("SFA")+" FA, "
	cQuery	+= 			RetSqlName("SA2")+" A2 "
	cQuery	+= "WHERE FA.FA_FILIAL = '"+xFilial("SFA")+"' "
	cQuery	+= "AND FA.D_E_L_E_T_ = ' ' "
	cQuery	+= "AND FA.FA_CODIGO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
	cQuery	+= "AND FA.FA_TIPO = '1' "
	cQuery	+= "AND FA.FA_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' " 
	cQuery	+= "AND FA.FA_CODIGO = F9.F9_CODIGO "
	cQuery	+= "AND F9.F9_FILIAL = '"+xFilial("SF9")+"' "
	cQuery	+= "AND F9.D_E_L_E_T_ = ' ' "
	cQuery	+= "AND F9.F9_FORNECE = A2.A2_COD "
	cQuery	+= "AND F9.F9_LOJAFOR = A2.A2_LOJA "
	cQuery	+= "AND A2.D_E_L_E_T_ = ' ' "
	cQuery	+= "AND A2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQuery	+= "ORDER BY FA.FA_CODIGO"

	If (Select("ALN") <> 0)
		dbSelectArea("ALN")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery NEW ALIAS "ALN"
	TCSetField("ALN","DTINIUT"  ,"D",8,0)                  

	titulo  	:= "RELATORIO CIAP DE "+DTOC(MV_PAR01)+" ATE "+DTOC(MV_PAR02)

	ALN->(dbGoTop())
	SetRegua(ALN->(RecCount()))

	nSaldo 		:= 0
	nCP    		:= 0
	nLP    		:= 0
	nToticm		:= 0
	nTotmes		:= 0
	nTotacu		:= 0
	nTotSal		:= 0
	nTotCP 		:= 0
	nTotLP 		:= 0
	nResidual	:= 0

	nFator		:= ALN->FATOR

	While !ALN->(EOF())
		
		IncRegua()

		If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
		nLin := 9
		endif

		/*If MV_PAR05 == 2
			If ALN->VALICMS < ALN->TOTALACUM
				dbSelectArea("ALN")
				ALN->(dbSkip())
				Loop
			EndIf
		EndIf*/
		
		nQtdParc 	:= ALN->QTDPARC
		nTotParc	:= ALN->TOTPARC
		nSaldo		:= ALN->VALICMS - ALN->TOTALACUM
		nCP   		:= 0
		nLP   		:= 0
		
		If nQtdParc == 48 
			nParcCP		:= 12
			nParcLP		:= nQtdParc - nParcCP
			
			If nTotParc > 36
				nCP   		:= ALN->MES * (nQtdParc - nTotParc)	//Curto Prazo
				nLP			:= 0								//Longo Prazo - ApСs a 36 Parcela, fica zerado
			Else
				nCP   		:= ALN->MES * nParcCP						//Curto Prazo
				nLP   		:= ALN->MES	* (nQtdParc-nParcCP-nTotParc)	//Longo Prazo
			EndIf
			If ALN->TOTPARC == 48 .Or. ! EmpTy( ALN->BAIXAPR )
				nResidual += nSaldo
			EndIf
		EndIf
		nToticm+=ALN->VALICMS
		nTotmes+=ALN->MES 
		nTotacu+=ALN->TOTALACUM   
		
		nTotSal+=nSaldo
		nTotCP+=nCP
		nTotLP+=nLP
		
		@ nLin,000 PSAY SubStr(Alltrim(ALN->FA_CODIGO),1,6)
		@ nLin,007 PSAY TRANSF(ALN->SLDPARC,"@E 99")
		@ nLin,012 PSAY ALN->DTINIUT
		@ nLin,024 PSAY AllTrim(ALN->DOCNFE)
		@ nLin,034 PSAY SUBSTR(ALN->A2_NOME,1,20)	
		@ nLin,055 PSAY TRANSF(ALN->VALICMS,"@E 9,999,999.99")
		@ nLin,068 PSAY TRANSF(ALN->TOTALACUM,"@E 9,999,999.99")
		@ nLin,081 PSAY TRANSF(nSaldo,"@E 9,999,999.99")
		@ nLin,094 PSAY TRANSF(ALN->MES,"@E 9,999,999.99")
		@ nLin,107 PSAY TRANSF(nCP,"@E 9,999,999.99")
		@ nLin,120 PSAY TRANSF(nLP,"@E 9,999,999.99")
		
		nLin:=nLin + 1
				
		ALN->(dbSkip())
	End

	If nLin > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
	nLin := 9
	endif

	nLin++
	nLin++
	@ nLin,000 PSAY "TOTAIS: ..."  
	@ nLin,055 PSAY TRANSF(nToticm,"@E 9,999,999.99")
	@ nLin,068 PSAY TRANSF(nTotacu,"@E 9,999,999.99")
	@ nLin,081 PSAY TRANSF(nTotSal,"@E 9,999,999.99")
	@ nLin,094 PSAY TRANSF(nTotmes,"@E 9,999,999.99")
	@ nLin,107 PSAY TRANSF(nTotCP ,"@E 9,999,999.99")
	@ nLin,120 PSAY TRANSF(nTotLP ,"@E 9,999,999.99")

	nLin++
	nLin++
	@ nLin,000 PSAY "SALDO RESIDUAL"
	nLin++
	@ nLin,000 PSAY "R$"
	@ nLin,002 PSAY TRANSF(nResidual,"@E 9,999,999.99")

	nLin++
	nLin++
	@ nLin,000 PSAY "COEFICIENTE MES"
	nLin++ 
	@ nLin,001 PSAY TRANSF(nFator,"@E 9,999.99999999")
		
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	If (Select("ALN") <> 0)
		dbSelectArea("ALN")
		dbCloseArea()
	EndIf

return
