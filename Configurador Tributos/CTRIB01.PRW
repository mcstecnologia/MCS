#Include 'Protheus.CH'

/*/{Protheus.doc} CTRIB01
Recebe os dados do PE ITEM e trata para gravar o execauto do perfil de produto;
@type function
@version  
@author MCS Tecnologia
@since 11/4/2025
@return variant, return_description
/*/
User Function CTRIB01(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xOrig)

    /*Local lMvcFacAuto   := .F. //MV_FACAUTO*/
    Local xParProd      := SuperGetMV("MV_CONFPP",.F.,"B1_POSIPI") //Parametro para automatizar conforme configuração do perfil, não usado ainda no fonte*/
    Local lRet          := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se o NCM ou o Grupo tributário estver preenchido e as rotinas estiverem na pilha ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ( (!Empty(xPosIpi) .And. IsInCallStack('MATA010')) ) .Or. ( (!Empty(xGrpTrib) .And. IsInCallStack('MATA020')) .Or. IsInCallStack('U_CRMA980') )

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Se vier se uma alteração, verifica em qual perfil se encontra o registro  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xOper == 4 .And. xPosIpi <> xOrig .Or. xGrpTrib <> xOrig
            lRet := fAlteraConf(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,Iif(IsInCallStack('MATA020'),'1','2'))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se ocorrer erro na exclusão, retorno ao registrio anterior nas tabelas principais ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If !lRet
                If !Empty(xProd)
                    fGravaSB1(xProd,xOrig)
                ElseIf IsInCallStack('MATA020')
                    fGravaSA2(xClieFor,xLoja,xOrig)
                Else  
                    fGravaSA1(xClieFor,xLoja,xOrig)
                EndIF
            EndIf
        Else
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
                    lRet := fValidaDados('MATA010','', '','','',(xAlias)->F24_CODIGO, (xAlias)->F24_TIPOPF,'',(xAlias)->F24_CDPROD,xProd,4,'',xPosIpi)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Verificando se a MATA020 está na pilha de chamada, senão é CRMA980  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
                ElseIf IsInCallStack('MATA020')
                    lRet := fValidaDados('MATA020',(xAlias)->F22_CLIFOR, (xAlias)->F22_LOJA,xClieFor,xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'1','','',4,xGrpTrib,'')
                Else 
                    lRet := fValidaDados('CRMA980',(xAlias)->F22_CLIFOR, (xAlias)->F22_LOJA,xClieFor,xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'2','','',4,xGrpTrib,'')
                EndIf

            (xAlias)->(dbSkip())          
            EndDo
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Fechando areas abertas                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            (xAlias)->(dbCloseArea())

        EndIf

    Else 
        Conout("Grupo de cliente/fornecedor ou NCM em branco, verifique")
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava o log, caso não gravar o registros                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !lRet
        Conout("Registros não inseridos, verifique perfil")     
    EndIf

Return lRet

/*/{Protheus.doc} fGetF24
Busca os registros da F24
@type function
@version  
@author MCS Tecnologia
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
        xQuery += " WHERE F24_FILIAL = '" + FwxFilial("F24") + "'" + chr(13)
        xQuery += " AND D_E_L_E_T_ = ' '" + chr(13)
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
        xQuery += " WHERE F22_FILIAL = '" + FwxFilial("F22") + "'" + chr(13)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verificando se é fornecedor ou cliente, para tratar codigos iguais  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpPart == '1'
            xQuery += " AND F22_TPPART = '1'" + chr(13)
        Else 
            xQuery += " AND F22_TPPART = '2'" + chr(13)
        EndIf 
        xQuery += " AND F22_LOJA <> 'ZZ' " + chr(13)
        xQuery += " AND D_E_L_E_T_ = ' '" + chr(13)
        xQuery += " ) AS A" + chr(13)
        xQuery += " WHERE RN = 1"
    EndIf

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias

/*/{Protheus.doc} fExecAutoConf
Execauto para gravação do perfil de produto
@type function
@version  
@author MCS Tecnologia
@since 11/4/2025
@param xCodPro, variant, param_description
@param xCodPer, variant, param_description
@return variant, return_description
/*/
Static Function fExecAutoConf(xClieFor,xLoja,xCodPer,xTipOpf,xTpPart,xCodPro,nOp)

    Local oModel as object
    Local lOk       := .F.
    Local aArea     := F20->(GetArea())
    LOcal aAreaF22  := F22->(GetArea())
    Local aAreaF24  := F24->(GetArea())
    Local xCod      := ""
    Local lPar      := SuperGetMV("ZZ_TABCTRL",.F.,.T.) // parametro que ativa ou não a gravação da tabela de controle
    Local aFields   := {}

    If nOp == 4

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
            oModel:SetOperation(nOp)
            oModel:Activate() // ativo o modelo
        
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Adiciona os registros                                               ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If Empty(xClieFor)
                    xTpPart := '3'
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
                        Conout("Produto " + xCodPro + " inserido no perfil " + xCodPer +" - "+ F20->F20_DESC )
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava log com o registro gerado no rootpath                         ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        U_fLogCtrb(xCodPer +"-"+F20->F20_DESC, xCodPro, "", "","Perfil Produto","Registro Incluído")
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava o registro na tabela de conferencia                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lPar
                            fGravaZZZ(xCodPer,xCodPro,'3','1',"Registro Incluído", F20->F20_DESC)
                        EndIf
                    Else 
                        Conout("Cliente " + AllTrim(xClieFor) + " loja " + AllTrim(xLoja) + " inserido no perfil " + AllTrim(xCodPer) )
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava log com o registro gerado no rootpath                         ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        U_fLogCtrb(xCodPer +"-"+F20->F20_DESC, "", xClieFor, xLoja,"Perfil CLiente-Fornecedor","Registro Incluído")
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava o registro na tabela de conferencia                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lPar 
                            fGravaZZZ(xCodPer,xClieFor+xLoja,xTpPart,'1',"Registro Incluído",F20->F20_DESC)
                        EndIf
                    EndIf
                Else
                    //VarInfo("",oModel:GetErrorMessage())
                    xCod := Iif(xTpPart == '3',xCodPro,xClieFor+xLoja)
                    If lPar
                        fGravaZZZ(xCodPer,xCodPro,xTpPart,'2',"Registro não gravado, verificar perfil",F20->F20_DESC)
                    EndIf
                EndIf

        EndIf

        oModel:DeActivate()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Processo de exclusão                                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Else 

        If Empty(xClieFor) 

            F24->(dbSelectArea("F24"))
            F24->(dbSetOrder(1))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Conforme fonte FISA171 a deleção é via reclock                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If F24->(MsSeek(xFilial("F24") + xCodPer + xCodPro))
                RecLock("F24",.F.)
                    F24->(dbDelete())
                    MsUnLock()
                F24->(FkCommit())
                lOk := .T. 
            EndIf

        Else 

            F22->(dbSelectArea("F22"))
            F22->(dbSetOrder(1))

            If F22->(MsSeek(xFilial("F22") + xCodPer + xTpPart + xClieFor + xLoja))
                RecLock("F22",.F.)
                    F22->(dbDelete())
                    MsUnLock()
                F22->(FkCommit())
                lOk := .T. 
            EndIf

        EndIf

    EndIf

    RestArea(aAreaF22)
    RestArea(aAreaF24)
    RestArea(aArea)

Return lOk

/*/{Protheus.doc} 
Grava o log para analise dos testes
@type function
@version  
@author MCS Tecnologia
@since 3/5/2024
@return variant, return_description
/*/
User Function fLogCtrb(xPerfil,xProd,xClieFor,xLoja,xProg,xMessage)

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
        FWrite(nPathEr, "Gravação efetuada do perfil:" +xPerfil+ " do registro : " +Iif(Empty(xClieFor), "Produto: " +xProd, "CliFor: " +xClieFor+"||"+xLoja+"||"+xMessage))
    EndIf
    FClose(nPathEr) 
        
Return

/*/{Protheus.doc} fAlteraConf
Faz a deleção e a alteração dos registros nos perfis
@type function
@version  
@author MCS Tecnologia
@since 11/5/2025
@param xProd, variant, param_description
@param xPosIpi, variant, param_description
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xGrpTrib, variant, param_description
@return variant, return_description
/*/
Static Function fAlteraConf(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xTpPart)

    Local lRet := .T.
    Local lPar := SuperGetMV("ZZ_TABCTRL",.F.,.T.) // parametro que ativa ou não a gravação da tabela de controle

    Default xTpPart := ""

    xAlias := fQueryAltera(xProd, xClieFor, xLoja, xTpPart)

    (xAlias)->(dbGoTop())

    While !(xAlias)->(Eof())

        If IsInCallStack('MATA010')
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Faz a exclusão do produto no perfil encontrado                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lRet := fExecAutoConf("","",(xAlias)->F24_CODIGO, (xAlias)->F24_TIPOPF,"",xProd,5)
            If lRet 
                U_fLogCtrb((xAlias)->F24_CODIGO, xProd, "", "","Perfil Produto","Registro Excluído")
            EndIf
            If lPar
                If lRet
                    fGravaZZZ((xAlias)->F24_CODIGO,xProd,'3','1',"Registro excluído")
                EndIf
            EndIf
            If lRet
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Excluído com sucesso, chama função para buscar o novo perfil        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                xAliasPer := fGetPerfil("","PROD")
                While !(xAliasPer)->(Eof())
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Faz a gravação do registro no novo perfil e grava tabela controle   ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
                    lRet := fValidaDados('MATA010','', '','','',(xAliasPer)->F24_CODIGO, (xAliasPer)->F24_TIPOPF,'',(xAliasPer)->F24_CDPROD,xProd,4,'',xPosIpi)      
                    If lPar
                        /*If lRet
                            fGravaZZZ((xAliasPer)->F24_CODIGO,xProd,'3','1',"Registro alterado")
                        EndIf*/
                    EndIf
                (xAliasPer)->(dbSkip())
                EndDo
                (xAliasPer)->(dbCloseArea())
            EndIf
        ElseIf IsInCallStack('MATA020')
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Faz a exclusão do forencedor no perfil encontrado                   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lRet := fExecAutoConf(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'1',"",5)   
            If lRet
                U_fLogCtrb((xAlias)->F22_CODIGO, "", xClieFor, xLoja,"Perfil CLiente-Fornecedor","Registro Excluído")
            EndIf
            If lPar 
                If lRet        
                    fGravaZZZ((xAlias)->F22_CODIGO,xClieFor+xLoja,'1','1',"Registro Excluído")
                EndIf
            EndIf
            If lRet
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Excluído com sucesso, chama função para buscar o novo perfil        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
                xAliasPer := fGetPerfil("1","") //corrigir
                While !(xAliasPer)->(Eof())
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Faz a gravação do registro no novo perfil e grava tabela de controle³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
                    lRet := fValidaDados('MATA020',(xAliasPer)->F22_CLIFOR, (xAliasPer)->F22_LOJA,xClieFor,xLoja, (xAliasPer)->F22_CODIGO, (xAliasPer)->F22_TIPOPF,'1','','',4,xGrpTrib,'')
                    If lPar
                        /*If lRet
                            fGravaZZZ((xAliasPer)->F22_CODIGO,xClieFor+xLoja,'1','1',"Registro alterado")
                        EndIF*/
                    EndIf
                (xAliasPer)->(dbSkip())
                EndDo
                (xAliasPer)->(dbCloseArea())
            EndIf
        Else
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Faz a exclusão do cliente no perfil encontrado                     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lRet := fExecAutoConf(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'2',"",5)
            If lRet
                U_fLogCtrb((xAlias)->F22_CODIGO, "", xClieFor, xLoja,"Perfil CLiente-Fornecedor","Registro Excluído")
            EndIf
            If lPar
                If lRet
                    fGravaZZZ((xAlias)->F22_CODIGO,xClieFor+xLoja,'2','1',"Registro Excluído")
                EndIf
            EndIf
            If lRet
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Excluído com sucesso, chama função para buscar o novo perfil        ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                 xAliasPer := fGetPerfil('2',"")
                 While !(xAliasPer)->(Eof())
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Faz a gravação do registro no novo perfil e grava tabela de controle³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
                    lRet := fValidaDados('CRMA980',(xAliasPer)->F22_CLIFOR, (xAliasPer)->F22_LOJA,xClieFor,xLoja, (xAliasPer)->F22_CODIGO, (xAliasPer)->F22_TIPOPF,'2','','',4,xGrpTrib,'')
                    If lPar
                        /*If lRet
                            fGravaZZZ((xAliasPer)->F22_CODIGO,xClieFor+xLoja,'2','1',"Registro Alterado")
                        EndIf*/
                    EndIf
                (xAliasPer)->(dbSkip())
                EndDo
                (xAliasPer)->(dbCloseArea())
            EndIf
        EndIf

    (xAlias)->(dbSkip())
    EndDo
    (xAlias)->(dbCloseArea())

Return lRet

/*/{Protheus.doc} fValidaDados
Valida as operações para efetuar a gravação
@type function
@version  
@author MCS Tecnologia
@since 11/5/2025
@param xChamada, variant, param_description
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xPerfil, variant, param_description
@param xTipOpf, variant, param_description
@param xTipoCF, variant, param_description
@param xProd, variant, param_description
@param nOper, numeric, param_description
@return variant, return_description
/*/
Static Function fValidaDados(xChamada,xClieForConf,xLojaConf,xClieFor, xLoja, xPerfil, xTipOpf,xTipoCF,xProdConf,xProd,nOper,xGrpTrib,xPosIpi)

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

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verificando se a MATA010, senão segue para verificar se é cli ou for³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    If xChamada == 'MATA010'
        If SB1->(dbSeek(xFilial("SB1") + xProdConf,.F.))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se o NCM do produto inserido for igual ao do produto pesquisado, grava ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If AllTrim(SB1->B1_POSIPI) == AllTrim(xPosIpi)
                lRet := fExecAutoConf("","",xPerfil,xTipoCF,"",xProd,nOper)
            EndIf
        EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verificando se a MATA020 está na pilha de chamada, senão é CRMA980  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    ElseIf IsInCallStack('MATA020')
        If SA2->(dbSeek(xFilial("SA2") + xClieForConf + xLojaConf,.F.))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Veririca se o grupo do fornecedor que foi cadastrado é igual ao que foi pesquisado ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If AllTrim(SA2->A2_GRPTRIB) == AllTrim(xGrpTrib)
                lRet := fExecAutoConf(xClieFor, xLoja, xPerfil, xTipOpf,'1',"",4)
            EndIf
        EndIf
    Else 
        If SA1->(dbSeek(xFilial("SA1") + xClieForConf + xLojaConf,.F.))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Veririca se o grupo do cliente que foi cadastrado é igual ao que foi pesquisado      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If AllTrim(SA1->A1_GRPTRIB) == AllTrim(xGrpTrib)
                lRet := fExecAutoConf(xClieFor, xLoja, xPerfil, xTipOpf,'2',"",4)
            EndIf
        EndIf
    EndIf

    RestArea(aArea)
    RestArea(aAreaA1)
    RestArea(aAreaA2)

Return lRet

/*/{Protheus.doc} fQueryAltera
Função para verificar em qual perfil se encontram o registros para deleção 
@type function
@version  
@author MCS Tecnologia
@since 11/5/2025
@param xProd, variant, param_description
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xTpPart, variant, param_description
@return variant, return_description
/*/
Static Function fQueryAltera(xProd, xClieFor, xLoja, xTpPart)

    Local xAlias := GetNextAlias()
    Local xQuery := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se vier da MATA010, trata a tabela do perfil de produto             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xProd)
        xQuery := " SELECT" + chr(13)
        xQuery += " F24_CODIGO," + chr(13)
        xQuery += " F24_CDPROD," + chr(13)
        xQuery += " F24_TIPOPF" + chr(13)
        xQuery += " FROM " + RetSqlName("F24") + "" + chr(13)
        xQuery += " WHERE F24_FILIAL = '" + FwxFilial("F24") + "'" + chr(13)
        xQuery += " AND F24_CDPROD = '" + xProd + "'" + chr(13)
        xQuery += " AND D_E_L_E_T_ = ' '" 
    Else 
        xQuery := " SELECT" + chr(13)
        xQuery += " F22_CODIGO," + chr(13)
        xQuery += " F22_CLIFOR," + chr(13)
        xQuery += " F22_LOJA," + chr(13)
        xQuery += " F22_TPPART," + chr(13)
        xQuery += " F22_TIPOPF" + chr(13)
        xQuery += " FROM " + RetSqlName("F22") + "" + chr(13)
        xQuery += " WHERE F22_FILIAL = '" + FwxFilial("F22") + "'" + chr(13)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verificando se é fornecedor ou cliente, para tratar codigos iguais  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If xTpPart == '1'
            xQuery += " AND F22_TPPART = '1'" + chr(13)
        Else 
            xQuery += " AND F22_TPPART = '2'" + chr(13)
        EndIf 
        xQuery += " AND F22_CLIFOR = '" + xClieFor + "' " + chr(13)
        xQuery += " AND F22_LOJA = '" + xLoja + "' " + chr(13)
        xQuery += " AND F22_LOJA <> 'ZZ' " + chr(13)
        xQuery += " AND D_E_L_E_T_ = ' '" 
    EndIf

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias

/*/{Protheus.doc} fMonitor
Tabela para exibir os registros integrados ao configurador
@type function
@version  
@author MCS Tecnologia
@since 11/6/2025
@return variant, return_description
/*/
User Function fMonitor()

    Local cTabela     := "ZZZ" 
    Local cCampo      := ""
    Local aArea       := (cTabela)->(GetArea())
    Private aCores    := {}
    Private cCadastro := "Monitor Gravação Perfil - Configurador Tributos"
    Private aRotina   := {}
     
    //Montando o Array aRotina, com funções que serão mostradas no menu
    aAdd(aRotina,{"Pesquisar"           ,   "AxPesqui"          , 0, 1})
    aAdd(aRotina,{"Visualizar"          ,   "AxVisual"          , 0, 2})
    aadd(aRotina,{"Legenda"             ,   "U_MON0002()"       , 0, 9})
    
    //Montando as cores da legenda
    aAdd(aCores,{"ZZZ_SITUAC == '1' ", "BR_VERDE"    })
    aAdd(aCores,{"ZZZ_SITUAC == '2' ", "BR_VERMELHO" })
     
    //Selecionando a tabela e ordenando
    DbSelectArea(cTabela)
    (cTabela)->(DbSetOrder(1))
     
    //Montando o Browse
    mBrowse(6, 1, 22, 75, cTabela , , , , , , aCores )
     
    //Encerrando a rotina
    (cTabela)->(DbCloseArea())
    
    RestArea(aArea)
    
Return

/*/{Protheus.doc} MONIT0002
Legenda
@type function
@version  
@author MCS Tecnologia
@since 11/6/2025
@return variant, return_description
/*/
User Function MON0002()

    Local aLegenda := {}

    aLegenda := { { "BR_VERDE"      ,    "Integrado"         },;
                  { "BR_VERMELHO"   ,    "Não integrado"     }}
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .T.

/*/{Protheus.doc} fGravaZZZ
Ggrava os registros na ZZZ
@type function
@version  
@author MCS Tecnologia
@since 11/6/2025
@param xCodPer, variant, param_description
@param xCodPro, variant, param_description
@param xTipo, variant, param_description
@param xStatus, variant, param_description
@return variant, return_description
/*/
Static Function fGravaZZZ(xCodPer,xCodPro,xTipo,xStatus,xMessage,xDesc)

    Default xDesc := ""

    ChkFile("ZZZ")

    Local aArea := ZZZ->(GetArea())
    Local xTab  := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica o tipo de gravação para setar a tabela correta            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Do Case 
        Case xTipo == '1'
            xTab := "SA2"
        Case xTipo == '2'
            xTab := "SA1"
        Otherwise
            xTab := "SB1"
    EndCase

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Executa o reclock                                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    RecLock("ZZZ", .T.)
        ZZZ->ZZZ_FILIAL := FWxFilial('ZZZ')
        ZZZ->ZZZ_CHAVE  := xCodPro
        ZZZ->ZZZ_SITUAC := xStatus
        ZZZ->ZZZ_ALIAS  := xTab
        ZZZ->ZZZ_PERFIL := xCodPer
        ZZZ->ZZZ_DATA   := dDataBase
        ZZZ->ZZZ_ACAO   := xMessage
        ZZZ->ZZZ_USER   := UsrRetName(__cUserId)
        //ZZZ->ZZZ_DESC   := xDesc
    ZZZ->(MsUnlock())

    RestArea(aArea)

Return
/*/{Protheus.doc} fRecLockSA1
Caso ocorra erro na gravação, retornar o registro antetior
@type function
@version  
@author MCS Tecnologia
@since 11/20/2025
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xOrig, variant, param_description
@return variant, return_description
/*/
Static Function fGravaSA1(xClieFor,xLoja,xOrig)

    Local aArea := SA1->(GetArea())

    SA1->(dbSelectArea("SA1"))
    SA1->(dbSetOrder(1))

    If SA1->(MsSeek(xFilial("SA1") + xClieFor + xLoja))
        RecLock("SA1",.F.)
            SA1->A1_GRPTRIB := xOrig
        SA1->(MsUnLock())
    EndIf
    RestArea(aArea)

Return
/*/{Protheus.doc} fGravaSA2
Caso ocorra erro na gravação, retornar o registro antetior
@type function
@version  
@author MCS Tecnologia
@since 11/20/2025
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xOrig, variant, param_description
@return variant, return_description
/*/
Static Function fGravaSA2(xClieFor,xLoja,xOrig)

    Local aArea := SA2->(GetArea())

    SA2->(dbSelectArea("SA2"))
    SA2->(dbSetOrder(1))

    If SA2->(MsSeek(xFilial("SA2") + xClieFor + xLoja))
        RecLock("SA2",.F.)
            SA2->A2_GRPTRIB := xOrig
        SA2->(MsUnLock())
    EndIf
    RestArea(aArea)

Return

/*/{Protheus.doc} fGravaSB1
Caso ocorra erro na gravação, retornar o registro antetior
@type function
@version  
@author MCS Tecnologia
@since 11/20/2025
@param xProd, variant, param_description
@param xOrig, variant, param_description
@return variant, return_description
/*/
Static Function fGravaSB1(xProd,xOrig)

    Local aArea := SB1->(GetArea())

    SB1->(dbSelectArea("SB1"))
    SB1->(dbSetOrder(1))

    If SB1->(MsSeek(xFilial("SB1") + xClieFor + xLoja))
        RecLock("SB1",.F.)
            SB1->B1_GRPTRIB := xOrig
        SB1->(MsUnLock())
    EndIf
    RestArea(aArea)

Return

