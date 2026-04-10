#Include 'Protheus.CH'

/*/{Protheus.doc} XRELFEC2
relatório de fechamento PIS e COFINS
@type function
@version  
@author MCS Tecnologia
@since 1/28/2026
@return variant, return_description
/*/
User Function XRELFEC2()

    Local aSays        := {}
    Local aButtons     := {}
    Local lOk          := .F.
    
    lCheckUser = .F.
    lAllEmp = .T.
    lOnlySelect= .T.
    
    //Popula as linhas que serão mostradas na tela
    aAdd(aSays, "Esse programa tem como objetivo gerar o relatório de conferencia dos retidos ")
    aAdd(aSays, "PIS/COFINS saídas. ")
    aadd(aSays, "Importante: para uma melhor visualização, o agent local precisa estar habilitado")
    aadd(aSays, "no seu navegador")

    //Botões da tela, cada botão tem um Bloco de Código
    aAdd(aButtons, { 1, .T., {|| lOk := .T., FechaBatch() }} )
    aAdd(aButtons, { 2, .T., {|| lOk := .F., FechaBatch() }} )
    
    //Chama a tela principal
    FormBatch("Relatório Conferencia Retidos - Pis e Cofins", aSays, aButtons)
    
    //Se foi confirmado a tela
    If lOk 
        FwMsgRun(,{ |oSay| fGetQuery(oSay) }, "Aguarde...", "Reunindo as informações para geração do relatório.")
    EndIf

Return

/*/{Protheus.doc} fGetQuery
Gera a consulta e o arquivo de excel
@type function
@version  
@author MCS Tecnologia
@since 1/28/2026
@param oSay, object, param_description
@return variant, return_description
/*/
Static Function fGetQuery(oSay)

    Local oFWMsExcel
	Local oExcel
    Local aParam        := Params()
    Local xQuery        := ""
    Local xAlias        := GetNextAlias()
	Local xArquivo      := ""
	Local xWorkSheet    := "Conferência Retidos - PIS e COFINS"
	Local xTitulo       := "conferência Retidos - PIS e COFINS"
    Local _ArqWeb
    Local xTime         := ""
    Local xData         := ""

    If Len(aParam) > 0

        xTime     := Replace(Time(),":","")
        xData     := dtos(dDataBase)

        xArquivo := "Conferencia"+"_"+xData+"_"+xTime+".xls"

        xQuery := "SELECT " + chr(13)
        xQuery += "    SA1.A1_COD      AS CLIENTE, " + chr(13)
        xQuery += "    SA1.A1_LOJA     AS LOJA, " + chr(13)
        xQuery += "    SA1.A1_CGC      AS CNPJ, " + chr(13)
        xQuery += "    SA1.A1_NOME     AS NOME_CLIENTE, " + chr(13)
        xQuery += "    SE1.E1_FILIAL   AS FILIAL, " + chr(13)
        xQuery += "    SE1.E1_NUM      AS NUMERO, " + chr(13)
        xQuery += "    SE1.E1_TIPO     AS TIPO, " + chr(13)
        xQuery += "    SE1.E1_NATUREZ  AS NATUREZA, " + chr(13)
        xQuery += "    CAST(SE1.E1_EMISSAO AS DATE)  AS EMISSAO, " + chr(13)
        xQuery += "    CAST(SE1.E1_VENCTO AS DATE)   AS VENCTO, " + chr(13)
        xQuery += "    CAST(SE1.E1_VENCREA AS DATE)  AS VENCREA, " + chr(13)
        xQuery += "    SE1.E1_VALOR    AS VALOR, " + chr(13)
        xQuery += "    CASE " + chr(13)
        xQuery += "        WHEN SE1.E1_NATUREZ = 'COFINS' THEN (SE1.E1_VALOR * 100 / 0.4) " + chr(13)
        xQuery += "        WHEN SE1.E1_NATUREZ = 'PIS'    THEN (SE1.E1_VALOR * 100 / 0.1) " + chr(13)
        xQuery += "        ELSE 0 " + chr(13)
        xQuery += "    END AS VALOR_CALCULADO " + chr(13)
        xQuery += "FROM " + RetSqlName("SA1") + " SA1 " + chr(13)
        xQuery += "INNER JOIN " + RetSqlName("SE1") + " SE1 " + chr(13)
        xQuery += "        ON SA1.A1_COD  = SE1.E1_CLIENTE " + chr(13)
        xQuery += "       AND SA1.A1_LOJA = SE1.E1_LOJA " + chr(13)
        xQuery += "WHERE SA1.D_E_L_E_T_ = ' ' " + chr(13)
        xQuery += "  AND SA1.A1_GRPTRIB = 'VIF' " + chr(13)
        xQuery += "  AND SA1.A1_MSBLQL  = '2' " + chr(13)
        xQuery += "  AND SE1.E1_TIPO IN ('CF-','PI-') " + chr(13)
        xQuery += "  AND SE1.D_E_L_E_T_ = ' ' " + chr(13)
        xQuery += "  AND SE1.E1_BAIXA BETWEEN '"+dTos(aParam[1])+"' AND '"+dTos(aParam[2])+"' " + chr(13)
            
        MpSysOpenQuery(xQuery,xAlias)

        (xAlias)->(DbGoTop())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Instancia o objeto e cria o xml                                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If (xAlias)->(!Eof())

            //oFWMsExcel := FWMSExcelXLSX():New()
            oFWMsExcel := FWMSExcel():New()
            
            oFWMsExcel:AddworkSheet(xWorkSheet)
            
            oFWMsExcel:AddTable(xWorkSheet, xTitulo)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cliente", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Loja", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cnpj", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Nome", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Filial Titulo", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Número", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Tipo", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Natureza", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Emissao", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vencimento", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vencimento Real", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Valor", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Valor Calculado", 3, 3, .F.)
            
        Else 
            MsgAlert("Não foram localizados dados para gerar!")
            Return 
        EndIf


        While (xAlias)->(!Eof())
            oFWMsExcel:AddRow(xWorkSheet, xTitulo, {;
                        (xAlias)->CLIENTE,;
                        (xAlias)->LOJA,;
                        (xAlias)->CNPJ,;
                        (xAlias)->NOME_CLIENTE,;
                        (xAlias)->FILIAL,;
                        (xAlias)->NUMERO,;
                        (xAlias)->TIPO,;
                        (xAlias)->NATUREZA,;
                        (xAlias)->EMISSAO,;
                        (xAlias)->VENCTO,;
                        (xAlias)->VENCREA,;
                        (xAlias)->VALOR,;
                        (xAlias)->VALOR_CALCULADO;
                })


        (xAlias)->(dbSkip())

        EndDo

        (xAlias)->(DbCloseArea())
        
        oFWMsExcel:Activate()
        //oFWMsExcel:GetXMLFile(xArquivo)
        oFWMsExcel:GetXMLFile("\"+xArquivo)
        _ArqWeb := "\"+xArquivo
        If GetRemoteType() = 5 //-- WebAgent não está atuvo
            _nRet   := CpyS2TW(_ArqWeb, .T.)
            FWAlertSuccess("Agente local não habilitado no seu navegador, com isso não será possível abrir automaticamente o arquivo, arquivo disponível para download no navegador", "PIS/COFINS")
        Else  //getremotetype() = 1 -- webagent ativo
            _nRet   := CpyS2T(_ArqWeb, "C:\TEMP")
            oExcel := MsExcel():New()
            oExcel:WorkBooks:Open("C:\Temp\"+xArquivo)
            oExcel:SetVisible(.T.)
            oExcel:Destroy()
            FWAlertSuccess("Arquivo(s) copiado(s) para C:\TEMP\", "Conferencia Retidos ")
        EndIf

    EndIf

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

    aadd(aParams, { 1, "Data baixa de"                    , Ctod(Space(08))                                   , "@!"                , '.T.','   '   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Data baixa até"                   , Ctod(Space(08))                                   , "@!"                , '.T.','   '   , '.T.', 50, .F. })

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
