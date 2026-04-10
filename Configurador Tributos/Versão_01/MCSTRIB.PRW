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

    Local lAtv := SuperGetMV("MV_XATVMCS",.F.,.T.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Somente segue se o parâmetro estiver true                           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lAtv

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Caso venha do processo de inclusão, grava registro                   ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If IsInCallStack('U_CRMA980')
            If nOperation == 3
                fInsertPer("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,nOperation,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS,"2")
            ElseIf nOperation == 4 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Se for alteração, chama função para excluir                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fDeletPerf("",SA1->A1_COD, SA1->A1_LOJA,'2') 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Após exclusão ou se não existe, faz a inserção                      ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fInsertPer("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,nOperation,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS,"2")
            EndIf
        ElseIf IsInCallStack('MATA020')
            If INCLUI 
                fInsertPer("","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,,SA2->A2_TIPO,SA2->A2_CONTRIB,SA2->A2_EST,SA2->A2_COD_MUN,"",SA2->A2_SIMPNAC,SA2->A2_PAIS,"1")
            ElseIf ALTERA  
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Se for alteração, chama função para excluir                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fDeletPerf("",SA1->A1_COD, SA1->A1_LOJA,'1') 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Após exclusão ou se não existe, faz a inserção                      ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fInsertPer("","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,,SA2->A2_TIPO,SA2->A2_CONTRIB,SA2->A2_EST,SA2->A2_COD_MUN,"",SA2->A2_SIMPNAC,SA2->A2_PAIS,"1")
            EndIf
        Else 
            If INCLUI 
                fInsertPer(SB1->B1_COD,SB1->B1_POSIPI,"","",AllTrim(SB1->B1_GRTRIB),"","","","","","","","","3")
            ElseIf ALTERA
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Se for alteração, chama função para excluir                         ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fDeletPerf(SB1->B1_COD,"","") 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Após exclusão ou se não existe, faz a inserção                      ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                fInsertPer(SB1->B1_COD,SB1->B1_POSIPI,"","",AllTrim(SB1->B1_GRTRIB),"","","","","","","","","3")
            EndIf
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
    Local lLog      := SuperGetMV("MV_XMCSLOG",.F.,.F.) // parametro que ativa ou não a gravação da tabela de controle
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

        If Len(aMsg) > 0 .And. lLog
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

    Local cTabela     := SuperGetMV("MV_XTABLOG",.F.,"ZZZ")
    Local aArea       := {}
    Private aCores    := {}
    Private cCadastro := ""
    Private aRotina   := {}


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se a tabela existe no dicionário                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ExisteSX2(cTabela)
        aArea       := (cTabela)->(GetArea())
        aCores    := {}
        cCadastro := "Monitor Gravação Perfil - Configurador Tributos"
        aRotina   := {}
        
        //Montando o Array aRotina, com funções que serão mostradas no menu
        aAdd(aRotina,{"Pesquisar"           ,   "AxPesqui"          , 0, 1})
        aAdd(aRotina,{"Visualizar"          ,   "AxVisual"          , 0, 2})
        aadd(aRotina,{"Legenda"             ,   "U_MON0002()"       , 0, 9})
        
        //Montando as cores da legenda
        aAdd(aCores,{"AllTrim(ZZZ_SITUAC) == '1' ", "BR_VERDE"    })
        aAdd(aCores,{"AllTrim(ZZZ_SITUAC) == '2' ", "BR_VERMELHO" })
        
        //Selecionando a tabela e ordenando
        DbSelectArea(cTabela)
        (cTabela)->(DbSetOrder(1))
        
        //Montando o Browse
        mBrowse(6, 1, 22, 75, cTabela , , , , , , aCores )
        
        //Encerrando a rotina
        (cTabela)->(DbCloseArea())
        
        RestArea(aArea)
    Else 
        Help(,, "MCSCONF", , "Tabela de monitoramento não encontrada no dicionário", 1, 0, , , , , , {"Execute o UPDMCS() para criação da tabela"})
    EndIf
    
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

    Local xTabela := SuperGetMV("MV_XTABLOG",.F.,"ZZZ")
    Local aArea   := {}
    Local xTab    := ""
    Default xDesc := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se a tabela existe no dicionário                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If ExisteSX2(xTabela)

        ChkFile(xTabela)

        aArea := &(xTabela+"->"+"(GetArea())")

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
        //³ Executa o reclock - executando em macro &                          ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        RecLock(xTabela, .T.)
            &(xTabela+"->"+xTabela+"_FILIAL") := FWxFilial(xTabela)
            &(xTabela+"->"+xTabela+"_CHAVE")  := xCodPro
            &(xTabela+"->"+xTabela+"_SITUAC") := xStatus
            &(xTabela+"->"+xTabela+"_ALIAS")  := xTab
            &(xTabela+"->"+xTabela+"_PERFIL") := xCodPer
            &(xTabela+"->"+xTabela+"_DATA")   := dDataBase
            &(xTabela+"->"+xTabela+"_ACAO")   := xMessage
            &(xTabela+"->"+xTabela+"_USER")   := UsrRetName(__cUserId)
            &(xTabela+"->"+xTabela+"_DESC")   := xDesc

            //ZZZ->ZZZ_CHAVE  := xCodPro
            //ZZZ->ZZZ_SITUAC := xStatus
            //ZZZ->ZZZ_ALIAS  := xTab
            //ZZZ->ZZZ_PERFIL := xCodPer
            //ZZZ->ZZZ_DATA   := dDataBase
            /*ZZZ->ZZZ_ACAO   := xMessage
            ZZZ->ZZZ_USER   := UsrRetName(__cUserId)
            ZZZ->ZZZ_DESC   := xDesc*/
        &(xTabela+"->"+"(MsUnlock())")

        RestArea(aArea)

    EndIf

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
Static Function fInsertPer(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais,xTipPer)

    Local xTabMaster    := SuperGetMV("MV_XMASTER",.F.,"ZZW")
    Local xTab1         := SuperGetMV("MV_XDETAL1",.F.,"ZZY")
    Local xTab2         := SuperGetMV("MV_XDETAL2",.F.,"ZZX")
    Local xTab3         := SuperGetMV("MV_XDETAL3",.F.,"ZZV")
    Local xTab4         := SuperGetMV("MV_XDETAL4",.F.,"ZZU")
    Local xTab5         := SuperGetMV("MV_XDETAL5",.F.,"ZZT")
    Local xTab6         := SuperGetMV("MV_XDETAL6",.F.,"ZZS")
    Local xTab7         := SuperGetMV("MV_XDETAL7",.F.,"ZZR")
    Local aPerf         := {}
    Local xAlias        := GetNextAlias()
    Local xAlias2       := GetNextAlias()
    Local xQuery        := ""
    Local xQuery2       := ""
    Local xQuery3       := ""
    Local lReg1         := .F.
    Local lReg2         := .F.
    Local lReg3         := .F.
    Local lReg4         := .F.
    Local lReg5         := .F.
    Local lReg6         := .F.
    Local aAreaZZV      := ZZV->(GetArea())
    Local aAreaZZU      := ZZU->(GetArea())
    Local aAreaZZT      := ZZT->(GetArea())
    Local aAreaZZS      := ZZS->(GetArea())
    Local aAreaZZR      := ZZR->(GetArea())
    Local aAreaZZX      := ZZX->(GetArea())
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

    &('xTab2->(dbSelectArea(xTab2))')
    &('xTab3->(dbSelectArea(xTab3))')
    ZZU->(dbSelectArea("ZZU"))
    ZZT->(dbSelectArea("ZZT"))
    ZZS->(dbSelectArea("ZZS"))
    ZZR->(dbSelectArea("ZZR"))

    ZZX->(dbSetOrder(3))
    ZZV->(dbSetOrder(3))
    ZZU->(dbSetOrder(3))
    ZZT->(dbSetOrder(3))
    ZZS->(dbSetOrder(4))
    ZZR->(dbSetOrder(3))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Query principal para busca dos perfis                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery := "SELECT "+xTabMaster+"_COD AS CODIGO, "+xTab1+"_CODPER AS CODPER, "+xTabMaster+"_TIPPAR, "+xTabMaster+"_CONTRI, "+xTabMaster+"_SUFRAM, "+xTabMaster+"_SIMPLE, "+xTabMaster+"_REGRA1 AS REGRA1, "
    xQuery += xTabMaster+"_REGRA2 AS REGRA2, "+xTabMaster+"_REGRA3 AS REGRA3, "+xTabMaster+"_REGRA4 AS REGRA4, "+xTabMaster+"_REGRA5 AS REGRA5, "+xTabMaster+"_REGRA6 AS REGRA6 "  + chr(13)
    xQuery += "FROM " + RetSqlName(xTabMaster) + " ZZW " + chr(13)
    xQuery += "INNER JOIN "+RetSqlName(xTab1)+ " ZZY " + chr(13)
    xQuery += "ON "+xTab1+"_FILIAL = "+xTabMaster+"_FILIAL " + chr(13) 
    xQuery += "AND "+xTab1+"_COD = "+xTabMaster+"_COD " + chr(13)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Guardo a string para concatenar depois                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery2 := xQuery
    xQuery3 := xQuery
    If Empty(xProd)
        If IsInCallStack('U_CRMA980')
            xQuery += "WHERE "+xTabMaster+"_TIPPAR = '" + AllTrim(xTipo) + "' " + chr(13)
            xQuery += "AND "+xTabMaster+"_ALIAS = '1' "  + chr(13)
            xQuery += "AND "+xTabMaster+"_CONTRI = '" + AllTrim(xContri) + "' " + chr(13)
            xQuery += "AND "+xTabMaster+"_SIMPLE ='" + AllTrim(xSimples) + "' " + chr(13)
        Else 
            xQuery += "WHERE "+xTabMaster+"_CONTRI = '" + AllTrim(xContri) + "' " + chr(13)
            xQuery += "AND "+xTabMaster+"_ALIAS = '2' "  + chr(13)
            xQuery += "AND "+xTabMaster+"_SIMPLE ='" + AllTrim(xSimples) + "' " + chr(13)
        EndIf

        If Empty(xSufr)
            xQuery += "AND "+xTabMaster+"_SUFRAM IN ('2','') " + chr(13)
        Else 
            xQuery += "AND "+xTabMaster+"_SUFRAM = '1' " + chr(13)
        EndIf
    Else
        xQuery += "WHERE "+xTabMaster+"_ALIAS = '3' " + chr(13)
    EndIf
    xQuery += "AND "+xTabMaster+".D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "AND "+xTab1+".D_E_L_E_T_ = ' ' " + chr(13)

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

    While (xAlias)->(!Eof())

        If Empty(xQuery2)
            xQuery2 := xQuery3
        EndIf 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Caso nenhuma aba seja usada, já grava no array o perfil encontrado   ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If &("(xAlias)->REGRA1 == '2' .And. (xAlias)->REGRA2 == '2' .And. (xAlias)->REGRA3 == '2' .And. (xAlias)->REGRA4 == '2' .And. (xAlias)->REGRA5 == '2' .And. (xAlias)->REGRA6 == '2'")
            aadd(aPerf,{(xAlias)->CODPER})
        Else 
            If Empty(xProd)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Grupos tributários                                                  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xGrpTrib) .And. (xAlias)->REGRA1 == '1'
                    If &('xTab2->(dbSeek(xFilial(xTab2) + (xAlias)->CODIGO + AllTrim(xGrpTrib)))') 
                        xQuery2 += "INNER JOIN "+RetSqlName(xTab2)+ " ZZX " + chr(13)
                        xQuery2 += "ON "+xTab2+"_FILIAL = "+xTabMaster+"_FILIAL " + chr(13)
                        xQuery2 += "AND "+xTab2+"_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND "+xTab2+"_GRPTRI = '" + AllTrim(xGrpTrib) + "' " + chr(13)
                        //xQuery2 += "AND ZZX.D_E_L_E_T_ = ' ' " + chr(13) 
                        lReg1 := .T.
                    Else 
                        lReg1 := .F.
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Municipios iguais                                                  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xEst) .And. (xAlias)->REGRA2 == '1'
                    If ZZV->(dbSeek(xFilial("ZZV") + (xAlias)->CODIGO + AllTrim(xEst) + AllTrim(xCodMun)))
                        xQuery2 += "INNER JOIN "+RetSqlName("ZZV")+ " ZZV " + chr(13) 
                        xQuery2 += "ON ZZV_FILIAL = "+xTabMaster+"_FILIAL " + chr(13) 
                        xQuery2 += "AND ZZV_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND ZZV_EST = '" + AllTrim(xEst) + "' " + chr(13)
                        xQuery2 += "AND ZZV_CODMUN = '" + AllTrim(xCodMun) + "' " + chr(13)
                        //xQuery2 += "AND ZZV.D_E_L_E_T_ = ' ' " + chr(13) 
                        lReg2 := .T.
                    Else 
                        lReg2 := .F.
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Municipio exceção                                                   ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xEst) .And. (xAlias)->REGRA3 == '1' 
                    If ZZS->(dbSeek(xFilial("ZZS") + (xAlias)->CODIGO + AllTrim(xEst)))//retirar se não der certo
                        If ZZS->(dbSeek(xFilial("ZZS") + (xAlias)->CODIGO + AllTrim(xEst) + AllTrim(xCodMun))) //AJUSTAR
                            lReg4 := .F.
                        Else
                            xQuery2 += "INNER JOIN "+RetSqlName("ZZS")+ " ZZS " + chr(13)
                            xQuery2 += "ON ZZS_FILIAL = "+xTabMaster+"_FILIAL " + chr(13)
                            xQuery2 += "AND ZZS_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                            xQuery2 += "AND ZZS_UF <> '" + AllTrim(xEst) + "' " + chr(13)
                            xQuery2 += "AND ZZS_CODMUN <> '" + AllTrim(xCodMun) + "' " + chr(13)
                            //xQuery2 += "AND ZZS.D_E_L_E_T_ = ' ' " + chr(13) 
                            lReg4 := .T.
                        EndIf
                    Else 
                        lRet4 := .F.
                    EndIf
                EndIf
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Estados exceção                                                     ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xEst) .And. (xAlias)->REGRA4 == '1' //.And. lReg4 == .T. .Or. ZZS->ZZS_UF <> ' '
                    If ZZU->(dbSeek(xFilial("ZZU") + (xAlias)->CODIGO + AllTrim(xEst)))
                        xQuery2 += "INNER JOIN "+RetSqlName("ZZU")+ " ZZU " + chr(13) 
                        xQuery2 += "ON ZZU_FILIAL = "+xTabMaster+"_FILIAL " + chr(13) 
                        xQuery2 += "AND ZZU_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND ZZU_EST = '" + AllTrim(xEst) + "' " + chr(13)
                       // xQuery2 += "AND ZZU.D_E_L_E_T_ = ' ' " + chr(13) 
                        lReg3 := .T.
                    Else 
                        lReg3 := .F.
                    EndIf
                Else 
                     lReg4 := .F.
                EndIf

            Else 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Grupos tributários                                                  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xGrpTrib) .And. (xAlias)->REGRA1 == '1'
                    If &('xTab2->(dbSeek(xFilial(xTab2) + (xAlias)->CODIGO + AllTrim(xGrpTrib)))')
                        xQuery2 += "INNER JOIN "+RetSqlName(xTab2)+ " ZZX " + chr(13)
                        xQuery2 += "ON "+xTab2+"_FILIAL = "+xTabMaster+"_FILIAL " + chr(13)
                        xQuery2 += "AND "+xTab2+"_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND "+xTab2+"_GRPTRI = '" + AllTrim(xGrpTrib) + "' " + chr(13)
                        //xQuery2 += "AND ZZX.D_E_L_E_T_ = ' ' " + chr(13) 
                        lReg1 := .T.
                    Else 
                        lReg1 := .F.
                    EndIf
                EndIf

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ NCM Igual                                                           ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !Empty(xPosIpi) .And. (xAlias)->REGRA6 == '1'
                    If ZZT->(dbSeek(xFilial("ZZT") + (xAlias)->CODIGO + AllTrim(xPosIpi)))
                        xQuery2 += "INNER JOIN "+RetSqlName("ZZT")+ " ZZT " + chr(13) 
                        xQuery2 += "ON ZZT_FILIAL = "+xTabMaster+"_FILIAL " + chr(13) 
                        xQuery2 += "AND ZZT_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND ZZT_NCM = '" + AllTrim(xPosIpi) + "' " + chr(13)
                        //xQuery2 += "AND ZZT.D_E_L_E_T_ = ' ' " + chr(13) 
                        lReg5 := .T.
                    Else 
                        lReg5 := .F.
                    EndIf
                EndIf

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Municipio exceção                                                   ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !lReg5 .And. !Empty(xPosIpi) .And. (xAlias)->REGRA5 == '1'
                    If ZZS->(dbSeek(xFilial("ZZS") + (xAlias)->CODIGO + AllTrim(xEst) + AllTrim(xCodMun)))
                        lReg6 := .F.
                    Else 
                        xQuery2 += "INNER JOIN "+RetSqlName("ZZR")+ " ZZR " + chr(13) 
                        xQuery2 += "ON ZZR_FILIAL = "+xTabMaster+"_FILIAL " + chr(13) 
                        xQuery2 += "AND ZZR_COD = '" +(xAlias)->CODIGO + "' " + chr(13)
                        xQuery2 += "AND ZZR_NCM <> ZZT_NCM " + chr(13)
                        xQuery2 += "AND ZZR_NCM = '" + AllTrim(xPosIpi) + "' " + chr(13)
                        //xQuery2 += "AND ZZR.D_E_L_E_T_ = ' ' " + chr(13)
                        lReg6 := .T.
                    EndIf
                Else 
                     lReg6 := .F.
                EndIf
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            ///³ Somente produto                                                   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If Empty(xProd)
                xQuery2 += "WHERE CODIGO = '" +(xAlias)->CODIGO + "' " + chr(13) 
                xQuery2 += "AND "+xTabMaster+"_TIPPAR = '" + AllTrim(xTipo) + "' " + chr(13)
                xQuery2 += "AND "+xTabMaster+"_CONTRI = '" + AllTrim(xContri) + "' " + chr(13)
                xQuery2 += "AND "+xTabMaster+"_SIMPLE ='" + AllTrim(xSimples) + "' " + chr(13)      
                If Empty(xSufr)
                    xQuery2 += "AND "+xTabMaster+"_SUFRAM IN ('2','') " + chr(13)
                Else 
                    xQuery2 += "AND "+xTabMaster+"_SUFRAM = '1' " + chr(13)
                EndIf
            Else 
                xQuery2 += "WHERE CODIGO = '" +(xAlias)->CODIGO + "' " + chr(13)
                xQuery2 += "AND "+xTabMaster+"_ALIAS = '3' " + chr(13)
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Segue se o array dos perfis está vazio                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If Len(aPerf) == 0
                xQuery2 += "AND "+xTabMaster+".D_E_L_E_T_ = ' ' " + chr(13)
                xQuery2 += "AND "+xTab1+".D_E_L_E_T_ = ' ' " + chr(13)
                If lReg1
                    xQuery2 += "AND "+xTab2+".D_E_L_E_T_ = ' ' " + chr(13) 
                ElseIf lReg2
                    xQuery2 += "AND ZZV.D_E_L_E_T_ = ' ' " + chr(13)
                ElseIf lReg4 
                    xQuery2 += "AND ZZS.D_E_L_E_T_ = ' ' " + chr(13)
                ElseIf lReg3 
                    xQuery2 += "AND ZZU.D_E_L_E_T_ = ' ' " + chr(13)
                ElseIf lReg5 
                    xQuery2 += "AND ZZT.D_E_L_E_T_ = ' ' " + chr(13)
                ElseIf lReg6 
                   xQuery2 += "AND ZZR.D_E_L_E_T_ = ' ' " + chr(13)
                EndIf
            EndIf
        EndIf
        
        MpSysOpenQuery(xQuery2, xAlias2)

        (xAlias2)->(dbGoTop())

        If (xAlias2)->(!Eof())
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se encontrou alguma regra, faz o processo de gravação do array     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lReg6 .Or. lReg5 .Or. lReg4 .Or. lReg3 .Or. lReg2 .Or. lReg1
                lReg1 := .F.
                lReg2 := .F.
                lReg3 := .F.
                lReg4 := .F.
                lReg5 := .F.
                lReg6 := .F.
                aadd(aPerf,{(xAlias2)->CODPER})
            EndIf
        EndIf
        xQuery2 := ""
        (xAlias2)->(dbSkip())

    (xAlias)->(dbSkip()) 

    EndDo 

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fechando os alias                                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    (xAlias)->(dbCloseArea())

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
        fGravaZZZ("",'',xTipPer,'2',"Registro " + Iif(Empty(xProd),xClieFor+xLoja,xProd) + " não gravado, verifique o cadastro original produto/cliente/fornecedor ou o cadastro das regras")
    EndIf

    RestArea(aAreaZZV) 
    RestArea(aAreaZZU)     
    RestArea(aAreaZZT)   
    RestArea(aAreaZZS)    
    RestArea(aAreaZZR)   
    RestArea(aAreaZZX) 


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
