#INCLUDE "PROTHEUS.CH"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} MCSCONF
Tela para montagem da regra
@type function
@version  
@author MCS Tecnologia
@since 12/26/2025
@return variant, return_description
/*/
User Function MCSCONF()

    Local oBrowse     := Nil

    Private xAliasZZW := "ZZW" //Alias da tabela de parametros
    Private zAliasZZY := "ZZY" //Alias da tabela de configuração dos retornos
    Private aRotina   := MenuDef()

    //Criando as tabelas
    ChkFile("ZZW")
	ChkFile("ZZY")

    dbSelectArea("ZZW")
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZZW")
	oBrowse:SetDescription( "Configurador das regras por perfil - Configurador de tributos" ) 
    
    oBrowse:Activate()
 
Return 

/*/{Protheus.doc} MenuDef
description
@type function
@version  
@author MCS Tecnologia
@since 12/26/2025
@return variant, return_description
/*/
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("MCSCONF")

    //Adicionando opcoes do menu
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MCSCONF" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MCSCONF" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MCSCONF" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MCSCONF" OPERATION 5 ACCESS 0

Return (aRotina)

/*/{Protheus.doc} ModelDef
Regras de negocio do MVC
@type function
@version  
@author MCS Tecnologia
@since 12/26/2025
@return variant, return_description
/*/
Static Function ModelDef()
    
    Local oModel 
    Local oStruA      := FwFormStruct(1, "ZZW")
    Local oStruB      := FWFormStruct(1, "ZZY") 
    Local cRelacB   := ""
    Local cRelacC   := ""
    Local cRelacD   := ""
    Local cRelacE   := ""
    Local aRelacB	:= {}
    Local cParMast  := "ZZWMASTER"
    Local cEnvDeta  := "ZZYDETAIL"   

    //Montando a string para relação das tabelas
    cRelacB := 'xFilial("ZZY")'

    //Obtendo a estrura das tabelas
    oStruA := FWFormStruct( 1, 'ZZW' , /* bAvalCampo */, /* lViewUsado */ )
    oStruB := FWFormStruct( 1, 'ZZY' , /* bAvalCampo */, /* lViewUsado */ )

    // DEFINE O SUBMODELO COMO FIELD
    oModel := MPFormModel():New("MCSCONFA")
    oModel:AddFields('ZZWMASTER', NIL, oStruA)

    oStruA:SetProperty('ZZW_ALIAS',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruA:SetProperty('ZZW_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZW", "ZZW_COD")'))


    // Adiciona ao modelo uma estrutura de formul?io de edi?o por grid
    oModel:AddGrid( 'ZZYDETAIL'		, 'ZZWMASTER'	, oStruB, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

    //Relacionamento da tabela 
    aAdd(aRelacB,{ oStruB:aFields[1][3]	, cRelacB	})

    // Faz relaciomaneto entre os compomentes do model
    oModel:SetRelation("ZZYDETAIL", {{"ZZY_FILIAL", "FwXFilial('ZZY')"}, {"ZZY_COD", "ZZW_COD"}}, ZZY->(IndexKey( 1 )))
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Configuração regras")

    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZZWMASTER' ):SetDescription("Montagem da regra") 
    oModel:GetModel( 'ZZYDETAIL' ):SetDescription( "Perfis realcionados" ) 

    oModel:SetPrimaryKey({oStruA:aFields[1][3]})

Return (oModel)

/*/{Protheus.doc} ViewDef
Função para criação da view
@type function
@version  
@author MCS Tecnologia
@since 12/26/2025
@return variant, return_description
/*/
Static Function ViewDef()

    // RECEBE O MODELO DE DADOS
    Local oStruB      := FWFormStruct(2, 'ZZY', {|x| Alltrim(x) + ";" $ "ZZY_CODPER;ZZY_DESC"})
    Local oStruA      := FwFormStruct(2, 'ZZW')
    /*Local oStruC      := FWFormStruct(2, cAliasDep)
    Local oStruD      := FWFormStruct(2, cAliasRet)
    Local oStruE      := FwFormStruct(2, cAliasDoc)*/
    Local oModel      := FwLoadModel("MCSCONF")
    Local oView       := Nil
    Local cParMast    := "ZZWMASTER"
    Local cEnvDeta    := "ZZYDETAIL"  

    oStruB:SetProperty("ZZY_CODPER", MVC_VIEW_LOOKUP, {|| McsF3()})
    // INDICA O MODELO DA VIEW
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("VIEW_ZZW", oStruA, cParMast)

    If McsF3() == 'F20PAR'
        oStruA:SetProperty('ZZW_CONTRI',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    EndIf    

    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
    oView:AddGrid( "VIEW_ZZY", oStruB, cEnvDeta )

    // Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR' , 60 )
    oView:CreateHorizontalBox( 'INFERIOR' , 40 )
  
    //Cria o controle de Abas
    oView:CreateFolder( 'PASTA_SUPERIOR' ,'SUPERIOR' )
    oView:CreateFolder( 'PASTA_INFERIOR','INFERIOR' )
    // Cria pastas nas folders
    oView:AddSheet('PASTA_SUPERIOR', 'ABA_INI',  'Parâmetros para configuração')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_PRIN', 'Perfis realcionados')

    //Cria os Box que serão vinculados as abas
    oView:CreateHorizontalBox( 'PARAMETRO' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_SUPERIOR', 'ABA_INI')
    oView:CreateHorizontalBox( 'PERFIS' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_PRIN')

    //Amarra as Abas aos Views de Struct criados
    oView:SetOwnerView('VIEW_ZZW','PARAMETRO')
    oView:SetOwnerView('VIEW_ZZY','PERFIS')

    // Liga a identificacao do componente
    oView:EnableTitleView("VIEW_ZZY","Perfis")


Return (oView)
/*/{Protheus.doc} McsF3
Consulta F3
@type function
@version  
@author MCS Tecnologia
@since 12/29/2025
@return variant, return_description
/*/
Static Function McsF3()

    Local oModel    := FwModelActive()
    Local oModZZW   := oModel:GetModel("ZZWMASTER")
    Local xTab      := Upper(oModZZW:GetValue("ZZW_ALIAS"))
    Local xConsulta := ""
  
    //Se usado SB1, gatilha a consulta padrão do perfil de produto, senão de participante
    If Left(xTab, 1) == "3"
        xConsulta := "F20PRD"
    Else
        xConsulta := "F20PAR"
    EndIf
  
Return xConsulta


