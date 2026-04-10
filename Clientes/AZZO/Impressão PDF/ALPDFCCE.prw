#Include "Protheus.ch"
#Include "TBIConn.ch"
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
/*
Objetivo: Fonte criado para geração de PDF da Carta de Correção sobre NFe De Saída
Autor: André Felipe Loos
Criação: 27/05/2020
Versão: 1.0
*/
//Função principal que irá iniciar o processo
User Function ALPDFCCE()

	Local aParam        := Params()
	/*if !(Pergunte("PDFCCE",.T.))
		Return .F.

	Endif*/
	If Len(aParam) > 0
		GeraDanfe(aParam[1], aParam[2])
	EndIf

Return .f.
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Rotina que irá gerar o PDF conforme dados do xml exportado pela rotina padrão para a pasta CCE dentro da 
//Protheus Data
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function GeraDanfe(cNota,cSerie)

	Local cFilePrint        := "C:\DANFE\"
	Local cLocal            := "C:\DANFE\"
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	Local cCodBar           := " "
	Local cNomeDest         := ""
	Local cCNPJDest         := ""
	Local cEndDest          := ""
	Local cCidDest          := ""
	Local cEstDest          := ""
	Local cIeDest           := ""
	Local nMaximo           := 95
	Local nAtual            := 1
	Local oPrinter

	//Private cBmp            := GetSrvProfString('Startpath','')+"LGMID01.bmp"
	Private cBmp            := FisxLogo("1")
	Private aRetXML         := {}

	If !ExistDir( "CCE\")
		MakeDir( "CCE\" )

	Endif

	If !ExistDir( "C:\DANFE\" )
		MakeDir( "C:\DANFE\" )

	Endif

	oFont7	:= TFont():New("Arial",9,07,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8	:= TFont():New("Arial",9,08,.T.,.T.,5,.T.,5,.T.,.F.)
	//Posiciona na SF2 para coletar os dados principais para a CCE
	DbSelectArea("SF2")
	DbSetOrder(1)
	if !(DbSeek(xFilial("SF2") + Padr(cNota,9) + cSerie))
		Alert("NF não encontrada!")
		Return .F.

	Endif

	cCodBar := SF2->F2_CHVNFE
	cCliente:= SF2->F2_CLIENTE
	cLoja   := SF2->F2_LOJA
	cIdCce  := SUBSTR(SF2->F2_IDCCE,3,54) // 1101104225040552115000016455003000026901115284283803
	Conout( "ALPDFCCE - " + cIdCce )
	//Verifica o tipo da nota, para identificar se deve pegar dados de cliente ou fornecedor
	if SF2->F2_TIPO <> 'D' .AND. SF2->F2_TIPO <> 'B'

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1") + cCliente + cLoja)

		cNomeDest := alltrim(SA1->A1_NOME)
		cCNPJDest := alltrim(SA1->A1_CGC)
		cEndDest  := alltrim(SA1->A1_END)
		cCidDest  := alltrim(SA1->A1_MUN)
		cEstDest  := alltrim(SA1->A1_EST)
		cIeDest   := alltrim(SA1->A1_INSCR)

	Else
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2") + cCliente + cLoja)

		cNomeDest := alltrim(SA2->A2_NOME)
		cCNPJDest := alltrim(SA2->A2_CGC)
		cEndDest  := alltrim(SA2->A2_END)
		cCidDest  := alltrim(SA2->A2_MUN)
		cEstDest  := alltrim(SA2->A2_EST)
		cIeDest   := alltrim(SA2->A2_INSCR)

	Endif
	//Pega os dados do XML gerado anteriormente pela rotina padrão
	aRetXML := u_getObjXML(cIdCce)

	if Empty(aRetXml)
		Alert( "Dados não encontrados. Favor gerar o XML pela rotina padrão novamente na pasta C:\DANFE\" )
		Return .F.
	Endif

	cMsg    := aRetXML[1]
	dDtEmis := aRetXML[2]

	nLin := 10
	nFim := nLin + 35
	//Starta o processo de geração
	oPrinter := FWMSPrinter():New(cNota + '.PD_', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	//Imprime o código de barras conforme a chave da nota
	oPrinter:Box( nLin, 010, nFim, 450, "-4")
	oPrinter:FWMSBAR("INT25" /*cTypeBar*/,1/*nRow*/ ,1/*nCol*/, cCodBar/*cCode*/,oPrinter/*oPrint*/,.T./*lCheck*/,/*Color*/,.T./*lHorz*/,0.02/*nWidth*/,0.8/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,2/*nPFWidth*/,2/*nPFHeigth*/,.F./*lCmtr2Pix*/)

	oPrinter:Box( nLin, 450, nFim, 570, "-4")
	nLin += 20
	oPrinter:Say( nLin, 453,' Carta Correção Eletrônica')

	nLin += 15

	nFim := nLin + 90
	//box Logo Sulmedic
	oPrinter:Box(nLin, 010, nFim, 135, "-4")
	//Box Dados Emitente
	oPrinter:Box( nLin, 135, nFim, 570, "-4")
	//Inserir logo da empresa
	nLin += 10
	oPrinter:SayBitmap(nLin,012,cBmp,120,72)
	//Dados de Emitente e NF
	nLin += 10
	oPrinter:Say(nLin,140,SM0->M0_NOMECOM,oFont8)
	nLin += 10
	oPrinter:Say(nLin,140,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+" I.E.: "+SM0->M0_INSC,oFont7)
	nLin += 10
	oPrinter:Say(nLin,140,"Endereço: "+alltrim(SM0->M0_ENDCOB)+" - "+alltrim(SM0->M0_CIDCOB)+"/"+alltrim(SM0->M0_ESTCOB),oFont7)
	nLin += 15
	oPrinter:Say(nLin,140,'Emissao CCe:' + cValToChar(sTod((dDtEmis))))
	oPrinter:Say(nLin,260,'Emissao NFe:' + cValToChar((SF2->F2_EMISSAO)))
	nLin += 15
	oPrinter:Say(nLin,140,'Nota Fiscal: ' + alltrim(cValToChar(StrZero(VAL(SF2->F2_DOC),9))) + ' - ' + SF2->F2_SERIE)
	//Box destinatário
	nLin := nFim
	nFim := nLin +15
	oPrinter:Box(nLin,010, nFim, 570, "-4")
	nLin += 10
	oPrinter:Say(nLin,020,'Destinatário',oFont7)
	nLin := nFim
//  ------------------------------------------------------------------
	nFim := nLin +50
	oPrinter:Box(nLin,010, nFim, 570, "-4")
	//Dados do Destinatário
	nLin += 10
	oPrinter:Say(nLin,020,cNomeDest,oFont7)
	nLin += 10
	oPrinter:Say(nLin,020,'CNPJ: '+Transform(cCnpjDest,"@R 99.999.999/9999-99")+" I.E.: "+cIeDest,oFont7)
	nLin += 10
	oPrinter:Say(nLin,020,'Endereço: ' + cEndDest + ' - ' + cCidDest + '/' + cEstDest,oFont7)
	//Box de Dados da Mensagem / separando em substr para gerar em várias linhas conforme necessário
	nLin := nFim
	nFim := nLin + 120
	oPrinter:Box(nLin,010, nFim, 570, "-4")
	nLin += 10

	aDados := U_QuebraLin(UPPER(cMsg), nMaximo,' ', .T.)

	oPrinter:Say(nLin,020,'Mensagem:' )
	nLin += 10
	//Percorrendo as linhas geradas
	For nAtual := 1 To Len(aDados)
		oPrinter:Say(nLin, 020, aDados[nAtual])
		nLin += 10

	Next

	//Imprime a Danfe na pasta c:\CCE na máquina do usuário
	cFilePrint := cLocal + cNota + '.PD_'
	File2Printer( cFilePrint, "PDF" )
	oPrinter:cPathPDF:= cLocal
	oPrinter:Preview()

Return
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//	Rotina que irá retornar os dados do XML criado pela rotina padrão
User Function getObjXML(cIdCce)

	Local oXml		:= NIL
	Local cWarning	:= ""
	Local cXmlFile	:= ""
	Local cDtEmis	:= ""
	Local cError	:= ""
	Local cMsg		:= ""
	Local aRet		:= {}

	If File( "C:\DANFE\" + cIdCce + '-cce.xml' )

		cXmlFile := 'cce\' + cIdCce + '-cce.xml'

		If __CopyFile( "C:\DANFE\" + cIdCce + '-cce.xml' , cXmlFile )

			oXml := XmlParserFile(cXmlFile, "_", @cError, @cWarning )
			If (oXml == NIL )
				MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
				Return

			Endif

			cMsg    := OXML:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT
			cDtEmis := substr(OXML:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DHEVENTO:TEXT,1,10)

			cDtEmis := strTran(cDtEmis,'-','')

			aAdd(aRet,cMsg)
			aAdd(aRet,cDtEmis)

		Endif

	Endif

Return aRet
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function QuebraLin(cTexto, nMaxCol, cQuebra, lTiraBra)

	Local aArea     := GetArea()
	Local aTexto    := {}
	Local aAux      := {}
	Local nAtu      := 0

	//Quebrando o Array, conforme -Enter-
	aAux:= StrTokArr(cTexto,Chr(13))

	//Correndo o Array e retirando o tabulamento
	For nAtu:=1 TO Len(aAux)
		aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')

	Next

	//Correndo as linhas quebradas
	For nAtu:=1 To Len(aAux)

		//Se o tamanho de Texto, for maior que o número de colunas
		If (Len(aAux[nAtu]) > nMaxCol)

			//Enquanto o Tamanho for Maior
			While (Len(aAux[nAtu]) > nMaxCol)
				//Pegando a quebra conforme texto por parâmetro
				nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))

				//Caso não tenha, a última posição será o último espaço em branco encontrado
				If nUltPos == 0
					nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))

				Endif

				//Se não encontrar espaço em branco, a última posição será a coluna máxima
				If(nUltPos==0)
					nUltPos:=nMaxCol

				Endif

				//Adicionando Parte da Sring (de 1 até a Úlima posição válida)
				aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))

				//Quebrando o resto da String
				aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))

			EndDo

			//Adicionando o que sobrou
			aAdd(aTexto,aAux[nAtu])

		Else
			//Se for menor que o Máximo de colunas, adiciona o texto
			aAdd(aTexto,aAux[nAtu])

		Endif

	Next

	//Se for para tirar os brancos
	If lTiraBra
		//Percorrendo as linhas do texto e aplica o AllTrim
		For nAtu:=1 To Len(aTexto)
			aTexto[nAtu] := Alltrim(aTexto[nAtu])

		Next

	Endif

	RestArea(aArea)

Return aTexto

/*/{Protheus.doc} Params
Monta tela de parãmetros
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@param xNomPer, variant, param_description
@return variant, return_description
/*/
Static Function Params()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Declaração de Variáveis
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local aParams  := {}
    Local aRet     := {}
    Local aRetPar  := {}

    aadd(aParams, { 1, "Nota"                 , Space(GetSx3Cache("F2_DOC"     ,  "X3_TAMANHO" ))	, "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams, { 1, "Série"                 , Space(GetSx3Cache("F2_SERIE"   ,  "X3_TAMANHO" ))	, "@!"                , '.T.','   '   , '.T.', 40, .F. })

    If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,"Parâmetros do Relatório",.T.,.T.)
        aRetPar := AjRetPar(aRet,aParams)
    Endif

Return(aClone(aRetPar))

/*/{Protheus.doc} AjRetPar
Ajusta os Parâmetros                    
@type function
@version  
@author MCS Tecnologia
@since 1/27/2026
@param aRet, array, param_description
@param aParams, array, param_description
@return variant, return_description
/*/
Static Function AjRetPar(aRet,aParams)

Local xInc := 0

If ValType(aRet) == "A" .and. Len(aRet) == Len(aParams)
	For xInc := 1 To Len(aParams)
		If aParams[xInc,1] == 1
			aRet[xInc] := aRet[xInc]
		ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
			aRet[xInc] := aScan(aParams[xInc,4], {|x| Alltrim(x) == aRet[xInc]})
		ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
			aRet[xInc] := aRet[xInc]
		Endif
	Next xInc
Endif

Return(aClone(aRet))
