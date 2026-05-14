#Include 'Protheus.CH'

/*/{Protheus.doc} XRELFEC1
relatório de fechamento PIS e COFINS
@type function
@version  
@author MCS Tecnologia
@since 1/27/2026
@return variant, return_description
/*/
User Function XRELFEC1()

    Local aSays        := {}
    Local aButtons     := {}
    Local lOk          := .F.
    
    lCheckUser = .F.
    lAllEmp = .T.
    lOnlySelect= .T.
    
    //Popula as linhas que serão mostradas na tela
    aAdd(aSays, "Esse programa tem como objetivo gerar o relatório de fechamento código de apuração ")
    aAdd(aSays, "PIS e COFINS.  ")
    aadd(aSays, "Importante: para uma melhor visualização, o agent local precisa estar habilitado")
    aadd(aSays, "no seu navegador")

    //Botões da tela, cada botão tem um Bloco de Código
    aAdd(aButtons, { 1, .T., {|| lOk := .T., FechaBatch() }} )
    aAdd(aButtons, { 2, .T., {|| lOk := .F., FechaBatch() }} )
    
    //Chama a tela principal
    FormBatch("Relatório Fechamento - Pis e Cofins", aSays, aButtons)
    
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
@since 1/27/2026
@param oSay, object, param_description
@return variant, return_description
/*/
Static Function fGetQuery(oSay)

    Local oFWMsExcel
	Local oExcel
    Local aParam        := Params()
	Local xArquivo      := ""
	Local xWorkSheet    := "Fechamento com código apuração - PIS e COFINS"
	Local xTitulo       := "Fechamento com código apuração - PIS e COFINS"
    Local _ArqWeb
    Local xTime         := ""
    Local xData         := ""

    If Len(aParam) > 0
    
        xTime     := Replace(Time(),":","")
        xData     := dtos(dDataBase)

        xArquivo := "fechamento"+"_"+xData+"_"+xTime+".xls"

        xAlias := MCSQUERY(aParam)

        (xAlias)->(DbGoTop())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Instancia o objeto e cria o xml                                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If (xAlias)->(!Eof())

            //oFWMsExcel := FWMSExcelXLSX():New()
            oFWMsExcel := FWMSExcel():New()
            
            oFWMsExcel:AddworkSheet(xWorkSheet)
            
            oFWMsExcel:AddTable(xWorkSheet, xTitulo)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Movimento", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Filial", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Data Entrada", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Data Emissão", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Data Cancelamento", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Documento", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Série", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cliente/Fornecedor", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Loja", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Documento Origem", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Razão Social", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "CNPJ", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Incrição Estadual", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Contribuinte", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "GrpTrib Cli/For", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Município", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Estado", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Espécie", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Tipo Nf", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Duplicata", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Livro", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "TES", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "CFOP", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Item", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Produto", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Descrição", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Estoque", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "C.Contábil", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "C.Custo", 1, 1, .F.)  
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "GrpTrib Produto", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Un. Medida", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Tipo Produto", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Chave Documento", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Armazém", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Ncm", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Sit Trib ICM", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cst PIS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cst Cofins", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cst Ipi", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Quantidade", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Unitário", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Contábil", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base Icms", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Alq Icms", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Icms", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Icms Isento", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Icms Outros", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base IpI", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Alq Ipi", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Ipi", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Ipi Isento", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Ipi Ouitros", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base Icms ST", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "MVA", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Icms St Difal", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Difal Entrada", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Difal Saída", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Fecp", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Frete", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Despesas", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Desconto", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod Pis e Cofins", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base Pis", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Alq Pis", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Pis", 3, 3, .F.)      
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base Cofins", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Alq Cofins", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Cofins", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr Cofins Majorado", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cbenef", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod BCC", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cst CBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base CBS", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Aliq CBS", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr CBS", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod CBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod Escri CBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cst IBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base IBS", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Aliq IBS", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr IBS", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod IBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod Escri IBS", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "CST IM", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Base IM", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Aliq IM", 2, 2, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Vlr IM", 3, 3, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod IM", 1, 1, .F.)
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Cod Escri IM", 1, 1, .F.)
        Else 
            MsgAlert("Não foram localizados dados para gerar, revise seus parâmetros!")
            Return 
        EndIf

        While (xAlias)->(!Eof())
            oFWMsExcel:AddRow(xWorkSheet, xTitulo, {;
                        (xAlias)->MOVIMENTO,;
                        (xAlias)->FILIAL,;
                        (xAlias)->DT_ENTRADA,;
                        (xAlias)->DT_EMISSAO,;
                        Iif(dTos((xAlias)->Dt_CANCELAMENTO) == '19000101',"",(xAlias)->Dt_CANCELAMENTO),;
                        (xAlias)->NOTA_FISCAL,;
                        (xAlias)->SERIE,;
                        (xAlias)->CLI_FOR,;
                        (xAlias)->LOJA,;
                        (xAlias)->NF_ORIGEM,;
                        (xAlias)->RAZAO_SOCIAL,;
                        (xAlias)->CNPJ,;
                        (xAlias)->INSCR_ESTADUAL,;
                        (xAlias)->CONTRIBUINTE,;
                        (xAlias)->GR_TRIB_CLI_FOR,;
                        (xAlias)->MUNICIPIO,;
                        (xAlias)->ESTADO,;
                        (xAlias)->ESPECIE,;
                        (xAlias)->TIPO_NF,;
                        (xAlias)->DUPLICATA,;
                        (xAlias)->LIVRO,;
                        (xAlias)->T_E_S,;
                        (xAlias)->CFOP,;
                        (xAlias)->ITEM,;
                        (xAlias)->PRODUTO,;
                        (xAlias)->DESCRICAO,;
                        (xAlias)->ESTOQUE,;
                        (xAlias)->CONTA_CONTABIL,;
                        (xAlias)->CENTRO_CUSTO,;
                        (xAlias)->GR_TRIB_PROD,;
                        (xAlias)->UNID,;
                        (xAlias)->TIPO_PROD,;
                        (xAlias)->CHAVE_ACESSO,;
                        (xAlias)->ARMAZEM,;
                        (xAlias)->N_C_M,;
                        (xAlias)->SIT_TRIB_ICMS,;
                        (xAlias)->CST_PIS,;
                        (xAlias)->CST_COFINS,;
                        (xAlias)->CST_IPI,;
                        (xAlias)->QUANTIDADE,;
                        (xAlias)->VL_UNITARIO,;
                        (xAlias)->VL_CONTABIL,;
                        (xAlias)->BASE_ICMS,;
                        (xAlias)->ALIQ_ICMS,;
                        (xAlias)->VL_ICMS,;
                        (xAlias)->ICMS_ISENTO,;
                        (xAlias)->ICMS_OUTRAS,;
                        (xAlias)->BASE_IPI,;
                        (xAlias)->ALIQ_IPI,;
                        (xAlias)->VL_IPI,;
                        (xAlias)->IPI_ISENTO,;
                        (xAlias)->IPI_OUTRAS,;
                        (xAlias)->BASE_ICMS_ST,;
                        (xAlias)->MVA,;
                        (xAlias)->VL_ICMS_ST_DIFAL,;
                        (xAlias)->DIFAL_ENTRADA,;
                        (xAlias)->DIFAL_SAIDAS,;
                        (xAlias)->FECP,;
                        (xAlias)->FRETE,;
                        (xAlias)->DESPESAS,;
                        (xAlias)->DESCONTO,;
                        (xAlias)->CODIGO_PISECOFINS,;
                        (xAlias)->BASE_PIS,;
                        (xAlias)->ALIQ_PIS,;
                        (xAlias)->VL_PIS,;
                        (xAlias)->BASE_COFINS,;
                        (xAlias)->ALIQ_COFINS,;
                        (xAlias)->VL_COFINS,;
                        (xAlias)->VL_COFINS_MAJORADO,;
                        (xAlias)->CBENEF,;
                        (xAlias)->F4_CODBCC,;
                        (xAlias)->SIT_TRIB_CST_CBS,;
                        (xAlias)->BASE_CBS,;
                        (xAlias)->ALIQUOTA_CBS,;
                        (xAlias)->VALOR_CBS,;
                        (xAlias)->TRIBUTO_CBS,;
                        (xAlias)->COD_ESCRITURACAO_CBS,;
                        (xAlias)->CST_IBS,;
                        (xAlias)->BASE_IBS,;
                        (xAlias)->ALIQ_IBS,;
                        (xAlias)->VAL_IBS,;
                        (xAlias)->COD_IBS,;
                        (xAlias)->COD_ESCRITURACAO_IBS,;
                        (xAlias)->CST_IM,;
                        (xAlias)->BASE_IM,;
                        (xAlias)->ALIQ_IM,;
                        (xAlias)->VAL_IM,;
                        (xAlias)->COD_IM,;
                        (xAlias)->COD_ESCRITURACAO_IM;
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
            FWAlertSuccess("Arquivo(s) copiado(s) para C:\TEMP\", "PIS/COFINS")
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

    aadd(aParams, { 1, "Filial de"                  , Space(GetSx3Cache("FT_FILIAL"   ,  "X3_TAMANHO" )), "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams, { 1, "Filial até"                 , Space(GetSx3Cache("FT_FILIAL"   ,  "X3_TAMANHO" )), "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams, { 1, "Filial SF4"                 , Space(GetSx3Cache("F4_FILIAL"   ,  "X3_TAMANHO" )), "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams, { 1, "Data de"                    , Ctod(Space(08))                                   , "@!"                , '.T.','   '   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Data até"                   , Ctod(Space(08))                                   , "@!"                , '.T.','   '   , '.T.', 50, .F. })

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

/*/{Protheus.doc} MCSQUERY
Query para busca dos dados
@type function
@version  
@author rodri
@since 4/28/2026
@return variant, return_description
/*/
Static Function MCSQUERY(aParams)

    Local xQuery        := ""
    Local xAlias        := GetNextAlias()

    xQuery := "SELECT " + chr(13)
    xQuery += "'ENTRADA' AS MOVIMENTO, " + chr(13)
    xQuery += "FT.FT_FILIAL as FILIAL, " + chr(13)
    xQuery += "CAST(FT.FT_ENTRADA AS DATE) as DT_ENTRADA, " + chr(13)
    xQuery += "CAST(FT.FT_EMISSAO AS DATE) as DT_EMISSAO, " + chr(13)
    xQuery += "CAST(FT.FT_DTCANC as DATE) as Dt_CANCELAMENTO, " + chr(13)
    xQuery += "FT.FT_NFISCAL as NOTA_FISCAL, " + chr(13)
    xQuery += "FT.FT_SERIE as SERIE, " + chr(13)
    xQuery += "FT.FT_CLIEFOR as CLI_FOR, " + chr(13)
    xQuery += "FT.FT_LOJA as LOJA, " + chr(13)
    xQuery += "FT.FT_NFORI as NF_ORIGEM, " + chr(13)
    /*xQuery += "FORN.A2_NOME AS RAZAO_SOCIAL, " + chr(13)
    xQuery += "FORN.A2_CGC AS CNPJ, " + chr(13)
    xQuery += "FORN.A2_INSCR AS INSCR_ESTADUAL, " + chr(13)
    xQuery += "CASE WHEN FORN.A2_CONTRIB = '1' THEN 'Sim' " + chr(13)
    xQuery += "     WHEN FORN.A2_CONTRIB = '2' THEN 'Não' END AS CONTRIBUINTE, " + chr(13)
    xQuery += "FORN.A2_GRPTRIB AS GR_TRIB_CLI_FOR, " + chr(13)
    xQuery += "FORN.A2_MUN AS MUNICIPIO, " + chr(13)*/
    xQuery += "CASE WHEN FT.FT_TIPO = 'D' THEN CLI.A1_NOME ELSE FORN.A2_NOME END AS RAZAO_SOCIAL, " + chr(13)
    xQuery += "CASE WHEN FT.FT_TIPO = 'D' THEN CLI.A1_CGC ELSE FORN.A2_CGC END AS CNPJ, " + chr(13)
    xQuery += "CASE WHEN FORN.A2_CONTRIB = '1' THEN 'Sim' " + chr(13)
    xQuery += "     WHEN FORN.A2_CONTRIB = '2' THEN 'Não' END AS CONTRIBUINTE, " + chr(13) 
    xQuery += "CASE WHEN FT.FT_TIPO = 'D' THEN CLI.A1_INSCR ELSE FORN.A2_INSCR END AS INSCR_ESTADUAL, " + chr(13)
    xQuery += "CASE WHEN FT.FT_TIPO = 'D' THEN CLI.A1_GRPTRIB ELSE FORN.A2_MUN END AS GR_TRIB_CLI_FOR, " + chr(13)
    xQuery += "CASE WHEN FT.FT_TIPO = 'D' THEN CLI.A1_MUN ELSE FORN.A2_MUN END AS MUNICIPIO, " + chr(13)
    xQuery += "FT.FT_ESTADO as ESTADO, " + chr(13)
    xQuery += "FT.FT_ESPECIE as ESPECIE, " + chr(13)
    xQuery += "FT.FT_TIPO as TIPO_NF, " + chr(13)
    xQuery += "CASE WHEN F4.F4_DUPLIC = 'S' THEN 'SIM' ELSE 'NÃO' END AS DUPLICATA, " + chr(13)
    xQuery += "FT.FT_NRLIVRO as LIVRO, " + chr(13)
    xQuery += "FT.FT_TES as T_E_S, " + chr(13)
    xQuery += "FT.FT_CFOP as CFOP, " + chr(13)
    xQuery += "FT.FT_ITEM as ITEM, " + chr(13)
    xQuery += "FT.FT_PRODUTO as PRODUTO, " + chr(13)
    xQuery += "B1.B1_DESC as DESCRICAO, " + chr(13)
    xQuery += "B1.B1_GRTRIB as GR_TRIB_PROD, " + chr(13)
    xQuery += "B1.B1_UM as UNID, " + chr(13)
    xQuery += "B1.B1_TIPO as TIPO_PROD, " + chr(13)
    xQuery += "FT.FT_CHVNFE as CHAVE_ACESSO, " + chr(13)
    xQuery += "SD1.D1_LOCAL AS ARMAZEM, " + chr(13)
    xQuery += "FT.FT_POSIPI as N_C_M, " + chr(13)
    xQuery += "FT.FT_CLASFIS as SIT_TRIB_ICMS, " + chr(13)
    xQuery += "FT.FT_CSTPIS as CST_PIS, " + chr(13)
    xQuery += "FT.FT_CSTCOF as CST_COFINS, " + chr(13)
    xQuery += "FT.FT_CTIPI as CST_IPI, " + chr(13)
    xQuery += "FT.FT_QUANT as QUANTIDADE, " + chr(13)
    xQuery += "FT.FT_PRCUNIT as VL_UNITARIO, " + chr(13)
    xQuery += "FT.FT_VALCONT as VL_CONTABIL, " + chr(13)
    xQuery += "FT.FT_BASEICM as BASE_ICMS, " + chr(13)
    xQuery += "FT.FT_ALIQICM as ALIQ_ICMS, " + chr(13)
    xQuery += "FT.FT_VALICM as VL_ICMS, " + chr(13)
    xQuery += "FT.FT_ISENICM as ICMS_ISENTO, " + chr(13)
    xQuery += "FT.FT_OUTRICM as ICMS_OUTRAS, " + chr(13)
    xQuery += "FT.FT_BASEIPI as BASE_IPI, " + chr(13)
    xQuery += "FT.FT_ALIQIPI as ALIQ_IPI, " + chr(13)
    xQuery += "FT.FT_VALIPI as VL_IPI, " + chr(13)
    xQuery += "FT.FT_ISENIPI as IPI_ISENTO, " + chr(13)
    xQuery += "FT.FT_OUTRIPI as IPI_OUTRAS, " + chr(13)
    xQuery += "FT.FT_BASERET as BASE_ICMS_ST, " + chr(13)
    xQuery += "FT.FT_MARGEM as MVA, " + chr(13)
    xQuery += "FT.FT_ICMSRET as VL_ICMS_ST_DIFAL, " + chr(13)
    xQuery += "FT.FT_ICMSCOM as DIFAL_ENTRADA, " + chr(13)
    xQuery += "FT.FT_DIFAL as DIFAL_SAIDAS, " + chr(13)
    xQuery += "FT.FT_VFCPDIF as FECP, " + chr(13)
    xQuery += "FT.FT_FRETE as FRETE, " + chr(13)
    xQuery += "FT.FT_DESPESA as DESPESAS, " + chr(13)
    xQuery += "FT.FT_DESCONT as DESCONTO, " + chr(13)
    xQuery += "FT.FT_CODBCC as CODIGO_PISECOFINS, " + chr(13)
    xQuery += "FT.FT_BASEPIS as BASE_PIS, " + chr(13)
    xQuery += "FT.FT_ALIQPIS as ALIQ_PIS, " + chr(13)
    xQuery += "FT.FT_VALPIS as VL_PIS, " + chr(13)
    xQuery += "FT.FT_BASECOF as BASE_COFINS, " + chr(13)
    xQuery += "FT.FT_ALIQCOF as ALIQ_COFINS, " + chr(13)
    xQuery += "FT.FT_VALCOF as VL_COFINS, " + chr(13)
    xQuery += "FT.FT_MVALCOF as VL_COFINS_MAJORADO, " + chr(13)
    xQuery += "CDV.CDV_CODAJU AS CBENEF, " + chr(13)
    xQuery += "F4.F4_CODBCC AS F4_CODBCC," + chr(13)
    xQuery += "F2D.F2D_FILIAL, " + chr(13)
    xQuery += "F2D.F2D_IDREL, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_CST END),0) AS SIT_TRIB_CST_CBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQUOTA_CBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VALOR_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_TRIB END),'') AS TRIBUTO_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN CJ3.CJ3_CST END),0) AS CST_IBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQ_IBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VAL_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN CJ3.CJ3_TRIB END),'') AS COD_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN CJ3.CJ3_CST END),0) AS CST_IM, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQ_IM, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VAL_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN CJ3.CJ3_TRIB END),'') AS COD_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_IM, " + chr(13)
    xQuery += "SD1.D1_CC AS CENTRO_CUSTO, " + chr(13)
    xQuery += "SD1.D1_CONTA  AS CONTA_CONTABIL, " + chr(13)
    xQuery += "CASE WHEN F4.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS ESTOQUE " + chr(13)
    xQuery += "FROM " + RetSqlName("SFT") + " FT " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SB1") + " B1 " + chr(13)
    xQuery += "    ON B1.B1_FILIAL = ' ' " + chr(13)
    xQuery += "    AND B1.B1_COD = FT.FT_PRODUTO " + chr(13)
    xQuery += "    AND B1.D_E_L_E_T_ = ' ' " + chr(13) 
    xQuery += "INNER JOIN " + RetSqlName("SF4") + " F4  " + chr(13)
    xQuery += "    ON F4.F4_FILIAL = '"+AllTrim(aParams[3])+"' " + chr(13)
    xQuery += "    AND F4.F4_CODIGO = FT.FT_TES " + chr(13)
    xQuery += "    AND F4.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("SA2") + " FORN " + chr(13)
    xQuery += "    ON FORN.A2_FILIAL = ' ' " + chr(13)
    xQuery += "    AND FORN.A2_COD = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND FORN.A2_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND FORN.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("SA1") + " CLI " + chr(13)
    xQuery += "     ON CLI.A1_FILIAL = ' ' " + chr(13)
    xQuery += "     AND CLI.A1_COD = FT.FT_CLIEFOR  " + chr(13)
    xQuery += "     AND CLI.A1_LOJA = FT.FT_LOJA  " + chr(13)
    xQuery += "     AND CLI.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SD1") + " SD1 " + chr(13)
    xQuery += "    ON SD1.D1_FILIAL = FT.FT_FILIAL " + chr(13)
    xQuery += "    AND SD1.D1_DOC = FT.FT_NFISCAL " + chr(13)
    xQuery += "    AND SD1.D1_SERIE = FT.FT_SERIE " + chr(13)
    xQuery += "    AND SD1.D1_FORNECE = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND SD1.D1_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND SD1.D1_COD = FT.FT_PRODUTO " + chr(13)
    xQuery += "    AND SD1.D1_ITEM = FT.FT_ITEM " + chr(13)
    xQuery += "    AND SD1.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("CDV") + " CDV " + chr(13)
    xQuery += "    ON CDV.CDV_FILIAL = FT.FT_FILIAL " + chr(13)
    xQuery += "    AND CDV.CDV_DOC = FT.FT_NFISCAL " + chr(13)
    xQuery += "    AND CDV.CDV_SERIE = FT.FT_SERIE " + chr(13)
    xQuery += "    AND CDV.CDV_CLIFOR = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND CDV.CDV_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND CDV.CDV_CFOP = FT.FT_CFOP " + chr(13)
    xQuery += "    AND CDV.CDV_NUMITE = FT.FT_ITEM " + chr(13)
    xQuery += "    AND CDV.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("F2D") + " F2D " + chr(13)
    xQuery += "    ON F2D.F2D_FILIAL = SD1.D1_FILIAL " + chr(13)
    xQuery += "    AND F2D.F2D_IDREL = SD1.D1_IDTRIB " + chr(13)
    xQuery += "    AND F2D.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("CJ3") + " CJ3 " + chr(13)
    xQuery += "    ON CJ3.CJ3_FILIAL = F2D.F2D_FILIAL " + chr(13)
    xQuery += "    AND CJ3.CJ3_IDF2D = F2D.F2D_ID " + chr(13)
    xQuery += "    AND CJ3.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("F2B") + " F2B " + chr(13)
    xQuery += "    ON F2B.F2B_FILIAL = CJ3.CJ3_FILIAL " + chr(13)
    xQuery += "    AND F2B.F2B_REGRA = CJ3.CJ3_TRIB " + chr(13)
    xQuery += "WHERE " + chr(13)
    xQuery += "FT.FT_FILIAL BETWEEN '"+AllTrim(aParams[1])+"' AND '"+AllTrim(aParams[2])+"' " + chr(13)
    xQuery += "AND FT.FT_TIPOMOV = 'E' " + chr(13)
    xQuery += "AND FT.FT_ENTRADA BETWEEN '"+dTos(aParams[4])+"' AND '"+dTos(aParams[5])+"' " + chr(13)
    xQuery += "AND FT.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "GROUP BY " + chr(13)
    xQuery += "FT.FT_FILIAL, FT.FT_ENTRADA, FT.FT_EMISSAO, FT.FT_DTCANC, " + chr(13)
    xQuery += "FT.FT_NFISCAL, FT.FT_SERIE, FT.FT_CLIEFOR, FT.FT_LOJA, FT.FT_NFORI, " + chr(13)
    xQuery += "FORN.A2_NOME, FORN.A2_CGC, FORN.A2_INSCR, FORN.A2_CONTRIB, " + chr(13)
    xQuery += "FORN.A2_GRPTRIB, FORN.A2_MUN, " + chr(13)
    xQuery += "CLI.A1_NOME,CLI.A1_CGC,CLI.A1_INSCR,CLI.A1_GRPTRIB,CLI.A1_MUN, " + chr(13)
    xQuery += "FT.FT_ESTADO, FT.FT_ESPECIE, FT.FT_TIPO, " + chr(13)
    xQuery += "F4.F4_DUPLIC, FT.FT_NRLIVRO, FT.FT_TES, FT.FT_CFOP, " + chr(13)
    xQuery += "FT.FT_ITEM, FT.FT_PRODUTO, " + chr(13)
    xQuery += "B1.B1_DESC, B1.B1_GRTRIB, B1.B1_UM, B1.B1_TIPO, " + chr(13)
    xQuery += "FT.FT_CHVNFE, SD1.D1_LOCAL, " + chr(13)
    xQuery += "FT.FT_POSIPI, FT.FT_CLASFIS, FT.FT_CSTPIS, FT.FT_CSTCOF, FT.FT_CTIPI, " + chr(13)
    xQuery += "FT.FT_QUANT, FT.FT_PRCUNIT, FT.FT_VALCONT, " + chr(13)
    xQuery += "FT.FT_BASEICM, FT.FT_ALIQICM, FT.FT_VALICM, " + chr(13)
    xQuery += "FT.FT_ISENICM, FT.FT_OUTRICM, " + chr(13)
    xQuery += "FT.FT_BASEIPI, FT.FT_ALIQIPI, FT.FT_VALIPI, " + chr(13)
    xQuery += "FT.FT_ISENIPI, FT.FT_OUTRIPI, " + chr(13)
    xQuery += "FT.FT_BASERET, FT.FT_MARGEM, FT.FT_ICMSRET, " + chr(13)
    xQuery += "FT.FT_ICMSCOM, FT.FT_DIFAL, FT.FT_VFCPDIF, " + chr(13)
    xQuery += "FT.FT_FRETE, FT.FT_DESPESA, FT.FT_DESCONT, " + chr(13)
    xQuery += "FT.FT_CODBCC, FT.FT_BASEPIS, FT.FT_ALIQPIS, FT.FT_VALPIS, " + chr(13)
    xQuery += "FT.FT_BASECOF, FT.FT_ALIQCOF, FT.FT_VALCOF, FT.FT_MVALCOF, " + chr(13)
    xQuery += "CDV.CDV_CODAJU, F4.F4_CODBCC, " + chr(13)
    xQuery += "F2D.F2D_FILIAL, F2D.F2D_IDREL, " + chr(13)
    xQuery += "SD1.D1_CC, SD1.D1_CONTA, " + chr(13)
    xQuery += "F4.F4_ESTOQUE " + chr(13)
    xQuery += "UNION ALL " + chr(13)
    xQuery += "SELECT  " + chr(13)
    xQuery += "'SAÍDA' AS SAIDA, " + chr(13) 
    xQuery += "FT.FT_FILIAL as FILIAL, " + chr(13) 
    xQuery += "CAST(FT.FT_ENTRADA AS DATE) as DT_ENTRADA, " + chr(13)
    xQuery += "CAST(FT.FT_EMISSAO AS DATE) as DT_EMISSAO, " + chr(13)
    xQuery += "CAST(FT.FT_DTCANC as DATE) as Dt_CANCELAMENTO, " + chr(13)
    xQuery += "FT.FT_NFISCAL as NOTA_FISCAL, " + chr(13)
    xQuery += "FT.FT_SERIE as SERIE, " + chr(13)
    xQuery += "FT.FT_CLIEFOR as CLI_FOR, " + chr(13)
    xQuery += "FT.FT_LOJA as LOJA, " + chr(13)
    xQuery += "FT.FT_NFORI as NF_ORIGEM, " + chr(13)
    xQuery += "CLI.A1_NOME AS RAZAO_SOCIAL, " + chr(13)
    xQuery += "CLI.A1_CGC AS CNPJ, " + chr(13)
    xQuery += "CLI.A1_INSCR AS INSCR_ESTADUAL, " + chr(13)
    xQuery += "CASE WHEN CLI.A1_CONTRIB = '1' THEN 'Sim' " + chr(13)
    xQuery += "     WHEN CLI.A1_CONTRIB = '2' THEN 'Não' END AS CONTRIBUINTE, " + chr(13)
    xQuery += "CLI.A1_GRPTRIB AS GR_TRIB_CLI_FOR, " + chr(13)
    xQuery += "CLI.A1_MUN AS MUNICIPIO, " + chr(13)
    xQuery += "FT.FT_ESTADO as ESTADO, " + chr(13)
    xQuery += "FT.FT_ESPECIE as ESPECIE, " + chr(13)
    xQuery += "FT.FT_TIPO as TIPO_NF, " + chr(13)
    xQuery += "CASE WHEN F4.F4_DUPLIC = 'S' THEN 'SIM' ELSE 'NÃO' END AS DUPLICATA, " + chr(13)
    xQuery += "FT.FT_NRLIVRO as LIVRO, " + chr(13)
    xQuery += "FT.FT_TES as T_E_S, " + chr(13)
    xQuery += "FT.FT_CFOP as CFOP, " + chr(13)
    xQuery += "FT.FT_ITEM as ITEM, " + chr(13)
    xQuery += "FT.FT_PRODUTO as PRODUTO, " + chr(13)
    xQuery += "B1.B1_DESC as DESCRICAO, " + chr(13)
    xQuery += "B1.B1_GRTRIB as GR_TRIB_PROD, " + chr(13)
    xQuery += "B1.B1_UM as UNID, " + chr(13)
    xQuery += "B1.B1_TIPO as TIPO_PROD, " + chr(13)
    xQuery += "FT.FT_CHVNFE as CHAVE_ACESSO, " + chr(13)
    xQuery += "SD2.D2_LOCAL AS ARMAZEM, " + chr(13)
    xQuery += "FT.FT_POSIPI as N_C_M, " + chr(13)
    xQuery += "FT.FT_CLASFIS as SIT_TRIB_ICMS, " + chr(13)
    xQuery += "FT.FT_CSTPIS as CST_PIS, " + chr(13)
    xQuery += "FT.FT_CSTCOF as CST_COFINS, " + chr(13)
    xQuery += "FT.FT_CTIPI as CST_IPI, " + chr(13)
    xQuery += "FT.FT_QUANT as QUANTIDADE, " + chr(13)
    xQuery += "FT.FT_PRCUNIT as VL_UNITARIO, " + chr(13)
    xQuery += "FT.FT_VALCONT as VL_CONTABIL, " + chr(13)
    xQuery += "FT.FT_BASEICM as BASE_ICMS, " + chr(13)
    xQuery += "FT.FT_ALIQICM as ALIQ_ICMS, " + chr(13)
    xQuery += "FT.FT_VALICM as VL_ICMS, " + chr(13)
    xQuery += "FT.FT_ISENICM as ICMS_ISENTO, " + chr(13)
    xQuery += "FT.FT_OUTRICM as ICMS_OUTRAS, " + chr(13)
    xQuery += "FT.FT_BASEIPI as BASE_IPI, " + chr(13)
    xQuery += "FT.FT_ALIQIPI as ALIQ_IPI, " + chr(13)
    xQuery += "FT.FT_VALIPI as VL_IPI, " + chr(13)
    xQuery += "FT.FT_ISENIPI as IPI_ISENTO, " + chr(13)
    xQuery += "FT.FT_OUTRIPI as IPI_OUTRAS, " + chr(13)
    xQuery += "FT.FT_BASERET as BASE_ICMS_ST, " + chr(13)
    xQuery += "FT.FT_MARGEM as MVA, " + chr(13)
    xQuery += "FT.FT_ICMSRET as VL_ICMS_ST_DIFAL, " + chr(13)
    xQuery += "FT.FT_ICMSCOM as DIFAL_ENTRADA, " + chr(13)
    xQuery += "FT.FT_DIFAL as DIFAL_SAIDAS, " + chr(13)
    xQuery += "FT.FT_VFCPDIF as FECP, " + chr(13)
    xQuery += "FT.FT_FRETE as FRETE, " + chr(13)
    xQuery += "FT.FT_DESPESA as DESPESAS, " + chr(13)
    xQuery += "FT.FT_DESCONT as DESCONTO, " + chr(13)
    xQuery += "FT.FT_CODBCC as CODIGO_PISECOFINS, " + chr(13)
    xQuery += "FT.FT_BASEPIS as BASE_PIS, " + chr(13)
    xQuery += "FT.FT_ALIQPIS as ALIQ_PIS, " + chr(13)
    xQuery += "FT.FT_VALPIS as VL_PIS, " + chr(13)
    xQuery += "FT.FT_BASECOF as BASE_COFINS, " + chr(13)
    xQuery += "FT.FT_ALIQCOF as ALIQ_COFINS, " + chr(13)
    xQuery += "FT.FT_VALCOF as VL_COFINS, " + chr(13)
    xQuery += "FT.FT_MVALCOF as VL_COFINS_MAJORADO, " + chr(13)
    xQuery += "CDV.CDV_CODAJU AS CBENEF, " + chr(13)
    xQuery += "F4.F4_CODBCC AS F4_CODBCC, " + chr(13)
    xQuery += "F2D.F2D_FILIAL, " + chr(13)
    xQuery += "F2D.F2D_IDREL, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_CST END),0) AS SIT_TRIB_CST_CBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQUOTA_CBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VALOR_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_TRIB END),'') AS TRIBUTO_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_CBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN CJ3.CJ3_CST END),0) AS CST_IBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQ_IBS, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSEST' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VAL_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_TRIB END),'') AS COD_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_IBS, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN CJ3.CJ3_CST END),0) AS CST_IM, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_BASE ELSE 0 END),0) AS BASE_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_ALIQ ELSE 0 END),0) AS ALIQ_IM, " + chr(13)
    xQuery += "COALESCE(SUM(CASE WHEN F2B.F2B_TRIB = 'IBSMUN' THEN F2D.F2D_VALOR ELSE 0 END),0) AS VAL_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN CJ3.CJ3_TRIB END),'') AS COD_IM, " + chr(13)
    xQuery += "COALESCE(MAX(CASE WHEN F2B.F2B_TRIB = 'CBSFED' THEN F2B.F2B_CODESC END),'') AS COD_ESCRITURACAO_IM, " + chr(13)
    xQuery += "SD2.D2_CCUSTO AS CENTRO_CUSTO, " + chr(13)
    xQuery += "SD2.D2_CONTA  AS CONTA_CONTABIL, " + chr(13)
    xQuery += "CASE WHEN F4.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS ESTOQUE " + chr(13)
    xQuery += "FROM " + RetSqlName("sft") + " FT " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("sb1") + " B1 " + chr(13)
    xQuery += "    ON B1.B1_FILIAL = ' ' " + chr(13)
    xQuery += "    AND B1.B1_COD = FT.FT_PRODUTO " + chr(13)
    xQuery += "    AND B1.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SF4") + " F4 " + chr(13)
    xQuery += "    ON F4.F4_FILIAL = '"+AllTrim(aParams[3])+"' " + chr(13)
    xQuery += "    AND F4.F4_CODIGO = FT.FT_TES " + chr(13)
    xQuery += "    AND F4.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SA1") + " CLI " + chr(13)
    xQuery += "    ON CLI.A1_FILIAL = ' ' " + chr(13)
    xQuery += "    AND CLI.A1_COD = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND CLI.A1_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND CLI.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 " + chr(13)
    xQuery += "    ON SD2.D2_FILIAL = FT.FT_FILIAL " + chr(13)
    xQuery += "    AND SD2.D2_DOC = FT.FT_NFISCAL " + chr(13)
    xQuery += "    AND SD2.D2_SERIE = FT.FT_SERIE " + chr(13)
    xQuery += "    AND SD2.D2_CLIENTE = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND SD2.D2_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND SD2.D2_COD = FT.FT_PRODUTO " + chr(13)
    xQuery += "    AND SD2.D2_ITEM = FT.FT_ITEM " + chr(13)
    xQuery += "    AND SD2.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("CDV") + " CDV " + chr(13)
    xQuery += "    ON CDV.CDV_FILIAL = FT.FT_FILIAL " + chr(13)
    xQuery += "    AND CDV.CDV_DOC = FT.FT_NFISCAL " + chr(13)
    xQuery += "    AND CDV.CDV_SERIE = FT.FT_SERIE " + chr(13)
    xQuery += "    AND CDV.CDV_CLIFOR = FT.FT_CLIEFOR " + chr(13)
    xQuery += "    AND CDV.CDV_LOJA = FT.FT_LOJA " + chr(13)
    xQuery += "    AND CDV.CDV_CFOP = FT.FT_CFOP " + chr(13)
    xQuery += "    AND CDV.CDV_NUMITE = FT.FT_ITEM " + chr(13)
    xQuery += "    AND CDV.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("F2D") + " F2D " + chr(13)
    xQuery += "    ON F2D.F2D_FILIAL = SD2.D2_FILIAL " + chr(13)
    xQuery += "    AND F2D.F2D_IDREL = SD2.D2_IDTRIB " + chr(13)
    xQuery += "    AND F2D.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("CJ3") + " CJ3  " + chr(13)
    xQuery += "    ON CJ3.CJ3_FILIAL = F2D.F2D_FILIAL " + chr(13) 
    xQuery += "    AND CJ3.CJ3_IDF2D = F2D.F2D_ID " + chr(13)
    xQuery += "    AND CJ3.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " + RetSqlName("F2B") + " F2B " + chr(13)
    xQuery += "    ON F2B.F2B_FILIAL = CJ3.CJ3_FILIAL " + chr(13)
    xQuery += "    AND F2B.F2B_REGRA = CJ3.CJ3_TRIB " + chr(13)
    xQuery += "WHERE " + chr(13)
    xQuery += "FT.FT_FILIAL BETWEEN '"+AllTrim(aParams[1])+"' AND '"+AllTrim(aParams[2])+"' " + chr(13)
    xQuery += "AND FT.FT_TIPOMOV = 'S' " + chr(13)
    xQuery += "AND FT.FT_ENTRADA BETWEEN '"+dTos(aParams[4])+"' AND '"+dTos(aParams[5])+"' " + chr(13)
    xQuery += "AND FT.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "GROUP BY " + chr(13)
    xQuery += "FT.FT_FILIAL, FT.FT_ENTRADA, FT.FT_EMISSAO, FT.FT_DTCANC, " + chr(13)
    xQuery += "FT.FT_NFISCAL, FT.FT_SERIE, FT.FT_CLIEFOR, FT.FT_LOJA, FT.FT_NFORI, " + chr(13)
    xQuery += "CLI.A1_NOME, CLI.A1_CGC, CLI.A1_INSCR, CLI.A1_CONTRIB, " + chr(13)
    xQuery += "CLI.A1_GRPTRIB, CLI.A1_MUN, " + chr(13)
    xQuery += "FT.FT_ESTADO, FT.FT_ESPECIE, FT.FT_TIPO, " + chr(13)
    xQuery += "F4.F4_DUPLIC, FT.FT_NRLIVRO, FT.FT_TES, FT.FT_CFOP, " + chr(13)
    xQuery += "FT.FT_ITEM, FT.FT_PRODUTO, " + chr(13)
    xQuery += "B1.B1_DESC, B1.B1_GRTRIB, B1.B1_UM, B1.B1_TIPO, " + chr(13)
    xQuery += "FT.FT_CHVNFE, SD2.D2_LOCAL, " + chr(13)
    xQuery += "FT.FT_POSIPI, FT.FT_CLASFIS, FT.FT_CSTPIS, FT.FT_CSTCOF, FT.FT_CTIPI, " + chr(13)
    xQuery += "FT.FT_QUANT, FT.FT_PRCUNIT, FT.FT_VALCONT, " + chr(13)
    xQuery += "FT.FT_BASEICM, FT.FT_ALIQICM, FT.FT_VALICM, " + chr(13)
    xQuery += "FT.FT_ISENICM, FT.FT_OUTRICM, " + chr(13)
    xQuery += "FT.FT_BASEIPI, FT.FT_ALIQIPI, FT.FT_VALIPI, " + chr(13)
    xQuery += "FT.FT_ISENIPI, FT.FT_OUTRIPI, " + chr(13)
    xQuery += "FT.FT_BASERET, FT.FT_MARGEM, FT.FT_ICMSRET, " + chr(13)
    xQuery += "FT.FT_ICMSCOM, FT.FT_DIFAL, FT.FT_VFCPDIF, " + chr(13)
    xQuery += "FT.FT_FRETE, FT.FT_DESPESA, FT.FT_DESCONT, " + chr(13)
    xQuery += "FT.FT_CODBCC, FT.FT_BASEPIS, FT.FT_ALIQPIS, FT.FT_VALPIS, " + chr(13)
    xQuery += "FT.FT_BASECOF, FT.FT_ALIQCOF, FT.FT_VALCOF, FT.FT_MVALCOF, " + chr(13)
    xQuery += "CDV.CDV_CODAJU, F4.F4_CODBCC, " + chr(13)
    xQuery += "F2D.F2D_FILIAL, F2D.F2D_IDREL, " + chr(13)
    xQuery += "SD2.D2_CCUSTO, SD2.D2_CONTA, " + chr(13) 
    xQuery += "F4.F4_ESTOQUE " + chr(13)

    MpSysOpenQuery(xQuery,xAlias)


Return xAlias
