#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Colors.ch"
#include "AP5MAIL.CH""


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PKS04A01  ºAutor  ³FABRICIO E. RECHE   º Data ³  11/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Pré-cadastro de produtos utilizado pela engenharia        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque - SIGAEST                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PKS04A01()

	Local cAlias := "SB1"

	Private aRotina := {}
	Private cCadastro := "Pré-Cadastro de Produto"

	AADD(aRotina,{"Pesquisar" , "axPesqui"	, 0, 1})
	AADD(aRotina,{"Visualizar", "U_PKS4A1GT", 0, 2})
	AADD(aRotina,{"Incluir" 	, "U_PKS4A1GT", 0, 3})
	AADD(aRotina,{"Alterar" 	, "U_PKS4A1GT", 0, 4})
	AADD(aRotina,{"Excluir" 	, "U_PKS4A1GT", 0, 5})

	DbSelectArea(cAlias)
	DbSetOrder(1)
	MBrowse(,,,,cAlias)

Return

User Function PKS4A1GT(cAlias,nReg,nOpc)

	Local cOpcao 		:= ""
	Local cConteudo 	:= ""
	Local cEmail		:= SuperGetMV("MV_MAILPR",.F.,"viviane.santos@azzobrasil.com.br;diogo@drftecnologia.com.br;drf.diogo@tigre.com")
	Local cCampos 		:= "B1_TIPO,B1_COD,B1_DESC,B1_GRUPO,B1_UM,B1_LOCPAD,B1_MSBLQL,B1_REVISA,B1_CODBAR"
	Local aCampos 		:= Separa(cCampos, ",")
	Local lCond			:= .T.
	Local nX			:= 0
	Local nOpct			:= 0
	Local nCol			:= 15
	Local nLin			:= 45
	Local oDlg

	Private cTipo		:= IIF(nOpc == 3, Space(TamSx3("B1_TIPO")[1])				, SB1->B1_TIPO)
	Private cGrupo		:= IIF(nOpc == 3, Space(TamSx3("B1_GRUPO")[1])			, SB1->B1_GRUPO)
	Private cCod		:= IIF(nOpc == 3, NextNumero("SB1",IndexOrd(),"B1_COD", .T.)	, SB1->B1_COD)
	Private cDesc		:= IIF(nOpc == 3, Space(TamSx3("B1_DESC")[1])				, SB1->B1_DESC)
	Private cUm 		:= IIF(nOpc == 3, Space(TamSx3("B1_UM")[1])					, SB1->B1_UM)
	Private cLocPad		:= IIF(nOpc == 3, Space(TamSx3("B1_LOCPAD")[1])				, SB1->B1_LOCPAD)
	Private cMSBLQL		:= IIF(nOpc == 3, Space(TamSx3("B1_MSBLQL")[1])				, SB1->B1_MSBLQL)
	Private cRevisa		:= IIF(nOpc == 3, Space(TamSx3("B1_REVISA")[1])				, SB1->B1_REVISA)
	Private cCodBar		:= IIF(nOpc == 3, Space(TamSx3("B1_CODBAR")[1])				, SB1->B1_CODBAR)

	cOpcao := IIF(nOpc == 2, "Visualizar", IIF(nOpc == 3, "Incluir", IIF(nOpc == 4,"Alterar", "Excluir"))) + " Produto " + IIF(nOpc == 4 .Or. nOpc == 5, SB1->B1_DESC, "")


	DEFINE MSDIALOG oDlg TITLE cOpcao FROM 0,0 TO 355,600 PIXEL

	oDlg:lMaximized := .T.

	//Permite a edição apenas quando não estiver visualizando ou excluindo
	lCond := nOpc <> 2 .And. nOpc <> 5

	CriaCampo(@oDlg,nLin,nCol,@cTipo,aCampos[1],,lCond)
	CriaCampo(@oDlg,nLin,nCol+80,@cCod,aCampos[2],,nOpc == 3)
	CriaCampo(@oDlg,nLin,nCol+160,@cDesc,aCampos[3],,nOpc == 3)

	nLin += 35

	CriaCampo(@oDlg,nLin,nCol,@cGrupo,aCampos[4],,lCond)
	CriaCampo(@oDlg,nLin,nCol+80,@cUm,aCampos[5],,lCond)
	CriaCampo(@oDlg,nLin,nCol+160,@cLocPad,aCampos[6],,lCond)

	nLin += 35

	CriaCampo(@oDlg,nLin,nCol,@cMSBLQL,aCampos[7],,lCond)
	CriaCampo(@oDlg,nLin,nCol+80,@cRevisa,aCampos[8],,lCond)
	CriaCampo(@oDlg,nLin,nCol+160,@cCodBar,aCampos[9],,lCond)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(nOpc != 5 .And. PKSVALID(),(nOpct := 1,oDlg:End()),)},{|| nOpct := 2, oDlg:End()})

	If nOpct == 1 .And. nOpc <> 2

		DbSelectArea("SB1")
		DbSetOrder(1)

		If nOpc <> 3
			DbSeek(xFilial("SB1")+cCod)
		EndIf

		RecLock("SB1", nOpc == 3)

		If nOpc == 5

			DbDelete()

		Else

			SB1->B1_FILIAL := xFilial("SB1")

			For nX := 1 To Len(aCampos)
				&("SB1->"+aCampos[nX]) := &("c"+SubStr(aCampos[nX],4))
			Next nX

		EndIf

		MsUnlock()

		//Complemento do produto
		DbSelectArea("SB5")
		DbSetOrder(1)

		If nOpc <> 3
			DbSeek(xFilial("SB5")+cCod)
		EndIf

		RecLock("SB5", nOpc == 3)

		If nOpc == 5
			DbDelete()
		Else
			SB5->B5_FILIAL := xFilial("SB5")
			SB5->B5_COD := cCod
		EndIf

		MsUnLock()

		EnvMail(cCod)

	EndIf

Return

Static Function PKSVALID()

	Local lRet := .T.
	Local aVer := {cTipo,cCod,cDesc,cUm,cLocPad,cMSBLQL,cRevisa,cGrupo}
	Local nX := 0

	For nX := 1 To Len(aVer)

		lRet := NaoVazio(aVer[nX])

		If !lRet
			nX := Len(aVer) + 1
		EndIf

	Next nX


Return lRet

Static Function CriaCampo(oParent,nLin, nCol, uConteudo, cTitulo, _cPict, _lBlock, _bValid, _cF3)

	Local cF3
	Local cPict
	Local bValid
	Local oCampo
	Local nWidth := 96
	Local nHeight:= 09
	Local nDif	 := 10
	Local aCombo := {}

	bValid 	:= IIF(_bValid 	== Nil, ""	, _bValid	)
	cF3 		:= IIF(_cF3 		== Nil, ""	, _cF3		)
	cPict 	:= IIF(_cPict 	== Nil, ""	, _cPict	)

	//Se não for caracter ou ser pequeno
	If ValType(uConteudo) <> "C"  .Or. Len(uConteudo) < 20
		nWidth := 50
	EndIf

	If cTitulo != "B1_CODBAR"
		bValid := {|| NaoVazio(@uConteudo)}
	EndIf

	If alltrim(cTitulo) == "B1_COD"
		bValid := {|| ExistChav("SB1", @uConteudo)}
	EndIf

	DbSelectArea("SX3")
	DbSetOrder(2) //X3_CAMPO

	If  DbSeek(cTitulo)

		If Empty(cF3)
			cF3 := AllTrim(SX3->X3_F3)
		EndIf

		If Empty(bValid)
			bValid := &("{|| " + SX3->X3_VALID + " }")
		EndIf

		If Empty(cPict) .And. !Empty(SX3->X3_PICTURE)
			cPict := SX3->X3_PICTURE
		EndIf

		If !Empty(SX3->X3_CBOX)
			aCombo := Separa(SX3->X3_CBOX, ";")
		EndIf

	EndIf

	@ nLin,nCol SAY RetTitle(cTitulo) OF oParent PIXEL COLOR CLR_HBLUE

	/*If Len(aCombo) > 0
		@ nLin+nDif,nCol COMBOBOX oCampo VAR uConteudo ITEMS aCombo SIZE nWidth,nHeight OF oParent PIXEL When IIF(_lBlock <> Nil, _lBlock, .T.)
	Else
		@ nLin+nDif,nCol MSGET oCampo VAR uConteudo SIZE nWidth,nHeight OF oParent PIXEL COLOR CLR_BLUE When IIF(_lBlock <> Nil, _lBlock, .T.) Valid Eval(bValid) Picture cPict F3 cF3 HasButton
	EndIf*/
	If Len(aCombo) > 0
		@ nLin+nDif,nCol COMBOBOX oCampo VAR uConteudo ITEMS aCombo SIZE nWidth,nHeight OF oParent PIXEL When IIF(_lBlock <> Nil, _lBlock, .T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ MCS - Tratamento pois o READVAR da função A010CodBar estão lendo o uConteuod, causando error.log                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTitulo <> 'B1_CODBAR'
		@ nLin+nDif,nCol MSGET oCampo VAR uConteudo SIZE nWidth,nHeight OF oParent PIXEL COLOR CLR_BLUE When IIF(_lBlock <> Nil, _lBlock, .T.) Valid Eval(bValid) Picture cPict F3 cF3 HasButton
	Else 
		@ nLin+nDif,nCol MSGET oCampo VAR uConteudo SIZE nWidth,nHeight OF oParent PIXEL COLOR CLR_BLUE When IIF(_lBlock <> Nil, _lBlock, .T.) Valid MCSCODBAR(uConteudo,.T.) Picture cPict F3 cF3 HasButton
	EndIf

Return oCampo

Static Function PKSEMAIL(cProduto, cEmail)

	Local oProcess
	Local oHtml
	Local nInd := 0
	Local cStatus := OemToAnsi("001011")
	Local cProcess:= OemToAnsi("001010")
	Local cFileHtm:= AllTrim(getmv("MV_WFDIR"))+"\PKS04A01.htm"

	oProcess:= TWFProcess():New(cProcess,OemToAnsi("Cadastro de Pré-Produto"))
	oProcess:NewTask(cStatus,cFileHtm)
	oProcess:cSubject	:= "Cadastro de Pre-Produto"
	oProcess:cTo 		:= cEmail

	Conout("Envio de e-mail para " + cEmail)

	oHtml		:= oProcess:oHtml

	//Altera o conteudo no htm enclosurado pelos %%
	oHtml:ValByName("USUARIO"	, AllTrim(cUserName))
	oHtml:ValByName("PRODUTO"	, cProduto)
	oHtml:ValByName("DESCPRO"	, Posicione("SB1",1,xFilial("SB1")+cProduto, "B1_DESC"))
	oHtml:ValByName("FILIAL"	, xFilial("SB1"))

	//Efetua o envio do e-mail
	oProcess:Start()
	oProcess:Finish()

Return

/*/{Protheus.doc} MCSCODBAR
Copia da function padrão da Totvs para tratar a validação do codbar na rotina de cadastro de produtos customizada
devido a error.log no tamsx3
@type function
@version  
@author MCS Tecnologia
@since 5/22/2026
@param cCodBar, character, param_description
@param lMVACDVLBA, logical, param_description
@return variant, return_description
/*/
Static Function MCSCODBAR(cCodBar,lMVACDVLBA)

	Local lRet       := .T.
	Local nTamB1CBar 
	Local lVldCodBar := SuperGetMV("MV_ACDVLBA",.F.,.T.)
	Local cCampo 	   := "B1_CODBAR"

	Default lMVACDVLBA := .T.

	 nTamB1CBar:= TamSX3(cCampo)[1]

	If ((lMVACDVLBA .and. cCampo == 'B1_CODGTIN') .Or. (lVldCodBar .and. cCampo == 'B1_CODBAR')) .And. (Len(AllTrim(cCodBar)) > nTamB1CBar - 1)
		// "B1_CODBAR" ### "Digite no maximo " ### 15 ## " caracteres, pois o último dígito do código de barras "
		//                                            "será preenchido automaticamente (dígito verificador)."
		Aviso("Digite no maximo  ### 15 ##  caracteres, pois o último dígito do código de barras","será preenchido automaticamente (dígito verificador)." + AllTrim(STR(nTamB1CBar - 1)) )
		lRet := .F.
	EndIf

Return lRet

/*/{Protheus.doc} EnvMail
Novo envio de Email
@type function
@version  
@author MCS Tecnologia
@since 5/22/2026
@param cProduto, character, param_description
@return variant, return_description
/*/
Static Function EnvMail(cProduto)

    Local lResulConn := .T.
	Local lResulSend := .T.
	Local cError 	 := ""
	Local lResult 	 := .T.
	Local cServer 	 := AllTrim(GetMV("MV_RELSERV"))
	Local cEmail 	 := AllTrim(GetMV("MV_RELACNT"))   //EMAIL PADRAO ENVIO DE EMAIL - CRIAR PARAMETRO 	- MV_MAILCOB
	Local cPara		 := SuperGetMV("MV_MAILPR",.F.,"viviane.santos@azzobrasil.com.br;diogo@drftecnologia.com.br;drf.diogo@tigre.com")
	Local cPass  	 := AllTrim(GetMV("MV_RELPSW"))    //SENHA DO NOVO EMAIL FINANCEIRO - CRIAR PARAMETRO -
	Local lRelauth   := GetMv("MV_RELAUTH")
	Local cDe 		 := cEmail
	Local cCc 		 := ""
	Local cDescrM 	 := ''
	Local _aRetUser  := {}
	Local cAssunto 	 := "Cadastro de Pre-Produto" 
	Local cMsg 		 := Space(200)
	Local _lJob 	 := .T.
	Local aDest 	 := {}
	Local cDest 	 := ""
	Local aAnexo	 := {}
	Local cLogo		 :=""
	Local xHtml      := ""

	cPara := StrTran(cPara,",",";")
	cPara := ALLTRIM(LOWER(cPara))	

	// Para compactar arquivo
		lCompacta := .T.
	//Corpo do E-mail
		
	cAssunto := "Cadastro de Pre-Produto"
	
	xHtml := "<!DOCTYPE html>" + chr(13)
	xHtml += "<html lang='pt-br'>" + chr(13)
	xHtml += "<head>" + chr(13)
	xHtml += "	<title>Cadastro de pré-produto</title>" + chr(13)
	xHtml += "</head>" + chr(13)
	xHtml += "<body>" + chr(13)
	xHtml += "	<h2>O usuario "+AllTrim(cUserName)+" cadastrou o produto:</h2>" + chr(13)
	xHtml += "	<ul>" + chr(13)
	xHtml += "		<li> Empresa/Filial - "+FwCodFil()+"</li>" + chr(13)
	xHtml += "		<li> Produto - "+AllTrim(cProduto)+"</li>" + chr(13)
	xHtml += "		<li> Descricao - "+Posicione("SB1",1,xFilial("SB1")+cProduto, "B1_DESC")+"</li>" + chr(13)
	xHtml += "	</ul>" + chr(13)
	xHtml += "	<p>E-mail enviado automaticamente pela rotina de pré cadastro de produto</p>" + chr(13)
	xHtml += "</body>" + chr(13)
	xHtml += "</html>" + chr(13)

	CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
		
		If !lResulConn
			GET MAIL ERROR cError
			If _lJob
				ConOut(Padc("Falha na conexao "+cError,80))
			Else
				ConOut("Falha na conexao "+cError)
			Endif
			Return(.F.)
		Endif
		
		If lRelauth
			lResult := MailAuth(Alltrim(cEmail), Alltrim(cPass))
			If !lResult
				nA := At("@",cEmail)
				cUser := If(nA>0,Subs(cEmail,1,nA-1),cEmail)
				lResult := MailAuth(Alltrim(cUser), Alltrim(cPass))
			Endif
		Endif
		
		If lResult
			SEND MAIL FROM cDe TO cPara CC cCC SUBJECT cAssunto BODY  xHtml ATTACHMENT  RESULT lResulSend
			If !lResulSend
				GET MAIL ERROR cError
				If _lJob
					ConOut(Padc("Falha no Envio do e-mail "+cError,80))
				Else
					ConOut("Falha no Envio do e-mail " + cError)
				Endif
			Endif
		Else
			If _lJob
				ConOut(Padc("Falha na autenticação do e-mail: "+cError,80))
			Else
				ConOut("Falha na autenticação do e-mail:" + cError)
			Endif
		Endif
		
		DISCONNECT SMTP SERVER
		
		IF lResulSend
			If _lJob
				ConOut(Padc("E-mail enviado com sucesso",80))
			Else
				ConOut("E-mail com erro: " + cError)
			Endif
		ENDIF
	
Return lResulSend
