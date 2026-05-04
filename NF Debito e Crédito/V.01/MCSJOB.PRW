#Include 'Protheus.CH'


/*/{Protheus.doc} MCSJOB
Job para gravação da tabela de monitoramento de nota débito e crédito
@type function
@version  
@author MCS Tecnologia
@since 4/30/2026
@return variant, return_description
/*/

User Function MCSTESTE()

    U_MCSJOB({FwCodEmp(),FwCodFil()})

Return

User Function MCSJOB(aEmp)

    Local lParMul   
    Local lParnProc 


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Abrindo o ambiente                                                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If IsBlind()
        RpcSetType(3)
        RpcSetEnv(aEmp[1],aEmp[2])
    EndIf

    lParMul   := SuperGetMV("XX_ATVNFMJ",.F.,.T.)
    lParnProc := SuperGetMV("XX_ATVNFNP",.F.,.T.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Query para buscar multa e jutos                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lParMul    
        xAlias := QryMulJur()
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se há registros encontrados                               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(xAlias)->(Eof())
            fGrvMonit(xAlias,'4')
        Else 
            (xAlias)->(dbCloseArea())
        EndIf
    EndIf
    If lParnProc
        xAlias := QryNProc()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se há registros encontrados                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(xAlias)->(Eof())
            fGrvMonit(xAlias,'5')
        Else 
            (xAlias)->(dbCloseArea())
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Encerrando o ambiente                                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If IsBlind()
        RpcClearEnv()
    EndIf

Return


/*/{Protheus.doc} fGrvMonit
Grava os registros na tabela de monitoramento
@type function
@version  
@author MCS Tecnologia
@since 4/30/2026
@return variant, return_description
/*/
Static Function fGrvMonit(xAlias,xTpNota)

    Local aArea     := ""
    Local xAliDoc   := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local lGeraNF   := SuperGetMV("XX_NFDCAUT",.F.,.F.) //Indica se gera a nota automaticamente
    Local xDoc      := ""

    aArea := &(xAliDoc+"->"+"(GetArea())")

    While !(xAlias)->(Eof())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se o registro já existe                         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpNota == '4'
            lRet := MCSVERIF((xAlias)->PREFIXO, (xAlias)->TITULO, (xAlias)->PARCELA, (xAlias)->TIPO, (xAlias)->LOJA, (xAlias)->COD_CLIENTE, (xAlias)->DOCUMENTO, (xAlias)->SERIE, (xAlias)->TIPO_NOTA)
        ElseIf xTpNota == '5'
            lRet := MCSVERIF("","","","",(xAlias)->LOJA, (xAlias)->COD_CLIENTE, (xAlias)->DOCUMENTO, (xAlias)->SERIE, (xAlias)->TIPO_NOTA)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Executa o reclock - executando em macro &                          ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        xDoc := GetSx8Num(xAliDoc,xAliDoc+"_ID")

        Begin Transaction

            If !lRet
                RecLock(xAliDoc, .T.)
                    &(xAliDoc+"->"+xAliDoc+"_FILIAL")   := FWxFilial(xAliDoc)
                    &(xAliDoc+"->"+xAliDoc+"_ID")       := xDoc
                    &(xAliDoc+"->"+xAliDoc+"_PREF")     := Iif(xTpNota == '4',(xAlias)->PREFIXO,'')
                    &(xAliDoc+"->"+xAliDoc+"_NUMTIT")   := Iif(xTpNota == '4',(xAlias)->TITULO,'')
                    &(xAliDoc+"->"+xAliDoc+"_PARCEL")   := Iif(xTpNota == '4',(xAlias)->PARCELA,'')
                    &(xAliDoc+"->"+xAliDoc+"_TIPO")     := Iif(xTpNota == '4',(xAlias)->TIPO,'')
                    &(xAliDoc+"->"+xAliDoc+"_CLIENT")   := AllTrim((xAlias)->COD_CLIENTE)
                    &(xAliDoc+"->"+xAliDoc+"_LOJA")     := AllTrim((xAlias)->LOJA)
                    &(xAliDoc+"->"+xAliDoc+"_NOME")     := AllTrim((xAlias)->NOME_CLIENTE)
                    &(xAliDoc+"->"+xAliDoc+"_DOCUME")   := (xAlias)->DOCUMENTO
                    &(xAliDoc+"->"+xAliDoc+"_SERIE")    := (xAlias)->SERIE
                    &(xAliDoc+"->"+xAliDoc+"_EMISS")    := sTod((xAlias)->DT_EMISSAO)
                    &(xAliDoc+"->"+xAliDoc+"_VECTO")    := Iif(xTpNota == '4',sTod((xAlias)->DT_VENCIMENTO),sTod(""))
                    &(xAliDoc+"->"+xAliDoc+"_BAIXA")    := Iif(xTpNota == '4',sTod((xAlias)->DT_BAIXA),sTod(""))
                    &(xAliDoc+"->"+xAliDoc+"_VLRTIT")   := Iif(xTpNota == '4',(xAlias)->VALOR_TITULO,(xAlias)->VALOR_TOTAL) //Uso o mesmo campo para gravar valor da NF e titulo
                    &(xAliDoc+"->"+xAliDoc+"_VLRJUR")   := Iif(xTpNota == '4',(xAlias)->VALOR_JUROS,0)
                    &(xAliDoc+"->"+xAliDoc+"_QTDIT")    := (xAlias)->QTDE_ITENS_SD2
                    &(xAliDoc+"->"+xAliDoc+"_IBSCBS")   := (xAlias)->CALCULA_IBS_CBS
                    &(xAliDoc+"->"+xAliDoc+"_JURITE")   := Iif(xTpNota == '4',(xAlias)->VALOR_JUROS / (xAlias)->QTDE_ITENS_SD2,0)
                    &(xAliDoc+"->"+xAliDoc+"_DKN")      := (xAlias)->EXISTE_DKN
                    &(xAliDoc+"->"+xAliDoc+"_TPNOTA")   := (xAlias)->TIPO_NOTA
                    &(xAliDoc+"->"+xAliDoc+"_NFEOK")    := Iif((xAlias)->EXISTE_DKN == 'S',"S","N")
                    &(xAliDoc+"->"+xAliDoc+"_BASECI")   := Iif(xTpNota == '5',(xAlias)->BASE_IBS_CBS,0)
                &(xAliDoc+"->"+"(MsUnlock())")
            EndIf

            ConfirmSx8()

        End Transaction

        (xAlias)->(dbSkip())

    EndDo
    
    //U_MCSLOG("INFO","MCSJOB","Execução da rotina de gravação da: " + xAliDoc)
    Conout("Execução ok ")
            
    RestArea(aArea)

    (xAlias)->(dbCloseArea())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Indica se gera nota automaticamente                                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lGeraNF
        //U_GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal)
    EndIf

Return

/*/{Protheus.doc} MCSVERIFICA
Verifica se o registros já existe na tabela de monitoramento
@type function
@version  
@author MCS Tecnologia
@since 5/1/2026
@return variant, return_description
/*/
Static Function MCSVERIF(xPref, xTitulo, xParcela, xTipo, xLoja, xCodCli, xDocumento, xSerie, xTipNota)

    Local lExist   := .F. 
    Local xAliDoc  := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local aArea    := GetArea(xAliDoc)

    (xAliDoc)->(DbSelectArea(xAliDoc))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica os tipos de nota                                           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xTipNota == '4'
        (xAliDoc)->(dbSetOrder(1))
        If (xAliDoc)->(dbSeek(xFilial(xAliDoc)+xPref+xTitulo+xParcela+xTipo+xCodCli+xLoja+xTipNota,.F.))
            lExist := .T.
            //U_MCSLOG("INFO","MCSVERIFICA","Encontrado registro na tabela: " + xAliDoc + " para o título: " + xPref + " " + xTitulo + " " + xParcela + " " + xTipo + " " + xLoja + " " + xCodCli + " " + xTipNota)
        EndIf 
    ElseIf xTipNota == '5'
        (xAliDoc)->(dbSetOrder(2))
        If (xAliDoc)->(dbSeek(xFilial(xAliDoc)+xDocumento+xSerie+xCodCli+xLoja,.F.))
            lExist := .T.
        EndIf
    EndIf

    FwRestArea(aArea)

Return lExist

/*/{Protheus.doc} User Function zExe228
Exibe uma mensagem no console.log do AppServer
@type Function
@author Atilio
@since 20/02/2023
@see https://tdn.totvs.com/display/public/framework/FWLogMsg
@obs 
*/
User Function MCSLOG(xInfo,xProg,xTxt)

    Local aArea     := FWGetArea()
 
    //Exibe a mensagem no Console.log
    FWLogMsg(;
        xInfo,;    //cSeverity      - Informe a severidade da mensagem de log. As opções possíveis são: INFO, WARN, ERROR, FATAL, DEBUG
        ,;          //cTransactionId - Informe o Id de identificação da transação para operações correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
        xProg,;     //cGroup         - Informe o Id do agrupador de mensagem de Log
        ,;          //cCategory      - Informe o Id da categoria da mensagem
        ,;          //cStep          - Informe o Id do passo da mensagem
        ,;          //cMsgId         - Informe o Id do código da mensagem
        xTxt,;      //cMessage       - Informe a mensagem de log. Limitada à 10K
        ,;          //nMensure       - Informe a uma unidade de medida da mensagem
        ,;          //nElapseTime    - Informe o tempo decorrido da transação
        ;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
    ) 
     
    FWRestArea(aArea)

Return

/*/{Protheus.doc} QryMulJur
Query para busca dos dados de multa e juros
@type function
@version  
@author rodri
@since 4/30/2026
@return variant, return_description
/*/
Static Function QryMulJur()

    Local xQuery := ""
    Local xAlias := ""

    xAlias := GetNextAlias()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Query principal para multa e juros, tipo 4                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery := "SELECT " + chr(13)
    xQuery += "    E1.E1_FILIAL      AS FILIAL, " + chr(13)
    xQuery += "    E1.E1_PREFIXO     AS PREFIXO, " + chr(13)
    xQuery += "    E1.E1_NUM         AS TITULO, " + chr(13)
    xQuery += "    E1.E1_PARCELA     AS PARCELA, " + chr(13)
    xQuery += "    E1.E1_TIPO        AS TIPO, " + chr(13)
    xQuery += "    E1.E1_CLIENTE     AS COD_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA        AS LOJA, " + chr(13)
    xQuery += "    D2.D2_DOC         AS DOCUMENTO, " + chr(13)
    xQuery += "    D2.D2_SERIE       AS SERIE, " + chr(13)
    xQuery += "    E1.E1_NOMCLI      AS NOME_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_EMISSAO     AS DT_EMISSAO, " + chr(13)
    xQuery += "    E1.E1_VENCTO      AS DT_VENCIMENTO, " + chr(13)
    xQuery += "    E1.E1_BAIXA       AS DT_BAIXA, " + chr(13)
    xQuery += "    E1.E1_VALOR       AS VALOR_TITULO, " + chr(13)
    xQuery += "    E1.E1_JUROS       AS VALOR_JUROS, " + chr(13)
    xQuery += "    COUNT(D2.D2_ITEM) AS QTDE_ITENS_SD2, " + chr(13)
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN ISNULL(MAX(D2.D2_IDTRIB),'') <> '' THEN 'S' " + chr(13)
    xQuery += "        ELSE 'N' " + chr(13)
    xQuery += "    END AS CALCULA_IBS_CBS, " + chr(13)
    xQuery += "    CASE " + chr(13) 
    xQuery += "        WHEN COUNT(D2.D2_ITEM) > 0 " + chr(13) 
    xQuery += "        THEN E1.E1_JUROS / COUNT(D2.D2_ITEM) " + chr(13)
    xQuery += "        ELSE 0 " + chr(13)
    xQuery += "    END AS VALOR_JUROS_POR_ITEM, " + chr(13)
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN MAX(CASE WHEN DKN.DKN_DOCREF IS NOT NULL THEN 1 ELSE 0 END) = 1 " + chr(13)
    xQuery += "        THEN 'S' " + chr(13)
    xQuery += "        ELSE 'N' " + chr(13)
    xQuery += "    END AS EXISTE_DKN, " + chr(13)
    xQuery += "    '4' AS TIPO_NOTA " + chr(13)
    xQuery += "FROM " +RetSqlName("SE1")+ " E1 " + chr(13)
    xQuery += "LEFT JOIN " +RetSqlName("SD2")+ " D2 " + chr(13)
    xQuery += "    ON  D2.D2_FILIAL  = E1.E1_FILIAL " + chr(13)
    xQuery += "    AND D2.D2_DOC     = E1.E1_NUM " + chr(13)
    xQuery += "    AND D2.D2_SERIE   = E1.E1_PREFIXO " + chr(13)
    xQuery += "    AND D2.D2_CLIENTE = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND D2.D2_LOJA    = E1.E1_LOJA " + chr(13)
    xQuery += "    AND D2.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " +RetSqlName("DKN")+ " DKN " + chr(13)
    xQuery += "    ON  DKN.DKN_FILIAL = E1.E1_FILIAL " + chr(13)
    xQuery += "    AND DKN.DKN_DOCREF = E1.E1_NUM " + chr(13)
    xQuery += "    AND DKN.DKN_SERREF = E1.E1_PREFIXO " + chr(13)
    xQuery += "    AND DKN.DKN_CLIFOR = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND DKN.DKN_LOJA   = E1.E1_LOJA " + chr(13)
    xQuery += "    AND DKN.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " +RetSqlName("SA1")+ " A1 " + chr(13)
    xQuery += "    ON  A1.A1_FILIAL  = '" +FwxFilial("SA1") + "' " + chr(13)
    xQuery += "    AND A1.A1_COD     = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND A1.A1_LOJA    = E1.E1_LOJA " + chr(13)
    xQuery += "WHERE  E1.E1_FILIAL  = '" +FwxFilial("SE1") + "' " + chr(13)
    /*xQuery += "  AND E1.E1_BAIXA BETWEEN '"+dTos(aPar[1])+"' AND '"+dTos(aPar[2])+"' " + chr(13)
    xQuery += "  AND E1.E1_CLIENTE BETWEEN '"+aPar[6]+"' AND '"+aPar[6]+"' " + chr(13)
    xQuery += "  AND E1.E1_LOJA    BETWEEN '"+aPar[7]+"' AND '"+aPar[7]+"' " + chr(13)*/
    xQuery += "  AND E1.E1_BAIXA BETWEEN '20250101' AND '20261230' " + chr(13)
    //xQuery += "  AND E1.E1_CLIENTE BETWEEN '"+aPar[6]+"' AND '"+aPar[6]+"' " + chr(13)
    //xQuery += "  AND E1.E1_LOJA    BETWEEN '"+aPar[7]+"' AND '"+aPar[7]+"' " + chr(13)   
    xQuery += "  AND ISNULL(E1.E1_JUROS,0) > 0 " + chr(13)
    xQuery += "  AND  E1.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "GROUP BY " + chr(13)
    xQuery += "    E1.E1_FILIAL, " + chr(13)
    xQuery += "    E1.E1_PREFIXO, " + chr(13)
    xQuery += "    E1.E1_NUM, " + chr(13)
    xQuery += "    E1.E1_PARCELA, " + chr(13)
    xQuery += "    E1.E1_TIPO, " + chr(13)
    xQuery += "    E1.E1_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA, " + chr(13)
    xQuery += "    D2.D2_DOC, " + chr(13)
    xQuery += "    D2.D2_SERIE, " + chr(13)
    xQuery += "    E1.E1_NOMCLI, " + chr(13)
    xQuery += "    E1.E1_EMISSAO, " + chr(13)
    xQuery += "    E1.E1_VENCTO, " + chr(13)
    xQuery += "    E1.E1_BAIXA, " + chr(13)
    xQuery += "    E1.E1_VALOR, " + chr(13)
    xQuery += "    E1.E1_JUROS " + chr(13)
    xQuery += "ORDER BY " + chr(13)
    xQuery += "    E1.E1_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA, " + chr(13)
    xQuery += "    E1.E1_NUM, " + chr(13)
    xQuery += "    E1.E1_PARCELA " + chr(13)

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias

/*/{Protheus.doc} QryNProc
Query par obtenção dos dados de nota não processada
@type function
@version  
@author MCS Tecnologia
@since 5/3/2026
@return variant, return_description
/*/
Static Function QryNProc()

    Local xQuery := ""
    Local xAlias := GetNextAlias()

    xQuery := "SELECT " + chr(13)
    xQuery += "    D2.D2_FILIAL   AS FILIAL, " + chr(13)
    xQuery += "    D2.D2_DOC      AS DOCUMENTO, " + chr(13)
    xQuery += "    D2.D2_SERIE    AS SERIE, " + chr(13)
    xQuery += "    D2.D2_CLIENTE  AS COD_CLIENTE, " + chr(13)
    xQuery += "    D2.D2_LOJA     AS LOJA, " + chr(13)
    xQuery += "    MIN(D2.D2_EMISSAO) AS DT_EMISSAO, " + chr(13)
    xQuery += "    SUM(D2.D2_TOTAL)   AS VALOR_TOTAL, " + chr(13)
    xQuery += "    COUNT(D2.D2_ITEM) AS QTDE_ITENS_SD2, " + chr(13)
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN ISNULL(MAX(D2.D2_IDTRIB), '') <> '' THEN 'SIM' " + chr(13)
    xQuery += "        ELSE 'NÃO' " + chr(13)
    xQuery += "    END AS CALCULA_IBS_CBS, " + chr(13)
    xQuery += "    SUM( " + chr(13)
    xQuery += "        ( " + chr(13)
    xQuery += "            ISNULL(D2.D2_TOTAL, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALFRE, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_SEGURO, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_DESPESA, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VLIMPOR, 0) " + chr(13)
    xQuery += "        ) " + chr(13)
    xQuery += "        - " + chr(13)
    xQuery += "        ( " + chr(13)
    xQuery += "            ISNULL(D2.D2_DESCON, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALIMP5, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALIMP6, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALICM, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_DIFAL, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALFECP, 0) " + chr(13)
    xQuery += "         -- + ISNULL(D2.D2_FCPDIF, 0) " + chr(13)
    xQuery += "          + ISNULL(D2.D2_VALISS, 0) " + chr(13)
    xQuery += "        ) " + chr(13)
    xQuery += "    ) AS BASE_IBS_CBS, " + chr(13)
    xQuery += "'5' AS TIPO_NOTA, "+ chr(13)
    xQuery += " A1.A1_NOME AS NOME_CLIENTE,"
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN MAX(CASE WHEN DKN.DKN_DOCREF IS NOT NULL THEN 1 ELSE 0 END) = 1 " + chr(13)
    xQuery += "        THEN 'S' " + chr(13)
    xQuery += "        ELSE 'N' " + chr(13)
    xQuery += "    END AS EXISTE_DKN " + chr(13)
    xQuery += "FROM " +RetSqlName("SD2")+ " D2 " + chr(13)
    xQuery += "INNER JOIN " +RetSqlName("SA1") + " A1 " + chr(13)
    xQuery += "ON D2.D2_CLIENTE = A1.A1_COD " + chr(13)
    xQuery += "AND D2.D2_LOJA = A1.A1_LOJA " + chr(13)
    xQuery += "AND A1.A1_FILIAL = '" + FWxFilial("SA1") + "' " + chr(13)
    xQuery += "LEFT JOIN " +RetSqlName("DKN")+ " DKN " + chr(13)
    xQuery += "    ON  DKN.DKN_FILIAL = D2.D2_FILIAL " + chr(13)
    xQuery += "    AND DKN.DKN_DOCREF = D2.D2_DOC " + chr(13)
    xQuery += "    AND DKN.DKN_SERREF = D2.D2_SERIE " + chr(13)
    xQuery += "    AND DKN.DKN_CLIFOR = D2.D2_CLIENTE " + chr(13)
    xQuery += "    AND DKN.DKN_LOJA   = D2.D2_LOJA " + chr(13)
    xQuery += "    AND DKN.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "WHERE D2.D2_FILIAL = '" +FwxFilial("SD2") + "' " + chr(13)
    xQuery += "  AND D2.D2_EMISSAO >= '20260101' " + chr(13)
    xQuery += "  AND D2.D2_IDTRIB = ' ' " + chr(13)
    xQuery += "  AND D2.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "  AND A1.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "GROUP BY " + chr(13)
    xQuery += "    D2.D2_FILIAL, " + chr(13)
    xQuery += "    D2.D2_DOC, " + chr(13)
    xQuery += "    D2.D2_SERIE, " + chr(13)
    xQuery += "    D2.D2_CLIENTE, " + chr(13)
    xQuery += "    D2.D2_LOJA, " + chr(13)
    xQuery += "    A1.A1_NOME " + chr(13)
    xQuery += "ORDER BY " + chr(13)
    xQuery += "    D2.D2_FILIAL, " + chr(13)
    xQuery += "    D2.D2_DOC, " + chr(13)
    xQuery += "    D2.D2_SERIE " + chr(13)

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias
