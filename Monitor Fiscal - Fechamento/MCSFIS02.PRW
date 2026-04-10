#include "protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "FWEditPanel.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FISA168()

Esta rotina tem objetivo de realizar cadastro dos tributos

Esta rotina estará disponível somente na versão 12.

@author joao.pellegrini
@since 11/09/2018
@version 12.1.17
/*/
//-------------------------------------------------------------------
User Function MCSFIS02()

    Local  oBrowse := Nil
    Local  xTabela1 := SuperGetMV("MX_XTABFIS",.F.,"WZA")
    Local  xTabela2 := SuperGetMV("MX_XTABFIS",.F.,"WZB")


    //Verifico se as tabelas existem antes de prosseguir
    IF AliasIndic(xTabela1) .And. AliasIndic(xTabela2)
        oBrowse := FWMBrowse():New()
        oBrowse:SetAlias(xTabela1)
        oBrowse:SetDescription("Cadastro de Cenário") // Cadastro de Tributos
        oBrowse:Activate()
    Else
        Help("",1,"Help","Help","Dicionário não atualizado, verifique as tabelas envolvidas no processo ou rode UPD",1,0) // Dicionário desatualizado, verifique as atualizações do motor tributário fiscal.
    EndIf

Return

/*/{Protheus.doc} MenuDef
Criação do menu
@type function
@version  
@author rodri
@since 3/27/2026
@return variant, return_description
/*/
Static Function MenuDef()

    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MCSFIS02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_MCSINC01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MCSFIS02' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MCSFIS02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*/{Protheus.doc} ModelDef
Criaçao do modelo
@type function
@version  
@author rodri
@since 3/27/2026
@return variant, return_description
/*/
Static Function ModelDef()

    Local  xTabela1 := SuperGetMV("MX_XTABFIS",.F.,"WZA")
    Local oModel := Nil
     
    Local oStruct := FWFormStruct(1, xTabela1)
     
    oModel := MPFormModel():New("MCSFIS02A",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    oModel:AddFields("MCSFIS02",/*cOwner*/,oStruct)
     
    oModel:SetPrimaryKey({xTabela1+'_FILIAL',''+xTabela1+'_ID'})
     
    oModel:SetDescription("Cadastro de Cenário")
     
    oModel:GetModel("MCSFIS02"):SetDescription("Cenário")

Return oModel
 
/*/{Protheus.doc} ViewDef
criação da visão
@type function
@version  
@author rodri
@since 3/27/2026
@return variant, return_description
/*/
Static Function ViewDef()

    Local oModel := FWLoadModel("MCSFIS02")
    Local  xTabela1 := SuperGetMV("MX_XTABFIS",.F.,"WZA")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStruct := FWFormStruct(2, xTabela1)  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
     
    Local oView := Nil

    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    oView:AddField("VIEW_"+xTabela1, oStruct, "MCSFIS02")
     
    oView:CreateHorizontalBox("TELA",100)
     
    oView:EnableTitleView('VIEW_'+xTabela1, 'Cenários gerados' )  
     
    oView:SetCloseOnOk({||.T.})
     
    oView:SetOwnerView("VIEW_"+xTabela1,"TELA")

Return oView
 

/*/{Protheus.doc} zMVC01Leg
Legenda
@type function
@version  
@author rodri
@since 3/27/2026
@return variant, return_description
/*/ 
User Function zMVC01Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Original"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Não Original"})
     
    BrwLegenda("Grupo de Produtos", "Procedencia", aLegenda)
Return

/*/{Protheus.doc} MCSINC01
Inclusão da regra 
@type function
@version  
@author rodri
@since 3/27/2026
@return variant, return_description
/*/
User Function MCSINC01()


    Local oGet1
    Local cGet1 := ""
    Local oGet2
    Local cGet2 := ""
    Local oGroup1
    Local oSay1
    Local oSay2
    Local oSay3
    Static oDlg

    DEFINE MSDIALOG oDlg TITLE "Configuração de Cenário" FROM 000, 000  TO 800, 1200 COLORS 0, 16777215 PIXEL

        @ 008, 006 GROUP oGroup1 TO 394, 591 PROMPT "Criação de Cenário" OF oDlg COLOR 0, 16777215 PIXEL
        @ 025, 105 SAY oSay1 PROMPT "Descrição" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 024, 139 MSGET oGet1 VAR cGet1 SIZE 424, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 025, 019 SAY oSay2 PROMPT "Código:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 024, 040 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 061, 020 SAY oSay3 PROMPT "Tributos" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return
