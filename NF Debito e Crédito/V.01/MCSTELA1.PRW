//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'
 
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



Return
