#Include 'Protheus.CH'

/*/{Protheus.doc} CTRIB02
Recebe os dados do do cliente e fornecedor e efetua a gravaГЦo no perfil do configurador de tributos.;
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@return variant, return_description
/*/
User Function CTRIB02(xClieFor, xLoja, xGrpTrib)

    Local lMvcFacAuto   := .F.
    //Local xParProd      := SuperGetMV("MV_CONFPP",.F.,"B1_POSIPI") //Parametro para automatizar conforme configuraГЦo do perfil, nЦo usado ainda no fonte
    Local aAreaA1       := SA1->(GetArea())
    Local aAreaA2       := SA2->(GetArea())
    Local lRet          := .T.

    SA1->(dbSelectArea("SA1"))
    SA1->(dbSetOrder(1))
    SA2->(dbSelectArea("SA2"))
    SA2->(dbSetOrder(1))

    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Se o grupo tributАrio estА preenchido                                Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    If !Empty(xGrpTrib)
        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Busca um registro de cada perfil para comparaГЦo, verificando se И fornecedor ou cliente Ё
        //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        xAlias := fGetF22(Iif(IsInCallStack('MATA020'),'1','2'))

        (xAlias)->(dbGoTop())

        While !(xAlias)->(Eof())

            //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            //Ё Verificando se a MATA020 estА na pilha de chamada, senЦo И CRMA980  Ё
            //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды 
            If IsInCallStack('MATA020')
                If SA2->(dbSeek(xFilial("SA2") + (xAlias)->F22_CLIFOR + (xAlias)->F22_LOJA,.F.))
                    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                    //Ё Veririca se o grupo do fornecedor que foi cadastrado И igual ao que foi pesquisado Ё
                    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                    If AllTrim(SA2->A2_GRPTRIB) == AllTrim(xGrpTrib)
                        lRet := fExecAutoFCA(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'1')
                    EndIf

                EndIf
            Else 
                If SA1->(dbSeek(xFilial("SA1") + (xAlias)->F22_CLIFOR + (xAlias)->F22_LOJA,.F.))
                    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                    //Ё Veririca se o grupo do cliente que foi cadastrado И igual ao que foi pesquisado Ё
                    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                    If AllTrim(SA1->A1_GRPTRIB) == AllTrim(xGrpTrib)
                        lRet := fExecAutoFCA(xClieFor, xLoja, (xAlias)->F22_CODIGO, (xAlias)->F22_TIPOPF,'2')
                    EndIf

                EndIf
            EndIf

        (xAlias)->(dbSkip())          
        EndDo

    Else 
        Conout("NЦo foi informado o grupo tributАrio no cadastro do cliente/fornecedor " + xProd)
        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Caso esteja habilitado o FwLogMsg no appserver                      Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды       
        U_fConout("NЦo foi informado o grupo tributАrio no cadastro do cliente/fornecedor " + xProd)
    EndIf

    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Grava o log, caso nЦo gravar o registros                            Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    If !lRet
        Conout("Cliente/Fornecedor nЦo inserido, verifique perfil")     
        U_fConout("Cliente/Fornecedor, verifique perfil")
    EndIf

    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Fechando areas abertas                                              Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

    (xAlias)->(dbCloseArea())

    RestArea(aAreaA1)
    RestArea(aAreaA2)

Return

/*/{Protheus.doc} fGetF22
Busca os registros da F22
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@return variant, return_description
/*/
Static Function fGetF22(xTpPart)

    Local xAlias := GetNextAlias()
    Local xQuery := ""

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
    If xTpPart == '1'
        xQuery += " WHERE F22_TPPART = '1'" + chr(13)
    Else 
        xQuery += " WHERE F22_TPPART = '2'" + chr(13)
    EndIf 
	xQuery += " AND D_E_L_E_T_ = ' '" + chr(13)
    xQuery += " ) AS A" + chr(13)
    xQuery += " WHERE RN = 1"

    MpSysOpenQuery(xQuery, xAlias)

Return xAlias

/*/{Protheus.doc} fExecAutoFCA
Execauto para gravaГЦo do perfil de cliente/fornecedor
@type function
@version  
@author MCS Consultoria
@since 11/4/2025
@param xCodPro, variant, param_description
@param xCodPer, variant, param_description
@return variant, return_description
/*/
Static Function fExecAutoFCA(xClieFor, xLoja, xCodPer,xTipOpf,xTpPart)

    Local oModel as object
    Local lOk   := .F.
    Local aArea := F20->(GetArea())

    F20->(dbSelectArea("F20"))
    F20->(dbSetOrder(1))

    If F20->(MsSeek(xFilial("F20") + xCodPer + xTipOpf))
 
        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Pega o modelo                                                       Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        oModel := FwLoadModel("FISA164") 
    
        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Apenas na alteraГЦo                                                 Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        oModel:SetOperation(4)
        oModel:Activate() // ativo o modelo
    
        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Adiciona os registros                                               Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        oModel:GetModel("FISA164PARTICIPANTE"):AddLine()
        oModel:SetValue("FISA164PARTICIPANTE", "F22_CODIGO", xCodPer)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_TPPART", xTpPart)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_CLIFOR", xClieFor)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_LOJA", xLoja)
        oModel:SetValue("FISA164PARTICIPANTE", "F22_TIPOPF", xTipOpf)
    
        If oModel:VldData()
            oModel:CommitData()
            lOk := .T.
            Conout("Cliente " + AllTrim(xClieFor) + " loja " + AllTrim(xLoja) + " inserido no perfil " + AllTrim(xCodPer) )
            //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            //Ё Grava log com o registro gerado no rootpath                         Ё
            //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
            U_fLogCtrb(xCodPer, "", xClieFor, xLoja,"Perfil CLiente-Fornecedor")
        Else
            VarInfo("",oModel:GetErrorMessage())
        EndIf
    
        oModel:DeActivate()

    EndIf

    RestArea(aArea)

Return lOk


