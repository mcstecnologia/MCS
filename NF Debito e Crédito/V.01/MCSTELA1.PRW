//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//Legendas da rotina TES X CFOP
Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
Static oBmpVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")
 
/*/{Protheus.doc} MCSTELA1
Tela MVC com mark browse
@type function
@version  
@author MCS Tecnologia
@since 5/4/2026
@return variant, return_description
/*/
User Function MCSTELA1()

    Local xTabela     := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local xCampo      := ""
    Private oMark
     
    //Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias(xTabela)
     
    //Setando semáforo, descrição e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription('Monitor - Notas Débito e Crédito')
    oMark:SetFieldMark( xTabela+"_DKN" )

    xCampo := xTabela+"_NFEOK" 
     
    //Setando Legenda
    oMark:AddLegend( xCampo+" == 'N' .And. "+xTabela+"_TPNOTA == '4' ", "GREEN",   "NF Tipo 4 Não Gerada" )
    oMark:AddLegend( xCampo+" == 'N' .And. "+xTabela+"_TPNOTA == '3' ", "PINK",    "NF Tipo 3 Não Gerada" )
    oMark:AddLegend( xCampo+" == 'S' ", "RED",    "NF Gerada" )

     
    //Ativando a janela
    oMark:Activate()

Return NIL
 

/*/{Protheus.doc} MenuDef
MenuDef
@type function
@version  
@author MCS Tecnologia
@since 5/4/2026
@return variant, return_description
/*/  
Static Function MenuDef()

    Local aRotina := {}
     
    //Criação das opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MCSTELA1' OPERATION 2 ACCESS 0
    //ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MCSMODEL' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Gerar Nota' ACTION 'U_MCSGERA'       OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'TES x CFOP' ACTION 'U_MCSTES'       OPERATION 2 ACCESS 0
    //ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 2 ACCESS 0
Return aRotina
 

/*/{Protheus.doc} ModelDef
ModelDef
@type function
@version  
@author MCS Tecnologia
@since 5/4/2026
@return variant, return_description
/*/  
Static Function ModelDef()

    Local oModel    := Nil
    Local xTabela   := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local oStr      := FWFormStruct(1, xTabela)
     
    oModel := MPFormModel():New("XMCSTELA1",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    oModel:AddFields("MCSFORM",/*cOwner*/,oStr)

    oModel:SetPrimaryKey({xTabela+'_FILIAL',xTabela+'_ID'})
     
    oModel:SetDescription("Monitor - Notas Débito e Crédito")
     
    oModel:GetModel("MCSFORM"):SetDescription("Monitor - Notas Débito e Crédito")

Return oModel
 
/*/{Protheus.doc} ViewDef
ViewDef
@type function
@version  
@author MCS Tecnologia
@since 5/4/2026
@return variant, return_description
/*/
Static Function ViewDef()

    Local oModel    := FWLoadModel("MCSTELA1")
    Local xTabela   := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local oStr      := FWFormStruct(2, xTabela)  
    Local oView     := Nil
 
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_MCS", oStr, "MCSFORM")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_MCS', 'Registros para geração notas débito/crédito' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_MCS","TELA")

Return oView
 
/*/{Protheus.doc} MCSTES
Monta dela para realizar o De/Para TES x CFOP
@type function
@version  
@author MCS Tecnologia
@since 5/4/2026
@return variant, return_description
/*/ 
User Function MCSTES()

    Local aArea     := GetArea()
    Local xTabela   := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP

    Private oDlgPvt
    Private oMsGet
    Private aHead := {}
    Private aColsTab := {}
    Private oBtnSalv
    Private oBtnFech
    Private oBtnLege
    Private nJanLarg    := 700
    Private nJanAltu    := 500
    Private cFontUti   := "Tahoma"
    Private oFontAno   := TFont():New(cFontUti,,-38)
    Private oFontSub   := TFont():New(cFontUti,,-20)
    Private oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private oFontBtn   := TFont():New(cFontUti,,-14)
     
    //aAdd(aHead, {""                 , "XX_COR",    "@BMP"                                   , 002,                        0,             ".F.",    "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHead, {"Filial"           , FwCodFil()       , ""                                   , TamSX3("F4_FILIAL")[01],    0,                ".T."         ,".T.", "C", "",    ""} )
    aAdd(aHead, {"TES"              , xTabela+"_TES"   , ""                                   , TamSX3("F4_CODIGO")[01],    0,                ""            ,".T.", "C", "",    ""} )
    aAdd(aHead, {"CFOP"             , xTabela+"_CFOP"  , ""                                   , TamSX3("F4_CF")[01]    ,    0,                ""            ,".T.", "C", "",    ""} )
    aAdd(aHead, {"Bloqueado"        , xTabela+"_BLQL"  , ""                                   , TamSX3(xTabela+"_BLQL")[01],0,                ""            ,".T.", "C", "",    ""} )
    aAdd(aHead, {"Recno"            , "XX_RECNO"       ,  "@E 999,999,999,999,999,999"        ,  018,                       0,                ".T."         ,".T.", "N", "",    ""} )
 
    Processa({|| fGravaAcols()}, "Processando")
 
    DEFINE MSDIALOG oDlgPvt TITLE "Tes X Cfop - Nota de Débito/Crédito" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

        //@ 004, 003 SAY "MCS"                SIZE 200, 030 FONT oFontAno  OF oDlgPvt COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Cadastro de"        SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Tes x CFOP"         SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL
         
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgPvt ACTION (oDlgPvt:End())                               FONT oFontBtn PIXEL
        //@ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Legenda"       SIZE 050, 018 OF oDlgPvt ACTION (fMcsLegen())                                  FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*03) BUTTON oBtnSalv  PROMPT "Salvar"        SIZE 050, 018 OF oDlgPvt ACTION (fMcsSalva())                                   FONT oFontBtn PIXEL
         
        oMsGet := MsNewGetDados():New(      029,;                //nTop      - Linha Inicial
                                            003,;                //nLeft     - Coluna Inicial
                                            (nJanAltu/2)-3,;     //nBottom   - Linha Final
                                            (nJanLarg/2)-3,;     //nRight    - Coluna Final
                                            GD_INSERT + GD_UPDATE + GD_DELETE,;                   //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
                                            "AllwaysTrue()",;    //cLinhaOk  - Validação da linha
                                            ,;                   //cTudoOk   - Validação de todas as linhas
                                            "",;                 //cIniCpos  - Função para inicialização de campos
                                            ,;                   //aAlter    - Colunas que podem ser alteradas
                                            ,;                   //nFreeze   - Número da coluna que será congelada
                                            9999,;               //nMax      - Máximo de Linhas
                                            ,;                   //cFieldOK  - Validação da coluna
                                            ,;                   //cSuperDel - Validação ao apertar '+'
                                            ,;                   //cDelOk    - Validação na exclusão da linha
                                            oDlgPvt,;            //oWnd      - Janela que é a dona da grid
                                            aHead,;              //aHeader   - Cabeçalho da Grid
                                            aColsTab)            //aCols     - Dados da Grid
         
    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    RestArea(aArea)

Return
 
/*/{Protheus.doc} fGravaAcols
Query para carregamento do aCols
@type function
@version  
@author rodri
@since 5/15/2026
@return variant, return_description
/*/
Static Function fGravaAcols()

    Local xTabela   := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP
    Local aArea     := GetArea()
    Local xQuery    := ""
    Local xAlias    := GetNextAlias()
    Local nAtual    := 0
    Local nTotal    := 0
    Local oBmpAux
   
    xQuery := "SELECT "+xTabela+"_FILIAL AS FILIAL, "+xTabela+"_TES AS TES, "+xTabela+"_CFOP AS CF, "+xTabela+"_BLQL AS BLQ, R_E_C_N_O_ AS RECNO " + chr(13)
    xQuery += "FROM " +RetSqlName(xTabela) + " " + chr(13)
    xQuery += "WHERE "+xTabela+"_FILIAL = '" + FwxFilial(xTabela) + "' " + chr(13)
    xQuery += "AND D_E_L_E_T_ = ' ' "

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())
     
    (xAlias)->(DbGoTop())
    While !(xAlias)->(EoF())
     
        /*If (xAlias)->BLQ == '1'
            oBmpAux := oBmpVermelho
         
        ElseIf (xAlias)->BLQ == '0'"
            oBmpAux := oBmpVerde 
        EndIf*/
         
        //Adiciona o item no aCols
        /*aAdd(aColsTab, { ;
            oBmpAux,;
            (xAlias)->FILIAL,;
            (xAlias)->TES,;
            (xAlias)->CF,;
            (xAlias)->BLQ,;
            (xAlias)->RECNO,;
            .F.;
        })*/
        aAdd(aColsTab, { ;
            (xAlias)->FILIAL,;
            (xAlias)->TES,;
            (xAlias)->CF,;
            (xAlias)->BLQ,;
            (xAlias)->RECNO,;
            .F.;
        })
         
        (xAlias)->(DbSkip())
    EndDo
    (xAlias)->(DbCloseArea())
     
    RestArea(aArea)

Return
 
/*/{Protheus.doc} fMcsLegen
Legenda
@type function
@version  
@author MCS Tecnologia
@since 5/15/2026
@return variant, return_description
/*/
Static Function fMcsLegen()

    Local aLegenda := {}
     
    aAdd(aLegenda, {"BR_PRETO",    "Sem Classificação"})    
    aAdd(aLegenda, {"BR_VERDE",    "Original"})
    aAdd(aLegenda, {"BR_VERMELHO", "Não Original"})
     
    BrwLegenda("Grupo de Produtos", "Legenda", aLegenda)
Return
 
/*/{Protheus.doc} fMcsSalva
Salva o conteudo da rotina
@type function
@version  
@author MCS Tecnologia
@since 5/15/2026
@return variant, return_description
/*/
Static Function fMcsSalva()

    Local xTabela  := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP
    Local aColsAux := oMsGet:aCols
    Local nPosFil  := aScan(aHead, {|x| Alltrim(x[2]) == xTabela+"_FILIAL"})
    Local nPosTes  := aScan(aHead, {|x| Alltrim(x[2]) == xTabela+"_TES"})
    Local nPosCfo  := aScan(aHead, {|x| Alltrim(x[2]) == xTabela+"_CFOP"})
    Local nPosBlq  := aScan(aHead, {|x| Alltrim(x[2]) == xTabela+"_BLQL"})
    Local nPosRec  := aScan(aHead, {|x| Alltrim(x[2]) == "XX_RECNO"})
    Local nPosDel  := Len(aHead) + 1
    Local nLinha   := 0
    
     
    DbSelectArea(xTabela)
     
    //Percorrendo todas as linhas
    For nLinha := 1 To Len(aColsAux)
     
        //Posiciona no registro
        If aColsAux[nLinha][nPosRec] != 0
            (xTabela)->(DbGoTo(aColsAux[nLinha][nPosRec]))
        EndIf
         
        //Se a linha estiver excluída
        If aColsAux[nLinha][nPosDel]
             
            //Se não for uma linha nova
            If aColsAux[nLinha][nPosRec] != 0
             
                //Se não tiver produtos, ai prossegue com exclusão
                RecLock(xTabela, .F.)
                    DbDelete()
                (xTabela)->(MsUnlock())
                 
            EndIf
             
        //Se a linha for incluída
        ElseIf aColsAux[nLinha][nPosRec] == 0
            RecLock(xTabela, .T.)
                &(xTabela+"->"+xTabela+"_FILIAL") := aColsAux[nLinha][nPosFil]
                &(xTabela+"->"+xTabela+"_TES")    := aColsAux[nLinha][nPosTes]
                &(xTabela+"->"+xTabela+"_CFOP")   := aColsAux[nLinha][nPosCfo]
                &(xTabela+"->"+xTabela+"_BLQL")   := aColsAux[nLinha][nPosBlq]
            (xTabela)->(MsUnlock())
             
        //Senão, será alteração
        Else
            RecLock(xTabela, .F.)
                &(xTabela+"->"+xTabela+"_TES")    := aColsAux[nLinha][nPosTes]
                &(xTabela+"->"+xTabela+"_CFOP")   := aColsAux[nLinha][nPosCfo]
                &(xTabela+"->"+xTabela+"_BLQL")   := aColsAux[nLinha][nPosBlq]
            (xTabela)->(MsUnlock())
        EndIf
         
    Next
     
    MsgInfo("Gravação efetuada com sucesso!", "Sucesso")

    oDlgPvt:End()


Return

/*/{Protheus.doc} FVALCFOP
Valida se o CFOP existe no de/para
@type function
@version  
@author rodri
@since 6/5/2026
@param xCf, variant, param_description
@return variant, return_description
/*/
User Function FVALCFOP(xCf)

    Local lRet := .T.
    Local xTabela   := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP
	Local aArea 	:= (xTabela)->(GetArea(xTabela))

	(xTabela)->(dbSelectArea(xTabela))
	(xTabela)->(dbSetOrder(2))

	If (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("5"+xCf),.F.)) .Or. (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("6"+xCf),.F.));
		.Or. (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("7"+xCf),.F.))
		xTes := &(xTabela+"->"+xTabela+"_TES")
        lRet := .F.
	EndIf

	RestArea(aArea)


Return lRet

/*/{Protheus.doc} fGatTes
Gatilho para preenchimento do CFOP
@type function
@version  
@author rodri
@since 6/5/2026
@return variant, return_description
/*/
User Function fGAtCFOP()

    Local aArea     := SF4->(GetArea())
    Local xTabela   := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP

    SF4->(dbSelectArea("SF4"))
    SF4->(dbSetOrder(1))

    xTes := M->&(xTabela+"_TES")

    If SF4->(dbSeek(xFilial("SF4") + xTes, .F.))
        xCf := SF4->F4_CF
    EndIf    

    FwRestArea(aArea)
    
Return xCf
