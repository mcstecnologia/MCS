#Include 'Protheus.CH'
#include "AP5MAIL.CH""

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
    lParAnt   := SuperGetMV("XX_ATVNANT",.F.,.F.)

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
            fGrvMonit(xAlias,'3')
        Else 
            (xAlias)->(dbCloseArea())
        EndIf
    EndIf

    If lParAnt
        xAlias := QryAntec()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se há registros encontrados                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(xAlias)->(Eof())
            fGrvMonit(xAlias,'6')
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
    Local nItens    := 0
    Local lMail     := SuperGetMV("XX_ATVMAIL",.F.,.F.)
    Local aRegs     := {}
    Local xIdFK7    := ""

    aArea := &(xAliDoc+"->"+"(GetArea())")

    While !(xAlias)->(Eof())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se o registro já existe                         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpNota == '4'
            lRet := MCSVERIF((xAlias)->PREFIXO, (xAlias)->TITULO, (xAlias)->PARCELA, (xAlias)->TIPO, (xAlias)->LOJA, (xAlias)->COD_CLIENTE, (xAlias)->DOCUMENTO, (xAlias)->SERIE, (xAlias)->TIPO_NOTA)
        ElseIf xTpNota == '3'
            lRet := MCSVERIF("","","","",(xAlias)->LOJA, (xAlias)->COD_CLIENTE, (xAlias)->DOCUMENTO, (xAlias)->SERIE, (xAlias)->TIPO_NOTA)
        ElseIf xTpNota == '6'
            lRet := MCSVERIF("","","","","","","","","",(xAlias)->IDDOC)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Executa o reclock - executando em macro &                          ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        xDoc := GetSx8Num(xAliDoc,xAliDoc+"_ID")

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Implementado - Pois pode ser que o valor seja menor que 0.01        ³ //futuro
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpNota == '4'
            If (xAlias)->VALOR_JUROS / (xAlias)->QTDE_ITENS_SD2 < 0.01 
                nItens := (xAlias)->VALOR_JUROS / 0.01
            EndIf
        EndIf

        Begin Transaction

            If !lRet
                RecLock(xAliDoc, .T.)
                    &(xAliDoc+"->"+xAliDoc+"_FILIAL")   := FWxFilial(xAliDoc)
                    &(xAliDoc+"->"+xAliDoc+"_ID")       := xDoc
                    &(xAliDoc+"->"+xAliDoc+"_PREF")     := Iif(xTpNota == '4',(xAlias)->PREFIXO,'')
                    &(xAliDoc+"->"+xAliDoc+"_NUMTIT")   := Iif(xTpNota $ '4/6',(xAlias)->TITULO,'')
                    &(xAliDoc+"->"+xAliDoc+"_PARCEL")   := Iif(xTpNota == '4',(xAlias)->PARCELA,'')
                    &(xAliDoc+"->"+xAliDoc+"_TIPO")     := Iif(xTpNota $ '4/6',(xAlias)->TIPO,'')
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
                    &(xAliDoc+"->"+xAliDoc+"_QTDIT")    := Iif(xTpNota $ '4/5',(xAlias)->QTDE_ITENS_SD2,0)
                    &(xAliDoc+"->"+xAliDoc+"_IBSCBS")   := Iif(xTpNota $ '4/5',(xAlias)->CALCULA_IBS_CBS,0)
                    //&(xAliDoc+"->"+xAliDoc+"_JURITE")   := Iif(xTpNota == '4',(xAlias)->VALOR_JUROS / (xAlias)->QTDE_ITENS_SD2,0)
                    &(xAliDoc+"->"+xAliDoc+"_DKN")      := Iif(xTpNota $ '4/5',(xAlias)->EXISTE_DKN,'N')
                    &(xAliDoc+"->"+xAliDoc+"_TPNOTA")   := (xAlias)->TIPO_NOTA
                    &(xAliDoc+"->"+xAliDoc+"_NFEOK")    := Iif((xAlias)->EXISTE_DKN == 'S',"S","N")
                    &(xAliDoc+"->"+xAliDoc+"_BASECI")   := Iif(xTpNota == '5',(xAlias)->BASE_IBS_CBS,0)
                    &(xAliDoc+"->"+xAliDoc+"_SLDFIE")   := Iif(xTpNota == '6',(xAlias)->SALDO,0)

                &(xAliDoc+"->"+"(MsUnlock())")
                ConfirmSx8()

                aadd(aRegs,{(xAlias)->TIPO_NOTA,AllTrim((xAlias)->COD_CLIENTE),AllTrim((xAlias)->LOJA),AllTrim((xAlias)->NOME_CLIENTE),;
                     xDoc})

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Indica se gera nota automaticamente, gero individualmente           ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If lGeraNF .And. (xTpNota == '4' .Or. xTpNota == '5')
                    U_MCSGERA((xAlias)->DOCUMENTO,(xAlias)->SERIE,AllTrim((xAlias)->COD_CLIENTE),AllTrim((xAlias)->LOJA),(xAlias)->TIPO_NOTA,Iif(xTpNota == '4',&(xAliDoc+"->"+xAliDoc+"_JURITE"),0))
                EndIf
                    
            EndIf

        End Transaction

        (xAlias)->(dbSkip())

    EndDo
    
    //U_MCSLOG("INFO","MCSJOB","Execução da rotina de gravação da: " + xAliDoc)
    Conout("Execução ok ")
            
    RestArea(aArea)

    (xAlias)->(dbCloseArea())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Envia ou não email com informação de registros gerados              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lMail .And. Len(aRegs) > 0 .And. !lGeraNF
         U_MCSMAIL(xTpNota, aRegs)
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
Static Function MCSVERIF(xPref, xTitulo, xParcela, xTipo, xLoja, xCodCli, xDocumento, xSerie, xTipNota, xIdDoc)

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
    ElseIf xTipNota == '3'
        (xAliDoc)->(dbSetOrder(2))
        If (xAliDoc)->(dbSeek(xFilial(xAliDoc)+xDocumento+xSerie+xCodCli+xLoja,.F.))
            lExist := .T.
        EndIf
    ElseIf xTipNota == '6'
        (xAliDoc)->(dbSetOrder(5))
        If (xAliDoc)->(dbSeek(xFilial(xAliDoc)+xIdDoc,.F.))
            lExist := .T.
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

    Local xQuery    := ""
    Local xAlias    := ""
    Local xSerie    := SuperGetMV("MV_NDCSERI",.F.,"9")

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
    xQuery += "    AND D2.D2_SERIE <> ' " +AllTrim(xSerie)+" ' "  + chr(13)
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
    Local xSerie := SuperGetMV("MV_NDCSERI",.F.,"9")

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
    xQuery += "'3' AS TIPO_NOTA, "+ chr(13)
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
    xQuery += "  AND D2.D2_SERIE <> '" +AllTrim(xSerie)+"' "  + chr(13)
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


/*/{Protheus.doc} QryAntec
Retorna os pedidos com condição de pagamento antecipado
@type function
@version  
@author MCS Tecnologia
@since 6/8/2026
@return variant, return_description
/*/
Static Function QryAntec()

    Local xQuery := ""
    Local xAlias := GetNextAlias()

    xQuery := "SELECT C5_FILIAL, C5_NUM AS DOCUMENTO, C5_CLIENTE AS COD_CLIENTE, C5_LOJACLI AS LOJA, A1.A1_NOME AS NOME_CLIENTE, C5_EMISSAO AS DT_EMISSAO, " + chr(13)
    xQuery += "'6' AS TIPO_NOTA, 'N' AS EXISTE_DKN, FIE_NUM AS TITULO, FIE_TIPO AS TIPO, FIE_SALDO AS SALDO, FIE_VALOR AS VALOR_TOTAL " + chr(13)
    xQuery += "FROM " + RetSqlName("SC5") + " C5 " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 " + chr(13)
    xQuery += "ON E4_CODIGO = C5_CONDPAG " + chr(13)
    xQuery += "AND E4_FILIAL = '" + FwxFilial("SE4") + "' " + chr(13)
    xQuery += "AND E4_CTRADT = '1' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SA1") + " A1 " + chr(13)
    xQuery += "ON A1.A1_COD = C5_CLIENTE " + chr(13)
    xQuery += "AND A1.A1_LOJA = C5_LOJACLI " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("FIE") + " FIE " + chr(13)
    xQuery += "ON FIE.FIE_FILIAL = C5_FILIAL " + chr(13)
    xQuery += "AND FIE.FIE_PEDIDO = C5_NUM " + chr(13)
    xQuery += "AND FIE_CLIENTE = C5_CLIENTE " + chr(13)
    xQuery += "AND FIE_LOJA = C5_LOJACLI " + chr(13)
    xQuery += "WHERE C5_FILIAL = '" + FwxFilial("SC5") + "' " + chr(13)
    xQuery += "AND C5.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "AND SE4.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "AND A1.D_E_L_E_T_ = ' ' " + chr(13)

    MpSysOpenQuery(xQuery,xAlias)

Return xAlias

/*/{Protheus.doc} MCSMAIL
Envia email informado da geração das notas de débito
@type function
@version  
@author Mcs tecnologia
@since 6/5/2026
@param xTipo, variant, param_description
@param aRegs, array, param_description
@return variant, return_description
/*/
User Function MCSMAIL(xTipo, aRegs)

    Local lResulConn := .T.
	Local lResulSend := .T.
	Local cError 	 := ""
	Local lResult 	 := .T.
	Local xServer 	 := AllTrim(SuperGetMV("MV_RELSERV",.F.,"smtp.hostinger.com:465"))
	Local xEmail 	 := AllTrim(SuperGetMV("MV_RELACNT",.F.,"rodrigo@mcstecno.com"))   //EMAIL PADRAO ENVIO DE EMAIL - CRIAR PARAMETRO 	- MV_MAILCOB
	Local xPara		 := SuperGetMV("MV_MAILPR",.F.,"rodrigo@mcstecno.com;rgiesau@gmail.com")
	Local xPass  	 := AllTrim(SuperGetMV("MV_RELPSW",.F.,"Rodrigo_2025"))    //SENHA DO NOVO EMAIL FINANCEIRO - CRIAR PARAMETRO -
	Local lRelauth   := SuperGetMV("MV_RELAUTH",.F.,.T.)
	Local xDe 		 := xEmail
	Local xCc 		 := ""
    Local xAssunto 	 := "MCSJOB - Notificação de Geração de Nota de Débito"
    Local nRegs      := 0
    Local xHtml      := ""

    xPara := StrTran(xPara,",",";")
	xPara := ALLTRIM(LOWER(xPara))

    xHtml := "<!DOCTYPE html> " + chr(13)
    xHtml += "<html lang='pt-BR'> " + chr(13)
    xHtml += "<head> " + chr(13)
    xHtml += "    <meta charset='UTF-8'> " + chr(13)
    xHtml += "    <title>Notificação de Nota de Débito</title> " + chr(13)
    xHtml += "</head> " + chr(13)
    xHtml += "<body style='margin:0; padding:0; background-color:#f4f4f4; font-family:Arial, Helvetica, sans-serif;'> " + chr(13)
    xHtml += "    <table width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:#f4f4f4; padding:20px;'> " + chr(13)
    xHtml += "        <tr> " + chr(13)
    xHtml += "            <td align='center'> " + chr(13)
    xHtml += "                <table width='600' cellpadding='0' cellspacing='0' border='0' style='background-color:#ffffff; border:1px solid #dddddd; border-radius:5px;'> " + chr(13)                  
    xHtml += "                    <tr> " + chr(13)
    xHtml += "                        <td style='background-color:#003366; color:#ffffff; padding:20px; text-align:center;'> " + chr(13)
    xHtml += "                            <h2 style='margin:0;'>Notificação de Nota de Débito</h2> " + chr(13)
    xHtml += "                        </td> " + chr(13)
    xHtml += "                    </tr> " + chr(13)
    xHtml += "                    <tr> " + chr(13)
    xHtml += "                        <td style='padding:30px;'> " + chr(13)
    xHtml += "                            <p style='font-size:14px; color:#333333;'> Foram identificados registros de Nota de Débito gerados automaticamente pelo processo MCSJOB. Seguem os detalhes do documento:</p> " + chr(13)
    xHtml += "                            <table width='100%' cellpadding='8' cellspacing='0' border='0' style='border-collapse:collapse;'> " + chr(13)   
    For nRegs := 1 to Len(aRegs)
        xHtml += "								<tr> " + chr(13)
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										Tipo de Nota: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ aRegs[nRegs][1] +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
        xHtml += "								<tr> " + chr(13)
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										Cliente: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ aRegs[nRegs][2] +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
        xHtml += "								<tr> " + chr(13) 
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										Loja: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ aRegs[nRegs][3] +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
        xHtml += "								<tr> " + chr(13)
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										Nome Cliente: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ aRegs[nRegs][4] +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
        xHtml += "								<tr> " + chr(13)
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										ID: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ aRegs[nRegs][5] +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
        xHtml += "								<tr> " + chr(13)
        xHtml += "									<td style='font-weight:bold; border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										Data: " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "									<td style='border-bottom:1px solid #eeeeee;'> " + chr(13)
        xHtml += "										"+ dToc(dDataBase) +" " + chr(13)
        xHtml += "									</td> " + chr(13)
        xHtml += "								</tr> " + chr(13)
    Next nRegs
    xHtml += "                            </table> " + chr(13)
    xHtml += "                            <p style='margin-top:30px; font-size:14px; color:#333333;'> " + chr(13)
    xHtml += "                                Registro gerado automaticamente pelo processo <strong>MCSJOB</strong>. " + chr(13)
    xHtml += "                            </p> " + chr(13)
    xHtml += "                        </td> " + chr(13)
    xHtml += "                    </tr> " + chr(13)
    xHtml += "                    <tr> " + chr(13)
    xHtml += "                        <td style='background-color:#f8f8f8; padding:15px; text-align:center; font-size:12px; color:#666666;'> " + chr(13)
    xHtml += "                            Este é um e-mail automático. Não responda esta mensagem. " + chr(13)
    xHtml += "                        </td>  " + chr(13)
    xHtml += "                    </tr> " + chr(13)
    xHtml += "                </table> " + chr(13)
    xHtml += "            </td> " + chr(13)
    xHtml += "        </tr> " + chr(13)
    xHtml += "    </table> " + chr(13)
    xHtml += "</body> " + chr(13)
    xHtml += "</html> " + chr(13)

    CONOUT("MAIL")

    CONNECT SMTP SERVER xServer ACCOUNT xEmail PASSWORD xPass RESULT lResulConn
		
	If !lResulConn
		GET MAIL ERROR cError
		If IsBlind()
			ConOut(Padc("Falha na conexao "+cError,80))
		Else
			ConOut("Falha na conexao "+cError)
		Endif
		Return(.F.)
	Endif
		
	If lRelauth
		lResult := MailAuth(Alltrim(xEmail), Alltrim(xPass))
		If !lResult
			nA := At("@",xEmail)
			cUser := If(nA>0,Subs(xEmail,1,nA-1),xEmail)
			lResult := MailAuth(Alltrim(cUser), Alltrim(xPass))
		Endif
	Endif
		
	If lResult
		SEND MAIL FROM xDe TO xPara CC xCc SUBJECT xAssunto BODY  xHtml ATTACHMENT  RESULT lResulSend
		If !lResulSend
			GET MAIL ERROR cError
			If IsBlind()
				ConOut(Padc("Falha no Envio do e-mail "+cError,80))
			Else
			    ConOut("Falha no Envio do e-mail " + cError)
			Endif
		Endif
	Else
		If IsBlind()
			ConOut(Padc("Falha na autenticação do e-mail: "+cError,80))
		Else
			ConOut("Falha na autenticação do e-mail:" + cError)
		Endif
	Endif
		
	DISCONNECT SMTP SERVER
		
	IF lResulSend
		If IsBlind()
			ConOut(Padc("E-mail enviado com sucesso",80))
		Else
			ConOut("E-mail com erro: " + cError)
		Endif
	ENDIF

Return
