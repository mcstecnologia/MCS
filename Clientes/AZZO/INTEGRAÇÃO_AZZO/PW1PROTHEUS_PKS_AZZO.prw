#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PW1PROTHEUSºAutor³NovaisIT-(11)3522-1304 ºData ³  16/05/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para integracao do sistem PW1 x Protheus          º±±
±±º          ³ Exporta Ordens de producao com dados de producao           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PW1INTEG()

Local oBitmap1
Local oButton1
//Local oButton2
Local oButton3
Static oDlg

cFecha:= "0"

DEFINE MSDIALOG oDlg TITLE "INTEGRAÇÃO PW1 X PROTHEUS" FROM 000, 000  TO 285, 300 COLORS 0, 16777215 PIXEL

@ 085, 017 BUTTON oButton1 PROMPT "EXPORTAR ORDEM DE PRODUÇÃO" SIZE 119, 022 OF oDlg ACTION ExpPw1() PIXEL
@ 112, 040 BUTTON oButton3 PROMPT "SAIR" SIZE 080, 022 OF oDlg ACTION Fecha() PIXEL
@ 005, 005 BITMAP oBitmap1 SIZE 140, 070 OF oDlg FILENAME "C:\Logos\Logo PW-1 trans.png" NOBORDER ADJUST PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If cFecha == "1"
	Return()
EndIf

Return

Static Function Fecha()
cFecha := "1"
oDlg:End()
Return

Static Function ExpPw1()

	Local aOP	 	:= {}
	Local cRoteiro  := ""
	Local xProd   	:= Space(TamSx3("B1_COD")[1])
	oDlg:End()

	cPerg:= "EXPORTRPW1"

	_fSX1Pergs(cPerg)

	Pergunte(cPerg)

	cOpDe:= Alltrim(mv_par01)
	cOpAte:= Alltrim(mv_par02)
	lCont:= .F.

	cTexto:="cdOrdemProducao;cdFerramenta;descFerramenta;cdEstrutura;cdProduto;descProduto;nomeCliente;cdMaquina;taxaProducao;tipoTaxaProducao;pecasCiclo;pontosPeca;dtInicio;dtEntrega;qtdPecas;complemento1;complemento2;complemento3"

	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2")+Alltrim(mv_par01)))

	SB1->(DbSetOrder(1))

	While ! SC2->(EOF()) .AND. (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) >= Alltrim(mv_par01) .AND. (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <= Alltrim(mv_par02)

		cOpMae   := ""
		cComp1   :=""
		cComp2   :=""
		lComp1   := .F.
		cOp      := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		cOpMae   := Alltrim(SC2->C2_OPMAE)
		cProd    := Alltrim(SC2->C2_PRODUTO)
		cRoteiro := AllTrim(SC2->C2_ROTEIRO)
		nQtd     := CVALTOCHAR(SC2->C2_QUANT)
		cDataIni := SUBSTR(DTOS(SC2->C2_DATPRI),1,4)+"-"+SUBSTR(DTOS(SC2->C2_DATPRI),5,2)+"-"+SUBSTR(DTOS(SC2->C2_DATPRI),7,2)+ "-00:00"
		cDataEnt := SUBSTR(DTOS(SC2->C2_DATPRF),1,4)+"-"+SUBSTR(DTOS(SC2->C2_DATPRF),5,2)+"-"+SUBSTR(DTOS(SC2->C2_DATPRF),7,2)+ "-00:00"
		lOk      := .T.
		cXml     := ""
		cNomeCli := ""

		SB1->(DbSeek(xFilial("SB1")+cProd))
		cDescProd := Alltrim(LEFT(SB1->B1_DESC,100))

		SG2->(DbSetOrder(1))
		cProd := Stuff(xProd,1,Len(cProd),Alltrim(cProd))
		SG2->(DbSeek(xFilial("SG2")+cProd+cRoteiro)) //MCS alteração pois sem informar o roteiro o sistema estava buscando sempre o 01

		cProd := AllTrim(cProd)

		If Alltrim(SG2->G2_PRODUTO) == cProd

			If Alltrim(SG2->G2_FERRAM) == ""
				MsgAlert("O produto " +cProd+ " - " +cDescProd+ " da OP " +cOP+ " não possui ferramenta cadastrada!!")
				lOk:= .F.
			EndIf

			If Alltrim(SG2->G2_RECURSO) == ""
				MsgAlert("O produto " +cProd+ " - " +cDescProd+ " da OP " +cOP+ " não possui maquina cadastrada!!")
				lOk:= .F.
			EndIf

			If SG2->G2_CAVIDAD == 0
				MsgAlert("O produto " +cProd+ " - " +cDescProd+ " da OP " +cOP+ " esta com cavidade 0!!")
				lOk:= .F.
			EndIf

			If SG2->G2_CICLO == 0
				MsgAlert("O produto " +cProd+ " - " +cDescProd+ " da OP " +cOP+ " esta com ciclo 0!!")
				lOk:= .F.
			EndIf

			cFerramenta:= Alltrim(SG2->G2_FERRAM)
			cMaquina   := Alltrim(SG2->G2_RECURSO)
			cCavidade  := CVALTOCHAR(SG2->G2_CAVIDAD)
			cCiclo     := CVALTOCHAR(SG2->G2_CICLO)

		Else

			MsgAlert("O produto " +cProd+ " - " +cDescProd+ " da OP " +cOP+ " não possui cadastro de Operação!!")
			//Voltar ao inicio
			lOk:= .F.

		EndIf

		If cOpMae <> "" .AND. lOk

			cQuery:= "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_OPMAE "
			cQuery+= "FROM "+RetSqlName("SC2")+" SC2 "
			cQuery+= "WHERE SC2.D_E_L_E_T_ <> '*' AND SC2.C2_OPMAE = '"+cOpMae+"' "

			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'C2SQL', .F., .T.)
			C2SQL->(DBGOTOP())

			While ! C2SQL->(EOF())
				
				If lComp1 == .T.
					cComp1+= ","
				EndIf

				cComp1+= C2SQL->C2_NUM+C2SQL->C2_ITEM+C2SQL->C2_SEQUEN
				lComp1:= .T.

				C2SQL->(DbSkip())

			EndDo

			C2SQL->(Dbclosearea())

		EndIf

		If lOk <> .F.

			SH4->(DbSetOrder(1))
			SH4->(DbSeek(xFilial("SH4")+cFerramenta))

			cDescFer:= Alltrim(LEFT(SH4->H4_DESCRI,100))

			// Prepara para WS
			cOperc		:= ""
			cEst        := ""
			cComp2      := ""

			cXml += '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:int="http://www.pw-1.net/ws/Integracao.asmx">'
			cXml += '<soap:Header/>'
			cXml += '<soap:Body>'
			cXml += '<int:ImportarOrdemProducao>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdOrdemProducao>'	+	cOp 			+'</int:cdOrdemProducao>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdOperacao>'		+ 	cOperc			+'</int:cdOperacao>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdFerramenta>'	+	cFerramenta		+'</int:cdFerramenta>'
			cXml += '<!--Optional:-->'
			cXml += '<int:descFerramenta>'	+	cDescFer		+'</int:descFerramenta>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdEstrutura>'		+	cEst			+'</int:cdEstrutura>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdProduto>'		+	cProd			+'</int:cdProduto>'
			cXml += '<!--Optional:-->'
			cXml += '<int:descProduto>'		+	cDescProd		+'</int:descProduto>'
			cXml += '<!--Optional:-->'
			cXml += '<int:nomeCliente>'		+	"PKS"			+'</int:nomeCliente>'
			cXml += '<!--Optional:-->'
			cXml += '<int:cdMaquina>'		+	cMaquina		+'</int:cdMaquina>'
			cXml += '<int:taxaProducao>'	+ 	cCiclo 			+'</int:taxaProducao>'
			cXml += '<int:tipoTaxaProducao>'+	"2"				+'</int:tipoTaxaProducao>'
			cXml += '<int:pecasCiclo>'		+	cCavidade		+'</int:pecasCiclo>'
			cXml += '<int:pontosPeca>'		+	"1"				+'</int:pontosPeca>'
			cXml += '<int:dtInicio>'		+ 	cDataIni 		+'</int:dtInicio>'
			cXml += '<int:dtEntrega>'		+ 	cDataEnt 		+'</int:dtEntrega>'
			cXml += '<int:qtdPecas>'		+	nQtd				+'</int:qtdPecas>'
			cXml += '<!--Optional:-->'
			cXml += '<int:complemento1>'	+ 	cComp1 			+'</int:complemento1>'
			cXml += '<!--Optional:-->'
			cXml += '<int:complemento2>'	+ 	cComp2 			+'</int:complemento2>'
			cXml += '<!--Optional:-->'
			cXml += '<int:complemento3></int:complemento3>'
			cXml += '</int:ImportarOrdemProducao>'
			cXml += '</soap:Body>'
			cXml += '</soap:Envelope>'
		EndIf

		IF !EMPTY(cXml)
			AADD(aOP,{cOp,cXml})
		EndIF

		SC2->(DbSkip())

		cXml	:= ""

		/* 	Murilo - MAIS i9 - 04/05/2023
			Retirado para nao gerar o arquivo CSV
		lCont:=.T.
		*/

	EndDo

	IF  len(aOP) > 0 .and. lOk
		U_ENVIPW1(aOP)
	Else 
		MSGALERT( 'Não foram processados Itens', "Integracao" )
	Endif

	/* 	Murilo - MAIS i9 - 04/05/2023
	Retirado para nao gerar o arquivo CSV
	If lCont == .T.

		If cEmpAnt =="01"
			//diretorio PKS
			Path := "\PRODWIN\"
			cArq := "EXPOP"+".CSV"
		Else
			// Diretorio Azzo
			Path := "\PRODWIN\AZZO\"
			cArq := "EXPOP"+".CSV"
		Endif

		If File(Path + cArq)
			fErase(Path+cArq)
		Endif

		If cEmpAnt =="01"
			//diretorio PKS
			Path := "\PRODWIN\"+cArq
		Else
			// Diretorio Azzo
			Path := "\PRODWIN\AZZO\"+cArq
		Endif

		MemoWrite(Path,cTexto)
		MsgAlert("Arquivo exportado com sucesso!!!")

	EndIf
	*/

Return

Static Function ImpPw1()

oDlg:End()
MsgAlert("Arquivo Importado com sucesso!!")

Return

Static Function _fSX1Pergs (cPerg)

// Selecionando SX1 para Carga
DbSelectArea("SX1") ; DbSetOrder(1)

// Produto Principal Inicial
If !DbSeek(cPerg + "01",.f.) ; RecLock("SX1",.T.)
ELSE                          ; RecLock("SX1",.F.)
ENDIF
SX1->X1_GRUPO   := cPerg                      // Localizador (Form.)
SX1->X1_ORDEM   := "01"                        // Ordem
SX1->X1_PERGUNT := "OP De ?"      // Titulo do Campo
SX1->X1_VARIAVL := "mv_ch01"                   // Variavel Microsiga (Seq.)
SX1->X1_TIPO    := "C"                         // Tipo
SX1->X1_TAMANHO := 11                          // Tamanho
SX1->X1_GSC     := "G"                         // Tipo do Campo (G-Get, C-Combo)
SX1->X1_VAR01   := "mv_par01"                  // Variavel Privada (Param. X Seq.)
SX1->X1_CNT01     := " "                       // Inicial

// Verificando Existencia
SX1->X1_F3      := "SC2"                       // Arquivo para Consulta
MsUnLock()

If !DbSeek(cPerg + "02",.f.) ; RecLock("SX1",.T.)
ELSE                          ; RecLock("SX1",.F.)
ENDIF
SX1->X1_GRUPO   := cPerg                      // Localizador (Form.)
SX1->X1_ORDEM   := "02"                        // Ordem
SX1->X1_PERGUNT := "OP Ate ?"      // Titulo do Campo
SX1->X1_VARIAVL := "mv_ch02"                   // Variavel Microsiga (Seq.)
SX1->X1_TIPO    := "C"                         // Tipo
SX1->X1_TAMANHO := 11                          // Tamanho
SX1->X1_GSC     := "G"                         // Tipo do Campo (G-Get, C-Combo)
SX1->X1_VAR01   := "mv_par02"                  // Variavel Privada (Param. X Seq.)
SX1->X1_CNT01   := " "                       // Inicial

// Verificando Existencia
SX1->X1_F3      := "SC2"                       // Arquivo para Consulta
MsUnLock()

Return

User Function VLOPMAE1()

lRet:= .T.

cOpMae  := Alltrim(M->C2_OPMAE)
cProdOp := Alltrim(M->C2_PRODUTO)
cFerrOp := ""
cProdMae:= ""
cFerrMae:= ""

If Alltrim(cOpMae) <> ""

	DbSelectArea("SC2")
	DbSetOrder(1)
	DbSeek(xFilial()+cOpMae)
	If Found()
		cProdMae:= Alltrim(SC2->C2_PRODUTO)
	Else
		MsgAlert("OP "+ cOpMae + " nao existe!!")
		Return(.F.)
	EndIf

	SG2->(DbSetOrder(1))
	SG2->(DbSeek(xFilial("SG2")+cProdOp))

	If Found()
		cFerrOp:= Alltrim(SG2->G2_FERRAM)
	Else
		MsgAlert("Produto " + cProdOp + " nao possui cadastro de operacoes, efetuar o cadastro para referenciar uma OP MAE!!!")
		lRet:= .F.
	EndIf

	SG2->(DbGoTop())
	SG2->(DbSeek(xFilial("SG2")+cProdMae))

	If Found()
		cFerrMae:= Alltrim(SG2->G2_FERRAM)
	Else
		MsgAlert("Produto " + cProdMae + " nao possui cadastro de operacoes, efetuar o cadastro para referenciar uma OP MAE!!!")
		lRet:= .F.
	Endif

	If cFerrOp <> cFerrMae .AND. lRet == .T.
		MsgAlert("Ferramenta do produto " + cProdOp + " nao e igual a ferramenta do produto " + cProdMae )
		Return(.F.)
	EndIf

EndIf

Return(lRet)

User Function ENVIPW1(aOP)
Local cUrlPW   := SuperGetMV("MV_ZURLPW",.F., 'http://10.0.255.248:9000/ws/Integracao.asmx?wsdl')
Local ctextErr := ""
Local oWsdl    := Nil
Local nQtdOP   := 0
Local cMsg	   := ""
Local ctextOK  := ""
Local lret	   :=  .T.
Local PULALINHA := CHR(13)+CHR(10)
Local cErroBlk   := ''
Local oException := ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, Break(e) })

Begin Sequence
	For nQtdOP := 1 to len(aOP)
		cXml		:= aOP[nQtdOP][2]
		lret	    :=  .T.

		// Cria o objeto da classe TWsdlManager
		oWsdl := TWsdlManager():New()
		oWsdl:lSSLInsecure := .T.
		oWsdl:nTimeout := 60

		// Faz o parse de uma URL
		xRet := oWsdl:ParseURL( cUrlPW )

		if xRet == .F.
			lRet := .F.
			ctextErr += "Problema Conexao - oWsdl:ParseURL "
		Else
			xRet := oWsdl:SetOperation( "ImportarOrdemProducao" )
			if xRet == .F.
				lRet := .F.
				ctextErr += "Problema Operacao - oWsdl:SetOperation( 'ImportarOrdemProducao' ) "
			endif
		endif

		xRet := oWsdl:SendSoapMsg(cXml)
		if xRet == .F.
			ctextErr += "Problema Operacao - oWsdl:SetOperation( 'ImportarOrdemProducao' ) "
			lRet	:= .F.
		endif

		IF lret

			cXMLResponse :=  DecodeUtf8( oWsdl:GetSoapResponse())

			If ">OK<" $ UPPER(cXMLResponse)
				ctextOK	+= "OP: "+ Alltrim(aOP[nQtdOP][1] + "..........OK" ) + PULALINHA
			ELSE
				ctextErr	:= "OP: "+ Alltrim(aOP[nQtdOP][1]) + "..........Erro retorno do WebServices"
			EndIf

		endif

	Next nQtdOP
	Recover

	ErrorBlock(oException)
	ctextErr	:= "Error Log !" + PULALINHA + cErroBlk

end Sequence

If !EMPTY(ctextOK)
	cMsg += "Processada(s) com sucesso:" + PULALINHA + PULALINHA
	cMsg += ctextOK
Endif

IF ! Empty(ctextErr)
	cMsg += + PULALINHA + "Processada(s) com err0:"+ PULALINHA + PULALINHA
	cMsg += ctextErr
Endif

If ! Empty(cMsg)
	MsgInfo( cMsg , "Integracao PW - PW1PROTHEUS")
Else
	MsgInfo( "Erro na integração, favor avisar o Setor de Tecnologia.", "Integracao PW - PW1PROTHEUS")
Endif

Return lRet
