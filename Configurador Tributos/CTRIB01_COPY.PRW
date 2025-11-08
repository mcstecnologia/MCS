#Include 'Protheus.CH'

/*/{Protheus.doc} CTRIB01
Recebe os dados do PE ITEM e trata para gravar o execauto do perfil de produto;
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@return variant, return_description
/*/
User Function CTRIB01(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib)

    /*Local lMvcFacAuto   := .F.
    Local xParProd      := SuperGetMV("MV_CONFPP",.F.,"B1_POSIPI") //Parametro para automatizar conforme configuração do perfil, não usado ainda no fonte*/
    Local aArea         := SB1->(GetArea())
    Local aAreaA1       := SA1->(GetArea())
    Local aAreaA2       := SA2->(GetArea())
    Local lRet          := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Abrindo as tabelas                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SB1->(dbSelectArea("SB1"))
    SA1->(dbSelectArea("SA1"))
    SA2->(dbSelectArea("SA2"))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Setando os indices que vão utilizados                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    SA2->(dbSetOrder(1))
    SB1->(dbSetOrder(1))
    SA1->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se o NCM ou o Grupo tributário estver preenchido e as rotinas estiverem na pilha ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ( (!Empty(xPosIpi) .And. IsInCallStack('MATA010')) ) .Or. ( (!Empty(xGrpTrib) .And. IsInCallStack('MATA020')) .Or. IsInCallStack('U_CRMA980') )

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Busca um registro de cada perfil para comparação, verificando se é fornecedor, cliente ou produto ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        xAlias := fGetPerfil(Iif(IsInCallStack('MATA020'),'1','2'),Iif(IsInCallStack('MATA010'), 'PROD', ''))

        (xAlias)->(dbGoTop())

        While !(xAlias)->(Eof())

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verificando se a MATA010, senão segue para verificar se é cli ou for³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
            If IsInCallStack('MATA010')
                If SB1->(dbSeek(xFilial("SB1") + (xAlias)->F24_CDPROD,.F.))
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Se o NCM do produto inserido for igual ao do produto pesquisado, grava ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If AllTrim(SB1->B1_POSIPI) == AllTrim(xPosIpi)
                        lRet := fExecAutoFCA("","",(xAlias)->F24_CODIGO,(xAlias)->F24_TIPOPF,"",xProd,4)
                    EndIf

                EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verificando se a MATA020 está na pilha de chamada, senão é CRMA980  ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
            ElseIf IsInCallStack('MATA020')
                If SA2->(dbSeek(xFilial("SA2") + (xAlias)->F22_CLIFOR + (xAlias)->F22_LOJA,.F.))
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Veririca se o grupo do fornecedor que foi cadastrado é igual ao que foi pesquisado ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If AllTrim(SA2->A2_GRPTRIB) == AllTrim(xGrpTrib)
                        lRet := fExecAutoFCA(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'1',"",4)
                    EndIf
                EndIf
            Else 
                If SA1->(dbSeek(xFilial("SA1") + (xAlias)->F22_CLIFOR + (xAlias)->F22_LOJA,.F.))
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Veririca se o grupo do cliente que foi cadastrado é igual ao que foi pesquisado      ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If AllTrim(SA1->A1_GRPTRIB) == AllTrim(xGrpTrib)
                        lRet := fExecAutoFCA(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'2',"",4)
                    EndIf

                EndIf
            EndIf

        (xAlias)->(dbSkip())          
        EndDo

    Else 
        Conout("Grupo de cliente/fornecedor ou NCM em branco, verifique")
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Caso esteja habilitado o FwLogMsg no appserver                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
        U_fConout("Grupo de cliente/fornecedor ou NCM em branco, verifique")
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava o log, caso não gravar o registros                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !lRet
        Conout("Registros não inseridos, verifique perfil")     
        U_fConout("Registros não inseridos, verifique perfil")
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fechando areas abertas                                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    (xAlias)->(dbCloseArea())

    RestArea(aArea)
    RestArea(aAreaA1)
    RestArea(aAreaA2)

Return

/*/{Protheus.doc} fGetF24
Busca os registros da F24
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@return variant, return_description
/*/
Static Function fGetPerfil(xTpPart,xProd)

    Local xAlias := GetNextAlias()
    Local xQuery := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se vier da MATA010, trata a tabela do perfil de produto             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xProd == 'PROD'
        xQuery := " SELECT" + chr(13)
        xQuery += " F24_CODIGO," + chr(13)
        xQuery += " F24_CDPROD," + chr(13)
        xQuery += " F24_TIPOPF" + chr(13)
        xQuery += " FROM (" + chr(13)
        xQuery += "    SELECT" + chr(13)
        xQuery += "    F24_CODIGO," + chr(13)
        xQuery += "    F24_CDPROD," + chr(13)
        xQuery += "    F24_TIPOPF," + chr(13)
        xQuery += "    ROW_NUMBER() OVER (PARTITION BY F24_CODIGO ORDER BY F24_CDPROD) AS RN" + chr(13)
        xQuery += " FROM " + RetSqlName("F24") + "" + chr(13)
        xQuery += " WHERE D_E_L_E_T_ = ' '" + chr(13)
        xQuery += " ) AS A" + chr(13)
        xQuery += " WHERE RN = 1"
    Else 
        xQuery := " SELECT" + chr(13)
        xQuery += " F22_CODIGO," + chr(13)
        xQuery += " F22_CLIFOR," + chr(13)
        xQuery += " F22_LOJA," + chr(13)
        xQuery += " F22_TPPART," + chr(13)
        xQuery += " F22_TIPOPF" + chr(13)
        xQuery += " FROM (" + chr(13)
        xQuery += "    SELECT" + chr(13)
        xQuery += "    F22_CODIGO," + chr(13)
        xQuery += "    F22_CLIFOR," + chr(13)
        xQuery += "    F22_LOJA," + chr(13)
        xQuery += "    F22_TPPART," + chr(13)
        xQuery += "    F22_TIPOPF," + chr(13)
        xQuery += "    ROW_NUMBER() OVER (PARTITION BY F22_CODIGO ORDER BY F22_CLIFOR) AS RN" + chr(13)
        xQuery += " FROM " + RetSqlName("F22") + "" + chr(13)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verificando se é fornecedor ou cliente, para tratar codigos iguais  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpPart == '1'
            xQuery += " WHERE F22_TPPART = '1'" + chr(13)
        Else 
            xQuery += " WHERE F22_TPPART = '2'" + chr(13)
        EndIf 
        xQuery += " AND D_E_L_E_T_ = ' '" + chr(13)
        xQuery += " ) AS A" + chr(13)
        xQuery += " WHERE RN = 1"
    EndIf

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias

/*/{Protheus.doc} fExecAutoFCA
Execauto para gravação do perfil de produto
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@param xCodPro, variant, param_description
@param xCodPer, variant, param_description
@return variant, return_description
/*/
Static Function fExecAutoFCA(xClieFor,xLoja,xCodPer,xTipOpf,xTpPart,xCodPro,xOp)

    Local oModel as object
    Local lOk := .F.
    Local aArea := F20->(GetArea())

    F20->(dbSelectArea("F20"))
    F20->(dbSetOrder(1))

    If F20->(MsSeek(xFilial("F20") + xCodPer + xTipOpf))
 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega o modelo                                                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Empty(xClieFor)
            oModel := FwLoadModel("FISA166") 
        Else 
            oModel := FwLoadModel("FISA164") 
        EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Apenas na alteração                                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oModel:SetOperation(4)
        oModel:Activate() // ativo o modelo
    
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Adiciona os registros                                               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Empty(xClieFor)
            oModel:GetModel("FISA166PRODUTO"):AddLine()
            oModel:SetValue("FISA166PRODUTO", "F24_FILIAL", FwCodFil())
            oModel:SetValue("FISA166PRODUTO", "F24_CODIGO", xCodPer)
            oModel:SetValue("FISA166PRODUTO", "F24_CDPROD", xCodPro)
            oModel:SetValue("FISA166PRODUTO", "F24_TIPOPF", xTipOpf)
        Else 
            oModel:GetModel("FISA164PARTICIPANTE"):AddLine()
            oModel:SetValue("FISA164PARTICIPANTE", "F22_CODIGO", xCodPer)
            oModel:SetValue("FISA164PARTICIPANTE", "F22_TPPART", xTpPart)
            oModel:SetValue("FISA164PARTICIPANTE", "F22_CLIFOR", xClieFor)
            oModel:SetValue("FISA164PARTICIPANTE", "F22_LOJA", xLoja)
            oModel:SetValue("FISA164PARTICIPANTE", "F22_TIPOPF", xTipOpf)
        EndIf
    
        If oModel:VldData()
            oModel:CommitData()
            lOk := .T.
            If Empty(xClieFor)
                Conout("Produto " + xCodPro + " inserido no perfil " + xCodPer )
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Grava log com o registro gerado no rootpath                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                U_fLogCtrb(xCodPer, xCodPro, "", "","Perfil Produto")
            Else 
                Conout("Cliente " + AllTrim(xClieFor) + " loja " + AllTrim(xLoja) + " inserido no perfil " + AllTrim(xCodPer) )
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Grava log com o registro gerado no rootpath                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                U_fLogCtrb(xCodPer, "", xClieFor, xLoja,"Perfil CLiente-Fornecedor")
            EndIf
        Else
            VarInfo("",oModel:GetErrorMessage())
        EndIf
    
        oModel:DeActivate()

    EndIf

    RestArea(aArea)

Return lOk

/*/{Protheus.doc} fConout
Gera os logs no appserver
@type function
@version  
@author MCS Consultoria
@since 1/23/2025
@param cTexto, character, param_description
@return variant, return_description
/*/
User Function fConout(cTexto)

    Local aArea    := GetArea()
    Default cTexto := ""
     
    FWLogMsg(;
        "INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As opções possíveis são: INFO, WARN, ERROR, FATAL, DEBUG
        ,;          //cTransactionId - Informe o Id de identificação da transação para operações correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
        "GRVPERFILPROD",; //cGroup         - Informe o Id do agrupador de mensagem de Log
        ,;          //cCategory      - Informe o Id da categoria da mensagem
        ,;          //cStep          - Informe o Id do passo da mensagem
        ,;          //cMsgId         - Informe o Id do código da mensagem
        cTexto,;    //cMessage       - Informe a mensagem de log. Limitada à 10K
        ,;          //nMensure       - Informe a uma unidade de medida da mensagem
        ,;          //nElapseTime    - Informe o tempo decorrido da transação
        ;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
    ) 
     
    RestArea(aArea)
    
Return

/*/{Protheus.doc} 
Grava o log para analise dos testes
@type function
@version  
@author MCS Consultoria
@since 3/5/2024
@return variant, return_description
/*/
User Function fLogCtrb(xPerfil,xProd,xClieFor,xLoja,xProg)

    Local cTime     
    Local cData     
    Local xPasta     
    Local xLog   
    Local nPathEr   

    cTime     := Replace(Time(),":","")
    cData     := dtos(dDataBase)
    xPasta    := "\Logs\MCS\CTRIB01\"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verificando se existe a pasta criada no protheus_data               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    If !ExistDir(xPasta)
        MakeDir(xPasta)
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criando arquivo                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    xLog := xProg+"_"+cData+"_"+cTime+".txt"
    nPathEr := FCreate(xPasta+Upper(xLog))

    If nPathEr < 0
		conout("Erro durante criação do arquivo.")
	Else 
        FWrite(nPathEr, "Gravação efetuada do perfil:" +xPerfil+ " do registro : " +Iif(Empty(xClieFor), "Produto: " +xProd, "CliFor: " +xClieFor+"||"+xLoja))
    EndIf
    FClose(nPathEr) 
        
Return
