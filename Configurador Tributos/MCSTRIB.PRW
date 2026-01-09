#Include 'Protheus.CH'

/*/{Protheus.doc} UNICTCLI
Recebe os dados do PE e trata para gravar o execauto do perfil de cliente;
@type function
@version  
@author MCS Tecnologia
@since 11/4/2025
@return variant, return_description
/*/
User Function MCSTRIB()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Caso venha do processo de inclusão, grava registro                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If IsInCallStack('U_CRMA980')
        If nOperation == 3
            fInsertPer("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,nOperation,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS)
        ElseIf nOperation == 4 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se for alteração, chama função para excluir                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fDeletPerf("",SA1->A1_COD, SA1->A1_LOJA,'2') 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Após exclusão ou se não existe, faz a inserção                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fInsertPer("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,nOperation,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS)
        EndIf
    ElseIf IsInCallStack('MATA020')
        If nOperation == 3
            fInsertPer("","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,nOperation,SA2->A2_TIPO,SA2->A2_CONTRIB,SA2->A2_EST,SA2->A2_COD_MUN,"",SA2->A2_SIMPNAC,SA2->A2_PAIS)
        ElseIf nOperation == 4 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se for alteração, chama função para excluir                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fDeletPerf("",SA1->A1_COD, SA1->A1_LOJA,'1') 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Após exclusão ou se não existe, faz a inserção                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fInsertPer("","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,nOperation,SA2->A2_TIPO,SA2->A2_CONTRIB,SA2->A2_EST,SA2->A2_COD_MUN,"",SA2->A2_SIMPNAC,SA2->A2_PAIS)
        EndIf
    Else 
        If INCLUI 
            fInsertPer(SB1->B1_COD,SB1->B1_POSIPI,"","","","","","","","","","","")
        ElseIf ALTERA
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se for alteração, chama função para excluir                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fDeletPerf(SB1->B1_COD,"","") 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Após exclusão ou se não existe, faz a inserção                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            fInsertPer(SB1->B1_COD,SB1->B1_POSIPI,"","","","","","","","","","","")
        EndIf


    EndIf
Return 


/*/{Protheus.doc} fExecAutoConf
Execauto para gravação do perfil
@type function
@version  
@author MCS Tecnologia
@since 11/4/2025
@param xCodPro, variant, param_description
@param xCodPer, variant, param_description
@return variant, return_description
/*/
Static Function fExecAutoConf(xProd,xClieFor,xLoja,aPerf,xTipOpf,xTpPart,nOp)

    Local oModel as object
    Local lOk       := .F.
    Local aArea     := F20->(GetArea())
    LOcal aAreaF22  := F22->(GetArea())
    Local aAreaF24  := F24->(GetArea())
    Local xCod      := ""
    Local lPar      := SuperGetMV("ZZ_TABCTRL",.F.,.T.) // parametro que ativa ou não a gravação da tabela de controle
    Local x         := 0
    Local y         := 0
    Local aMsg      := {}

    If nOp == 4

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Setando tabela e indice da F20                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        F20->(dbSelectArea("F20"))
        F20->(dbSetOrder(1))

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Laço para passar por todos os perfis                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        For x := 1 to Len(aPerf)

            If F20->(MsSeek(xFilial("F20") + aPerf[x][1] + xTipOpf))
        
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
                    oModel:GetModel("FISA166PRODUTO"):AddLine()
                    //oModel:SetValue("FISA166PRODUTO", "F24_FILIAL", FwCodFil())
                    oModel:SetValue("FISA166PRODUTO", "F24_CODIGO", aPerf[x][1])
                    oModel:SetValue("FISA166PRODUTO", "F24_CDPROD", xProd)
                    oModel:SetValue("FISA166PRODUTO", "F24_TIPOPF", xTipOpf)
                Else
                    oModel:GetModel("FISA164PARTICIPANTE"):AddLine()
                    oModel:SetValue("FISA164PARTICIPANTE", "F22_CODIGO", aPerf[x][1])
                    oModel:SetValue("FISA164PARTICIPANTE", "F22_TPPART", xTpPart)
                    oModel:SetValue("FISA164PARTICIPANTE", "F22_CLIFOR", xClieFor)
                    oModel:SetValue("FISA164PARTICIPANTE", "F22_LOJA"  , xLoja)
                    oModel:SetValue("FISA164PARTICIPANTE", "F22_TIPOPF", xTipOpf)
                EndIf 
        
                If oModel:VldData()
                    oModel:CommitData()
                    lOk := .T.
                    If !Empty(xClieFor)    
                        Conout("Cliente " + AllTrim(xClieFor) + " loja " + AllTrim(xLoja) + " inserido no perfil " + AllTrim(aPerf[x][1]) )
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava log com o registro gerado no rootpath                         ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        aadd(aMsg,{AllTrim(aPerf[x][1]) +"|"+AllTrim(F20->F20_DESC) +"|" + xClieFor+xLoja + "| Perfil CLiente-Fornecedor"+"|"+"Registro Incluído"})
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava o registro na tabela de conferencia                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lPar 
                            fGravaZZZ(aPerf[x][1],xClieFor+xLoja,xTpPart,'1',"Registro Incluído",F20->F20_DESC)
                        EndIf
                    Else 
                        Conout("Produto " + AllTrim(xProd) + " inserido no perfil " + AllTrim(aPerf[x][1]) )
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava log com o registro gerado no rootpath                         ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        aadd(aMsg,{AllTrim(aPerf[x][1]) +"||"+AllTrim(F20->F20_DESC)+ "|" + xProd + " |Perfil Produto" +"|"+ "Registro Incluído"})
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                        //³ Grava o registro na tabela de conferencia                          ³
                        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        If lPar 
                            fGravaZZZ(aPerf[x][1],xProd,xTpPart,'1',"Registro Incluído",F20->F20_DESC)
                        EndIf

                    EndIf
                Else
                    //VarInfo("",oModel:GetErrorMessage())
                    If !Empty(xClieFor) 
                        xCod := Iif(xTipOpf == '3',xProd,xClieFor+xLoja)
                        If lPar
                            fGravaZZZ(aPerf[x][1],'',xTpPart,'2',"Registro " + xCod + " não gravado, verificar perfil",F20->F20_DESC)
                        EndIf
                    Else 

                    EndIf
                EndIf
                oModel:DeActivate()
            EndIf
            
        Next x

        If Len(aMsg) > 0
            U_fLogCtrb(aMsg)
        EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Processo de exclusão                                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Else

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Setando tabela e indice da F20                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        F20->(dbSelectArea("F20"))
        F20->(dbSetOrder(1))

        For x := 1 to Len(aPerf)

           F20->(MsSeek(xFilial("F20") + aPerf[x][1] + xTipOpf))

           If xTipOpf == '02'
               F22->(dbSelectArea("F22"))
               F22->(dbSetOrder(1))

               For y := 1 to Len(aPerf)
                  If F22->(MsSeek(xFilial("F22") + aPerf[y][1] + xTpPart + xClieFor + xLoja))
                     RecLock("F22",.F.)
                         F22->(dbDelete())
                         MsUnLock()
                     F22->(FkCommit())
                     lOk := .T. 
                  EndIf
                  fGravaZZZ(aPerf[y][1],xClieFor+xLoja,xTpPart,'1',"Registro Excluído",F20->F20_DESC)
                Next y
            Else 
                F24->(dbSelectArea("F24"))
                F24->(dbSetOrder(1))

                For y := 1 to Len(aPerf)
                    If F24->(MsSeek(xFilial("F24") + aPerf[y][1] + xProd))
                        RecLock("F24",.F.)
                            F24->(dbDelete())
                            MsUnLock()
                        F24->(FkCommit())
                        lOk := .T. 
                    EndIf
                    fGravaZZZ(aPerf[y][1],xProd,xTpPart,'1',"Registro Excluído",F20->F20_DESC)
                Next y
            EndIf
        Next x

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
User Function fLogCtrb(aMsg)

    Local cTime     
    Local cData     
    Local xPasta     
    Local xLog   
    Local nPathEr   
    Local x       := 0

    cTime     := Replace(Time(),":","")
    cData     := dtos(dDataBase)
    xPasta    := "\Logs\MCS\MCSTRIB\"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verificando se existe a pasta criada no protheus_data               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    If !ExistDir(xPasta)
        MakeDir(xPasta)
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criando arquivo                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    xLog := "Perfil Clientes"+"_"+cData+"_"+cTime+".txt"
    nPathEr := FCreate(xPasta+Upper(xLog))

    If nPathEr < 0
		conout("Erro durante criação do arquivo.")
	Else 
        For x := 1 to Len(aMsg)
            FWrite(nPathEr, aMsg[x][1])
        Next x
    EndIf
    FClose(nPathEr) 
        
Return


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
        ZZZ->ZZZ_DESC   := xDesc
    ZZZ->(MsUnlock())

    RestArea(aArea)

Return

/*/{Protheus.doc} fInsertPer
Query principal para busca dos registros de perfis para inclusão
@type function
@version  
@author MCS Tecnologia
@since 11/29/2025
@param xProd, variant, param_description
@param xPosIpi, variant, param_description
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@param xGrpTrib, variant, param_description
@param xOper, variant, param_description
@param xOrig, variant, param_description
@param xTipo, variant, param_description
@param xContri, variant, param_description
@param xEst, variant, param_description
@param xCodMun, variant, param_description
@param xSufr, variant, param_description
@param xSimples, variant, param_description
@param xPais, variant, param_description
@param lRevisa, logical, param_description
@return variant, return_description
/*/
Static Function fInsertPer(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais)

    Local aPerf         := {}
    Local xAlias        := GetNextAlias()
    Local xAlias2       := GetNextAlias()
    Local xQuery        := ""
    Local xQuery2       := ""
    Local lReg1         := .F.
    Local lReg2         := .F.
    Local lReg3         := .F.
    Local lReg4         := .F.
    Local lReg5         := .F.
    Local lReg6         := .F.
    Default xProd       := ""
    Default xPosIpi     := ""
    Default xClieFor    := ""
    Default xLoja       := ""
    Default xGrpTrib    := ""
    Default xOper       := ""
    Default xTipo       := ""
    Default xContri     := ""
    Default xEst        := ""
    Default xCodMun     := ""
    Default xSufr       := ""
    Default xSimples    := ""
    Default xPais       := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Query principal para busca dos perfis                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery := "SELECT ZZW_COD, ZZY_CODPER, ZZW_TIPPAR, ZZW_CONTRI, ZZW_SUFRAM, ZZW_SIMPLE, ZZW_REGRA1, ZZW_REGRA2, ZZW_REGRA3, ZZW_REGRA4, ZZW_REGRA5"  + chr(13)
    xQuery += "FROM " + RetSqlName("ZZW") + " ZZW " + chr(13)
    xQuery += "INNER JOIN "+RetSqlName("ZZY")+ " ZZY " + chr(13)
    xQuery += "ON ZZY_FILIAL = ZZW_FILIAL " + chr(13) 
    xQuery += "AND ZZY_COD = ZZW_COD " + chr(13)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Guardo a string para concatenar depois                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery2 := xQuery
    If Empty(xProd)
        xQuery += "WHERE ZZW_TIPPAR = '" + AllTrim(xTipo) + "' " + chr(13)
        xQuery += "AND ZZW_CONTRI = '" + AllTrim(xContri) + "' " + chr(13)
        xQuery += "AND ZZW_SIMPLE ='" + AllTrim(xSimples) + "' " + chr(13)
        If !Empty(xSufr)
            xQuery += "AND ZZW_SUFRAM = 'SIM' " + chr(13)
        EndIf
    Else
        xQuery += "WHERE ZZW_ALIAS = '3' " + chr(13)
    EndIf
    xQuery += "AND ZZW.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "AND ZZY.D_E_L_E_T_ = ' ' " + chr(13)

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

    While (xAlias)->(!Eof())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Concatenar com a query gravada anteriormente                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If (xAlias)->ZZW_REGRA1 == '1' .And. Empty(xProd) .And. !Empty(xGrpTrib) .And. !lReg1
            xQuery2 += "INNER JOIN "+RetSqlName("ZZX")+ " ZZX " + chr(13)
            xQuery2 += "ON ZZX_FILIAL = ZZW_FILIAL " + chr(13)
            xQuery2 += "AND ZZX_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZX_GRPTRI = '" + AllTrim(xGrpTrib) + "' " + chr(13)
            xQuery2 += "AND ZZX.D_E_L_E_T_ = ' ' " + chr(13) 
            lReg1 := .T.
        EndIf
        //Tabela que contêm os códigos de municipio
        If (xAlias)->ZZW_REGRA2 == '1' .And. !Empty(xSufr) .And. Empty(xProd) .And. !lReg2
            xQuery2 += "INNER JOIN "+RetSqlName("ZZV")+ " ZZV " + chr(13) 
            xQuery2 += "ON ZZV_FILIAL = ZZW_FILIAL " + chr(13) 
            xQuery2 += "AND ZZV_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZV_EST = '" + AllTrim(xEst) + "' " + chr(13)
            xQuery2 += "AND ZZV_CODMUN = '" + AllTrim(xCodMun) + "' " + chr(13)
            xQuery2 += "AND ZZV.D_E_L_E_T_ = ' ' " + chr(13)
            lReg2 := .T.
        EndIf
        //Tabela que contem os estados
        If (xAlias)->ZZW_REGRA3 == '1' .And. Empty(xProd) .And. !lReg3
            xQuery2 += "INNER JOIN "+RetSqlName("ZZS")+ " ZZS " + chr(13)
            xQuery2 += "ON ZZS_FILIAL = ZZW_FILIAL " + chr(13)
            xQuery2 += "AND ZZS_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZS_UF = '" + AllTrim(xEst) + "' " + chr(13)
            xQuery2 += "AND ZZS.D_E_L_E_T_ = ' ' " + chr(13)
            lReg3 := .T.
        EndIf
        If (xAlias)->ZZW_REGRA4 == '1' .And. Empty(xProd) .And. !lReg4
        //Tabela que contem os estados como exceção na regra
            xQuery2 += "INNER JOIN "+RetSqlName("ZZU")+ " ZZU " + chr(13) 
            xQuery2 += "ON ZZU_FILIAL = ZZW_FILIAL " + chr(13) 
            xQuery2 += "AND ZZU_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZU_EST = '" + AllTrim(xEst) + "' " + chr(13)
            xQuery2 += "AND ZZU.D_E_L_E_T_ = ' ' " + chr(13)
            lReg4 := .T.
        EndIf
            //Tabela que contem o NCM - perfil produto
        If (xAlias)->ZZW_REGRA5 == '2' .And. !Empty(xProd) .And. !lReg5
            xQuery2 += "INNER JOIN "+RetSqlName("ZZT")+ " ZZT " + chr(13) 
            xQuery2 += "ON ZZT_FILIAL = ZZW_FILIAL " + chr(13) 
            xQuery2 += "AND ZZT_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZT_NCM = '" + AllTrim(xPosIpi) + "' " + chr(13)
            xQuery2 += "AND ZZT.D_E_L_E_T_ = ' ' " + chr(13)
            lReg5 := .T.
        EndIf

        If (xAlias)->ZZW_REGRA5 == '1' .And. !Empty(xProd) .And. !lReg6
            xQuery2 += "INNER JOIN "+RetSqlName("ZZR")+ " ZZR " + chr(13) 
            xQuery2 += "ON ZZR_FILIAL = ZZW_FILIAL " + chr(13) 
            xQuery2 += "AND ZZR_COD = ZZW_COD " + chr(13)
            xQuery2 += "AND ZZR_NCM <> ZZT_NCM " + chr(13)
            xQuery2 += "AND ZZR_NCM = '" + AllTrim(xPosIpi) + "' " + chr(13)
            xQuery2 += "AND ZZR.D_E_L_E_T_ = ' ' " + chr(13)
            lReg6 := .T.
        EndIf

    (xAlias)->(dbSkip()) 

    If lReg6 .Or. lReg5 .Or. lReg4 .Or. lReg3 .Or. lReg2 .Or. lReg1 
        xQuery2 += "AND ZZW.D_E_L_E_T_ = ' ' " + chr(13)
        xQuery2 += "AND ZZY.D_E_L_E_T_ = ' ' " + chr(13) 
    EndIf

    EndDo  
        
    MpSysOpenQuery(xQuery2, xAlias2)

    (xAlias2)->(dbGoTop())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Percorre todos os perfis                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    While (xAlias2)->(!Eof())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Adicionando o perfil encontrado no array                             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aadd(aPerf,{(xAlias2)->ZZY_CODPER})
    
    (xAlias2)->(dbSkip())

    EndDo
 
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fechando os alias                                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    (xAlias)->(dbCloseArea())
    (xAlias2)->(dbCloseArea())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se perfil encontrado, envia conforme o tipo                        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aPerf) > 0
        If IsInCallStack('U_CRMA980')
            fExecAutoConf("",xClieFor,xLoja,aPerf,'02','2',4)
        ElseIf IsInCallStack('MATA020')
            fExecAutoConf("",xClieFor,xLoja,aPerf,'02','1',4)
        Else 
            fExecAutoConf(xProd,'','',aPerf,'04','3',4)
        EndIf
    Else 
        fGravaZZZ("",'','0','2',"Registro " + Iif(Empty(xProd),xClieFor+xLoja,xProd) + " não gravado, verifique o cadastro original produto/cliente/fornecedor ou o cadastro das regras")
    EndIf


Return

/*/{Protheus.doc} fDeletPerf
Faz a exclusão dos registros na alteração.
@type function
@version  
@author MCS Tecnologia
@since 11/29/2025
@param xClieFor, variant, param_description
@param xLoja, variant, param_description
@return variant, return_description
/*/
Static Function fDeletPerf(xProd,xClieFor,xLoja,xTpPart)

    Local xQuery := ""
    Local xAlias := GetNextAlias()
    Local aPerf  := {}
    Default xClieFor := ""
    Default xLoja    := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Tratamento para perfil de produto                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Empty(xProd)
        xQuery := "SELECT F22_CODIGO AS COD_PERFIL FROM "+RetSqlName("F22")+ " " + chr(13)
        xQuery += "WHERE F22_FILIAL = '" +FwxFilial("F22")+ "' " + chr(13) 
        xQuery += "AND F22_CLIFOR = '" +AllTrim(xClieFor)+ "' " + chr(13)
        xQuery += "AND F22_LOJA = '" +AllTrim(xLoja)+ "' " + chr(13)
        xQuery += "AND F22_TPPART = '" +AllTrim(xTpPart)+ "' " + chr(13)
        xQuery += "AND D_E_L_E_T_ = ' ' "
    Else 
        xQuery := "SELECT F24_CODIGO AS COD_PERFIL FROM "+RetSqlName("F24")+ " " + chr(13)
        xQuery += "WHERE F24_FILIAL = '" +FwxFilial("F24")+ "' " + chr(13) 
        xQuery += "AND F24_CDPROD = '" +AllTrim(xProd)+ "' " + chr(13)
        xQuery += "AND D_E_L_E_T_ = ' ' "
    EndIf

    MpSysOpenQuery(xQuery,xAlias)

    (xAlias)->(dbGoTop())

    While !(xAlias)->(Eof())

        aadd(aPerf,{(xAlias)->COD_PERFIL})

    (xAlias)->(dbSkip())
    
    EndDo

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Envia para excluir o registro, tipo 5                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aPerf) > 0
        If Empty(xProd)
            fExecAutoConf("",xClieFor,xLoja,aPerf,'02',xTpPart,5)
        Else 
            fExecAutoConf(xProd,"","",aPerf,'04',xTpPart,5)
        EndIf
    EndIf 

Return 
