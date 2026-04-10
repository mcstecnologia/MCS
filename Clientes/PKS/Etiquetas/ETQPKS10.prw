#include "Protheus.ch"

/*/{Protheus.doc} ETQPKS10
Etiqueta de produto por OP
@type  User Function
@author Caio Monteiro
@since 10/04/2024
/*/

/*/
Consulta Padrao: ETQPKS10
MV_PAR01 - Ordem de Producao
MV_PAR02 - Responsavel 1
MV_PAR03 - Responsavel 2
MV_PAR04 - Quantidade de produtos
MV_PAR05 - Qtde. de impressoes de etiquetas
MV_PAR06 - Data
MV_PAR07 - Cliente
/*/
User Function ETQPKS10()

	Local aAreaSA1		:= SA1->(GetArea())
	Local aAreaSB1		:= SB1->(GetArea())
	Local aAreaSC2		:= SC2->(GetArea())
	Local cResp1		:= Space(6)
	Local cResp2		:= Space(6)
	Local cOper			:= Space(6)
	Local nL1			:= 013
	Local nL2			:= 010
	Local nQtdEtq		:= 0
	Local nQtdPrd		:= 0

	Private cNmResp1	:= ""
	Private cNmResp2	:= ""
	Private cProduto	:= ""

	DEFINE MSDIALOG oDlg TITLE "IMPRESSAO DE ETIQUETA" FROM 000, 000 TO 400, 650					PIXEL

	@ nL1, 010 SAY "ORDEM DE PRODUCAO"								OF oDlg							PIXEL
	@ nL2, 090 MSGET oGet1 VAR cOper				SIZE 060, 012 	OF oDlg F3 "SC2SB1"				PIXEL Valid RetPrd( cOper )
	@ nL2, 160 MSGET oGet1 VAR cProduto				SIZE 130, 012 	OF oDlg 						PIXEL When .F.

	nL1 +=20
	nL2 +=20
	@ nL1, 010 SAY "QTD PRODUTOS"									OF oDlg							PIXEL
	@ nL2, 090 MSGET oGet1 VAR nQtdPrd				SIZE 060, 012 	OF oDlg Picture "@E 99999" 		PIXEL

	nL1 +=20
	nL2 +=20
	@ nL1, 010 SAY "Responsavel 1"									OF oDlg							PIXEL
	@ nL2, 090 MSGET oGet1 VAR cResp1				SIZE 060, 012 	OF oDlg F3 "ZAENOM"				PIXEL Valid RetRes( cResp1 , 1 )
	@ nL2, 160 MSGET oGet1 VAR cNmResp1				SIZE 130, 012 	OF oDlg 						PIXEL When .F.

	nL1 +=20
	nL2 +=20
	@ nL1, 010 SAY "Responsavel 2"									OF oDlg							PIXEL
	@ nL2, 090 MSGET oGet1 VAR cResp2				SIZE 060, 012 	OF oDlg F3 "ZAENOM"				PIXEL Valid RetRes( cResp1 , 2 )
	@ nL2, 160 MSGET oGet1 VAR cNmResp2				SIZE 130, 012 	OF oDlg 						PIXEL When .F.

	nL1 +=20
	nL2 +=20
	@ nL1, 010 SAY "QTD ETIQUETAS"									OF oDlg							PIXEL
	@ nL2, 090 MSGET oGet1 VAR nQtdEtq				SIZE 060, 012 	OF oDlg Picture "@E 99999" 		PIXEL

	nL1 +=20
	@ nL1, 060 BUTTON oButton1 PROMPT "IMPRESSAO" 	SIZE 060, 020 	OF oDlg 						PIXEL;
		ACTION Processa({|| ImprEtiq( cOper , nQtdPrd , cResp1 , cResp2 , nQtdEtq ) },OemToAnsi("Processando Arquivo..."))

	ACTIVATE MSDIALOG oDlg CENTERED

	SA1->(DbCloseArea())
	SB1->(DbCloseArea())
	SC2->(DbCloseArea())

	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aAreaSC2)

Return
//===================================================================================================================================================================================================================================
//===================================================================================================================================================================================================================================
Static Function RetPrd( cOper )

	Local lRet	:= .F.

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If SC2->( DbSeek( xFilial("SC2") + cOper ) )

		DbSelectArea("SB1")
		SB1->( DbSetOrder(1))
		If SB1->( DbSeek(xFilial("SB1") + SC2->C2_PRODUTO ) )
			cProduto	:= SB1->B1_COD + " - " + SB1->B1_DESC
			lRet		:= .T.

		Else
			cProduto	:= "PRODUTO DA OP NAO CADASTRADO"

		Endif

	Else
		cProduto	:= "OP NAO LOCALIZADA"

	Endif

Return lRet
//===================================================================================================================================================================================================================================
//===================================================================================================================================================================================================================================
Static Function RetRes( cResp , nOp )

	DbSelectArea("ZAE")
	ZAE->(DbSetOrder(1))
	If ZAE->( DbSeek( xFilial("ZAE") + cResp ) )

		If nOp == 1
			cNmResp1	:= Alltrim(Upper(ZAE->ZAE_NOME))

		Else
			cNmResp2	:= Alltrim(Upper(ZAE->ZAE_NOME))

		ENdif

	Endif

Return .T.
//===================================================================================================================================================================================================================================
//===================================================================================================================================================================================================================================
Static Function ImprEtiq( cOper , nQtdPrd , cResp1 , cResp2 , nQtdEtq ) 

	Local cImpres	:= SuperGetMV("AL_IMPET99",.F.,"ELTRON")
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSA7	:= SA7->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSC2	:= SC2->(GetArea())
	Local cPorta	:= "LPT1"
	Local cRazaoCli	:= ""
	Local cCliente	:= ""
	Local cCodProd  := ""
	Local cDesc		:= ""
	Local cLote		:= ""
	Local i

	Default dData	:= Stod("")
	Default cOper	:= ""
	Default cProd	:= ""
	Default cResp1	:= ""
	Default cResp2	:= ""
	Default nQtdPrd	:= 0
	Default nQtdEtq	:= 0

	IF !Empty(cResp2)
		cRespon	:= Alltrim(cResp1) + " / " + Alltrim(cResp2)

	Else
		cRespon	:= Alltrim(cResp1)

	Endif

	cQtdPrd		:= cValToChar(nQtdPrd)

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	IF !DbSeek(xFilial("SC2") + Alltrim(cOper))
		Alert("OP NAO ENCONTRADA")
		Return

	Endif

	cCodProd	:= Alltrim(SC2->C2_PRODUTO)
	cLote		:= Alltrim(SC2->C2_NUM)

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSeek(xFilial("SB1") + SC2->C2_PRODUTO)
	cDesc	:= Alltrim(SB1->B1_DESC)
	cCodbar	:= Alltrim(SB1->B1_CODBAR)

	DbSelectArea("SA7")
	SA7->(DbSetOrder(2))
	If SA7->(DbSeek(xFilial("SA7") + SC2->C2_PRODUTO))

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1") + SA7->A7_CLIENTE))

			If SA7->A7_XIMPETQ == "S"
				cCliente	:= StrTran(Upper(Alltrim(SA1->A1_NOME)),'.',' ')
				nPos		:= At( ' ' , cCliente ) - 1
				cCliente	:= Upper(FwNoAccent(SubStr( cCliente , 1 , nPos )))

			Else
				cRazaoCli	:= FwNoAccent(Upper(Alltrim(SA1->A1_NOME)))

			Endif

		Endif

	Endif
	/* CONEXAO COM A IMPRESSORA */
	MscBPrinter( cImpres , cPorta , , , .F. )

	FOR i := 1 TO nQtdEtq STEP 1

		MscBLoadGrf("SIGA.PCX")
		MscBInfoEti("Etiqueta Produto/Cliente","ETIQUETA")
		MscBBegin(01,03)

		MscBBox(03	,02,98,48,4)	//	BOX 01
		MscBBox(86	,48,98,39,4)	//	FIFO

		MscBLineV(65,02,48,4)		//	LINHA VERTICAL SEPARAÇÃO

		MscBLineH(03,12,98,4) 		//	LINHA 1
		MscBLineH(03,28,98,4) 		//	LINHA 2
		MscBLineH(03,38,65,4) 		//	LINHA 3

	 	/* INFORMACOES ESQUERDA*/
		MscBSay(	04,06,cRazaoCli											,"N","1","1,0")
		MscBSay(	04,14,"COD PRODUTO"										,"N","2","1,0")
		MscBSay(	04,18,cCodProd											,"N","4","2,2")
		MscBSay(	04,30,"DESCRICAO / DESCRIPTION"							,"N","2","1,0")
		MscBSay(	04,34,cDesc												,"N","3","1,0")
		MscBSay(	04,39,"LOTE / CHARGE: " + cLote + "/ RESP: " + cRespon	,"N","1","1,0")
		MscBSayBAR(	06,42,(cCodbar)											,"N","MB07",4,.F.,.F.,,,3,1)

	 	/* INFORMACOES DIREITA*/
		If Empty(cCliente)
			MscBSay(68,06,"PKS PLASTICOS"									,"N","4","1,0")
		Else
			MscBSay(68,06,cCliente											,"N","4","1,0")
		Endif
		MscBSay(	66,14,"QUANTIDADE / QUANTITY"							,"N","2","1,0")
		MscBSay(	67,18,cQtdPrd											,"N","4","2,2")
		MscBSay(	66,30,"DATA: " + Dtoc(Date())							,"N","2","1,0")
		MscBSay(	66,36,"HORA:"											,"N","2","1,0")
		MscBSay(	85,40,"FIFO"											,"R","2","1,0")

		MscBEnd()

	NEXT

	MscBClosePrinter()

	SA1->(DbCloseArea())
	SA7->(DbCloseArea())
	SB1->(DbCloseArea())
	SC2->(DbCloseArea())

	RestArea(aAreaSA1)
	RestArea(aAreaSA7)
	RestArea(aAreaSB1)
	RestArea(aAreaSC2)

Return
//======================================================================================================================================================================================================================== 
//	U_DBGPKS10
//======================================================================================================================================================================================================================== 
User Function DBGPKS10()

	RpcSetType(3)
	RpcSetEnv('01','01')

	U_ETQPKS10()

	RpcClearEnv()

Return
