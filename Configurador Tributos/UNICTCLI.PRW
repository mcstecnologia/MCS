#Include 'Protheus.CH'

/*/{Protheus.doc} UNICTCLI
Recebe os dados do PE e trata para gravar o execauto do perfil de cliente;
@type function
@version  
@author MCS Tecnologia
@since 11/4/2025
@return variant, return_description
/*/
User Function UNICTCLI(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xOrig,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais,lRevisa)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Caso venha do processo de inclusão, grava registro                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xOper == 3
        fInsertPer(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xOrig,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais,lRevisa)
    ElseIf xOper == 4 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Se for alteração, chama função para excluir                         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        fDeletPerf(xClieFor,xLoja) 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Após exclusão ou se não existe, faz a inserção                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        fInsertPer(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,4,xOrig,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais,lRevisa)
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
Static Function fExecAutoConf(xClieFor,xLoja,aPerf,xTipOpf,xTpPart,nOp)

    Local oModel as object
    Local lOk       := .F.
    Local aArea     := F20->(GetArea())
    LOcal aAreaF22  := F22->(GetArea())
    Local aAreaF24  := F24->(GetArea())
    Local xCod      := ""
    Local lPar      := SuperGetMV("ZZ_TABCTRL",.F.,.T.) // parametro que ativa ou não a gravação da tabela de controle
    Local x         := 0
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

                oModel := FwLoadModel("FISA164") 

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Apenas na alteração                                                 ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                oModel:SetOperation(nOp)
                oModel:Activate() // ativo o modelo
            
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Adiciona os registros                                               ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                oModel:GetModel("FISA164PARTICIPANTE"):AddLine()
                oModel:SetValue("FISA164PARTICIPANTE", "F22_CODIGO", aPerf[x][1])
                oModel:SetValue("FISA164PARTICIPANTE", "F22_TPPART", xTpPart)
                oModel:SetValue("FISA164PARTICIPANTE", "F22_CLIFOR", xClieFor)
                oModel:SetValue("FISA164PARTICIPANTE", "F22_LOJA"  , xLoja)
                oModel:SetValue("FISA164PARTICIPANTE", "F22_TIPOPF", xTipOpf)
        
                If oModel:VldData()
                    oModel:CommitData()
                    lOk := .T.
                        
                    Conout("Cliente " + AllTrim(xClieFor) + " loja " + AllTrim(xLoja) + " inserido no perfil " + AllTrim(aPerf[x][1]) )
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Grava log com o registro gerado no rootpath                         ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    aadd(aMsg,{AllTrim(aPerf[x][1]) +"||"+AllTrim(F20->F20_DESC), "", xClieFor, xLoja,"Perfil CLiente-Fornecedor","Registro Incluído"})
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Grava o registro na tabela de conferencia                          ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If lPar 
                        fGravaZZZ(aPerf[x][1],xClieFor+xLoja,xTpPart,'1',"Registro Incluído",F20->F20_DESC)
                    EndIf
                Else
                    //VarInfo("",oModel:GetErrorMessage())
                    xCod := Iif(xTpPart == '3','',xClieFor+xLoja)
                    If lPar
                        fGravaZZZ(aPerf[x][1],'',xTpPart,'2',"Registro não gravado, verificar perfil",F20->F20_DESC)
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

        F20->(MsSeek(xFilial("F20") + aPerf[x][1] + '02'))

        F22->(dbSelectArea("F22"))
        F22->(dbSetOrder(1))

        For x := 1 to Len(aPerf)
            If F22->(MsSeek(xFilial("F22") + aPerf[x][1] + '2' + xClieFor + xLoja))
                RecLock("F22",.F.)
                    F22->(dbDelete())
                    MsUnLock()
                F22->(FkCommit())
                lOk := .T. 
            EndIf
            fGravaZZZ(aPerf[x][1],xClieFor+xLoja,'2','1',"Registro Excluído",F20->F20_DESC)
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
    xLog := "Perfil Clientes"+"_"+cData+"_"+cTime+".txt"
    nPathEr := FCreate(xPasta+Upper(xLog))

    If nPathEr < 0
		conout("Erro durante criação do arquivo.")
	Else 
        For x := 1 to Len(aMsg)
            FWrite(nPathEr, aMsg[1][x])
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
Regra para inclusão
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
Static Function fInsertPer(xProd,xPosIpi,xClieFor,xLoja,xGrpTrib,xOper,xOrig,xTipo,xContri,xEst,xCodMun,xSufr,xSimples,xPais,lRevisa)

    Local aPerf         := {}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Apenas se o cadastro for revisado                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lRevisa
        If xTipo == 'F' .And. xContri == '2' .And. xEst <> 'PE'
            aadd(aPerf,{'C00000'})
            aadd(aPerf,{'C00006'})
            aadd(aPerf,{'C00012'})
            aadd(aPerf,{'C00013'})
            fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
        ElseIf xTipo == 'F' .And.xContri == '2' .And. xEst == 'PE'
            aadd(aPerf,{'C00000'})
            aadd(aPerf,{'C00006'})
            aadd(aPerf,{'C00012'})
            aadd(aPerf,{'C00015'})
            fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
        ElseIf xTipo == 'F' .And. xContri == '1' .And. xEst <> 'PE'
            aadd(aPerf,{'C00000'})
            aadd(aPerf,{'C00006'})
            aadd(aPerf,{'C00012'})
            aadd(aPerf,{'C00013'})
            fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
        ElseIf xTipo == 'F' .And. xContri == '1' .And. xEst == 'PE'
            aadd(aPerf,{'C00006'})
            aadd(aPerf,{'C00012'})
            aadd(aPerf,{'C00015'})
            fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
        EndIf
        If xTipo == 'R' .And. xContri == '1'
            If xEst == 'PE'
                aadd(aPerf,{'C00001'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00006'})
                aadd(aPerf,{'C00012'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            ElseIf xEst == 'AM' .And. xCodMun $ "02603#03569#03536" .And. !Empty(xSufr)     
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00004'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            ElseIf xEst == 'RR' .And. xCodMun $ "00100#00159" .And. xSimples == '2'
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00007'})
                aadd(aPerf,{'C00009'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            ElseIf xEst $ "RO#AC#AM#AP" .And. xCodMun $ "00106#00104#00252#00203#04062#00303#00600" .And. xSimples == '2'
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00008'})
                aadd(aPerf,{'C00009'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            ElseIf xEst $ "RO#AC#AM#AP" .And. xCodMun $ "00100#00159#00106#00104#00252#00203#04062#00303#00600" .And. xSimples == '1'
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00003'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00009'})
                aadd(aPerf,{'C00012'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            ElseIf xEst $ "AM#AC#RO#RR" .And. !xCodMun $ "00100#00159#00106#00104#00252#00203#04062#00303#00600#02603#03569#03536"
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00003'})
                aadd(aPerf,{'C00010'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            Else //A1_TIPO = 'F' A1_CONTRIB = '1' A1_EST <> 'PE' grava esse condição
                aadd(aPerf,{'C00002'})
                aadd(aPerf,{'C00005'})
                aadd(aPerf,{'C00006'})
                aadd(aPerf,{'C00012'})
                aadd(aPerf,{'C00013'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            EndIf
            If xEst == 'EX' .And. xPais <> '105'
                aadd(aPerf,{'C00011'})
                fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',4)
            EndIf
        EndIf
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
Static Function fDeletPerf(xClieFor,xLoja)

    Local xQuery := ""
    Local xAlias := GetNextAlias()
    Local aPerf  := {}

    xQuery := "SELECT F22_CODIGO FROM "+RetSqlName("F22")+ " " + chr(13)
    xQuery += "WHERE F22_FILIAL = '" +FwxFilial("F22")+ "' " + chr(13) 
    xQuery += "AND F22_CLIFOR = '" + xClieFor + "' " + chr(13)
    xQuery += "AND F22_LOJA = '" + xLoja + "' " + chr(13)
    xQuery += "AND F22_TPPART = '2' " + chr(13)
    xQuery += "AND D_E_L_E_T_ = ' ' "

    MpSysOpenQuery(xQuery,xAlias)

    (xAlias)->(dbGoTop())

    While !(xAlias)->(Eof())

        aadd(aPerf,{(xAlias)->F22_CODIGO})

    (xAlias)->(dbSkip())
    
    EndDo

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Envia para excluir o registro, tipo 5                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aPerf) > 0
        fExecAutoConf(xClieFor,xLoja,aPerf,'02','2',5)
    EndIf 

Return 
