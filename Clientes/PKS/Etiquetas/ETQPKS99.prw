#Include "Protheus.ch"

/*/{Protheus.doc} U_ETQPKS99
Etiqueta de produto Nova
@type User Function
@author Mcs Tecnologia
@since 12/05/2025
/*/

/*/
Consulta Padrao: ETQPKS99
/*/

User Function ETQPKS99()

	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSC2	:= SC2->(GetArea())
	Local cOper		:= Space(6)
	Local nQtd		:= 0

	Private aRet	:= { Space(6) , 0 }

	DEFINE MSDIALOG oDlg TITLE "IMPRESSAO DE ETIQUETA" FROM 000, 000 TO 200, 400					PIXEL

	@ 013, 010 SAY "ORDEM DE PRODUCAO"								OF oDlg							PIXEL
	@ 010, 090 MSGET oGet1 VAR cOper				SIZE 060, 012 	OF oDlg F3 "SC2"				PIXEL

	@ 033, 010 SAY "QUANTIDADE"										OF oDlg							PIXEL
	@ 030, 090 MSGET oGet1 VAR nQtd					SIZE 060, 012 	OF oDlg Picture "@E 99999" 		PIXEL

	@ 060, 060 BUTTON oButton1 PROMPT "IMPRESSAO" 	SIZE 060, 020 	OF oDlg 						PIXEL;
		ACTION Processa({|| ImprEtiq(cOper,nQtd) },OemToAnsi("Processando Arquivo..."))

	ACTIVATE MSDIALOG oDlg CENTERED

	SA1->(DbCloseArea())
	SB1->(DbCloseArea())
	SC2->(DbCloseArea())

	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aAreaSC2)

Return
/*/{Protheus.doc} ImprEtiq
Efetiva a impressão 
@type function
@version  
@author MCS Tecnologia
@since 2/5/2026
@param cOper, character, param_description
@param nQtd, numeric, param_description
@return variant, return_description
/*/
Static Function ImprEtiq( cOper , nQtd )

	Local cImpres	:= SuperGetMV("AL_IMPET99",.F.,"ELTRON")
	Local cFabric	:= Padc("Fabricado no Brasil",25)
	Local cPorta	:= "LPT1"
	Local cMaterial	:= ""
	Local cCliente	:= ""
	Local cCodbar	:= ""
	Local cCNPJ		:= ""
//	Local nTam		:= 25
	Local i

	Default cOper	:= ""
	Default nQtd	:= 0

	DbSelectArea("SC2")
	SC2->( DbSetOrder(1) )
	IF !SC2->( DbSeek(xFilial("SC2") + cOper ) )
		Alert("OP NAO ENCONTRADA")
		Return

	Endif

	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek(xFilial("SB1") + SC2->C2_PRODUTO ) )
	cCodDesc	:= Alltrim(SB1->B1_COD) + "-" + Alltrim(SB1->B1_DESC)
	cCodbar		:= Alltrim(SB1->B1_CODBAR)

	nTam		:= 025
	If Empty( SubStr( cCodDesc	, 25 , 1 ) ) .And. !(Empty( SubStr( cCodDesc	, 26 , 1 ) )) .And. Empty( SubStr( cCodDesc	, 27 , 1 ) )
		nTam	:= 026

	Endif

	cProd1		:= Padc( Alltrim( SubStr( cCodDesc , 01		, nTam ) ) , nTam )
	cProd2		:= Padc( Alltrim( SubStr( cCodDesc , nTam+1	, nTam ) ) , nTam )

	cMaterial	:= Material( SB1->B1_COD )

	If Empty(cCodbar)
		MsgInfo("Produto com codigo de barra vazio: " + SB1->B1_COD)
		Return

	Endif

	MscBPrinter( cImpres , cPorta , , , .F. )
	MscBChkStatus(.F.)

	DbSelectArea("SA7")
	SA7->(DbSetOrder(2))
	If SA7->( DbSeek( xFilial("SA7") + SB1->B1_COD ) )

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->( DbSeek( xFilial("SA1") + SA7->A7_CLIENTE + SA7->A7_LOJA ) )

			cCliente	:= StrTran(Upper(Alltrim(SA1->A1_NOME)),'.',' ')
			nPos		:= At( ' ' , cCliente ) - 1
			cCliente	:= Padc(Upper(FwNoAccent(SubStr( cCliente , 1 , nPos ))),25)

			If SA1->A1_PESSOA = 'J'
				cCNPJ	:= Transform( SA1->A1_CGC, "@R 99.999.999/9999-99")
			Else
				cCNPJ	:= Transform( SA1->A1_CGC, "@R 999.999.999-99")

			Endif
			cCNPJ		:= Padc("CNPJ: " + cCNPJ,25)

		Endif

	Endif

	nSaldo := 0

	FOR i := 1 TO nQtd

		If nSaldo >= nQtd
			MscBEnd()
			Exit

		Endif

		MscBBegin( 1 , 1 )

//		POSICAO Y DA LINHA
		nL1	:= 2.0
		nL2	:= nL1 + 1.8
		nL3	:= nL2 + 1.8
		nL4	:= nL3 + 1.8
		nL5	:= nL4 + 1.8
		nL6	:= nL5 + 1.8
		nL7	:= nL6 + 1.8

//		POSICAO X COLUNA 1
		nCL1	:= 01.0
		nCLA	:= 04.0

//		POSICAO X COLUNA 2
		nCL2	:= 35.0
		nClB	:= 38.0

//		POSICAO X COLUNA 3
		nCL3	:= 69.0
		nCLC	:= 72.0

//		COLUNA 1		
		IF nSaldo <= nQtd
			/*MscBSay( 	nCL1	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL1	, nL2	, cProd2		,"N","1","1", , , , , .T. )
			MscBSayBar(	nCLA	, nL3	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)
			MscBSay(	nCL1	, nL4	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL5	, cCliente		,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL6	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL7	, cMaterial		,"N","1","1", , , , , .T. )*/

			MscBSay( 	nCL1	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL1	, nL2	, cProd2		,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL3	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL4	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	05.0	, nL5	, cMaterial		,"N","1","1", , , , , .T. )
			MscBSay(	nCL1	, nL6	, cCliente		,"N","1","1", , , , , .T. )
			MscBSayBar(	nCLA	, nL7	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)

			nSaldo++

		Endif

		If nSaldo >= nQtd
			MscBEnd()
			Exit

		Endif

//		COLUNA 2 
		IF nSaldo <= nQtd
			/*MscBSay( 	nCL2	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL2	, nL2	, cProd2		,"N","1","1", , , , , .T. )
			MscBSayBar(	nCLB	, nL3	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)
			MscBSay(	nCL2	, nL4	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL2	, nL5	, cCliente		,"N","1","1", , , , , .T. )
			MscBSay(	nCL2	, nL6	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	nCL2	, nL7	, cMaterial		,"N","1","1", , , , , .T. )*/
			
			MscBSay( 	nCL2	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL2	, nL2	, cProd2		,"N","1","1", , , , , .T. )		
			MscBSay(	nCL2	, nL3	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL2	, nL4	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	39.0	, nL5	, cMaterial		,"N","1","1", , , , , .T. )
			MscBSay(	nCL2	, nL6	, cCliente		,"N","1","1", , , , , .T. )	
			MscBSayBar(	nCLB	, nL7	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)
			nSaldo++

		Endif

		If nSaldo >= nQtd
			MscBEnd()
			Exit

		Endif

//		COLUNA 3
		IF nSaldo <= nQtd
			/*MscBSay( 	nCL3	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL3	, nL2	, cProd2		,"N","1","1", , , , , .T. )
			MscBSayBar(	nCLC	, nL3	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)
			MscBSay(	nCL3	, nL4	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL5	, cCliente		,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL6	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL7	, cMaterial		,"N","1","1", , , , , .T. )*/

			MscBSay( 	nCL3	, nL1	, cProd1		,"N","1","1", , , , , .T. )
			MscBSay( 	nCL3	, nL2	, cProd2		,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL3	, cCNPJ			,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL4	, cFabric		,"N","1","1", , , , , .T. )
			MscBSay(	73.0   	, nL5	, cMaterial		,"N","1","1", , , , , .T. )
			MscBSay(	nCL3	, nL6	, cCliente		,"N","1","1", , , , , .T. )
			MscBSayBar(	nCLC	, nL7	, cCodbar		,"N","MB04",4.0,.F.,.T.,.F.,,1.5,1.5,.F.,.F.,,.F.)
			

			nSaldo++

		Endif

		If nSaldo >= nQtd
			MscBEnd()
			Exit

		Endif

		MscBEnd()

	Next

	MscBClosePrinter()

Return
/*/{Protheus.doc} Material
Busca o material para buscar na etiqueta
@type function
@version  
@author MCS Tecnologia
@since 2/5/2026
@param _cProduto, variant, param_description
@return variant, return_description
/*/
Static Function Material( _cProduto )

	Local cMaterial		:= ""

	Default _cProduto	:= ""

	DbSelectArea( "ZD8" )
	ZD8->( DbSetOrder(1))
	If 	ZD8->( DbSeek( xFilial( "ZD8" ) + _cProduto ) )

		If !Empty(ZD8->ZD8_MAT2)
			cMaterial	:= "Material: " + ZD8->ZD8_MAT1 + " e " + ZD8->ZD8_MAT2

		Else
			cMaterial	:= "Material: " + ZD8->ZD8_MAT1

		Endif

	Endif

Return cMaterial
//======================================================================================================================================================================================================================== 
//	U_DBGPKS99
//======================================================================================================================================================================================================================== 
User Function DBGPKS99()

	RpcSetType(3)
	RpcSetEnv('01','01')

	U_ETQPKS99()

	RpcClearEnv()

Return
