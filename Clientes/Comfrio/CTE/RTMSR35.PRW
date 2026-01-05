#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "topconn.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    008 
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   Max((022-Max(0,Len(aMensagem)-02)),1)
#DEFINE MAXITEMP2 055
#DEFINE MAXMENLIN 070

#DEFINE doDTC_SERNFC	1
#DEFINE doDTC_NUMNFC	2
#DEFINE doDTC_EMINFC	3
#DEFINE doDTC_VALOR		4
#DEFINE doDTC_PESO		5
#DEFINE doDTC_CLIDEV	6
#DEFINE doDTC_LOJDEV	7
#DEFINE doDTC_NFEID		8
#DEFINE doDTC_CTEID		9
#Define PESO_VARIAVEL  "V" //customização

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³19/01/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao responsavel por imprimir o DACTE.                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RTMSR35()
Local nCount		:= 0
Local nSoma			:= 0
Local nCInic		:= 0	// Coluna Inicial
Local cChaveA		:= ''
Local cChaveB		:= ''
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cTmsCOTM		:= SuperGetMv( "MV_TMSCOTM", .F., .F. )	//Numero do registro da OTM
Local cAliasD2		:= ''
Local aCab			:= {}
Local aDoc			:= {}
Local oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local lControl		:= .F.
Local cAliasInfNF	:= ''
Local cPerg			:= 'RTMSR25'
Local nCont			:= 0
Local lSeqDes		:= .F.
Local lSeqRec		:= .F.
Local cDT6Obs		:= ''
Local cDT6Obs2		:= ''
Local cDT6Obs3		:= '' 
Local cDTCObs		:= ''
Local aDTCObserv	:= {"","","","","","","",""} //--Linha da Observação proveniente da tabela DTC
Local nCountDTC		:= 0
Local cObsProp		:= ''
Local cObsStat		:= ''
Local nCountObs		:= 0
Local nLinhaObs  	:= 0
Local aObsCont		:= ''
Local cTipoNF		:= ''
Local cCtrDpc		:= ''
Local cSerDpc		:= ''
Local cTpDocAnt		:= ''
Local cCTEDocAnt	:= ''
//-- Buscar dados XML
Local aNotas		:= {}
Local aXML			:= {}
Local cAviso		:= ""
Local cErro			:= ""
Local cAutoriza		:= ""
Local cHorAut		:= ""
Local cDatAut		:= ""
Local cModalidade	:= ""
Local cIdEnt		:= ""
Local nX			:= 0
Local nY			:= 0
//-- CFOP - Natureza da Prestacao
Local cCFOP			:= ''
Local cDescCfop		:= ''
//-- Origem Prestacao
Local cOriMunPre	:= ""
Local cOriUFPre		:= ""
//-- Destino Prestacao
Local cDesMunPre	:= ""
Local cDesUFPre		:= ""
//-- Remetente
Local cRemMun		:= ""
Local cRemUF		:= ""
Local cRemNome		:= ""
Local cRemEnd		:= ""
Local cRemNro		:= ""
Local cRemCompl		:= ""
Local cRemBair		:= ""
Local cRemCEP		:= ""
Local cRemCNPJ		:= ""
Local cRemIE		:= ""
Local cRemPais		:= ""
Local cRemFone		:= ""
//-- Destinatario
Local cDesMun		:= ""
Local cDesUF		:= ""
Local cDesNome		:= ""
Local cDesEnd		:= ""
Local cDesNro		:= ""
Local cDesCompl		:= ""
Local cDesBair		:= ""
Local cDesCEP		:= ""
Local cDesCNPJ		:= ""
Local cDesIE		:= ""
Local cDesPais		:= ""
Local cDesFone		:= ""
//-- Expedidor
Local cExpNome		:= ""
Local cExpEnd		:= ""
Local cExpNro		:= ""
Local cExpMun		:= ""
Local cExpBai		:= ""
Local cExpUF		:= ""
Local cExpPais		:= ""
//-- Recebedor
Local cRecNome		:= ""
Local cRecEnd		:= ""
Local cRecNro   	:= ""
Local cRecBai		:= ""
Local cRecMun		:= ""
Local cRecUF		:= ""
Local cRecCEP		:= ""
Local cRecFone  	:= ""
Local lRecPJ		:= .F.
Local cRecCGC		:= ""
Local cRecCPF		:= ""
Local cRecINSCR		:= ""
Local cRecPais		:= ""
Local cRecCompl 	:= ""
//-- Tomador do Servico
Local cDevMun		:= ""
Local cDevUF		:= ""
Local cDevNome		:= ""
Local cDevEnd		:= ""
Local cDevNro		:= ""
Local cDevCompl		:= ""
Local cDevBair		:= ""
Local cDevCEP		:= ""
Local cDevCNPJ		:= ""
Local cDevIE		:= ""
Local cDevPais		:= ""
Local cDevFone		:= ""
//-- Produto Predominante
Local cPPDesc		:= ""
Local cPPCarga	:= ""
Local cPPVlTot	:= ""
Local cPPPesoB	:= ""
Local cPPPeso3	:= ""
Local cPPMetro3	:= ""
Local cPPQtdVol	:= ""
Local cPesoBC   := ""

//-- Documentos Originarios
Local aDocOri		:= {}
//Lotação
Local cDesDocAnt	:= ""
Local cAliasPeri	:= ""
Local lPerig		:= .F.	//-- Informa se ha produtos perigosos
Local cStartPath    := ''
Local cTipoDoc		:= ''
Local cTagObs		:= ''
Local lTMSDACTE     := ExistBlock("TMSDACTE",,.T.)
Local lXmlCont      := .F.
Local nLinIEM		:= 0 //-- valor de ajuste de salto pra as linhas relacionadas a Informações do Modal Rodoviário
Local cEndCom		:= ""
Local cChaveCTe		:= ""

Local cDestPDF 	    := ''
Local cFilDoc		:= ''
Local cDoc		    := ''
Local cSerie		:= ''
Local cChave		:= ''
Local lExibePerg    := .T.
Local lJob 			:= IsBlind()
Local aTamDocs      := IIf(FindFunction('TMSTamDocs'), TMSTamDocs("CTE"), {{9, 3}})
Local cSerieCTE     := ''
Local cNumCTE       := ''
Local nTamDocumen	:= 0
Local nTamSerie	    := 0
Local nMsg          := 0
Local lCorteCtes	:= .T. //Variavel customizada comfrio
Local nValid		:= 0   //Variavel customizada comfrio
Local cCteSegue		:= ""  //Variavel customizada comfrio
Local aImpCteFood 	:= {}  //Variavel customizada comfrio corte

//-- Variaveis Private
Private cAliasCT	:= GetNextAlias()
Private oDacte
Private oNfe
Private nLInic		:= 0	// Linha Inicial
Private nLFim		:= 0	// Linha Inicial
Private nDifEsq		:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
Private cInsRemOpc	:= ''	// Remetente com sequencia de IE
Private nFolhas		:= 1
Private nFolhAtu	:= 1
Private PixelX		:= nil
Private PixelY		:= nil
Private nMM			:= 0
Private lComp		:= .F.	//CTE Complementar
Private cVersaoCTE	:= ""
Private lUsaColab	:= UsaColaboracao("2")
Private aCtesFood	:= {} //Variavel customizada comfrio
Private aCorteOper	:= {} //Array com produtos que realmente cortou //Variavel customizada comfrio
Private aValidMAil  := {} //Variavel customizada comfrio
Private aRecsCorte	:= {} //Variavel customizada comfrio

//-- Verifica se o arquivo sera gerado em Remote Linux
if Type('ParamIXB') <> 'U' .And. Len( ParamIXB ) > 0
	cDestPDF:= ParamIXB[1]
	cFilDoc	:= ParamIXB[2]
	cDoc	:= ParamIXB[3]
	cSerie	:= ParamIXB[4]
	cChave	:= ParamIXB[5]
	If Len(ParamIXB) > 5
		cIdEnt		:= ParamIXB[6]
		cModalidade	:= ParamIXB[7]
		cVersaoCTE  := ParamIXB[8]
	EndIf
ElseIf Empty(cDestPDF)

	cStartPath := IIf(IsBlind(),"",GetTempPath(.T.))
	
endif
AjustaSX1()
//-- MV_PAR01 - Informe lote inicial.
//-- MV_PAR02 - Informe lote final.
//-- MV_PAR03 - Informe documento inicial.
//-- MV_PAR04 - Informe documento final.
//-- MV_PAR05 - Informe serie do documento inicial.
//-- MV_PAR06 - Informe serie do documento final.
//-- MV_PAR07 - Informe tipo do documento.
//-- MV_PAR08 - Buscar XML do WebService.

If lTMSDACTE
	ExecBlock("TMSDACTE",.F.,.F.)	
	Return()
EndIf

lExibePerg := !( !Empty(cChave) .And. !Empty(cFilDoc) .And. !Empty(cDoc) )
If !Pergunte( cPerg, lExibePerg ) .And. lExibePerg
	Return()
EndIf
//Valida Corte //customização

If cEmpAnt == "01" .AND. cFilAnt == "0201"
	 MsgRun("Analisando pedidos em processo de recuperacao de corte...","COMFRIO",{|| lCorteCtes := ValidRecCorte() })
Endif

If Empty(cIdEnt) .Or. Empty(cModalidade) .Or. Empty(cVersaoCTE)
	If !lUsaColab .And. !TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,lUsaColab)
		Return()
	EndIf
EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
cAliasCT := DataSource( 'DT6', cFilDoc, cDoc, cSerie )
If !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerie) .AND. Empty(cChave)
	cChaveCTe := IIf(!Empty((cAliasCT)->DT6_CHVCTE), (cAliasCT)->DT6_CHVCTE, (cAliasCT)->DT6_CHVCTG)
ElseIf !Empty(cChave) .AND. !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerie)
	cChaveCTe := cChave
EndIf

oDacte := FWMSPrinter():New( If( !Empty(cChaveCTe), cChaveCTe, "DACTE"), IMP_PDF, .F., If(!Empty(cDestPDF), cDestPDF, cStartPath ), If( !Empty(cDoc), .T., .F.), , @oDacte, ,Iif(":" $ cStartPath .Or. ":" $ cDestPDF,.F.,.T.) , , , If( Empty(cDoc) .And. !lJob, .T., .F. ) )
oDacte:SetResolution( 72 )
oDacte:SetPortrait()
oDacte:SetPaperSize( DMPAPER_A4 )
oDacte:SetMargin( 60, 60, 60, 60 )
oDacte:SetParm( "-RFS" )

//--Salvar arquivo na pasta temporaria deverá seleciona no TOTVSPrinter Servidor,
//--Caso contrário salvará na pasta selecionada.
If !Empty(cDestPDF)
	oDacte:lServer	:= .T.
	oDacte:nDevice	:= IMP_PDF
	oDacte:cPathPDF	:= cDestPDF
Else
	oDacte:cPathPDF := cStartPath //--Pasta Temp.
EndIf

If Empty(cDoc) .And. oDacte:nModalResult <> 1
	oDacte:Cancel()
EndIf

If oDacte:Canceled()
	oDacte:DeActivate()
	Return(.T.)
EndIf

PixelX  := oDacte:nLogPixelX()
PixelY  := oDacte:nLogPixelY()
nMM     := 0

While !(cAliasCT)->(Eof())
	//Valida Corte //customização
	If cEmpAnt == "01" .AND. cFilAnt == "0201" .AND. !lCorteCtes
		nValid :=  ascan(aCtesFood, { |x| alltrim(x[1]) == Alltrim((cAliasCT)->DT6_DOC) })
		If nValid <> 0
			cCteSegue := ""
		Else 
			cCteSegue := (cAliasCT)->DT6_DOC
		Endif 
	Else //Demais filiais nada muda
		cCteSegue := (cAliasCT)->DT6_DOC
	Endif 

	If !Empty(cCteSegue) //customização

		AADD(aImpCteFood,{cCteSegue}) //customização

		oDacte:StartPage()

		cExpMun		:= ""
		cExpUF		:= ""
		cExpNome	:= ""
		cExpEnd		:= ""
		cExpNro		:= ""
		cExpCompl	:= ""
		cExpBai		:= ""
		cExpCEP		:= ""
		cExpCNPJ	:= ""
		cExpIE		:= ""
		cExpPais	:= ""
		cExpFone	:= ""
		cHorAut		:= ""
		cDatAut		:= ""
		lExped		:= .F.

		//-- Buscar XML do WebService
		
		cSerieCTE := (cAliasCT)->DT6_SERIE
		cNumCTE   := (cAliasCT)->DT6_DOC

		nTamDocumen	  := aTamDocs[1][1]
		nTamSerie	  := aTamDocs[1][2]

		PadR(cNumCTE,    nTamDocumen)
		PadR(cSerieCTE,  nTamSerie)

		aNotas := {}
		aadd(aNotas,{})
		aAdd(Atail(aNotas),.F.)

		aadd(Atail(aNotas),"S") //IIF(MV_PAR04==1,"E","S"))
		aAdd(Atail(aNotas),"")
		aAdd(Atail(aNotas),cSerieCTE) //SERIE
		aAdd(Atail(aNotas),cNumCTE)   //Documento
		aadd(Atail(aNotas),"")
		aadd(Atail(aNotas),"")

		nX   := 1
		aXml := {}
		If lUsaColab
			//-- TOTVS Colaboracao 2.0
			aXml := TMSColXML(aNotas,@cModalidade,lUsaColab)
		Else
			aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade)
		EndIf
		
		If SubStr(cModalidade,1,1) $ '5;7'
			lXmlCont := .T.
		EndIf
			
		If !Empty(aXML[nX][2])
			If !Empty(aXml[nX])
				cAutoriza   := aXML[nX][1]
				cCodAutDPEC := aXML[nX][5]
				cHorAut     := IIF(!Empty(aXML[nX][6]),aXML[nX][6],"")		//-- Data autorizacao
				cDatAut     := IIF(!Empty(aXML[nX][7]),DToC(aXML[nX][7]),"")	//-- Hora autorizacao
			Else
				cAutoriza   := ""
				cCodAutDPEC := ""
			EndIf
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
			oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
			
			If ValType( oNfe ) == 'U'
				(cAliasCT)->(DbSkip())
				Loop
			EndIf
			
			If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. !cModalidade$"1,4,5,6")
				If aNotas[nX][02]=="S"
					dbSelectArea("SF2")
					dbSetOrder(1)
					If MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]) .And. cModalidade$"1,4,6"
						RecLock("SF2")
						If !SF2->F2_FIMP$"D"
							SF2->F2_FIMP := "S"
						EndIf
						If SF2->(FieldPos("F2_CHVNFE"))>0
							SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
						EndIf
						MsUnlock()
					EndIf
				EndIf
			EndIf
		EndIf
		
		If ValType( oNfe ) == 'U'
			(cAliasCT)->(DbSkip())
			Loop 
		EndIf

		// Seleciona a qtde de registros, p/ calcular a qtde de folhas
		cAliasInfNF := DataSource( 'DTC' )
		If (cAliasInfNF)->nTotal > 0
			If (cAliasInfNF)->nTotal <= 10
				nFolhas := 1
			Else
				nFolhas := (cAliasInfNF)->nTotal - 10	//-- Qtde da primeira paginas.
				nFolhas := Int(( nFolhas / 74 ) + 2)	//-- Qtde da outras paginas.
			EndIf
		EndIf
		(cAliasInfNF)->(DbCloseArea())	

		// Controla o documento a ser enviado para montagem do cabecalho.
		nCont += 1
			aAdd(aCab, {;
			AllTrim((cAliasCT)->DT6_DOC),;
			AllTrim(oNfe:_CTE:_INFCTE:_IDE:_SERIE:TEXT),;
			AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
			AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
			AllTrim(STRTRAN(UPPER(oNFE:_CTE:_INFCTE:_ID:TEXT),'CTE','')),;
			(cAliasCT)->DT6_PROCTE,"" ,cDatAut, cHorAut})	//-- Nao possui ref. no XML
		
		// Funcao responsavel por montar o cabecalho do relatorio
		nFolhAtu := 1
		lSeqDes  :=.F.
		lSeqRec  :=.F.
		TMSR31Cab(aCab[nCont],.T., lXmlCont)

		//-- Estrutura da funcao que retorna o logradouro, numero e complemento.
		//-- Logradouro		FisGetEnd(XXXXXXXX)[1]
		//-- Numero			FisGetEnd(XXXXXXXX)[2]
		//-- Complemento	FisGetEnd(XXXXXXXX)[4]

		//-- CFOP
		cCFOP		:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_CFOP:TEXT)
		cDescCfop	:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_NATOP:TEXT)

		//-- Origem da Prestacao
		cOriMunPre	:= Iif(XmlChildEx( oNfe:_CTE:_INFCTE:_IDE, '_XMUNINI') == NIL," ",oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT )
		cOriUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT

		//-- Destino da Prestacao
		cDesMunPre	:= oNfe:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
		cDesUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFFIM:TEXT

		//-- Remetente
		If XmlChildEx(oNfe:_CTE:_INFCTE,'_REM') <> NIL
			cRemMun   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT
			cRemUF    := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT
			cRemNome  := oNfe:_CTE:_INFCTE:_REM:_XNOME:TEXT
			cRemEnd   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT
			cRemNro   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT
			cRemCompl := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_ENDERREME,'_XCPL' )== NIL," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XCPL:TEXT)
			cRemBair  := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT
			cRemCEP   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT
			cRemCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_CNPJ') == Nil,oNfe:_CTE:_INFCTE:_REM:_CPF:TEXT,oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
			cRemIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_IE' ) == Nil," ",oNfe:_CTE:_INFCTE:_REM:_IE:TEXT)
			cRemPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_ENDERREME,'_XPAIS') == Nil," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT)
			cRemFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT)
		EndIf
		//-- Expedidor
		If (XmlChildEx(oNfe:_CTE:_INFCTE,'_EXPED')) <> Nil
			lExped		:= .T.
			cExpMun		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT
			cExpUF		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT
			cExpNome	:= oNfe:_CTE:_INFCTE:_EXPED:_XNOME:TEXT
			cExpEnd		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT
			cExpNro		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT
			cExpCompl 	:= ""
			cExpBai		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT
			cExpCEP		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT
			cExpCNPJ	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_EXPED:_CPF:TEXT , oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
			cExpIE		:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_IE:TEXT)
			cExpPais	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED,'_XPAIS')==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XPAIS:TEXT)
			cExpFone	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EXPED,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT)
		EndIf

		//-- Destinatario
		If XmlChildEx(oNfe:_CTE:_INFCTE,'_DEST') <> Nil
			cDesMun   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
			cDesUF    := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
			cDesNome  := oNfe:_CTE:_INFCTE:_DEST:_XNOME:TEXT
			cDesEnd   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
			cDesNro   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT
			cDesCompl := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST,'_XCPL' ) == Nil," ", oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XCPL:TEXT)
			cDesBair  := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
			cDesCEP   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT
			cDesCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_CNPJ') == Nil,    oNfe:_CTE:_INFCTE:_DEST:_CPF:TEXT, oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
			cDesIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_IE'  ) == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT)
			cDesPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST,'_XPAIS') == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT)
			cDesFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT)
		EndIf

		//-- Local de Entrega
		If XmlChildEx(oNfe:_CTE:_INFCTE,'_RECEB') <> Nil .AND. XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_ENDERRECEB') <> Nil
			lSeqRec := .T.
			//Destino Recebedor
			cRecNome	:= oNfe:_CTE:_INFCTE:_RECEB:_XNOME:TEXT
			cRecEnd		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XLGR:TEXT
			cRecNro  	:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_NRO:TEXT
			cRecBai		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XBAIRRO:TEXT
			cRecMun		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XMUN:TEXT
			crecUF		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_UF:TEXT
			cRecPais  	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_XPAIS')== Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XPAIS:TEXT)
			cRecCompl 	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_XCPL') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XCPL:TEXT )
			cRecCEP   	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_CEP')  == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_CEP:TEXT  )
			
			cRecFone := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_FONE:TEXT )
			If Empty(cRecFone)
				cRecFone := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB,'_FONE') == Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_FONE:TEXT )
			EndIf

			If XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_CNPJ')==Nil
				cRecCPF	:= oNfe:_CTE:_INFCTE:_RECEB:_CPF:TEXT
			Else
				cRecCGC	:= oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT				
				cRecINSCR := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_RECEB,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_RECEB:_IE:TEXT)
				lRecPJ	:= .T.
			EndIf		
		EndIf

		//-- Produto Predominante
		If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil
			If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_PROPRED') <> Nil
				cPPDesc		:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT
			EndIf
			If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_XOUTCAT') <> Nil
				cPPCarga	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_XOUTCAT:TEXT
			EndIf
			If XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_VMERC') <> Nil
				cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT
			Else
				cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT
			EndIf
			If XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA,'_INFQ' ) <> Nil
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ )
					Do Case
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO DECLARADO"
							cPPPesoB := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO BASE DE CALCULO"
							cPesoBC := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT	
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO CUBADO"
							cPPPeso3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "LITRAGEM"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "VOLUME"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "METROS CUBICOS"
							cPPMetro3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
					EndCase
				Next nCount
			EndIf
		EndIf

		// Tomador
		//
		// Tomador do Servico
		// 0 - Remetente;
		// 1 - Expedidor;
		// 2 - Recebedor;
		// 3 - Destinatario. 
			//| Remetente é o tomador do frete
		If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_TOMA3') <> Nil .AND. (oNfe:_CTE:_INFCTE:_IDE:_TOMA3,'_TOMA') <> Nil
			If oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "0"
				cDevMun   := cRemMun
				cDevUF    := cRemUF
				cDevNome  := cRemNome
				cDevEnd   := cRemEnd
				cDevNro   := cRemNro
				cDevCompl := cRemCompl
				cDevBair  := cRemBair
				cDevCEP   := cRemCEP
				cDevCNPJ  := cRemCNPJ
				cDevIE    := cRemIE
				cDevPais  := cRemPais
				cDevFone  := cRemFone
			//| Expedidor é o Tomador do Frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "1"
				cDevMun   := cExpMun
				cDevUF    := cExpUF
				cDevNome  := cExpNome
				cDevEnd   := cExpEnd
				cDevNro   := cExpNro
				cDevCompl := cExpCompl
				cDevBair  := cExpBai
				cDevCEP   := cExpCEP
				cDevCNPJ  := cExpCNPJ
				cDevIE    := cExpIE
				cDevPais  := cExpPais
				cDevFone  := cExpFone
			//| Recebedor é o tomador do frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "2"
				cDevMun   := cRecMun
				cDevUF    := cRecUF
				cDevNome  := cRecNome
				cDevEnd   := cRecEnd
				cDevNro   := cRecNro
				cDevCompl := cRecCompl
				cDevBair  := cRecBai
				cDevCEP   := cRecCEP
				cDevCNPJ  := cRecCGC
				cDevIE    := cRecINSCR
				cDevPais  := cRecPais
				cDevFone  := cRecFone
			//| Destinatário  é o Tomador do Frete
			ElseIf oNfe:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT == "3"
				cDevMun   := cDesMun
				cDevUF    := cDesUF
				cDevNome  := cDesNome
				cDevEnd   := cDesEnd
				cDevNro   := cDesNro
				cDevCompl := cDesCompl
				cDevBair  := cDesBair
				cDevCEP   := cDesCEP
				cDevCNPJ  := cDesCNPJ
				cDevIE    := cDesIE
				cDevPais  := cDesPais
				cDevFone  := cDesFone
			EndIf
		ElseIf XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_TOMA4') <> Nil .AND. (oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_TOMA') <> Nil
			If oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT == "4"
				// Subcontratacao DT6_DEVFRE == "4" - Despachante		
				cDevMun   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XMUN:TEXT
				cDevUF    := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT
				cDevNome  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_XNOME:TEXT
				cDevEnd   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XLGR:TEXT
				cDevNro   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_NRO:TEXT
				cDevCompl := ""
				cDevBair  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XBAIRRO:TEXT
				cDevCEP   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_CEP:TEXT
				cDevCNPJ  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_CNPJ')==Nil,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
				cDevIE    := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_IE' )==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT)
				cDevPais  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA,'_XPAIS' )==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XPAIS:TEXT)
				cDevFone  := Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_IDE:_TOMA4,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT)
			EndIf
		EndIf
		//-- Documentos Originarios
		aDocOri := {}
		If (XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFNFE' ) <> Nil )
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNFE )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT }) 
				EndIf
			EndIf
		ElseIf	(XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFNF' ) <> Nil ) 
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNF ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNF )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT,;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_DEMI:TEXT,'-'),;
						oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_VPROD:TEXT,;
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
				//-- Local de Retirada
				If (XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF[1],'_LOCRET')) <> Nil
					cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XMUN:TEXT
					cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_UF:TEXT
					cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XNOME:TEXT
					cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XLGR:TEXT
					cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_NRO:TEXT
					cExpCompl 	:= ""
					cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_XBAIRRO:TEXT
					cExpCEP   	:= ""
					cExpCNPJ  	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF[1]:_LOCRET:_CNPJ:TEXT)
					cExpIE    	:= ""
					cExpPais  	:= cRemPais
					cExpFone  	:= ""
				EndIf
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT,;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT,'-'),;
					oNFE:_CTE:_INFCTE:_REM:_INFNF:_VPROD:TEXT,;
					'',;
					'',;
					'',;
					'' })
				EndIf
				If (XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF,'_LOCRET')) <> Nil
					cExpMun	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XMUN:TEXT
					cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_UF:TEXT
					cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XNOME:TEXT
					cExpEnd	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XLGR:TEXT
					cExpNro	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_NRO:TEXT
					cExpCompl 	:= ""
					cExpBai	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XBAIRRO:TEXT
					cExpCEP   	:= ""
					cExpCNPJ  	:= Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET,'_CNPJ')==Nil, oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT)
					cExpIE    	:= ""
					cExpPais  	:= cRemPais
					cExpFone  	:= ""
				EndIf
			EndIf
		//Aqui Inicio
		ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFNF') <> Nil
				If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_NDOC:TEXT})==0
							AADD(aDocOri, {;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_SERIE:TEXT,;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_NDOC:TEXT,;
							STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_DEMI:TEXT,'-'),;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF[ nCount ]:_VPROD:TEXT,;
							'',;
							'',;
							'',;
							'' })
						EndIf
					Next nCount
				Else
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT,;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_DEMI:TEXT,'-'),;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_VPROD:TEXT,;
						'',;
						'',;
						'',;
						'',;
						'' })
					EndIf
				EndIf
			
		//CTE MULTIMODAL
		ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFSERVVINC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC,'_INFCTEMULTIMODAL' ) <> Nil 
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL[ nCount ]:_CHCTEMULTIMODAL:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL[ nCount ]:_CHCTEMULTIMODAL:TEXT })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL:_CHCTEMULTIMODAL:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFSERVVINC:_INFCTEMULTIMODAL:_CHCTEMULTIMODAL:TEXT }) 
				EndIf
			EndIf

		ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFNFE' ) <> Nil 
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT,;
						'' })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT,;
					'' }) 
				EndIf
			EndIf
		ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFDCE' ) <> Nil 
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE )
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE[ nCount ]:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE[ nCount ]:_CHAVE:TEXT,;
						'' })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE ) == 'O'
				If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE:_CHAVE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFDCE:_CHAVE:TEXT,;
					'' }) 
				EndIf
			EndIf
		ElseIf	(XmlChildEx(oNFE:_CTE:_INFCTE,'_REM') <> Nil) .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_REM,'_INFOUTROS' ) <> Nil )
			If ValType( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
						'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_DEMI:TEXT,'-'),;
					'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					'',;
					'',;
					'',;
					'' })
				EndIf
			EndIf
		ElseIf XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM') <> Nil .And. XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM,'_INFDOC') <> Nil .And. ( XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC,'_INFOUTROS' ) <> Nil ) 
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS )
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
						AADD(aDocOri, {;
						'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
						STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
						'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
						'',;
						'',;
						'',;
						'' })
					EndIf
				Next nCount
			Else
				If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT})==0
					AADD(aDocOri, {;
					'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT,;
					STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_DEMI:TEXT,'-'),;
					'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
					'',;
					'',;
					'',;
					'' })
				EndIf
			EndIf
		EndIf

		//Tratamento para a tag docAnt
		If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM,'_DOCANT' ) <> Nil .AND. ;
			XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT,'_EMIDOCANT' ) <> NIL .AND.;
			XmlChildEx( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT,'_IDDOCANTELE' ) <> Nil
			aDocOri := {}
			If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE ) == 'A'
				For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE )
					If aScan(aDocOri,{|x|x[9]==oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE[ nCount ]:_CHCTE:TEXT})==0
						AADD(aDocOri, {;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE[ nCount ]:_CHCTE:TEXT })
					EndIf
				Next nCount
			ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE ) == 'O'
				If aScan(aDocOri,{|x|x[9]==oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE:_CHCTE:TEXT})==0
					AADD(aDocOri, {;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					oNFE:_CTE:_INFCTE:_INFCTENORM:_DOCANT:_EMIDOCANT:_IDDOCANT:_IDDOCANTELE:_CHCTE:TEXT }) 
				EndIf
			EndIf
		EndIf

		// BOX: CFOP - Natureza da Prestacao
		oDacte:Box(0195, 0000, 0215, 0280)
		oDacte:Say(0202, 0003, "Código Fiscal de Operações - Natureza da Operação",	oFont08N)
		oDacte:Say(0211, 0003, cCFOP + " - " + cDescCfop,		oFont08)

		// BOX: ORIGEM DA PRESTACAO
		oDacte:Box(0215, 0000, 0229, 0280)
		oDacte:Say(0221, 0003, "Início da Prestação" , oFont08N)
		oDacte:Say(0228, 0003, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08)	

		// BOX: DESTINO DA PRESTACAO
		oDacte:Box(0215, 0280, 0229, 0559)
		oDacte:Say(0221, 0288, "Término da Prestação", oFont08N)
		oDacte:Say(0228, 0288, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08)

		// BOX: Remetente
		// BOX: Destinatario
		oDacte:Box(0231, 0000, 0282, 0279)	//Remetente
		oDacte:Box(0231, 0281, 0282, 0559)	//Destinatario

		oDacte:Say(0237, 0003, "Remetente:", oFont08)
		oDacte:Say(0237, 0043, NoAcentoCte(Substr(cRemNome,1,45)), oFont08N)
		oDacte:Say(0237, 0286, "Destinatário:", oFont08)
		oDacte:Say(0237, 0328, NoAcentoCte(Substr(cDesNome,1,45)), oFont08N)

		cInsRemOpc := AllTrim(cRemIE)
		For nCount := 1 To 5
			Do Case
				Case ( nCount == 1 )
					oDacte:Say(0246, 0003, "Endereço:", oFont08)
					If Len(AllTrim(cRemEnd)) > 40
						oDacte:Say(0246, 0039, SubStr( AllTrim(cRemEnd), 1, 40 ) , oFont08)
						oDacte:Say(0253, 0039, SubStr( AllTrim(cRemEnd), 40,Len(AllTrim(cRemEnd) ) ) + ", " + cRemNro, oFont08)
					Else
						oDacte:Say(0246, 0039, AllTrim(cRemEnd) + ", " + cRemNro, oFont08)
					EndIf
					
					oDacte:Say(0246, 0286, "Endereço:", oFont08)
					If Len(AllTrim(cDesEnd)) > 40
						oDacte:Say(0246, 0324, SubStr( AllTrim(cDesEnd), 1, 40) , oFont08)
						oDacte:Say(0253, 0324, SubStr( AllTrim(cDesEnd), 40, 35 ) + ", " + cDesNro, oFont08)
					Else
						oDacte:Say(0246, 0324, AllTrim(cDesEnd) + ", " + cDesNro, oFont08)
					EndIf
				Case ( nCount == 2 )
					oDacte:Say(0260, 0039, SubStr( AllTrim(cRemCompl), 1, 20 ) + " - " + SubStr( AllTrim(cRemBair), 1, 20 ), oFont08)
					oDacte:Say(0260, 0324, SubStr( AllTrim(cDesCompl), 1, 20 ) + " - " + SubStr( AllTrim(cDesBair), 1, 20 ), oFont08)
				Case ( nCount == 3 )
					oDacte:Say(0267, 0003, "Município:", oFont08)
					oDacte:Say(0267, 0043, AllTrim(cRemMun) + ' - ' + AllTrim(cRemUF)  + ' CEP.: ' + Transform(AllTrim(cRemCEP), "@r 99999-999"), oFont08)
					oDacte:Say(0267, 0286, "Município:", oFont08)
					oDacte:Say(0267, 0328, AllTrim(cDesMun) + ' - ' + AllTrim(cDesUF) + ' CEP.: ' + Transform(AllTrim(cDesCEP), "@r 99999-999"), oFont08)
				Case ( nCount == 4 )
					oDacte:Say(0274, 0003, "CNPJ/CPF:", oFont08)
					oDacte:Say(0274, 0043, Transform(AllTrim(cRemCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cInsRemOpc), oFont08)
					oDacte:Say(0274, 0286, "CNPJ/CPF:", oFont08)
					oDacte:Say(0274, 0328, Transform(AllTrim(cDesCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cDesIE),    oFont08)
				Case ( nCount == 5 )
					oDacte:Say(0281, 0003, "País:", oFont08)
					oDacte:Say(0281, 0043, AllTrim(cRemPais) + ' - Telefone: ' + Transform(AllTrim(cRemFone),"@r (999) 999999999"),  oFont08)
					oDacte:Say(0281, 0286, "País:", oFont08)
					oDacte:Say(0281, 0328, AllTrim(cDesPais) + '  - Telefone: ' + Transform(AllTrim(cDesFone),"@r (999) 999999999"), oFont08)
			EndCase
		Next nCount

		// BOX: Expedidor / BOX: Recebedor
		oDacte:Box(0284, 0000, 0335, 0279)	//Expedidor
		oDacte:Box(0284, 0281, 0335, 0559)	//Recebedor

		If lExped .Or. Empty(cExpNome) 		
			oDacte:Say(0291, 0003, "Expedidor:", oFont08) 
		Else
			oDacte:Say(0291, 0003, "Local de Coleta:", oFont08)
		EndIf
		oDacte:Say(0291, 0043, NoAcentoCte(Substr(cExpNome,1,45))    , oFont08N)

		//-- Sequencia de endereco preenchida, fica como local de entrega.
		If lSeqDes
			oDacte:Say(0291, 0286, "Local de Entrega:", oFont08)
			oDacte:Say(0291, 0342,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
		EndIf
		
		If lSeqRec
			oDacte:Say(0291, 0286, "Recebedor:", oFont08)
			oDacte:Say(0291, 0328,  NoAcentoCte(Substr(cRecNome,1,45)), oFont08N)
		EndIf

		If !lSeqDes .And. !lSeqRec
			oDacte:Say(0291, 0286, "Recebedor:", oFont08)
		EndIf

		For nCount := 1 To 5
			Do Case
				Case ( nCount == 1 )
					oDacte:Say(0300, 0003, "Endereço:", oFont08)
					If Len(AllTrim(cDesEnd)) > 40
						oDacte:Say(0300, 0039, If( !Empty(cExpEnd), SubStr(AllTrim(cExpEnd), 1, 40 ), " "), oFont08)
						oDacte:Say(0307, 0039, If( !Empty(cExpEnd), SubStr(AllTrim(cExpEnd), 40, Len(AllTrim(cExpEnd) ) ) + ", " + cExpNro, " "), oFont08)
					Else
						oDacte:Say(0300, 0039, IIf(!Empty(cExpEnd), AllTrim(cExpEnd) + ", " + cExpNro, " "), oFont08)
					EndIf
					oDacte:Say(0300, 0286, "Endereço:", oFont08)
					//-- Sequencia de endereco preenchida, fica como local de entrega.
					If Len(AllTrim(cRecEnd)) > 40
						oDacte:Say(0300, 0324, If(lSeqDes .or. lSeqRec, SubStr(AllTrim(cRecEnd), 1, 40 ), " "), oFont08)
						oDacte:Say(0307, 0324, If(lSeqDes .or. lSeqRec, SubStr(AllTrim(cRecEnd), 40, Len(AllTrim(cRecEnd) ) ) + ", " + cRecNro, " "), oFont08)
					Else
						oDacte:Say(0300, 0324, If(lSeqDes .or. lSeqRec, AllTrim(cRecEnd) + ", " + cRecNro, " "), oFont08)
					EndIf
				Case ( nCount == 2 )
					oDacte:Say(0314, 0039, If(!Empty(cExpCompl), If(!Empty(cExpCompl), SubStr(AllTrim(cExpCompl), 1, 20 ), "" ) + " - " + SubStr(AllTrim(cExpBai), 1, 20 ), cExpBai), oFont08)
					oDacte:Say(0314, 0324, If(lSeqDes .or. lSeqRec, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[4] ) ) + " - " + AllTrim(cRecBai),""), oFont08)
				Case ( nCount == 3 )
					oDacte:Say(0321, 0003, "Município:", oFont08)
					oDacte:Say(0321, 0043, IIf(!Empty(cExpMun),  AllTrim(cExpMun) + ' - ' + AllTrim(cExpUF), " ")  + ' CEP.: ' + IIf(!Empty(cExpCEP), Transform(AllTrim(cExpCEP), "@r 99999-999"), ""), oFont08)
					oDacte:Say(0321, 0286, "Município:", oFont08)
					oDacte:Say(0321, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cRecMun) + ' - ' + AllTrim(cRecUF),"") + ' CEP.: ' + IIf(!Empty(cRecCEP), Transform(AllTrim(cRecCEP), "@r 99999-999"), ""), oFont08)
				Case ( nCount == 4 )
					oDacte:Say(0328, 0003, "CNPJ/CPF:", oFont08)
					oDacte:Say(0328, 0043, IIf(!Empty(cExpCNPJ), Transform(AllTrim(cExpCNPJ), "@r 99.999.999/9999-99"), " ") + "   Inscrição Estadual: " +  AllTrim(cExpIE), oFont08)
					oDacte:Say(0328, 0286, "CNPJ/CPF:", oFont08)
					If lSeqDes .or. lSeqRec
						If lRecPJ
							oDacte:Say(0328, 0328, IIf(!Empty(cRecCGC), Transform(cRecCGC,"@r 99.999.999/9999-99"), " ") + "   Inscrição Estadual: " +  cRecINSCR, oFont08)
						Else
							oDacte:Say(0328, 0328, Transform(cRecCPF,"@r 999.999.999-99"), oFont08)
						EndIf
					Else
						oDacte:Say(0328, 0328, "", oFont08)
					EndIf

				Case ( nCount == 5 )
					If lExped .Or. Empty(cExpNome)
						oDacte:Say(0335, 0003, "País:" , oFont08)
						oDacte:Say(0335, 0043, AllTrim(cExpPais) + ' Telefone: ' + IIf(!Empty(cExpFone), Transform(AllTrim(cExpFone),"@r (999) 999999999"), " "),  oFont08)
					EndIf
					If !lSeqDes
						oDacte:Say(0335, 0286, "País:" , oFont08)
						oDacte:Say(0335, 0328, AllTrim(cRecPais) + ' Telefone: ' + IIf(!Empty(cRecFone), Transform(AllTrim(cRecFone),"@r (999) 999999999"), " "),  oFont08)
					EndIf
			EndCase
		Next nCount

		// BOX: Tomador do Servico
		oDacte:Box(0337, 0000, 0364, 0559)
		oDacte:Say(0344, 0003, "Tomador do Serviço:", oFont08)
		oDacte:Say(0344, 0072, NoAcentoCte(SubStr(cDevNome,1,45)), oFont08)
		oDacte:Say(0344, 0328, "Município:", oFont08)
		oDacte:Say(0344, 0368, AllTrim(cDevMun) + ' - ' + AllTrim(cDevUF) + ' CEP.: ' + Transform(AllTrim(cDevCEP),"@r 99999-999"), oFont08)

		For nCount := 1 To 2
			Do Case
				Case ( nCount == 1 )
					cEndCom := SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - " + AllTrim(cDevCompl) + " - " + AllTrim(cDevBair)
					oDacte:Say(0352, 0003, "Endereço:", oFont08	)

					If Len(cEndCom) > 64 .AND. !Empty(cDevCompl)
						cEndCom := SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - " + SubStr(AllTrim(cDevCompl), 1, 10 ) + " - " + SubStr(AllTrim(cDevBair), 1, 29 )
						oDacte:Say(0352, 0038, cEndCom, oFont08		)
						oDacte:Say(0352, 0485, "País: ", oFont08	)
						oDacte:Say(0352, 0505, AllTrim(cDevPais), oFont08	)
					ElseIf Len(cEndCom) > 64
						oDacte:Say(0352, 0038, cEndCom, oFont08		)
						oDacte:Say(0352, 0485, "País: ", oFont08	)
						oDacte:Say(0352, 0505, AllTrim(cDevPais), oFont08	)
					Else
						oDacte:Say(0352, 0038, cEndCom, oFont08		)
						oDacte:Say(0352, 0328, "País: ", oFont08	)
						oDacte:Say(0352, 0368, AllTrim(cDevPais), oFont08	)
					EndIf
					
				Case ( nCount == 2 )
					oDacte:Say(0360, 0003, "CNPJ/CPF:", oFont08)
					oDacte:Say(0360, 0043, Transform(AllTrim(cDevCNPJ),"@r 99.999.999/9999-99") + "   Inscrição Estadual: " + AllTrim(cDevIE), oFont08)
					oDacte:Say(0360, 0328, "Telefone:", oFont08)
					oDacte:Say(0360, 0368, Transform(AllTrim(cDevFone),"@r (999) 999999999"), oFont08)
			EndCase
		Next nCount

		If	AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 2, Len(DT6->DT6_DOCTMS)) .Or.;
			AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 6, Len(DT6->DT6_DOCTMS)) .Or.;
			AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 7, Len(DT6->DT6_DOCTMS)) .Or.;
			AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 9, Len(DT6->DT6_DOCTMS)) .Or.;
			AllTrim((cAliasCT)->DT6_DOCTMS) == 'A' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'E' .Or. ;
			AllTrim((cAliasCT)->DT6_DOCTMS) == 'M' .Or. ;
			(AllTrim((cAliasCT)->DT6_DOCTMS) == 'B' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'C' .And. ;
			Empty(Posicione('DUI',1,xFilial('DUI')+(cAliasCT)->DT6_DOCTMS,'DUI_DOCFAT')) )

			// BOX: Prod Predom || Outras Caract || Valor Total da Mercadoria
			oDacte:Box(0366 , 0000, 0383, 0559)
			oDacte:Line(0366, 0189, 0383, 0189) // Linha: Prod.Predominante e Out.Caracteristicas
			oDacte:Line(0366, 0378, 0383, 0378) // Linha: Out.Caracteristicas e Vlr.Total
			oDacte:Say(0372, 0003, "Produto Predominante"           , oFont08N)
			oDacte:Say(0372, 0192, "Outras Características da Carga", oFont08N)
			oDacte:Say(0372, 0381, "Valor Total da Mercadoria"      , oFont08N)
			oDacte:Say(0380, 0003, SubStr(cPPDesc,1,40), oFont08)	//Produto Predominante
			oDacte:Say(0380, 0192, AllTrim(cPPCarga)	, oFont08)	//Outras Caracteristicas da Carga
			oDacte:Say(0380, 0381, PadL( Transform( val(cPPVlTot), PesqPict("DT6","DT6_VALMER") ), 20 ), oFont08)	//Valor Total da Mercadoria

			// BOX: QNT. / UNIDADE MEDIDA /
			oDacte:Box(0385, 0000, 0443,  0559)	
			oDacte:Box(0385, 0000, 0443,  0040) // Box Qtd / Carga
			oDacte:Say(0392 , 0003, "Qtd."	, oFont08N)
			oDacte:Say(0402 , 0003, "Carga"	, oFont08N)	
			oDacte:Say(0392 , 0043, "Peso Bruto (KG)"			, oFont08N)
			oDacte:Say(0392 , 0143, "Peso Base de Cálculo (KG)"	, oFont08N)
			oDacte:Say(0392 , 0247, "Peso Aferido (KG)  "	, oFont08N)
			oDacte:Say(0392 , 0352, "Cubagem (M³)        "		, oFont08N)
			oDacte:Say(0392 , 0457, "Qtd. Volume (UN)"	, oFont08N)
			oDacte:Say(0392 , nCInic, "                ", oFont08N)
			oDacte:Line(0385, 0140, 0443, 0140) // Linha: Separador Peso Bruto (KG) / Peso Cubado		
			oDacte:Line(0385, 0245, 0443, 0245) // Linha: Separador Peso Cubado / M³				
			oDacte:Line(0385, 0350, 0443, 0350) // Linha: Separador M³ / Qtd. Volume (Un)			
			oDacte:Line(0385, 0455, 0443, 0455) // Linha: SeparadorQtd. Volume (Un) / 				

			oDacte:Say(0405, 0043, Transform(val(cPPPesoB) ,	PesqPict("DT6","DT6_PESO")   ),	oFont08) 
			oDacte:Say(0405, 0143, Transform(val(cPesoBC) ,  	PesqPict("DT6","DT6_PESO")   ),	oFont08) 						
			oDacte:Say(0405, 0247, Transform(val(cPPPeso3) ,	PesqPict("DT6","DT6_PESOM3") ),	oFont08)  			
			oDacte:Say(0405, 0352, Transform(val(cPPMetro3),	PesqPict("DT6","DT6_METRO3") ),	oFont08)   				
			oDacte:Say(0405, 0457, Transform(val(cPPQtdVol),	PesqPict("DT6","DT6_QTDVOL") ),	oFont08)    
			
			//-- Zera as variaveis(Peso, Peso Cubado, Metro Cubico e Qtd Volume) depois de impresso no DACTE.
			cPPPesoB  := ""
			cPPPeso3  := ""
			cPPMetro3 := ""
			cPPQtdVol := ""
			cPesoBC	  := ""	

			// Conteudo do Box: Componentes do Valor da Prestacao de Servico
			// Conteudo do Box: Informacoes Relativas ao Imposto
			TMSR31Comp()

			cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
			If (cAliasPeri)->(!Eof())
				lPerig := .T.
			Else
				lPerig := .F.
			EndIf
			(cAliasPeri)->(DbCloseArea())

			// BOX: DOCUMENTOS ORIGINARIOS
			oDacte:Box(0502, 0000, 0559, 0559)
			If Empty(cCtrDpc)
				oDacte:Say(0508 , 0243, "Documentos Originários", oFont08N)
			Else
				oDacte:Say(0508 , 0143, "Documentos Originários",oFont08N)
				oDacte:Say(0508 , 0443, "Documentos Anteriores ",oFont08N)
			EndIf

			oDacte:Line(0510, 0000, 0510, 0559)	// Linha: Abaixo    DOCUMENTOS ORIGINARIOS
			oDacte:Line(0510, 0283, 0590, 0283)	// Linha: Separador DOCUMENTOS ORIGINARIOS
			
			oDacte:Say(0517 , 0003, "Tp. Doc."           , oFont08N)
			If !Empty(aDocOri) .And. Empty(AllTrim(aDocOri[1][doDTC_NFEID]))
				oDacte:Say(0517 , 0033, "CNPJ/CPF Emitente"  , oFont08N)
			EndIf
			oDacte:Say(0517 , 0163, "Série/Nr. Documento", oFont08N)
			oDacte:Say(0517 , 0286, "Tp. Doc."           , oFont08N)
			If !Empty(aDocOri) .And. Empty(AllTrim(aDocOri[1][doDTC_NFEID]))
				oDacte:Say(0517 , 0316, "CNPJ/CPF Emitente"  , oFont08N)
			EndIf
			oDacte:Say(0517 , 0448, "Série/Nr. Documento", oFont08N)
					
			// Documentos Originarios
			lControl := .F.
			nLInic   := 0525

			nCount := 0
			aDoc   := {}

			For nCount := 1 to Len( aDocOri )
				lControl := !lControl
				If nCount < 11
					If Empty(cCtrDpc)
						If lControl
							If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
								//-- Imprime a Chave da NF-e, lado esquerdo
								oDacte:Say(nLInic, 0003, "NF", oFont08)
								oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
							ElseIf Len(aDocOri[nCount]) >= doDTC_CTEID .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID])) 
								//-- Imprime a Chave da CT-e docAnt, lado esquerdo
								cChaveA := (AllTrim(aDocOri[nCount][doDTC_CTEID]))
								oDacte:Say(nLInic, 0003, "CT-E CHAVE:", oFont08)
								oDacte:Say(nLInic, 0073, cChaveA, oFont08)
								cChaveA := ''
							ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
								//-- Imprime os dados do documento não fiscal do lado esquerdo.
								oDacte:Say(nLInic, 0003, "OUTROS", oFont08)
								oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)						
							Else
								//-- Imprime a Chave da NF-e, lado esquerdo
								cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
								If  SubStr(cChaveA, 21, 2) == '99'
									oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
								Else	
									oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
								EndIf	
								oDacte:Say(nLInic, 0073, SUBSTR(cChaveA,1,22), oFont08)
								oDacte:Say(nLInic, 0168, SUBSTR(cChaveA,23,3) + " " + SUBSTR(cChaveA,26,9), oFont08N)
								oDacte:Say(nLInic, 0223, SUBSTR(cChaveA,35,10), oFont08)
								cChaveA := ''
							EndIf

						Else
							If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
								//-- Imprime a Chave da NF-e, lado direito
								oDacte:Say(nLInic, 0286, "NF", oFont08)
								oDacte:Say(nLInic, 0316, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
							ElseIf Len(aDocOri[nCount]) >= doDTC_CTEID .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID])) 
								//-- Imprime a Chave da CT-e docAnt, lado direito
								cChaveB := (AllTrim(aDocOri[nCount][doDTC_CTEID]))
								oDacte:Say(nLInic, 0286, "CT-E CHAVE:", oFont08)
								oDacte:Say(nLInic, 0356, cChaveB, oFont08)
								cChaveB := ''
							ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
								//-- Imprime os dados do documento não fiscal do lado direito.
								oDacte:Say(nLInic, 0286, "OUTROS", oFont08)
								oDacte:Say(nLInic, 0316, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
							Else
								//-- Imprime a Chave da NF-e, lado direito
								cChaveB := AllTrim(aDocOri[nCount][doDTC_NFEID])
								If  SubStr(cChaveB, 21, 2) == '99'
									oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
								Else	
									oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
								EndIf	
								oDacte:Say(nLInic, 0356, SUBSTR(cChaveB,1,22), oFont08)
								oDacte:Say(nLInic, 0451, SUBSTR(cChaveB,23,3) + " " + SUBSTR(cChaveB,26,9), oFont08N)
								oDacte:Say(nLInic, 0506, SUBSTR(cChaveB,35,10), oFont08)
								cChaveB := ''
							EndIf
						EndIf
					ElseIf lControl
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
							oDacte:Say(nLInic, 0003, "NF", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							oDacte:Say(nLInic, 0003, "OUTROS", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)					
						Else
							//-- Imprime a Chave da NF-e, lado direito
							cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
							If  SubStr(cChaveA, 21, 2) == '99'
								oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
							Else	
								oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
							EndIf	
							oDacte:Say(nLInic, 0073, cChaveA, oFont08)
							cChaveA := ''
						EndIf
						If !Empty(cCtrDpc)
							If Empty(cCTEDocAnt)
								oDacte:Say(nLInic, 0286, cDesDocAnt, oFont08)
								oDacte:Say(nLInic, 0316, Transform(AllTrim((cAliasCT)->DPC_CNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(cSerDpc) + " / " + AllTrim(cCtrDpc), oFont08)
							Else
								//-- Imprime a Chave da NF-e, lado esquerdo
								cChaveB := AllTrim(cCTEDocAnt)
								If  SubStr(cChaveB, 21, 2) == '99'
									oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
								Else	
									oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
								EndIf	
								oDacte:Say(nLInic, 0356, cChaveB, oFont08)
								cChaveB := ''
							EndIf
						EndIf
					EndIf
				Else
					cTipoDoc := IIf(Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC])),'Outros',IIf(Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])),'NF','NF-e'))
					If cTipoDoc == 'Outros' .And. !Empty(AllTrim(aDocOri[nCount][doDTC_CTEID]))
						cTipoDoc := 'CT-e'
						aadd(aDoc,{ AllTrim(cRemCNPJ), AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),	AllTrim(aDocOri[nCount][doDTC_CTEID]), cTipoDoc})					
					Else
						aadd(aDoc,{ AllTrim(cRemCNPJ),;
							AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),;
							AllTrim(aDocOri[nCount][doDTC_NFEID]),cTipoDoc})
							//--Acrescenta o Tipo do Documento no aDoc
					EndIf
				EndIf

				// FORCAR A "QUEBRA" DA LINHA
				If ( (mod(nCount,2)) == 0 )
					If nCount < 11
						If !Empty(cChaveA)
							nLInic += 0008
							If  SubStr(cChaveA, 21, 2) == '99'
								oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
							Else	
								oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
							EndIf
							oDacte:Say(nLInic, 0073, cChaveA, oFont08)
							cChaveA := ''
						
							If !Empty(cChaveB)
								If  SubStr(cChaveB, 21, 2) == '99'
									oDacte:Say(nLInic, 0286, "DC-E CHAVE:", oFont08)
								Else	
									oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
								EndIf
								oDacte:Say(nLInic, 0356, cChaveB, oFont08)
								cChaveB := ''
							EndIf
						EndIf
						
						nLInic += 0008
					EndIf
				EndIf
			Next nCount
			nLInic := 2050
		Else
			TMSR31Cmp()
			TMSR31Comp()
		EndIf
		
		// BOX: PREVISÃO DO FLUXO CARGA
		oDacte:Box(0561 , 0000, 0590, 0559)
		oDacte:Say(0568,  0245, "Previsão do Fluxo de Carga", oFont08N)
		oDacte:Line(0569, 0000, 0569, 0559)	// Linha: Abaixo    
		oDacte:Say(0575,  0003, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Origem", oFont07)
		oDacte:Say(0583,  0003, cOriUFPre, oFont07)
		oDacte:Say(0575,  0188, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Passagem", oFont07)
		oDacte:Say(0575,  0374, "Sigla ou Código da Filial/Porto/Estação/Aeroporto de Destino", oFont07)
		oDacte:Say(0583,  0374, cDesUFPre, oFont07)
		oDacte:Line(0569, 0186, 0590, 0186)	// Linha: Separadoras
		oDacte:Line(0569, 0372, 0590, 0372)	// Linha: Separadoras

		// BOX: OBSERVACOES GERAIS
		oDacte:Box(0592,  0000, 0683, 0559)	
		oDacte:Say(0598,  0258, "Observações Gerais", oFont08N)
		oDacte:Line(0600, 0000, 0600, 0559) // Linha: OBSERVACOES
		nCountObs := 9
		If (cAliasCT)->DT6_AMBIEN == 2 .And. Empty((cAliasCT)->DT6_CHVCTG)
			cObsStat := "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO"
			nCountObs -= 1
			cTagObs := 'OBSGER1;'
		ElseIf !Empty((cAliasCT)->DT6_CHVCTG) .And. Substr((cAliasCT)->DT6_CHVCTG,3,1) == "5"  //"7-Contingência FS-DA"
			cObsStat := "DACTE em Contingência - impresso em decorrência de problemas técnicos"
			nCountObs -= 1
			cTagObs := 'OBSGER1;' 
		EndIf

			//Personalizado
			aMsg := GetSubContratacao((cAliasCT)->DT6_DOC,(cAliasCT)->DT6_SERIE)
			If Len(aMsg) > 0
				nLinMsg	:= 0618
				For nMsg := 1 To Len(aMsg)
					oDacte:Say (nLinMsg, 0003, aMsg[nMsg] , oFont08)
					nLinMsg += 10
				Next nMsg
			Endif	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ BOX: OBSERVACOES                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("DT6") //-- Nao retirar
		cDT6Obs := " "
		If XmlChildEx(oNfe:_CTE:_INFCTE:_IMP,'_INFADFISCO') == Nil
			cDT6Obs := " "
		Else
			cDT6Obs := oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT
		EndIf
		cObsProp := " "
		If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. ;
			XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL,'_RODO') != Nil .AND. ;
			XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO,'_VEIC') != Nil .And. ;
			XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC,'_PROP') != Nil .And. ;
			XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP,'_XNOME') != Nil .And.;
			XmlChildEx(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC,'_TPPROP') != Nil
			If oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT == 'T'
				cObsProp += " Proprietario : " + AllTrim(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_XNOME:TEXT)			
			EndIf
		EndIf
		cDTCObs := " "

		If XmlChildEx(oNfe:_CTE:_INFCTE,'_COMPL') != Nil 
			If XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL,'_XOBS') != Nil
				cDTCObs += oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT
			EndIf
			If XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL, '_OBSCONT') <> Nil
				If ValType(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT) == "A"
					aObsCont := {}
					For nX := 1 to len(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT)
						aAdd(aObsCont, oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nX]:_XTEXTO:TEXT )
					Next nX
				ElseIf XmlChildEx(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT,'_XTEXTO') == Nil
					aObsCont := {""}
				Else
					aObsCont := {oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT}
				EndIf
			EndIf
		EndIf
		// Agendamento de Entrega
		If AliasIndic("DYD")
			If DYD->(FieldPos("DYD_DIAATR"))>0
				cDT6Obs += (" "+Posicione("DYD",2,xFilial("DYD")+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE,"DYD_MOTAGD"))
			EndIf
		EndIf

		cDT6Obs3:= SubStr(cDT6Obs,281,140)
		cDT6Obs2:= SubStr(cDT6Obs,141,140)
		cDT6Obs := SubStr(cDT6Obs,  1,140)
		//-- Popula o vetor de observações
		cObsProp:= SubStr(cObsProp,  1,140)
		nObsStart := 1
		For nCountDTC := 1 To Len(aDTCObserv)		
			aDTCObserv[nCountDTC] := SubStr(cDTCObs ,  nObsStart,140)
			//--Atualiza Tags
			cTagObs += "OBSDTC"+AllTrim(Str(nCountDTC))+";"
			nCountObs -= 1
			nObsStart += 140
		Next nCountDTC
		
		// Tratamento para aproveitar todo o espaco do quadro observacao
		if !Empty(cDT6Obs)
		nCountObs -= 1
		cTagObs += 'OBSDT61;' 
		EndIf
		
		if !Empty(cDT6Obs2)
		nCountObs -= 1
		cTagObs += 'OBSDT62;' 
		EndIf

		if !Empty(cObsProp)
		nCountObs -= 1
		cTagObs  += 'OBSPRO1;' 
		EndIf
		
		// If (nCountObs > 0) .AND. (!Empty(cDTCObs2))
		//   nCountObs -= 1
		//   cTagObs += 'OBSDTC2;' 
		// EndIf
		
		If (nCountObs > 0) .AND. (!Empty(cDT6Obs3))
		nCountObs -= 1
		cTagObs += 'OBSDT63;' 
		EndIf

		nLinhaObs := 0608
		if AT('OBSGER1;',cTagObs) > 0
		oDacte:Say (nLinhaObs, 0003, cObsStat, oFont10N)
		nLinhaObs += 8  
		EndIF
		
		if AT('OBSDT61;',cTagObs) > 0
		oDacte:Say (nLinhaObs, 0003, cDT6Obs, oFont07)
		nLinhaObs += 8  
		EndIF
		
		if AT('OBSDT62;',cTagObs) > 0
		oDacte:Say (nLinhaObs, 0003, cDT6Obs2, oFont07)
		nLinhaObs += 8  
		EndIF
		
		if AT('OBSDT63;',cTagObs) > 0
		oDacte:Say (nLinhaObs, 0003, cDT6Obs3, oFont07)
		nLinhaObs += 8  
		EndIF
		
		//-- Realiza a impressão da observações gerais
		For nCountDTC := 1 To Len(aDTCObserv)
			If AT("OBSDTC" + AllTrim(Str(nCountDTC)) + ";",cTagObs) > 0
				oDacte:Say (nLinhaObs, 0003, aDTCObserv[nCountDTC], oFont07)
				nLinhaObs += 8
			EndIF
		Next nCountDTC
		
		if AT('OBSPRO1;',cTagObs) > 0
		oDacte:Say (nLinhaObs, 0003, cObsProp, oFont07)
		nLinhaObs += 8  
		End IF		

		// BOX: INFORMACOES ESPECIFICAS DO MODAL
		nLinIEM := 40
		If  oNfe:_CTE:_INFCTE:_IDE:_modal:TEXT == "06" // do tipo MultiModal 
			oDacte:Box(0688+nLinIEM, 0000, 0717+nLinIEM, 0559)
			oDacte:Say(0651+nLinIEM, 0210, "Informações Específicas do Transporte Multimodal de Cargas", oFont08N)
			oDacte:Line(0654+nLinIEM, 0000, 0654+nLinIEM, 0559)
			oDacte:Say(0664+nLinIEM, 0003, "COTM da Empresa: " + cTmsCOTM	, oFont08)

			If (XmlChildEx(oNFE:_CTE:_INFCTE,'_INFCTENORM')) <> Nil .And. (XmlChildEx(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL,'_MULTIMODAL')) <> NIL //Existe Stru da MultiModal.
				cIndNegoci := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_MULTIMODAL:_indNegociavel:TEXT

				oDacte:Box(0658+nLinIEM, 0295, 0666+nLinIEM, 0285)
				oDacte:Say(0664+nLinIEM, 0300, "Negociável" , oFont08)	 
				
				oDacte:Box(0658+nLinIEM, 0350, 0666+nLinIEM, 0360)
				oDacte:Say(0664+nLinIEM, 0368, "Não Negociável" , oFont08)
				
				If (cIndNegoci == "1") 			
					oDacte:Say(0664+nLinIEM, 0287, "X" /* DTC_INDNEG */	, oFont08) 
				Else
					oDacte:Say(0664+nLinIEM, 0352, "X" /* DTC_INDNEG */	, oFont08)
				EndIf
			EndIf
		Else
			oDacte:Box(0645+nLinIEM, 0000, 0672+nLinIEM, 0559)
			oDacte:Say(0651+nLinIEM, 0210, "Informações do Modal Rodoviário", oFont08N)
			oDacte:Line(0654+nLinIEM, 0000, 0654+nLinIEM, 0559)
			oDacte:Say(0661+nLinIEM, 0003, "RNTRC da Empresa: " + cTmsAntt	, oFont08)
		EndIf

		// BOX: USO EXCLUSIVO DO EMISSOR + RESERVADO AO FISCO
		oDacte:Box(0674+nLinIEM , 0000, 0720+nLinIEM, 0559)  
		oDacte:Say(0681+nLinIEM , 0090, "USO EXCLUSIVO DO EMISSOR DO CT-E", oFont08N)
		nSoma := 0
		For nX := 1 to len(aObsCont)
			If nX > 3
				Exit
			EndIf
			oDacte:Say(0690 + nSoma+nLinIEM, 0003, aObsCont[nX], oFont08)
			nSoma += 10
		Next
		oDacte:Say(0681+nLinIEM , 0420, "RESERVADO AO FISCO", oFont08N)
		oDacte:Line(0683+nLinIEM, 0000, 0683+nLinIEM, 0559)	//Linha Horizontal
		oDacte:Line(0674+nLinIEM, 0355, 0720+nLinIEM, 0355)	//Linha Vertical

		// Atualizar o Status de Impressao no CTe
		DT6->(dbSetOrder(1))
		If	DT6->(MsSeek(xFilial('DT6')+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE))
			RecLock('DT6',.F.)
			DT6->DT6_FIMP := StrZero(1, Len(DT6->DT6_FIMP)) //Grava Flag de Impressao
			MsUnLock()
		EndIf
		oDacte:EndPage()

		//-- aDoc > 0, existe mais de uma pagina com Doc a ser impressa.
		//-- lPerig .T. existem produtos perigosos a serem impressos.
		If Len(aDoc) > 0 .OR. lPerig
			//-- Caso de mais de uma pagina, chama a funcao para montar as paginas seguites.
			TMSR35Cont( aDoc, aCab[nCont] )
		EndIf
	Endif //customização
	(cAliasCT)->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TERMINO ROTINA DE IMPRESSAO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aImpCteFood) > 0 //customização
oDacte:Preview()
Else 
	MsgInfo("Não há documentos para impressão","COMFRIO")	
Endif

(cAliasCT)->(dbCloseArea())

/*
	Personalizado - Brunno de Medeiros da Costa 06/06/2017
	*/
	//--Início   /*
	If GetNewPar("ZZ_HBOLCTE",.F.)//Habilita Impressão de Boleto CTE junto ao DACTE
		aAreaAtu := GetArea()
		aAreaSE1	:= SE1->(GetArea())
		aAreaSF2	:= SF2->(GetArea())
		aAreaSF3	:= SF3->(GetArea())
		aAreaSE1	:= SE1->(GetArea())

		If checaImpressaoBoleto() //Aqui ja foram passados os parametros para o boleto
			FWAlertInfo("[DANFEII] Impressão do Boleto Ativada.")
			
			MsgRun("Imprimindo Boletos...","TOTVS",{|| imprimeBoleto(oDacte) })
			
		Else
			FWAlertInfo("[DANFEII] Impressão do Boleto Desativada.")
		Endif

		RestArea(aAreaSE1)
		RestArea(aAreaSF3)
		RestArea(aAreaSF2)
		RestArea(aAreaSE1)
		RestArea(aAreaAtu)
	Endif
	//--Término

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |TMSR35Cont³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descri‡…o ³Caso de mais de uma pagina, chama a funcao para montar      ³±±
±±³          ³as paginas seguites.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSR35Cont(aDoc, aCab, aPerigo, nCnt)
Local oFont08	:= TFont():New( "Times New Roman", 08, 08, , .F., , , , .T., .F. )
Local oFont08N	:= TFont():New( "Times New Roman", 08, 08, , .T., , , , .T., .F. )
Local lControl	:= .F.
Local nCount	:= 0
Local aDoc1		:= {}
Local cChaveA	:= ''
Local cChaveB	:= ''

//Variaveis Produtos Perigosos
Local nCompr	:= 42	//Comprimento Padrao da Primeira Linha
Local nSegLinha	:= 1	//Trecho a ser Impresso para cada linha
Local lVerif	:= .F.	//Evita Repeticao de Impressao
Local lVerifCls := .F.
Local lFimPerig	:= .F.

Default nCnt	:= 1
Default aPerigo	:= {}
Default aDoc	:= {}
Default aCab	:= {}

oDacte:StartPage()
oDacte:SetPaperSize( Val( GetProfString( GetPrinterSession(), "PAPERSIZE", "1", .T. ) ) )

// Funcao responsavel pela montagem do cabecalho do DACTE
TMSR31Cab( aCab, .F. )

// BOX: DOCUMENTOS ORIGINARIOS
oDacte:Box(	0224, 0000, 0593, 0559)
oDacte:Say(	0230, 0210, "Documentos Originários",	oFont08N )
oDacte:Line(0232, 0000, 0232, 0559)							// Linha: DOCUMENTOS ORIGINARIOS
oDacte:Line(0232, 0280, 0593, 0280)							// Linha: Separador DOCUMENTOS ORIGINARIOS
oDacte:Say(	0238, 0003, "Tp.Doc",					oFont08N )

If Len(aDoc) > 0 .AND. Empty(AllTrim(aDoc[1][3]))
	oDacte:Say( 0238, 0033, "CNPJ/CPF Emitente",	oFont08N )
EndIf

oDacte:Say(	0238, 0163, "Série/Nr.Documento",		oFont08N )
oDacte:Say(	0238, 0286, "Tp.Doc",					oFont08N )

If Len(aDoc) > 0 .AND. Empty(AllTrim(aDoc[1][3]))
	oDacte:Say( 0238, 0316, "CNPJ/CPF Emitente",	oFont08N )
Endif

oDacte:Say( 0238, 0448, "Série/Nr.Documento",		oFont08N )

// Imprime as NF
lControl := .F.
nLInic := 0244
For nCount := 1 To Len(aDoc)
	lControl := !lControl

	If nCount < 75         
		If (lControl == .T.)			
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0003, aDoc[nCount,4],										oFont08)
				oDacte:Say(nLInic, 0033, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),		oFont08)
				oDacte:Say(nLInic, 0163, aDoc[nCount,2],										oFont08)
			ElseIf Upper(aDoc[nCount,4]) == "CT-E"
				cChaveA     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0003, "CT-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0073, cChaveA,												oFont08)
				cChaveA := ''
			Else
				cChaveA     := aDoc[nCount,3]
				If  SubStr(cChaveA, 21, 2) == '99'
					oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
				Else	
					oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
				EndIf				
				oDacte:Say(nLInic, 0073, SUBSTR(cChaveA,1,22),									oFont08)
				oDacte:Say(nLInic, 0168, SUBSTR(cChaveA,23,3) + " " + SUBSTR(cChaveA,26,9),		oFont08N)
				oDacte:Say(nLInic, 0223, SUBSTR(cChaveA,35,10),									oFont08)
				cChaveA     := ''
			EndIf
			
		Else
			If Empty(aDoc[nCount,3])
				oDacte:Say(nLInic, 0286, aDoc[nCount,4],									    oFont08)
				oDacte:Say(nLInic, 0316, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),		oFont08)
				oDacte:Say(nLInic, 0448, aDoc[nCount,2],										oFont08)
			ElseIf Upper(aDoc[nCount,4]) == "CT-E"
				cChaveB     := aDoc[nCount,3]
				oDacte:Say(nLInic, 0286, "CT-E CHAVE:",											oFont08)
				oDacte:Say(nLInic, 0356, cChaveB,												oFont08)
				cChaveB := ''
			Else
				cChaveB     := aDoc[nCount,3]
				If  SubStr(cChaveB, 21, 2) == '99'
					oDacte:Say(nLInic, 0286, "DC-E CHAVE:",										oFont08)
				Else	
					oDacte:Say(nLInic, 0286, "NF-E CHAVE:",									    oFont08)
				EndIf						
				oDacte:Say(nLInic, 0356, SUBSTR(cChaveB,1,22),									oFont08)
				oDacte:Say(nLInic, 0451, SUBSTR(cChaveB,23,3) + " " + SUBSTR(cChaveB,26,9),		oFont08N)
				oDacte:Say(nLInic, 0506, SUBSTR(cChaveB,35,10),									oFont08)
				cChaveB     := ''
			EndIf
			nLInic += 0008
		EndIf		
	Else
		AAdd( aDoc1, { aDoc[nCount,1], aDoc[nCount,2], aDoc[nCount,3], aDoc[nCount,4] } )
	EndIf
	
Next nCount

// Imprime a ultima Chave.
// FORCAR A "QUEBRA" DA LINHA
If !Empty(cChaveA)
	nLInic += 0008
	If  SubStr(cChaveA, 21, 2) == '99'
		oDacte:Say(nLInic, 0003, "DC-E CHAVE:", oFont08)
	Else	
		oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
	EndIf	
	oDacte:Say(nLInic, 0073,cChaveA ,			oFont08)
	cChaveA := ''

	If !Empty(cChaveB)
		If  SubStr(cChaveB, 21, 2) == '99'
			oDacte:Say(nLInic, 0256, "DC-E CHAVE:", oFont08)
		Else	
			oDacte:Say(nLInic, 0256, "NF-E CHAVE:", oFont08)
		EndIf
		oDacte:Say(nLInic, 0356, cChaveB,		oFont08)
		cChaveB := ''
	EndIf
EndIf

// BOX: Produtos Perigosos
cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
nSoma   := 1380
nQtdTotal := 0

If (cAliasPeri)->(!Eof())
	nDifEsq:= 110
	nLInic := 2214
	oDacte:Box(0645 , 0000, 0820, 0559)
	oDacte:Say(0651 , 0200, "Informações sobre Produtos Perigosos", oFont08N)
	nSoma  := 12
	oDacte:Line(0653, 0000, 0653, 0559)		// Linha Horizontal
	oDacte:Line(0653, 0032, 0820, 0032 )	// Linha Divisoria Nro. Onu X Nome Apropriado
	oDacte:Line(0653, 0262, 0820, 0262 )	// Linha Divisoria Nome Apropriado X Classe/Subclasse e Risco Subsidiário
	oDacte:Line(0653, 0470, 0820, 0470 )	// Linha Divisoria Classe Subclasse e Risco Subsidiário X Grupo de Embalagem	
	oDacte:Line(0653, 0511, 0820, 0511 )	// Linha Divisoria Grupo de Embalagem X Qto. Tot. Produto	
	
	oDacte:Say(0659 , 0002, "Nº Onu"			, oFont08N)
	oDacte:Say(0659 , 0035, "Nome Apropriado" 	, oFont08N)
	oDacte:Say(0659 , 0265, "Classe/Subclasse e Risco Subsidiário", oFont08N)
	oDacte:Say(0659 , 0474, "Grp.Emb.", oFont08N)
	oDacte:Say(0659 , 0513, "Qtde.Produto" , oFont08N)
	nLInic :=  0670
	
	If Len(aPerigo) <= 0
		Do While (cAliasPeri)->(!EoF())
			If DTC_PESO == 0
				nQtdTotal := Str(DTC_QTDVOL)
			Else
				nQtdTotal := Str(DTC_PESO)
			EndIf
			AAdd(aPerigo,{	(cAliasPeri)->DY3_ONU,;
							(cAliasPeri)->DY3_DESCRI,;
							AllTrim((cAliasPeri)->DY3_CLASSE) + ' ' + (cAliasPeri)->DY3_NRISCO, ;
							(cAliasPeri)->DY3_GRPEMB,;
							(cAliasPeri)->(nQtdTotal)})
			(cAliasPeri)->(dbSkip())
		EndDo
	Else
		If DTC_PESO == 0
			nQtdTotal := Str(DTC_QTDVOL)
		Else
			nQtdTotal := Str(DTC_PESO)
		EndIf	
	EndIf

	For nCnt := nCnt to Len(aPerigo)														//Verifica tamanho do array
		oDacte:Say(nLInic , 0002,     aPerigo[nCnt][1]   , oFont08)							//Nro. Onu
		For nSegLinha:= nSegLinha To Len(aPerigo[nCnt][2])									
			oDacte:Say(nLInic , 0035,Substr(aPerigo[nCnt][2],nSegLinha,nCompr), oFont08)	//Nome Apropriado 																										
			If !lVerif
				oDacte:Say(nLInic , 0265, aPerigo[nCnt][3]  , oFont08)		//Classe/Subclasse e Risco Subsidiário - Maximo 33 Caracteres
				oDacte:Say(nLInic , 0477,aPerigo[nCnt][4] 	, oFont08)						//Grupo de Embalagem
				oDacte:Say(nLInic , 0510,aPerigo[nCnt][5]	, oFont08)						//Qto. Tot. Produto
				lVerif := .T.
			EndIf
			nSegLinha += nCompr -1
			If Len(aPerigo[nCnt][2]) > nSegLinha
				nLInic += 0008
			EndIf
			If nLInic >= 0770		//Verifica se chegou ao fim da pagina
				lFimPerig := .T.
				Exit
			EndIf
		Next
		If lFimPerig
			Exit
		EndIf
		nSegLinha := 1
		lVerif	:= .F. // Reinicia valor para o proximo elemento
		lVerifCls := .F.
	Next
	nCnt++
EndIf

(cAliasPeri)->(DbCloseArea())

// Linha de finalizacao.
oDacte:EndPage()

// Se existir mais doc para outra pagina, chama a mesma funcao.
If Len(aDoc1) > 1
	TMSR35Cont(aDoc1,aCab)
EndIf

// Se existir mais prod perigoso para outra pagina, chama a mesma funcao.
If nLInic >= 0820
	TMSR35Cont(,aCab,aPerigo,nCnt)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR31Cab³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o cabecalho do relatorio      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSR31Cab(aCab, lImpCan, lXmlCont)
Local oFont07    := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local oFont07N   := TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont08    := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
Local oFont08N   := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont10N   := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local cTpServ    := ''
Local cProtocolo := ''
Local cStartPath := GetSrvProfString("Startpath","")
Local cLogoTp	 := cStartPath + "logoCte" + cEmpAnt + ".BMP" //Insira o caminho do Logo da empresa logada, na variavel cLogoTp.
Local cQrCode    := ''
Local nPosSign   := 0

Default lXmlCont := .F.
Default lImpCan  := .F.

If	IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

If  !File(cLogoTp)
	cLogoTp    := cStartPath + "logoCte.bmp"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: CANHOTO - 0746                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	lImpCan

	_cCgcDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_CGC")
	_cNomDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_NOME")
	_cMunDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_MUN")
	_cEstDev :=Posicione("SA1",1,xFilial("SA1")+(cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV,"A1_EST")
	
	oDacte:Box(0020, 0000, 0082, 0559)
	oDacte:Say(026 , 0005, "TOMADOR: " + SPACE(05) +Transform(_cCgcDev, PesqPict("SA1","A1_CGC"))+ '  -  ' + SPACE(05) +;
	_cNomDev + '  -  ' + SPACE(05) + _cMunDev + '  -  '  + _cEstDev, oFont07N )
	
	oDacte:Line(0029, 0000, 0029, 0559) // Linha horizontal
	oDacte:Say(0036 , 0001, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont07)
	oDacte:Line(0039, 0000, 0039, 0559) // Linha horizontal
	
	oDacte:Line(0062, 0000, 0062, 0166) // Linha Horizontal: Separador NOME e RG
	oDacte:Line(0062, 0416, 0062, 0513) // Linha Horizontal: Separador CHEGADA e SAIDA
	
	oDacte:Line(0039, 0166, 0082, 0166) // Linha vertical
	oDacte:Line(0039, 0416, 0082, 0416) // Linha vertical
	oDacte:Line(0039, 0513, 0082, 0513) // Linha vertical
	
	oDacte:Say(0047 , 0005, "NOME"               	, oFont07N)
	oDacte:Say(0047 , 0421, "Término Prest.Data/Hora"	, oFont07N)
	oDacte:Say(0047 , 0530, "CT-E"					, oFont07N)
	oDacte:Say(0057 , 0518, "No DOC. " , oFont07N)
	oDacte:Say(0067 , 0518, cValtoChar( Val(aCab[1]))	, oFont07N)
	oDacte:Say(0079 , 0518, "SÉRIE: "+cValtoChar( Val(aCab[2]))	, oFont07N)
	oDacte:Say(0070 , 0005, "RG"                	, oFont07N)
	oDacte:Say(0079 , 0241, "ASSINATURA / CARIMBO"  , oFont07N)
	oDacte:Say(0070 , 0421, "Início Prest.Data/Hora"  	, oFont07N)
EndIf

oDacte:Box(0086, 0000, 0148, 0240)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa + 0050                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:SayBitmap(0088, 0005,cLogoTp,0088,0057 )		//Logo

If XmlChildEx(oNfe:_CTE:_INFCTE,'_EMIT') <> Nil
	oDacte:Say(0100, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_XNOME:Text),oFont07) 	//Nome Comercial
	oDacte:Say(0110, 0090, 'CNPJ ' + Transform(AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT),"@r 99.999.999/9999-99") +;
						   ' - IE ' + Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT,'_IE'  )==NIL," ",AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_IE:TEXT)), oFont07)
	oDacte:Say(0120, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + ;
						   ", "+ AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_NRO:TEXT) +;
						   Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT,'_XCPL')==Nil, " ", " " + AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XCPL:TEXT) + " ") +;
						   AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT), oFont07)	//Endereço + Bairro      
	oDacte:Say(0130, 0090, AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT) + '  -  ' +;
					       AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT) + ;
						   '  CEP:  ' + Transform(AllTrim(AllTrim(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT)), "@r 99999-999") ,oFont07)	//Cidade, UF, CEP
	oDacte:Say(0140, 0090, AllTrim(Iif(XmlChildEx(oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT,'_FONE')==Nil," ",oNfe:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT))	,oFont07)	//Telefone
Else
	oDacte:Say(0100, 0090, AllTrim(SM0->M0_NOMECOM),oFont07) 	//Nome Comercial
	oDacte:Say(0110, 0090, 'CNPJ ' + Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") + ' - IE ' + AllTrim(SM0->M0_INSC), oFont07)
	oDacte:Say(0120, 0090, AllTrim(SM0->M0_ENDCOB) + ' ' + AllTrim(SM0->M0_BAIRCOB), oFont07)	//Endereço + Bairro      
	oDacte:Say(0130, 0090, AllTrim(SM0->M0_CIDCOB) + '  -  ' + AllTrim(SM0->M0_ESTCOB) + '  CEP:  ' + AllTrim(SM0->M0_CEPCOB) ,oFont07)	//Cidade, UF, CEP
	oDacte:Say(0140, 0090, AllTrim(SM0->M0_TEL)	,oFont07)	//Telefone
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0240, 0133, 0377)					
oDacte:Say(0095, 292, "DACTE", oFont10N)
oDacte:Say(0105, 243, "Documento Auxiliar do Conhecimento", oFont08N)
oDacte:Say(0116, 265, "de Transporte Eletrônico", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: MODAL                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0377, 0133, 0433)
oDacte:Say(0093, 390,"MODAL"     ,oFont08N)
If oNfe:_CTE:_INFCTE:_IDE:_modal:TEXT == "06" // do tipo MultiModal
	oDacte:Say(0116, 380,Upper("MULTIMODAL"),oFont08 ) 
Else
	oDacte:Say(0116, 380,Upper("Rodoviário"),oFont08 ) 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: FOLHA
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0086, 0433, 0133, 0460)
oDacte:Say(0093, 0435, "Folha"  , oFont08N)	//Folha
oDacte:Say(0116, 0437, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³QRCODE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If XmlChildEx( oNfe:_CTE,'_INFCTESUPL') != Nil
	If XmlChildEx( oNfe:_CTE:_INFCTESUPL,'_QRCODCTE' ) != NIL .And. !Empty(oNFE:_CTE:_INFCTESUPL:_QRCODCTE:TEXT  )
		cQrCode := oNfe:_CTE:_INFCTESUPL:_QRCODCTE:TEXT
		If lXmlCont //Contingencia
			nPosSign := At("&sign", cQrCode)
			cQrCode := Substr(cQrCode, 1, nPosSign - 1)
		EndIf 
	EndIf
EndIf
oDacte:QRCODE(190, 466, cQrCode, 90)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Emis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0125, 0240, 0148, 0270)
oDacte:Say(0133, 0242, "Modelo", oFont08N)	//Modelo
oDacte:Say(0144, 0242, "57", oFont08)

oDacte:Box(0125, 0270, 0148 , 0294)
oDacte:Say(0133, 0272, "Série"  , oFont08N)	//Serie
oDacte:Say(0144, 0272, cValtoChar( Val(aCab[2]) ), oFont08)

oDacte:Box(0125, 0294, 0148, 0333)
oDacte:Say(0133, 0295, "Número" , oFont07N)	//Numero
oDacte:Say(0144, 0295, cValtoChar( Val(aCab[1]) ), oFont08)

oDacte:Box(0125, 0333, 0148, 0396)
oDacte:Say(0133, 0334, "Emissão", oFont07N) //Emissao
oDacte:Say(0144, 0334, 	SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[3]), 1, 4) + "-" +; 
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", oFont07)
oDacte:Box(0125, 0396, 0148, 0460)
oDacte:Say(0133, 0397, "Ins SUFRAMA Des"  , oFont07N)	//Insc. SUFRAMA Destinatário
oDacte:Say(0144, 0397, Iif(XmlChildEx(oNfe:_CTE:_INFCTE,'_DEST') <> Nil .And. XmlChildEx(oNfe:_CTE:_INFCTE:_DEST,'_ISUF') <> Nil, oNfe:_CTE:_INFCTE:_DEST:_ISUF:TEXT, " "), oFont07)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0173, 0460, 0185, 0460)
If	AllTrim((cAliasCT)->DT6_CHVCTG)<>''
	oDacte:Code128C(172.4,286,(cAliasCT)->DT6_CHVCTE, 24)	
	oDacte:Code128C(208.2,286,(cAliasCT)->DT6_CHVCTG, 23)
Else
	oDacte:Code128C(171.4,286,(cAliasCT)->DT6_CHVCTE, 24)	
	oDacte:Say(0205, 0282, "Consulta em: http://www.cte-fazenda.gov.br/portal", oFont07)
EndIf	
oDacte:Line(0173, 0280, 0173, 0460 )	//Linha Separadora
oDacte:Say( 0178, 0282,"Chave de acesso",oFont07)
If oDacte:nDevice == 2
	oDacte:Say( 0185, 0281, Transform(AllTrim(aCab[5]),"@r 9999999999999999 9999999999999999 999999999999"), oFont07)
Else 
	oDacte:Say( 0185, 0282, Transform(AllTrim(aCab[5]),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), oFont07N)
EndIf

oDacte:Line(0186, 0280, 0186, 0460 )	//Linha Separadora 
oDacte:Line(0209, 0280, 0209, 0559 )	//Linha Separadora
oDacte:Say(0214,  0282, "Protocolo de Autorização de uso", oFont07)
oDacte:Line(0217, 0280, 0217, 0559 )	//Linha Separadora

oDacte:Line(0173, 0460, 0209, 0460 )	//Linha Vertical
oDacte:Line(0209, 0559, 0217, 0559 )	//Linha Vertical

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0148, 0000, 0170, 0280) 
oDacte:Say(0157, 0003, "Tipo do CT-e"   , oFont08N)
oDacte:Say(0157, 0143, "Tipo de Serviço", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe  Globalizado                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDacte:Box(0170, 0000, 0195, 0280)
oDacte:Say(0180, 0003, "Indicador CT-e Globalizado"  , oFont08N)

If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE,'_INDGLOBALIZADO') <> NIL .And. AllTrim(oNfe:_CTE:_INFCTE:_IDE:_INDGLOBALIZADO:Text) == "1"
	oDacte:Say(0190, 0003, "Sim"  , oFont08N)
Else
	oDacte:Say(0190, 0003, "Não"  , oFont08N)
EndIf

oDacte:Say(0180, 0143, "Informações CT-e Globalizado", oFont08N)
oDacte:Line(0148,0140, 0195, 0140)  //Linha Vertical Tipo CT-e / Inf. CT-e Globalizado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Conhecimento                                            ³
//³ 0 - Normal                                                      ³
//³ 1 - Complemento de Valores                                      ³
//³ 2 - Emitido em Hipotese de anulacao de Debito                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( AllTrim((cAliasCT)->DT6_DOCTMS) == "8" )
	oDacte:Say(0167,  0003, "COMPLEMENTO"	, oFont08)
ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "P" )
	oDacte:Say(0167,  0003, "SUBSTITUTO"		, oFont08)	
ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "M" )
	oDacte:Say(0167,  0003, "ANULACAO"		, oFont08)
Else
	oDacte:Say(0167,  0003, "NORMAL"		, oFont08)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Servico                                                 ³
//³ 0 - Normal                                                      ³
//³ 1 - SubContratacao                                              ³
//³ 2 - Redespacho                                                  ³
//³ 3 - Redespacho Intermediario                                    ³
//³ 4 - Serviço Vinculado a Multimodal                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           ³
//³   0 - Normal                                                    ³
//³   1 - Devolucao                                                 ³
//³   2 - SubContratacao                                            ³
//³   3 - Dcto Nao Fiscal                                           ³
//³   4 - Exportacao                                                ³
//³   5 - Redespacho                                                ³
//³   6 - Dcto Nao Fiscal 1                                         ³
//³   7 - Dcto Nao Fiscal 2                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTpServ := oNfe:_CTE:_INFCTE:_IDE:_tpserv:TEXT

If (cTpServ $ '0')
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
ElseIf (cTpServ == '1')
	oDacte:Say(0167, 0145, "SUBCONTRATAÇÃO"		, oFont08)
ElseIf (cTpServ == '2')
	oDacte:Say(0167, 0145, "REDESPACHO"			, oFont08)
ElseIf (cTpServ == '3')
	oDacte:Say(0167, 0145, "REDESPACHO INTERM"			, oFont08)	//--Redespacho Intermediário
ElseIf (cTpServ == '4')
	oDacte:Say(0167, 0145, "SERV.VINC.MULTIMODAL"			, oFont08)	//--Serviço vinculado Multimodal
Else
	oDacte:Say(0167, 0145, "NORMAL"				, oFont08)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero Protocolo + Data e Hora Autorizacao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄadminÙ
cProtocolo := aCab[6] + " " + aCab[8] + " " + aCab[9]
oDacte:Say(0214,  0378, cProtocolo, oFont08)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSR27Comp³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o BOX com as informacoes do   ³±±
±±³          ³componentes do frete e impostos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSR31Comp()
Local cLabel      	:= ''
Local nCInic      	:= 0			// Coluna Inicial
Local oFont08     	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N    	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N    	:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local lControl    	:= .F.
Local nCount      	:= 0
Local nCount_2    	:= 0
Local cSitTriba		:= "Sit Trib"
Local cBaseIcms		:= ''			//-- Base de Calculo
Local cAliqIcms		:= ''			//-- Aliquota ICMS
Local cValIcms		:= ''			//-- Valor ICMS
Local cRedBcCalc	:= ''			//-- "Red.Bc.Calc."
Local nCount_3		:= 0
Local aComp			:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DA PRESTACAO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lComp
	nLInic	:= 0474
	nLFim	:= 0532	
Else
	nLInic	:= 0414
	nLFim	:= 0472	
EndIf

oDacte:Box(nLInic, 0000, nLFim, 0559)

nLInic	+= 0008
oDacte:Say(nLInic, 0210, "Componentes do Valor da Prestação de Serviço", oFont08N)
	
nLInic	+= 0004
	
oDacte:Line(nLInic, 0000, nLInic, 0559) // Linha: Componentes da Prestacao
oDacte:Line(nLInic, 0140, nLFim, 0140) // Linha: Separador Vertical
oDacte:Line(nLInic, 0280, nLFim, 0280) // Linha: Separador Vertical
oDacte:Line(nLInic, 0420, nLFim, 0420) // Linha: Separador Vertical
	
nLInic	+= 0006
oDacte:Say(nLInic, 0003, "Nome",	oFont08N)
oDacte:Say(nLInic, 0073, "Valor",	oFont08N)
oDacte:Say(nLInic, 0143, "Nome",	oFont08N)
oDacte:Say(nLInic, 0213, "Valor",	oFont08N)
oDacte:Say(nLInic, 0283, "Nome",	oFont08N)
oDacte:Say(nLInic, 0353, "Valor",	oFont08N)
oDacte:Say(nLInic, 0423, "Valor Total da Prestação do Serviço", oFont08N)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Componentes do Valor da Prestacao de Servico                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DT8 - Componentes do Frete                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLInic		+= 0008
nCInic		:= 0003
lControl	:= .F.

	aComp := TMSGetComp( oNfe )
		
	For nCount_3 := 1 To Len( aComp )
		nCount += 2
		oDacte:Say(nLInic, nCInic, Substr(AllTrim(aComp[nCount_3][1]),1,14), oFont08)	//Descricao do Componente
		nCInic += 0070	//Proxima Coluna

		oDacte:Say(nLInic, nCInic, Transform(Val(AllTrim(aComp[nCount_3][2])),'@E 999,999,999.99'), oFont08)	//Valor do Componente
		nCInic += 0070	//Proxima Coluna


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( (mod(nCount,6)) == 0 )
			nCount_2 += 1
			Do Case
				Case ( nCount_2 == 1 )
				cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
				Case ( nCount_2 == 2 )
				cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999,999.99'),20)
			EndCase
				
			oDacte:Say(nLInic + 4 , 0423, cLabel, oFont10N)
			nLInic   += 0008
			nCInic   := 0003
		EndIf
	Next nCount_3
	For nCount := (1 + nCount) To 24
		lControl := !lControl
		nCInic   += 0070
		cLabel   := ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( (mod(nCount,6)) == 0 )
			nCount_2 += 1
			Do Case
				Case ( nCount_2 == 1 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999,999.99'),20)
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999,999.99'),20)
			EndCase
			
			oDacte:Say(nLInic, 0423, cLabel, oFont10N)
			nLInic   += 0008
			nCInic   := 0003
		EndIf
	Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: INFORMACOES RELATIVAS AO IMPOSTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lComp
	nLInic	:= 0474
	nLFim	:= 0500	
Else
	nLInic	:= 0534
	nLFim	:= 0560
EndIf

oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0212, "Informações Relativas ao Imposto", oFont08N)

nLInic += 0002
oDacte:Line(nLInic, 0000, nLInic, 0559)	// Linha:
oDacte:Line(nLInic, 0240, nLFim, 0240)	// Linha: Separador Situacao Trib	/ Base de Calculo
oDacte:Line(nLInic, 0350, nLFim, 0350) 	// Linha: Separador Base de Calculo	/ Aliq.ICMS
oDacte:Line(nLInic, 0400, nLFim, 0400) 	// Linha: Separador Aliq.ICMS    	/ Valor ICMS
oDacte:Line(nLInic, 0470, nLFim, 0470) 	// Linha: Separador Valor ICMS    	/ %Red Bc.Calc

nLInic += 0008
oDacte:Say(nLInic , 0003, "Classificação Tributária", oFont08N)   // Label: Classificação Tributária
oDacte:Say(nLInic , 0243, "Base de Cálculo"    , oFont08N)   // Label: Base de Cálculo
oDacte:Say(nLInic , 0353, "Aliq. ICMS"         , oFont08N)   // Label: Aliq.ICMS
oDacte:Say(nLInic , 0403, "Valor ICMS"         , oFont08N)   // Label: Valor ICMS
oDacte:Say(nLInic , 0473, "%Red. Bc. Calc."    , oFont08N)   // Label: %Red.Bc.Calc.

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS00>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS00') == NIL .AND. !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST') == NIL

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS45>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS45') == Nil .AND. !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )
		
		(cAliasD2)->(DbCloseArea()) 
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS90>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS90') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)
	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)
		cRedBcCalc := Val(Iif( XmlChildEx(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_pRedBC')==Nil," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT) ))
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS20>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS20') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)
		cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT)
		cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)
		cRedBcCalc := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_pRedBC:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS60>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS60') == Nil

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,'_CST') == "U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

		//DECRETO Nº 13.780 DE 16 DE MARÇO DE 2012   TDN https://tdn.totvs.com/pages/releaseview.action?pageId=498708893
		If XmlChildEx(oNfe:_CTE:_INFCTE:_IDE, '_UFINI') <> Nil .And. oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT = "BA"  
			cBaseIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
			cCredPres	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_vCred:TEXT)
			cValIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
			cAliqIcms	:= 0 // Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
		Else
			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
			cCredPres	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_vCred:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
		EndIf

		(cAliasD2)->(DbCloseArea())
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSOUTRAUF') == NIL

		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF,'_CST') == Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5DESCRI),1,40) )

	   	cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_PICMSOUTRAUF:TEXT)
		cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_VBCOUTRAUF:TEXT)
		cValIcms   := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_VICMSOUTRAUF:TEXT)
		
		(cAliasD2)->(DbCloseArea())
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMSSN> Simples Nacional                                   ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/	
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSSN') == Nil
		cSitTriba	:= Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN,'_INDSN')==Nil," "," Simples Nacional ")		
	EndIf

nLInic += 0008
oDacte:Say(nLInic , 0003, cSitTriba,								oFont08)
oDacte:Say(nLInic , 0243, Transform(cBaseIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0353, Transform(cAliqIcms , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0403, Transform(cValIcms  , '@E 999,999,999.99'),	oFont08)
oDacte:Say(nLInic , 0473, Transform(cRedBcCalc, '@E 999,999,999.99'),	oFont08)

lComp := .F. //CTE Complementar

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR27Cmp³ Autor ³Felipe Barbiere           ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o BOX relativo as informacoes ³±±
±±³          ³dos componentes e valores complementados                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSR31Cmp()

Local nCount    := 0
Local nCount_2  := 0
Local oFont08   := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N  := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl  := .F.
Local cAliasChv := ''

lComp := .T.	//CTE Complementar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLInic  := 0400
nLFim   := 0506
oDacte:Box(nLInic , 0000, nLFim, 0559)

nLInic += 0006
oDacte:Say(nLInic , 0210, "Componentes do Valor da Prestação do Serviço", oFont08N)

nLInic += 0002
oDacte:Line(nLInic, 0000, nLInic, 0559)		// Linha: DOCUMENTOS ORIGINARIOS       
oDacte:Line(nLInic, 0279, nLFim , 0279)	// Linha: Separador DOCUMENTOS ORIGINARIOS

nLInic += 0007
oDacte:Say(nLInic , 0003, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 0205, "Valor Complementado", oFont08N)
oDacte:Say(nLInic , 0281, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 0483, "Valor Complementado", oFont08N)

nLInic   += 0008
nCount   := 0
nCount_2 := 0
lControl := .F.

//-- Query para pesquisar a chave do CTE original
cAliasChv :=  GetNextAlias()
cQuery := ''
cQuery += " SELECT DT6.DT6_CHVCTE " +CRLF
cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" +CRLF
cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" +CRLF
cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" +CRLF
cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)

nCount   := 0
While !(cAliasChv)->(Eof())

	nCount   += 1
	lControl := !lControl

	If nCount < 9

		If (lControl == .T.)
			oDacte:Say(nLInic, 0003, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
			oDacte:Say(nLInic, 0205, PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 9,999,999.9999'),20), oFont08)
		Else
			oDacte:Say(nLInic, 0281, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
		EndIf

	EndIf

	(cAliasChv)->(DbSkip())

EndDo

(cAliasChv)->(dbCloseArea())

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjustaSX1     ³ Autor ³Felipe Barbiere          ³ Data ³01/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ajusta o X1_GSC                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AjustaSX1()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function AjustaSX1()
Local aArea    := GetArea()
Local cTamLot  := TamSX3("DTP_LOTNFC")[1]
Local cTamDoc  := TamSX3("DT6_DOC")[1]
Local cTamSer  := TamSX3("DT6_SERIE")[1]
Local cTamTip  := TamSX3("DT6_DOCTMS")[1]
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpEsp := {}

aHelpPor := {"Informe o lote inicial."}
aHelpEng := {"Introduzca el lote inicial."}
aHelpEsp := {"Enter the initial batch."}
PutSx1(	"RTMSR25", "01", "Lote De", "De Lote?", "From Lot?", ;
			"MV_CH1", "C",cTamLot, 0, 0, "G", "", "DTP", "", "", ;
			"MV_PAR01", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )

aHelpPor := {"Informe o lote final."}
aHelpEng := {"Introduzca la mezcla final."}
aHelpEsp := {"Enter the final blend."}
PutSx1(	"RTMSR25", "02", "Lote Ate", "A Lote?", "To Lot?", ;
			"MV_CH2", "C", cTamLot, 0, 0, "G", "", "DTP", "", "", ;
			"MV_PAR02", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )


//-- Numero do Documento.
aHelpPor := {"Informe o documento inicial."}
aHelpEng := {"Introduzca el documento de partida."}
aHelpEsp := {"Enter the starting document."}
PutSx1(	"RTMSR25", "03", "Documento De", "De Documento", "From Document", ;
			"MV_CH3", "C", cTamDoc, 0, 0, "G", "", "DT6", "", "", ;
			"MV_PAR03", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )
			
aHelpPor := {"Informe o documento final."}
aHelpEng := {"Introduzca el documento final."}
aHelpEsp := {"Enter the final document."}
PutSx1(	"RTMSR25", "04", "Documento Ate", "A Documento", "To Document", ;
			"MV_CH4", "C", cTamDoc, 0, 0, "G", "", "DT6", "", "", ;
			"MV_PAR04", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )


//-- Serie do Documento.
aHelpPor := {"Informe  serie do documento inicial."}
aHelpEng := {"Informe de la serie del documento original."}
aHelpEsp := {"Report series of the original document."}
PutSx1(	"RTMSR25", "05", "Serie De", "De Serie", "From Series", ;
			"MV_CH5", "C", cTamSer, 0, 0, "G", "", "", "", "", ;
			"MV_PAR05", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )

aHelpPor := {"Informe  serie do documento final."}
aHelpEng := {"La serie de Informes del documento final."}
aHelpEsp := {"Report series of the final document."}
PutSx1(	"RTMSR25", "06", "Serie Ate", "A Serie", "To Series", ;
			"MV_CH6", "C", cTamSer, 0, 0, "G", "", "", "", "", ;
			"MV_PAR06", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )


//-- Tipo do Documento.
aHelpPor := {"Informe  o tipo do documento."}
aHelpEng := {"Introduzca el tipo de documento."}
aHelpEsp := {"Enter the type of document."}
PutSx1(	"RTMSR25", "07", "Tipo do Documento", "Tipo do Documento", "Document Type", ;
			"MV_CH7", "C", cTamTip, 0, 0, "G", "", "DLC", "", "", ;
			"MV_PAR07", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )

// Busca XML
SX1->(DbSetOrder(1))
If SX1->(MsSeek(Padr("RTMSR25",Len(SX1->X1_GRUPO))+"08")) 
	RecLock('SX1',.F.)
	dbDelete()
	MsUnLock()
EndIf

RestArea(aArea)
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna um Array com a estrutura do campo complemento rel. º±±
±±º          ³ ao objeto passado por parametro                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TMSGetComp( oObject )
Local i			:= 0		// Auxiliar no Incremento da Estrutura de Laco
Local aAuxClone	:= { }		// Copia da propriedade Comp do Objeto passado por parametro
Local aAuxComp	:= { }		// Auxiliar no processamento de aAuxClone
Local aResult	:= { }		// Retorno da Funcao
 If Valtype(XmlChildEx(oObject:_CTE:_INFCTE:_VPREST,"_COMP")) <> "U"
	If	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "A"
		aAuxClone := ACLONE( oObject:_CTE:_INFCTE:_VPREST:_COMP )
		For i := 1 To Len( aAuxClone )
			AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
		Next i
	ElseIf	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "O"
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT) )
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT) )
		AADD( aResult, aAuxComp )
		aAuxComp := {}
	EndIf
 EndIf
Return ( aResult )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DataSource( cSource, cFilDoc, cDoc, cSerie )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

Default cFilDoc		:= ''
Default cDoc		:= ''
Default cSerie		:= ''

cQuery := GetSQL( cSource, cFilDoc, cDoc, cSerie )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*
Função para validar recuperação de corte de pedidos no momento da impressao da DACTE
Autor: Eduardo Santana
Data : 09/01/2021
*/

Static Function ValidRecCorte()
	Local lRet			:= .T.
	Local cQuery 		:= ""
	Local cAliasCtes 	:= ""
	Local cCte			:= "" 
	Local cAliasDTC 	:= ""
	Local cMsg			:= ""
	Local cQueryDTC		:= ""
	Local cNotEmp   	:= GetNewPar("ZZ_NOTEMP","02,13,15")
	Local aEmp			:= {}
	Local nPos			:= 0
	Local cTitulo		:= "ATENCAO Pedidos em Recuperacao de Corte"
	Local nAviso		:= 0
	Local nTipo			:= 2
	Local cLocal		:= ""
	Local cTexto		:= ""
	Local cArqHTML		:= ""
	Local cHtml			:= ""
	Local cAssunto		:= ""
	Local cEmail		:= ""
	Local cEmailCC      := GetNewPar("ZZ_EMAILCS","erp@comfriofs.com.br")
    Local cEmailBCC     := GetNewPar("ZZ_MAILCOR","erp@comfriofs.com.br")
	Local cClientHtml 	:= ""
	Local cLojCliHtml 	:= ""
	Local cEmpresaHtml	:= ""
	Local cNomeCliHtml	:= ""
	Local cNumPedHtml 	:= ""
	Local nfor			:= 0
	Local ncont         := 0

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	dbGoTop()
	While SM0->(!Eof())
		If !(Alltrim(SM0->M0_CODIGO) $ cNotEmp)
			nPos := Ascan(aEmp,{|x|Alltrim(x[2]) == Alltrim(SM0->M0_CODIGO)})
			If nPos == 0
				Aadd(aEmp, {"EMPRESA", alltrim(SM0->M0_CODIGO)})
			Endif
		EndIf
		SM0->(DbSkip())	
	Enddo
	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))

	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
	
	cQuery := GetSQL('DT6') //Query Retorna os Ctes conforme dados do parametro
	TcQuery cQuery New Alias(cAliasCtes:=GetNextAlias())
	dbSelectArea(cAliasCtes)
	(cAliasCtes)->(dbGoTop())
	If (cAliasCtes)->(!EOF())
		While (cAliasCtes)->(!EOF())

			cCte := (cAliasCtes)->DT6_DOC
			cSerieCte := (cAliasCtes)->DT6_SERIE
			cCodClient := (cAliasCtes)->DT6_CLIDES
			cLojaClient := (cAliasCtes)->DT6_LOJDES
			cFilDoc := (cAliasCtes)->DT6_FILDOC 
			
			//Função para anaLisar se houve corte no pedido
			AnalisaCorte(aEmp,cFilDoc, cCte, cSerieCte, cCodClient, cLojaClient)

			(cAliasCtes)->(DbSkip())
    	Enddo
	Endif 

	If Len(aRecsCorte) > 0 //Se encontrar pedidos em recuperação de corte apresenta mensagem
		For ncont := 1 to Len(aRecsCorte)
			Aadd(aCtesFood,{aRecsCorte[ncont,10]}) //Array para armazenar CTes que irão seguir
			If Empty(cMsg)
				cMsg += "Os Documentos possuem pedidos em processo de recuperação de corte. Deseja Seguir com a impressão da DACTE ?"+CRLF
				cMsg += "Empresa|Pedido|Cliente|Loja|Cte"+CRLF
				cEmpMsg := SubStr(aRecsCorte[ncont,1],1,2)
				cMsg += cEmpMsg+" "+aRecsCorte[ncont,2]+" "+aRecsCorte[ncont,8]+" "+aRecsCorte[ncont,9]+" "+aRecsCorte[ncont,10]+""+CRLF
			Else
				cMsg += cEmpMsg+" "+aRecsCorte[ncont,2]+" "+aRecsCorte[ncont,8]+" "+aRecsCorte[ncont,9]+" "+aRecsCorte[ncont,10]+""+CRLF
			Endif 
		Next ncont
		
		lRet := MsgYesNo(cMsg, cTitulo) //Mostra janela com mensagem e botão sim ou não 
		
	Endif

	//Envia Workflow de pedidos em recuperação de corte
	If lRet .AND. Len(aRecsCorte) > 0	
		nAviso:= Aviso("COMFRIO","Será gerado DACTE dos Ctes com recuperação de corte e enviado notificação ao cliente. Deseja prosseguir com os mesmos?",{"Sim","Não"})
		If nAviso == 1
			aValidMAil := {}
			For nfor := 1 to Len(aRecsCorte)
				nValid :=  ascan(aValidMAil, { |x| alltrim(x[1])+alltrim(x[2])+alltrim(x[3])+alltrim(x[4]) == Alltrim(aRecsCorte[nfor,1])+Alltrim(aRecsCorte[nfor,2])+Alltrim(aRecsCorte[nfor,8])+Alltrim(aRecsCorte[nfor,9]) })
				If nValid == 0
					cClientHtml  := aRecsCorte[nfor,8]
					cLojCliHtml  := aRecsCorte[nfor,9]
					cEmpresaHtml := aRecsCorte[nfor,1]
					cNomeCliHtml := aRecsCorte[nfor,3]
					cNumPedHtml  := aRecsCorte[nfor,2]
					cHtml 		 := MontaHmlEnv(aRecsCorte,cEmpresaHtml,cClientHtml,cLojCliHtml,cNomeCliHtml,cNumPedHtml)
					cAssunto	 := "Lista de Corte COMFRIO - "+cNumPedHtml  //Assunto alterado Henrique Rubim.
					cEmail  	 := aRecsCorte[nfor,7]     //Recebe e-mail do cliente
					U_CFGEN01(nTipo,cLocal,cTexto,cArqHTML,cHtml,cAssunto,cEmail,cEmailCC,cEmailBCC)  //Envia Workflow
				Endif
			Next nfor
		Else
			lRet := .F.
		Endif 		
	Endif 

	If lRet .AND. Len(aCorteOper) > 0	
		aValidMAil := {}
		For nfor := 1 to Len(aCorteOper)
			nValid :=  ascan(aValidMAil, { |x| alltrim(x[1])+alltrim(x[2])+alltrim(x[3])+alltrim(x[4]) == Alltrim(aCorteOper[nfor,1])+Alltrim(aCorteOper[nfor,2])+Alltrim(aCorteOper[nfor,8])+Alltrim(aCorteOper[nfor,9]) })
			If nValid == 0
				//Envia email de cortes operacionais
				cClientHtml := aCorteOper[nfor,8]
				cLojCliHtml := aCorteOper[nfor,9]
				cEmpresaHtml := aCorteOper[nfor,1]
				cNomeCliHtml := aCorteOper[nfor,3]
				cNumPedHtml := aCorteOper[nfor,2]
				cHtml := MontaHmlEnv(aCorteOper,cEmpresaHtml,cClientHtml,cLojCliHtml,cNomeCliHtml,cNumPedHtml)
				cAssunto := "COMFRIO - Pedido com corte de itens: "+cNumPedHtml
				cEmail := aCorteOper[nfor,7]    //E-mail do cliente A1_EMAIL
				U_CFGEN01(nTipo,cLocal,cTexto,cArqHTML,cHtml,cAssunto,cEmail,cEmailCC,cEmailBCC)  //Envia Workflow
			Endif 
		Next nfor
	Endif

	(cAliasCtes)->(dbCloseArea())  

Return lRet

/*
	Busca se teve corte no pedido
*/
static function AnalisaCorte(aEmp,cFilDoc, cCte, cSerieCte, cCodClient, cLojaClient)
	Local cSQL			:= ""
	Local cSQL2			:= ""
	Local cEmp			:= ""
	Local cCliNcontr	:= ""
	Local lRet 			:= .T.
	Local cPediRecs 	:= ""
	Local aRet 			:= {}
	Local cNomeClient	:= ""
	Local cNumPedido	:= ""
	Local cNumPortal	:= ""
	Local cClient 		:= ""
	Local cLojaCli 		:= ""
	Local cEmpresa		:= ""
	Local cCodProd 		:= ""
	Local cDescProd 	:= ""
	Local cQuant		:= ""
	Local nQuant		:= 0
	Local nPosDoc 		:= 0
	Local aScanWF		:= {}
	Local cEmailCli 	:= ""
	Local cAlias1		:= ""
	Local cFilialPed 	:= ""
	Local c1Um			:= ""
	Local c2Um			:= ""
	Local nRecord 		:= 0
	Local nPedoMed		:= 0
	Local cEmpPSM		:= GetNewPar("ZZ_EMPPSM", "010") //Empresa que contem produto tipo peso variavel
	Local cTipoProd		:= ""
	

	For nRecord := 1 to Len(aEmp)
		cEmp := aEmp[nRecord,2]+"0"

		cSQL += "SELECT * FROM (																																							 " + CRLF
		cSQL += "WITH  " + CRLF
		cSQL += "	RET01 AS (  " + CRLF
		cSQL += "		SELECT  " + CRLF
		cSQL += "			DTC.DTC_FILIAL, DTC.DTC_FILORI, DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_CLIDES, DTC.DTC_LOJDES, SA1.A1_CGC AS CGCDES, SC501.C5_FILIAL AS C5_FILIAL, SC501.C5_NUM, SC501.C5_NOTA" + CRLF
		cSQL += "		FROM  "+retSqlName("DT6")+"  DT6 " + CRLF
		cSQL += "		INNER JOIN  "+retSqlName("SA1")+"  SA1 ON 1=1 " + CRLF
		cSQL += "			AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' " + CRLF
		cSQL += "			AND SA1.A1_COD = DT6.DT6_CLIDES " + CRLF
		cSQL += "			AND SA1.A1_LOJA = DT6.DT6_LOJDES " + CRLF
		cSQL += "			AND SA1.A1_ZZFOOD = '1'  " + CRLF
		cSQL += "			AND SA1.D_E_L_E_T_ = ' '  " + CRLF
		cSQL += "		INNER JOIN  "+retSqlName("DTC")+"  DTC ON 1=1 " + CRLF
		cSQL += "			AND DTC.DTC_FILIAL = DT6.DT6_FILIAL " + CRLF
		cSQL += "			AND DTC.DTC_FILORI = DT6.DT6_FILDOC " + CRLF
		cSQL += "			AND DTC.DTC_DOC = DT6.DT6_DOC " + CRLF
		cSQL += "			AND DTC.DTC_SERIE = DT6.DT6_SERIE " + CRLF
		cSQL += "			AND DTC.DTC_CLIDES = DT6.DT6_CLIDES " + CRLF
		cSQL += "			AND DTC.DTC_LOJDES = DT6.DT6_LOJDES " + CRLF
		cSQL += "			AND DTC.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += " 		INNER JOIN "+retSqlName("SC5")+" SC501 ON SC501.C5_NOTA = DTC.DTC_NUMNFC "+ CRLF
		cSQL += "		WHERE 1=1 " + CRLF
		cSQL += "			AND DT6.DT6_FILIAL = '"+xFilial("DT6")+"' " + CRLF
		cSQL += "			AND DT6.DT6_FILDOC = '"+cFilDoc+"' " + CRLF
		cSQL += "			AND DT6.DT6_CLIDES = '"+cCodClient+"' " + CRLF
		cSQL += "			AND DT6.DT6_LOJDES = '"+cLojaClient+"' " + CRLF
		cSQL += "			AND DT6.DT6_DOC = '"+cCte+"' " + CRLF
		cSQL += "			AND DT6.DT6_SERIE = '"+cSerieCte+"' " + CRLF
		cSQL += "			AND DT6.DT6_FIMP <> '1'" + CRLF
		cSQL += "			AND DT6.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "	), RET02 AS ( " + CRLF
		cSQL += "		--SELECIONA TODOS OS PEDIDOS RELACIONADO AO CTE/CLIENTE EM QUESTAO " + CRLF
		cSQL += "	 	SELECT SC5.C5_NUM AS C5_NUM, SC5.C5_ZZPEDOR AS C5_ZZPEDOR, SC5.C5_FILIAL AS C5_FILIAL " + CRLF
		cSQL += "		FROM (RET01) RET01 " + CRLF
		cSQL += "		INNER JOIN SC5"+cEmp+" SC5 ON 1=1 " + CRLF
		//Revisar //cSQL += "			AND SC5.C5_FILIAL = RET01.DTC_FILORI " + CRLF
		cSQL += "			AND SC5.C5_NOTA = RET01.DTC_NUMNFC " + CRLF
		cSQL += "			AND SC5.C5_SERIE = RET01.DTC_SERNFC " + CRLF
		cSQL += "			AND SC5.D_E_L_E_T_ = ' ' " + CRLF
        cSQL += "       INNER JOIN SA1"+cEmp+" SA1 ON SA1.A1_COD = SC5.C5_CLIENTE " + CRLF
        cSQL += "           AND SA1.A1_LOJA = SC5.C5_LOJACLI " + CRLF
        cSQL += "           AND SA1.D_E_L_E_T_ = ' ' " + CRLF
        cSQL += "           AND A1_ZZCOD = RET01.DTC_CLIDES " + CRLF
        cSQL += "           AND A1_ZZLOJ = RET01.DTC_LOJDES " + CRLF
		cSQL += "	), RET03 AS ( " + CRLF
		cSQL += "		--UNIPIVOT --> LISTA AS DUAS COLUNAS EM UMA " + CRLF
		cSQL += "		SELECT DISTINCT PEDIDO AS C5_NUM, C5_FILIAL " + CRLF
		cSQL += "		FROM RET02 " + CRLF
		cSQL += "		UNPIVOT( " + CRLF
		cSQL += "			PEDIDO FOR PEDIDOS IN ( " + CRLF
		cSQL += "				C5_NUM, C5_ZZPEDOR " + CRLF
		cSQL += "			) " + CRLF
		cSQL += "		) " + CRLF
		cSQL += "		WHERE PEDIDO <> ' ' " + CRLF
		cSQL += "	), RET04 AS ( " + CRLF
		cSQL += "		--SELECIONA O PEDIDO QUE FOI ORIGINADO PELO PORTAL -- TIPO NORMAL (GRADE) " + CRLF
		cSQL += "		SELECT SC5.C5_FILIAL, MIN(SC5.C5_NUM) AS C5_NUM, SC5.C5_CLIENT, SC5.C5_LOJACLI, SC5.C5_ZZNUMPT, SC5.C5_ZZPEDOR, SC5.C5_ZZLIB " + CRLF
		cSQL += "		FROM RET03 " + CRLF
		cSQL += "		INNER JOIN SC5"+cEmp+" SC5 ON SC5.C5_FILIAL = RET03.C5_FILIAL " + CRLF
		cSQL += "			AND SC5.C5_NUM = RET03.C5_NUM " + CRLF
		cSQL += "			AND SC5.C5_ZZNUMPT <> ' ' " + CRLF
		cSQL += "			AND SC5.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "		INNER JOIN ZZ1"+cEmp+" ZZ1 ON 1=1 " + CRLF
		cSQL += "			AND ZZ1.ZZ1_FILIAL = SC5.C5_FILIAL " + CRLF
		cSQL += "			AND ZZ1.ZZ1_NUM = SC5.C5_ZZNUMPT " + CRLF
		cSQL += "			AND ZZ1.ZZ1_CLIENT = SC5.C5_CLIENT " + CRLF
		cSQL += "			AND ZZ1.ZZ1_LOJA = SC5.C5_LOJACLI " + CRLF
		cSQL += "			AND ZZ1.ZZ1_TIPO in ('N','U') " + CRLF
		cSQL += "			AND ZZ1.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "		GROUP BY SC5.C5_FILIAL, SC5.C5_CLIENT, SC5.C5_LOJACLI, SC5.C5_ZZNUMPT, SC5.C5_ZZPEDOR, SC5.C5_ZZLIB " + CRLF
		cSQL += "	), RET05 AS ( " + CRLF
		cSQL += "		--SELECIONA TODOS OS PEDIDOS QUE FORAM CRIADOS PARA RECUPERACAO, PARTINDO DO PEDIDO ORIGINADO PELO PORTAL " + CRLF
		cSQL += "		SELECT RET04.C5_FILIAL, RET04.C5_NUM AS C5_REC, RET04.C5_CLIENT, RET04.C5_LOJACLI, RET04.C5_ZZNUMPT, RET04.C5_ZZPEDOR AS C5_ORI, RET04.C5_ZZLIB " + CRLF
		cSQL += "		FROM RET04 " + CRLF
		cSQL += "		LEFT JOIN SC5"+cEmp+" SC5 ON 1=1 " + CRLF
		cSQL += "			AND SC5.C5_FILIAL = RET04.C5_FILIAL " + CRLF
		cSQL += "			AND SC5.C5_CLIENT = RET04.C5_CLIENT " + CRLF
		cSQL += "			AND SC5.C5_LOJACLI = RET04.C5_LOJACLI " + CRLF
		cSQL += "			AND SC5.C5_ZZPEDOR = RET04.C5_NUM " + CRLF
		cSQL += "			AND SC5.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "	), RET06 AS ( " + CRLF
		cSQL += "		--ANALISA EM TODOS OS PEDIDOS (ORIGINAL E RECUPERADO) SE HOUVERAM CORTES DURANTE O PROCESSO DE SEPARACAO " + CRLF
		cSQL += "		--CORTES DO PEDIDO ORIGINAL " + CRLF
		cSQL += "		SELECT DISTINCT RET05.C5_FILIAL, RET05.C5_REC, RET05.C5_CLIENT, RET05.C5_LOJACLI, RET05.C5_ZZNUMPT, RET05.C5_ORI, RET05.C5_ZZLIB, " + CRLF
		cSQL += "			ZZ3.ZZ3_PRODUT, ZZ3.ZZ3_QTDPV, ZZ3.ZZ3_QTATEN, ZZ3.ZZ3_QTCORT, ZZ3.ZZ3_TPCOR,ZZ3.ZZ3_DESCRI " + CRLF
		cSQL += "		FROM RET05 " + CRLF
		cSQL += "		INNER JOIN ZZ3"+cEmp+" ZZ3 ON 1=1  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_FILIAL = RET05.C5_FILIAL  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_CLIENT = RET05.C5_CLIENT  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_LOJA = RET05.C5_LOJACLI  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_PEDIDO = RET05.C5_ORI --ORIGINAL " + CRLF
		cSQL += "			AND ZZ3.ZZ3_STATUS <> 'R'" + CRLF
		cSQL += "			AND ZZ3.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "		UNION ALL " + CRLF
		cSQL += "		--CORTES DOS PEDIDOS PARA RECUPERACAO " + CRLF
		cSQL += "		SELECT DISTINCT RET05.C5_FILIAL, RET05.C5_REC, RET05.C5_CLIENT, RET05.C5_LOJACLI, RET05.C5_ZZNUMPT, RET05.C5_ORI, RET05.C5_ZZLIB, " + CRLF
		cSQL += "			ZZ3.ZZ3_PRODUT, ZZ3.ZZ3_QTDPV, ZZ3.ZZ3_QTATEN, ZZ3.ZZ3_QTCORT, ZZ3.ZZ3_TPCOR,ZZ3.ZZ3_DESCRI " + CRLF
		cSQL += "		FROM RET05 " + CRLF
		cSQL += "		INNER JOIN ZZ3"+cEmp+" ZZ3 ON 1=1  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_FILIAL = RET05.C5_FILIAL  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_CLIENT = RET05.C5_CLIENT  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_LOJA = RET05.C5_LOJACLI  " + CRLF
		cSQL += "			AND ZZ3.ZZ3_PEDIDO = RET05.C5_REC --RECUPERADO " + CRLF
		cSQL += "			AND ZZ3.ZZ3_STATUS <> 'R'" + CRLF
		cSQL += "			AND ZZ3.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "	), RET07 AS ( " + CRLF
		cSQL += "		--ANALISA OS ITENS CORTADOS X ITENS RECUPERADOS (PEDIDO REC) " + CRLF
		cSQL += "		SELECT DISTINCT'"+ cEmp +"' AS EMP, RET06.C5_FILIAL, RET06.C5_CLIENT, RET06.C5_LOJACLI, RET06.C5_ZZLIB, RET06.ZZ3_TPCOR, RET06.C5_ORI, RET06.C5_REC, RET06.ZZ3_PRODUT,RET06.ZZ3_DESCRI, SC6.C6_UM, SC6.C6_SEGUM, " + CRLF
		cSQL += "			CASE WHEN RET06.ZZ3_PRODUT = SC6.C6_PRODUTO " + CRLF
		cSQL += "				THEN RET06.ZZ3_QTCORT - SC6.C6_QTDVEN " + CRLF
		cSQL += "				ELSE RET06.ZZ3_QTCORT " + CRLF
		cSQL += "			END ZZ3_QTCORT " + CRLF
		cSQL += "		FROM RET06 " + CRLF
		cSQL += "		INNER JOIN SC6"+cEmp+" SC6 ON 1=1 " + CRLF
		cSQL += "			AND SC6.C6_FILIAL = RET06.C5_FILIAL " + CRLF
		cSQL += "			AND SC6.C6_CLI = RET06.C5_CLIENT " + CRLF
		cSQL += "			AND SC6.C6_LOJA = RET06.C5_LOJACLI " + CRLF
		cSQL += "			AND SC6.C6_NUM = RET06.C5_REC " + CRLF
		cSQL += "			AND ((SC6.C6_PRODUTO = RET06.ZZ3_PRODUT AND SC6.C6_QTDVEN < RET06.ZZ3_QTCORT) OR (SC6.C6_PRODUTO <> RET06.ZZ3_PRODUT)) " + CRLF
		cSQL += "			AND SC6.D_E_L_E_T_ = ' ' " + CRLF
		cSQL += "	) " + CRLF
		cSQL += "	SELECT * FROM RET07 " + CRLF
		cSQL += ") " + CRLF

		If nRecord < Len(aEmp)
			cSQL += " UNION ALL " + CRLF
		Endif

	Next nRecord

	MemoWrite("\sql\AnalisaCorte.sql",cSQL)	

	TCQUERY cSQL NEW Alias (cAlias:=GetNextAlias())
	dbselectarea(cAlias)
	(cAlias)->(dbGoTop())
	If (cAlias)->(!Eof())
		While (cAlias)->(!EOF()) //Percorre os produtos que teve corte 

			///cNumPedido	:= (cAlias)->C5_ORI
			cNumPedido	:= IF(!EMPTY((cAlias)->C5_ORI),(cAlias)->C5_ORI,(cAlias)->C5_REC)
			cClient 	:= (cAlias)->C5_CLIENT
			cLojaCli 	:= (cAlias)->C5_LOJACLI
			cEmpresa	:= Alltrim((cAlias)->EMP)
			cNomeClient	:= Alltrim(RetNomeEmail(cEmpresa, cClient,cLojaCli,"N"))
			cCodProd 	:= Alltrim((cAlias)->ZZ3_PRODUT)
			cDescProd 	:= Alltrim((cAlias)->ZZ3_DESCRI)
			cQuant		:= AllTrim(Str((cAlias)->ZZ3_QTCORT))
			nQuant		:= GetDtoVal(cQuant)
			cEmailCli 	:= Alltrim(RetNomeEmail(cEmpresa, cClient,cLojaCli,"M"))
			c1Um		:= Alltrim((cAlias)->C6_UM)
			c2Um		:= Alltrim((cAlias)->C6_SEGUM)

			
			IF cEmpresa == cEmpPSM

				cSQL2 += "	SELECT SB1.B1_ZZTPESO, SB1.B1_ZZPSOMD "				   + CRLF
				cSQL2 += "	FROM SB1"+cEmpresa+" SB1"			  				   + CRLF
				cSQL2 += "	INNER JOIN ZZ3"+cEmpresa+" ZZ3 ON ZZ3.D_E_L_E_T_ = ' '"+ CRLF
				cSQL2 += "	AND ZZ3_PRODUT = SB1.B1_COD" 						   + CRLF
				cSQL2 += "	WHERE ZZ3_PEDIDO = '"+cNumPedido+"'" 				   + CRLF
				cSQL2 += "	AND ZZ3_PRODUT = '"+cCodProd+"'"					   + CRLF

				TcQuery cSQL2 New Alias (cAlias1:=GetNextAlias())
				
				if (cAlias1)->(!eof())
					cTipoProd := (cAlias1)->B1_ZZTPESO
					nPedoMed  := (cAlias1)->B1_ZZPSOMD
					lRet 	  := .T.
				endif
				
				(cAlias1)->(dbCloseArea())
				cSQL2 := ""

			Else
				cTipoProd := ""	
			Endif

			iF cEmpresa == cEmpPSM .and. cTipoProd == PESO_VARIAVEL .AND. nQuant > nPedoMed
			
				nPosDoc := aScan(aScanWF,{|x| x[1] == cCodProd})
				
				If nPosDoc == 0

					aadd(aScanWF,{cCodProd})

					If Alltrim((cAlias)->C5_ZZLIB) == "2" //Se não foi faturado a recuperação do corte
						AADD(aRecsCorte,{cEmpresa,cNumPedido,Alltrim(cNomeClient),cCodProd,cDescProd,cQuant,Alltrim(cEmailCli),cClient,cLojaCli,cCte,c1Um}) //Em recuperação de corte
					Elseif Alltrim((cAlias)->C5_ZZLIB) == "1" //Se cortou
						AADD(aCorteOper,{cEmpresa,cNumPedido,Alltrim(cNomeClient),cCodProd,cDescProd,cQuant,Alltrim(cEmailCli),cClient,cLojaCli,c1Um}) //Cortou não teve recuperação
					Endif 

				Endif

			elseif !cTipoProd == PESO_VARIAVEL

				nPosDoc := aScan(aScanWF,{|x| x[1] == cCodProd})
				
				If nPosDoc == 0

					aadd(aScanWF,{cCodProd})

					If Alltrim((cAlias)->C5_ZZLIB) == "2" //Se não foi faturado a recuperação do corte
						AADD(aRecsCorte,{cEmpresa,cNumPedido,Alltrim(cNomeClient),cCodProd,cDescProd,cQuant,Alltrim(cEmailCli),cClient,cLojaCli,cCte,c1Um}) //Em recuperação de corte
					Elseif Alltrim((cAlias)->C5_ZZLIB) == "1" //Se cortou
						AADD(aCorteOper,{cEmpresa,cNumPedido,Alltrim(cNomeClient),cCodProd,cDescProd,cQuant,Alltrim(cEmailCli),cClient,cLojaCli,c1Um}) //Cortou não teve recuperação
					Endif 

				ENDIF

			Endif
			(cAlias)->(DbSkip())
    	Enddo
	Endif

	(cAlias)->(dbCloseArea())  

Return .T.

/*
	Busca se teve corte no pedido
*/
static function RetNomeEmail(cEmp, cCodCli,cLojaCli,cTipoRet)
	Local cSQL		:= ""
	Local cAliasCli	:= ""
	Local cRet 		:= ""

	//Retorna recuperação de corte usando produto original
	cSQL := "			SELECT " + CRLF
	cSQL += "				* " + CRLF
	cSQL += "			FROM SA1"+ cEmp +" " + CRLF
	cSQL += "			WHERE " + CRLF
	cSQL += "				A1_COD = '"+cCodCli+"' " + CRLF
	cSQL += "				AND A1_LOJA = '"+cLojaCli+"' " + CRLF
	cSQL += "				AND D_E_L_E_T_ = ' ' " + CRLF

	TCQUERY cSQL NEW Alias (cAliasCli:=GetNextAlias())
	dbselectarea(cAliasCli)
	(cAliasCli)->(dbGoTop())
	If (cAliasCli)->(!Eof())
		If cTipoRet == "M"
			cRet := (cAliasCli)->A1_ZZMCORT
		Else 
			cRet := (cAliasCli)->A1_NREDUZ
		Endif 
	Endif

	(cAliasCli)->(dbCloseArea())  

Return cRet 

/*
	Função para montar layout html do e-mail a ser enviado
*/
Static Function MontaHmlEnv(aDados,cEmpHtml,cCodCliHtml,cLojaCliHtml,cNomCliHtml,cNumPedHtml)
	Local cSql			:= ""
	Local cHtml 		:= ""
	Local cLogo 		:= GetNewPar("ZZ_LOGOCFR","D:\TOTVS\PROTHEUS\LG_QA2\protheus_data\logohtml\comfrio.png") 
	Local cUrl 			:= "url('http://localhost/pontilhado.gif'); background-color: #6699CC"
	Local cNumPedPortal := ""
	Local cAliasPed		:= ""

	cSQL += " SELECT C5_ZZNUMPT FROM SC5"+cEmpHtml+" WHERE 1=1 " + CRLF
	cSQL += " AND C5_FILIAL  = '" + xFilial("SC5") + "'" + CRLF
	cSQL += " AND C5_CLIENTE = '"+cCodCliHtml+"' " + CRLF
	cSQL += " AND C5_LOJACLI = '"+cLojaCliHtml+"' " + CRLF
	cSQL += " AND C5_NUM = '"+cNumPedHtml+"' " + CRLF
	cSQL += " AND D_E_L_E_T_ = ' ' " + CRLF
	

	TCQUERY cSQL NEW Alias (cAliasPed:=GetNextAlias())
	dbselectarea(cAliasPed)
	(cAliasPed)->(dbGoTop())
	If (cAliasPed)->(!Eof())
		cNumPedPortal := Alltrim((cAliasPed)->C5_ZZNUMPT)
	Endif

	Aadd(aValidMAil,{cEmpHtml,cNumPedHtml,cCodCliHtml,cLojaCliHtml})

	cHtml := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ CRLF
	cHtml += '<html>'+ CRLF
	cHtml += '	<head>		
	cHtml += '		<!-- saved from url=(0022)http://internet.e-mail -->
	cHtml += '		<title>WorkFlow Cortes</title>
	cHtml += '		<style>
	cHtml += '			TD {
	cHtml += '			FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt
	cHtml += '			}
	cHtml += '			.TarjaTopoCor {
	cHtml += '			text-decoration: none; height: 6px; background-image:'+cUrl+' '+CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.titulo {'+ CRLF
	cHtml += '			font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.TitleBig {'+ CRLF
	cHtml += '			COLOR: #074b85; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 24px; FONT-WEIGHT: normal; LINE-HEIGHT: 26px; TEXT-ALIGN: left'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.style1 {'+ CRLF
	cHtml += '			color: #19167D'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.style2 {'+ CRLF
	cHtml += '			BACKGROUND-COLOR: #E4E4E4; COLOR: #19167D; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 14px; VERTICAL-ALIGN: top;'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.style3 {'+ CRLF
	cHtml += '			BACKGROUND-COLOR: #E4E4E4; COLOR: #19167D; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top;'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.style5 {'+ CRLF
	cHtml += '			color: #19167D; font-weight: bold;'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.SmallBold {'+ CRLF
	cHtml += '			FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; FONT-WEIGHT: bold'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.Small {'+ CRLF
	cHtml += '			FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.TableRowBlueDarkMini {'+ CRLF
	cHtml += '			BACKGROUND-COLOR: #E4E4E4; COLOR: #FFCC00; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.TableRowWhiteMini2 {'+ CRLF
	cHtml += '			COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.Mini {'+ CRLF
	cHtml += '			FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			DIV {'+ CRLF
	cHtml += '			FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '			.texto-layer {'+ CRLF
	cHtml += '			font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none'+ CRLF
	cHtml += '			}'+ CRLF
	cHtml += '		</style>'+ CRLF
	cHtml += '	</head>'+ CRLF
	cHtml += '	<body style="background-color: rgb(255, 255, 255);">'+ CRLF
	cHtml += '<p><strong><font color="#808080" face="calibri size="2">Prezados,</font></strong></p>' + CRLF
	cHtml += '<p><font color="#808080" face="calibri size="1">Informo que a relação de itens abaixo está indisponível no momento. Favor inserir novamente os itens em seu próximo  pedido:</font></p>' + CRLF
	cHtml += '<table width="998" border="0">' + CRLF
	cHtml += '<tr><td>' + CRLF
	cHtml += '<div align="center"><font color="#4f4f4f">' + CRLF
	cHtml += '</font>' + CRLF
	cHtml += '</div></td></tr>' + CRLF
	cHtml += '</table>' + CRLF
	cHtml += '</p>' + CRLF
	cHtml += '</p>' + CRLF
	cHtml += '		<table style="border-collapse: collapse;" id="table1" align="center" border="0" bordercolor="#111111" cellpadding="0" cellspacing="0" height="32" width="100%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '				<tr>'+ CRLF
	cHtml += '					<td height="32" width="14%"><img src="'+cLogo+'" border="0"></td>'+ CRLF
	cHtml += '					<td height="32" width="20%">'+ CRLF
	cHtml += '						<table style="border-collapse: collapse;" id="table2" bgcolor="#f7f7f7" border="0" bordercolor="#000000" cellpadding="0" cellspacing="0" width="100%">'+ CRLF
	cHtml += '							<tbody>'+ CRLF
	cHtml += '								<tr>'+ CRLF
	cHtml += '									<td style="border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="51%"> <b><font color="#19167d" face="Arial" size="2">Nome Cliente</font></b></td>'+ CRLF
	cHtml += '									<td style="padding: 0pt; border-left-width: 1px; border-right-width: 1px; border-top-width: 1px;" width="3%">&nbsp;</td>'+ CRLF
	cHtml += '									<td style="border-width: 1px; border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="66%"> <font face="Arial" size="2"><b>'+cNomCliHtml+'</b></font></td>'+ CRLF
	cHtml += '								</tr>'+ CRLF
	cHtml += '								<tr>'+ CRLF
	cHtml += '									<td style="border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="51%"> <b><font color="#19167d" face="Arial" size="2">N&ordm; Pedido</font></b></td>'+ CRLF
	cHtml += '									<td style="padding: 0pt; border-left-width: 1px; border-right-width: 1px; border-top-width: 1px;" width="3%">&nbsp;</td>'+ CRLF
	cHtml += '									<td style="border-width: 1px; border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="66%"> <font face="Arial" size="2"><b>'+cNumPedHtml+'</b></font></td>'+ CRLF
	cHtml += '								</tr>'+ CRLF
	cHtml += '								<tr>'+ CRLF
	cHtml += '									<td style="border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="51%"> <b><font color="#19167d" face="Arial" size="2">N&ordm; Pedido Portal</font></b></td>'+ CRLF
	cHtml += '									<td style="padding: 0pt; border-left-width: 1px; border-right-width: 1px; border-top-width: 1px;" width="3%">&nbsp;</td>'+ CRLF
	cHtml += '									<td style="border-width: 1px; border-bottom: 1px solid rgb(192, 192, 192); padding: 0pt;" width="66%"> <font face="Arial" size="2"><b>'+cNumPedPortal+'</b></font></td>'+ CRLF
	cHtml += '								</tr>'+ CRLF
	cHtml += '							</tbody>'+ CRLF
	cHtml += '						</table>'+ CRLF
	cHtml += '					</td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<br>'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" border="0" cellpadding="0" cellspacing="0" width="100%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '				<tr background="http://localhost/pontilhado.gif">'+ CRLF
	cHtml += '					<td class="TarjaTopoCor" height="5"> <img src="http://localhost/transparente.gif" height="1" width="1"></td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" border="0" cellpadding="0" cellspacing="0" hspace="0" vspace="0" width="100%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		&nbsp;'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" id="table6" align="center" border="0" cellpadding="0" cellspacing="3" width="96%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '				<tr>'+ CRLF
	cHtml += '					<td width="99%"><span class="titulo"><font size="3">&raquo; Cortes do Pedido</font></span></td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" align="center" bgcolor="#f7f7f7" border="1" bordercolor="#e5e5e5" cellpadding="6" cellspacing="0" width="96%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '			<tr>'+ CRLF
	cHtml += '			<td bordercolor="#FFFFFF" class="titulo" width="100%">'+ CRLF
	cHtml += '			<div style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" align="center">'+ CRLF
	cHtml += '				<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" width="100%"></table>'+ CRLF
	cHtml += '			</div>'+ CRLF
	cHtml += '			<form method="post" action="mailto:%WFMailTo%" name="FrontPage_Form1" style="margin: 0px;">'+ CRLF
	cHtml += '				<input name="T30" size="4" maxlength="5" value="%t.9%" style="font-family: Courier; font-size: 12px;" type="hidden">'+ CRLF
	cHtml += '				<input name="T11" size="12" maxlength="12" value="%t.14%" style="font-family: Courier; font-size: 12px;" type="hidden">'+ CRLF
	cHtml += '				<input name="nItem" size="12" maxlength="12" value="%nItem%" style="font-family: Courier; font-size: 12px;" type="hidden">'+ CRLF
	cHtml += '				<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" id="table3" border="0" cellpadding="2" cellspacing="1" width="100%">'+ CRLF
	cHtml += '				</table>'+ CRLF
	cHtml += '				<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" border="0" cellpadding="0" cellspacing="0" width="100%">'+ CRLF
	cHtml += '					<tbody>'+ CRLF
	cHtml += '						<tr>'+ CRLF
	cHtml += '							<td bgcolor="#074b85"><img src="http://localhost/pic_invis.gif" height="1" width="1"></td>'+ CRLF
	cHtml += '						</tr>'+ CRLF
	cHtml += '					</tbody>'+ CRLF
	cHtml += '				</table>'+ CRLF
	cHtml += '				<br>'+ CRLF
	cHtml += '				<table id="table4" border="0" cellspacing="2" height="40" width="100%">'+ CRLF
	cHtml += '					<tbody>'+ CRLF
	cHtml += '						<tr class="TituloMenor" bgcolor="#e4e4e4">'+ CRLF
	cHtml += '							<td align="center" height="3" width="5%"> <font color="#000080" face="Arial"><b>C&oacute;digo</b></font></td>'+ CRLF
	cHtml += '							<td align="center" height="3" width="18%"> <font color="#000080" face="Arial"><b>Descri&ccedil;&atilde;o</b></font></td>'+ CRLF
	cHtml += '							<td align="center" height="3" width="8%"> <font color="#000080" face="Arial"><b>Quant</b></font></td>'+ CRLF
	cHtml += '						</tr>'+ CRLF
	cHtml += '					</tbody>'+ CRLF
	cHtml += '					<tbody>'+ CRLF

	For nhtml := 1 to Len(aDados)
		If aDados[nhtml,1]+aDados[nhtml,2]+aDados[nhtml,8]+aDados[nhtml,9] == cEmpHtml+cNumPedHtml+cCodCliHtml+cLojaCliHtml
			cHtml += '						<tr class="texto-layer" bgcolor="#ffffff">'+ CRLF
			cHtml += '							<td height="5" width="5%">'+ CRLF
			cHtml += '								<div align="center"><span style="font-size: 7pt;">'+Alltrim(aDados[nhtml,4])+'</span></div>'+ CRLF //CODIGO PRODUTO
			cHtml += '							</td>'+ CRLF
			cHtml += '							<td height="5" width="18%">'+ CRLF
			cHtml += '								<div align="center"><span style="font-size: 7pt;">'+Alltrim(aDados[nhtml,5])+'</span></div>'+ CRLF //DESCRICAO
			cHtml += '							</td>'+ CRLF
			cHtml += '							<td height="5" width="8%">'+ CRLF
			cHtml += '								<div align="center"><span style="font-size: 7pt;">'+aDados[nhtml,6]+'</span></div>'+ CRLF //QUANTIDADE
			cHtml += '							</td>'+ CRLF
			cHtml += '						</tr>'+ CRLF
		Endif 
	Next nhtml


	cHtml += '					</tbody>'+ CRLF
	cHtml += '				</table>'+ CRLF
	cHtml += '			</form>'+ CRLF
	cHtml += '			</td>'+ CRLF
	cHtml += '			</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<br>'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" border="0" width="100%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '				<tr></tr>'+ CRLF
	cHtml += '				<tr>'+ CRLF
	cHtml += '					<td class="TituloMenor">'+ CRLF
	cHtml += '						<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" align="center" bgcolor="#f7f7f7" border="1" bordercolor="#e5e5e5" cellpadding="0" cellspacing="0" width="96%">'+ CRLF
	cHtml += '							<tbody>'+ CRLF
	cHtml += '							</tbody>'+ CRLF
	cHtml += '						</table>'+ CRLF
	cHtml += '					</td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" border="0" width="100%">'+ CRLF
	cHtml += '			<tbody>'+ CRLF
	cHtml += '				<tr>'+ CRLF
	cHtml += '					<td class="Mini"></td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '				<tr>'+ CRLF
	cHtml += '					<td class="Mini">'+ CRLF
	cHtml += '						<table style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 10pt;" align="center" bgcolor="#f7f7f7" border="1" bordercolor="#e5e5e5" cellpadding="0" cellspacing="0" width="96%">'+ CRLF
	cHtml += '							<tbody>'+ CRLF
	cHtml += '								<tr>'+ CRLF
	cHtml += '									<td bordercolor="#FFFFFF" width="100%">'+ CRLF
	cHtml += '										<div class="texto-layer" align="right">WorkFlow &#64 COMFRIO S.A</div>'+ CRLF
	cHtml += '									</td>'+ CRLF
	cHtml += '								</tr>'+ CRLF
	cHtml += '							</tbody>'+ CRLF
	cHtml += '						</table>'+ CRLF
	cHtml += '					</td>'+ CRLF
	cHtml += '				</tr>'+ CRLF
	cHtml += '			</tbody>'+ CRLF
	cHtml += '		</table>'+ CRLF
	cHtml += '		<!--<pre><font color="#b67878ff" face="Verdana" size="2"><b>%WFAvisoJS%</b></font></pre>-->'+ CRLF
	cHtml += '	</body>'+ CRLF
	cHtml += '</html>'+ CRLF

	
Return cHTML



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Cria DACTE sem utilizar o XML, utilizando tabela.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSQL( cSource, cFilDoc, cDoc, cSerie )
Local cQuery	:= ""
Local cSitTriba	:= ""

Default cFilDoc		:= ''
Default cDoc		:= ''
Default cSerie		:= ''

If	cSource == 'DT6'
	cQuery += " SELECT " + CRLF
	cQuery += " CTRC.DT6_FILDOC, " +CRLF
	cQuery += " CTRC.DT6_SERIE, " +CRLF
	cQuery += " CTRC.DT6_DOC, " +CRLF
	cQuery += " CTRC.DT6_DOCTMS, " +CRLF
	cQuery += " CTRC.DT6_CHVCTE, " +CRLF
	cQuery += " CTRC.DT6_PROCTE, " +CRLF
	cQuery += " CTRC.DT6_VALFAT, " +CRLF
	cQuery += " CTRC.DT6_FILDCO, " +CRLF
	cQuery += " CTRC.DT6_DOCDCO, " +CRLF
	cQuery += " CTRC.DT6_SERDCO, " +CRLF
	cQuery += " CTRC.DT6_AMBIEN, " +CRLF
	cQuery += " CTRC.DT6_DEVFRE, " +CRLF
	cQuery += " CTRC.DT6_CHVCTG, " +CRLF
	cQuery += " CTRC.DT6_CLIDEV, " +CRLF
	cQuery += " CTRC.DT6_LOJDEV, " +CRLF
	
	cQuery += " CLIDES.A1_SUFRAMA DES_SUFRAMA, " +CRLF
	
	cQuery += " CLIDPC.A1_CGC DPC_CNPJ, " +CRLF
	cQuery += " CTRC.DT6_CLIDES,                " +CRLF //Comfrio adicionado para consulta customizada . Evailton 18.12.2025
	cQuery += " CTRC.DT6_LOJDES                " +CRLF //Comfrio adicionado para consulta customizada . Evailton 18.12.2025

	
	cQuery += " FROM " + RetSqlName('DT6') + " CTRC " + CRLF
	
	cQuery += " INNER JOIN " + RetSqlName('SA1') + " CLIDES ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES AND CLIDES.D_E_L_E_T_ = ' ' ) " + CRLF
	
	cQuery += " LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF
	
	cQuery += " WHERE CTRC.DT6_FILIAL  = '" + xFilial('DT6') + "'" + CRLF

	If Empty(cFilDoc) .And. Empty(cDoc) .And. Empty(cSerie)
		cQuery += " AND CTRC.DT6_FILORI = '" + cFilAnt  + "'" + CRLF	
		cQuery += " AND CTRC.DT6_LOTNFC >= '" + MV_PAR01 + "'" + CRLF
		cQuery += " AND CTRC.DT6_LOTNFC <= '" + MV_PAR02 + "'" + CRLF
	EndIf

	cQuery += " AND (CTRC.DT6_IDRCTE = '100' OR CTRC.DT6_IDRCTE = '136' OR (CTRC.DT6_CHVCTG <> ' '))" + CRLF

	If Empty(cFilDoc) .And. Empty(cDoc) .And. Empty(cSerie)
		cQuery += " AND CTRC.DT6_FILDOC = '" + cFilAnt + "'" + CRLF
		cQuery += " AND CTRC.DT6_DOC >= '" + MV_PAR03 + "'" + CRLF
		cQuery += " AND CTRC.DT6_DOC <= '" + MV_PAR04 + "'" + CRLF
		cQuery += " AND CTRC.DT6_SERIE >= '" + MV_PAR05 + "'" + CRLF
		cQuery += " AND CTRC.DT6_SERIE <= '" + MV_PAR06 + "'" + CRLF
		If !Empty(MV_PAR07)
			cQuery += " AND CTRC.DT6_DOCTMS = '" + MV_PAR07 + "'" + CRLF
		EndIf
	Else
		cQuery += " AND CTRC.DT6_FILDOC = '"  + cFilDoc + "'" + CRLF
		cQuery += " AND CTRC.DT6_DOC = '"  + cDoc    + "'" + CRLF
		cQuery += " AND CTRC.DT6_SERIE = '"  + cSerie  + "'" + CRLF
	EndIf
	cQuery += " AND CTRC.DT6_DOCTMS <> 'S'" + CRLF
	cQuery += " AND CTRC.D_E_L_E_T_ = ' ' " + CRLF

	cQuery += " AND CLIDES.A1_FILIAL = '"  + xFilial('SA1') + "'" + CRLF
	cQuery += " AND CLIDES.D_E_L_E_T_ = ' '" + CRLF
	cQuery += " ORDER BY 1, 2, 3 "

ElseIf cSource == 'DTC'

	cQuery += " SELECT Count(Distinct NF.DTC_NUMNFC) nTotal "
	cQuery += " FROM " + RetSqlName('DTC') + " NF "
	cQuery += " WHERE NF.DTC_FILIAL = '" + xFilial("DTC") + "'"
	cQuery += 	" AND NF.DTC_FILDOC = '" + AllTrim((cAliasCT)->DT6_FILDOC) + "'"
	cQuery += 	" AND NF.DTC_DOC = '"    + AllTrim((cAliasCT)->DT6_DOC)    + "'"
	cQuery += 	" AND NF.DTC_SERIE = '"  + AllTrim((cAliasCT)->DT6_SERIE)  + "'"
	cQuery += 	" AND NF.D_E_L_E_T_ =' '"

ElseIf cSource == 'DESCRSUBSTTRIBUTARIA'

	cQuery := " SELECT SX5.X5_DESCRI X5DESCRI"
	cQuery += " FROM " + RetSqlName("SX5") + " SX5 "
	cQuery += " WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'"
	cQuery += "   AND SX5.X5_TABELA ='S2'"

	If !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS00')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS45')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS90')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS20')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMS60')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT)
	ElseIf !XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS,'_ICMSOUTRAUF')==Nil
		cSitTriba := Iif( XmlChildEx(oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF,'_CST')==Nil," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_CST:TEXT)
	EndIf

	cQuery += " AND SX5.X5_CHAVE  ='" +cSitTriba+ "'"
	cQuery += " AND SX5.D_E_L_E_T_ = ' '"

ElseIf cSource == "PRODUTOS_PERIGOSOS"

	cQuery := " SELECT DTC.DTC_PESO, DTC.DTC_QTDVOL, DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_GRPEMB, DY3.DY3_CLASSE, DY3.DY3_NRISCO "
	cQuery += " FROM " + RetSqlName("DTC") + " DTC , " + RetSqlName("SB5") + " SB5 , " + RetSqlName("DY3") + " DY3 "
	cQuery += " WHERE DTC.DTC_FILIAL   = '"  + xFilial("DT6") + "' "
	cQuery += " AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDOC + "'"
	cQuery += " AND DTC.DTC_DOC = '" + (cAliasCT)->DT6_DOC + "'"
	cQuery += " AND DTC.DTC_SERIE = '" + (cAliasCT)->DT6_SERIE + "'"
	cQuery += " AND SB5.B5_CARPER = '1' " //-- Carga Perigosa
	cQuery += " AND DTC.DTC_CODPRO = SB5.B5_COD"
	cQuery += " AND DY3.DY3_ONU = SB5.B5_ONU "
	cQuery += " AND DY3.DY3_ITEM = SB5.B5_ITEM "
	cQuery += " AND DTC.D_E_L_E_T_ = ' '"
	cQuery += " AND SB5.D_E_L_E_T_ = ' '"
	cQuery += " AND DY3.D_E_L_E_T_ = ' '"

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR35   ³ Autor ³Felipe Barbiere        ³ Data ³01/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Retorna se usuário utliza TOTVS Colaboração               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function UsaColaboracao(cModelo)

Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif

return (lUsa)

/*
	Personalizacao
*/
Static function GetSubContratacao(cDocumento,cSerie)
	local cQuery	:= ""
	Local cAlias	:= ""
	Local aRet		:= {}

	cQuery := " SELECT SA2.A2_NOME, SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_RNTRC, SA2.A2_END "					+ CRLF
	cQuery += "	FROM " 			+ retSqlTab("DTA")	 														+ CRLF
	cQuery += "	INNER JOIN "	+ retSqlTab("DTR") + " ON DTR.DTR_FILIAL = '" + xFilial("DTR") + "'"		+ CRLF
	cQuery += "	AND DTR.DTR_VIAGEM = DTA.DTA_VIAGEM " 														+ CRLF
	cQuery += "	AND DTR.D_E_L_E_T_ = ' ' " 																	+ CRLF
	cQuery += "	INNER JOIN "	+ retSqlTab("DA3") + " ON DA3.DA3_FILIAL = '" + xFilial("DA3") + "'" 		+ CRLF
	cQuery += "	AND DA3.DA3_COD    = DTR.DTR_CODVEI" 														+ CRLF
	cQuery += "	AND DA3.D_E_L_E_T_ = ' '"																	+ CRLF
	cQuery += "	INNER JOIN "	+ retSqlTab("SA2") + " ON SA2.A2_FILIAL = '" + xFilial("SA2") + "'" 		+ CRLF
	cQuery += " AND SA2.A2_COD     = DA3.DA3_CODFOR"														+ CRLF
	cQuery += " AND SA2.A2_LOJA    = DA3.DA3_LOJFOR"														+ CRLF
	cQuery += " AND SA2.D_E_L_E_T_ = ' '"																	+ CRLF
	cQuery += "  WHERE DTA.DTA_FILIAL = '" + xFilial("DTA") + "'"											+ CRLF
	cQuery += "    AND DTA.DTA_DOC    = '" + cDocumento 	+ "'"											+ CRLF
	cQuery += "    AND DTA.DTA_SERIE  = '" + cSerie 		+ "'"											+ CRLF
	cQuery += "    AND DTA.D_E_L_E_T_ = ' ' "																+ CRLF
	cQuery += " GROUP BY SA2.A2_NOME, SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_RNTRC, SA2.A2_END "					+ CRLF

	MemoWrite("\sql\RTMSR27_SUB.sql",cQuery)	

	//Abre a Consulta
	TcQuery cQuery New Alias (cAlias:=GetNextAlias())
	dbSelectArea(cAlias)

	While (cAlias)->(!EOF())
		aAdd(aRet, "Transporte subcontratado com " + AllTrim((cAlias)->A2_NOME) + " CNPJ: " + AllTrim((cAlias)->A2_CGC) + ", IE: " + AllTrim((cAlias)->A2_INSCR) )
		aAdd(aRet, "Rntrc: " + AllTrim((cAlias)->A2_RNTRC) + " " + AllTrim((cAlias)->A2_END) + ", conforme disposto no RICMS/SP, artigo 205" )

		(cAlias)->(dbSkip())
	Enddo

	(cAlias)->(dbCloseArea())

Return aRet

/*/{Protheus.doc} GetDtVencto
Retorna data de vencimento do título vinculado ao CTE
@author GILSON LIMA
@since 04/01/2017
@version P11.R8
@param cFilDoc, characters, filial CTE
@param cDoc, characters, nr. CTE
@param cPrefix, characters, prefixo CTE
@param cTipo, characters, tipo CTE
@type function
/*/
Static Function GetDtVencto(cFilDoc, cDoc, cPrefix, cTipo)

	Local dData := POSICIONE('SE1', 1, cFilDoc + cPrefix + cDoc + Space(TamSX3('E1_PARCELA')[1]) + cTipo, 'E1_VENCREA')

Return dData

Static Function getFiltroBoletoB(lFiltroA) 

	Local cFiltroB := ""		    
	Local lConverteAspas := .T.

	cFiltroB := " AND E1_NUM IN (" + lFiltroA + " ) " 
	cFiltroB += " AND E1_SERIE = '" + MV_PAR03 + "' "	
	/*
	Filtra Somente Clientes que geram boleto
	*/	
	dbSelectArea("SA1")	
	If SA1->(FieldPos("A1_ZZBOL")) > 0
		cFiltroB  += " AND A1_ZZBOL = 'S' "

	Endif

	If lConverteAspas
		cFiltroB := StrTran(cFiltroB,"'",Chr(34))
	Endif
Return (cFiltroB)	  

/*
Função Personalizada para Impressão do Boleto
*/
Static Function imprimeBoleto(oDacte)	
	Local aParam 			:= {}
	Local cCodDef			:= GetNewPar("ZZ_IMPBOL","005")
	Local cTipoDef			:= "I"
	Local lShowPerg			:= .F.
	Local lAuto				:= .F.
	Local lImprimeBoleto	:= .T.
	Local lRet				:= .T.
	Local nMvPar03			:= MV_PAR03
	Local nMvPar04			:= MV_PAR04
	Local nMvpar05          := MV_PAR05
	Local cSerie			:= MV_PAR05
	Local aCliente			:= {}
	Local aLoja				:= {}
	Local aConta			:= {}
	Local nContador			:= 0 
	Local nC				:= 0  

	Local aABCArray			:= {}
	Local aSANArray			:= {}
	Local aITAArray			:= {}
	Local aBBMArray			:= {}
	Local aBRDArray			:= {}
	Local aDAYArray			:= {}
	Local aSOFArray			:= {}
	Local aBolSup			:= {}
	Local nNewRecno			:= 0 
	Local cFiltroB			:= ""
	Local cFiltroA			:= ""
	Local lSupBAtiv 		:= GetNewPar("ZZ_SUPBOL", .F.) // Desativa emissão de Boletos Supplier Paulo David 08-12-20

	Private cFiltrosBoleto	:= "" //getFiltrosBoleto()
	Private cPrinterDANFE	:= ""
	//Default cImpressoraInf	:= ""
	Private cAliasQry

	Private DANFE_MV_PAR04	:= MV_PAR04
	Private DANFE_MV_PAR05	:= MV_PAR05
	Private DANFE_MV_PAR06	:= MV_PAR06

	//cPrinterDANFE := AllTrim(cImpressoraInf)
	cPrinterDANFE := oDacte:cPrinter//oDacte:nDevice


	IF lImprimeBoleto //.And. !Empty(cCodDef)
		If Type("cPrinterDANFE") <> "C"
			cPrinterDANFE := ""
		EndIf
		FWAlertInfo("[DANFEII][BOLETO] Impressora Selecionada: " + cPrinterDANFE)

		cAliasQry := NFCBoletos()//Recupera Alias Criado pela Consulta
		While (cAliasQry)->(!EOF())//DT6.DT6_FILDOC, DT6.DT6_DOC, DT6.DT6_SERIE, SF3.F3_DTCANC, SF3.F3_CHVNFE, SF3.F3_CLIEFOR, SF3.F3_LOJA

			If EMPTY((cAliasQry)->F3_DTCANC) .and. !EMPTY((cAliasQry)->F3_CHVNFE)
				If lSupBAtiv
					If (cAliasQry)->E1_XSUPAPR $ "E|A|P"   //Supplier
						aConta:= U_CtaCliSup((cAliasQry)->F3_CLIEFOR,(cAliasQry)->F3_LOJA)
						
						Aadd(aBolSup,{ .T., (cAliasQry)->E1RECNO,aConta[1],aConta[2],aConta[3]})					
											
					else /*IF (cAliasQry)->DT6_CLIDES == (cAliasQry)->DT6_CLIDEV  Alterado Rogerio Lemos 2018 07 25 */
					
						AADD(aCliente, (cAliasQry)->F3_CLIEFOR)						
						AADD(aLoja, (cAliasQry)->F3_LOJA)
					
						//Rotina para Retornar o Banco/Agencia/Conta e Sub-Conta associada a uma Rede ou Cliente informado					
						aConta := u_CFAFATB8((cAliasQry)->F3_CLIEFOR,(cAliasQry)->F3_LOJA)
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})

						If !Empty((cAliasQry)->E1_PORTADO) .and. (cAliasQry)->E1_PORTADO<>aConta[1]
							aConta[1] := (cAliasQry)->E1_PORTADO
							aConta[2] := (cAliasQry)->E1_AGEDEP
							aConta[3] := (cAliasQry)->E1_CONTA
						EndIf
					
						IF aConta[1] == '246'// BANCO ABC	
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aABCArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF	

						ELSEIF aConta[1] == '033'// BANCO SANTANDER						 
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aSANArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF	

						ELSEIF aConta[1] == '341' // BANCO ITAU						 
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aITAArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF
						ELSEIF aConta[1] == '107' // BANCO BBM						 
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aBBMArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF	
						ELSEIF aConta[1] == '237' // BANCO Bradesco - SIFRA						 
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aBRDArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF				
						ELSEIF aConta[1] == '637' // BANCO ITAU - SOFISA						 
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aSOFArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
							ENDIF				
							/*ELSE
							cFiltroA += "'"+STRZERO(nMvpar01,9) +"',"*/						    	                     
						ELSEIF aConta[1] == '707' // BANCO DAYCOVAL
							nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
							IF 	nNewRecno > 0
								Aadd(aDAYArray, nNewRecno)					
							ENDIF				
						ENDIF                                        
					endif
				Else /*IF (cAliasQry)->DT6_CLIDES == (cAliasQry)->DT6_CLIDEV  Alterado Rogerio Lemos 2018 07 25 */
					AADD(aCliente, (cAliasQry)->F3_CLIEFOR)						
					AADD(aLoja, (cAliasQry)->F3_LOJA)
				
					//Rotina para Retornar o Banco/Agencia/Conta e Sub-Conta associada a uma Rede ou Cliente informado					
					aConta := u_CFAFATB8((cAliasQry)->F3_CLIEFOR,(cAliasQry)->F3_LOJA)
					nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})

					If !Empty((cAliasQry)->E1_PORTADO) .and. (cAliasQry)->E1_PORTADO<>aConta[1]
						aConta[1] := (cAliasQry)->E1_PORTADO
						aConta[2] := (cAliasQry)->E1_AGEDEP
						aConta[3] := (cAliasQry)->E1_CONTA
					EndIf
				
					IF aConta[1] == '246'// BANCO ABC	
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aABCArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF	

					ELSEIF aConta[1] == '033'// BANCO SANTANDER						 
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aSANArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF	

					ELSEIF aConta[1] == '341' // BANCO ITAU						 
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aITAArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF
					ELSEIF aConta[1] == '107' // BANCO BBM						 
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aBBMArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF	
					ELSEIF aConta[1] == '237' // BANCO Bradesco - SIFRA						 
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aBRDArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF				
					ELSEIF aConta[1] == '637' // BANCO ITAU - SOFISA						 
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aSOFArray,{ .T., nNewRecno,aConta[1],aConta[2],aConta[3]})					
						ENDIF				
						/*ELSE
						cFiltroA += "'"+STRZERO(nMvpar01,9) +"',"*/						    	                     
					ELSEIF aConta[1] == '707' // BANCO DAYCOVAL
						nNewRecno:= ExecBlock("CFAFATLU",.F.,.F.,{(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE,(cAliasQry)->E1_FILIAL})
						IF 	nNewRecno > 0
							Aadd(aDAYArray, nNewRecno)					
						ENDIF				
					ENDIF                                        
				endif
			EndIf
			(cAliasQry)->(DbSkip())
		End
		(cAliasQry)->(dbCloseArea())

		//IMPRIMI BOLETOS ABC
		IF Len(aABCArray) > 0
			u_IaBolABC(aABCArray) 
		ENDIF

		//IMPRIMI BOLETOS SANTANDER
		IF Len(aSANArray) > 0
			u_IaBolSAN(aSANArray) 
		ENDIF

		//IMPRIMI BOLETOS ITAU
		IF Len(aITAArray) > 0
			u_IaBolITA(aITAArray) 
		ENDIF

		//IMPRIMI BOLETOS BBM
		IF Len(aBBMArray) > 0
			u_IaBolBRD(aBBMArray) 
		ENDIF
		
		//IMPRIMI BOLETOS Bradesco - SIFRA
		IF Len(aBRDArray) > 0
			u_IaBolBRD(aBRDArray) 
		ENDIF
		
		//IMPRIMI BOLETOS ITAU - SOFISA
		IF Len(aSOFArray) > 0
			u_IaBolSOF(aSOFArray) 
		ENDIF
		
		//IMPRIMI BOLETOS Supplier
		IF Len(aBolSup) > 0
			u_SupBolet(aBolSup)
		ENDIF
		
		//IMPRIMI BOLETOS DAYCOVAL
		IF Len(aDAYArray) > 0
			U_DIAFIN10(aDAYArray , .T. , .F.)
		ENDIF
		
		//Recarrega o Grupo de Perguntas da DANFE
		Pergunte("RTMSR25",.F.)
	ENDIF
Return (lRet)

Static Function NFCBoletos()

	Local cSQL				:= ""
	Local cAlias			:= ""               
	Local lConverteAspas	:= .F.
	Local cFiltrosBoleto  	:= getFiltrosBoleto(lConverteAspas)
	//Local cFiltroBoletoB	:= getFiltroBoletoB(lConverteAspas)
	Local lRet				:= .F.

	cSQL := " SELECT DISTINCT DT6.DT6_FILDOC, DT6.DT6_DOC, DT6.DT6_SERIE, SF3.F3_DTCANC, SF3.F3_CHVNFE, SF3.F3_CLIEFOR, SF3.F3_LOJA, SE1.E1_PORTADO, " + CRLF
	cSQL += " 		SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_FILIAL,SE1.E1_XSUPAPR, " + CRLF
	cSQL += " 		SE1.R_E_C_N_O_ AS E1RECNO, DT6.DT6_CLIDES, DT6.DT6_CLIDEV " + CRLF
	cSQL += " FROM " + retSqlTab("DT6") + " INNER JOIN " + retSqlTab("SF3") + " " + CRLF 
	cSQL += "         ON DT6.DT6_FILDOC = SF3.F3_FILIAL AND " + CRLF
	cSQL += "         DT6.DT6_DOC = SF3.F3_NFISCAL AND " + CRLF
	cSQL += "         DT6.DT6_SERIE = SF3.F3_SERIE " + CRLF
	cSQL += "     INNER JOIN " + retSqlTab("SA1") + " " + CRLF
	cSQL += "         ON SA1.A1_COD = SF3.F3_CLIEFOR " + CRLF
	cSQL += "         AND SA1.A1_LOJA = SF3.F3_LOJA " + CRLF
	cSQL += "     INNER JOIN " + retSqlTab("SE1") + " " + CRLF
	cSQL += "         ON SE1.E1_FILIAL = '" + xFilial('SE1') + "'" +CRLF
	cSQL += "         AND SE1.E1_NUM = SF3.F3_NFISCAL " + CRLF
	cSQL += "         AND SE1.E1_SERIE = SF3.F3_SERIE " + CRLF
	cSQL += "         AND SE1.E1_CLIENTE = SF3.F3_CLIEFOR " + CRLF
	cSQL += "         AND SE1.E1_LOJA = SF3.F3_LOJA " + CRLF
	cSQL += " WHERE DT6.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SF3.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SA1.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SE1.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SE1.E1_SALDO > 0 " + CRLF 


	cSQL += " 	" + cFiltrosBoleto
	
	cSQL += " ORDER BY DT6_FILDOC, DT6_DOC " + CRLF   /* Rogerio C LEmos 25/07/2018 */

	cSQL := ChangeQuery(cSQL)

	TcQuery cSQL New Alias(cAlias:=GetNextAlias())
	dbSelectArea(cAlias)

Return cAlias

/*
Função que verifica se Imprime o Boleto
*/
Static Function checaImpressaoBoleto()
	Local cSQL				:= ""
	Local cAlias			:= ""               
	Local lConverteAspas	:= .F.
	Local cFiltrosBoleto  	:= getFiltrosBoleto(lConverteAspas)
	//Local cFiltroBoletoB	:= getFiltroBoletoB(lConverteAspas)
	Local lRet				:= .F.

	cSQL := " SELECT COUNT(*) as CONTATITULOS " + CRLF
	cSQL += " FROM " + retSqlTab("DT6") + " INNER JOIN " + retSqlTab("SF3") + " " + CRLF 
	cSQL += "         ON DT6.DT6_FILDOC = SF3.F3_FILIAL AND " + CRLF
	cSQL += "         DT6.DT6_DOC = SF3.F3_NFISCAL AND " + CRLF
	cSQL += "         DT6.DT6_SERIE = SF3.F3_SERIE " + CRLF
	cSQL += "     INNER JOIN " + retSqlTab("SA1") + " " + CRLF
	cSQL += "         ON SA1.A1_COD = SF3.F3_CLIEFOR " + CRLF
	cSQL += "         AND SA1.A1_LOJA = SF3.F3_LOJA " + CRLF
	cSQL += "     INNER JOIN " + retSqlTab("SE1") + " " + CRLF
	cSQL += "         ON SE1.E1_FILIAL = '" + xFilial('SE1') + "'" +CRLF
	cSQL += "         AND SE1.E1_NUM = SF3.F3_NFISCAL " + CRLF
	cSQL += "         AND SE1.E1_SERIE = SF3.F3_SERIE " + CRLF
	cSQL += "         AND SE1.E1_CLIENTE = SF3.F3_CLIEFOR " + CRLF
	cSQL += "         AND SE1.E1_LOJA = SF3.F3_LOJA " + CRLF
	cSQL += " WHERE DT6.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SF3.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SA1.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SE1.D_E_L_E_T_<>'*' " + CRLF 
	cSQL += "     AND SE1.E1_SALDO > 0 " + CRLF 

	cSQL += " 	" + cFiltrosBoleto

	cSQL := ChangeQuery(cSQL)

	TcQuery cSQL New Alias(cAlias:=GetNextAlias())
	dbSelectArea(cAlias)
	If (cAlias)->(!EOF())
		FWAlertInfo("[DANFEII] Títulos a serem Impressos Boletos: " + cValToChar( (cAlias)->CONTATITULOS ) )
		If (cAlias)->CONTATITULOS > 0
			lRet := .T.
		Else 
			lRet := .F.
		Endif
	Endif
	(cAlias)->(dbCloseArea())
	
	

Return (lRet)

/*
Retorna os Filtros para Impressão do Boleto
*/

Static Function getFiltrosBoleto(lConverteAspas)
	Local cFiltrosBoleto := ""   

	Default lConverteAspas := .T.

	//-- MV_PAR01 - Informe lote inicial.
	//-- MV_PAR02 - Informe lote final.
	//-- MV_PAR03 - Informe documento inicial.
	//-- MV_PAR04 - Informe documento final.
	//-- MV_PAR05 - Informe serie do documento inicial.
	//-- MV_PAR06 - Informe serie do documento final.
	//-- MV_PAR07 - Informe tipo do documento.
	//-- MV_PAR08 - Buscar XML do WebService.

	//Personalizado Thadeu:
	//-- MV_PAR09 - Cliente Remetente
	//-- MV_PAR10 - Loja Remetente
	//-- MV_PAR11 - Cliente Devedor
	//-- MV_PAR12 - Loja Devedor
	//-- MV_PAR13 - Filial
	//-- MV_PAR14 - Emissão De
	//-- MV_PAR15 - Emissão Ate
	//-->Fim personalização

	cFiltrosBoleto := " AND DT6.DT6_LOTNFC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
	cFiltrosBoleto += " AND SE1.E1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	cFiltrosBoleto += " AND SE1.E1_SERIE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
	cFiltrosBoleto += " AND SE1.E1_EMISSAO BETWEEN '" + DtoS(MV_PAR13) + "' AND '" + DtoS(MV_PAR14) + "' " + CRLF
	cFiltrosBoleto += " AND DT6.DT6_FILDOC = '" + MV_PAR12 + "' "
	//cFiltrosBoleto += " AND SE1.E1_TIPO = 'CTE' " // OS CASOS DE JARINU NÃO SÃO CFE, SÃO NF	

	/*
	Filtra Somente Clientes que geram boleto
	*/

	dbSelectArea("SA1")	
	If SA1->(FieldPos("A1_ZZBOL")) > 0
		cFiltrosBoleto  += " AND SA1.A1_ZZBOL = 'S' " + CRLF
	Endif


	If lConverteAspas
		cFiltrosBoleto := StrTran(cFiltrosBoleto,"'",Chr(34))
	Endif

Return (cFiltrosBoleto)

