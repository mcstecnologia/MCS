#Include "rwmake.ch"
#Include "topconn.ch"
#Include "colors.ch"
#Include "barra.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
////#INCLUDE "SPEDNFE.ch"


#DEFINE IMP_SPOOL 2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172     ºAutor  ³Fabricio Cargnin    º Data ³  04/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de seleção de pedidos para Faturamento                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ved172
********************
Local oPnl
Local aCampos		:= {}
Local cPerg			:= "VED172"
Local lInverte		:= .F.
Local oFontNegr 	:= oSend(TFont(),"New","MS Sans Serif",0,08,,.T.) //Fonte MS Sans Serif em modo negrito
Local aHeader   	:= {}
Local aCols 		:= {}
Local aCpo			:= {}
Private oDlg
Private oMark
Private cIndex 		:= CriaTrab(NIl,.f.)
Private oQtdPed
Private oPesos
Private oPed
Private oProd
Private nBLqCred	:= 1
Private cIndex 		:= CriaTrab(NIl,.f.)
Private aCores		:= {}
Private aAlts		:= {}
Private aSaldos170	:= {}
Private oPesoB,	oPesoL,	oVolum,	oTotal
Private nPesoB,	nPesoL,	nVolum,	nTotal
Private lOffLine:=.F.
Private oBotLib

nPesoL:=0
nPesoB:=0
nVolum:=0
nTotal:=0

fAjusSX1(cPerg)

If Pergunte(cPerg,.T.)
	lOffLine:=mv_par08==1
///	lOffLine:=.F.
	oDlg := MsDialog():New(1,1,400,600,OemToAnsi("Acompanhamento de Pedidos para Faturamento"),,,.F.,,,,,oMainWnd,.T.,,,.F.)
	oDlg:lMaximized := .T.
	oDlg:lEscClose  := .F.
	
	oPnlTot := TPanel():New(nil,nil,,oDlg,,.T.,.F.,,,1,1,,)
	oPnlTot:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPnlTop := TPanel():New(nil,nil,,oPnlTot,,.T.,.F.,,,1,1,,)
	oPnlTop:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPnlInf := TPanel():New(nil,nil,,oPnlTop,,.T.,.F.,,,30,30,,)
	oPnlInf:Align := CONTROL_ALIGN_BOTTOM
	
	aHeader := fHeader()
	MsgRun("Aguarde, selecionando pedidos...",, {|| aCols:=ved172Stru(1)})
	
	oMark :=MsNewGetDados():New(20,1,1,1,GD_UPDATE,,,,,,,,,,oPnlTop,aHeader,aCols)
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMark:oBrowse:blDblClick := {||  fMark()  }
	
	oBotAnali := TButton():New(007,006,"&Atualiza Tela"	,oPnlInf,{|| MsgRun("Aguarde, selecionando pedidos...",,{||VED172Stru(2)} )}	,55,15,,,,.T.)
	oBotAnali := TButton():New(007,065,"&Atualiza Parametros"	,oPnlInf,{|| MsgRun("Aguarde, selecionando pedidos...",,{||VED172Stru(3)} )}	,55,15,,,,.T.)
	oBotPesq  := TButton():New(007,125,"&Pesquisar Pedido"	,oPnlInf,{|| MsgRun("Aguarde, pesquisando pedidos...",,{||VD172Pesq()} )}	,55,15,,,,.T.)
	If lOffLine
		//oBotLib   := TButton():New(007,185,"&Faturar (OFFLINE)"	,oPnlInf,{|| MsgRun("Aguarde, faturando pedidos marcados...",,{||fFatura()} )}		,55,15,,,,.T.)
	Else
		oBotLib   := TButton():New(007,185,"&Faturar (ONLINE)"	,oPnlInf,{|| MsgRun("Aguarde, faturando pedidos marcados...",,{||fFatura()} )}		,55,15,,,,.T.)
	Endif
	oBotAlte  := TButton():New(007,245,"&Altera Pedido"	,oPnlInf,{||fAlteraPV2()}		,55,15,,,,.T.)
	
	oSay1  := TSay():New(001,400,{||"Peso Bruto(Total)"},oPnlInf,,oFontNegr,.F.,.F.,.F.,.T.,,060,060)
	oPesoB	:=TGet():New(008,400,bSetGet(nPesoB),oPnlInf,60,12,"@E 999,999.99",,,,,,,.T.,,,{||.F.})
	oSay2  := TSay():New(001,470,{||"Peso Liquido(Total)"},oPnlInf,,oFontNegr,.F.,.F.,.F.,.T.,,060,060)
	oPesoL	:=TGet():New(008,470,bSetGet(nPesoL),oPnlInf,60,12,"@E 999,999.99",,,,,,,.T.,,,{||.F.})
	oSay3  := TSay():New(001,540,{||"Volumes(Total)"},oPnlInf,,oFontNegr,.F.,.F.,.F.,.T.,,060,060)
	oVolum	:=TGet():New(008,540,bSetGet(nVolum),oPnlInf,60,12,"@E 999,999.99",,,,,,,.T.,,,{||.F.})
	oSay4  := TSay():New(001,610,{||"Val.Merc.(Total)"},oPnlInf,,oFontNegr,.F.,.F.,.F.,.T.,,060,060)
	oTotal	:=TGet():New(008,610,bSetGet(nTotal),oPnlInf,60,12,"@E 999,999.99",,,,,,,.T.,,,{||.F.})
	
	Activate msDialog oDlg Centered On Init fRefresh()
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172    ºAutor  ³Fabricio Cargnin    º Data ³  08/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Refresh da Dialog                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function fRefresh()
**************************
Local lOk			:= .F.
Local bOk			:= {|| oDlg:End() }
Local bCancel   	:= {|| oDlg:End() }
Local aButtons		:= {}

aAdd(aButtons,{ "LEGENDA", {||  U_VD172LEG() }  , "Legenda","Legenda" })
aAdd(aButtons,{ "IMPRIME", {||  U_VED172IM() }  , "Imprime Danfe","Imprime Danfe" })
aAdd(aButtons,{ "LIBERA", {||  U_VD172MNT() }  , "Monitor Processos","Monitor de Processos" })

EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
oMark:Refresh()
oDlg:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172     ºAutor  ³Fabricio Cargnin    º Data ³  04/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna os pedidos aptos a serem impressos.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ved172Stru(nOpca)
*********************************
Local aTam   	:= {}
Local aItens 	:= {}
Local aPesos	:= {}
Local lPadrao	:=.T.
Local cLegenda  :=""
Local lCompl	:=.F.
Local aSX5RETZ3:={}

nPesoL:=0
nPesoB:=0
nVolum:=0
nTotal:=0

If nOpca<>1   /// Refresh da tela
	If nOpca==3
		Pergunte("VED172",.T.)
		lOffLine:=mv_par08==1
///		lOffLine:=.F.
	Endif
	oMark:aCols:={}
	If lOffLine
	    oBotLib:ccaption:="Faturar (OFFLINE)" 
		oBotLib:Hide()  
	Else
		If(type("oBotLib")=='U')
			oBotLib   := TButton():New(007,185,"&Faturar (ONLINE)"	,oPnlInf,{|| MsgRun("Aguarde, faturando pedidos marcados...",,{||fFatura()} )}		,55,15,,,,.T.)
		Else
			oBotLib:ccaption:="Faturar (ONLINE)"        
			oBotLib:Show()
		EndIf
	Endif
Else
	Pergunte("VED172",.F.)
Endif



cQuery := " SELECT DISTINCT C9_FILIAL , C9_PEDIDO, C9_CLIENTE, C9_LOJA, A1_NOME, A1_EST, A4_NOME, C6_ENTREG, C5_MENPED, C5_EMISSAO, "
///cQuery += "  ISNULL((SELECT COUNT(*) FROM "+RetSqlName("SC5")+" SC52 WHERE SC52.C5_FILIAL=C5.C5_FILIAL AND SC52.C5_PVCOMPL=C5.C5_NUM AND SC52.D_E_L_E_T_<>'*'),0) AS TR_NCOMPL ,  "

///cQuery += " 		(CASE WHEN C9_VDLIBES IN ('I','V','B') THEN  'I' ELSE 'N' END) C9_VDLIBES, "
/*
cQuery += " 	   ISNULL((SELECT COUNT(C9_PEDIDO) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL = ' ' "
cQuery += " 	   AND XC9.C9_VDEXPST = 'I' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_IMPRESSO, "
cQuery += " 	   ISNULL((SELECT COUNT(C9_PEDIDO) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL = ' ' "
cQuery += " 	   AND XC9.C9_BLEST = ' ' "
cQuery += " 	   AND XC9.C9_VDEXPST = ' ' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_NIMPRESSO, "
*/

cQuery += " 	   ISNULL((SELECT SUM(C9_QTDLIB) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL = ' ' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_PECAS, "
cQuery += " 	   ISNULL((SELECT SUM(C9_QTDLIB*C9_PRCVEN) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL = ' ' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_TOTAL, "
cQuery += " 	   ISNULL((SELECT COUNT(*) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL = ' ' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_ITENS, "
cQuery += " 	   ISNULL((SELECT MIN(XC9.C9_DATENT+XC9.C9_PEDIDO) "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_CLIENTE = C9.C9_CLIENTE "
cQuery += " 	   AND XC9.C9_LOJA = C9.C9_LOJA "
cQuery += " 	   AND XC9.C9_NFISCAL = '"+ criaVar('C9_NFISCAL' , .F.)+"'"
cQuery += " 	   AND XC9.C9_BLEST = '" + criaVar('C9_BLEST' , .F.) + "' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_MINENTREG, "
cQuery += " 	   ISNULL((SELECT COUNT(*) AS BLOQEST"
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9  "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_BLEST <> '  '   "
cQuery += " 	   AND XC9.C9_BLEST <> '10'   "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_BLOQU ,  "
cQuery += " 	   ISNULL((SELECT COUNT(*) AS BLOQEST"
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9  "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_BLEST = '  '   "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_LIBERADO ,  "
cQuery += " 	   ISNULL((SELECT COUNT(*) AS BLOQEST"
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9  "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_BLEST = '  '   "
cQuery += " 	   AND XC9.C9_VDLIBES='S'  "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_SEPARADO ,  "
cQuery += " 	   ISNULL((SELECT COUNT(*) AS BLOQEST"
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9  "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_ITENSSC9, "
/*
cQuery += " 	   ISNULL((SELECT COUNT(*) AS BLOQEST "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9 "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_CLIENTE = C9.C9_CLIENTE "
cQuery += " 	   AND XC9.C9_LOJA = C9.C9_LOJA "
cQuery += " 	   AND XC9.C9_NFISCAL = '"+ criaVar('C9_NFISCAL' , .F.)+"'"
cQuery += " 	   AND XC9.C9_BLEST = '" + criaVar('C9_BLEST' , .F.) + "' "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_LIBCLI,  "
*/

cQuery += " 	   ISNULL((SELECT SUM(Z06_QTLIB) AS BIPADO"
cQuery += " 	   FROM " + retSqlTab("Z06")
cQuery += " 	   WHERE Z06_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND Z06_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND Z06_NF = ' ' "
cQuery += " 	   AND Z06.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_BIPADO, "

cQuery += " 	   ISNULL((SELECT COUNT(*) AS SEPARADO "
cQuery += " 	   FROM " + retSqlName("SC9") + " XC9  "
cQuery += " 	   WHERE XC9.C9_FILIAL = C9.C9_FILIAL "
cQuery += " 	   AND XC9.C9_PEDIDO = C9.C9_PEDIDO "
cQuery += " 	   AND XC9.C9_NFISCAL <> '  '   "
cQuery += " 	   AND XC9.D_E_L_E_T_ <> '*'),0) "
cQuery += " AS TR_FATURADO "

cQuery += " FROM " + retSqlName("SC9") + " C9 "
cQuery += " INNER JOIN "+ retSqlName("SC5") + " C5  " +" ON   "
cQuery += " 				C5_FILIAL = C9.C9_FILIAL"
cQuery += " 				AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " 				AND C5.D_E_L_E_T_ <> '*'    "
cQuery += " INNER JOIN "+ retSqlName("SA1") + " A1 "+" ON   "
cQuery += " 				A1_FILIAL = '"+xFilial("SA1")+"'"
cQuery += " 				AND A1_COD = C5_CLIENTE		"
cQuery += " 				AND A1_LOJA = C5_LOJACLI	"
cQuery += " 				AND A1.D_E_L_E_T_ <> '*'    "
cQuery += " INNER JOIN "+ retSqlName("SC6") + " C6  " +" ON   "
cQuery += " 				C6_FILIAL = C9.C9_FILIAL"
cQuery += " 				AND C6_NUM = C9_PEDIDO     "
cQuery += " 				AND C6_ITEM = C9_ITEM      "
cQuery += " 				AND C6.D_E_L_E_T_ <> '*'    "
cQuery += " LEFT JOIN "+ retSqlName("SA4") + " A4  " +" ON   "
cQuery += " 				A4_FILIAL = '"+xFilial("SA4")+"'"
cQuery += " 				AND A4_COD = C5_TRANSP     "
cQuery += " 				AND A4.D_E_L_E_T_ <> '*'    "

cQuery += " INNER JOIN "+ retSqlName("SX5") + " SX5  " +" ON   "
cQuery+="  	 "+RetSqlFil("SX5")+" AND X5_TABELA='ZY' AND X5_DESCSPA=A1_CTAREC AND X5_CHAVE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' AND "+RetSqlDel("SX5")

cQuery += " WHERE   "
cQuery += "  	C9_FILIAL  = '" + xFilial("SC9") + "' "
///cQuery += " 	AND C9_PEDIDO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " 				AND C9_PEDIDO = C5_NUM      "

If mv_par05==1
	cQuery += " 	AND C9_NFISCAL = '"+ criaVar('C9_NFISCAL' , .F.)+"'"
	cQuery += " 	AND C9_SERIENF = '"+ criaVar('C9_SERIENF' , .F.)+"'"
	cQuery += " 	AND C9_BLCRED  = '" + criaVar('C9_BLCRED' , .F.) + "' "
	cQuery += " 	AND C9_VDEXPST <> 'F' "  //// Faturado -> Todos os itens sem estoque do faturamento parcial são marcados como F
	cQuery += " 	AND C9_BLEST =' '    "  /// Lista apenas pedidos liberados no estoque
Endif

cQuery += " AND C9_VDLIBES <>' '    "  /// Lista apenas pedidos que tenham passado pelo novo processo

cQuery += " AND C9_SEQFAT = ' '    "  /// Lista apenas pedidos que tenham passado pelo novo processo

cQuery += " AND C6_ENTREG BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"

cQuery += " AND C5_TRANSP BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"

cQuery += " AND C9.D_E_L_E_T_ <> '*'    "

If mv_par09<>"000005" .and. !Empty(mv_par09) //// Todos

   //SX5->(DBSetOrder(1))

   aSX5RETZ3:=U_SX5RETRG("Z3", mv_par09, "pt-br", xFilial("SX5"))
    If(Len(aSX5RETZ3)>0)
   //If SX5->(DBSeek(xFilial("SX5")+"Z3"+mv_par09))
   	   //cQuery += " AND  ( A1_EST IN "+FormatIn(Alltrim(SX5->X5_DESCRI),"/")
	   cQuery += " AND  ( A1_EST IN "+FormatIn(Alltrim(aSX5RETZ3[4]),"/")

	   aSX5RETZ3:=U_SX5RETRG("Z3", mv_par09, "es", xFilial("SX5"))
	   
	   //If Alltrim(SX5->X5_DESCSPA)<>'.'
	   If Alltrim(aSX5RETZ3[4])<>'.'
	   	   		cQuery += " OR A1_CTAREC = '"+Alltrim(aSX5RETZ3[4])+"'"
	   Else
	   		cQuery += " AND A1_CTAREC <> '3101300004' "   /// Industria lista apenas para usuário com região específica // 02/07/2018
	   Endif       
	   cQuery += " ) "
   Endif
Endif

////cQuery += "	GROUP BY C9_FILIAL , C9_PEDIDO, C9_CLIENTE, C9_LOJA, C6_ENTREG, C9_VDLIBES "
cQuery += "	ORDER BY TR_MINENTREG, C9_PEDIDO "



If Select("TMP2") <> 0
	TMP2->(dbCloseArea())
End

//Conout("Inicio QUERY "+FunName()+" "+time())
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Inicio QUERY "+FunName()+" "+time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMP2",.T.,.F.)

//Conout("Final QUERY "+FunName()+" "+time())
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Final QUERY "+FunName()+" "+time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

TCSetField("TMP2","C6_ENTREG","D",08,0)
TCSetField("TMP2","C5_EMISSAO","D",08,0)

// atualiza os dados da area temporaria, arquivo com dados
// a serem trabalhados na atualização.

SC5->(DBOrderNickName('VDSC501'))
SA4->(dbSetOrder(1))
SA2->(dbSetOrder(1))
SA1->(dbSetOrder(1))
SC9->(dbSetOrder(1))
SC6->(dbSetOrder(1))


While TMP2->(!Eof())
	
	///	ZZ6->(DBSetOrder(3))
	
	If mv_par05==1.and. ( TMP2->TR_LIBERADO<>TMP2->TR_SEPARADO ).and. (TMP2->TR_PECAS<>TMP2->TR_BIPADO)
		TMP2->(Dbskip())
		Loop
	Endif
	cLegenda:=""
	///    CONOUT("Pedido VED172 "+TMP2->C9_PEDIDO)
	If mv_par05<>1
		If TMP2->TR_FATURADO<>0.and. TMP2->TR_FATURADO==TMP2->TR_ITENSSC9
			cLegenda:="BR_VERMELHO"   /// Faturado
		ElseIf TMP2->TR_BLOQU>0 .and. TMP2->TR_ITENS==TMP2->TR_BLOQU
			cLegenda:="BR_PRETO"     //// Aguardando análise do PCP
		ElseIf TMP2->TR_BLOQU>0 .and. TMP2->TR_ITENS>TMP2->TR_BLOQU
			cLegenda:="BR_LARANJA"     //// Liberado parcial pelo PCP
		ElseIf TMP2->TR_SEPARADO<TMP2->TR_ITENS.and.( TMP2->TR_BIPADO<>0 .and. TMP2->TR_PECAS<>TMP2->TR_BIPADO)
			cLegenda:="BR_AZUL"  //// Separado parcialmente pela expedicaoo
		ElseIf TMP2->TR_LIBERADO>TMP2->TR_SEPARADO .and. TMP2->TR_BIPADO==0
			cLegenda:="BR_VIOLETA"  //// Separado parcialmente pelo PCP
		ElseIf TMP2->TR_SEPARADO==TMP2->TR_LIBERADO
			cLegenda:="BR_VERDE"   /// Separado e não gravado pela expedição
		ElseIf TMP2->TR_PECAS==TMP2->TR_BIPADO
			cLegenda:="BR_CANCEL"   /// Apenas pendentes definido por Thagor que deve mostrar sempre legenda verde.
		ElseIf TMP2->TR_FATURADO<>0 .and. TMP2->TR_FATURADO<>TMP2->TR_ITENSSC9
			cLegenda:="BR_VERDE_ESCURO"   /// Apenas pendentes definido por Thagor que deve mostrar sempre legenda verde.
		Endif
	Else
		If TMP2->TR_PECAS==TMP2->TR_BIPADO .AND. (TMP2->TR_SEPARADO<>TMP2->TR_LIBERADO)
			cLegenda:="BR_CANCEL"   /// Separado e não gravado pela expedição
		Else
			cLegenda:="BR_VERDE"   /// Apenas pendentes definido por Thagor que deve mostrar sempre legenda verde.
		Endif
	Endif
	
	SC5->(DBOrderNickName('VDSC501'))  /// Pedido Complementar
	lCompl:=SC5->(DBSeek(xFilial("SC5")+TMP2->C9_PEDIDO))  /// Retirado da Query devido a performance (Mesmo com indice estava lento)
	
	SC5->(dbSetOrder(1))   // Pedido original
	SC5->(DBSeek(xFilial("SC5")+TMP2->C9_PEDIDO))
	
	aPeso:=fSomaPeso(TMP2->C9_PEDIDO)
	
	aadd(aItens,{"LBNO",cLegenda,TMP2->C9_PEDIDO,If(Empty(SC5->C5_VDOBSEX)," ","X"),If(lCompl,"S","N"),TMP2->C5_MENPED , TMP2->C9_CLIENTE,TMP2->C9_LOJA, TMP2->A1_NOME,TMP2->A1_EST,TMP2->A4_NOME,TMP2->C6_ENTREG,;
	TMP2->TR_TOTAL,aPeso[3],aPeso[1],aPeso[2],;
	TMP2->C5_EMISSAO,TMP2->TR_ITENS, TMP2->TR_PECAS,;
	TMP2->TR_SEPARADO,TMP2->TR_BLOQU,TMP2->TR_FATURADO,.f.	})
	
	TMP2->(Dbskip())
End

If nOpca<>1
	oMark:aCols:=aItens
	oMark:oBrowse:Refresh()
Endif

Return aItens

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172     ºAutor  ³Fabricio Cargnin    º Data ³  04/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a marcacao dos pedidos e soma os totalizadores.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fMark()
***********************
Local nLin    	:= oMark:oBrowse:nAt
Local nPosFLAG	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "OK"})
Local nPosSTS	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "STATUS"})
Local nPosPed 	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "C6_NUM"})
Local nPosOBS	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "TR_EXPINF"})
Local nPosPL	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "TR_PLIQ"})
Local nPosPB	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "TR_PBRU"})
Local nPosVol	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "TR_VOLUME"})
Local nPosVal	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "TR_VALOR"})
Local c

If oMark:oBrowse:nColPos == nPosOBS
	U_fInfObs(oMark:aCols[oMark:nAt][nPosPed],.F.)
Else
	
	If oMark:aCols[oMark:nAt][nPosSTS]=="BR_VERDE"
		If oMark:aCols[oMark:nAt][nPosFLAG] == "LBNO"
			oMark:aCols[oMark:nAt][nPosFLAG]:= "LBOK"           // MARCADO
			nPesoL+=oMark:aCols[oMark:nAt][nPosPL]
			nPesoB+=oMark:aCols[oMark:nAt][nPosPB]
			nVolum+=oMark:aCols[oMark:nAt][nPosVol]
			nTotal+=oMark:aCols[oMark:nAt][nPosVal]
			
			
			
		Else
			oMark:aCols[oMark:nAt][nPosFLAG]:= "LBNO"
			nPesoL-=oMark:aCols[oMark:nAt][nPosPL]
			nPesoB-=oMark:aCols[oMark:nAt][nPosPB]
			nVolum-=oMark:aCols[oMark:nAt][nPosVol]
			nTotal-=oMark:aCols[oMark:nAt][nPosVal]
		EndIf
		oPesoL:Refresh()
		oPesoB:Refresh()
		oVolum:Refresh()
		oTotal:Refresh()
		oMark:oBrowse:Refresh()
		oDlg:Refresh()
	Endif
	
Endif

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172     ºAutor  ³Fabricio Cargnin    º Data ³  04/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fHeader(nOpca)
******************************
Local aHdr := {}
Default nOpca:=1
//SX3->(DbSetOrder(2))

If nOpca==1
	Aadd(aHdr, {" ","OK","@BMP",2,0,".F.","","C","","V","","","","V"})
	Aadd(aHdr, {" ","STATUS","@BMP",2,0,".F.","","C","","V","","","","V"})
	
	//SX3->(dbSeek("C6_NUM"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "C6_NUM", 4)

	Aadd(aHdr,{"Obs.Exp" , "TR_EXPINF" , "@!" , 1 ,0,".F.","","C","","V","","","","V"})
	
	Aadd(aHdr,{Trim("Tem Compl.") , "TR_NCOMPL" , "@!" , 1 , 0,".F.","","C","","V","","","","V"})
	
	//SX3->(dbSeek("C5_MENPED"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , 100 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "C5_MENPED", 4)

	//SX3->(dbSeek("C5_CLIENTE"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "C5_CLIENTE", 4)

	//SX3->(dbSeek("C5_LOJACLI"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "C5_LOJACLI", 4)

	//SX3->(dbSeek("A1_NOME"))
	//Aadd(aHdr,{"Cliente" , SX3->X3_CAMPO , SX3->X3_PICTURE , 30 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "A1_NOME", 4,"Cliente")

	//SX3->(dbSeek("A1_EST"))
	//Aadd(aHdr,{"UF" , SX3->X3_CAMPO , SX3->X3_PICTURE , 2 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "A1_EST", 4,"UF")

	//SX3->(dbSeek("A3_NOME"))
	//Aadd(aHdr,{"Transportadora" , SX3->X3_CAMPO , SX3->X3_PICTURE , 15 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "A3_NOME", 4,"Transportadora")

	//SX3->(dbSeek("C6_ENTREG"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , 20 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "C6_ENTREG", 4)

	Aadd(aHdr,{Trim("Valor Mercadorias") , "TR_VALOR" , "@E 9,999,999.99" , 12 , 2,".F.","","N","","V","","","","V"})
	
	Aadd(aHdr,{Trim("Volumes") , "TR_VOLUME" , "@E 99,999" , 5 , 0,".F.","","N","","V","","","","V"})
	Aadd(aHdr,{Trim("P.Liquido") , "TR_PLIQ" , "@E 99,999.99" , 8 , 2,".F.","","N","","V","","","","V"})
	Aadd(aHdr,{Trim("P.Bruto") , "TR_PBRU" , "@E 99,999.99" , 8 , 2,".F.","","N","","V","","","","V"})
	
	
	//SX3->(dbSeek("C5_EMISSAO"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , 20 , SX3->X3_DECIMAL,SX3->X3_Valid,SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_Context,SX3->X3_CBOX ,"","",SX3->X3_VISUAL,SX3->X3_VLDUSER})
	U_SX3RETRG(aHdr, "C5_EMISSAO", 4)
	
	Aadd(aHdr,{Trim("Sld.Itens") , "TR_ITENS" , "@E 99,999" , 5 , 0,".F.","","N","","V","","","","V"})
	Aadd(aHdr,{Trim("Sld.Peças") , "TR_PECAS" , "@E 99,999,999" , 8 , 0,".F.","","N","","V","","","","V"})
	
	Aadd(aHdr,{Trim("Itens Sep.") , "TR_LIBERA" , "@E 99,999" , 5 , 0,".F.","","N","","V","","","","V"})
	Aadd(aHdr,{Trim("Itens S/Sld") , "TR_SSALDO" , "@E 99,999,999" , 8 , 0,".F.","","N","","V","","","","V"})
	Aadd(aHdr,{Trim("Itens Fat.") , "TR_FATURADO" , "@E 99,999,999" , 8 , 0,".F.","","N","","V","","","","V"})
	
ElseIf nOpca==2   /// Monitor off line ZF2

	Aadd(aHdr, {" ","OK","@BMP",2,0,".F.","","C","","V","","","","V"})
	Aadd(aHdr, {" ","STATUS","@BMP",2,0,".F.","","C","","V","","","","V"})

	//SX3->(dbSeek("ZF2_SEQUEN"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "ZF2_SEQUEN", 4)

	//SX3->(dbSeek("ZF2_DATA"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "ZF2_DATA", 4)

	//SX3->(dbSeek("ZF2_USER"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "ZF2_USER", 4)

	//SX3->(dbSeek("ZF2_STATUS"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "ZF2_STATUS", 4)

ElseIf nOpca==3   /// Monitor off line PEDIDOS

	Aadd(aHdr, {" ","STATUS","@BMP",2,0,".F.","","C","","V","","","","V"})

	//SX3->(dbSeek("C9_PEDIDO"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "C9_PEDIDO", 4)

	//SX3->(dbSeek("C9_NFISCAL"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "C9_NFISCAL", 4)
	
	//SX3->(dbSeek("A1_NOME"))
	//Aadd(aHdr,{Trim(X3Titulo()) , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"",SX3->X3_Usado,SX3->X3_TIPO,SX3->X3_F3,"",SX3->X3_CBOX ,"","",SX3->X3_VISUAL,""})
	U_SX3RETRG(aHdr, "A1_NOME", 4)

	Aadd(aHdr,{"Status SEFAZ" , "STSSEFAZ" , "@!" ,50,0,".F.","","C","","V","","","","V"})
	
Endif

Return aHdr


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172    ºAutor  ³Fabricio Cargnin    º Data ³  08/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta perguntas da tela de liberação do PCP                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAjusSX1(cPerg)
********************************
Local aArea := GetArea()                                                                         

PutSx1(cPerg,"01","Pedido de"			,"","","mv_ch1","C",6,0,1,"G","","SC5"	,"","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o Pedido Inicial"},{""},{""})
PutSx1(cPerg,"02","Pedido Ate"			,"","","mv_ch2","C",6,0,1,"G","","SC5"	,"","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o Pedido Final"},{""},{""})
PutSx1(cPerg,"03","Dt.Entrega de"		,"","","mv_ch3","D",08,0,1,"G","",""	,"","","mv_par03","","","","","","","","","","","","","","","","",{"Informe a Dt.Entrega Incial"},{""},{""})
PutSx1(cPerg,"04","Dt.Entrega Ate"		,"","","mv_ch4","D",08,0,1,"G","",""	,"","","mv_par04","","","","","","","","","","","","","","","","",{"Informe a Dt.Entrega Final"},{""},{""})
PutSx1(cPerg,"05","Apenas Liberados?	","","","mv_ch5","N",01,0,1,"C","",""	,"","","mv_par05","Sim","","","","Nao","","","","","","","","","","","",{"Define se lista apenas pedido "},{"totalmente separados "},{""})
PutSx1(cPerg,"06","Mercado de Venda De","","","mv_ch6","C",06,0,1,"G","","ZY","","","mv_par06","","","","","","","","","","","","","","","","",{"Informe o Mercado Inicial "},{""},{""})
PutSx1(cPerg,"07","Mercado de Venda Ate","","","mv_ch7","C",06,0,1,"G","","ZY","","","mv_par07","","","","","","","","","","","","","","","","",{"Informe o Mercado Final"},{""},{""})

U_XPutSx1(cPerg,"08","Faturamento Off Line?	","","","mv_ch8","N",01,0,1,"C","",""	,"","","mv_par08","Sim","","","","Nao","","","","","","","","","","","",{"Faturamento off line "},{" "},{""})
U_XPutSx1(cPerg,"09","Regioes?","","","mv_ch9","C",06,0,1,"G","","Z3"	,"","","mv_par09","","","","","","","","","","","","","","","","",{"Regioes"},{" "},{""})

U_XPutSx1(cPerg,"10","Transportadora de"			,"","","mv_ch10","C",6,0,1,"G","","SA4"	,"","","mv_par10","","","","","","","","","","","","","","","","",{"Informe a Transportadora Inicial"},{""},{""})
U_XPutSx1(cPerg,"11","Transportadora Ate"			,"","","mv_ch11","C",6,0,1,"G","","SA4"	,"","","mv_par11","","","","","","","","","","","","","","","","",{"Informe a Transportadora Final"},{""},{""})

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  08/17/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Legenda                                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VD172LEG
*********************
Local aSituacoes := {}

aAdd(aSituacoes,{"BR_VERDE"   	,OemToAnsi("Pedido Liberado para Faturamento")})
aAdd(aSituacoes,{"BR_PRETO"   	,OemToAnsi("Aguardando Analise do PCP")})
aAdd(aSituacoes,{"BR_LARANJA"	,OemToAnsi("Liberado Parcialmente pelo PCP")})
aAdd(aSituacoes,{"BR_VERMELHO"	,OemToAnsi("Pedido Faturado")})
aAdd(aSituacoes,{"BR_AZUL"		,OemToAnsi("Separado Parcialmente")})
aAdd(aSituacoes,{"BR_VIOLETA"	,OemToAnsi("Na fila de separacao")})
aAdd(aSituacoes,{"BR_VERDE_ESCURO",OemToAnsi("Faturado Parcial")})
aAdd(aSituacoes,{"BR_CANCEL"	,OemToAnsi("Totalmente Separado e não Lib.pela Expedição")})


/*
aAdd(aSituacoes,{"BR_MARROM"	,OemToAnsi("Pedido Já Impresso e ALTERADO")})
*/

BrwLegenda("Faturamento de Pedidos","Legenda",aSituacoes)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  08/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pesquisa pedido no browse                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VD172Pesq()
**************************
Local cPesquisa := CriaVar("C5_NUM" , .F.)
Local nPosPed :=gdFieldPos("C6_NUM" , oMark:aHeader)
Local aOpc 		:= {"1-Numero do Pedido" }
Local cCombo    := space(1)
Local nPos		:=0
oMainWnd:ReadClientCoords()

oJanPesq:= msDialog():New(0,0,057,365,"Pesquisa",,,.F.,,,,,oMainWnd,.T.,,,.F.)

oCombo := TComboBox():New(10,010, bSetGet(cCombo), aOpc, 70, 20, oJanPesq,,,,,,.T.,,,)
oPesquisa := TGet():New(10,90,bSetGet(cPesquisa),oJanPesq,90,08,,,,,,,,.T.,,,{||.T.})

oBotao := TButton():New(10,150,"&Ok",oJanPesq,{|| oJanPesq:End()},30,10,,,,.T.)

Activate msDialog oJanPesq Centered
cTmp := substr(cCombo , 1 , 1)

If cPesquisa != " "
	nPos := aScan(oMark:aCols , {|x| x[nPosPed] == cPesquisa })
	If nPos<>0
		oMark:oBrowse:nAt:=nPos
		oMark:oBrowse:refresh()
	Else
		Alert("Pedido não encontrado!")
	Endif
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  07/14/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento dos pedidos marcados                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fFatura()
*************************
Local i,j,k,c
Local nPosFLAG	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "OK"})
Local nPosPed	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "C6_NUM"})
Local nPosCli	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "C5_CLIENTE"})
Local nPosLoja	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "C5_LOJACLI"})
Local nPosSTS	:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "STATUS"})
Local cSerie:="1"
Local cPedido	:=""
Local aPedidos	:={}
Local aCli	 	:={}
Local aCliCanc	:={}
Local aPedFat	:={}
Local aNFe		:={}
Local aPedAux
Local cQuebra,cQuebraAtu
Local aQuebDiv	:={}
Local cCFOP
Local lRet         
Local cCliente
Local cLoja
Local cMensagem	:=""
Local aPedInadi:={}
Local aPedVlAber:={}
Private NTENTSD9:=0
Private aVDSC5PV:={}

For i:=1 to len(oMark:aCols)
	
	If oMark:aCols[i][nPosFLAG] == "LBOK"
		SC5->(DBSetOrder(1))
		SC5->(DBSeek(xFilial("SC5")+oMark:aCols[i][nPosPed]))
		
		If !Empty(SC5->C5_VDOBSEX)
			If !U_fInfObs(SC5->C5_NUM,.F.)
				Return
			Endif
		Endif
		
		aadd(aPedFat,{oMark:aCols[i][nPosPed],oMark:aCols[i][nPosCli],oMark:aCols[i][nPosLoja],i})
		If Ascan(aCli,oMark:aCols[i][nPosCli]+oMark:aCols[i][nPosLoja])==0
			aadd(aCli,oMark:aCols[i][nPosCli]+oMark:aCols[i][nPosLoja])
		Endif
		If Ascan(aVDSC5PV,oMark:aCols[i][nPosPed])==0
			aadd(aVDSC5PV,oMark:aCols[i][nPosPed])
		Endif
		
	Endif
	
Next i

aSort(aPedFat,,,{|x, y| x[2]+x[3]+x[1] < y[2]+y[3]+y[1]})

If(SuperGetMV("VDVDCATIVO",.F.,"/C/D/")) //Ativar validação
	//Percorro todo array e envio para a função U_ConValDv que ela consulta no cadastro de contas a receber se o cliente tem titulos a receber em aberto, se tiver algum eu encerro o processo.
	For i:=1 to len(aPedFat)
		if(U_ConValDv(aPedFat[i][2],aPedFat[i][3]))
			cMensagem:=cMensagem+"Pedido: "+aPedFat[i][1]+" - Cliente: "+(replace(aPedFat[i][2],' ','')+" "+aPedFat[i][3])+Chr(13)+Chr(10)
			aadd(aPedVlAber,{aPedFat[i][1],aPedFat[i][2],aPedFat[i][3]})
		endIf
	next i
	If (!Empty(cMensagem)).and.(cMensagem<>'')
		alert("Por favor, verifique os contas a receber em aberto com atraso dos clientes destes pedidos e entre em contato sobre esta situação com o responsável do setor financeiro, os pedidos não serão faturados, esta operação será encerrada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+cMensagem )
		U_VED436(aPedVlAber,"Informamos que tentaram faturar o(s) pedido(s) abaixo com cliente em débito com a Vedamotors. Por favor, verifique os contas a receber.","Tentativa de Faturamento com cliente em debito",.T.)
		Return
	EndIf
EndIf
//Percorro todo array e envio para a função U_fConInad que ela consulta no cadastro se o cliente é inadimplente, se tiver algum eu encerro o processo.
If(SuperGetMV("VDVDIATIVO",.F.,"/C/D/")) //Ativar validação
	For i:=1 to len(aPedFat)
		if(U_fConInad(aPedFat[i][2],aPedFat[i][3]))
			cMensagem:=cMensagem+"Pedido: "+aPedFat[i][1]+" - Cliente: "+(replace(aPedFat[i][2],' ','')+" "+aPedFat[i][3])+Chr(13)+Chr(10)
			aadd(aPedInadi,{aPedFat[i][1],aPedFat[i][2],aPedFat[i][3]})
		endIf
	next i
	If (!Empty(cMensagem)).and.(cMensagem<>'')
		alert("Por favor, verifique os cadastros dos clientes inadimplentes dos pedidos que você selecionou e entre em contato sobre esta situação com o responsável do setor financeiro, os pedidos não serão faturados, esta operação será encerrada."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+cMensagem )
		U_VED312(aPedInadi,"Informamos que tentaram faturar alguns pedidos com clientes marcados como inadimplente. Por favor, verifique estes cadastros.","Tentativa de Faturamento com cliente inadimplente",.T.)
		Return
	EndIf
EndIf

For i:=1 to len(aPedFat)    /// Verificação se existem divergências entre o pedido liberado e a separação
	If !U_fVerDiv(aPedFat[i][1],,.T.)
		aadd(aCliCanc,aPedFat[i][2]+aPedFat[i][3])
	Endif
Next i

// Aqui o sistema verifica se o cliente tem pendencia financeira e informa na tela
For i:=1 to len(aCli)
	If aScan(aCliCanc,aCli[i])==0
		If !U_fLisPend(Subs(aCli[i],1,TamSX3("A1_COD")[1]))
			aadd(aCliCanc,aCli[i])
		ElseIf !(U_VED133(Subs(aCli[i],1,TamSX3("A1_COD")[1]), Subs(aCli[i],(TamSX3("A1_COD")[1])+1,TamSX3("A1_LOJA")[1])))
			aadd(aCliCanc,aCli[i])
		Endif
		
	Endif
Next i

i:=1
aVDSC5PV:={}

While i<=len(aPedFat)
	
	If aScan(aCliCanc,aPedFat[i][2]+aPedFat[i][3])==0
		cCliLoja:=aPedFat[i][2]+aPedFat[i][3]
		aPedidos := {}
		aStatus	 :={}
		
		cQuebra:=cQuebraAtu:=""
		
		aQuebras:={}
		aQuebDiv:={}
		While i<=len(aPedFat) .and. cCliLoja==aPedFat[i][2]+aPedFat[i][3]
			cPedido:=aPedFat[i][1]

			cCliente:=aPedFat[i][2]
			cLoja	:=aPedFat[i][3]

			aadd(aVDSC5PV,cPedido)
			
			aadd(aStatus,aPedFat[i][4])
			
			SC5->(dbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN
			SC5->(dbSeek(xFilial("SC5")+cPedido))
			
			SA1->(dbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN
			SA1->(dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
			
			SC9->(dbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN
			SC9->(dbSeek(xFilial("SC9") + SC5->C5_Num))
			
			SC6->(dbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			SC6->(dbSeek(xFilial("SC6")+SC9->(C9_Pedido+C9_Item+C9_Produto)))
			
			SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_Produto))
			
			SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
			SF4->(dbSeek(xFilial("SF4")+SC6->C6_Tes))
			
			cCFOP:=If(Alltrim(SF4->F4_CF)$"/5101/5401/6101/6401/","5101",SF4->F4_CF)   //// CFOPs que juntam no faturamento
			
			cQuebraAtu:=SC9->C9_AGREG+SC9->C9_CARGA+SC9->C9_SEQCAR+SC5->C5_TIPO+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_TIPOCLI+SC5->C5_CLIENT+SC5->C5_LOJAENT+SC5->C5_REAJUST+SC5->C5_CONDPAG+SC5->C5_INCISS+SC5->C5_TRANSP+SC5->C5_TPFRETE+SC5->C5_FORNISS+;
			SC5->C5_VEND1+SC5->C5_VEND2+SC5->C5_VEND3+SC5->C5_VEND4+SC5->C5_RECISS+SB1->B1_RETOPER+SB1->B1_COFINS+SB1->B1_PIS+SF4->F4_DUPLIC+SF4->F4_ESTOQUE+cCFOP
			
			aadd(aQuebras,{cQuebraAtu+SC9->C9_PEDIDO,SC9->C9_PEDIDO, SA1->A1_NOME, SC9->C9_PRODUTO, SC9->C9_AGREG,SC9->C9_CARGA,SC9->C9_SEQCAR,SC5->C5_TIPO,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_TIPOCLI,SC5->C5_CLIENT,SC5->C5_LOJAENT,SC5->C5_REAJUST,SC5->C5_CONDPAG,SC5->C5_INCISS,SC5->C5_TRANSP,SC5->C5_TPFRETE,SC5->C5_FORNISS,;
			SC5->C5_VEND1,SC5->C5_VEND2,SC5->C5_VEND3,SC5->C5_VEND4,SC5->C5_RECISS,SB1->B1_RETOPER,SB1->B1_COFINS,SB1->B1_PIS,SF4->F4_DUPLIC,SF4->F4_ESTOQUE,cCFOP , .F.})
			
			While SC9->(!Eof()) .And. SC9->(C9_Filial+C9_Pedido) == xFilial("SC9")+SC5->C5_Num
				
				If SC9->C9_VDLIBES=="S" .and. Empty(SC9->C9_NFISCAL)
					SC6->(dbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					SC6->(dbSeek(xFilial("SC6")+SC9->(C9_Pedido+C9_Item+C9_Produto)))
					
					SE4->(dbSetOrder(1)) //E4_FILIAL+E4_CODIGO
					SE4->(dbSeek(xFilial("SE4")+SC5->C5_CondPag))
					
					SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
					SB1->(dbSeek(xFilial("SB1")+SC6->C6_Produto))
					
					SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
					SB2->(dbSeek(xFilial("SB2")+SC6->(C6_Produto+C6_Local)))
					
					SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
					SF4->(dbSeek(xFilial("SF4")+SC6->C6_Tes))
					
					cCFOP:=If(Alltrim(SF4->F4_CF)$"/5101/5401/6101/6401/","5101",If(Alltrim(SF4->F4_CF)$"/7127/7101/","7101",SF4->F4_CF))
					
					cQuebraAtu:=SC9->C9_AGREG+SC9->C9_CARGA+SC9->C9_SEQCAR+SC5->C5_TIPO+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_TIPOCLI+SC5->C5_CLIENT+SC5->C5_LOJAENT+SC5->C5_REAJUST+SC5->C5_CONDPAG+SC5->C5_INCISS+SC5->C5_TRANSP+SC5->C5_TPFRETE+SC5->C5_FORNISS+;
					SC5->C5_VEND1+SC5->C5_VEND2+SC5->C5_VEND3+SC5->C5_VEND4+SC5->C5_RECISS+SB1->B1_RETOPER+SB1->B1_COFINS+SB1->B1_PIS+SF4->F4_DUPLIC+SF4->F4_ESTOQUE+cCFOP
					
					If aScan(aQuebDiv,{|x| x[1]=cQuebraAtu })==0
						aadd(aQuebDiv,{cQuebraAtu})
						If aScan(aQuebras,{|x| x[1]=cQuebraAtu+SC9->C9_PEDIDO })==0
							aadd(aQuebras,{cQuebraAtu,SC9->C9_PEDIDO, SA1->A1_NOME, SC9->C9_PRODUTO, SC9->C9_AGREG,SC9->C9_CARGA,SC9->C9_SEQCAR,SC5->C5_TIPO,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_TIPOCLI,SC5->C5_CLIENT,SC5->C5_LOJAENT,SC5->C5_REAJUST,SC5->C5_CONDPAG,SC5->C5_INCISS,SC5->C5_TRANSP,SC5->C5_TPFRETE,SC5->C5_FORNISS,;
							SC5->C5_VEND1,SC5->C5_VEND2,SC5->C5_VEND3,SC5->C5_VEND4,SC5->C5_RECISS,SB1->B1_RETOPER,SB1->B1_COFINS,SB1->B1_PIS,SF4->F4_DUPLIC,SF4->F4_ESTOQUE,cCFOP , .F.})
						Endif
					Endif
					
					aAdd(aPedidos,{SC9->C9_Pedido,;
					SC9->C9_Item,;
					SC9->C9_Sequen,;
					SC9->C9_QtdLib,;
					SC9->C9_PrcVen,;
					SC9->C9_Produto,;
					.F.,;
					SC9->(Recno()),;
					SC5->(Recno()),;
					SC6->(Recno()),;
					SE4->(Recno()),;
					SB1->(Recno()),;
					SB2->(Recno()),;
					SF4->(Recno()),;
					cQuebraAtu})
					
				Endif
				SC9->(dbSkip())
				
			End
			i++
		End
		//Ordena os pedidos para faturar
		
		lContinua:=.T.
		
		If len(aQuebDiv)>1  /// Pedidos selecionados vao gerar mais de uma nota
			Aviso("Quebras de Nota","Os pedidos selecionados gerarão quebras de nota. Confirme a tela a seguir para prosseguir com o faturamento!",{"OK"})
			lContinua:=flistQuebra(aQuebras)
			If lContinua   /// Reorganiza o array de pedidos com as alterações após confirmação do usuário (Ajusta a variável 15 do array conforme alterações na SC5)
				For i:=1 to len(aPedidos)
					SC9->(DBGoto(aPedidos[i][8]))
					SC5->(DBGoto(aPedidos[i][9]))
					SC6->(DBGoto(aPedidos[i][10]))
					SE4->(DBGoto(aPedidos[i][11]))
					SB1->(DBGoto(aPedidos[i][12]))
					SB2->(DBGoto(aPedidos[i][13]))
					SF4->(DBGoto(aPedidos[i][14]))
					cCFOP:=If(Alltrim(SF4->F4_CF)$"/5101/5401/6101/6401/","5101",SF4->F4_CF)
					cQuebraAtu:=SC9->C9_AGREG+SC9->C9_CARGA+SC9->C9_SEQCAR+SC5->C5_TIPO+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_TIPOCLI+SC5->C5_CLIENT+SC5->C5_LOJAENT+SC5->C5_REAJUST+SC5->C5_CONDPAG+SC5->C5_INCISS+SC5->C5_TRANSP+SC5->C5_TPFRETE+SC5->C5_FORNISS+;
					SC5->C5_VEND1+SC5->C5_VEND2+SC5->C5_VEND3+SC5->C5_VEND4+SC5->C5_RECISS+SB1->B1_RETOPER+SB1->B1_COFINS+SB1->B1_PIS+SF4->F4_DUPLIC+SF4->F4_ESTOQUE+cCFOP
					aPedidos[i][15]:=cQuebraAtu
				Next i
			Endif
		Endif
		
		If lContinua
			
			aSort(aPedidos,,,{|x, y| x[15]+x[1]+x[2] < y[15]+y[1]+y[2]})
			
			If Len(aPedidos)>0
				
				aPedAux:={}
				
				cQuebra:=aPedidos[1][15]
				
				For k:=1 to len(aPedidos)
					
					If cQuebra<>aPedidos[k][15]
						If !lOffLine
							If u_VDVldNF(cSerie,cCliente,cLoja)
								fGeraNota(aPedAux)
								U_C2VD003(.F.)   /// Relatório de resíduos do cliente
							Endif
						Else
							lRet:=fFatOff(aPedAux,cCliente,cLoja)
						Endif
						cQuebra:=aPedidos[k][15]
						aPedAux:={}
					Endif
					
					aLinha:={}
					
					For j:=1 to 14
						aadd(aLinha,aPedidos[k][j])
					Next j
					
					aadd(aPedAux,aLinha)
					
				Next k
				
				If !lOffLine
					If len(aPedAux)	>0
						If u_VDVldNF(cSerie,cCliente,cLoja)
							fGeraNota(aPedAux)
							For c:=1 to len(aStatus)
								oMark:aCols[aStatus[c]][nPosFLAG]:= "LBNO"
								oMark:aCols[aStatus[c]][nPosSTS] := "BR_VERMELHO"
							Next c
							U_C2VD003(.F.)   /// Relatório de resíduos do cliente
						Endif
					Endif
				Else
					lRet:=fFatOff(aPedAux,cCliente,cLoja)
					For c:=1 to len(aStatus)
						oMark:aCols[aStatus[c]][nPosFLAG]:= "LBNO"
						If lRet
							oMark:aCols[aStatus[c]][nPosSTS] := "BR_VERMELHO"
						Endif
					Next c
				Endif
			Endif
		Endif
	Else
		oMark:aCols[aPedFat[i][4]][nPosFLAG]:= "LBNO"
		i++
	Endif
	
	nPesoL:=0
	nPesoB:=0
	nVolum:=0
	nTotal:=0
	oPesoL:Refresh()
	oPesoB:Refresh()
	oVolum:Refresh()
	oTotal:Refresh()
	
	
End

Pergunte("VED172",.F.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  08/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geração NF                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGeraNota(aPedidos,lJob)

	****************************************
	Local aSaveSC5			:=SC5->(GetArea())
	Local aSaveSC9			:=SC9->(GetArea())
	Local dPrevEntrega  	:= CTOD("") // MCS tratamento dPrevEntrega

	Default lJob:=.F.

	aSort(aPedidos,,,{|x, y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3]})

	Private __cNSerie := "1"

	//+------------------------------------------------+
	//|            Geração da nota fiscal              |
	//+------------------------------------------------+

	//Conout("Chamada Inicio geração NF "+FunName()+"  "+Time())
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Chamada Inicio geração NF "+FunName()+"  "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	//Tratamento MCS - ajuste para geração do <dPervEntreg>
	/*If SC5->C5_ENTREG < dDataBase
		dPrevEntrega := dDataBase + 1
	Else 
		dPrevEntrega := SC5->C5_ENTREG
	EndIf
	Pergunte("MT460A",.F.)
	SetMVValue("MT460A","MV_PAR28", dPrevEntrega, .T. ) //data de entrega*/
	cNFiscal := MaPvlNfs(aPedidos,__cNSerie,.F.,.F.,.F.,.T.,.F.,0,0,.T.,.F.,"")
	//Conout("Chamada Final geração NF "+FunName()+"  "+Time())
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Chamada Final geração NF "+FunName()+"  "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

	If Empty(cNFiscal)
		dbUnlockAll()
		If !lJob
			cRet := "Não foi possível faturar o pedido!"
			MostraErro()
		Else
			//Conout( "Não foi possível faturar o pedido!"+aPedidos[1][1]+" Função "+FunName()+" Hora "+Time())
			FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Não foi possível faturar o pedido!"+aPedidos[1][1]+" Função "+FunName()+" Hora "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
		Endif
	Else
		fInsertZ11(aPedidos) //Verifico se usuário quer imprimir a nota mais tarde e jogo os dados na Z11010
	EndIf

	RestArea(aSaveSC5)
	RestArea(aSaveSC9)

Return cNFiscal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  07/19/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chamada externa da impressão da Danfe                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function VED172IM(aSequen)
*******************************
Local i
Local aCli:={}
Private aNFs:={}
Default aSequen:={}

fPrintDanfe(,,aSequen)

If len(aNFs)>0.and.Aviso("Imprimir Packing?","Deseja imprimir o packing list das Danfes impressas?",{"Sim","Nao"})==1
	
	//	For i:=1 to len(aNFs)
	//	    SF2->(DBSetOrder(1))
	//	    If SF2->(DBSeek(xFilial("SF2")+aNFs[i][1]+aNFs[i][2]))
	U_VEDR121(.F.,aNFs,.T.)   //// Impressão packing
	//		Endif
	//    Next i
Endif
////SpedDanfe()

///If len(aSequen)>0 .and. len(aNFs)>0.and.Aviso("Imprimir Residuos?","Deseja imprimir os relatórios de resíduos?",{"Sim","Nao"})==1
If len(aNFs)>0.and.Aviso("Imprimir Residuos?","Deseja imprimir os relatórios de resíduos?",{"Sim","Nao"})==1

	////aadd(aNFs,{SF2->F2_DOC,SF2->F2_SERIE})
    For i:=1 to len(aNFs)
        SF2->(DBSetOrder(1))
       	SF2->(DBSeek(xFilial("SF2")+aNFs[i][1]+aNFs[i][2]))
       	If Ascan(aCli,SF2->(F2_CLIENTE+F2_LOJA))==0
			aadd(aCli,SF2->(F2_CLIENTE+F2_LOJA))
			U_C2VD003(.F.,.T.)   /// Relatório de resíduos do cliente
        Endif
    Next i    

Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerPDF    ºAutor  ³Max Ivan            º Data ³  23/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a transmissao dos e-mails com os PDFs.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GerDanfe.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fPrintDanfe(aNfe,cSerie,aSequen)
************************************************
Local cIdEnt   	:= U_fGetIDEnt()
Local cPathArq 	:= "C:\smartclient\"
Local cPathSrv 	:= "\saida\"
Local cChvNfe  	:= ""
Local aAreaSX1 	:= SX1->(GetArea())
Local lGerou
Local cArqNfe
Local __RelDir  := cPathArq
Local oDanfe1
Local oSetup
Local nFlags
Local cAlias  :=	 "SF2"

Local cFilNfe:=xFilial("SF2")
Local cEmissao:=DTos(dDatabase)
Local nTipo:=2
Local nTpArq:=2
Local nEnvMail:=2

Default aNfe:={}
Default aSequen:={}
Private lEnd  := .F.

Private a_172_Seq:=aSequen

If Len(aNfe)==0
	
	Pergunte("NFSIGW",.F.)
	
	cQuery:=" SELECT TOP 1 F2_DOC, F2_SERIE FROM "+RetSqlTab("SF2")+" WHERE "+RetSqlFil("SF2")+ " AND F2_FIMP='T' AND F2_ESPECIE='SPED' AND F2_EMISSAO='"+DTOS(DDATABASE)+"' AND "+RetSqlDel("SF2")+" ORDER BY  F2_DOC "
///	cQuery:=" SELECT TOP 1 F2_DOC, F2_SERIE FROM  SF2010 SF2  WHERE  F2_FILIAL = '01'  AND F2_ESPECIE='SPED' AND F2_EMISSAO='20180412' AND  SF2.D_E_L_E_T_ = ' '  AND F2_DOC='086584 '"
	
	If Select("TSF2") <> 0
		TSF2->(dbCloseArea())
	End
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TSF2",.T.,.F.)
	
	If TSF2->(!Eof())
		
		MV_PAR01:=TSF2->F2_DOC
		MV_PAR03:=TSF2->F2_SERIE
		
	Else
		Alert("Nenhuma NF pendente para impressão!")
		Return
	Endif
	
	
	cQuery:=" SELECT TOP 1 F2_DOC, F2_SERIE FROM "+RetSqlTab("SF2")+" WHERE "+RetSqlFil("SF2")+ " AND F2_FIMP='T' AND F2_ESPECIE='SPED' AND F2_EMISSAO='"+DTOS(DDATABASE)+"' AND "+RetSqlDel("SF2")+" ORDER BY  F2_DOC DESC"
///	cQuery:=" SELECT TOP 1 F2_DOC, F2_SERIE FROM  SF2010 SF2  WHERE  F2_FILIAL = '01'  AND F2_ESPECIE='SPED' AND F2_EMISSAO='20180412' AND  SF2.D_E_L_E_T_ = ' '  AND F2_DOC='086584 '"
	
	If Select("TSF2") <> 0
		TSF2->(dbCloseArea())
	End
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TSF2",.T.,.F.)
	
	If TSF2->(!Eof())
		
		MV_PAR02:=TSF2->F2_DOC
		
	Endif

	MV_PAR04 := 2	//NF de Saida
	MV_PAR05 := 2	//Frente e Verso - 1:Sim
	MV_PAR06 := 2	//Frente e Verso - 1:Sim

Else
	
	Pergunte("NFSIGW",.F.)
	
	MV_PAR01:=aNfe[1]
	MV_PAR02:=aNfe[Len(aNfe)]
	MV_PAR03:=cSerie
	
Endif

cFilePrint       := cChvNfe
cArqPdf		   := 'nfe' + cFilePrint + '-procnfe'
lAdjustToLegacy  := .F.
__RelDir         := cPathArq
///			IMP_PDF          := 2
oDanfe1          := FWMSPrinter():New("oDanfeI", IMP_SPOOL , lAdjustToLegacy,"c:\smartclient\",.F.)
///			oDanfe1:lInJob   := .T.
If !isBlind()
	oDanfe1:cPathPDF := cPathArq
	oDanfe1:lServer  := .F.
Else
	oDanfe1:cPathPDF := cPathArq
	oDanfe1:lServer  := .T.
EndIf
///			oDanfe1:lViewPdf := .F.
nFlags           := PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
////nFlags           := PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEMARGIN

oSetup           := FWPrintSetup():New(nFlags, "DANFE")
u_DANFE_P1(cIdEnt,,,oDanfe1,oSetup) ////,cArqPdf , .f.)

Return



User Function fGetIDEnt()
*************************
Local cQuery 	:= ""
Local cReturn	:= ""

cQuery := " SELECT ID_ENT 								"
cQuery += " FROM SPED001 								"
cQuery += " WHERE ENTATIV = 'S' 						"
cQuery += " AND CNPJ = '" + AllTrim(SM0->M0_CGC) + "'	"

If Select("QRY") <> 0
	QRY->(dbCloseArea())
End

TCQUERY cQuery NEW ALIAS "QRY"

cReturn := QRY->ID_ENT

Return cReturn


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  08/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lista as quebras de nota para análise do usuário           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static function flistQuebra(aQuebras)
*************************************

Local aHeaQueb:={}
Local aColQueb:={}
Local aAux:={}
Local i, j
Local oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)

//SX3->(DbSetOrder(2))
//SX3->(DbSeek("C5_NUM"))  ;	Aadd(aHeaQueb,{Trim("Pedido") , "PEDIDO" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"SC5",""})
U_SX3RETRG(aHdr, "C5_NUM", 4,"Pedido")

//SX3->(DbSeek("A1_NOME")) ;	Aadd(aHeaQueb,{Trim("Cliente") , "CLIENTE" , SX3->X3_PICTURE , 20 , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"SA1",""})
U_SX3RETRG(aHdr, "A1_NOME", 4,"Cliente")

//SX3->(DbSeek("C9_PRODUTO"));Aadd(aHeaQueb,{Trim("Produto") , "PRODUTO" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"SB1",""})
U_SX3RETRG(aHdr, "C9_PRODUTO", 4,"Produto")

//SX3->(DbSeek("C9_AGREG")) ;	Aadd(aHeaQueb,{Trim("Sequencia") , "AGREG" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C9_AGREG", 4,"Sequencia")

//SX3->(DbSeek("C9_CARGA")) ;	Aadd(aHeaQueb,{Trim("Carga") , "CARGA" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C9_CARGA", 4,"Carga")

//SX3->(DbSeek("C9_SEQCAR"));	Aadd(aHeaQueb,{Trim("Seq.Carga") , "SEQCARGA" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C9_SEQCAR", 4,"Seq.Carga")

//SX3->(DbSeek("C5_TIPO"));	Aadd(aHeaQueb,{Trim("Tipo Pedido") , "C5TIPO" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_TIPO", 4,"Tipo Pedido")

//SX3->(DbSeek("C5_CLIENTE"));Aadd(aHeaQueb,{Trim("Cliente") , "C5CLIE" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_CLIENTE", 4,"Cliente")

//SX3->(DbSeek("C5_LOJACLI"));Aadd(aHeaQueb,{SX3->X3_TITULO , "C5CLIE" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_LOJACLI", 4)

//SX3->(DbSeek("C5_TIPOCLI"));Aadd(aHeaQueb,{SX3->X3_TITULO , "C5CLIE" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_TIPOCLI", 4)

//SX3->(DbSeek("C5_CLIENT")); Aadd(aHeaQueb,{Trim("Cli.Ent.") , "C5CLIEE" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_CLIENT", 4,"Cli.Ent.")

//SX3->(DbSeek("C5_LOJAENT"));Aadd(aHeaQueb,{Trim("Loja.Ent.") , "C5LCLIEE" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_LOJAENT", 4,"Loja.Ent.")

//SX3->(DbSeek("C5_REAJUST"));Aadd(aHeaQueb,{Trim("Reajuste") , "REAJ" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_REAJUST", 4,"Reajuste")

//SX3->(DbSeek("C5_CONDPAG"));Aadd(aHeaQueb,{Trim("Cond.Pagto") , "COND" , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_CONDPAG", 4,"Cond.Pagto")

//SX3->(DbSeek("C5_INCISS"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_INCISS",4)

//SX3->(DbSeek("C5_TRANSP"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_TRANSP",4)

//SX3->(DbSeek("C5_TPFRETE"));Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_TPFRETE",4)

//SX3->(DbSeek("C5_FORNISS"));Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_FORNISS",4)

//SX3->(DbSeek("C5_VEND1"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_VEND1",4)

//SX3->(DbSeek("C5_VEND2"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_VEND2",4)

//SX3->(DbSeek("C5_VEND3"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_VEND3",4)

//SX3->(DbSeek("C5_VEND4"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_VEND4",4)

//SX3->(DbSeek("C5_RECISS"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "C5_RECISS",4)

//SX3->(DbSeek("B1_RETOPER"));Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "B1_RETOPER",4)

//SX3->(DbSeek("B1_COFINS"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "B1_COFINS",4)

//SX3->(DbSeek("B1_PIS"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "B1_PIS",4)

//SX3->(DbSeek("F4_DUPLIC"));	Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "F4_DUPLIC",4)

//SX3->(DbSeek("F4_ESTOQUE"));Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "F4_ESTOQUE",4)

//SX3->(DbSeek("F4_CF"));		Aadd(aHeaQueb,{SX3->X3_TITULO , SX3->X3_CAMPO , SX3->X3_PICTURE , SX3->X3_TAMANHO , SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",""})
U_SX3RETRG(aHdr, "F4_CF",4)

For i:=1 to len(aQuebras)
	aAux:={}
	For j:=2 to len(aQuebras[i])
		aadd(aAux,aQuebras[i][j])
	Next j
	aadd(aColQueb,aAux)
Next i

oMainWnd:ReadClientCoords()
oDlgQue := MsDialog():New(oMainWnd:nTop+100,oMainWnd:nLeft+50,oMainWnd:nBottom-100,oMainWnd:nRight-50,OemToAnsi("Quebras de Pedidos"),,,.F.,,,,,oMainWnd,.T.,,,.F.)

oPnl := TPanel():New(nil,nil,,oDlgQue,,.T.,.F.,,,1,1,,)   //// Painel total
oPnl:Align := CONTROL_ALIGN_ALLCLIENT

oPnlTop := TPanel():New(nil,nil,,oPnl,,.T.,.F.,,,1,1,,) //// Painel Topo
oPnlTop:Align := CONTROL_ALIGN_ALLCLIENT

oPnlBot := TPanel():New(nil,nil,,oPnl,,.T.,.F.,,,30,30,,) /// Painel inferior
oPnlBot:Align := CONTROL_ALIGN_BOTTOM

@ 001,001 To (oPnlTop:nClientHeight/2)-015 ,(oPnlTop:nClientWidth/2)-001  Label oemtoansi("Quebras de Pedidos") Of oPnlTop Pixel

MBQue := MsNewGetDados():New(010, 010, (oPnlTop:nClientHeight/2)-020, (oPnlTop:nClientWidth/2)-005,  ,"AllwaysTrue","AllwaysTrue" , , , , , , , , oPnlTop  ,aHeaQueb,aColQueb)

oBotQOK		:= TButton():New(005,005,"&Faturar",oPnlBot,{|| lOpcao:=.T.,oDlgQue:End()},50,10,,oFont08,,.T.)
oBotQAlt	:= TButton():New(005,060,"&Altera",oPnlBot,{|| fAlteraPV() },50,10,,oFont08,,.T.)
oBotQCanc	:= TButton():New(005,115,"&Ignorar Pedidos do Cliente",oPnlBot,{|| lOpcao:=.F.,oDlgQue:End()},130,10,,oFont08,,.T.)

Activate Dialog oDlgQue Centered


Return lOpcao



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  08/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada da tela de alteração de pedidos (M460NUM)           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAlteraPV()
***************************
Local nPos:=MBQue:oBrowse:nAt
Local aArea:=SC5->(GetArea())
Local nPosTransp:= aScan(MBQue:aHeader,{|x| AllTrim(x[2]) == "C5_TRANSP"})
Local nPosVend	:= aScan(MBQue:aHeader,{|x| AllTrim(x[2]) == "C5_VEND1"})
Local nPosTpFret:= aScan(MBQue:aHeader,{|x| AllTrim(x[2]) == "C5_TPFRETE"})


SC5->(DBSetOrder(1))

If SC5->(DBSeek(xFilial("SC5")+MBQue:aCols[nPos][1]))
	If U_VDM460NUM({{SC5->C5_NUM}},.F.)
		MBQue:aCols[nPos][nPosTransp]:=SC5->C5_TRANSP
		MBQue:aCols[nPos][nPosVend]:=SC5->C5_VEND1
		MBQue:aCols[nPos][nPosTpFret]:=SC5->C5_TPFRETE
		MBQue:Refresh()
		
		/// Ajusta dados do acols
		/*
		SC5->C5_TRANSP 	:= cTransp
		SC5->C5_VEND1 	:= cVend
		SC5->C5_TPFRETE := cTpFrete
		*/
		
	Endif
Endif

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460NUM   ºAutor  ³Fabricio Cargnin    º Data ³  04/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca peso separado do pedido (Z06)                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fSomaPeso(cPedido)
**********************************
Local aPeso
Local cQuery

cQuery  := " SELECT COUNT(*) CONT, SUM(Z06_PESOL) Z06_PESOL,  SUM(Z06_PESOB) Z06_PESOB "
cQuery  += "  FROM (SELECT DISTINCT Z06_PEDIDO, Z06_CAIXA, Z06_PESOL, Z06_PESOB FROM "+RetSqlTab("Z06")
cQuery  += " WHERE "
cQuery  += "  "+RetSqlFil("Z06")+ " AND Z06_NF=' ' AND "
cQuery	+="   Z06_PEDIDO =   '"+cPedido+"' AND "
cQuery  += " Z06_NF=' '  AND Z06_STATUS='L' AND "
cQuery  += "  "+RetSqlDel("Z06")+" "
cQuery  += "  ) TABAUX "

If Select("QRYZ06") <> 0
	QRYZ06->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "QRYZ06"

aPeso:={QRYZ06->Z06_PESOL,QRYZ06->Z06_PESOB,QRYZ06->CONT}

QRYZ06->(dbCloseArea())

Return aPeso


Static Function fAlteraPV2()
***************************
Local nPos:=oMark:oBrowse:nAt
Local aArea:=SC5->(GetArea())
Local nPosTransp:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "A3_NOME"})
Local nPosPed:= aScan(oMark:aHeader,{|x| AllTrim(x[2]) == "C6_NUM"})

SC5->(DBSetOrder(1))

If SC5->(DBSeek(xFilial("SC5")+oMark:aCols[nPos][nPosPed]))
	If U_VDM460NUM({{SC5->C5_NUM}},.F.,.F.)
		SA4->(DBSetOrder(1))
		SA4->(DBSeek(xFilial("SA3")+SC5->C5_TRANSP))
		oMark:aCols[nPos][nPosTransp]:=SA4->A4_NOME
		oMark:Refresh()
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  03/22/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Off Line                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fFatOff(aPedAux,cCliente,cLoja)
***********************************************
Local cSequen
Local i
Local lRet:=.F.
Local cSerie:="1"

If u_VDVldNF(cSerie,cCliente,cLoja)

	SC5->(DBGoto(aPedAux[1][9]))
	SC9->(DBGoto(aPedAux[1][8]))
	
	cSequen:=GetSxENum("ZF2","ZF2_SEQUEN")
	
	If U_VDM460NUM(aPedAux,.F.,.F.,.T.,cSequen)      ////VDM460NUM(aPedidos,lFat, lNota,lOffLine,cSequen)
		ConfirmSx8()
		
		Begin Transaction
		
		For i:=1 to len(aPedAux)
			SC9->(DBGoto(aPedAux[i][8]))
			Reclock("SC9",.F.)
			SC9->C9_SEQFAT:=cSequen
			SC9->(MSUnlock())
		Next i
		
		End Transaction
		
		lRet:=.T.
		
	Endif

Endif

Return lRet


User function VEDJBFAT(lJob, cSequen)
*************************************
Local lRet	:=.F.
Local cQuery:=""
Local cSeqAtu:=""
Local aPedidos:={}
Local aIndPed:={}

Default lJob:=.T.
Default cSequen:=""

//Conout("**********************************************************")
//Conout("Iniciando agendamento de faturamento VEDJBFAT "+Time())
//Conout("***********************************************************")

FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/, "*********************************************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Iniciando agendamento de faturamento VEDJBFAT "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/, "*********************************************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)



If RunNotExclusive()
	
	cQuery:=" SELECT C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_QTDLIB, C9_PRCVEN, C9_PRODUTO, C9_SEQFAT, SC9.R_E_C_N_O_ SC9REG, SC5.R_E_C_N_O_ SC5REG, SC6.R_E_C_N_O_ SC6REG, SE4.R_E_C_N_O_ SE4REG, SB1.R_E_C_N_O_ SB1REG, SB2.R_E_C_N_O_ SB2REG, SF4.R_E_C_N_O_ SF4REG"
	cQuery+=" FROM "+RetSqlTab("SC9")+","+RetSqlTab("SC5")+","+RetSqlTab("SC6")+","+RetSqlTab("SE4")+","+RetSqlTab("SB1")+","+RetSqlTab("SB2")+","+RetSqlTab("SF4")
	cQuery+=" WHERE "
	cQuery+="   "+RetSqlFil("SC9")+" AND C9_NFISCAL=' ' AND C9_BLEST=' ' AND C9_BLCRED=' ' AND "
	
	If !Empty(cSequen)
		cQuery+="   C9_SEQFAT='"+cSequen+"' AND "
	Else
		cQuery+="   C9_SEQFAT<>' ' AND "
	Endif
	
	cQuery+="   "+RetSqlFil("SC5")+" AND C5_NUM=C9_PEDIDO AND "
	cQuery+="   "+RetSqlFil("SC6")+" AND C6_NUM=C9_PEDIDO AND C6_ITEM=C9_ITEM AND "
	cQuery+="   "+RetSqlFil("SE4")+" AND E4_CODIGO=C5_CONDPAG AND "
	cQuery+="   "+RetSqlFil("SB1")+" AND B1_COD=C9_PRODUTO AND"
	cQuery+="   "+RetSqlFil("SB2")+" AND B2_COD=C9_PRODUTO AND B2_LOCAL=C9_LOCAL AND  "
	cQuery+="   "+RetSqlFil("SF4")+" AND F4_CODIGO=C6_TES AND "
	cQuery+="   "+RetSqlDel("SC9")+" AND "
	cQuery+="   "+RetSqlDel("SC5")+" AND "
	cQuery+="   "+RetSqlDel("SC6")+" AND "
	cQuery+="   "+RetSqlDel("SE4")+" AND "
	cQuery+="   "+RetSqlDel("SB1")+" AND "
	cQuery+="   "+RetSqlDel("SB2")+" AND "
	cQuery+="   "+RetSqlDel("SF4")
	
	cQuery+=" ORDER BY C9_SEQFAT, C9_PEDIDO, C9_ITEM  "
	
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"VEDJBFAT Query: " +cQuery, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	//CONOUT(cQuery)
	
	If Select("QFATSC9") <> 0
		QFATSC9->(dbCloseArea())
	End
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QFATSC9",.T.,.F.)
	
	cSeqAtu:=QFATSC9->C9_SEQFAT
	
	While QFATSC9->(!Eof())
		
		aAdd(aPedidos,{QFATSC9->C9_Pedido,;
		QFATSC9->C9_Item,;
		QFATSC9->C9_Sequen,;
		QFATSC9->C9_QtdLib,;
		QFATSC9->C9_PrcVen,;
		QFATSC9->C9_Produto,;
		.F.,;
		QFATSC9->SC9REG,;
		QFATSC9->SC5REG,;
		QFATSC9->SC6REG,;
		QFATSC9->SE4REG,;
		QFATSC9->SB1REG,;
		QFATSC9->SB2REG,;
		QFATSC9->SF4REG})
		
		If Ascan(aIndPed,QFATSC9->C9_Pedido)==0
			aadd(aIndPed,QFATSC9->C9_Pedido)
		Endif
		
		QFATSC9->(DBSkip())
		
		If cSeqAtu<>QFATSC9->C9_SEQFAT
			If fAjusSC5(aIndPed,cSeqAtu)
				ZF2->(DBSetOrder(1))
				If ZF2->(DBSeek(xFilial("ZF2")+cSeqAtu))
					fGeraNota(aPedidos,.T.)
				Endif
				If QFATSC9->(!Eof())
					aPedidos:={}
					aIndPed:={}
					cSeqAtu:=QFATSC9->C9_SEQFAT
				Endif
			Endif
		Endif
	End
	
	/*Conout("**********************************************************")
	Conout("Finalizando agendamento de faturamento VEDJBFAT "+Time())
	Conout("***********************************************************")*/

	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"**********************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Finalizando agendamento de faturamento VEDJBFAT "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"**********************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	
	QFATSC9->(dbCloseArea())
Else
	
	/*Conout("**************************************************************************************")
	Conout("Finalizando agendamento de faturamento VEDJBFAT - EXISTE OUTRO JOB EM EXECUCAO"+Time())
	Conout("******* -0********************************************************************************")*/
	
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"**************************************************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"Finalizando agendamento de faturamento VEDJBFAT - EXISTE OUTRO JOB EM EXECUCAO"+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"**************************************************************************************", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  02/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chamada agendamento via JOB                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function VDFATJOB()
************************
RpcSetEnv("01","01")

//Conout("INICIO JOB  faturamento VDFATJOB "+Time())
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"INICIO JOB  faturamento VDFATJOB "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

U_VEDJBFAT(.T., "")

//Conout("FINAL JOB faturamento VDFATJOB "+Time())
FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/,"FINAL JOB faturamento VDFATJOB "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

RpcClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  02/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste pedidos conforme informações do faturamento off lineº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAjusSC5(aIndPed,cSequen)
*****************************************
Local lRet:=.F.
Local i
ZF2->(DBSetOrder(1))
SC5->(DBSetOrder(1))

If ZF2->(DBSeek(xFilial("ZF2")+cSequen))
	If SC5->(DBSeek(xFilial("SC5")+aIndPed[1]))
		lRet:=.T.
		//Conout(" VED172 - Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen)
		FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/," VED172 - Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
		Reclock("SC5",.F.)
		SC5->C5_PBRUTO  := ZF2->ZF2_PBRUTO
		SC5->C5_PESOL   := ZF2->ZF2_PESOL
		SC5->C5_VOLUME1 := ZF2->ZF2_VOL1
		SC5->C5_ESPECI1 := ZF2->ZF2_ESP1
		SC5->C5_REDESP 	:= ZF2->ZF2_REDESP
		SC5->C5_TPFRETE := ZF2->ZF2_TPFRET
		SC5->(MSUnlock())
		
		For i:=2 to len(aIndPed)
			If SC5->(DBSeek(xFilial("SC5")+aIndPed[i]))
				//Conout(" VED172 - Fat OffLine ZERAMENTO Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen)
				FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/," VED172 - Fat OffLine ZERAMENTO Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
				Reclock("SC5",.F.)
				SC5->C5_PBRUTO  := 0
				SC5->C5_PESOL   := 0
				SC5->C5_VOLUME1 := 0
				SC5->C5_ESPECI1 := ZF2->ZF2_ESP1
				SC5->C5_REDESP 	:= ZF2->ZF2_REDESP
				SC5->C5_TPFRETE := ZF2->ZF2_TPFRET
				SC5->(MSUnlock())
			Endif
		Next i
	Else
		//Conout(" VED172 - ####  ERROR 1 #### Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen)
		FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/," VED172 - ####  ERROR 1 #### Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	Endif
Else
	//Conout(" VED172 - ####  ERROR 2 #### Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen)
	FWLogMsg("INFO", /*cTransactionId*/, "VED172", /*cCategory*/, /*cStep*/, /*cMsgId*/," VED172 - ####  ERROR 2 #### Fat OffLine Ajuste SC5 x ZF2 "+SC5->C5_NUM+" Seq "+cSequen, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
Endif

Return lRet


Static Function RunNotExclusive()
*********************************
Local cFile := "Veda_FATOFFLINE.lck"

If File(cFile)
	n7Semaforo := FOpen(cFile,FO_DENYREAD)
Else
	n7Semaforo := FCreate(cFile)
End

If n7Semaforo < 0
	Return .F.
End

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  02/16/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monitor de processos de faturamentos off-line               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function VD172MNT()
************************
Local oPnl
Local aCampos		:= {}
Local cPerg			:= "VD172MNT"
Local lInverte		:= .F.
Local oFontNegr 	:= oSend(TFont(),"New","MS Sans Serif",0,08,,.T.) //Fonte MS Sans Serif em modo negrito
Local aHeader   	:= {}
Local aCols 		:= {}
Local aCpo			:= {}
Local aColsM1		:= {}
Local aColsM2		:= {}
Private oDlgMNT
Private oMarkMNT
Private oPedMN
Private cIndexMNT	:= CriaTrab(NIl,.f.)
Private aCoresMNT	:= {}
Private aAltsMNT	:= {}
Private aHeaderPri

fAjusSX1MN(cPerg)

If Pergunte(cPerg,.T.)
	
	oDlgMNT := MsDialog():New(1,1,400,600,OemToAnsi("Monitor Processos Off-Line"),,,.F.,,,,,oMainWnd,.T.,,,.F.)
	oDlgMNT:lMaximized := .T.
	oDlgMNT:lEscClose  := .F.
	
	///oPanel:=       tPanel():New(01,01,"Teste",oDlg,oTFont,.T.,,CLR_YELLOW,CLR_BLUE,100,100)
	oPnlTotM := TPanel():New(nil,nil,,oDlgMNT,,.T.,.F.,,,1,1,,)
	oPnlTotM:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPnlTopM := TPanel():New(nil,nil,,oPnlTotM,,.T.,.F.,,,1,1,,)
	oPnlTopM:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPnlSupM := TPanel():New(nil,nil,,oPnlTotM,,.T.,.F.,,,20,20,,)
	oPnlSupM:Align := CONTROL_ALIGN_TOP
	
	oPnlBotM := TPanel():New(nil,nil,,oPnlTotM,,.T.,.F.,,,100,100,,)
	oPnlBotM:Align := CONTROL_ALIGN_BOTTOM
	
	oPnlM := TPanel():New(nil,nil,,oPnlTopM,,.T.,.F.,,,1,1,,)
	oPnlM:Align := CONTROL_ALIGN_ALLCLIENT
	
	aHeaderM1 := fHeader(2)

	aColsM1   := {}

	MsgRun("Aguarde, selecionando processos...",, {|| aColsM1:=VD172MN(1)})
	
	oMarkMNT :=MsNewGetDados():New(20,1,1,1,GD_UPDATE,,,,,,,,,,oPnlM,aHeaderM1,aColsM1)
	oMarkMNT:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oMarkMNT:oBrowse:blDblClick := {|| If(oMarkMNT:oBrowse:nColPos <>1,  MsgRun("Aguarde, listando pedidos do processo...",,{||  fListProc() }), fMarkMN() ) }
	
	oPnlInfMN := TPanel():New(nil,nil,,oPnlBotM,,.T.,.F.,,,20,20,,)
	oPnlInfMN:Align := CONTROL_ALIGN_BOTTOM
	
	oBotAnali := TButton():New(001,010,"&Imprime Docs"	,oPnlInfMN,{|| fImpDocs() }	,50,15,,,,.T.)

	oBotAnali := TButton():New(001,070,"&Atualiza Dados"	,oPnlInfMN,{|| aColsM1:=VD172MN(1,,.T.) }	,50,15,,,,.T.)
	
	oPnlRodMN := TPanel():New(nil,nil,,oPnlBotM,,.T.,.F.,,,1,1,,)
	oPnlRodMN:Align := CONTROL_ALIGN_ALLCLIENT
	
	aHeaderM2 := fHeader(3)
	aColsM2   := {}
	aadd(aColsM2   ,{" "," "," "," "," ",.f.})
	
	oPedMN := MsNewGetDados():New(1, 1, 1, 1,,,,,Nil,,,,,,oPnlRodMN,aHeaderM2,aColsM2)
	oPedMN:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	Activate msDialog oDlgMNT Centered On Init fRefreshMN()
End



Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ved172    ºAutor  ³Fabricio Cargnin    º Data ³  08/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta perguntas da tela de liberação do PCP                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAjusSX1MN(cPerg)
********************************
Local aArea := GetArea()                                                                         

u_xPutSx1(cPerg,"01","Pedido de"			,"","","mv_ch1","C",6,0,1,"G","","SC5"	,"","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o Pedido Inicial"},{""},{""})
u_xPutSx1(cPerg,"02","Pedido Ate"			,"","","mv_ch2","C",6,0,1,"G","","SC5"	,"","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o Pedido Final"},{""},{""})
u_xPutSx1(cPerg,"03","Apenas Pendentes?	","","","mv_ch3","N",01,0,1,"C","",""	,"","","mv_par03","Sim","","","","Nao","","","","","","","","","","","",{"Define se lista apenas pedido "},{"totalmente separados "},{""})
u_xPutSx1(cPerg,"04","Apenas Meus Processos?	","","","mv_ch4","N",01,0,1,"C","",""	,"","","mv_par04","Sim","","","","Nao","","","","","","","","","","","",{"Define se lista apenas processos"},{" do usuário logado "},{""})

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Microsiga           º Data ³  02/20/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Listagem dos processos do monitor de processos offline      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VD172MN(nOpcao,cSequen,lAtualiza)
*************************************************
Local cQuery:=" "
Local aCols:={}
Local cLegenda

Pergunte("VD172MNT",.F.)

If nOpcao==1  /// ZF2

	cQuery+=" SELECT ZF2_FILIAL, ZF2_SEQUEN, ZF2_DATA, ZF2_USER, ZF2_STATUS, "
	cQuery+=" TR_FATURADO=(SELECT COUNT(*) FROM "+RetSqlName("SC9")+" SC9 WHERE C9_FILIAL=ZF2_FILIAL AND C9_SEQFAT=ZF2_SEQUEN AND C9_NFISCAL<>' ' AND SC9.D_E_L_E_T_<>'*'), "
	cQuery+=" TR_NFATURADO=(SELECT COUNT(*) FROM "+RetSqlName("SC9")+" SC9 WHERE C9_FILIAL=ZF2_FILIAL AND C9_SEQFAT=ZF2_SEQUEN AND C9_NFISCAL=' ' AND SC9.D_E_L_E_T_<>'*'), "
	cQuery+=" TR_TRANSMIT=(SELECT COUNT(*) FROM "+RetSqlName("SC9")+" SC9 "
	cQuery+=" 				INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF AND SF2.D_E_L_E_T_<>'*' AND F2_FIMP='T' "
	cQuery+=" 				INNER JOIN SPED054 ON ID_ENT='0000"+xFilial("SF2")+"' AND NFE_ID=F2_SERIE+F2_DOC AND CSTAT_SEFR='100' AND SPED054.D_E_L_E_T_<>'*'  "
	cQuery+=" 				WHERE C9_FILIAL=ZF2_FILIAL AND C9_SEQFAT=ZF2_SEQUEN AND C9_NFISCAL<>' ' AND SC9.D_E_L_E_T_<>'*'), "
	cQuery+=" TR_IMPRESS=(SELECT COUNT(*) FROM "+RetSqlName("SC9")+" SC9 "
	cQuery+=" 				INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF AND SF2.D_E_L_E_T_<>'*' AND F2_FIMP='S' "
	cQuery+=" 				WHERE C9_FILIAL=ZF2_FILIAL AND C9_SEQFAT=ZF2_SEQUEN AND C9_NFISCAL<>' ' AND SC9.D_E_L_E_T_<>'*') "
	cQuery+=" FROM "
	cQuery+=" 	"+RetSqlName("ZF2")+" ZF2 "
	cQuery+=" INNER JOIN "+RetSqlName("SC9")+" SC9  ON 	C9_FILIAL=ZF2_FILIAL AND C9_PEDIDO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND SC9.D_E_L_E_T_<>'*' "
	cQuery+=" LEFT JOIN "+RetSqlName("SF2")+" SF2  ON 	F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF  AND SF2.D_E_L_E_T_<>'*' "
	cQuery+=" WHERE "
	cQuery+=" 	ZF2_FILIAL='"+xFilial("ZF2")+"' AND ZF2_STATUS=' ' AND ZF2.D_E_L_E_T_<>'*'  AND ZF2_SEQUEN=C9_SEQFAT "
	cQuery+="   "
	If mv_par03==1
		cQuery+=" AND ISNULL(F2_FIMP,' ') <>'S'	"	
	Endif              
	If mv_par04==1
		cQuery+=" 	AND	ZF2_USER='"+Alltrim(PSWRet()[1][2])+"'"
    Endif

	cQuery+=" GROUP BY ZF2_FILIAL, ZF2_SEQUEN, ZF2_DATA, ZF2_USER, ZF2_STATUS "
	cQuery+=" ORDER BY ZF2_SEQUEN, ZF2_DATA, ZF2_USER, ZF2_STATUS "

///	cQuery+=" 				INNER JOIN SPED050 ON F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF AND SF2.D_E_L_E_T_<>'*' AND F2_FIMP='T' "

	If Select("QZF2") <> 0
		QZF2->(dbCloseArea())
	End
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QZF2",.T.,.F.)
   
	TCSetField("QZF2","ZF2_DATA","D",08,0)
	
	While QZF2->(!Eof())

        cLegenda:=""

        If QZF2->TR_NFATURADO> 0 .and.  QZF2->TR_FATURADO=0   /// Não faturado
            cLegenda:="BR_VERMELHO"  
        ElseIf QZF2->TR_NFATURADO> 0 .and.  QZF2->TR_FATURADO>0   /// Faturado parcial
            cLegenda:="BR_PINK"  
        ElseIf QZF2->TR_NFATURADO=0 .and.  QZF2->TR_TRANSMIT==QZF2->TR_FATURADO   /// Faturado e transmitido
            cLegenda:="BR_VERDE"  
        ElseIf QZF2->TR_NFATURADO= 0 .and.  QZF2->TR_FATURADO>0 .and. QZF2->TR_IMPRESS==0  /// Faturado e Não transmitido
            cLegenda:="BR_AMARELO"  
        ElseIf QZF2->TR_IMPRESS==QZF2->TR_FATURADO   /// Danfes Impressas
            cLegenda:="BR_AZUL"  
		Else
            cLegenda:="BR_PRETO"  
        Endif
        aadd(aCols,{"LBNO",cLegenda,QZF2->ZF2_SEQUEN,QZF2->ZF2_DATA,QZF2->ZF2_USER,QZF2->ZF2_STATUS,.F. })
		QZF2->(DBSkip())
    End
ElseIf nOpcao==2
	cQuery:=" SELECT DISTINCT C9_PEDIDO, C9_NFISCAL, A1_NOME, F2_FIMP , F2_DOC, F2_SERIE FROM  "+RetSqlName("SC9")+" SC9  "
	cQuery+="  	INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C9_CLIENTE AND A1_LOJA=C9_LOJA AND SA1.D_E_L_E_T_<>'*' " 
	cQuery+="   LEFT JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF AND SF2.D_E_L_E_T_<>'*' "
	cQuery+=" WHERE "
	cQuery+="  C9_FILIAL='"+xFilial("SC9")+"' AND SC9.D_E_L_E_T_<>'*'  AND C9_SEQFAT='"+cSequen+"' "

	If Select("QZF2") <> 0
		QZF2->(dbCloseArea())
	End
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"QZF2",.T.,.F.)
		
	While QZF2->(!Eof())
        cLegenda:=""
        cStatus:=""
        If Empty(QZF2->C9_NFISCAL)  /// Não faturado
            cLegenda:="BR_VERMELHO"  
        ElseIf Empty(QZF2->F2_FIMP)  /// Faturado e não transmitido
            cLegenda:="BR_AMARELO"  
        ElseIf QZF2->F2_FIMP=="T" /// Transmitido
               cQuerySts:="SELECT TOP 1 CSTAT_SEFR, XMOT_SEFR FROM SPED054 WHERE ID_ENT='0000"+xFilial("SF2")+"' AND NFE_ID='"+QZF2->(F2_SERIE+F2_DOC)+"' AND CSTAT_SEFR='100' AND SPED054.D_E_L_E_T_<>'*'  ORDER BY R_E_C_N_O_ DESC "
				If Select("QSTATUS") <> 0
					QSTATUS->(dbCloseArea())
				End
				
				DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuerySts),"QSTATUS",.T.,.F.)
				cStatus:=QSTATUS->XMOT_SEFR
                If QSTATUS->CSTAT_SEFR=="100"
            		cLegenda:="BR_VERDE"  
                Else
            		cLegenda:="BR_LARANJA"  
                Endif

        ElseIf QZF2->F2_FIMP=="S" /// Impresso
            cLegenda:="BR_AZUL"  
        Endif
        aadd(aCols,{cLegenda,QZF2->C9_PEDIDO,QZF2->C9_NFISCAL,QZF2->A1_NOME,cStatus,.F. })

		QZF2->(DBSkip())
    End


Endif

If lAtualiza

	oMarkMNT:aCols:=aCols
	oMarkMNT:Refresh()
	oPedMN:aCols:={{" "," "," "," "," ",.f.}}
	oMarkMNT:Refresh()
	oPedMN:Refresh()

Endif

Return aCols

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio Cargnin    º Data ³  02/16/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lista o detalhamento dos processos                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static function fListProc()
***************************
Local nLin		:=oMarkMNT:oBrowse:nAt
Local nPosProces:= aScan(oMarkMNT:aHeader,{|x| AllTrim(x[2]) == "ZF2_SEQUEN"})
Local cProcess	:=oMarkMNT:aCols[nLin][nPosProces]

aCols:=VD172MN(2,cProcess)

oPedMN:aCols:=aCols

oPedMN:Refresh()

Return aCols




Static Function fMarkMN()
***********************
Local nLin    	:= oMark:oBrowse:nAt
Local nPosFLAG	:= aScan(oMarkMNT:aHeader,{|x| AllTrim(x[2]) == "OK"})
Local nPosSTS	:= aScan(oMarkMNT:aHeader,{|x| AllTrim(x[2]) == "STATUS"})
Local c

If oMarkMNT:oBrowse:nColPos == nPosFLAG
	If oMarkMNT:aCols[oMarkMNT:nAt][nPosSTS]=="BR_VERDE".or.oMarkMNT:aCols[oMarkMNT:nAt][nPosSTS]=="BR_AZUL"
		If oMarkMNT:aCols[oMarkMNT:nAt][nPosFLAG] == "LBNO"
			oMarkMNT:aCols[oMarkMNT:nAt][nPosFLAG]:= "LBOK"           
		Else
			oMarkMNT:aCols[oMarkMNT:nAt][nPosFLAG]:= "LBNO"
		EndIf
		oMarkMNT:oBrowse:Refresh()
		oDlgMNT:Refresh()
	Endif
	
Endif

Return .T.


Static function fRefreshMN(lInit)
**************************
Local lOk			:= .F.
Local bOk			:= {|| oDlgMNT:End() }
Local bCancel   	:= {|| oDlgMNT:End() }
Local aButtons		:= {}
Default lInit:=.T.

If lInit
	aAdd(aButtons,{ "LEGENDA", {||  U_VD172LMN() }  , "Legenda","Legenda" })
	EnchoiceBar(oDlgMNT,bOk,bCancel,,aButtons)
Endif

oMarkMNT:Refresh()
oDlgMNT:Refresh()

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio            º Data ³  02/16/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Legenda Monitor                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VD172LMN
*********************
Local aSituacoes := {}

aAdd(aSituacoes,{"BR_VERMELHO"	,OemToAnsi("Nota não Gerada")})
aAdd(aSituacoes,{"BR_PINK"		,OemToAnsi("Pendente Faturamento de Pedidos")})
aAdd(aSituacoes,{"BR_AMARELO"	,OemToAnsi("Faturado e Não Transmitido")})
aAdd(aSituacoes,{"BR_LARANJA"	,OemToAnsi("Pendente autorizazção do SEFAZ")})
aAdd(aSituacoes,{"BR_VERDE"   	,OemToAnsi("Faturado e Transmitido")})
aAdd(aSituacoes,{"BR_AZUL"		,OemToAnsi("Danfe Impressa")})
aAdd(aSituacoes,{"BR_PRETO"		,OemToAnsi("Com Pendencias")})

BrwLegenda("Monitor de processos","Legenda",aSituacoes)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Fabricio            º Data ³  02/16/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime documentos liberados                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  fImpDocs()
***************************
Local i
Local aSequen:={}
Local nPosProces:= aScan(oMarkMNT:aHeader,{|x| AllTrim(x[2]) == "ZF2_SEQUEN"})
Local nPosOK:= aScan(oMarkMNT:aHeader,{|x| AllTrim(x[2]) == "OK"})

For i:=1 to len(oMarkMNT:aCols)
    If oMarkMNT:aCols[i][nPosOK]=="LBOK"
       aadd(aSequen,oMarkMNT:aCols[i][nPosProces])
    Endif
Next i

If len(aSequen)>0
	u_VED172IM(aSequen)

	For i:=1 to len(oMarkMNT:aCols)
	    If oMarkMNT:aCols[i][nPosOK]=="LBOK"
	       oMarkMNT:aCols[i][nPosOK]:="LBNO"
	    Endif
	Next i
	
Endif

fRefreshMN(.f.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VED172    ºAutor  ³Willian Wamser      º Data ³  28/01/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que determina se os itens serão levados a tabela Z11 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fInsertZ11(aPedidos)

	Local aVerificado:={}
	Local i:=1
	Local aParametro:={}
	Local cCodUsuLog:=""

	cCodUsuLog:=RetCodUsr()

	aParametro:= strtokarr(TRIM(GETMV("VD_172UF")),',')

	While (i<=len(aPedidos))

		if(aScan(aVerificado,aPedidos[i][1])==0)
			//não passou no pedido, então executa
			
			SC5->(dbSetOrder(1))
			SA1->(dbSetOrder(1))

			SC5->(DbSeek(xFilial("SC5")+aPedidos[i][1]))
			SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

			//IF (SA1->A1_EST !='MT' .and. SA1->A1_EST !='AL' .and. SA1->A1_EST !='RR' .and. SA1->A1_EST !='RO')
			If(aScan(aParametro,SA1->A1_EST)==0)

				If(Aviso("Impressão DANF-e","Deseja imprimir a Danf-e do pedido "+aPedidos[i][1]+" mais tarde?",{"Sim","Nao"})==1)

					Reclock("Z11" , .T.)
					
					Z11->Z11_FILIAL:=xFilial()
					Z11->Z11_NUMPED:=aPedidos[i][1]
					Z11->Z11_USER:=UsrRetName(cCodUsuLog)
					Z11->Z11_DATA:=Date()
					Z11->Z11_HORA:=TIME()
					
					Z11->(MSUnlock())

				EndIf

			EndIf

			aadd(aVerificado,aPedidos[i][1])

		EndIf

		i:=i+1	

	EndDo

Return
