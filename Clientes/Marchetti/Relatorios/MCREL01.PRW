#Include 'Protheus.CH'

//VARIAVEIS STATICAS PARA CONTROLE DE PAGINAS
#DEFINE NULTIMALINHA	2300
#DEFINE NMARGESQUERDA   0015
#DEFINE NMARGDIREITA	2000


/*/{Protheus.doc} MCREL01
Relatóio de contas
@type function
@version  
@author MCS Tecnologia
@since 3/31/2026
@return variant, return_description
/*/
User Function MCREL01()

    Local aSays        := {}
    Local aButtons     := {}
    Local lOk          := .F.
    
    lCheckUser = .F.
    lAllEmp = .T.
    lOnlySelect= .T.
    
    aAdd(aSays, "Esse programa tem como objetivo gerar o relatório dos valores contidos nas ")
	aAdd(aSays, "contas de débito e crédito diretamente da CT2.")
    aadd(aSays, "Importante: para uma melhor visualização, o agent local precisa estar habilitado")

    aAdd(aButtons, { 1, .T., {|| lOk := .T., FechaBatch() }} )
    aAdd(aButtons, { 2, .T., {|| lOk := .F., FechaBatch() }} )
    
    FormBatch("Totais débito e crédito", aSays, aButtons)
    
    If lOk 
        FwMsgRun(,{ |oSay| fGetQuery(oSay) }, "Aguarde...", "Realizando consulta na CT2 do período informado.")
    EndIf

Return

/*/{Protheus.doc} fGetQuery
Query princial
@type function
@version  
@author MCS Tecnologia
@since 3/31/2026
@param oSay, object, param_description
@return variant, return_description
/*/
Static Function fGetQuery(oSay)

    Local aParams   	:= Params()
    Local xQuery    	:= ""
    Local xAlias    	:= GetNextAlias()
    Local aResultCred   := {}
    Local aResultDeb    := {}
	Local dData     	
	Local nMes      	:= 0
	Local cMesExtenso 	:= ""
	Local nTotalCred    := 0
	Local nTotalDeb     := 0
	Local lAtvPdf       := .F.

    If Len(aParams) > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query com o union buscando as contas e datas informadas
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        xQuery := "SELECT " + chr(13)
        xQuery += "CT2_CREDIT AS CONTA, " + chr(13)
        xQuery += "LEFT(CT2_DATA, 6) AS ANO_MES, " + chr(13)
        xQuery += "SUM(CT2_VLR01) AS TOTAL " + chr(13)
        xQuery += "FROM " + RetSqlName("CT2") + chr(13)
		xQuery += "WHERE CT2_FILIAL BETWEEN '"+AllTrim(aParams[5])+"' AND '"+AllTrim(aParams[6])+"' " + chr(13)
        xQuery += "AND CT2_DATA BETWEEN '"+dTos(aParams[1])+"' AND '"+dTos(aParams[2])+"' " + chr(13) 
        xQuery += "AND CT2_CREDIT = '"+AllTrim(aParams[3])+"' " + chr(13)
        xQuery += "AND D_E_L_E_T_ = ' ' " + chr(13)
        xQuery += "GROUP BY " + chr(13)
        xQuery += "CT2_CREDIT, " + chr(13)
        xQuery += "LEFT(CT2_DATA, 6) " + chr(13)
        xQuery += "UNION ALL " + chr(13)
        xQuery += "SELECT " + chr(13)
        xQuery += "CT2_DEBITO AS CONTA, " + chr(13)
        xQuery += "LEFT(CT2_DATA, 6) AS ANO_MES, " + chr(13)
        xQuery += "SUM(CT2_VLR01) AS TOTAL " + chr(13)
        xQuery += "FROM " + RetSqlName("CT2") + chr(13)
		xQuery += "WHERE CT2_FILIAL BETWEEN '"+AllTrim(aParams[5])+"' AND '"+AllTrim(aParams[6])+"' " + chr(13)
        xQuery += "AND CT2_DATA BETWEEN '"+dTos(aParams[1])+"' AND '"+dTos(aParams[2])+"' " + chr(13)
        xQuery += "AND CT2_DEBITO = '"+AllTrim(aParams[4])+"' " + chr(13)
        xQuery += "AND D_E_L_E_T_ = ' ' " + chr(13)
        xQuery += "GROUP BY " + chr(13)
        xQuery += "CT2_DEBITO, " + chr(13)
        xQuery += "LEFT(CT2_DATA, 6) " + chr(13)
        xQuery += "ORDER BY " + chr(13)
        xQuery += "ANO_MES " + chr(13)

        MpSysOpenQuery(xQuery, xAlias)

        (xAlias)->(DbGoTop())

		If (xAlias)->(Eof())
			FwAlertWarning("Nenhum registro encontrado para o período informado.", "Totvs")
			Return
		Else

			While !(xAlias)->(Eof())

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pegando o mês para buscar o extenso
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dData := stod((xAlias)->ANO_MES+'01')	
				nMes := month(dData)
				cMesExtenso := MesExtenso(nMes)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravado no array correspondente e totalizando
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim((xAlias)->CONTA) == AllTrim(aParams[3])
					aadd(aResultCred, { cMesExtenso, Substr((xAlias)->ANO_MES,1,4), (xAlias)->TOTAL, (xAlias)->CONTA })
					nTotalCred += (xAlias)->TOTAL
				Else 
					aadd(aResultDeb, { cMesExtenso, Substr((xAlias)->ANO_MES,1,4), (xAlias)->TOTAL, (xAlias)->CONTA })
					nTotalDeb += (xAlias)->TOTAL
				EndIf

				(xAlias)->(DbSkip())
				
			EndDo

		EndIf

		If aParams[7] == 1 
			If lAtvPdf == .F.
				FwAlertWarning("Rotina em desenvolvimento, utilize o excel","Totvs")
				Return
			EndIf
			fGeraPDF(aResultCred,nTotalCred)
		Else
			FwMsgRun(,{ |oSay| fGeraExcel(oSay,aResultCred,aResultDeb,nTotalCred,nTotalDeb) }, "Aguarde...", "Gerando excel.")
		EndIf

	EndIf

	(xAlias)->(DbCloseArea())

Return 
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

    aadd(aParams, { 1, "Data de"                    , Ctod(Space(08))                                    , "@!"                , '.T.','   '   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Data até"                   , Ctod(Space(08))                                    , "@!"                , '.T.','   '   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Conta crédito"              , Space(GetSx3Cache("CT1_CONTA"   ,  "X3_TAMANHO" )) , "@!"                , '.T.','CT1'   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Conta débito"               , Space(GetSx3Cache("CT1_CONTA"   ,  "X3_TAMANHO" )) , "@!"                , '.T.','CT1'   , '.T.', 50, .F. })
	aadd(aParams, { 1, "Filial de"                  , Space(GetSx3Cache("CT1_FILIAL"  ,  "X3_TAMANHO" )) , "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams, { 1, "Filial até"                 , Space(GetSx3Cache("CT1_FILIAL"  ,  "X3_TAMANHO" )) , "@!"                , '.T.','   '   , '.T.', 40, .F. })
	aadd(aParams, { 2, "Tipo"                       , 2 , {"PDF", "Excel"}                            , 100, ".T.", .T.})

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

/*/{Protheus.doc} fGeraExcel
Gera o excel com os registros de faturamento
@type function
@version  
@author MCS Tecnologia
@since 4/2/2026
@param aDados, array, param_description
@return variant, return_description
/*/
Static Function fGeraExcel(oSay,aDados1,aDados2,nTotal1,nTotal2)

    Local oFWMsExcel
	Local oExcel
    Local xArquivo       := ""
	Local xTitulo1       := ""
	Local xTitulo2       := ""
    Local _ArqWeb
    Local nI             := 0

    xArquivo := "relacao_contas_ct2.xls"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Buscando a descrição da conta
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xTitulo1 := "Crédito " + fRetDescCT1(aDados1[1][4])
    xTitulo2 := "Débito " + fRetDescCT1(aDados2[1][4])

    oFWMsExcel := FWMSExcel():New()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Garando a aba de crédito
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    oFWMsExcel:AddworkSheet("Credito - " + AllTrim(aDados1[1][4]))

    oFWMsExcel:AddTable("Credito - " + AllTrim(aDados1[1][4]), xTitulo1)

    oFWMsExcel:AddColumn("Credito - " + AllTrim(aDados1[1][4]), xTitulo1, "Mês", 1, 1, .F.)
    oFWMsExcel:AddColumn("Credito - " + AllTrim(aDados1[1][4]), xTitulo1, "Ano", 1, 1, .F.)
    oFWMsExcel:AddColumn("Credito - " + AllTrim(aDados1[1][4]), xTitulo1, "Valor", 3, 3, .F.)

	For nI := 1 To Len(aDados1)

            oFWMsExcel:AddRow("Credito - " + AllTrim(aDados1[1][4]), xTitulo1, {;
                aDados1[nI][1],; 			 //Mês
                SubStr(aDados1[nI][2],1,4),; //Ano
                aDados1[nI][3];              //Valor
            })

    Next nI
	oFWMsExcel:AddRow("Credito - " + AllTrim(aDados1[1][4]), xTitulo1, {"","",nTotal1})

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravando a aba de débito
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oFWMsExcel:AddworkSheet("Debito - " + AllTrim(aDados2[1][4]))
	oFWMsExcel:AddTable("Debito - " + AllTrim(aDados2[1][4]), xTitulo2)

    oFWMsExcel:AddColumn("Debito - " + AllTrim(aDados2[1][4]), xTitulo2, "Mês", 1, 1, .F.)
    oFWMsExcel:AddColumn("Debito - " + AllTrim(aDados2[1][4]), xTitulo2, "Ano", 1, 1, .F.)
    oFWMsExcel:AddColumn("Debito - " + AllTrim(aDados2[1][4]), xTitulo2, "Valor", 3, 3, .F.)

	For nI := 1 To Len(aDados2)

            oFWMsExcel:AddRow("Debito - " + AllTrim(aDados2[1][4]), xTitulo2, {;
                aDados2[nI][1],; 			 //Mês
                SubStr(aDados2[nI][2],1,4),; //Ano
                aDados2[nI][3];              //Valor
            })

    Next nI

	oFWMsExcel:AddRow("Debito - " + AllTrim(aDados2[1][4]), xTitulo2, {"","",nTotal2})

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gerando o excel e verificando se o wegabent está ativo
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile("\"+xArquivo)
    _ArqWeb := "\"+xArquivo
    If GetRemoteType() = 5 
        _nRet   := CpyS2TW(_ArqWeb, .T.)
        FWAlertSuccess("Agente local não habilitado no seu navegador, com isso não será possível abrir automaticamente o arquivo, arquivo disponível para download no navegador", "Faturamento")
    Else  
        _nRet   := CpyS2T(_ArqWeb, "C:\TEMP")
        oExcel := MsExcel():New()
        oExcel:WorkBooks:Open("C:\Temp\"+xArquivo)
        oExcel:SetVisible(.T.)
        oExcel:Destroy()
        FWAlertSuccess("Arquivo(s) copiado(s) para C:\TEMP\", "Faturamento")
    EndIf

Return

/*/{Protheus.doc} fRetDescCT1
Retorna a descrição da conta
@type function
@version  
@author rodri
@since 4/7/2026
@param xConta, variant, param_description
@return variant, return_description
/*/
Static Function fRetDescCT1(xConta)

	Local xAlias := GetNextAlias()
	Local xQuery := ""
	Local xRet   := ""

	xQuery := "SELECT CT1_DESC01 FROM " + RetSqlName("CT1") + " WHERE CT1_CONTA = '"+AllTrim(xConta)+"' AND D_E_L_E_T_ = ' ' "

	MpSysOpenQuery(xQuery, xAlias)

	If (xAlias)->(Eof())
		xRet := ""
	Else
		xRet := (xAlias)->CT1_DESC01
	EndIf

	(xAlias)->(DbCloseArea())

Return xRet


/*/{Protheus.doc} fGeraPDF
Gera o PDF com os registros de faturamento
@type function
@version  
@author rodri
@since 4/2/2026
@param aDados, array, param_description
@return variant, return_description
/*/
Static Function fGeraPDF(aDados,nTotal)

//Private cBmp := GetSrvProfString('Startpath','')+"LGMID.PNG"
	
	Private oFtitNeg    := TFont():New( "Futura",,21,,.T.,,,,,.f. )
	Private oFtit 		:= TFont():New( "Futura",,18,,.f.,,,,,.f. )
	Private oFontRec 	:= TFont():New( "Futura",,22,,.T.,,,,,.f. )
	Private oFont 	    := TFont():New( "Futura",,16,,.F.,,,,,.f. )
	Private oFontNeg 	:= TFont():New( "Futura",,20,,.T.,,,,,.f. )
	Private cStartPath   := GetSrvProfString("Startpath","")
	Private nLin			:= 0
	Private nPagina		:= 1
	Private cAliasTemp   := GetNextAlias()
	Private nMora		:= 0
	Private nDespesas	:= 0
	Private nOutros		:= 0
	Private nPula       := 0

	
	oPrint:=FWMSPrinter():New("Faturamento"+SubStr(aDados[1][2],1,4)+".pdf",6,.T., nil , .T.)   //TMSPrinter():New()
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(9)
	oPrint:SetMargin(60,60,60,60)
	oPrint:cPathPDF:= ALLTRIM(GETTEMPPATH())
	oPrint:StartPage()
	//exibe caixa de dialogo
	oPrint:Setup()
	
	RptStatus({|lEnd| sfImprime(@lEnd)},"Imprimindo.....")
	
	//oPrint:Preview()
	oPrint:EndPage()
	oPrint:Cancel()
	oPrint:Print()
	
Return

Static Function sfImprime(lEnd)
	
    Local nLin       := 0
	Local nX         := 0
	//1 COPIA
	//CRIANDO O BOX DO RECIBO - LINHA, MARGEM, LINHA, MARGEM, ESPESSURA BOX
	nLin += 100
	/*oPrint:Box( nLin , NMARGESQUERDA  , nLin + 1100 ,NMARGDIREITA , "00")
	oPrint:Box( nLin , 1300  , nLin+250 ,NMARGDIREITA , "00")
	nLin += 125
	oPrint:Line( nLin, 1300, nLin, NMARGDIREITA, , "00")
	nLin += 125
	oPrint:Box( nLin , NMARGESQUERDA  , nLin + 1100 ,NMARGDIREITA , "00")*/
	
	//IMPRIMINDO OS VALORES DO CABELAÇALHO DO RECBIDO
	//imprime logo da empresa
	oPrint:SayBitmap( 300,100,('Startpath','')+"LGMID1.PNG",150,200 )
	//oPrint:SayBitmap (28,8,cBmp,50,35)
	//oPrint:Say(155,NMARGESQUERDA +170 ,"aaaaaaaaaaaaaaaaaa ",oFtitNeg)
	//oPrint:Say(190, 1400 ,"R E C I B O",oFontRec)
	
	//StrZero, colocando zero a esqueda
	//faz o cálculo para o valor total do recibo
	//nValTot := cValor + nJuros + nMulta - nDescont
	//oPrint:Say(300, 1370 ,"R$"+ Transform(0+1-2, "@E 999,999.99"),oFontRec)
	

	//oPrint:Say(210,NMARGESQUERDA +170 ,"00.00.0000/0000-00 ",oFtit)
	/*oPrint:Say(210,800 ,"000000000",oFtit)
	oPrint:Say(260,NMARGESQUERDA +170 ,"Clodoaldo Gomes - 300",oFtit)
	oPrint:Say(310,NMARGESQUERDA +170 ,"89219-550",oFtit)
	oPrint:Say(310,800 ,"Joinville / SC ",oFtit)*/

		
//abaixo corpo do recibo
	
	/*Print:Say(410,NMARGESQUERDA +10 ,"Cliente",oFont)
	oPrint:Say(410,300 ,"555555555555",oFontNeg)*/
	oPrint:Say(480,NMARGESQUERDA +10 ,"FATURAMENTO ANO",oFontNeg)
	//função para imprimir extenso 50 carateres e preencher com *
	//oPrint:Say(480,400 ,SubStr(aDados[nI][2],1,4),oFontNeg)

	//laço para imprimir o extenso do valor 
	For nLin := 480 To 500
	
	//quebrando a string para imprimir o extenso.
	oPrint:SAY(NLIN, 400 ,SubStr(aDados[nI][2],1,4),oFontNeg)
	//oPrint:SAY(NLIN+=45, 400 ,""+ PADR(SUBSTR(cExtenso,65,140),64,"#"), oFont)
	//@nLin,10 Say Substr(cExtenso,(nLin-20)*70+1,70)
	Next nLin
	
	//oPrint:Say(520,400 ,"*************************************************** ",oFont)
	oPrint:Say(640,NMARGESQUERDA +10 ,"TERCÍLIO MARCHETTI IND. E COM. DE AUTOPEÇAS LTDA",oFontNeg)

	For nX := 1 To Len(aDados)

		oPrint:Say(690 + nPula,NMARGESQUERDA +30 ,aDados[nX][1],oFont)
		oPrint:Say(690 + nPula,NMARGESQUERDA +70 ,SubStr(aDados[nX][2],1,4),oFont)
		oPrint:Say(690 + nPula,NMARGESQUERDA +110 ,aDados[nX][3],oFont)

		nPula += 10

	Next nX

	/*oPrint:Say(690,NMARGESQUERDA +10 ,"Vlr. Parcela",oFont)
	oPrint:Say(690, 370 ,Transform(0, "@E 999,999.99"),oFont)
	oPrint:Say(740,NMARGESQUERDA +10 ,"Acréscimo",oFont)
	oPrint:Say(740,370,Transform(9, "@E 999,999.99"),oFont)*/
	//oPrint:Say(790,NMARGESQUERDA +10 ,"Descréscimo",oFont)
	//oPrint:Say(790,370,Transform(9, "@E 999,999.99"),oFont)
	//oPrint:Say(740,NMARGESQUERDA +10 ,"Descontos",oFont)
	//oPrint:Say(740,370,Transform(nDescont, "@E 999,999.99"),oFont)
	//oPrint:Say(790,NMARGESQUERDA +10 ,"Juros",oFont)
	//oPrint:Say(790,370,Transform(nJuros, "@E 999,999.99"),oFont)
	//dia mes e ano por extenso
	//IF nFilial == '01'
	oPrint:Say(1500,1010 ,"Rio dos cedros " + cValToChar(Day(date())) + " de " + MesExtenso(date()) + " de " + cValToChar(Year(date())) ,oFont)
		/*elseif nFilial == '02'
			oPrint:Say(790,1010 ,"Araquari " + cValToChar(Day(date())) + " de " + MesExtenso(date()) + " de " + cValToChar(Year(date())) ,oFont)
		elseif nFilial == '03'
			oPrint:Say(790,1010 ,"Simão Dias " + cValToChar(Day(date())) + " de " + MesExtenso(date()) + " de " + cValToChar(Year(date())) ,oFont)*/
	//EndIf
	
	//oPrint:Say(840,NMARGESQUERDA +10 ,"Mora",oFont)
	//oPrint:Say(840,370,Transform(nMora, "@E 999,999.99"),oFont)
	//oPrint:Say(890,NMARGESQUERDA +10 ,"Multas",oFont)
	//oPrint:Say(890,370,Transform(nMulta, "@E 999,999.99"),oFont)
	//oPrint:Say(940,NMARGESQUERDA +10 ,"Desp. Banc.",oFont)
	//oPrint:Say(940,370,Transform(nDespesas, "@E 999,999.99"),oFont)
	//oPrint:Say(990,NMARGESQUERDA +10 ,"Outros.",oFont)
	//oPrint:Say(990,370,Transform(nOutros, "@E 999,999.99"),oFont)
	//oPrint:Line(nLin, NMARGESQUERDA, nLin ,600,0 , "")
	//oPrint:Line( 960, NMARGESQUERDA + 10, 960, 600, , "")
//criando um objeto do tipo linha 
	oPrint:Line( 1040,0015,1040,600 )
	oPrint:Line( 1040,1800,1040,1000 )
	oPrint:Say(1070,1300,"Assinatura.",oFont)
	oPrint:Say(200,NMARGESQUERDA +10 ,"Valor total.",oFont)
	oPrint:Say(1110,370,Transform(0+1-2, "@E 999,999.99"),oFont)	
	//oPrint:Say(1150,NMARGESQUERDA +10 ,"Banco: " + cNomePort,oFont)
		
	
	//2 COPIA
	//nLin += 100
	//oPrint:Box( nLin , NMARGESQUERDA  , nLin + 1100 ,NMARGDIREITA , "02")
	//oPrint:Say(nLin+200,NMARGESQUERDA +10 ,"TESTEE TESTE TESTE TESTE ",oFont1)

return

/*


*/
Static Function sfControl()
	*****************************
	If nLin > NULTIMALINHA
		nPagina++
		nLin += 60
		oPrint:Say( nLin , 950, "*** CONTINUA NA PÁ"+chr(65533)+"GINA :"+Transform(nPagina,"@E 99")+" ***", oFont3, 100 )
		nLin := 0
		oPrint:EndPage()
		oPrint:StartPage()
	EndIf

	
RETURN 

