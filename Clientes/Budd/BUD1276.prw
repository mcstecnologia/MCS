#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥BUD1276 ∫ Autor ≥ Murilo MAIS i9       ∫ Data ≥  03/07/17   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥RelatÛrio de ConferÍncia Contabil                           ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ SIGACTB                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function BUD1276()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Local cDesc1        := "RelatÛrio de ConferÍncia Contabil"
Local cDesc2        := ""
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "RelatÛrio de ConferÍncia Contabil"
Local nLin         	:= 80

Local Cabec1       	:= "CPF/CNPJ           NOME                                     ENTRADA    EMISSAO    NFISCAL    SERIE    CODISS            VALOR               BASE ISS             ALIQ                     RETIDO              CALCULADO"
Local Cabec2       	:= ""
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
Local imprime      	:= .T.
Local aOrd 			:= {}
Local nOpc			:= 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "BUD1276" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "BUD1276" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    	:= "SFT"

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ AJUSTE NO SX1                                                ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Private cPerg 		:= "BUD1276"

Private oDlg,oMainWnd
Private oCpo1, cCpo2, oExcel, oPisCofins, oTitulos, oRecDepBri,oFilial

Private dData1 		:= FirstDate(dDatabase)	//Retorna a Data com Primeiro Dia do Mes da Data Informada
Private dData2 		:= LastDate(dDatabase)	//Retorna a Data com ⁄ltimo Dia do Mes da Data Informada
Private lExcel 		:= .F.
Private lPisCofins 	:= .F.
Private lTitulos 	:= .F.
Private lRecDepBri 	:= .F.
Private cLote		:= IIF(cEmpAnt=="01","008880","8880")

Private aCT2Tit		:= {}	//Dados CT2 para Titulos
Private aCT2Rec		:= {}	//Dados CT2 para Receitas
Private aCT2Ativ	:= {}	//Dados CT2 para Ativo
Private aCT2Est		:= {}	//Dados CT2 para Estorno
Private aCT2Outros	:= {}	//Dados CT2 para Outros Creditos
Private aGravaCF8	:= {}

Private aTotCST		:= {}
Private aTotCF5		:= {{0,0},{0,0},{0,0},{0,0}}
Private aDadosCT1	:= {"","",0,0,0,0,0,""}

Private lWhen1		:= .T.
Private lWhen2		:= .F.
Private lWhen3		:= .F.

Private cOpc := "T=Todas"
Private aFilUser := FWLoadSM0()
Private aFiliais := {}

aadd(aFiliais,cOpc)

For nInc := 1 To Len(aFilUser)
	If cEmpAnt == aFilUser[nInc][1]
		aadd(aFiliais,AllTrim(aFilUser[nInc][2])+"="+AllTrim(aFilUser[nInc][7]))
	EndIf
Next nInc

DEFINE MSDIALOG oDlg TITLE "Digite os dados" FROM 0,0 TO 240,300 OF oMainWnd PIXEL

@ 004, 006 SAY "Data De" 	SIZE 070,7 PIXEL OF oDlg
@ 003, 065 MSGET oCpo1 VAR dData1 SIZE 060,007 PIXEL OF oDlg

@ 017, 006 SAY "Data Ate" 	SIZE 070,7 PIXEL OF oDlg
@ 016, 065 MSGET oCpo2 VAR dData2 SIZE 060,007 VALID VerificaBotoes() PIXEL OF oDlg

@ 30, 006 SAY "Filial" SIZE 70,7 PIXEL OF oDlg
@ 29, 065 MSCOMBOBOX oItens VAR cOpc ITEMS aFiliais SIZE 60,7 PIXEL OF oDlg

@ 043, 006 CHECKBOX oExcel 		VAR lExcel 		PROMPT "Gera Excel?" VALID VerificaBotoes()						SIZE 140, 010 PIXEL OF oDlg
@ 056, 006 CHECKBOX oPisCofins 	VAR lPisCofins	PROMPT "Atualiza PIS/COFINS?" 						WHEN lWhen1 SIZE 140, 010 PIXEL OF oDlg
@ 069, 006 CHECKBOX oTitulos 	VAR lTitulos	PROMPT "Contabiliza Titulos?" 						WHEN lWhen2 SIZE 140, 010 PIXEL OF oDlg
@ 082, 006 CHECKBOX oRecDepBri 	VAR lRecDepBri	PROMPT "Contabiliza Receitas/DepreciaÁ„o/Brindes?" 	WHEN lWhen3 SIZE 140, 010 PIXEL OF oDlg

DEFINE SBUTTON FROM 102,060 TYPE 2 ACTION ( nOpc:=0,oDlg:End() ) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM 102,100 TYPE 1 ACTION ( nOpc:=1,oDlg:End() ) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTER

If nOpc == 0
	Return
EndIf

/* AlteraÁ„o contas contabeis Marcelo 06/09/2021.

aadd(aCT2Rec,{"320103006","210301004"   ,"053","PIS S/RECEITA FINANCEIRA REF. "		+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73130",""})
aadd(aCT2Rec,{"320103007","210301005"   ,"054","COFINS S/RECEITA FINANCEIRA REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73130",""})

aadd(aCT2Ativ,{"210301004","320103006"  ,"051","CREDITO PIS S/DEPRECIACAO REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"","73130"})
aadd(aCT2Ativ,{"210301005","320103007"  ,"052","CREDITO COFINS S/DEPRECIACAO REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"","73130"})

aadd(aCT2Est,{"320101024","210301004"   ,"053","PIS S/BRINDES REF. "				+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73120",""})
aadd(aCT2Est,{"320101024","210301005"   ,"054","COFINS S/BRINDES REF. "				+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73120",""})

Fim alteraÁ„o contas contabeis.
*/

If cEmpAnt == "01"
	aadd(aCT2Rec,{"320103006","210401027"   ,"053","PIS S/RECEITA FINANCEIRA REF. "		+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73130",""})
	aadd(aCT2Rec,{"320103007","210401028"   ,"054","COFINS S/RECEITA FINANCEIRA REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73130",""})

	aadd(aCT2Ativ,{"210401027","320103006"  ,"051","CREDITO PIS S/DEPRECIACAO REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"","73130"})
	aadd(aCT2Ativ,{"210401028","320103007"  ,"052","CREDITO COFINS S/DEPRECIACAO REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"","73130"})

	aadd(aCT2Est,{"320101024","210401027"   ,"053","PIS S/BRINDES REF. "				+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73120",""})
	aadd(aCT2Est,{"320101024","210401028"   ,"054","COFINS S/BRINDES REF. "				+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73120",""})
ElseIf cEmpAnt == "02"
	aadd(aCT2Rec,{"330103002","210401027"  ,"053","PIS S/RECEITA FINANCEIRA REF. "		+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73140",""})
	aadd(aCT2Rec,{"330103001","210401028"  ,"054","COFINS S/RECEITA FINANCEIRA REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"73140",""})
ElseIf cEmpAnt == "03"
	aadd(aCT2Rec,{"3213004","2131004"   ,"41","PIS S/RECEITA FINANCEIRA REF. "		+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"",""})
	aadd(aCT2Rec,{"3213005","2131005"   ,"42","COFINS S/RECEITA FINANCEIRA REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),0,"",""})
EndIf
/*
PutSx1(cPerg,"01","Data De            ?","Data De            ?","Data De            ?", "mv_ch1", "D", 08, 0, 0,"G", "", "", "", "","MV_PAR01","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"02","Data Ate           ?","Data Ate           ?","Data Ate           ?", "mv_ch2", "D", 08, 0, 0,"G", "", "", "", "","MV_PAR02","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"03","Opcao              ?","Opcao              ?","Opcao              ?", "mv_ch3", "N", 01, 0, 0,"C", "", "", "", "","MV_PAR03","Analitico","Analitico","Analitico", "","Sintetico","Sintetico","Sintetico", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"04","Exporta Excel      ?","Exporta Excel      ?","Exporta Excel      ?", "mv_ch4", "N", 01, 0, 0,"C", "", "", "", "","MV_PAR04","Sim","Sim","Sim", "","Nao","Nao","Nao", "", "", "", "", "", "", "", "", "", "", "", "", "")
*/
Pergunte(cPerg,.F.)
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ FIM DO AJUSTE NO SX1                                         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta a interface padrao com o usuario...                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !lExcel
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)
EndIf
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,dData1,dData2,lExcel) },Titulo)

If lPisCofins .And. MsgYesNo("Conforme os dados do relatÛrio, deseja realmente atualizar Pis/Cofins?")
	AtualizaPisCofins(dData1,dData2)
EndIf

If lTitulos .Or. lRecDepBri
	GravaCT2()
EndIf

Return

Static Function VerificaBotoes()
lWhen2 := lExcel .And. HabilitaBotao({},"TITULOS")

If ! lWhen2
	lTitulos := .F.
EndIf

lWhen3 := lExcel .And. HabilitaBotao({},"REC/ATI/EST")

If ! lWhen3
	lRecDepBri := .F.
EndIf

Return .T.

Static Function HabilitaBotao(aDados,cOpcao)
Local lRet 		:= .T.
Local nInc		:= 0
Local cFiltro	:= ""
Local cQuery	:= ""
Default cOpcao 	:= ""

If cOpcao == "TITULOS" .Or. cOpcao == "REC/ATI/EST"

	cQuery := "SELECT CT2_DEBITO "
	cQuery += "FROM " + RETSQLNAME("CT2") + " CT2 "
	cQuery += "WHERE CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
	cQuery += "AND CT2_FILIAL = '"+xFilial("CT2")+"' "
	cQuery += "AND CT2_LOTE = '"+cLote+"' "
	cQuery += "AND D_E_L_E_T_ <> '*'"

	If cOpcao == "TITULOS"

		cQuery += "AND CT2_DOC = '000001' "

	Elseif cOpcao == "REC/ATI/EST"

		cQuery += "AND CT2_DOC = '000002' "

	EndIf

EndIf

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

If QUERY -> ( ! eof() )
	lRet := .F.
EndIf

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

Return lRet
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  09/06/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,dData1,dData2,lExcel)

Local lPrim		:= .T.
Local nTotal1	:= 0
Local nTotal2	:= 0
Local nTotal3	:= 0
Local nTotal4	:= 0
Local nTotal5	:= 0
Local nTotal6	:= 0
Local nTotal7	:= 0
Local nTotal8	:= 0
Local nTotal9	:= 0

Local nTotal1ES	:= 0 //Entrada/Saida
Local nTotal2ES	:= 0
Local nTotal3ES	:= 0
Local nTotal4ES	:= 0
Local nTotal5ES	:= 0
Local nTotal6ES	:= 0
Local nTotal7ES	:= 0
Local nTotal8ES	:= 0
Local nTotal9ES	:= 0

Local nTotal	:= 0
Local aTotais	:= {}
Local cTipo		:= "ENTRADA"

If lExcel // Excel
	GeraExcel(dData1,dData2)
	//MS_FLUSH()
	Return
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Posicionamento do primeiro registro e loop principal. Pode-se criar ≥
//≥ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ≥
//≥ cessa enquanto a filial do registro for a filial corrente. Por exem ≥
//≥ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ≥
//≥                                                                     ≥
//≥ dbSeek(xFilial())                                                   ≥
//≥ While !EOF() .And. xFilial() == A1_FILIAL                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

/*
Local cTabela2	:= "Movimentos Resumo"
Local cTitulo2	:= "ConciliaÁ„o Movimentos Resumo"
Local cTabela3	:= "TÌtulos"
Local cTitulo3	:= "ConciliaÁ„o TÌtulos"
Local cTabela4	:= "DepreciaÁ„o"
Local cTitulo4	:= "ConciliaÁ„o Ativo por DepreciaÁ„o"
Local cTabela5	:= "AquisiÁ„o"
Local cTitulo5	:= "ConciliaÁ„o Ativo por AquisiÁ„o"
Local cTabela7	:= "Rec. Fin."
Local cTitulo7	:= "Receitas Financeiras"
Local cTabela99	:= "Totais"
Local cTitulo99	:= "Totais ConciliaÁ„o PIS/Cofins"
*/

CalcSFTR(dData1,dData2)

Cabec1	:= "  TIPO    |Cod  |           Vlr |           Vlr |           Vlr |          Base | Aliq |           Vlr |          Base |  Aliq |           Vlr |Sit |   Sit"

Cabec2	:= "    NF    |Fis  |      Contabil |          ICMS |           IPI |           PIS |  PIS |           PIS |        Cofins |Cofins |        Cofins |PIS |Cofins"

nTotal1ES	:= 0
nTotal2ES	:= 0
nTotal3ES	:= 0
nTotal4ES	:= 0
nTotal5ES	:= 0
nTotal6ES	:= 0
nTotal7ES	:= 0
nTotal8ES	:= 0
nTotal9ES	:= 0

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0
nTotal7	:= 0
nTotal8	:= 0
nTotal9	:= 0

Titulo 	:= "ApuraÁ„o PIS e COFINS - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

QUERY->(dbGoTop())
If QUERY->( ! eof() )
	While QUERY->( ! EOF())

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If nLin > 55
			If !lPrim
				Roda(0,"","G")
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
			lPrim:=.F.
		Endif
	/*
	-------- ---- 999.999.999.99 999.999.999.99 99.99 999.999.999.99 999.999.999.99  99.99 999.999.999.99  --    --
	QUERY->TIPO_NF,;
	QUERY->FT_CFOP,;
	QUERY->FT_VALCONT,;
	QUERY->FT_BASEPIS,;
	QUERY->FT_ALIQPIS,;
	QUERY->FT_VALPIS,;
	QUERY->FT_BASECOF,;
	QUERY->FT_ALIQCOF,;
	QUERY->FT_VALCOF,;
	QUERY->FT_CSTPIS,;
	QUERY->FT_CSTCOF })
	*/
		If QUERY->TIPO_NF <> cTipo
			cTipo := QUERY->TIPO_NF

			aadd(aTotais,{nTotal1ES,nTotal2ES,nTotal3ES,nTotal4ES,nTotal5ES,nTotal6ES,nTotal7ES}) //Entradas

			nLin++

			@nLin,000 PSAY Replicate("-",220)

			nLin++

			@nLin,000 PSAY "TOTAL ENTRADA"
			@nLin,016 PSAY "|"
			@nLin,017 PSAY TRANSFORM(aTotais[1][1],"@E 999,999,999.99")
			@nLin,032 PSAY "|"
			@nLin,033 PSAY TRANSFORM(aTotais[1][6],"@E 999,999,999.99")
			@nLin,048 PSAY "|"
			@nLin,049 PSAY TRANSFORM(aTotais[1][7],"@E 999,999,999.99")
			@nLin,064 PSAY "|"
			@nLin,065 PSAY TRANSFORM(aTotais[1][2],"@E 999,999,999.99")
			@nLin,080 PSAY "|"
			@nLin,087 PSAY "|"
			@nLin,088 PSAY TRANSFORM(aTotais[1][3],"@E 999,999,999.99")
			@nLin,104 PSAY "|"
			@nLin,105 PSAY TRANSFORM(aTotais[1][4],"@E 999,999,999.99")
			@nLin,121 PSAY "|"
			@nLin,127 PSAY "|"
			@nLin,128 PSAY TRANSFORM(aTotais[1][5],"@E 999,999,999.99")

			nLin++

			@nLin,000 PSAY Replicate("-",220)

			nLin++
			nLin++

			nTotal1ES	:= 0
			nTotal2ES	:= 0
			nTotal3ES	:= 0
			nTotal4ES	:= 0
			nTotal5ES	:= 0
			nTotal6ES	:= 0
			nTotal7ES	:= 0
			nTotal8ES	:= 0
			nTotal9ES	:= 0

		EndIf

/*
--------   ----  999.999.999.99  999.999.999.99  99.99  999.999.999.99  999.999.999.99   99.99  999.999.999.99  --   --*/

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
	    @nLin,000 PSAY QUERY->TIPO_NF
	    @nLin,010 PSAY "|"
		@nLin,011 PSAY QUERY->FT_CFOP
		@nLin,016 PSAY "|"
		@nLin,017 PSAY TRANSFORM(QUERY->FT_VALCONT,"@E 999,999,999.99")
		@nLin,032 PSAY "|"
		@nLin,033 PSAY TRANSFORM(IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM),"@E 999,999,999.99")
		@nLin,048 PSAY "|"

		@nLin,049 PSAY TRANSFORM(QUERY->FT_VALIPI,"@E 999,999,999.99")
		@nLin,064 PSAY "|"

		@nLin,065 PSAY TRANSFORM(QUERY->FT_BASEPIS,"@E 999,999,999.99")
		@nLin,081 PSAY "|"
		@nLin,082 PSAY TRANSFORM(QUERY->FT_ALIQPIS,"@E 99.99")
		@nLin,087 PSAY "|"
		@nLin,088 PSAY TRANSFORM(QUERY->FT_VALPIS,"@E 999,999,999.99")
		@nLin,104 PSAY "|"
		@nLin,105 PSAY TRANSFORM(QUERY->FT_BASECOF,"@E 999,999,999.99")

		@nLin,121 PSAY "|"
		@nLin,122 PSAY TRANSFORM(QUERY->FT_ALIQCOF,"@E 99.99")
		@nLin,127 PSAY "|"
		@nLin,128 PSAY TRANSFORM(QUERY->FT_VALCOF,"@E 999,999,999.99")
		@nLin,144 PSAY "|"
		@nLin,145 PSAY QUERY->FT_CSTPIS
		@nLin,148 PSAY "|"
		@nLin,149 PSAY QUERY->FT_CSTCOF

		nLin++

		If QUERY->TIPO_NF == "ENTRADAS"
			nTotal1	+= QUERY->FT_VALCONT
			nTotal2	+= QUERY->FT_BASEPIS
			nTotal3	+= QUERY->FT_VALPIS
			nTotal4	+= QUERY->FT_BASECOF
			nTotal5	+= QUERY->FT_VALCOF
			nTotal6	+= IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM)
		Else
			nTotal1	-= QUERY->FT_VALCONT
			nTotal2	-= QUERY->FT_BASEPIS
			nTotal3	-= QUERY->FT_VALPIS
			nTotal4	-= QUERY->FT_BASECOF
			nTotal5	-= QUERY->FT_VALCOF
			nTotal6	-= IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM)

			If QUERY->FT_TIPO = "S"
				nTotal8	+= QUERY->FT_VRETPIS
				nTotal9	+= QUERY->FT_VRETCOF
				nTotal8ES+= QUERY->FT_VRETPIS
				nTotal9ES+= QUERY->FT_VRETCOF
			EndIf

		EndIf

		nTotal1ES	+= QUERY->FT_VALCONT
		nTotal2ES	+= QUERY->FT_BASEPIS
		nTotal3ES	+= QUERY->FT_VALPIS
		nTotal4ES	+= QUERY->FT_BASECOF
		nTotal5ES	+= QUERY->FT_VALCOF
		nTotal6ES	+= IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM)

		QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	aadd(aTotais,{nTotal1ES,nTotal2ES,nTotal3ES,nTotal4ES,nTotal5ES,nTotal6ES,nTotal7ES,nTotal8ES,nTotal9ES}) //Saidas
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9}) //Total de Entradas - Saidas

	nLin++

	@nLin,000 PSAY Replicate("-",220)

	nLin++

	@nLin,000 PSAY "TOTAL SAÕDA"
	@nLin,016 PSAY "|"
	@nLin,017 PSAY TRANSFORM(aTotais[2][1],"@E 999,999,999.99")
	@nLin,032 PSAY "|"
	@nLin,033 PSAY TRANSFORM(aTotais[2][6],"@E 999,999,999.99")
	@nLin,048 PSAY "|"
	@nLin,049 PSAY TRANSFORM(aTotais[1][7],"@E 999,999,999.99")
	@nLin,064 PSAY "|"

	@nLin,065 PSAY TRANSFORM(aTotais[2][2],"@E 999,999,999.99")
	@nLin,080 PSAY "|"
	@nLin,087 PSAY "|"
	@nLin,088 PSAY TRANSFORM(aTotais[2][3],"@E 999,999,999.99")
	@nLin,104 PSAY "|"
	@nLin,105 PSAY TRANSFORM(aTotais[2][4],"@E 999,999,999.99")
	@nLin,121 PSAY "|"
	@nLin,127 PSAY "|"
	@nLin,128 PSAY TRANSFORM(aTotais[2][5],"@E 999,999,999.99")

	nLin++

	@nLin,000 PSAY Replicate("-",220)

	nLin++
	nLin++

    @nLin,000 PSAY IIF(aTotais[3][3] < 0,"TOTAL PAGAR","TOTAL CREDOR")
	@nLin,088 PSAY TRANSFORM(aTotais[3][3],"@E 999,999,999.99")
	@nLin,128 PSAY TRANSFORM(aTotais[3][5],"@E 999,999,999.99")
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0

If cEmpAnt <> "02"

	CalcSE2(dData1,dData2)


	Cabec1	:= "No.          Fornec Loja          Valor Aliq.            Valor  Aliq.          Valor Conta               Descricao"
	Cabec2	:= "Titulo                           Titulo   PIS              PIS Cofins         Cofins Contab              Conta"
	/*
	------------ ------ ---- 999.999.999.99  99.99  999.999.999.99  99.99 999.999.999.99 -------------- ----------------------------------------
	*/

	Titulo 	:= "ConciliaÁ„o TÌtulos - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	nTotal	:= 0
	cTipo	:= ""
	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )
		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif
		/*
	------------ ------ ---- 999.999.999.99  99.99  999.999.999.99  99.99 999.999.999.99 --------------
		*/

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			@nLin,000 PSAY AllTrim(QUERY->E2_NUM)
			@nLin,013 PSAY QUERY->E2_FORNECE
			@nLin,020 PSAY QUERY->E2_LOJA
			@nLin,025 PSAY TRANSFORM(QUERY->VALOR,"@E 999,999,999.99")
			@nLin,041 PSAY QUERY->ALIQPIS
			@nLin,048 PSAY TRANSFORM(QUERY->VALPIS,"@E 999,999,999.99")
			@nLin,064 PSAY QUERY->ALIQCOF
			@nLin,070 PSAY TRANSFORM(QUERY->VALCOF,"@E 999,999,999.99")
			@nLin,085 PSAY AllTrim(QUERY->CONTA)
			@nLin,105 PSAY AllTrim(QUERY->DESC_CONTA)

			nLin++

			nTotal1	+= QUERY->VALOR
			nTotal2	+= QUERY->VALPIS
			nTotal3	+= QUERY->VALCOF

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Titulos

		aadd(aTotCST,{"50",ROUND(nTotal1,2),ROUND(nTotal2,2),ROUND(nTotal3,2),"2"})

		nLin++
		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,025 PSAY TRANSFORM(aTotais[4][1],"@E 999,999,999.99")
		@nLin,048 PSAY TRANSFORM(aTotais[4][2],"@E 999,999,999.99")
		@nLin,070 PSAY TRANSFORM(aTotais[4][3],"@E 999,999,999.99")

	Else
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Titulos
	EndIf

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0

If cEmpAnt <> "02"

	CalcRecFin(dData1,dData2,2)

	Cabec1	:= "Conta               Descricao                                     Valor Aliq.          Valor   Aliq.          Valor   CST   Cod BCC"
	Cabec2	:= "Credito                                                                   PIS            PIS  Cofins         Cofins                "

	/*
	---------------- 999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99
	*/
	Titulo 	:= "Outros CrÈditos - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0
	nTotal4ES	:= 0
	nTotal5ES	:= 0
	nTotal6ES	:= 0

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )

		While ( QUERY->( ! eof() ) )

			If Alltrim(QUERY->CT2_DEBITO) == "110301052" //Pegar a Base pelo Cofins, pois e o % mais alto

				nTotal3 += QUERY->VALCOF / (QUERY->ALIQCOF / 100)

			EndIf

			QUERY->( dbSkip() )

		EndDo

		QUERY->(dbGoTop())

		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			@nLin,000 PSAY AllTrim(QUERY->CT2_DEBITO)
			@nLin,020 PSAY AllTrim(QUERY->CT1_DESC01)
			@nLin,058 PSAY TRANSFORM(nTotal3,"@E 999,999,999.99")
			@nLin,073 PSAY TRANSFORM(QUERY->ALIQPIS,"@E 99.99")
			@nLin,079 PSAY TRANSFORM(QUERY->VALPIS,"@E 999,999,999.99")
			@nLin,096 PSAY TRANSFORM(QUERY->ALIQCOF,"@E 99.99")
			@nLin,102 PSAY TRANSFORM(QUERY->VALCOF,"@E 999,999,999.99")
			@nLin,119 PSAY QUERY->CST
			@nLin,124 PSAY QUERY->CODBCC

			nLin++

			nTotal1	+= QUERY->VALPIS
			nTotal2	+= QUERY->VALCOF

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		aadd(aCT2Outros,{ Round(nTotal1,2),Round(nTotal2,2),Round(nTotal3,2) }) //Total Outros Creditos

		nLin++
		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,079 PSAY TRANSFORM(IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),"@E 999,999,999.99")
		@nLin,102 PSAY TRANSFORM(IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0),"@E 999,999,999.99")

	Else
		aadd(aCT2Outros,{ Round(nTotal1,2),Round(nTotal2,2),Round(nTotal3,2) }) //Total Outros Creditos
	EndIf

EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN109(dData1,dData2)


	Cabec1	:= "Cod.     Item           Base  Aliq.           Valor   Aliq.          Valor Cod."
	Cabec2	:= "do Bem                Calculo   PIS             PIS  Cofins         Cofins BC Cred."
	/*
	-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
	*/
	Titulo 	:= "ConciliaÁ„o Ativo por DepreciaÁ„o - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )
		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif
		/*
		-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
		*/
			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			@nLin,000 PSAY AllTrim(QUERY->N1_CBASE)
			@nLin,009 PSAY AllTrim(QUERY->N1_ITEM)
			@nLin,015 PSAY TRANSFORM(QUERY->N4_VLROC1,"@E 999,999,999.99")
			@nLin,031 PSAY QUERY->N1_ALIQPIS
			@nLin,037 PSAY TRANSFORM(QUERY->VALPIS,"@E 999,999,999.99")
			@nLin,054 PSAY QUERY->N1_ALIQCOF
			@nLin,060 PSAY TRANSFORM(QUERY->VALCOF,"@E 999,999,999.99")
			@nLin,075 PSAY QUERY->N1_CODBCC

			nLin++

			nTotal1	+= QUERY->N4_VLROC1
			nTotal2	+= QUERY->VALPIS
			nTotal3	+= QUERY->VALCOF

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 09

		nLin++
		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,015 PSAY TRANSFORM(aTotais[5][1],"@E 999,999,999.99")
		@nLin,037 PSAY TRANSFORM(aTotais[5][2],"@E 999,999,999.99")
		@nLin,060 PSAY TRANSFORM(aTotais[5][3],"@E 999,999,999.99")
	Else
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 09
	EndIf

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN110A(dData1,dData2)

	Cabec1	:= "Cod.     Item          Base  Aliq.           Valor   Aliq.          Valor Cod."
	Cabec2	:= "do Bem               Calculo   PIS             PIS  Cofins         Cofins BC Cred."

	/*
	-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
	*/
	Titulo 	:= "ConciliaÁ„o Ativo por AquisiÁ„o - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )
		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif
		/*
		-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
		*/

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			@nLin,000 PSAY AllTrim(QUERY->N1_CBASE)
			@nLin,009 PSAY AllTrim(QUERY->N1_ITEM)
			@nLin,015 PSAY TRANSFORM(QUERY->N1_VLAQUIS,"@E 999,999,999.99")
			@nLin,030 PSAY QUERY->N1_ALIQPIS
			@nLin,036 PSAY TRANSFORM(QUERY->VALPIS,"@E 999,999,999.99")
			@nLin,053 PSAY QUERY->N1_ALIQCOF
			@nLin,059 PSAY TRANSFORM(QUERY->VALCOF,"@E 999,999,999.99")
			@nLin,074 PSAY QUERY->N1_CODBCC

			nLin++

			nTotal1	+= Round(QUERY->N1_VLAQUIS,2)
			nTotal2	+= Round(QUERY->VALPIS,2)
			nTotal3	+= Round(QUERY->VALCOF,2)

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 10

		nLin++
		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,015 PSAY TRANSFORM(aTotais[6][1],"@E 999,999,999.99")
		@nLin,036 PSAY TRANSFORM(aTotais[6][2],"@E 999,999,999.99")
		@nLin,059 PSAY TRANSFORM(aTotais[6][3],"@E 999,999,999.99")
	Else
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 09
	EndIf

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN110B(dData1,dData2)

	Cabec1	:= "Cod.     Item          Base  Aliq.           Valor   Aliq.          Valor Cod."
	Cabec2	:= "do Bem               Calculo   PIS             PIS  Cofins         Cofins BC Cred."

	/*
	-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
	*/
	Titulo 	:= "ConciliaÁ„o Ativo por AquisiÁ„o 24X - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )
		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif
		/*
		-------- ---  999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99 --------
		*/

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			@nLin,000 PSAY AllTrim(QUERY->N1_CBASE)
			@nLin,009 PSAY AllTrim(QUERY->N1_ITEM)
			@nLin,015 PSAY TRANSFORM(QUERY->N1_VLAQUIS,"@E 999,999,999.99")
			@nLin,030 PSAY QUERY->N1_ALIQPIS
			@nLin,036 PSAY TRANSFORM(ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2),"@E 999,999,999.99")
			@nLin,053 PSAY QUERY->N1_ALIQCOF
			@nLin,059 PSAY TRANSFORM(ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2),"@E 999,999,999.99")
			@nLin,074 PSAY QUERY->N1_CODBCC

			nLin++

			nTotal1	+= ROUND(QUERY->N1_VLAQUIS,2)
			nTotal2	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2)
			nTotal3	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2)

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 10

		nLin++
		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,015 PSAY TRANSFORM(aTotais[7][1],"@E 999,999,999.99")
		@nLin,036 PSAY TRANSFORM(aTotais[7][2],"@E 999,999,999.99")
		@nLin,059 PSAY TRANSFORM(aTotais[7][3],"@E 999,999,999.99")
	Else
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 09
	EndIf

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nLin := 80

CalcRecFin(dData1,dData2,1)

Cabec1	:= "Conta               Descricao                                     Valor Aliq.          Valor   Aliq.          Valor"
Cabec2	:= "Credito                                                                   PIS            PIS  Cofins         Cofins"

/*
---------------- 999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99
*/
Titulo 	:= "Receitas Financeiras - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0

nTotal1ES	:= 0
nTotal2ES	:= 0
nTotal3ES	:= 0
nTotal4ES	:= 0
nTotal5ES	:= 0
nTotal6ES	:= 0

QUERY->(dbGoTop())

cTipo		:= QUERY->ALIQPIS

If QUERY->( ! eof() )
	While QUERY->( ! EOF())

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If nLin > 55
			If !lPrim
				Roda(0,"","G")
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
			lPrim:=.F.
		Endif
	/*
	---------------- 999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99
	*/
		nPosAliq := aScan(aTotCST,{|x| x[1] == IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02"))})
		If nPosAliq > 0
			aTotCST[nPosAliq][2] += ROUND(QUERY->VALOR,2)
			aTotCST[nPosAliq][3] += ROUND(QUERY->VALPIS,2)
			aTotCST[nPosAliq][4] += ROUND(QUERY->VALCOF,2)
		Else
			aadd(aTotCST,{IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02")),ROUND(QUERY->VALOR,2),ROUND(QUERY->VALPIS,2),ROUND(QUERY->VALCOF,2),"1"})
		EndIf

		nPosAliq := aScan(aGravaCF8,{|x| x[1] == IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02"))})
		If nPosAliq > 0
			aGravaCF8[nPosAliq][3] += ROUND(QUERY->VALOR ,2)
			aGravaCF8[nPosAliq][5] += ROUND(QUERY->VALPIS,2)
			aGravaCF8[nPosAliq][7] += ROUND(QUERY->VALCOF,2)
		Else
			aadd(aGravaCF8,{IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02")),dData2,ROUND(QUERY->VALOR,2),AllTrim(QUERY->ALIQPIS),ROUND(QUERY->VALPIS,2),AllTrim(QUERY->ALIQCOF),ROUND(QUERY->VALCOF,2)})
		EndIf

		If QUERY->ALIQPIS <> cTipo

			nLin++

			@nLin,000 PSAY "TOTAL ALIQ "+cTipo
			@nLin,058 PSAY TRANSFORM(nTotal1ES,"@E 999,999,999.99")
			@nLin,079 PSAY TRANSFORM(nTotal2ES,"@E 999,999,999.99")
			@nLin,102 PSAY TRANSFORM(nTotal3ES,"@E 999,999,999.99")

			nLin++
			nLin++

			cTipo 		:= QUERY->ALIQPIS

			nTotal1ES	:= 0
			nTotal2ES	:= 0
			nTotal3ES	:= 0
			nTotal4ES	:= 0
			nTotal5ES	:= 0
			nTotal6ES	:= 0

		EndIf

		nTotal1ES	+= QUERY->VALOR
		nTotal2ES	+= QUERY->VALPIS
		nTotal3ES	+= QUERY->VALCOF

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
	    @nLin,000 PSAY AllTrim(QUERY->CT2_CREDIT)
	    @nLin,020 PSAY AllTrim(QUERY->CT1_DESC01)
		@nLin,058 PSAY TRANSFORM(QUERY->VALOR,"@E 999,999,999.99")
		@nLin,073 PSAY QUERY->ALIQPIS
		@nLin,079 PSAY TRANSFORM(QUERY->VALPIS,"@E 999,999,999.99")
		@nLin,096 PSAY QUERY->ALIQCOF
		@nLin,102 PSAY TRANSFORM(QUERY->VALCOF,"@E 999,999,999.99")

		nLin++

		nTotal1	+= QUERY->VALOR
		nTotal2	+= QUERY->VALPIS
		nTotal3	+= QUERY->VALCOF

		QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Receitas Financeiras

	nLin++

	@nLin,000 PSAY "TOTAL ALIQ "+cTipo
	@nLin,058 PSAY TRANSFORM(nTotal1ES,"@E 999,999,999.99")
	@nLin,079 PSAY TRANSFORM(nTotal2ES,"@E 999,999,999.99")
	@nLin,102 PSAY TRANSFORM(nTotal3ES,"@E 999,999,999.99")

	nLin++
	nLin++

    @nLin,000 PSAY "TOTAL"
	@nLin,058 PSAY TRANSFORM(aTotais[8][1],"@E 999,999,999.99")
	@nLin,079 PSAY TRANSFORM(aTotais[8][2],"@E 999,999,999.99")
	@nLin,102 PSAY TRANSFORM(aTotais[8][3],"@E 999,999,999.99")

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Receitas Financeiras
EndIf

nLin := 80

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	//CalcEstorno(dData1,dData2)
	CalcOutrosAjustes(dData1,dData2)

/* Trocar a planilha
		oExcel:AddColumn(cTabela10,cTitulo10,"Filial",1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_INDAJU",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_PISCOF",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODAJU",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_NUMDOC",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_DESAJU",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_DTREF",cCampo),1,4)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODIGO",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODCRE",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_TIPATV",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CST",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_BASE",cCampo),1,3)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_ALQ",cCampo),1,2)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_VALAJU",cCampo),1,3)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CONTA",cCampo),1,1)
		oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_TPAJST",cCampo),1,1)

		oExcel:AddRow(cTabela10,cTitulo10,{;
			QUERY->CF5_FILIAL,;
			IIF(AllTrim(QUERY->CF5_INDAJU)=="0","Ajuste de Reducao","Ajuste de Acrescimo"),;	//0=Ajuste de Reducao;1=Ajuste de Acrescimo
			IIF(AllTrim(QUERY->CF5_PISCOF)=="0","Ajuste de PIS","Ajuste de COFINS"),;			//0=Ajuste de PIS;1=Ajuste de COFINS;2=Ajuste de CPRB
			RetCodAju(AllTrim(QUERY->CF5_CODAJU)),;//IIF(AllTrim(QUERY->CF5_CODAJU)=="06","Estorno",QUERY->CF5_CODAJU),;	//01=Acao Judicial;02=Processo Adm.;03=Legislacao Tribu.;04=Especi. do RTT;05=Outras Situacoes;06=Estorno
			QUERY->CF5_NUMDOC,;
			QUERY->CF5_DESAJU,;
			sTod(QUERY->CF5_DTREF),;
			QUERY->CF5_CODIGO,;
			QUERY->CF5_CODCRE,;
			IIF(AllTrim(QUERY->CF5_TIPATV)=="0","Servico","Industria"),;	//0=Servico;1=Industria
			QUERY->CF5_CST,;
			QUERY->CF5_BASE,;
			QUERY->CF5_ALQ,;
			QUERY->CF5_VALAJU,;
			QUERY->CF5_CONTA,;
			IIF(AllTrim(QUERY->CF5_TPAJST)=="1","Credito","Debito")})	//1=CrÈdito;2=DÈbito

*/			
				

	//Cabec1	:= "Emissao    Num.      Cod.   Produto            Quantidade  Prc Tabela      Custo        Total  Aliq.  Aliq.      Estorno      Estorno"
	//Cabec2	:= "           da Nota   Fiscal                                                             Custo    Pis Cofins          Pis       Cofins"

	Cabec1	:= "Fi Ind. Ajuste          Ajuste              Cod. Ajuste         Numero     Descricao do Ajuste            Data      Codigo  Tp  Tp.       CST           Base   Aliquota        Valor  Conta Contabil       Ajuste  "
	Cabec2	:= "lial                                                            Doc.                                      Refe.             CR  Atividade            Calculo                  Ajuste                       Cred/Deb"




	/*
	---------------- 999.999.999.99 99.99 999.999.999.99   99.99 999.999.999.99
	*/
	Titulo 	:= "Estorno Pis Cofins - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0
	nTotal4ES	:= 0
	nTotal5ES	:= 0
	nTotal6ES	:= 0

	QUERY->(dbGoTop())

	If QUERY->( ! eof() )
		While QUERY->( ! EOF())

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Verifica o cancelamento pelo usuario...                             ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Impressao do cabecalho do relatorio. . .                            ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If nLin > 55
				If !lPrim
					Roda(0,"","G")
				EndIf
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
				lPrim:=.F.
			Endif
	/*

	Emissao    Num.      Cod.   Produto            Quantidade  Prc Tabela      Custo        Total  Aliq.  Aliq.      Estorno      Estorno"
			da Nota   Fiscal                                                             Custo    Pis Cofins          Pis       Cofins"
	99/99/9999 999999999 691    F35179020000010000 999.999.99  999.999.99 999.999.99   999.999.99  99.99  99.99   999.999.99   999.999.99
	*/

	/*
Fi Ind. Ajuste          Ajuste              Cod. Ajuste         Numero     Descricao do Ajuste            Data     Codigo Tp  Tp.       CST Base           Aliquota Valor           Conta Contabil        Ajuste de
lial                                                            Doc.                                      Refe.           CR  Atividade     Calculo                 Ajuste                                CrÈdito/DÈbito
	*/

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			/*
			@nLin,000 PSAY dToc(QUERY->D2_EMISSAO)
			@nLin,011 PSAY AllTrim(QUERY->D2_DOC)
			@nLin,021 PSAY AllTrim(QUERY->D2_CF)
			@nLin,028 PSAY AllTrim(QUERY->D2_COD)
			@nLin,047 PSAY TRANSFORM(QUERY->D2_QUANT,"@E 999,999.99")
			@nLin,059 PSAY TRANSFORM(QUERY->D2_PRUNIT,"@E 999,999.99")
			@nLin,071 PSAY TRANSFORM(QUERY->VAL_CUSTO,"@E 999,999.99")
			@nLin,084 PSAY TRANSFORM(ROUND(QUERY->D2_QUANT*QUERY->VAL_CUSTO,2),"@E 999,999.99")
			@nLin,095 PSAY TRANSFORM(QUERY->D2_ALQPIS,"@E 99.99")
			@nLin,102 PSAY TRANSFORM(QUERY->D2_ALQCOF,"@E 99.99")
			@nLin,110 PSAY TRANSFORM(ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQPIS/100),2),"@E 999,999.99")
			@nLin,123 PSAY TRANSFORM(ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQCOF/100),2),"@E 999,999.99")
			*/

			@nLin,000 PSAY AllTrim(QUERY->CF5_FILIAL)	//C 2
			@nLin,003 PSAY IIF(AllTrim(QUERY->CF5_INDAJU)=="0","Ajuste de Reducao","Ajuste de Acrescimo")	//C 1 0=Ajuste de Reducao;1=Ajuste de Acrescimo
			@nLin,024 PSAY IIF(AllTrim(QUERY->CF5_PISCOF)=="0","Ajuste de PIS","Ajuste de COFINS")			//C 1 0=Ajuste de PIS;1=Ajuste de COFINS;2=Ajuste de CPRB
			@nLin,044 PSAY RetCodAju(AllTrim(QUERY->CF5_CODAJU))	//C 2 01=Acao Judicial;02=Processo Adm.;03=Legislacao Tribu.;04=Especi. do RTT;05=Outras Situacoes;06=Estorno
			@nLin,064 PSAY QUERY->CF5_NUMDOC			//C 10
			@nLin,075 PSAY QUERY->CF5_DESAJU			//C 30
			@nLin,106 PSAY dToc(sTod(QUERY->CF5_DTREF))	//D 8 
			@nLin,117 PSAY QUERY->CF5_CODIGO			//C 6
			@nLin,124 PSAY QUERY->CF5_CODCRE			//C 3
			@nLin,128 PSAY IIF(AllTrim(QUERY->CF5_TIPATV)=="0","Servico","Industria")	//C 1 0=Servico;1=Industria
			@nLin,138 PSAY QUERY->CF5_CST				//C 2 
			@nLin,142 PSAY TRANSFORM(ROUND(QUERY->CF5_BASE,2),"@E 999,999,999.99")		//N 14
			@nLin,157 PSAY TRANSFORM(QUERY->CF5_ALQ,"@E 999.99")						//N 7
			@nLin,166 PSAY TRANSFORM(ROUND(QUERY->CF5_VALAJU,2),"@E 999,999,999.99")	//N 14
			@nLin,182 PSAY AllTrim(QUERY->CF5_CONTA)									//C 20
			@nLin,203 PSAY IIF(AllTrim(QUERY->CF5_TPAJST)=="1","Credito","Debito")		//C 1 1=CrÈdito;2=DÈbito

			nLin++
			
			nTotal1	+= ROUND(QUERY->CF5_BASE,2)
			nTotal2	+= ROUND(IIF(AllTrim(QUERY->CF5_PISCOF)=="0",QUERY->CF5_VALAJU,0),2)
			nTotal3	+= ROUND(IIF(AllTrim(QUERY->CF5_PISCOF)=="0",0,QUERY->CF5_VALAJU),2)

			QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo


		/*
		nPosAliq := aScan(aTotCST,{|x| x[1] == "M110/M510"})
		If nPosAliq > 0
			aTotCST[nPosAliq][2] += ROUND(nTotal1,2)
			aTotCST[nPosAliq][3] += ROUND(nTotal2,2)
			aTotCST[nPosAliq][4] += ROUND(nTotal3,2)
		Else
			aadd(aTotCST,{"M110/M510",ROUND(nTotal1,2),ROUND(nTotal2,2),ROUND(nTotal3,2),"1"})
		EndIf

		If Len(aCT2Est) > 0
			aCT2Est[1][5] := nTotal2
			aCT2Est[2][5] := nTotal3
		EndIf
		*/

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Estorno Pis Cofins

		nLin++

		@nLin,000 PSAY "TOTAL"
		@nLin,084 PSAY TRANSFORM(aTotais[9][1],"@E 999,999.99")
		@nLin,110 PSAY TRANSFORM(aTotais[9][2],"@E 999,999.99")
		@nLin,123 PSAY TRANSFORM(aTotais[9][3],"@E 999,999.99")

	Else
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Estorno Pis Cofins
	EndIf

Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

CalcOutrosAjustes(dData1,dData2)

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )

	//Caso encontre registros gravados na CF5, desconsiderar o calculo anterior para pegar somente o historico
	//aTotais[9][2] := 0
	//aTotais[9][3] := 0

	//aTotCF5[1][1] - TOTAL OUTROS DEBITOS
	//aTotCF5[1][2] - TOTAL OUTROS DEBITOS
	//aTotCF5[2][1] - TOTAL ESTORNO SAIDAS
	//aTotCF5[2][2] - TOTAL ESTORNO SAIDAS
	//aTotCF5[3][1] - TOTAL OUTROS CREDITOS
	//aTotCF5[3][2] - TOTAL OUTROS CREDITOS
	//aTotCF5[4][1] - TOTAL ESTORNO ENTRADAS
	//aTotCF5[4][2] - TOTAL ESTORNO ENTRADAS

	While ( QUERY->( ! eof() ) )

		If AllTrim(QUERY->CF5_INDAJU)=="1" .And. AllTrim(QUERY->CF5_TPAJST)<>"1"
			If AllTrim(QUERY->CF5_PISCOF) == "0"
				aTotCF5[1][1] += QUERY->CF5_VALAJU
			Else
				aTotCF5[1][2] += QUERY->CF5_VALAJU
			EndIf
		ElseIf AllTrim(QUERY->CF5_INDAJU)=="0" .And. AllTrim(QUERY->CF5_TPAJST)<>"1"
			If AllTrim(QUERY->CF5_PISCOF) == "0"
				aTotCF5[2][1] += QUERY->CF5_VALAJU
			Else
				aTotCF5[2][2] += QUERY->CF5_VALAJU
			EndIf
		ElseIf AllTrim(QUERY->CF5_INDAJU)=="1" .And. AllTrim(QUERY->CF5_TPAJST)=="1"
			If AllTrim(QUERY->CF5_PISCOF) == "0"
				aTotCF5[3][1] += QUERY->CF5_VALAJU
			Else
				aTotCF5[3][2] += QUERY->CF5_VALAJU
			EndIf
		ElseIf AllTrim(QUERY->CF5_INDAJU)=="0" .And. AllTrim(QUERY->CF5_TPAJST)=="1"
			If AllTrim(QUERY->CF5_PISCOF) == "0"
				aTotCF5[4][1] += QUERY->CF5_VALAJU
			Else
				aTotCF5[4][2] += QUERY->CF5_VALAJU
			EndIf
		EndIf

		QUERY->( dbSkip() )

	EndDo

	//Deixar o valor que est· na planilha, caso nao tenha dados na CF5
	If aTotCF5[4][1] == 0 .And. aTotCF5[4][2] == 0 .And. Len(aCT2Est) > 0
		aTotCF5[4][1] := aCT2Est[1][5]
		aTotCF5[4][2] := aCT2Est[2][5]
	EndIf

Else

	If Len(aCT2Est) > 0
		aTotCF5[4][1] := aCT2Est[1][5]
		aTotCF5[4][2] := aCT2Est[2][5]
	EndIf

EndIf

//Pegar Saldo Credor do mes anterior
CalcSldCredor(MonthSub(dData1,1),MonthSub(dData2,1))

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )
	nTotal1 := QUERY->PIS
	nTotal2 := QUERY->COFINS
EndIf

aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})

nTotal1	:= (aTotais[2][3]+aTotais[8][2]+aTotais[9][2])-(aTotais[1][3]+aTotais[4][2]+aTotais[5][2]+aTotais[6][2]+aTotais[7][2]+aTotais[10][1]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0))
nTotal2	:= (aTotais[2][5]+aTotais[8][3]+aTotais[9][3])-(aTotais[1][5]+aTotais[4][3]+aTotais[5][3]+aTotais[6][3]+aTotais[7][3]+aTotais[10][2]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0))

nTotal1ES	:= 0
nTotal2ES	:= 0

If nTotal1 <= 0
	CalcSldCredor(MonthSub(dData1,1),MonthSub(dData2,1))

	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		nTotal1ES := QUERY->PIS
		nTotal2ES := QUERY->COFINS
	EndIf

	nTotal3 := nTotal1*-1 - nTotal1ES
	nTotal4 := nTotal2*-1 - nTotal2ES
Else
	CalcSldPagar(MonthSub(dData1,1),MonthSub(dData2,1))
	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		While QUERY->( ! eof() )
			If AllTrim(QUERY->CL3_CODREC) == '691201'
				nTotal1ES := QUERY->CL3_VALOR
			EndIf
			If AllTrim(QUERY->CL3_CODREC) == '585601'
				nTotal2ES := QUERY->CL3_VALOR
			EndIf
			QUERY->( dbSkip() )
		EndDo
	EndIf

	nTotal3 := nTotal1 - nTotal1ES
	nTotal4 := nTotal2 - nTotal2ES
EndIf

If nTotal1 <= 0 //Credor
	If (nTotal1*-1) < nTotal1ES
		If nTotal1ES - (nTotal1*-1) >= 0.00 .And. nTotal1ES - (nTotal1*-1) <= 0.10
			nTotal1 		:= (nTotal1ES*-1)
			aTotais[1][3] 	-= nTotal3	//Entradas
		EndIf
	Else
		If (nTotal1*-1) - nTotal1ES >= 0.00 .And. (nTotal1*-1) - nTotal1ES <= 0.10
			nTotal1 		:= (nTotal1ES*-1)
			aTotais[2][3] 	+= nTotal3	//Saidas
		EndIf
	EndIf
	If (nTotal2*-1) < nTotal2ES
		If nTotal2ES - (nTotal2*-1) >= 0.00 .And. nTotal2ES - (nTotal2*-1) <= 0.10
			nTotal2 		:= (nTotal2ES*-1)
			aTotais[1][5] 	-= nTotal4	//Entradas
		EndIf
	Else
		If (nTotal2*-1) - nTotal2ES >= 0.00 .And. (nTotal2*-1) - nTotal2ES <= 0.10
			nTotal2 		:= (nTotal2ES*-1)
			aTotais[2][5] 	+= nTotal4	//Saidas
		EndIf
	EndIf
Else//Pagar
	If nTotal1 < nTotal1ES
		If nTotal1ES - nTotal1 >= 0.00 .And. nTotal1ES - nTotal1 <= 0.10
			nTotal1 		:= nTotal1ES
			aTotais[1][3] 	-= nTotal3	//Entradas
		EndIf
	Else
		If nTotal1 - nTotal1ES >= 0.00 .And. nTotal1 - nTotal1ES <= 0.10
			nTotal1 		:= nTotal1ES
			aTotais[2][3] 	+= nTotal3	//Saidas
		EndIf
	EndIf
	If nTotal2 < nTotal2ES
		If nTotal2ES - nTotal2 >= 0.00 .And. nTotal2ES - nTotal2 <= 0.10
			nTotal2 		:= nTotal2ES
			aTotais[1][5] 	-= nTotal4	//Entradas
		EndIf
	Else
		If nTotal2 - nTotal2ES >= 0.00 .And. nTotal2 - nTotal2ES <= 0.10
			nTotal2 		:= nTotal2ES
			aTotais[2][5] 	+= nTotal4	//Saidas
		EndIf
	EndIf
EndIf

nLin := 80

Cabec1	:= "Tipo                                   Valor               Valor"
Cabec2	:= "                                         PIS              Cofins"

/*
----------------         999.999.999.99 999.999.999.99
*/
Titulo 	:= "Totais ConciliaÁ„o PIS/Cofins  - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )

If nLin > 55
	If !lPrim
		Roda(0,"","G")
	EndIf
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 10
	lPrim:=.F.
Endif

@nLin,000 PSAY "TOTAL SAIDAS"
@nLin,040 PSAY TRANSFORM(aTotais[2][3],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[2][5],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL RECEITAS"
@nLin,040 PSAY TRANSFORM(aTotais[8][2],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[8][3],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL OUTROS DEBITOS"
@nLin,040 PSAY TRANSFORM(aTotCF5[1][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotCF5[1][2],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL ESTORNO DEBITO"
@nLin,040 PSAY TRANSFORM(aTotCF5[2][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotCF5[2][2],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL DEBITOS"
@nLin,040 PSAY TRANSFORM(aTotais[2][3]+aTotais[8][2]+aTotCF5[1][1]-aTotCF5[2][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[2][5]+aTotais[8][3]+aTotCF5[1][2]-aTotCF5[2][2],"@E 999,999,999.99")

nLin++

nLin++

@nLin,000 PSAY "TOTAL ENTRADAS"
@nLin,040 PSAY TRANSFORM(aTotais[1][3],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[1][5],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL OUTROS CREDITOS"
@nLin,040 PSAY TRANSFORM(aTotCF5[3][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotCF5[3][2],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL ESTORNO CREDITO"
@nLin,040 PSAY TRANSFORM(aTotCF5[4][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotCF5[4][2],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL CREDOR MES ANTERIOR"
@nLin,040 PSAY TRANSFORM(aTotais[10][1],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[10][2],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL CRED. EXTEMPORANEO"
@nLin,040 PSAY TRANSFORM(IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0),"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL RETENCOES MES"
@nLin,040 PSAY TRANSFORM(aTotais[2][8],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[2][9],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL TITULOS"
@nLin,040 PSAY TRANSFORM(aTotais[4][2],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[4][3],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL ATIVO DEPRECIACAO"
@nLin,040 PSAY TRANSFORM(aTotais[5][2],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[5][3],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL ATIVO AQUISICAO"
@nLin,040 PSAY TRANSFORM(aTotais[6][2],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[6][3],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL ATIVO AQUISICAO 24X"
@nLin,040 PSAY TRANSFORM(aTotais[7][2],"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[7][3],"@E 999,999,999.99")

nLin++

@nLin,000 PSAY "TOTAL CREDITOS"
@nLin,040 PSAY TRANSFORM(aTotais[1][3]+aTotCF5[3][1]-aTotCF5[4][1]+aTotais[2][8]+aTotais[4][2]+aTotais[5][2]+aTotais[6][2]+aTotais[7][2]+aTotais[10][1]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(aTotais[1][5]+aTotCF5[3][2]-aTotCF5[4][2]+aTotais[2][9]+aTotais[4][3]+aTotais[5][3]+aTotais[6][3]+aTotais[7][3]+aTotais[10][2]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0),"@E 999,999,999.99")

nLin++
nLin++

nTotal1	:=  (ROUND(aTotais[2][3],2)+ROUND(aTotais[8][2],2)+ROUND(aTotCF5[1][1],2)-ROUND(aTotCF5[2][1],2)) ;
			- ;
			(ROUND(aTotais[2][8],2)+ROUND(aTotais[1][3],2)+ROUND(aTotCF5[3][1],2)-ROUND(aTotCF5[4][1],2)+ROUND(aTotais[4][2],2)+ROUND(aTotais[5][2],2)+ROUND(aTotais[6][2],2)+ROUND(aTotais[7][2],2)+ROUND(aTotais[10][1],2)+ROUND(IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),2))

nTotal2	:=  (ROUND(aTotais[2][5],2)+ROUND(aTotais[8][3],2)+ROUND(aTotCF5[1][2],2)-ROUND(aTotCF5[2][2],2)) ;
			- ;
			(ROUND(aTotais[2][9],2)+ROUND(aTotais[1][5],2)+ROUND(aTotCF5[3][2],2)-ROUND(aTotCF5[4][2],2)+ROUND(aTotais[4][3],2)+ROUND(aTotais[5][3],2)+ROUND(aTotais[6][3],2)+ROUND(aTotais[7][3],2)+ROUND(aTotais[10][2],2)+ROUND(IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0),2))

@nLin,000 PSAY IIF(nTotal1 < 0,"TOTAL CREDOR","TOTAL A PAGAR")
@nLin,040 PSAY TRANSFORM(IIF(nTotal1 < 0,nTotal1*-1,nTotal1),"@E 999,999,999.99")
@nLin,060 PSAY TRANSFORM(IIF(nTotal2 < 0,nTotal2*-1,nTotal2),"@E 999,999,999.99")

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Finaliza a execucao do relatorio...                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

SET DEVICE TO SCREEN

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

Return


Static Function CalcSFT(dData1,dData2)
Local cQuery := ""

cQUERY := "SELECT 'ENTRADAS' AS TIPO_NF,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,SUM(FT_VALCONT) AS FT_VALCONT,FT_CODBCC,SUM(FT_BASEPIS) AS FT_BASEPIS,FT_ALIQPIS,SUM(FT_VALPIS) AS FT_VALPIS,SUM(FT_BASECOF) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,SUM(FT_VALCOF-FT_MVALCOF) AS FT_VALCOF,SUM(FT_VALICM) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY += "FROM " + RETSQLNAME("SFT") + " "
cQUERY += "WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY += "AND FT_DTCANC = '' "
cQUERY += "AND FT_CSTPIS <> '' "
cQUERY += "AND FT_TIPOMOV = 'E' "
cQuery +="AND FT_BASEPIS <> 0 "
cQuery +="AND FT_ALIQPIS <> 0 "
cQuery +="AND FT_BASECOF <> 0 "
cQuery +="AND FT_ALIQCOF <> 0 "
cQUERY +="AND D_E_L_E_T_ <> '*' "
cQuery +="AND FT_CSTPIS NOT IN ('70','72','98','99') "
cQUERY +="GROUP BY FT_ENTRADA,FT_FILIAL,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,FT_CODBCC,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="UNION "
//DEVOLUCOES COM BASE DE PIS E COFINS
cQUERY +="SELECT 'SAIDAS' AS TIPO_NF,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,SUM(FT_VALCONT) AS FT_VALCONT,FT_CODBCC,SUM(FT_BASEPIS) AS FT_BASEPIS,FT_ALIQPIS,SUM(FT_VALPIS) AS FT_VALPIS,SUM(FT_BASECOF) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,SUM(FT_VALCOF-FT_MVALCOF) AS FT_VALCOF,SUM(FT_VALICM) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="FROM " + RETSQLNAME("SFT") + " "
cQUERY +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY +="AND FT_DTCANC = '' "
cQUERY +="AND FT_CSTPIS <> '' "
cQUERY +="AND FT_TIPOMOV = 'S' "
cQuery +="AND FT_BASEPIS <> 0 "
cQuery +="AND FT_ALIQPIS <> 0 "
cQuery +="AND FT_BASECOF <> 0 "
cQuery +="AND FT_ALIQCOF <> 0 "
cQUERY +="AND D_E_L_E_T_ <> '*' "
cQUERY +="GROUP BY FT_ENTRADA,FT_FILIAL,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,FT_CODBCC,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="UNION "
//DEVOLUCOES SEM BASE DE PIS E COFINS, BUSCA NA ORIGEM
cQUERY +="SELECT 'SAIDAS' AS TIPO_NF,A.FT_FILIAL,A.FT_ENTRADA,A.FT_EMISSAO,A.FT_NFISCAL,A.FT_SERIE,A.FT_CLIEFOR,A.FT_LOJA,A.FT_CFOP,A.FT_CONTA,SUM(A.FT_TOTAL) AS FT_VALCONT,A.FT_CODBCC,SUM(A.FT_TOTAL) AS FT_BASEPIS,B.FT_ALIQPIS,SUM(ROUND((A.FT_TOTAL*B.FT_ALIQPIS)/100,2)) AS FT_VALPIS,SUM(A.FT_TOTAL) AS FT_BASECOF,(B.FT_ALIQCOF-B.FT_MALQCOF),SUM(ROUND((A.FT_TOTAL*(B.FT_ALIQCOF-B.FT_MALQCOF))/100,2)) AS FT_VALCOF,SUM(A.FT_VALICM) AS FT_VALICM,SUM(A.FT_VALIPI) AS FT_VALIPI,SUM(A.FT_VRETPIS) AS FT_VRETPIS,SUM(A.FT_VRETCOF) AS FT_VRETCOF,A.FT_CSTPIS,A.FT_CSTCOF,A.FT_TIPO "
cQUERY +="FROM " + RETSQLNAME("SFT") + " A "
cQUERY +="INNER JOIN " + RETSQLNAME("SFT") + " B ON B.FT_FILIAL = A.FT_FILIAL AND B.FT_NFISCAL = A.FT_NFORI AND B.FT_SERIE = A.FT_SERORI AND B.FT_ITEM = A.FT_ITEMORI AND B.FT_CLIEFOR = A.FT_CLIEFOR AND B.FT_LOJA = A.FT_LOJA AND B.D_E_L_E_T_ <> '*' "
cQUERY +="WHERE A.FT_ENTRADA >= '"+dTos(dData1)+"' AND A.FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND A.FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY +="AND A.FT_DTCANC = '' "
cQUERY +="AND A.FT_TIPO = 'D' "
cQUERY +="AND A.FT_TIPOMOV = 'S' "
cQUERY +="AND A.FT_BASEPIS = 0 "
cQUERY +="AND A.FT_ALIQPIS = 0 "
cQUERY +="AND A.FT_BASECOF = 0 "
cQUERY +="AND A.FT_ALIQCOF = 0 "
cQUERY +="AND A.FT_CSTPIS = '49' "
cQUERY +="AND A.D_E_L_E_T_ <> '*' "
cQUERY +="GROUP BY A.FT_TIPOMOV,A.FT_FILIAL,A.FT_ENTRADA,A.FT_EMISSAO,A.FT_NFISCAL,A.FT_SERIE,A.FT_CLIEFOR,A.FT_LOJA,A.FT_CFOP,A.FT_CONTA,A.FT_CODBCC,B.FT_ALIQPIS,B.FT_ALIQCOF,B.FT_MALQCOF,A.FT_CSTPIS,A.FT_CSTCOF,A.FT_TIPO "
cQUERY +="UNION "
//ZONA FRANCA MANAUS
cQUERY +="SELECT IIF(FT_TIPOMOV = 'S','SAIDAS','ENTRADAS') AS TIPO_NF,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,SUM(FT_VALCONT) AS FT_VALCONT,FT_CODBCC,SUM(FT_BASEPIS) AS FT_BASEPIS,FT_ALIQPIS,SUM(FT_VALPIS) AS FT_VALPIS,SUM(FT_BASECOF) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,SUM(FT_VALCOF-FT_MVALCOF) AS FT_VALCOF,SUM(IIF(FT_TIPOMOV = 'S',FT_VALICM,0)) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="FROM " + RETSQLNAME("SFT") + " "
cQUERY +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY +="AND FT_DTCANC = '' "
cQUERY +="AND FT_CSTPIS = '06' "
cQUERY +="AND D_E_L_E_T_ <> '*' "
cQUERY +="GROUP BY FT_TIPOMOV,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,FT_CODBCC,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="UNION "
//EXPORTACAO
cQUERY +="SELECT IIF(FT_TIPOMOV = 'S','SAIDAS','ENTRADAS') AS TIPO_NF,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,SUM(FT_VALCONT) AS FT_VALCONT,FT_CODBCC,SUM(FT_BASEPIS) AS FT_BASEPIS,FT_ALIQPIS,SUM(FT_VALPIS) AS FT_VALPIS,SUM(FT_BASECOF) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,SUM(FT_VALCOF-FT_MVALCOF) AS FT_VALCOF,SUM(FT_VALICM) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="FROM " + RETSQLNAME("SFT") + " "
cQUERY +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY +="AND FT_DTCANC = '' "
cQUERY +="AND FT_TIPOMOV = 'S' "
cQUERY +="AND FT_CSTPIS = '08' "
cQUERY +="AND SUBSTRING(FT_CFOP,1,1) = '7' "
cQUERY +="AND D_E_L_E_T_ <> '*' "
cQUERY +="GROUP BY FT_TIPOMOV,FT_FILIAL,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA,FT_CFOP,FT_CONTA,FT_CODBCC,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQUERY +="ORDER BY TIPO_NF,FT_ENTRADA,FT_EMISSAO,FT_NFISCAL,FT_SERIE,FT_CLIEFOR,FT_LOJA"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
TCSetField("QUERY","FT_ENTRADA","D",08,0)
TCSetField("QUERY","FT_EMISSAO","D",08,0)

Return

Static Function CalcSFTR(dData1,dData2)
Local cQuery := ""

cQuery :="SELECT 'ENTRADAS' AS TIPO_NF,FT_FILIAL,FT_CFOP,ROUND(SUM(FT_VALCONT),2) AS FT_VALCONT,ROUND(SUM(FT_BASEPIS),2) AS FT_BASEPIS,FT_ALIQPIS,ROUND(SUM(FT_VALPIS),2) AS FT_VALPIS,ROUND(SUM(FT_BASECOF),2) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,ROUND(SUM(FT_VALCOF-FT_MVALCOF),2) AS FT_VALCOF,SUM(FT_VALICM) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="FROM " + RETSQLNAME("SFT") + " "
cQuery +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQuery +="AND FT_DTCANC = '' "
cQUERY +="AND FT_CSTPIS <> '' "
cQuery +="AND FT_TIPOMOV = 'E' "
cQuery +="AND FT_BASEPIS <> 0 "
cQuery +="AND FT_ALIQPIS <> 0 "
cQuery +="AND FT_BASECOF <> 0 "
cQuery +="AND FT_ALIQCOF <> 0 "
cQuery +="AND FT_CSTPIS NOT IN ('70','72','98','99') "
cQuery +="AND D_E_L_E_T_ <> '*' "
cQuery +="GROUP BY FT_FILIAL,FT_CFOP,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="UNION "
//DEVOLUCOES COM BASE DE PIS E COFINS
cQuery +="SELECT 'SAIDAS' AS TIPO_NF,FT_FILIAL,FT_CFOP,ROUND(SUM(FT_VALCONT),2) AS FT_VALCONT,ROUND(SUM(FT_BASEPIS),2) AS FT_BASEPIS,FT_ALIQPIS,ROUND(SUM(FT_VALPIS),2) AS FT_VALPIS,ROUND(SUM(FT_BASECOF),2) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,ROUND(SUM(FT_VALCOF-FT_MVALCOF),2) AS FT_VALCOF,SUM(FT_VALICM) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="FROM " + RETSQLNAME("SFT") + " "
cQuery +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQuery +="AND FT_DTCANC  = '' "
cQuery +="AND FT_CSTPIS <> '' "
cQuery +="AND FT_TIPOMOV = 'S' "
cQuery +="AND FT_BASEPIS <> 0 "
cQuery +="AND FT_ALIQPIS <> 0 "
cQuery +="AND FT_BASECOF <> 0 "
cQuery +="AND FT_ALIQCOF <> 0 "
cQuery +="AND D_E_L_E_T_ <> '*' "
cQuery +="GROUP BY FT_FILIAL,FT_CFOP,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="UNION "
//DEVOLUCOES SEM BASE DE PIS E COFINS, BUSCA NA ORIGEM
cQUERY +="SELECT 'SAIDAS' AS TIPO_NF,A.FT_FILIAL,A.FT_CFOP,SUM(A.FT_TOTAL) AS FT_VALCONT,SUM(A.FT_TOTAL) AS FT_BASEPIS,B.FT_ALIQPIS,SUM(ROUND((A.FT_TOTAL*B.FT_ALIQPIS)/100,2)) AS FT_VALPIS,SUM(A.FT_TOTAL) AS FT_BASECOF,(B.FT_ALIQCOF-B.FT_MALQCOF) AS FT_ALIQCOF,SUM(ROUND((A.FT_TOTAL*(B.FT_ALIQCOF-B.FT_MALQCOF))/100,2)) AS FT_VALCOF,SUM(A.FT_VALICM) AS FT_VALICM,SUM(A.FT_VALIPI) AS FT_VALIPI,SUM(A.FT_VRETPIS) AS FT_VRETPIS,SUM(A.FT_VRETCOF) AS FT_VRETCOF,A.FT_CSTPIS,A.FT_CSTCOF,A.FT_TIPO "
cQUERY +="FROM " + RETSQLNAME("SFT") + " A "
cQUERY +="INNER JOIN " + RETSQLNAME("SFT") + " B ON B.FT_FILIAL = A.FT_FILIAL AND B.FT_NFISCAL = A.FT_NFORI AND B.FT_SERIE = A.FT_SERORI AND B.FT_ITEM = A.FT_ITEMORI AND B.FT_CLIEFOR = A.FT_CLIEFOR AND B.FT_LOJA = A.FT_LOJA AND B.D_E_L_E_T_ <> '*' "
cQUERY +="WHERE A.FT_ENTRADA >= '"+dTos(dData1)+"' AND A.FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND A.FT_FILIAL = '"+cOpc+"' "
EndIf
cQUERY +="AND A.FT_DTCANC = '' "
cQUERY +="AND A.FT_TIPO = 'D' "
cQUERY +="AND A.FT_TIPOMOV = 'S' "
cQUERY +="AND A.FT_BASEPIS = 0 "
cQUERY +="AND A.FT_ALIQPIS = 0 "
cQUERY +="AND A.FT_BASECOF = 0 "
cQUERY +="AND A.FT_ALIQCOF = 0 "
cQUERY +="AND A.FT_CSTPIS = '49' "
cQUERY +="AND A.D_E_L_E_T_ <> '*' "
cQUERY +="GROUP BY A.FT_FILIAL,A.FT_CFOP,B.FT_ALIQPIS,B.FT_ALIQCOF,B.FT_MALQCOF,A.FT_CSTPIS,A.FT_CSTCOF,A.FT_TIPO "
cQUERY +="UNION "
//ZONA FRANCA MANAUS
cQuery +="SELECT IIF(FT_TIPOMOV = 'S','SAIDAS','ENTRADAS') AS TIPO_NF,FT_FILIAL,FT_CFOP,ROUND(SUM(FT_VALCONT),2) AS FT_VALCONT,ROUND(SUM(FT_BASEPIS),2) AS FT_BASEPIS,FT_ALIQPIS,ROUND(SUM(FT_VALPIS),2) AS FT_VALPIS,ROUND(SUM(FT_BASECOF),2) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,ROUND(SUM(FT_VALCOF-FT_MVALCOF),2) AS FT_VALCOF,SUM(IIF(FT_TIPOMOV = 'S',FT_VALICM,0)) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="FROM " + RETSQLNAME("SFT") + " "
cQuery +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQuery +="AND FT_DTCANC = '' "
cQuery +="AND FT_CSTPIS = '06' "
cQuery +="AND D_E_L_E_T_ = '' "
cQuery +="GROUP BY FT_TIPOMOV,FT_FILIAL,FT_CFOP,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="UNION "
//EXPORTACAO
cQuery +="SELECT IIF(FT_TIPOMOV = 'S','SAIDAS','ENTRADAS') AS TIPO_NF,FT_FILIAL,FT_CFOP,ROUND(SUM(FT_VALCONT),2) AS FT_VALCONT,ROUND(SUM(FT_BASEPIS),2) AS FT_BASEPIS,FT_ALIQPIS,ROUND(SUM(FT_VALPIS),2) AS FT_VALPIS,ROUND(SUM(FT_BASECOF),2) AS FT_BASECOF,(FT_ALIQCOF-FT_MALQCOF) AS FT_ALIQCOF,ROUND(SUM(FT_VALCOF-FT_MVALCOF),2) AS FT_VALCOF,SUM(IIF(FT_TIPOMOV = 'S',FT_VALICM,0)) AS FT_VALICM,SUM(FT_VALIPI) AS FT_VALIPI,SUM(FT_VRETPIS) AS FT_VRETPIS,SUM(FT_VRETCOF) AS FT_VRETCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="FROM " + RETSQLNAME("SFT") + " "
cQuery +="WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND FT_FILIAL = '"+cOpc+"' "
EndIf
cQuery +="AND FT_DTCANC = '' "
cQuery +="AND FT_TIPOMOV = 'S' "
cQuery +="AND FT_CSTPIS = '08' "
cQuery +="AND SUBSTRING(FT_CFOP,1,1) = '7' "
cQuery +="AND D_E_L_E_T_ = '' "
cQuery +="GROUP BY FT_TIPOMOV,FT_FILIAL,FT_CFOP,FT_ALIQPIS,FT_ALIQCOF,FT_MALQCOF,FT_CSTPIS,FT_CSTCOF,FT_TIPO "
cQuery +="ORDER BY FT_CFOP,FT_CSTPIS"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcSE2(dData1,dData2)
Local cQuery := ""

cQuery := "SELECT E2_FILORIG,E2_NUM, E2_FORNECE, E2_LOJA, E2_NOMFOR,E2_CCD AS CCUSTO,E2_DEBITO AS CONTA, CT1_DESC01 AS DESC_CONTA, E2_VALOR AS VALOR, ED_PCAPPIS AS ALIQPIS, ROUND(E2_VALOR*0.0165,2) AS VALPIS,ED_PCAPCOF AS ALIQCOF , ROUND(E2_VALOR*0.0760,2) AS VALCOF "
cQuery += "FROM " + RETSQLNAME("SE2") + " E2 "
cQuery += "INNER JOIN " + RETSQLNAME("SED") + " ED  ON  ED_FILIAL = '"+xFilial("SED")+"' AND ED_PCAPPIS <> 0 AND ED_PCAPCOF <> 0 AND ED_APURPIS = 'C' AND ED_APURCOF = 'C' AND ED_CODIGO = E2_NATUREZ AND ED.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN " + RETSQLNAME("CT1") + " CT1 ON  CT1_FILIAL = '"+xFilial("CT1")+"' AND CT1_CONTA = E2_DEBITO AND CT1.D_E_L_E_T_ <> '*' "
cQuery += "WHERE E2_EMIS1 BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
cQuery += "AND E2_FILIAL = '"+xFilial("SE2")+"' "
If cOpc <> "T"
	cQUERY += "AND E2_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "AND E2_ORIGEM <> 'MATA100' "
cQuery += "AND E2_MULTNAT = '2' "
cQuery += "AND E2.D_E_L_E_T_ = '' "
cQuery += "UNION "
cQuery += "SELECT E2_FILORIG,E2_NUM, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_CCD AS CCUSTO, EV_CONTA AS CONTA, CT1_DESC01 AS DESC_CONTA, EV_VALOR AS VALOR, ED_PCAPPIS AS ALIQPIS, ROUND(EV_VALOR*(ED_PCAPPIS/100),2) AS VALPIS, ED_PCAPCOF AS ALIQCOF, ROUND(EV_VALOR*(ED_PCAPCOF/100),2) AS VALCOF "
cQuery += "FROM " + RETSQLNAME("SEV") + " EV "
cQuery += "INNER JOIN " + RETSQLNAME("SED") + " ED  ON ED_FILIAL = '"+xFilial("SED")+"' AND ED_PCAPPIS <> 0 AND ED_PCAPCOF <> 0 AND ED_APURPIS = 'C' AND ED_APURCOF = 'C' AND ED_CODIGO = EV_NATUREZ AND ED.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN " + RETSQLNAME("SE2") + " E2  ON EV_FILIAL = E2_FILIAL "
If cOpc <> "T"
	cQUERY += "AND E2_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "AND EV_NUM = E2_NUM AND EV_PREFIXO = E2_PREFIXO AND EV_CLIFOR = E2_FORNECE AND EV_LOJA = E2_LOJA AND EV_TIPO = E2_TIPO AND E2_MULTNAT = '1' AND E2_ORIGEM <> 'MATA100' AND E2_EMIS1 BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' AND E2.D_E_L_E_T_   = '' "  // Incluido a validaÁ„o de codigo de fornecedor e loja Marcelo Mcs 01-02-2023
cQuery += "INNER JOIN " + RETSQLNAME("CT1") + " CT1 ON CT1_FILIAL = '"+xFilial("CT1")+"' AND CT1_CONTA = EV_CONTA AND CT1.D_E_L_E_T_ <> '*' "
cQuery += "WHERE EV.D_E_L_E_T_ = '' "
cQuery += "AND EV_FILIAL = '"+xFilial("SEV")+"' "
cQuery += "AND EV_RATEICC = '2' "
cQuery += "UNION "
cQuery += "SELECT E2_FILORIG,E2_NUM, E2_FORNECE, E2_LOJA, E2_NOMFOR,EZ_CCUSTO AS CCUSTO,EZ_CONTA AS CONTA, CT1_DESC01 AS DESC_CONTA, EZ_VALOR AS VALOR,ED_PCAPPIS AS ALIQPIS, ROUND(EZ_VALOR*(ED_PCAPPIS/100),2) AS VALPIS,ED_PCAPCOF AS ALIQCOF, ROUND(EZ_VALOR*(ED_PCAPCOF/100),2) AS VALCOF "
cQuery += "FROM " + RETSQLNAME("SEV") + " EV "
cQuery += "INNER JOIN " + RETSQLNAME("SED") + " ED  ON ED_FILIAL = '"+xFilial("SED")+"' AND ED_PCAPPIS <> 0 AND ED_PCAPCOF <> 0 AND ED_APURPIS = 'C' AND ED_APURCOF = 'C' AND ED_CODIGO = EV_NATUREZ AND ED.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN " + RETSQLNAME("SE2") + " E2  ON EV_FILIAL = E2_FILIAL "
If cOpc <> "T"
	cQUERY += "AND E2_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "AND EV_NUM = E2_NUM AND EV_PREFIXO = E2_PREFIXO AND EV_CLIFOR = E2_FORNECE AND EV_LOJA = E2_LOJA AND EV_TIPO = E2_TIPO AND E2_MULTNAT = '1' AND E2_ORIGEM <> 'MATA100' AND E2_EMIS1 BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' AND E2.D_E_L_E_T_   = '' " // Incluido a validaÁ„o de codigo de fornecedor e loja Marcelo Mcs 01-02-2023
cQuery += "INNER JOIN " + RETSQLNAME("SEZ") + " EZ  ON EZ_FILIAL = E2_FILIAL AND EZ_NUM = E2_NUM AND EZ_PREFIXO = E2_PREFIXO AND EZ_CLIFOR = E2_FORNECE AND EZ_LOJA = E2_LOJA AND EZ_TIPO = E2_TIPO AND EZ_NATUREZ = ED_CODIGO AND EZ.D_E_L_E_T_   = '' "  // Incluido a validaÁ„o de codigo de fornecedor e loja Marcelo Mcs 01-02-2023
cQuery += "INNER JOIN " + RETSQLNAME("CT1") + " CT1 ON CT1_FILIAL = '"+xFilial("CT1")+"' AND CT1_CONTA = EZ_CONTA AND CT1.D_E_L_E_T_ <> '*' "
cQuery += "WHERE EV.D_E_L_E_T_ = '' "
cQuery += "AND EV_FILIAL = '"+xFilial("SEV")+"' "
cQuery += "AND EV_RATEICC = '1' "
cQuery += "ORDER BY CONTA, CCUSTO, E2_FORNECE, E2_LOJA, E2_NUM"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcSN109(dData1,dData2)
Local cQuery := ""

cQuery := "SELECT N1_CBASE,N1_ITEM,N4_VLROC1,N1_ALIQPIS,N4_VLROC1*(N1_ALIQPIS/100) AS VALPIS,N1_ALIQCOF,N4_VLROC1*(N1_ALIQCOF/100) AS VALCOF,N1_CODBCC,N1_CSTPIS,N1_CSTCOFI,N3_CCONTAB,N3_FILORIG "
cQuery += "FROM " + RETSQLNAME("SN4") + " N4 "
cQuery += "INNER JOIN " + RETSQLNAME("SN1") + " N1 ON N4_FILIAL = N1_FILIAL "
cQuery += "     AND N4_CBASE = N1_CBASE "
cQuery += "     AND N4_ITEM  = N1_ITEM "
cQuery += "INNER JOIN " + RETSQLNAME("SN3") + " N3 ON N3_FILIAL = N4_FILIAL "
cQuery += "		AND N4_CBASE = N3_CBASE "
cQuery += "     AND N4_ITEM  = N3_ITEM "
cQuery += "	 	AND N3_TIPO = '01' "
If cOpc <> "T"
	cQUERY += " AND N3_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "WHERE N4.D_E_L_E_T_ = '' "
cQuery += "AND N1.D_E_L_E_T_ = '' "
cQuery += "AND N3.D_E_L_E_T_ = '' "
cQuery += "AND N4_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
cQuery += "AND N4_TIPOCNT = '4' "
cQuery += "AND N4_TIPO = '01' "
cQuery += "AND N1_CODBCC = '09' "
cQuery += "AND N4_OCORR = '06' " //--6 DepreciaÁ„o
cQuery += "ORDER BY N3_CCONTAB,N1_CBASE,N1_ITEM"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcSN110A(dData1,dData2)
Local cQuery := ""

cQuery := "SELECT N1_CBASE,N1_ITEM,N1_VLAQUIS,N1_ALIQPIS,(N1_VLAQUIS*N1_ALIQPIS/100) AS VALPIS,N1_ALIQCOF,N1_VLAQUIS*(N1_ALIQCOF/100) AS VALCOF,N1_CODBCC,N1_CSTPIS,N1_CSTCOFI,N3_CCONTAB,N3_FILORIG "
cQuery += "FROM " + RETSQLNAME("SN1") + " N1 "
cQuery += "INNER JOIN " + RETSQLNAME("SN3") + " N3 ON N3_FILIAL = N1_FILIAL "
cQuery += "     AND N1_CBASE = N3_CBASE "
cQuery += "     AND N1_ITEM  = N3_ITEM "
cQuery += "		AND N3_TIPO = '01' "
cQuery += "		AND N3_DTBAIXA = '' "
If cOpc <> "T"
	cQUERY += " AND N3_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "WHERE N1.D_E_L_E_T_ = '' "
cQuery += "AND N3.D_E_L_E_T_ = '' "
cQuery += "AND N1_AQUISIC BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
cQuery += "AND N1_CODBCC = '10' "
cQuery += "AND N1_MESCPIS = 0 "
cQuery += "AND N1_VLAQUIS > 0 "
cQuery += "ORDER BY N3_CCONTAB,N1_CBASE,N1_ITEM"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcSN110B(dData1,dData2)
Local cQuery := ""
//*(DATEDIFF(month,N3_DINDEPR,'"+dTos(dData2)+"')+1)
cQuery := "SELECT N1_CBASE,N1_ITEM,(N1_VLAQUIS/24) AS N1_VLAQUIS,N1_ALIQPIS,0 AS VALPIS,N1_ALIQCOF,0 AS VALCOF,N1_CODBCC,N1_CSTPIS,N1_CSTCOFI,N3_CCONTAB,N3_FILORIG,DATEDIFF(month,N3_DINDEPR,'"+dTos(dData2)+"')+1 AS MESCOUNT "
cQuery += "FROM " + RETSQLNAME("SN1") + " N1 "
cQuery += "INNER JOIN " + RETSQLNAME("SN3") + " N3 ON N3_FILIAL = N1_FILIAL "
cQuery += "     AND N1_CBASE = N3_CBASE "
cQuery += "     AND N1_ITEM  = N3_ITEM "
cQuery += "		AND N3_TIPO = '01' "
cQuery += "		AND N3_DTBAIXA = '' "
If cOpc <> "T"
	cQUERY += " AND N3_FILORIG = '"+cOpc+"' "
EndIf
cQuery += "WHERE N1.D_E_L_E_T_ = '' "
cQuery += "AND N3.D_E_L_E_T_ = '' "
cQuery += "AND (DATEDIFF(month,N3_DINDEPR,'"+dTos(dData2)+"')+1) <= 24 "
cQuery += "AND N1_CODBCC = '10' "
cQuery += "AND N1_MESCPIS = 24 "
cQuery += "AND N1_VLAQUIS > 0 "
cQuery += "ORDER BY N3_CCONTAB,N1_CBASE,N1_ITEM"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcRecFin(dData1,dData2,nOpc)
Local cQuery := ""

Default nOpc := 1

If nOpc == 1

	If cEmpAnt == "01"

		cQuery := "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '0.65' as ALIQPIS,ROUND(SUM(CT2_VALOR)*0.0065,2) as VALPIS,'4.00' AS ALIQCOF , ROUND(SUM(CT2_VALOR)*0.04,2) as VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf		
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('320104001','320104004','320104005','320104007','320104010','320104019','320104020','320104015','320104018','320104021') "
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01 "
		cQuery += "UNION "
		cQuery += "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '1.65' as ALIQPIS,ROUND(SUM(CT2_VALOR)*0.0165,2) as VALPIS,'7.60' AS ALIQCOF , ROUND(SUM(CT2_VALOR)*0.076,2) as VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf				
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('310101001007','320106007','330101001') " //110601014 retirado a conta contabil da regra
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01 "
		cQuery += "UNION "
		cQuery += "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '0' as ALIQPIS, 0 as VALPIS, '0' AS ALIQCOF, 0 AS VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf				
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('320104006','320106002') "
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01 "
		cQuery += "ORDER BY ALIQPIS,CT2_CREDIT"

	ElseIf cEmpAnt == "02"

		cQuery := "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '0' as ALIQPIS, 0 as VALPIS, '0' AS ALIQCOF , 0 as VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf				
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('320104001','320104004','320104005') "
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01 "
		cQuery += "UNION "
		cQuery += "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '0.65' as ALIQPIS, ROUND(SUM(CT2_VALOR)*0.0065,2) as VALPIS, '3.00' AS ALIQCOF, ROUND(SUM(CT2_VALOR)*0.03,2) as VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf				
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('330101001') "
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01 "

	ElseIf cEmpAnt == "03"

		cQuery := "SELECT CT2_FILORI,CT2_CREDIT,CT1_DESC01,SUM(CT2_VALOR) AS VALOR, '0.65' as ALIQPIS,ROUND(SUM(CT2_VALOR)*0.0065,2) as VALPIS,'4.00' AS ALIQCOF, ROUND(SUM(CT2_VALOR)*0.04,2) as VALCOF "
		cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
		cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
		If cOpc <> "T"
			cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
		EndIf				
		cQuery += "AND CT1.D_E_L_E_T_ = '' "
		cQuery += "AND CT2.CT2_CREDIT = CT1.CT1_CONTA "
		cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
		cQuery += "AND CT2.CT2_CREDIT IN ('3214002','3214003') "
		cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_CREDIT,CT1.CT1_DESC01"

	EndIf

ElseIf nOpc == 2

	cQuery := "SELECT CT2_FILORI,CT2_DEBITO,CT1_DESC01, "
	cQuery += "1.65 AS ALIQPIS, "
	cQuery += "IIF(CT2_DEBITO='110301051',ROUND(SUM(CT2_VALOR),2),0) AS VALPIS, "
	cQuery += "7.60 AS ALIQCOF , "
	cQuery += "IIF(CT2_DEBITO='110301052',ROUND(SUM(CT2_VALOR),2),0) AS VALCOF, "
	cQuery += "'50' AS CST, "
	cQuery += "'13' AS CODBCC "
	cQuery += "FROM " + RETSQLNAME("CT2") + " CT2, " + RETSQLNAME("CT1") + " CT1 "
	cQuery += "WHERE CT2.D_E_L_E_T_ = '' "
	If cOpc <> "T"
		cQUERY += " AND CT2.CT2_FILORI = '"+cOpc+"' "
	EndIf		
	cQuery += "AND CT1.D_E_L_E_T_ = '' "
	cQuery += "AND CT2.CT2_DEBITO = CT1.CT1_CONTA "
	cQuery += "AND CT2.CT2_DATA BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
	cQuery += "AND CT2.CT2_DEBITO IN ('110301051','110301052') "
	cQuery += "GROUP BY CT2.CT2_FILORI,CT2.CT2_DEBITO,CT1.CT1_DESC01 "
	cQuery += "ORDER BY 1,2"

EndIf

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function CalcEstorno(dData1,dData2)

cQuery := "SELECT D2_FILIAL,D2_EMISSAO,D2_DOC,D2_CF,D2_COD,B1_DESC,B1_TIPO,D2_QUANT,D2_PRUNIT, "
cQuery += "ISNULL((SELECT ZZY_CMATPR FROM " + RETSQLNAME("ZZY") + " ZZY WHERE ZZY_COD = D2_COD AND ZZY.D_E_L_E_T_ = ''),0) AS VAL_CUSTO, "
cQuery += "D2_ALQPIS,D2_ALQCOF "
//cQuery += "ROUND((ISNULL((SELECT ZZY_CMATPR FROM ZZY010 WHERE ZZY_COD = D2_COD AND D_E_L_E_T_ = ''),0)*D2_QUANT)*(D2_ALQPIS/100),2) AS EST_PIS, "
//cQuery += "ROUND((ISNULL((SELECT ZZY_CMATPR FROM ZZY010 WHERE ZZY_COD = D2_COD AND D_E_L_E_T_ = ''),0)*D2_QUANT)*(D2_ALQCOF/100),2) AS EST_COFINS "
cQuery += "FROM " + RETSQLNAME("SD2") + " D2 "
cQuery += "INNER JOIN " + RETSQLNAME("SB1") + " B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = D2_COD AND B1.D_E_L_E_T_ = '' "		
cQuery += "WHERE D2_EMISSAO BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND D2_FILIAL = '"+cOpc+"' "
EndIf
cQuery += "AND D2_CF IN ('5910','6910') "
cQuery += "AND D2_DOC IN (SELECT MAX(F3_NFISCAL) FROM " + RETSQLNAME("SF3") + " F3 WHERE D2_FILIAL = F3_FILIAL "
cQuery += "AND D2_DOC = F3_NFISCAL "
cQuery += "AND D2_SERIE = F3_SERIE "
cQuery += "AND D2_CLIENTE = F3_CLIEFOR "
cQuery += "AND D2_LOJA = F3_LOJA "
cQuery += "AND F3_DTCANC = '' "
cQuery += "AND F3.D_E_L_E_T_ = '') "
cQuery += "AND D2.D_E_L_E_T_ = '' "
cQuery += "ORDER BY D2_DOC"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
TCSetField("QUERY","D2_EMISSAO","D",08,0)

Return

Static Function CalcOutrosAjustes(dData1,dData2)

cQuery := "SELECT CF5_FILIAL,CF5_INDAJU,CF5_PISCOF,CF5_VALAJU,CF5_CODAJU,CF5_NUMDOC,CF5_DESAJU,CF5_DTREF,CF5_CODIGO,CF5_CODCRE,CF5_TIPATV,CF5_CST,CF5_BASE,CF5_ALQ,CF5_CONTA,CF5_TPAJST "
cQuery += "FROM " + RETSQLNAME("CF5") + " CF5 "
cQuery += "WHERE CF5_DTREF BETWEEN '"+dTos(dData1)+"' AND '"+dTos(dData2)+"' "
If cOpc <> "T"
	cQUERY += "AND CF5_FILIAL = '"+cOpc+"' "
EndIf
cQuery += "AND CF5_NUMDOC <> ' ' "
cQuery += "AND CF5.D_E_L_E_T_ = '' "
cQuery += "ORDER BY CF5_NUMDOC"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
//TCSetField("QUERY","D2_EMISSAO","D",08,0)

Return

/*
Static Function CalcCSTSFT(dData1,dData2)
Local cQuery := ""

cQUERY := "SELECT FT_CSTPIS,FT_TIPOMOV,SUM(FT_VALCONT) AS FT_VALCONT,SUM(FT_BASEPIS) AS FT_BASEPIS,SUM(FT_BASECOF) AS FT_BASECOF,SUM(FT_VALPIS) AS FT_VALPIS,SUM(FT_VALCOF) AS FT_VALCOF "
cQUERY += "FROM " + RETSQLNAME("SFT") + " FT "
cQUERY += "WHERE FT_ENTRADA >= '"+dTos(dData1)+"' AND FT_ENTRADA <= '"+dTos(dData2)+"' "
cQUERY += "AND FT_FILIAL = '"+xFilial("SFT")+"' "
cQUERY += "AND FT_BASEPIS <> 0 "
cQUERY += "AND FT_ALIQPIS <> 0 "
cQUERY += "AND FT_BASECOF <> 0 "
cQUERY += "AND FT_ALIQCOF <> 0 "
cQUERY += "AND FT_CSTPIS NOT IN ('70','72','98','99') "
cQUERY += "AND FT_CSTPIS <> '' "
cQUERY += "AND FT_DTCANC = '' "
cQUERY += "AND (FT_VALPIS <> 0 AND FT_VALCOF <> 0)"
cQUERY += "AND D_E_L_E_T_ = '' "
cQUERY += "GROUP BY FT_CSTPIS,FT_TIPOMOV "
cQUERY += "ORDER BY FT_CSTPIS,FT_TIPOMOV "

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
//TCSetField("QUERY","FT_ENTRADA","D",08,0)
//TCSetField("QUERY","FT_EMISSAO","D",08,0)

Return
*/

Static Function CalcSldCredor(dData1,dData2)
Local cQuery := ""

cQUERY := "SELECT "
cQUERY += " (SELECT SUM(CCY_CRDISP) "
cQUERY += "  FROM " + RETSQLNAME("CCY") + " CCY "
cQUERY += "  WHERE CCY.D_E_L_E_T_ = '' "
cQUERY += "  AND CCY_PERIOD = '" + StrZero(Month(dData1),2) + Alltrim(Str(Year(dData1))) + "' "
cQUERY += "  AND CCY_FILIAL = '" + xFilial("CCY") + "') AS PIS, "
cQUERY += "  (SELECT SUM(CCW_CRDISP) "
cQUERY += "  FROM " + RETSQLNAME("CCW") + " CCW "
cQUERY += "  WHERE CCW.D_E_L_E_T_ = '' "
cQUERY += "  AND CCW_PERIOD = '" + StrZero(Month(dData1),2) + Alltrim(Str(Year(dData1))) + "' "
cQUERY += "  AND CCW_FILIAL = '" + xFilial("CCW") + "') AS COFINS "
cQUERY += "WHERE 1 = 1"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
//TCSetField("QUERY","FT_ENTRADA","D",08,0)
//TCSetField("QUERY","FT_EMISSAO","D",08,0)

Return

Static Function CalcSldPagar(dData1,dData2)
Local cQuery := ""

cQUERY := "SELECT CL3_TRIB,CL3_CODREC,CL3_VALOR "
cQUERY += "FROM " + RETSQLNAME("CL3") + " CL3 "
cQUERY += "WHERE SUBSTRING(CL3_PER,1,6) = '" + SubStr(dTos(dData1),1,6) + "' "
cQUERY += "AND CL3.D_E_L_E_T_ = '' "
cQUERY += "AND CL3_FILIAL = '" + xFilial("CL3") + "' "
cQUERY += "AND (CL3_CODREC = '691201' OR CL3_CODREC = '585601')"

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

Return

Static Function GeraExcel()
Local oExcel 	:= FWMSEXCEL():New()
Local cTabela1	:= "Movimentos"
Local cTitulo1	:= "ConciliaÁ„o Movimentos"
Local cTabela2	:= "Movimentos Resumo"
Local cTitulo2	:= "ApuraÁ„o PIS e COFINS - PerÌodo de ApuraÁ„o " + dToc( dData1 ) + " ‡ " + dToc( dData2 )
Local cTabela3	:= "TÌtulos"
Local cTitulo3	:= "ConciliaÁ„o TÌtulos"
Local cTabela4	:= "Ativos por DepreciaÁ„o"
Local cTitulo4	:= "ConciliaÁ„o Ativos por DepreciaÁ„o"
Local cTabela5	:= "Ativos por AquisiÁ„o"
Local cTitulo5	:= "ConciliaÁ„o Ativos por AquisiÁ„o"
Local cTabela6	:= "Ativos por AquisiÁ„o 24X"
Local cTitulo6	:= "ConciliaÁ„o Ativos por AquisiÁ„o 24X"
Local cTabela7	:= "Outras Receitas-Aluguel"
Local cTitulo7	:= "ConciliaÁ„o Outras Receitas/Aluguel"
Local cTabela8	:= "Estorno PIS-Cofins"
Local cTitulo8	:= "ConciliaÁ„o Estorno PIS/Cofins"
Local cTabela9	:= "Outros CrÈditos"
Local cTitulo9	:= "ConciliaÁ„o Outros CrÈditos"
Local cTabela10	:= "Outros Ajustes"
Local cTitulo10	:= "ConciliaÁ„o Outros Ajustes"

Local cTabela99	:= "Totais"
Local cTitulo99	:= "Totais ConciliaÁ„o PIS/Cofins"
Local nTotal1	:= 0
Local nTotal2	:= 0
Local nTotal3	:= 0
Local nTotal4	:= 0
Local nTotal5	:= 0
Local nTotal6	:= 0
Local nTotal7	:= 0
Local nTotal8	:= 0
Local nTotal9	:= 0

Local nTotal1ES	:= 0 //Entrada/Saida
Local nTotal2ES	:= 0
Local nTotal3ES	:= 0
Local nTotal4ES	:= 0
Local nTotal5ES	:= 0
Local nTotal6ES	:= 0
Local nTotal7ES	:= 0

Local nTotal	:= 0
Local aTotais	:= {}
Local aTotAlPE	:= {}
Local aTotAlPS	:= {}
Local aTotAlCE	:= {}
Local aTotAlCS	:= {}
Local nPosAliq	:= 0
Local nCont		:= 0

Local cTipo		:= "ENTRADAS"
Local cCCusto	:= ""
Local cCampo 	:= "X3_TITULO"
//Local cArquivo	:= GetTempPath() + AllTrim(GetNextAlias()) +".xml"
Local cArquivo	:= 	GetTempPath()+;
					"BUD1276_"+;
					MesExtenso(Month(dData1))+"_"+Alltrim(Str(Year(dData1)))+"_"+;
					StrTran(AllTrim(Time()),":","")+".xml"

CalcSFT(dData1,dData2)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

dbSelectArea("QUERY")
SetRegua(RecCount())

oExcel:AddworkSheet(cTabela1)
oExcel:AddTable (cTabela1,cTitulo1)

oExcel:AddColumn(cTabela1,cTitulo1,"TIPO NF",1,1)
oExcel:AddColumn(cTabela1,cTitulo1,"Filial",1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_ENTRADA",cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_EMISSAO",cCampo),1,4)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_NFISCAL",cCampo),1,4)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_SERIE"  ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CLIEFOR",cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_LOJA"   ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CFOP"   ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CONTA"  ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CODBCC" ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_VALCONT",cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_VALICM" ,cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_VALIPI" ,cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_BASEPIS",cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_ALIQPIS",cCampo),1,2)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_VALPIS" ,cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_BASECOF",cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_ALIQCOF",cCampo),1,2)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_VALCOF" ,cCampo),1,3)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CSTPIS" ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,GetSx3Cache("FT_CSTCOF" ,cCampo),1,1)
oExcel:AddColumn(cTabela1,cTitulo1,"DIF PIS",1,3)
oExcel:AddColumn(cTabela1,cTitulo1,"DIF COFINS",1,3)

QUERY->( dbGoTop() )

If QUERY->( ! eof() )
	While ( QUERY->( ! eof() ) )

		If QUERY->TIPO_NF <> cTipo
			cTipo := QUERY->TIPO_NF

			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9}) //Entradas

			nTotal1	:= 0
			nTotal2	:= 0
			nTotal3	:= 0
			nTotal4	:= 0
			nTotal5	:= 0
			nTotal6	:= 0
			nTotal7	:= 0
			nTotal8	:= 0
			nTotal9	:= 0

		EndIf

		oExcel:AddRow(cTabela1,cTitulo1,{;
			QUERY->TIPO_NF,;
			QUERY->FT_FILIAL,;
			dtoc(QUERY->FT_ENTRADA),;
			dtoc(QUERY->FT_EMISSAO),;
			QUERY->FT_NFISCAL,;
			QUERY->FT_SERIE,;
			QUERY->FT_CLIEFOR,;
			QUERY->FT_LOJA,;
			QUERY->FT_CFOP,;
			QUERY->FT_CONTA,;
			QUERY->FT_CODBCC,;
			QUERY->FT_VALCONT,;
			IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM),;
			QUERY->FT_VALIPI,;
			ROUND(QUERY->FT_BASEPIS,2),;
			QUERY->FT_ALIQPIS,;
			QUERY->FT_VALPIS,;
			ROUND(QUERY->FT_BASECOF,2),;
			QUERY->FT_ALIQCOF,;
			QUERY->FT_VALCOF,;
			QUERY->FT_CSTPIS,;
			QUERY->FT_CSTCOF,;
			ROUND( ( ( ROUND(QUERY->FT_BASEPIS,2)*QUERY->FT_ALIQPIS )/100),2) - QUERY->FT_VALPIS,;
			ROUND( ( ( ROUND(QUERY->FT_BASECOF,2)*QUERY->FT_ALIQCOF )/100),2) - QUERY->FT_VALCOF})

		If QUERY->TIPO_NF == "ENTRADAS"

			nTotal1	+= QUERY->FT_VALCONT
			nTotal2	+= QUERY->FT_BASEPIS
			nTotal3	+= QUERY->FT_VALPIS
			nTotal4	+= QUERY->FT_BASECOF
			nTotal5	+= QUERY->FT_VALCOF
			nTotal6	+= IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM)
			nTotal7	+= QUERY->FT_VALIPI

		Else

			nTotal1	+= QUERY->FT_VALCONT
			nTotal2	+= QUERY->FT_BASEPIS
			nTotal3	+= QUERY->FT_VALPIS
			nTotal4	+= QUERY->FT_BASECOF
			nTotal5	+= QUERY->FT_VALCOF
			nTotal6	+= IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM)
			nTotal7	+= QUERY->FT_VALIPI

			If QUERY->FT_TIPO = "S"
				nTotal8	+= QUERY->FT_VRETPIS
				nTotal9	+= QUERY->FT_VRETCOF
			EndIf

		EndIf

		/*
		nTotal1ES	+= QUERY->FT_VALCONT
		nTotal2ES	+= QUERY->FT_BASEPIS
		nTotal3ES	+= QUERY->FT_VALPIS
		nTotal4ES	+= QUERY->FT_BASECOF
		nTotal5ES	+= QUERY->FT_VALCOF
		nTotal6ES	+= QUERY->FT_VALICM
		*/

		QUERY->( dbSkip() )

	EndDo

	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9}) //Saidas

	aadd(aTotais,{nTotal1,nTotal2,aTotais[1][3]-aTotais[2][3],nTotal4,aTotais[1][5]-aTotais[2][5],nTotal6,nTotal7,nTotal8,nTotal9}) //Total de Entradas - Saidas

	oExcel:AddRow(cTabela1,cTitulo1,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela1,cTitulo1,{;
		"TOTAL ENTRADA",;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		aTotais[1][1],;
		aTotais[1][6],;
		aTotais[1][7],;
		aTotais[1][2],;
		NIL,;
		aTotais[1][3],;
		aTotais[1][4],;
		NIL,;
		aTotais[1][5],;
		NIL,;
		NIL,;
		NIL,;
		NIL })


	oExcel:AddRow(cTabela1,cTitulo1,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela1,cTitulo1,{;
		"TOTAL SAIDA",;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		aTotais[2][1],;
		aTotais[2][6],;
		aTotais[2][7],;
		aTotais[2][2],;
		NIL,;
		aTotais[2][3],;
		aTotais[2][4],;
		NIL,;
		aTotais[2][5],;
		NIL,;
		NIL,;
		NIL,;
		NIL })

	oExcel:AddRow(cTabela1,cTitulo1,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela1,cTitulo1,{;
		"TOTAL PAGAR",;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		aTotais[3][3],;
		NIL,;
		NIL,;
		aTotais[3][5],;
		NIL,;
		NIL,;
		NIL,;
		NIL })
Else
	oExcel:AddRow(cTabela1,cTitulo1,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7,nTotal8,nTotal9})
EndIf

CalcSFTR(dData1,dData2)

oExcel:AddworkSheet(cTabela2)
oExcel:AddTable(cTabela2,cTitulo2)

oExcel:AddColumn(cTabela2,cTitulo2,"TIPO NF",1,1)
oExcel:AddColumn(cTabela2,cTitulo2,"Filial",1,1)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_CFOP",cCampo),1,1)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_VALCONT",cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_VALICM" ,cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_VALIPI" ,cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_BASEPIS",cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_ALIQPIS",cCampo),1,2)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_VALPIS",cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_BASECOF",cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_ALIQCOF",cCampo),1,2)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_VALCOF",cCampo),1,3)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_CSTPIS",cCampo),1,1)
oExcel:AddColumn(cTabela2,cTitulo2,GetSx3Cache("FT_CSTCOF",cCampo),1,1)

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0
nTotal7	:= 0
nTotal8	:= 0
nTotal9	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )
	While ( QUERY->( ! eof() ) )

		oExcel:AddRow(cTabela2,cTitulo2,{;
			QUERY->TIPO_NF,;
			QUERY->FT_FILIAL,;
			QUERY->FT_CFOP,;
			QUERY->FT_VALCONT,;
			IIF(QUERY->FT_TIPO=="S",0,QUERY->FT_VALICM),;
			QUERY->FT_VALIPI,;
			QUERY->FT_BASEPIS,;
			QUERY->FT_ALIQPIS,;
			QUERY->FT_VALPIS,;
			QUERY->FT_BASECOF,;
			QUERY->FT_ALIQCOF,;
			QUERY->FT_VALCOF,;
			QUERY->FT_CSTPIS,;
			QUERY->FT_CSTCOF })

			If QUERY->FT_TIPO = "S"
				nTotal8	+= QUERY->FT_VRETPIS
				nTotal9	+= QUERY->FT_VRETCOF
			EndIf

		QUERY->( dbSkip() )

	EndDo
	oExcel:AddRow(cTabela2,cTitulo2,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela2,cTitulo2,{;
		"TOTAL ENTRADA",;
		NIL,;
		NIL,;
		aTotais[1][1],;
		aTotais[1][6],;
		aTotais[1][7],;
		aTotais[1][2],;
		NIL,;
		aTotais[1][3],;
		aTotais[1][4],;
		NIL,;
		aTotais[1][5],;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela2,cTitulo2,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela2,cTitulo2,{;
		"TOTAL SAIDA",;
		NIL,;
		NIL,;
		aTotais[2][1],;
		aTotais[2][6],;
		aTotais[2][7],;
		aTotais[2][2],;
		NIL,;
		aTotais[2][3],;
		aTotais[2][4],;
		NIL,;
		aTotais[2][5],;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela2,cTitulo2,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela2,cTitulo2,{;
		"TOTAL PAGAR",;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		aTotais[3][3],;
		NIL,;
		NIL,;
		aTotais[3][5],;
		NIL,;
		NIL })
Else
	oExcel:AddRow(cTabela2,cTitulo2,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
		//aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6,nTotal7})
EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0
nTotal6	:= 0
nTotal7	:= 0
nTotal8	:= 0
nTotal9	:= 0

If cEmpAnt <> "02"

	CalcSE2(dData1,dData2)

	oExcel:AddworkSheet(cTabela3)
	oExcel:AddTable(cTabela3,cTitulo3)

	oExcel:AddColumn(cTabela3,cTitulo3,"Filial",1,2)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("E2_NUM",cCampo),1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("E2_FORNECE",cCampo),1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("E2_LOJA",cCampo),1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("E2_NOMFOR",cCampo),1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("E2_VALOR",cCampo),1,3)
	oExcel:AddColumn(cTabela3,cTitulo3,"Aliq. PIS",1,2)
	oExcel:AddColumn(cTabela3,cTitulo3,"Valor PIS",1,3)
	oExcel:AddColumn(cTabela3,cTitulo3,"Aliq. Cofins",1,2)
	oExcel:AddColumn(cTabela3,cTitulo3,"Valor Cofins",1,3)
	oExcel:AddColumn(cTabela3,cTitulo3,"Centro Custo",1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,GetSx3Cache("CT1_CONTA",cCampo),1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,"DescriÁ„o Conta Cont·bil",1,1)
	oExcel:AddColumn(cTabela3,cTitulo3,"CST",1,1)

	nTotal	:= 0
	cTipo	:= ""
	cCCusto	:= ""

	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->( dbGoTop() )

	cTipo	:= QUERY->CONTA
	cCCusto	:= QUERY->CCUSTO

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela3,cTitulo3,{;
				QUERY->E2_FILORIG,;
				QUERY->E2_NUM,;
				QUERY->E2_FORNECE,;
				QUERY->E2_LOJA,;
				QUERY->E2_NOMFOR,;
				QUERY->VALOR,;
				QUERY->ALIQPIS,;
				QUERY->VALPIS,;
				QUERY->ALIQCOF,;
				QUERY->VALCOF,;
				QUERY->CCUSTO,;
				QUERY->CONTA,;
				QUERY->DESC_CONTA,;
				"50"})

			nTotal1	+= QUERY->VALOR
			nTotal2	+= QUERY->VALPIS
			nTotal3	+= QUERY->VALCOF

			nTotal1ES	+= QUERY->VALOR
			nTotal2ES	+= QUERY->VALPIS
			nTotal3ES	+= QUERY->VALCOF

			If cEmpAnt == "01"

				If	( nPos := aScan(aCT2Tit, {|x| x[1]+x[2]+x[7] == "210401027" + QUERY->CONTA + QUERY->CCUSTO}) ) > 0 //AlteraÁ„o conta contabil Marcelo Goone 06/09/2021
					aCT2Tit[nPos][5] += QUERY->VALPIS
				Else
					aadd(aCT2Tit,{"210401027",QUERY->CONTA,"051","CREDITO PIS S/"   + SEPARA(QUERY->DESC_CONTA," ")[1] +" REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),QUERY->VALPIS,"",QUERY->CCUSTO}) //AlteraÁ„o conta contabil Marcelo Goone 06/09/2021
				EndIf
				If	( nPos := aScan(aCT2Tit, {|x| x[1]+x[2]+x[7] == "210401028" + QUERY->CONTA + QUERY->CCUSTO}) ) > 0  //AlteraÁ„o conta contabil Marcelo Goone 06/09/2021
					aCT2Tit[nPos][5] += QUERY->VALCOF
				Else
					aadd(aCT2Tit,{"210401028",QUERY->CONTA,"052","CREDITO COFINS S/"+ SEPARA(QUERY->DESC_CONTA," ")[1] +" REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),QUERY->VALCOF,"",QUERY->CCUSTO})  //AlteraÁ„o conta contabil Marcelo Goone 06/09/2021
				EndIf

			ElseIf cEmpAnt == "03"

				If	( nPos := aScan(aCT2Tit, {|x| x[1]+x[2]+x[7] == "2131004" + QUERY->CONTA + QUERY->CCUSTO}) ) > 0
					aCT2Tit[nPos][5] += QUERY->VALPIS
				Else
					aadd(aCT2Tit,{"2131004",QUERY->CONTA,"41","PIS"   + SEPARA(QUERY->DESC_CONTA," ")[1] +" REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),QUERY->VALPIS,"",QUERY->CCUSTO})
				EndIf
				If	( nPos := aScan(aCT2Tit, {|x| x[1]+x[2]+x[7] == "2131005" + QUERY->CONTA + QUERY->CCUSTO}) ) > 0
					aCT2Tit[nPos][5] += QUERY->VALCOF
				Else
					aadd(aCT2Tit,{"2131005",QUERY->CONTA,"42","COFINS"+ SEPARA(QUERY->DESC_CONTA," ")[1] +" REF. "	+ SubStr(dTos(dData1),5,2) +"/"+ SubStr(dTos(dData1),1,4),QUERY->VALCOF,"",QUERY->CCUSTO})
				EndIf

			EndIf

			QUERY->( dbSkip() )

			If cTipo <> QUERY->CONTA .Or. QUERY->( eof() )

				oExcel:AddRow(cTabela3,cTitulo3,{;
					"TOTAL CONTA",;
					NIL,;
					NIL,;
					NIL,;
					NIL,;
					nTotal1ES,;
					NIL,;
					nTotal2ES,;
					NIL,;
					nTotal3ES,;
					NIL,;
					NIL,;
					NIL,;
					NIL})

				nTotal1ES	:= 0
				nTotal2ES	:= 0
				nTotal3ES	:= 0
				cTipo 		:= QUERY->CONTA
				cCCusto		:= QUERY->CCUSTO
			EndIf
		EndDo

		aadd(aTotCST,{"50",ROUND(nTotal1,2),ROUND(nTotal2,2),ROUND(nTotal3,2),"2"})

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Titulos

		oExcel:AddRow(cTabela3,cTitulo3,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela3,cTitulo3,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			aTotais[4][1],;
			NIL,;
			aTotais[4][2],;
			NIL,;
			aTotais[4][3],;
			NIL,;
			NIL,;
			NIL,;
			NIL})
		oExcel:AddRow(cTabela3,cTitulo3,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
	Else
		oExcel:AddRow(cTabela3,cTitulo3,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
	EndIf
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcRecFin(dData1,dData2,2)

	oExcel:AddworkSheet(cTabela9)
	oExcel:AddTable(cTabela9,cTitulo9)

	oExcel:AddColumn(cTabela9,cTitulo9,"Filial",1,1)
	oExcel:AddColumn(cTabela9,cTitulo9,GetSx3Cache("CT1_CONTA",cCampo),1,1)
	oExcel:AddColumn(cTabela9,cTitulo9,"DescriÁ„o Conta Cont·bil",1,1)
	oExcel:AddColumn(cTabela9,cTitulo9,GetSx3Cache("CT2_VALOR",cCampo),1,3)
	oExcel:AddColumn(cTabela9,cTitulo9,GetSx3Cache("N1_ALIQPIS",cCampo),1,2)
	oExcel:AddColumn(cTabela9,cTitulo9,"Valor PIS",1,3)
	oExcel:AddColumn(cTabela9,cTitulo9,GetSx3Cache("N1_ALIQCOF",cCampo),1,2)
	oExcel:AddColumn(cTabela9,cTitulo9,"Valor COFINS",1,3)
	oExcel:AddColumn(cTabela9,cTitulo9,"CST",1,1)
	oExcel:AddColumn(cTabela9,cTitulo9,"Cod Cred",1,1)

	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			If Alltrim(QUERY->CT2_DEBITO) == "110301052" //Pegar a Base pelo Cofins, pois e o % mais alto

				nTotal3 += QUERY->VALCOF / (QUERY->ALIQCOF / 100)

			EndIf

			QUERY->( dbSkip() )

		EndDo

		QUERY->( dbGoTop() )

		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela9,cTitulo9,{;
				QUERY->CT2_FILORI,;
				QUERY->CT2_DEBITO,;
				QUERY->CT1_DESC01,;
				nTotal3,;
				QUERY->ALIQPIS,;
				QUERY->VALPIS,;
				QUERY->ALIQCOF,;
				QUERY->VALCOF,;
				QUERY->CST,;
				QUERY->CODBCC})

			nTotal1	+= QUERY->VALPIS
			nTotal2	+= QUERY->VALCOF

			QUERY->( dbSkip() )

		EndDo

		aadd(aCT2Outros,{ Round(nTotal1,2),Round(nTotal2,2),Round(nTotal3,2) }) //Total Outros Creditos

		oExcel:AddRow(cTabela9,cTitulo9,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela9,cTitulo9,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			nTotal1,;
			NIL,;
			nTotal2,;
			NIL,;
			NIL})

	Else
		oExcel:AddRow(cTabela9,cTitulo9,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aCT2Outros,{nTotal1,nTotal2,nTotal3}) //Total Outros Creditos
	EndIf

EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN109(dData1,dData2)

	oExcel:AddworkSheet(cTabela4)
	oExcel:AddTable(cTabela4,cTitulo4)

	oExcel:AddColumn(cTabela4,cTitulo4,"Filial",1,3)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N3_CCONTAB",cCampo),1,1)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_CBASE",cCampo),1,1)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_ITEM",cCampo),1,1)
	oExcel:AddColumn(cTabela4,cTitulo4,"Base Calculo",1,3)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_ALIQPIS",cCampo),1,2)
	oExcel:AddColumn(cTabela4,cTitulo4,"Valor PIS",1,3)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_ALIQCOF",cCampo),1,2)
	oExcel:AddColumn(cTabela4,cTitulo4,"Valor COFINS",1,3)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_CODBCC",cCampo),1,1)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_CSTPIS",cCampo),1,1)
	oExcel:AddColumn(cTabela4,cTitulo4,GetSx3Cache("N1_CSTCOFI",cCampo),1,1)

	cTipo	:= ""
	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->( dbGoTop() )

	cTipo	:= QUERY->N3_CCONTAB

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela4,cTitulo4,{;
				QUERY->N3_FILORIG,;
				AllTrim(QUERY->N3_CCONTAB),;
				AllTrim(QUERY->N1_CBASE),;
				QUERY->N1_ITEM,;
				QUERY->N4_VLROC1,;
				QUERY->N1_ALIQPIS,;
				QUERY->VALPIS,;
				QUERY->N1_ALIQCOF,;
				QUERY->VALCOF,;
				QUERY->N1_CODBCC,;
				QUERY->N1_CSTPIS,;
				QUERY->N1_CSTCOFI})

			nTotal1	+= QUERY->N4_VLROC1
			nTotal2	+= QUERY->VALPIS
			nTotal3	+= QUERY->VALCOF

			nTotal1ES	+= QUERY->N4_VLROC1
			nTotal2ES	+= QUERY->VALPIS
			nTotal3ES	+= QUERY->VALCOF

			QUERY->( dbSkip() )

			If cTipo <> QUERY->N3_CCONTAB .Or. QUERY->( eof() )

			oExcel:AddRow(cTabela4,cTitulo4,{;
				"TOTAL CONTA",;
				cTipo,;
				NIL,;
				NIL,;
				nTotal1ES,;
				NIL,;
				nTotal2ES,;
				NIL,;
				nTotal3ES,;
				NIL,;
				NIL,;
				NIL})

				nTotal1ES	:= 0
				nTotal2ES	:= 0
				nTotal3ES	:= 0
				cTipo 		:= QUERY->N3_CCONTAB
			EndIf

		EndDo

		nPosAliq := aScan(aTotCST,{|x| x[1] == "50"})
		If nPosAliq > 0
			aTotCST[nPosAliq][2] += ROUND(nTotal1,2)
			aTotCST[nPosAliq][3] += ROUND(nTotal2,2)
			aTotCST[nPosAliq][4] += ROUND(nTotal3,2)
		Else
			aadd(aTotCST,{"50",ROUND(nTotal1,2),ROUND(nTotal2,2),ROUND(nTotal3,2),"2"})
		EndIf

		If Len(aCT2Ativ) > 0
			aCT2Ativ[1][5] += nTotal2
			aCT2Ativ[2][5] += nTotal3
		EndIf
		//aadd(aCT2Ativ,{"210301004","320103006","051","CREDITO PIS S/DEPRECIACAO REF. "	+SubStr(dToc(dData1),4),nTotal2})
		//aadd(aCT2Ativ,{"210301005","320103007","052","CREDITO COFINS S/DEPRECIACAO REF. "	+SubStr(dToc(dData1),4),nTotal3})

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 09

		oExcel:AddRow(cTabela4,cTitulo4,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela4,cTitulo4,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			aTotais[5][1],;
			NIL,;
			aTotais[5][2],;
			NIL,;
			aTotais[5][3],;
			NIL,;
			NIL,;
			NIL })
	Else
		oExcel:AddRow(cTabela4,cTitulo4,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
	EndIf
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN110A(dData1,dData2)

	oExcel:AddworkSheet(cTabela5)
	oExcel:AddTable(cTabela5,cTitulo5)

	oExcel:AddColumn(cTabela5,cTitulo5,"Filial",1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N3_CCONTAB",cCampo),1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_CBASE",cCampo),1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_ITEM",cCampo),1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,"Base Calculo",1,3)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_ALIQPIS",cCampo),1,2)
	oExcel:AddColumn(cTabela5,cTitulo5,"Valor PIS",1,3)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_ALIQCOF",cCampo),1,2)
	oExcel:AddColumn(cTabela5,cTitulo5,"Valor COFINS",1,3)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_CODBCC",cCampo),1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_CSTPIS",cCampo),1,1)
	oExcel:AddColumn(cTabela5,cTitulo5,GetSx3Cache("N1_CSTCOFI",cCampo),1,1)

	cTipo	:= ""
	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->( dbGoTop() )

	cTipo 		:= QUERY->N3_CCONTAB

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela5,cTitulo5,{;
				QUERY->N3_FILORIG,;
				AllTrim(QUERY->N3_CCONTAB),;
				AllTrim(QUERY->N1_CBASE),;
				QUERY->N1_ITEM,;
				ROUND(QUERY->N1_VLAQUIS,2),;
				QUERY->N1_ALIQPIS,;
				ROUND(QUERY->VALPIS,2),;
				QUERY->N1_ALIQCOF,;
				ROUND(QUERY->VALCOF,2),;
				QUERY->N1_CODBCC,;
				QUERY->N1_CSTPIS,;
				QUERY->N1_CSTCOFI})

			nTotal1	+= ROUND(QUERY->N1_VLAQUIS,2)
			nTotal2	+= ROUND(QUERY->VALPIS,2)
			nTotal3	+= ROUND(QUERY->VALCOF,2)

			nTotal1ES	+= ROUND(QUERY->N1_VLAQUIS,2)
			nTotal2ES	+= ROUND(QUERY->VALPIS,2)
			nTotal3ES	+= ROUND(QUERY->VALCOF,2)

			nPosAliq := aScan(aTotCST,{|x| x[1] == QUERY->N1_CSTPIS})
			If nPosAliq > 0
				aTotCST[nPosAliq][2] += ROUND(QUERY->N1_VLAQUIS,2)
				aTotCST[nPosAliq][3] += ROUND(QUERY->VALPIS,2)
				aTotCST[nPosAliq][4] += ROUND(QUERY->VALCOF,2)
			Else
				aadd(aTotCST,{QUERY->N1_CSTPIS,ROUND(QUERY->N1_VLAQUIS,2),ROUND(QUERY->VALPIS,2),ROUND(QUERY->VALCOF,2),"2"})
			EndIf

			QUERY->( dbSkip() )

			If cTipo <> QUERY->N3_CCONTAB .Or. QUERY->( eof() )

			oExcel:AddRow(cTabela5,cTitulo5,{;
				"TOTAL CONTA",;
				NIL,;
				cTipo,;
				NIL,;
				nTotal1ES,;
				NIL,;
				nTotal2ES,;
				NIL,;
				nTotal3ES,;
				NIL,;
				NIL,;
				NIL })

				nTotal1ES	:= 0
				nTotal2ES	:= 0
				nTotal3ES	:= 0
				cTipo 		:= QUERY->N3_CCONTAB
			EndIf
		EndDo

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 10

		oExcel:AddRow(cTabela5,cTitulo5,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela5,cTitulo5,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			aTotais[6][1],;
			NIL,;
			aTotais[6][2],;
			NIL,;
			aTotais[6][3],;
			NIL,;
			NIL,;
			NIL })
	Else
		oExcel:AddRow(cTabela5,cTitulo5,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
	EndIf
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcSN110B(dData1,dData2)

	oExcel:AddworkSheet(cTabela6)
	oExcel:AddTable(cTabela6,cTitulo6)

	oExcel:AddColumn(cTabela6,cTitulo6,"Filial",1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N3_CCONTAB",cCampo),1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_CBASE",cCampo),1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_ITEM",cCampo),1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,"Parcela",1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,"Base Calculo",1,3)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_ALIQPIS",cCampo),1,2)
	oExcel:AddColumn(cTabela6,cTitulo6,"Valor PIS",1,3)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_ALIQCOF",cCampo),1,2)
	oExcel:AddColumn(cTabela6,cTitulo6,"Valor COFINS",1,3)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_CODBCC",cCampo),1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_CSTPIS",cCampo),1,1)
	oExcel:AddColumn(cTabela6,cTitulo6,GetSx3Cache("N1_CSTCOFI",cCampo),1,1)

	cTipo	:= ""
	nTotal1ES	:= 0
	nTotal2ES	:= 0
	nTotal3ES	:= 0

	QUERY->( dbGoTop() )

	cTipo 		:= QUERY->N3_CCONTAB

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela6,cTitulo6,{;
				QUERY->N3_FILORIG,;
				AllTrim(QUERY->N3_CCONTAB),;
				AllTrim(QUERY->N1_CBASE),;
				QUERY->N1_ITEM,;
				QUERY->MESCOUNT,;
				ROUND(QUERY->N1_VLAQUIS,2),;
				QUERY->N1_ALIQPIS,;
				ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2),;
				QUERY->N1_ALIQCOF,;
				ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2),;
				QUERY->N1_CODBCC,;
				QUERY->N1_CSTPIS,;
				QUERY->N1_CSTCOFI})

			nTotal1	+= ROUND(QUERY->N1_VLAQUIS,2)
			nTotal2	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2)
			nTotal3	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2)

			nTotal1ES	+= ROUND(QUERY->N1_VLAQUIS,2)
			nTotal2ES	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2)
			nTotal3ES	+= ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2)

			nPosAliq := aScan(aTotCST,{|x| x[1] == QUERY->N1_CSTPIS})
			If nPosAliq > 0
				aTotCST[nPosAliq][2] += ROUND(QUERY->N1_VLAQUIS,2)
				aTotCST[nPosAliq][3] += ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2)
				aTotCST[nPosAliq][4] += ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2)
			Else
				aadd(aTotCST,{	QUERY->N1_CSTPIS,;
								ROUND(QUERY->N1_VLAQUIS,2),;
								ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQPIS/100)),2),;
								ROUND((QUERY->N1_VLAQUIS*(QUERY->N1_ALIQCOF/100)),2),;
								"2"})
			EndIf		

			QUERY->( dbSkip() )

			If cTipo <> QUERY->N3_CCONTAB .Or. QUERY->( eof() )

			oExcel:AddRow(cTabela6,cTitulo6,{;
				"TOTAL CONTA",;
				cTipo,;
				NIL,;
				NIL,;
				NIL,;
				nTotal1ES,;
				NIL,;
				nTotal2ES,;
				NIL,;
				nTotal3ES,;
				NIL,;
				NIL,;
				NIL })

				nTotal1ES	:= 0
				nTotal2ES	:= 0
				nTotal3ES	:= 0
				cTipo 		:= QUERY->N3_CCONTAB
			EndIf
		EndDo

		If Len(aCT2Ativ) > 0
			aCT2Ativ[1][5] += nTotal2
			aCT2Ativ[2][5] += nTotal3
		EndIf			

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total de Ativo 10

		oExcel:AddRow(cTabela6,cTitulo6,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela6,cTitulo6,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			aTotais[7][1],;
			NIL,;
			aTotais[7][2],;
			NIL,;
			aTotais[7][3],;
			NIL,;
			NIL,;
			NIL })
	Else
		oExcel:AddRow(cTabela6,cTitulo6,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
	EndIf
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

CalcRecFin(dData1,dData2,1)

oExcel:AddworkSheet(cTabela7)
oExcel:AddTable(cTabela7,cTitulo7)

oExcel:AddColumn(cTabela7,cTitulo7,"Filial",1,1)
oExcel:AddColumn(cTabela7,cTitulo7,GetSx3Cache("CT1_CONTA",cCampo),1,1)
oExcel:AddColumn(cTabela7,cTitulo7,"DescriÁ„o Conta Cont·bil",1,1)
oExcel:AddColumn(cTabela7,cTitulo7,GetSx3Cache("CT2_VALOR",cCampo),1,3)
oExcel:AddColumn(cTabela7,cTitulo7,GetSx3Cache("N1_ALIQPIS",cCampo),1,2)
oExcel:AddColumn(cTabela7,cTitulo7,"Valor PIS",1,3)
oExcel:AddColumn(cTabela7,cTitulo7,GetSx3Cache("N1_ALIQCOF",cCampo),1,2)
oExcel:AddColumn(cTabela7,cTitulo7,"Valor COFINS",1,3)
oExcel:AddColumn(cTabela7,cTitulo7,"CST",1,1)

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

cTipo	:= ""
nTotal1ES	:= 0
nTotal2ES	:= 0
nTotal3ES	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )
	While ( QUERY->( ! eof() ) )

		If cEmpAnt <> "02"

			nPosAliq := aScan(aGravaCF8,{|x| x[1] == IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0".And.(AllTrim(QUERY->CT2_CREDIT)=="320104006".Or.AllTrim(QUERY->CT2_CREDIT)=="320106002"),"06",IIF(AllTrim(QUERY->ALIQPIS)=="0".And.AllTrim(QUERY->CT2_CREDIT)=="320104002","08","02")))})
			If nPosAliq > 0
				aGravaCF8[nPosAliq][3] += ROUND(QUERY->VALOR ,2)
				aGravaCF8[nPosAliq][5] += ROUND(QUERY->VALPIS,2)
				aGravaCF8[nPosAliq][7] += ROUND(QUERY->VALCOF,2)
			Else
				//aadd(aGravaCF8,{IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02")),dData2,ROUND(QUERY->VALOR,2),AllTrim(QUERY->ALIQPIS),ROUND(QUERY->VALPIS,2),AllTrim(QUERY->ALIQCOF),ROUND(QUERY->VALCOF,2)})
				aadd(aGravaCF8,{IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0".And.(AllTrim(QUERY->CT2_CREDIT)=="320104006".Or.AllTrim(QUERY->CT2_CREDIT)=="320106002"),"06",IIF(AllTrim(QUERY->ALIQPIS)=="0".And.AllTrim(QUERY->CT2_CREDIT)=="320104002","08","02"))),dData2,ROUND(QUERY->VALOR,2),AllTrim(QUERY->ALIQPIS),ROUND(QUERY->VALPIS,2),AllTrim(QUERY->ALIQCOF),ROUND(QUERY->VALCOF,2)})
			EndIf

		Else

			nPosAliq := aScan(aGravaCF8,{|x| x[1] == IIF(AllTrim(QUERY->ALIQPIS)=="0.65","01","06")})
			If nPosAliq > 0
				aGravaCF8[nPosAliq][3] += ROUND(QUERY->VALOR ,2)
				aGravaCF8[nPosAliq][5] += ROUND(QUERY->VALPIS,2)
				aGravaCF8[nPosAliq][7] += ROUND(QUERY->VALCOF,2)
			Else
				aadd(aGravaCF8,{IIF(AllTrim(QUERY->ALIQPIS)=="0.65","01","06"),dData2,ROUND(QUERY->VALOR,2),AllTrim(QUERY->ALIQPIS),ROUND(QUERY->VALPIS,2),AllTrim(QUERY->ALIQCOF),ROUND(QUERY->VALCOF,2)})
			EndIf

		EndIf

		If AllTrim(QUERY->CT2_CREDIT) == "310101001007"
				aDadosCT1[1] := QUERY->CT2_CREDIT
				aDadosCT1[2] := QUERY->CT1_DESC01
				aDadosCT1[3] := QUERY->VALOR
				aDadosCT1[4] := AllTrim(QUERY->ALIQPIS)
				aDadosCT1[5] := QUERY->VALPIS
				aDadosCT1[6] := QUERY->ALIQCOF
				aDadosCT1[7] := QUERY->VALCOF
				aDadosCT1[8] := IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02"))
		Else
			oExcel:AddRow(cTabela7,cTitulo7,{;
				QUERY->CT2_FILORI,;
				QUERY->CT2_CREDIT,;
				QUERY->CT1_DESC01,;
				QUERY->VALOR,;
				QUERY->ALIQPIS,;
				QUERY->VALPIS,;
				QUERY->ALIQCOF,;
				QUERY->VALCOF,;
				IIF(cEmpAnt=="02",IIF(AllTrim(QUERY->ALIQPIS)=="0.65","01","06"),IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02")))})

			nTotal1	+= QUERY->VALOR
			nTotal2	+= QUERY->VALPIS
			nTotal3	+= QUERY->VALCOF
		EndIf
		nPosAliq := aScan(aTotCST,{|x| x[1] == IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02"))})
		If nPosAliq > 0
			aTotCST[nPosAliq][2] += ROUND(QUERY->VALOR,2)
			aTotCST[nPosAliq][3] += ROUND(QUERY->VALPIS,2)
			aTotCST[nPosAliq][4] += ROUND(QUERY->VALCOF,2)
		Else
			aadd(aTotCST,{IIF(AllTrim(QUERY->ALIQPIS)=="1.65","01",IIF(AllTrim(QUERY->ALIQPIS)=="0","06","02")),ROUND(QUERY->VALOR,2),ROUND(QUERY->VALPIS,2),ROUND(QUERY->VALCOF,2),"1"})
		EndIf

		QUERY->( dbSkip() )

	EndDo

	If Len(aCT2Rec) > 0
		aCT2Rec[1][5] := nTotal2
		aCT2Rec[2][5] := nTotal3
	EndIf
	//aadd(aCT2Rec,{"320103006","210301004","053","PIS S/RECEITA FINANCEIRA REF. "	+SubStr(dToc(dData1),4),nTotal2})
	//aadd(aCT2Rec,{"320103007","210301005","054","COFINS S/RECEITA FINANCEIRA REF. "	+SubStr(dToc(dData1),4),nTotal3})

	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Receitas Financeiras

	oExcel:AddRow(cTabela7,cTitulo7,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
	oExcel:AddRow(cTabela7,cTitulo7,{;
		"TOTAL",;
		NIL,;
		NIL,;
		aTotais[8][1],;
		NIL,;
		aTotais[8][2],;
		NIL,;
		aTotais[8][3],;
		NIL})

	If Len(aDadosCT1) > 0 .And. ! EmpTy( aDadosCT1[1] )

		oExcel:AddRow(cTabela7,cTitulo7,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })

		oExcel:AddRow(cTabela7,cTitulo7,{;
			NIL,;
			aDadosCT1[1],;
			aDadosCT1[2],;
			aDadosCT1[3],;
			aDadosCT1[4],;
			aDadosCT1[5],;
			aDadosCT1[6],;
			aDadosCT1[7],;
			aDadosCT1[8]})

		oExcel:AddRow(cTabela7,cTitulo7,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })

		oExcel:AddRow(cTabela7,cTitulo7,{;
			"TOTAL",;
			NIL,;
			NIL,;
			aDadosCT1[3],;
			NIL,;
			aDadosCT1[5],;
			NIL,;
			aDadosCT1[7],;
			NIL})

		aTotais[8][1] += aDadosCT1[3]
		aTotais[8][2] += aDadosCT1[5]
		aTotais[8][3] += aDadosCT1[7]
	EndIf
Else
	oExcel:AddRow(cTabela7,cTitulo7,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

If cEmpAnt <> "02"

	CalcEstorno(dData1,dData2)

	oExcel:AddworkSheet(cTabela8)
	oExcel:AddTable(cTabela8,cTitulo8)

	oExcel:AddColumn(cTabela8,cTitulo8,"Filial",1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_EMISSAO",cCampo),1,4)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_DOC",cCampo),1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_CF",cCampo),1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_COD",cCampo),1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("B1_DESC",cCampo),1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("B1_TIPO",cCampo),1,1)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_QUANT",cCampo),1,2)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_PRUNIT",cCampo),1,3)
	oExcel:AddColumn(cTabela8,cTitulo8,"Custo",1,3)
	oExcel:AddColumn(cTabela8,cTitulo8,"Total Custo",1,3)

	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_ALQPIS",cCampo),1,2)
	oExcel:AddColumn(cTabela8,cTitulo8,GetSx3Cache("D2_ALQCOF",cCampo),1,2)

	oExcel:AddColumn(cTabela8,cTitulo8,"Estorno Pis",1,3)
	oExcel:AddColumn(cTabela8,cTitulo8,"Estorno Cofins",1,3)
	oExcel:AddColumn(cTabela8,cTitulo8,"CST",1,1)

	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		While ( QUERY->( ! eof() ) )

			oExcel:AddRow(cTabela8,cTitulo8,{;
				QUERY->D2_FILIAL,;
				dToc(QUERY->D2_EMISSAO),;
				QUERY->D2_DOC,;
				QUERY->D2_CF,;
				QUERY->D2_COD,;
				Alltrim(QUERY->B1_DESC),;
				QUERY->B1_TIPO,;
				QUERY->D2_QUANT,;
				QUERY->D2_PRUNIT,;
				QUERY->VAL_CUSTO,;
				ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT),2),;
				QUERY->D2_ALQPIS,;
				QUERY->D2_ALQCOF,;
				ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT)*(QUERY->D2_ALQPIS/100),2),;
				ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT)*(QUERY->D2_ALQCOF/100),2),;
				"M110/M510"})

			nTotal1	+= ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT),2)
			nTotal2	+= ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT)*(QUERY->D2_ALQPIS/100),2)
			nTotal3	+= ROUND((QUERY->VAL_CUSTO*QUERY->D2_QUANT)*(QUERY->D2_ALQCOF/100),2)

			QUERY->( dbSkip() )

		EndDo

		nPosAliq := aScan(aTotCST,{|x| x[1] == "M110/M510"})
		If nPosAliq > 0
			aTotCST[nPosAliq][2] += ROUND(nTotal1,2)
			aTotCST[nPosAliq][3] += ROUND(nTotal2,2)
			aTotCST[nPosAliq][4] += ROUND(nTotal3,2)
		Else
			aadd(aTotCST,{"M110/M510",ROUND(nTotal1,2),ROUND(nTotal2,2),ROUND(nTotal3,2),"1"})
		EndIf

		aCT2Est[1][5] := nTotal2
		aCT2Est[2][5] := nTotal3
		//aadd(aCT2Est,{"320101024","210301004","053","PIS S/BRINDES REF. "	+SubStr(dToc(dData1),4),nTotal2})
		//aadd(aCT2Est,{"320101024","210301005","054","COFINS S/BRINDES REF. "+SubStr(dToc(dData1),4),nTotal3})

		aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Receitas Financeiras

		oExcel:AddRow(cTabela8,cTitulo8,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
		oExcel:AddRow(cTabela8,cTitulo8,{;
			"TOTAL",;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			aTotais[9][1],;
			NIL,;
			NIL,;
			aTotais[9][2],;
			aTotais[9][3],;
			NIL})
	Else
		oExcel:AddRow(cTabela8,cTitulo8,{;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL,;
			NIL })
			aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
	EndIf
Else
	aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

CalcOutrosAjustes(dData1,dData2)

oExcel:AddworkSheet(cTabela10)
oExcel:AddTable(cTabela10,cTitulo10)

oExcel:AddColumn(cTabela10,cTitulo10,"Filial",1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_INDAJU",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_PISCOF",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODAJU",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_NUMDOC",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_DESAJU",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_DTREF",cCampo),1,4)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODIGO",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CODCRE",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_TIPATV",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CST",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_BASE",cCampo),1,3)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_ALQ",cCampo),1,2)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_VALAJU",cCampo),1,3)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_CONTA",cCampo),1,1)
oExcel:AddColumn(cTabela10,cTitulo10,GetSx3Cache("CF5_TPAJST",cCampo),1,1)

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )

	//Caso encontre registros gravados na CF5, desconsiderar o calculo anterior para pegar somente o historico
	//aTotais[9][2] := 0
	//aTotais[9][3] := 0

	//aTotCF5[1][1] - TOTAL OUTROS DEBITOS
	//aTotCF5[1][2] - TOTAL OUTROS DEBITOS
	//aTotCF5[2][1] - TOTAL ESTORNO SAIDAS
	//aTotCF5[2][2] - TOTAL ESTORNO SAIDAS
	//aTotCF5[3][1] - TOTAL OUTROS CREDITOS
	//aTotCF5[3][2] - TOTAL OUTROS CREDITOS
	//aTotCF5[4][1] - TOTAL ESTORNO ENTRADAS
	//aTotCF5[4][2] - TOTAL ESTORNO ENTRADAS

	While ( QUERY->( ! eof() ) )

		oExcel:AddRow(cTabela10,cTitulo10,{;
			QUERY->CF5_FILIAL,;
			IIF(AllTrim(QUERY->CF5_INDAJU)=="0","Ajuste de Reducao","Ajuste de Acrescimo"),;	//0=Ajuste de Reducao;1=Ajuste de Acrescimo
			IIF(AllTrim(QUERY->CF5_PISCOF)=="0","Ajuste de PIS","Ajuste de COFINS"),;			//0=Ajuste de PIS;1=Ajuste de COFINS;2=Ajuste de CPRB
			RetCodAju(AllTrim(QUERY->CF5_CODAJU)),;//IIF(AllTrim(QUERY->CF5_CODAJU)=="06","Estorno",QUERY->CF5_CODAJU),;	//01=Acao Judicial;02=Processo Adm.;03=Legislacao Tribu.;04=Especi. do RTT;05=Outras Situacoes;06=Estorno
			QUERY->CF5_NUMDOC,;
			QUERY->CF5_DESAJU,;
			sTod(QUERY->CF5_DTREF),;
			QUERY->CF5_CODIGO,;
			QUERY->CF5_CODCRE,;
			IIF(AllTrim(QUERY->CF5_TIPATV)=="0","Servico","Industria"),;	//0=Servico;1=Industria
			QUERY->CF5_CST,;
			QUERY->CF5_BASE,;
			QUERY->CF5_ALQ,;
			QUERY->CF5_VALAJU,;
			QUERY->CF5_CONTA,;
			IIF(AllTrim(QUERY->CF5_TPAJST)=="1","Credito","Debito")})	//1=CrÈdito;2=DÈbito
			/*
			If QUERY->CF5_PISCOF == "0"	//Pis
				aTotais[9][2] += QUERY->CF5_VALAJU
			ElseIf QUERY->CF5_PISCOF == "1"	//Cofins
				aTotais[9][3] += QUERY->CF5_VALAJU
			EndIf
			*/
			nTotal1	+= QUERY->CF5_BASE
			If AllTrim(QUERY->CF5_PISCOF) == "0"
				nTotal2	+= ROUND(QUERY->CF5_VALAJU,2)
			Else
				nTotal3	+= ROUND(QUERY->CF5_VALAJU,2)
			EndIf

			If AllTrim(QUERY->CF5_INDAJU)=="1" .And. AllTrim(QUERY->CF5_TPAJST)<>"1"
				If AllTrim(QUERY->CF5_PISCOF) == "0"
					aTotCF5[1][1] += QUERY->CF5_VALAJU
				Else
					aTotCF5[1][2] += QUERY->CF5_VALAJU
				EndIf
			ElseIf AllTrim(QUERY->CF5_INDAJU)=="0" .And. AllTrim(QUERY->CF5_TPAJST)<>"1"
				If AllTrim(QUERY->CF5_PISCOF) == "0"
					aTotCF5[2][1] += QUERY->CF5_VALAJU
				Else
					aTotCF5[2][2] += QUERY->CF5_VALAJU
				EndIf
			ElseIf AllTrim(QUERY->CF5_INDAJU)=="1" .And. AllTrim(QUERY->CF5_TPAJST)=="1"
				If AllTrim(QUERY->CF5_PISCOF) == "0"
					aTotCF5[3][1] += QUERY->CF5_VALAJU
				Else
					aTotCF5[3][2] += QUERY->CF5_VALAJU
				EndIf
			ElseIf AllTrim(QUERY->CF5_INDAJU)=="0" .And. AllTrim(QUERY->CF5_TPAJST)=="1"
				If AllTrim(QUERY->CF5_PISCOF) == "0"
					aTotCF5[4][1] += QUERY->CF5_VALAJU
				Else
					aTotCF5[4][2] += QUERY->CF5_VALAJU
				EndIf
			EndIf

		QUERY->( dbSkip() )

	EndDo

	oExcel:AddRow(cTabela10,cTitulo10,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })

	oExcel:AddRow(cTabela10,cTitulo10,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		"TOTAL PIS",;
		NIL,;
		NIL,;
		nTotal2,;
		NIL,;
		NIL })

	oExcel:AddRow(cTabela10,cTitulo10,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		"TOTAL COFINS",;
		NIL,;
		NIL,;
		nTotal3,;
		NIL,;
		NIL })

	//aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5}) //Total Receitas Financeiras

	//Deixar o valor que est· na planilha, caso nao tenha dados na CF5
	If aTotCF5[4][1] == 0 .And. aTotCF5[4][2] == 0 .And. Len(aCT2Est) > 0
		aTotCF5[4][1] := aCT2Est[1][5]
		aTotCF5[4][2] := aCT2Est[2][5]
	EndIf

Else

	If Len(aCT2Est) > 0
		aTotCF5[4][1] := aCT2Est[1][5]
		aTotCF5[4][2] := aCT2Est[2][5]
	EndIf

	oExcel:AddRow(cTabela10,cTitulo10,{;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL,;
		NIL })
		//aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})
EndIf

//Pegar Saldo Credor do mes anterior
CalcSldCredor(MonthSub(dData1,1),MonthSub(dData2,1))

nTotal1	:= 0
nTotal2	:= 0
nTotal3	:= 0
nTotal4	:= 0
nTotal5	:= 0

QUERY->( dbGoTop() )

If QUERY->( ! eof() )
	nTotal1 := QUERY->PIS
	nTotal2 := QUERY->COFINS
EndIf

//aTotais[10]
aadd(aTotais,{nTotal1,nTotal2,nTotal3,nTotal4,nTotal5})

nTotal1	:= (ROUND(aTotais[2][3],2)+ROUND(aTotais[8][2],2)+ROUND(aTotais[9][2],2))-(ROUND(aTotais[1][3],2)+ROUND(aTotais[4][2],2)+ROUND(aTotais[5][2],2)+ROUND(aTotais[6][2],2)+ROUND(aTotais[7][2],2)+ROUND(aTotais[10][1],2))
nTotal2	:= (ROUND(aTotais[2][5],2)+ROUND(aTotais[8][3],2)+ROUND(aTotais[9][3],2))-(ROUND(aTotais[1][5],2)+ROUND(aTotais[4][3],2)+ROUND(aTotais[5][3],2)+ROUND(aTotais[6][3],2)+ROUND(aTotais[7][3],2)+ROUND(aTotais[10][2],2))

nTotal1ES	:= 0
nTotal2ES	:= 0

If nTotal1 <= 0
	CalcSldCredor(MonthSub(dData1,1),MonthSub(dData2,1))

	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		nTotal1ES := QUERY->PIS
		nTotal2ES := QUERY->COFINS
	EndIf

	//If nTotal1*-1 > nTotal1ES
		nTotal3 := nTotal1*-1 - nTotal1ES
	//Else
		//nTotal3 := nTotal1ES - nTotal1*-1
	//EndIf


	//If nTotal2*-1 > nTotal2ES
		nTotal4 := nTotal2*-1 - nTotal2ES
	//Else
		//nTotal4 := nTotal2ES - nTotal2*-1
	//EndIf

Else
	CalcSldPagar(MonthSub(dData1,1),MonthSub(dData2,1))
	QUERY->( dbGoTop() )

	If QUERY->( ! eof() )
		While QUERY->( ! eof() )
			If AllTrim(QUERY->CL3_CODREC) == '691201'
				nTotal1ES := QUERY->CL3_VALOR
			EndIf
			If AllTrim(QUERY->CL3_CODREC) == '585601'
				nTotal2ES := QUERY->CL3_VALOR
			EndIf
			QUERY->( dbSkip() )
		EndDo
	EndIf

	//If nTotal1 > nTotal1ES
		nTotal3 := nTotal1 - nTotal1ES
	//Else
		//nTotal3 := nTotal1ES - nTotall
	//EndIf

	//If nTotal2 > nTotal2ES
		nTotal4 := nTotal2 - nTotal2ES
	//Else
		//nTotal4 := nTotal2ES - nTotal2
	//EndIf
EndIf

If nTotal1 <= 0 //Credor
	If (nTotal1*-1) < nTotal1ES
		If nTotal1ES - (nTotal1*-1) >= 0.00 .And. nTotal1ES - (nTotal1*-1) <= 0.10
			nTotal1 		:= (nTotal1ES*-1)
			aTotais[1][3] 	-= nTotal3	//Entradas
		EndIf
	Else
		If (nTotal1*-1) - nTotal1ES >= 0.00 .And. (nTotal1*-1) - nTotal1ES <= 0.10
			nTotal1 		:= (nTotal1ES*-1)
			aTotais[2][3] 	+= nTotal3	//Saidas
		EndIf
	EndIf
	If (nTotal2*-1) < nTotal2ES
		If nTotal2ES - (nTotal2*-1) >= 0.00 .And. nTotal2ES - (nTotal2*-1) <= 0.10
			nTotal2 		:= (nTotal2ES*-1)
			aTotais[1][5] 	-= nTotal4	//Entradas
		EndIf
	Else
		If (nTotal2*-1) - nTotal2ES >= 0.00 .And. (nTotal2*-1) - nTotal2ES <= 0.10
			nTotal2 		:= (nTotal2ES*-1)
			aTotais[2][5] 	+= nTotal4	//Saidas
		EndIf
	EndIf
Else//Pagar
	If nTotal1 < nTotal1ES
		If nTotal1ES - nTotal1 >= 0.00 .And. nTotal1ES - nTotal1 <= 0.10
			nTotal1 		:= nTotal1ES
			aTotais[1][3] 	-= nTotal3	//Entradas
		EndIf
	Else
		If nTotal1 - nTotal1ES >= 0.00 .And. nTotal1 - nTotal1ES <= 0.10
			nTotal1 		:= nTotal1ES
			aTotais[2][3] 	+= nTotal3	//Saidas
		EndIf
	EndIf
	If nTotal2 < nTotal2ES
		If nTotal2ES - nTotal2 >= 0.00 .And. nTotal2ES - nTotal2 <= 0.10
			nTotal2 		:= nTotal2ES
			aTotais[1][5] 	-= nTotal4	//Entradas
		EndIf
	Else
		If nTotal2 - nTotal2ES >= 0.00 .And. nTotal2 - nTotal2ES <= 0.10
			nTotal2 		:= nTotal2ES
			aTotais[2][5] 	+= nTotal4	//Saidas
		EndIf
	EndIf
EndIf

nTotal1	:=  (ROUND(aTotais[2][3],2)+ROUND(aTotais[8][2],2)+ROUND(aTotCF5[1][1],2)-ROUND(aTotCF5[2][1],2)) ;
			- ;
			(ROUND(aTotais[2][8],2)+ROUND(aTotais[1][3],2)+ROUND(aTotCF5[3][1],2)-ROUND(aTotCF5[4][1],2)+ROUND(aTotais[4][2],2)+ROUND(aTotais[5][2],2)+ROUND(aTotais[6][2],2)+ROUND(aTotais[7][2],2)+ROUND(aTotais[10][1],2)+IIF(Len(aCT2Outros)>0,ROUND(aCT2Outros[1][1],2),0))

nTotal2	:=  (ROUND(aTotais[2][5],2)+ROUND(aTotais[8][3],2)+ROUND(aTotCF5[1][2],2)-ROUND(aTotCF5[2][2],2)) ;
			- ;
			(ROUND(aTotais[2][9],2)+ROUND(aTotais[1][5],2)+ROUND(aTotCF5[3][2],2)-ROUND(aTotCF5[4][2],2)+ROUND(aTotais[4][3],2)+ROUND(aTotais[5][3],2)+ROUND(aTotais[6][3],2)+ROUND(aTotais[7][3],2)+ROUND(aTotais[10][2],2)+IIF(Len(aCT2Outros)>0,ROUND(aCT2Outros[1][2],2),0))

oExcel:AddworkSheet(cTabela99)
oExcel:AddTable(cTabela99,cTitulo99)

oExcel:AddColumn(cTabela99,cTitulo99,"TIPO",1,1)
oExcel:AddColumn(cTabela99,cTitulo99,"Valor PIS",1,3)
oExcel:AddColumn(cTabela99,cTitulo99,"Valor Cofins",1,3)

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL SAIDAS",;
	aTotais[2][3],;
	aTotais[2][5]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL RECEITAS",;
	aTotais[8][2],;
	aTotais[8][3]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL OUTROS DEBITOS",;
	aTotCF5[1][1],;//PIS
	aTotCF5[1][2]})//COFINS

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ESTORNO DEBITO",;//"TOTAL ESTORNO PIS\COFINS",;
	aTotCF5[2][1],;//aTotais[9][2],;
	aTotCF5[2][2]})//aTotais[9][3]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL D…BITOS",;
	aTotais[2][3]+aTotais[8][2]+aTotCF5[1][1]-aTotCF5[2][1],;//aTotais[9][2]
	aTotais[2][5]+aTotais[8][3]+aTotCF5[1][2]-aTotCF5[2][2]})//aTotais[9][3]

oExcel:AddRow(cTabela99,cTitulo99,{;
	NIL,;
	NIL,;
	NIL})

//////////////////////////////////////////////////

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ENTRADAS",;
	aTotais[1][3],;
	aTotais[1][5]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL OUTROS CREDITOS",;
	aTotCF5[3][1],;//PIS
	aTotCF5[3][2]})//COFINS

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ESTORNO CREDITO",;
	aTotCF5[4][1],;//PIS
	aTotCF5[4][2]})//COFINS

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL CREDOR MES ANTERIOR",;
	aTotais[10][1],;
	aTotais[10][2]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL CRED. EXTEMPOR¬NEO",;
	IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),;
	IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0)})

If cEmpAnt == "03"
	oExcel:AddRow(cTabela99,cTitulo99,{;
		"TOTAL RETEN«’ES M S",;
		aTotais[3][8],;
		aTotais[3][9]})
EndIf

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL TITULOS",;
	aTotais[4][2],;
	aTotais[4][3]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ATIVO DEPRECIA«√O",;
	aTotais[5][2],;
	aTotais[5][3]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ATIVO AQUISI«√O",;
	aTotais[6][2],;
	aTotais[6][3]})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL ATIVO AQUISI«√O 24X",;
	aTotais[7][2],;
	aTotais[7][3]})	

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL CR…DITOS",;
	aTotais[1][3]+aTotCF5[3][1]-aTotCF5[4][1]+aTotais[2][8]+aTotais[4][2]+aTotais[5][2]+aTotais[6][2]+aTotais[7][2]+aTotais[10][1]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][1],0),;
	aTotais[1][5]+aTotCF5[3][2]-aTotCF5[4][2]+aTotais[2][9]+aTotais[4][3]+aTotais[5][3]+aTotais[6][3]+aTotais[7][3]+aTotais[10][2]+IIF(Len(aCT2Outros)>0,aCT2Outros[1][2],0)})

oExcel:AddRow(cTabela99,cTitulo99,{;
	NIL,;
	NIL,;
	NIL})

oExcel:AddRow(cTabela99,cTitulo99,{;
	"TOTAL "+IIF( nTotal1 < 0,"CREDOR","A PAGAR"),;
	IIF(nTotal1 < 0,nTotal1*-1,nTotal1),;
	IIF(nTotal2 < 0,nTotal2*-1,nTotal2)})

oExcel:Activate()
oExcel:GetXMLFile(cArquivo)

//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()           //Abre uma nova conex„o com Excel
oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
oExcel:SetVisible(.T.)              //Visualiza a planilha
oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

Static Function GravaCT2()
Local lReturn 	:= .T.
Local cDoc		:= ""
Local nInc		:= 0
Local nCont		:= 0
Local aItens 	:= {}
Local aCab 		:= {}
/*
Private aCT2Tit	:= {}	//Dados CT2 para Titulos
Private aCT2Rec	:= {}	//Dados CT2 para Receitas
Private aCT2Ativ:= {}	//Dados CT2 para Ativo
Private aCT2Est	:= {}	//Dados CT2 para Estorno
aadd(aCT2Tit,{"210301004","310104005016","051","CREDITO PIS S/ALUGUEL REF. "		+SubStr(dToc(dData1),4),0})
LastDate(dData2)
Private lTitulos 	:= .F.
Private lRecDepBri 	:= .F.
@ 056, 006 CHECKBOX oTitulos 	VAR lTitulos	PROMPT "Contabiliza Titulos?" 						WHEN lWhen2 SIZE 140, 010 PIXEL OF oDlg
@ 069, 006 CHECKBOX oRecDepBri 	VAR lRecDepBri	PROMPT "Contabiliza Receitas/DepreciaÁ„o/Brindes?" 	WHEN lWhen3 SIZE 140, 010 PIXEL OF oDlg

*/
If lTitulos .And. MsgYesNo("Conforme os dados do relatÛrio, deseja realmente Contabilizar Titulos?")

	nCont 	:= 0
	cDoc	:= "000001"
	aItens 	:= {}
	If Len(aCT2Tit) > 0
		aCab 		:= { 	{'DDATALANC' 	,LastDate(dData2)	,NIL},;
							{'CLOTE' 		,cLote 				,NIL},;
							{'CSUBLOTE' 	,'001' 				,NIL},;
							{'CDOC' 		,cDoc 				,NIL},;
							{'CPADRAO' 		,'' 				,NIL},;
							{'NTOTINF' 		,0 					,NIL},;
							{'NTOTINFLOT' 	,0 					,NIL} }

		For nInc := 1 To Len(aCT2Tit)
			nCont++

			aAdd(aItens,{	{'CT2_FILIAL' 	,xFilial("CT2") 	, NIL},;
							{'CT2_LINHA' 	,STRZERO(nCont,3)	, NIL},;
							{'CT2_MOEDLC' 	,'01' 				, NIL},;
							{'CT2_DC' 		,'3'				, NIL},;
							{'CT2_DEBITO' 	,aCT2Tit[nInc][1] 	, NIL},;
							{'CT2_CREDIT' 	,aCT2Tit[nInc][2]	, NIL},;
							{'CT2_VALOR' 	,aCT2Tit[nInc][5]	, NIL},;
							{'CT2_ORIGEM' 	,'BUD1276'			, NIL},;
							{'CT2_HP' 		,aCT2Tit[nInc][3]	, NIL},;
							{'CT2_HIST' 	,aCT2Tit[nInc][4]	, NIL},;
							{'CT2_CCD' 		,aCT2Tit[nInc][6]	, NIL},;
							{'CT2_CCC' 		,aCT2Tit[nInc][7]	, NIL}  } )
	/*
			//este trecho deve ser usado apenas quando necess·rio incluir continuaÁ„o de histÛrico
			aAdd(aItens,{ 	{'CT2_FILIAL' ,'D MG 01 ' , NIL},;
							{'CT2_LINHA' ,'002' , NIL},;
							{'CT2_DC' ,'4' , NIL},;
							{'CT2_HIST' ,'CONT - MSEXECAUT INCLUSAO CONTINUACAO DE HISTORICO COM MAIS DE 80 CARACT', NIL} } )
	*/

		Next nInc
	EndIf

	If Len(aCab) > 0 .And. Len(aItens) > 0
		ExecutaCT2(aCab,aItens)
	EndIf
EndIf

If lRecDepBri .And. MsgYesNo("Conforme os dados do relatÛrio, deseja realmente Contabilizar Receitas/DepreciaÁ„o/Brindes?")
	nCont 	:= 0
	cDoc	:= "000002"
	aItens 	:= {}
	aCab 	:= { 	{'DDATALANC' 	,LastDate(dData2)	,NIL},;
					{'CLOTE' 		,cLote 				,NIL},;
					{'CSUBLOTE' 	,'001' 				,NIL},;
					{'CDOC' 		,cDoc 				,NIL},;
					{'CPADRAO' 		,'' 				,NIL},;
					{'NTOTINF' 		,0 					,NIL},;
					{'NTOTINFLOT' 	,0 					,NIL} }

	If Len(aCT2Rec) > 0
		For nInc := 1 To Len(aCT2Rec)
			nCont++
			aAdd(aItens,{	{'CT2_FILIAL' 	,xFilial("CT2") 	, NIL},;
							{'CT2_LINHA' 	,STRZERO(nCont,3)	, NIL},;
							{'CT2_MOEDLC' 	,'01' 				, NIL},;
							{'CT2_DC' 		,'3'				, NIL},;
							{'CT2_DEBITO' 	,aCT2Rec[nInc][1] 	, NIL},;
							{'CT2_CREDIT' 	,aCT2Rec[nInc][2]	, NIL},;
							{'CT2_VALOR' 	,aCT2Rec[nInc][5]	, NIL},;
							{'CT2_ORIGEM' 	,'BUD1276'			, NIL},;
							{'CT2_HP' 		,aCT2Rec[nInc][3]	, NIL},;
							{'CT2_HIST' 	,aCT2Rec[nInc][4]	, NIL},;
							{'CT2_CCD' 		,aCT2Rec[nInc][6]	, NIL},;
							{'CT2_CCC' 		,aCT2Rec[nInc][7]	, NIL}  } )

		Next nInc
	EndIf
	If Len(aCT2Ativ) > 0
		For nInc := 1 To Len(aCT2Ativ)
			nCont++
			aAdd(aItens,{	{'CT2_FILIAL' 	,xFilial("CT2") 	, NIL},;
							{'CT2_LINHA' 	,STRZERO(nCont,3)	, NIL},;
							{'CT2_MOEDLC' 	,'01' 				, NIL},;
							{'CT2_DC' 		,'3'				, NIL},;
							{'CT2_DEBITO' 	,aCT2Ativ[nInc][1] 	, NIL},;
							{'CT2_CREDIT' 	,aCT2Ativ[nInc][2]	, NIL},;
							{'CT2_VALOR' 	,aCT2Ativ[nInc][5]	, NIL},;
							{'CT2_ORIGEM' 	,'BUD1276'			, NIL},;
							{'CT2_HP' 		,aCT2Ativ[nInc][3]	, NIL},;
							{'CT2_HIST' 	,aCT2Ativ[nInc][4]	, NIL},;
							{'CT2_CCD' 		,aCT2Ativ[nInc][6]	, NIL},;
							{'CT2_CCC' 		,aCT2Ativ[nInc][7]	, NIL}  } )

		Next nInc
	EndIf
	If Len(aCT2Est) > 0
		For nInc := 1 To Len(aCT2Est)
			nCont++
			aAdd(aItens,{	{'CT2_FILIAL' 	,xFilial("CT2") 	, NIL},;
							{'CT2_LINHA' 	,STRZERO(nCont,3)	, NIL},;
							{'CT2_MOEDLC' 	,'01' 				, NIL},;
							{'CT2_DC' 		,'3'				, NIL},;
							{'CT2_DEBITO' 	,aCT2Est[nInc][1] 	, NIL},;
							{'CT2_CREDIT' 	,aCT2Est[nInc][2]	, NIL},;
							{'CT2_VALOR' 	,aCT2Est[nInc][5]	, NIL},;
							{'CT2_ORIGEM' 	,'BUD1276'			, NIL},;
							{'CT2_HP' 		,aCT2Est[nInc][3]	, NIL},;
							{'CT2_HIST' 	,aCT2Est[nInc][4]	, NIL},;
							{'CT2_CCD' 		,aCT2Est[nInc][6]	, NIL},;
							{'CT2_CCC' 		,aCT2Est[nInc][7]	, NIL}  } )

		Next nInc
	EndIf

	If Len(aCab) > 0 .And. Len(aItens) > 0
		ExecutaCT2(aCab,aItens)
	EndIf
EndIf
Return lReturn

Static Function ExecutaCT2(aCab,aItens)
Local _lOk 			:= .T.
PRIVATE lMsErroAuto := .F.

MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)

If !lMsErroAuto
	_lOk := .T.
	/*
	If !IsBlind()
		MsgInfo('Inclus„o com sucesso!')
	EndIf
	*/
Else
	_lOk := .F.
	If !IsBlind()
		//MsgAlert('Erro na inclusao!')
		MostraErro()
	Endif
EndIf

Return

Static Function AtualizaPisCofins(dData1,dData2)
Local cNF	:= ""
Local aNF	:= {}
Local nPos	:= 0, nInc:= 0, nInc2:= 0

CalcEstorno(dData1,dData2)

QUERY->(dbGoTop())
If QUERY->( ! eof() )
	cNF := QUERY->D2_DOC
	While QUERY->( ! EOF())
		If cNF == QUERY->D2_DOC .And. Len(aNF) > 0
			aNF[Len(aNF)][2] += ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQPIS/100),2)
			aNF[Len(aNF)][3] += ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQCOF/100),2)
			aNF[Len(aNF)][4] += ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO),2)
		Else
			aadd(aNF,{	QUERY->D2_DOC,;
						ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQPIS/100),2),;
						ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQCOF/100),2),;
						ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO),2),;
						QUERY->D2_ALQPIS,;
						QUERY->D2_ALQCOF;
					})
			cNF := QUERY->D2_DOC
		EndIf
		//nTotal1	+= ROUND(QUERY->D2_QUANT*QUERY->VAL_CUSTO,2)
		//nTotal2	+= ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQPIS/100),2)
		//nTotal3	+= ROUND((QUERY->D2_QUANT*QUERY->VAL_CUSTO)*(QUERY->D2_ALQCOF/100),2)

		QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
EndIf

//oModel:Getvalue('FISA042MOD','CF5_CODIGO') + (cEndAju+cPISCOF+cCodAju+Dtos(cDtRef)+cCodCred)
//CF5_FILIAL+CF5_CODIGO+CF5_INDAJU+CF5_PISCOF+CF5_CODAJU+DTOS(CF5_DTREF)+CF5_CODCRE
If Len(aNF) > 0
	//CF5->(DbSetOrder(1))  //CF5_FILIAL+CF5_CODIGO+CF5_INDAJU+CF5_PISCOF+CF5_CODAJU+DTOS(CF5_DTREF)+CF5_CODCRE
	For nInc := 1 To Len(aNF)
		BuscaCF5(LastDate(dData1),aNF[nInc][1])//CF5->(DbSeek(xFilial("CF5")+cChave))
		QUERY->( dbGoTop() )
		If QUERY->( ! eof() )
			While ( QUERY->( ! eof() ) )
				CF5->(dbGoto(QUERY->NREG))
				If CF5->CF5_NUMDOC == aNF[nInc][1]
					CF5->(RecLock("CF5", .F.))
					If CF5->CF5_ALQ 	== aNF[nInc][5]
						CF5->CF5_VALAJU := aNF[nInc][2]
					ElseIf CF5->CF5_ALQ == aNF[nInc][6]
						CF5->CF5_VALAJU := aNF[nInc][3]
					EndIf
					CF5->( MsUnlock() )
				EndIf
				QUERY->( dbSkip() )
			EndDo
		Else

			For nInc2 := 1 To 2
				CF5->(RecLock("CF5", .T.))

				CF5->CF5_FILIAL := xFilial("CF5")
				CF5->CF5_INDAJU := "0"
				CF5->CF5_PISCOF	:= IIF(nInc2 == 1,"0","1")
				CF5->CF5_VALAJU	:= IIF(nInc2 == 1,aNF[nInc][2],aNF[nInc][3])
				CF5->CF5_CODAJU := "06"
				CF5->CF5_NUMDOC	:= aNF[nInc][1]
				CF5->CF5_DESAJU	:= "ESTORNO REF OP BRINDES"
				CF5->CF5_DTREF	:= LastDate(dData1)
				CF5->CF5_CODCRE	:= "101"
				CF5->CF5_CODIGO	:= GetSxeNum("CF5","CF5_CODIGO")
				CF5->CF5_TIPATV	:= "1"
				CF5->CF5_CST	:= "50"
				CF5->CF5_BASE	:= aNF[nInc][4]
				CF5->CF5_ALQ	:= IIF(nInc2 == 1,aNF[nInc][5],aNF[nInc][6])
				CF5->CF5_CONTA	:= "320101024"
				CF5->CF5_TPAJST	:= "1"
				CF5->CF5_CODCON	:= ""

				CF5->( MsUnlock() )

				ConfirmSx8()
			Next nInc2

		EndIf
	Next nInc
EndIf

If Len(aGravaCF8) > 0
	For nInc := 1 To Len(aGravaCF8)
		If aGravaCF8[nInc][3] > 0
			BuscaCF8(LastDate(aGravaCF8[nInc][2]),aGravaCF8[nInc][1])
			QUERY->( dbGoTop() )
			If QUERY->( ! eof() )
				CF8->(dbGoto(QUERY->NREG))
				If AllTrim( CF8->CF8_CSTPIS ) == AllTrim( aGravaCF8[nInc][1] ) .And. AllTrim( CF8->CF8_CSTCOF ) == AllTrim( aGravaCF8[nInc][1] )
					CF8->(RecLock("CF8", .F.))
						CF8->CF8_VLOPER := aGravaCF8[nInc][3]
						CF8->CF8_ALQPIS	:= Val(aGravaCF8[nInc][4])
						CF8->CF8_BASPIS	:= aGravaCF8[nInc][3]
						CF8->CF8_VALPIS	:= aGravaCF8[nInc][5]

						CF8->CF8_ALQCOF	:= Val(aGravaCF8[nInc][6])
						CF8->CF8_BASCOF	:= aGravaCF8[nInc][3]
						CF8->CF8_VALCOF	:= aGravaCF8[nInc][7]
					CF8->( MsUnlock() )
				EndIf
			Else
				//                                                    1      2                     3              4                     5               6                      7
				//aadd(aGravaCF8,{IIF(QUERY->ALIQPIS=="1.65","01","02"),dData2,ROUND(QUERY->VALOR,2),QUERY->ALIQPIS,ROUND(QUERY->VALPIS,2),QUERY->ALIQCOF,ROUND(QUERY->VALCOF,2)})
				CF8->(RecLock("CF8", .T.))

				CF8->CF8_FILIAL := xFilial("CF8")
				
				CF8->CF8_DTOPER	:= aGravaCF8[nInc][2]
				CF8->CF8_CSTPIS	:= aGravaCF8[nInc][1]

				CF8->CF8_VLOPER := aGravaCF8[nInc][3]

				CF8->CF8_ALQPIS	:= Val(aGravaCF8[nInc][4])
				CF8->CF8_BASPIS	:= aGravaCF8[nInc][3]
				CF8->CF8_VALPIS	:= aGravaCF8[nInc][5]

				CF8->CF8_CSTCOF	:= aGravaCF8[nInc][1]

				CF8->CF8_ALQCOF	:= Val(aGravaCF8[nInc][6])
				CF8->CF8_BASCOF	:= aGravaCF8[nInc][3]
				CF8->CF8_VALCOF	:= aGravaCF8[nInc][7]

				If cEmpAnt == "01"
					
					CF8->CF8_TPREG 	:= "2"
					//CF8->CF8_CODCTA	:= IIF(aGravaCF8[nInc][1] == "01","310101001007",IIF(aGravaCF8[nInc][1] == "06","320104006","320104"))
					If aGravaCF8[nInc][1] == "01"
						CF8->CF8_CODCTA	:= "310101001007"
					ElseIf aGravaCF8[nInc][1] == "06"
						CF8->CF8_CODCTA	:= "320104006"
					ElseIf aGravaCF8[nInc][1] == "08"
						CF8->CF8_CODCTA	:= "320106002"
					Else
						CF8->CF8_CODCTA	:= "320104"
					EndIf

					CF8->CF8_DESCPR	:= "RECEITAS FINANCEIRAS"

				ElseIf cEmpAnt == "02"

					CF8->CF8_TPREG 	:= "1"

					If aGravaCF8[nInc][1] == "01"
						CF8->CF8_DESCPR	:= "ALUGUEIS RECEBIDOS"
					Else
						CF8->CF8_DESCPR	:= "RECEITAS FINANCEIRAS"
					EndIf

				ElseIf cEmpAnt == "03"

					CF8->CF8_TPREG 	:= "2"
					CF8->CF8_CODCTA	:= IIF(aGravaCF8[nInc][1] == "01","",IIF(aGravaCF8[nInc][1] == "06","","3214002"))
					CF8->CF8_DESCPR	:= "RECEITAS FINANCEIRAS"

				EndIf

				CF8->CF8_SCORGP	:= "2"
				If aGravaCF8[nInc][1] == "06"
					CF8->CF8_INDOPE	:= "2"
					CF8->CF8_TNATRE	:= "4313"
					CF8->CF8_CNATRE	:= "911"
				ElseIf aGravaCF8[nInc][1] == "08"
					CF8->CF8_INDOPE	:= "2"
					CF8->CF8_TNATRE	:= "4315"
					CF8->CF8_CNATRE	:= "999"
				Else
					CF8->CF8_INDOPE	:= "1"
				EndIf
				CF8->CF8_CODIGO	:= GetSxeNum("CF8","CF8_CODIGO")

				CF8->( MsUnlock() )

				ConfirmSx8()

			EndIf
		EndIf
	Next nInc
EndIf

If Len(aCT2Outros) > 0
	For nInc := 1 To Len(aCT2Outros)
		If aCT2Outros[nInc][3] > 0
			BuscaCF8(LastDate(dData1),"50")
			QUERY->( dbGoTop() )
			If QUERY->( ! eof() )
				CF8->(dbGoto(QUERY->NREG))
				If AllTrim( CF8->CF8_CSTPIS ) == "50" .And. AllTrim( CF8->CF8_CSTCOF ) == "50"
					CF8->(RecLock("CF8", .F.))
						CF8->CF8_VLOPER := aCT2Outros[nInc][3]
						CF8->CF8_ALQPIS	:= 1.65
						CF8->CF8_BASPIS	:= aCT2Outros[nInc][3]
						CF8->CF8_VALPIS	:= aCT2Outros[nInc][1]

						CF8->CF8_ALQCOF	:= 7.6
						CF8->CF8_BASCOF	:= aCT2Outros[nInc][3]
						CF8->CF8_VALCOF	:= aCT2Outros[nInc][2]
					CF8->( MsUnlock() )
				EndIf
			Else

				CF8->(RecLock("CF8", .T.))

				CF8->CF8_FILIAL := xFilial("CF8")
				CF8->CF8_TPREG 	:= "2"
				CF8->CF8_INDOPE	:= "1"
				CF8->CF8_DTOPER	:= LastDate(dData1)
				CF8->CF8_CSTPIS	:= "50"

				CF8->CF8_VLOPER := aCT2Outros[nInc][3]

				CF8->CF8_ALQPIS	:= 1.65
				CF8->CF8_BASPIS	:= aCT2Outros[nInc][3]
				CF8->CF8_VALPIS	:= aCT2Outros[nInc][1]

				CF8->CF8_CSTCOF	:= "50"

				CF8->CF8_ALQCOF	:= 7.6
				CF8->CF8_BASCOF	:= aCT2Outros[nInc][3]
				CF8->CF8_VALCOF	:= aCT2Outros[nInc][2]

				CF8->CF8_CODCTA	:= ""
				CF8->CF8_DESCPR	:= "CREDITO EXTEMPORANEO"
				CF8->CF8_SCORGP	:= "2"
				CF8->CF8_CODBCC	:= "13"
				CF8->CF8_CODIGO	:= GetSxeNum("CF8","CF8_CODIGO")

				CF8->( MsUnlock() )

				ConfirmSx8()

			EndIf
		EndIf
	Next nInc
EndIf
Return

Static Function BuscaCF5(dDataRef,cNumDoc)
Local nRet := 0

cQuery := "SELECT R_E_C_N_O_ AS NREG "
cQuery += "FROM " + RETSQLNAME("CF5") + " "
cQuery += "WHERE CF5_DTREF = '"+dTos(dDataRef)+"' "
cQuery += "AND CF5_FILIAL = '"+xFilial("CF5")+"' "
cQuery += "AND CF5_NUMDOC = '"+cNumDoc+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
TcSetField("QUERY","NREG","N",17,0)

Return

Static Function BuscaCF8(dDataRef,cCST)
Local nRet := 0

cQuery := "SELECT R_E_C_N_O_ AS NREG "
cQuery += "FROM " + RETSQLNAME("CF8") + " "
cQuery += "WHERE CF8_DTOPER = '"+dTos(dDataRef)+"' "
cQuery += "AND CF8_FILIAL = '"+xFilial("CF8")+"' "
cQuery += "AND CF8_CSTPIS = '"+cCST+"' "
cQuery += "AND CF8_CSTCOF = '"+cCST+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "

If Select("QUERY") > 0
  dbSelectArea("QUERY")
  dbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"
TcSetField("QUERY","NREG","N",17,0)

Return

Static Function RetCodAju(cCodAju)
Local cRet	:= ""

//01=Acao Judicial;02=Processo Adm.;03=Legislacao Tribu.;04=Especi. do RTT;05=Outras Situacoes;06=Estorno
If cCodAju == "01"
	cRet := "Acao Judicial"
ElseIf cCodAju == "02"
	cRet := "Processo Adm."
ElseIf cCodAju == "03"
	cRet := "Legislacao Tribu."
ElseIf cCodAju == "04"
	cRet := "Especi. do RTT"
ElseIf cCodAju == "05"
	cRet := "Outras Situacoes"
ElseIf cCodAju == "06"
	cRet := "Estorno"
Else
	cRet := cCodAju
EndIf

Return cRet
