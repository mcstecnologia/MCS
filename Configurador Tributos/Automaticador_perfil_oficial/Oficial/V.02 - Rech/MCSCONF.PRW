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

    Private xAliasZM6 := "ZM6" //Alias da tabela de parametros
    Private zAliasZM7 := "ZM7" //Alias da tabela de configuração dos retornos
    Private aRotina   := MenuDef()

    //Criando as tabelas
    ChkFile("ZM6")
	ChkFile("ZM7")
    ChkFile("ZM8")
    ChkFile("ZM9")
    ChkFile("ZMB")
    ChkFile("ZMC")
    ChkFile("ZMA")
    ChkFile("ZMD")
    ChkFile("ZME")
    ChkFile("ZMF")

    dbSelectArea("ZM6")
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZM6")
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
    ADD OPTION aRotina TITLE "Cadastro S/ Relação com Perfil" ACTION "U_MCSTRIBR" OPERATION 1 ACCESS 0
    //ADD OPTION aRotina TITLE "Associar a Perfil" ACTION "U_MCSTRIBA" OPERATION 1 ACCESS 0

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
    Local oStruA      := FwFormStruct(1, "ZM6")
    Local oStruB      := FWFormStruct(1, "ZM7") 
    Local oStruC      := FWFormStruct(1, "ZM8") 
    Local oStruD      := FWFormStruct(1, "ZM9")
    Local oStruE      := FWFormStruct(1, "ZMB") 
    Local oStruF      := FWFormStruct(1, "ZMC") 
    Local oStruG      := FWFormStruct(1, "ZMA")
    Local oStruH      := FWFormStruct(1, "ZMD")
    Local oStruI      := FWFormStruct(1, "ZME")
    Local oStruj      := FWFormStruct(1, "ZMF")
    Local cRelacB   := ""
    Local cRelacC   := ""
    Local cRelacD   := ""
    Local cRelacE   := ""
    Local cRelacF   := ""
    Local cRelacG   := ""
    Local cRelacH   := ""
    Local cRelacI   := ""
    Local aRelacB	:= {}
    Local aRelacC	:= {}
    Local aRelacD	:= {}
    Local aRelacE	:= {}
    Local aRelacF	:= {}
    Local aRelacG	:= {}
    Local aRelacH	:= {}
    Local aRelacI	:= {}
    Local aRelacJ	:= {}
    Local aGat      := {}
    Local aGat1     := {}
    Local aGat2     := {}
    Local aGat3     := {}
    Local aGat4     := {}
    Local bVldPos   := {|| U_ValReg01()} //Validação ao clicar no Confirmar

    //Montando a string para relação das tabelas
    cRelacB := 'xFilial("ZM7")'
    cRelacC := 'xFilial("ZM8")'
    cRelacD := 'xFilial("ZM9")'
    cRelacE := 'xFilial("ZMB")'
    cRelacF := 'xFilial("ZMC")'
    cRelacG := 'xFilial("ZMA")'
    cRelacH := 'xFilial("ZMD")'
    cRelacI := 'xFilial("ZME")'
    cRelacJ := 'xFilial("ZMF")'

    //Obtendo a estrura das tabelas
    oStruA := FWFormStruct( 1, 'ZM6' , /* bAvalCampo */, /* lViewUsado */ )
    oStruB := FWFormStruct( 1, 'ZM7' , /* bAvalCampo */, /* lViewUsado */ )
    oStruC := FWFormStruct( 1, 'ZM8' , /* bAvalCampo */, /* lViewUsado */ )
    oStruD := FWFormStruct( 1, 'ZM9' , /* bAvalCampo */, /* lViewUsado */ )
    oStruE := FWFormStruct( 1, 'ZMB' , /* bAvalCampo */, /* lViewUsado */ )
    oStruF := FWFormStruct( 1, 'ZMC' , /* bAvalCampo */, /* lViewUsado */ )
    oStruG := FWFormStruct( 1, 'ZMA' , /* bAvalCampo */, /* lViewUsado */ )
    oStruH := FWFormStruct( 1, 'ZMD' , /* bAvalCampo */, /* lViewUsado */ )
    oStruI := FWFormStruct( 1, 'ZME' , /* bAvalCampo */, /* lViewUsado */ )
    oStruJ := FWFormStruct( 1, 'ZMF' , /* bAvalCampo */, /* lViewUsado */ )

    // DEFINE O SUBMODELO COMO FIELD
    oModel := MPFormModel():New("MCSCONFA", /*bVldPre*/, bVldPos,/*bVldCom*/, /*bVldCan*/)
    oModel:AddFields('ZM6MASTER', NIL, oStruA)

    oStruA:SetProperty('ZM6_ALIAS'    , MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZM6_DESC'     , MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZM6_COD'      , MODEL_FIELD_OBRIGAT, .T. )
    oStrua:SetProperty('ZM6_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))
    oStruA:SetProperty('ZM6_ALIAS'    , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))
    oStruB:SetProperty('ZM7_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruC:SetProperty('ZM8_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruD:SetProperty('ZM9_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruE:SetProperty('ZMB_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruF:SetProperty('ZMC_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruG:SetProperty('ZMA_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruH:SetProperty('ZMD_COD'      , MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruA:SetProperty('ZM6_CONTRI'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_TIPPAR'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_TIPPAR'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENFOR()'))
    oStruA:SetProperty('ZM6_SUFRAM'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_SIMPLE'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    //oStruA:SetProperty('ZM6_REGRA1'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_REGRA2'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_REGRA3'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_REGRA4'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty('ZM6_REGRA5'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty('ZM6_REGRA6'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty('ZM6_REGRA7'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty('ZM6_REGRA8'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))

    //Defini campos que não serão copiados
    oModel:GetModel("ZM6MASTER"):SetFldNoCopy({"ZM6_COD"})

    //Gatilhos
    aGat := FwStruTrigger("ZM9_CODMUN","ZM9_DESC",'Posicione("CC2",1,xFilial("CC2") + M->ZM9_EST+M->ZM9_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruD:AddTrigger(aGat[1],aGat[2],aGat[3],aGat[4])

    aGat1:= FwStruTrigger("ZMA_CODMUN","ZMA_DESC",'Posicione("CC2",1,xFilial("CC2") + M->ZMA_UF+M->ZMA_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruG:AddTrigger(aGat1[1],aGat1[2],aGat1[3],aGat1[4]) 

    aGat2:= FwStruTrigger("ZMB_EST","ZMB_DESC",'U_GATPER("2")',.F.,,,)
	oStruE:AddTrigger(aGat2[1],aGat2[2],aGat2[3],aGat2[4])

    aGat3:= FwStruTrigger("ZM7_CODPER","ZM7_DESC",'U_GATPER("1")',.F.,,,)
	oStruB:AddTrigger(aGat3[1],aGat3[2],aGat3[3],aGat3[4])

    aGat4:= FwStruTrigger("ZME_ORIGEM","ZME_DESC",'U_GATPER("3")',.F.,,,)
	oStruI:AddTrigger(aGat4[1],aGat4[2],aGat4[3],aGat4[4])

    //oStruA:SetProperty('ZM6_COD',MODEL_FIELD_VALID,FWBuildFeature(STRUCT_FEATURE_VALID,"ExistChav( 'ZM6', FWFldGet('ZM6_COD'))" ))
    oStruB:SetProperty('ZM7_CODPER',MODEL_FIELD_VALID,FWBuildFeature(STRUCT_FEATURE_VALID,"ExistCpo('F20',+FWFldGet('ZM7_CODPER'))"))

    // Adiciona ao modelo uma estrutura de formul?io de edi?o por grid
    oModel:AddGrid( 'ZM7DETAIL'     , 'ZM6MASTER'   , oStruB, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZM8DETAIL'		, 'ZM6MASTER'	, oStruC, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZM9DETAIL'		, 'ZM6MASTER'	, oStruD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMBDETAIL'		, 'ZM6MASTER'	, oStruE, /*bLinePre*/, /*bLinePost, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMCDETAIL'		, 'ZM6MASTER'	, oStruF, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMADETAIL'		, 'ZM6MASTER'	, oStruG, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMDDETAIL'		, 'ZM6MASTER'	, oStruH, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMEDETAIL'		, 'ZM6MASTER'	, oStruI, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZMFDETAIL'		, 'ZM6MASTER'	, oStruJ, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

    //Relacionamento da tabela 
    aAdd(aRelacB,{ oStruB:aFields[1][3]	, cRelacB	})
    aAdd(aRelacC,{ oStruC:aFields[1][3]	, cRelacC	})
    aAdd(aRelacD,{ oStruD:aFields[1][3]	, cRelacB	})
    aAdd(aRelacE,{ oStruE:aFields[1][3]	, cRelacB	})
    aAdd(aRelacF,{ oStruF:aFields[1][3]	, cRelacB	})
    aAdd(aRelacG,{ oStruG:aFields[1][3]	, cRelacB	})
    aAdd(aRelacH,{ oStruH:aFields[1][3]	, cRelacB	})
    aAdd(aRelacI,{ oStruI:aFields[1][3]	, cRelacB	})
    aAdd(aRelacJ,{ oStruJ:aFields[1][3]	, cRelacB	})

    // Faz relaciomaneto entre os compomentes do model
    oModel:SetRelation("ZM7DETAIL", {{"ZM7_FILIAL", "FwXFilial('ZM7')"}, {"ZM7_COD", "ZM6_COD"}}, ZM7->(IndexKey( 1 )))
    oModel:SetRelation("ZM8DETAIL", {{"ZM8_FILIAL", "FwXFilial('ZM8')"}, {"ZM8_COD", "ZM6_COD"}}, ZM8->(IndexKey( 1 )))
    oModel:SetRelation("ZM9DETAIL", {{"ZM9_FILIAL", "FwXFilial('ZM9')"}, {"ZM9_COD", "ZM6_COD"}}, ZM9->(IndexKey( 1 )))
    oModel:SetRelation("ZMBDETAIL", {{"ZMB_FILIAL", "FwXFilial('ZMB')"}, {"ZMB_COD", "ZM6_COD"}}, ZMB->(IndexKey( 1 )))
    oModel:SetRelation("ZMCDETAIL", {{"ZMC_FILIAL", "FwXFilial('ZMC')"}, {"ZMC_COD", "ZM6_COD"}}, ZMC->(IndexKey( 1 )))
    oModel:SetRelation("ZMADETAIL", {{"ZMA_FILIAL", "FwXFilial('ZMA')"}, {"ZMA_COD", "ZM6_COD"}}, ZMA->(IndexKey( 1 )))
    oModel:SetRelation("ZMDDETAIL", {{"ZMD_FILIAL", "FwXFilial('ZMD')"}, {"ZMD_COD", "ZM6_COD"}}, ZMD->(IndexKey( 1 )))
    oModel:SetRelation("ZMEDETAIL", {{"ZME_FILIAL", "FwXFilial('ZME')"}, {"ZME_COD", "ZM6_COD"}}, ZME->(IndexKey( 1 )))
    oModel:SetRelation("ZMFDETAIL", {{"ZMF_FILIAL", "FwXFilial('ZMF')"}, {"ZMF_COD", "ZM6_COD"}}, ZMF->(IndexKey( 1 )))
 
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Configuração regras")

    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZM6MASTER' ):SetDescription("Montagem da regra") 
    oModel:GetModel( 'ZM7DETAIL' ):SetDescription( "Perfis relacionados" )
    oModel:GetModel( 'ZM8DETAIL' ):SetDescription( "Suframa" )
    oModel:GetModel( 'ZM9DETAIL' ):SetDescription( "Município Igual (==)" )
    oModel:GetModel( 'ZMADETAIL' ):SetDescription( "Município Diferente (<>)" )
    oModel:GetModel( 'ZMBDETAIL' ):SetDescription( "Uf" )
    oModel:GetModel( 'ZMCDETAIL' ):SetDescription( "NCM Iguais (==)" )
    oModel:GetModel( 'ZMDDETAIL' ):SetDescription( "NCM Diferentes (<>)" )
    oModel:GetModel( 'ZMEDETAIL' ):SetDescription( "Origem Produto" )
    oModel:GetModel( 'ZMFDETAIL' ):SetDescription( "Tipo Produto" )

    oModel:SetPrimaryKey({oStruA:aFields[1][3]})

    //oModel:GetModel("ZM7DETAIL"):SetOptional(.T.)
    oModel:GetModel("ZM8DETAIL"):SetOptional(.T.)
    oModel:GetModel("ZM9DETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMBDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMCDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMADETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMDDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMEDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZMFDETAIL"):SetOptional(.T.)


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
    Local oStruA      := FwFormStruct(2, 'ZM6')
    Local oStruB      := FWFormStruct(2, 'ZM7',{|x| Alltrim(x) + ";" $ "ZM7_CODPER;ZM7_DESC;"})
    Local oStruC      := FwFormStruct(2, 'ZM8',{|x| Alltrim(x) + ";" $ "ZM8_GRPTRI;"})
    Local oStruD      := FwFormStruct(2, 'ZM9',{|x| Alltrim(x) + ";" $ "ZM9_EST;ZM9_CODMUN;ZM9_DESC;"})
    Local oStruE      := FwFormStruct(2, 'ZMB',{|x| Alltrim(x) + ";" $ "ZMB_EST;ZMB_DESC;"})
    Local oStruF      := FwFormStruct(2, 'ZMC',{|x| Alltrim(x) + ";" $ "ZMC_NCM;"})
    Local oStruG      := FwFormStruct(2, 'ZMA',{|x| Alltrim(x) + ";" $ "ZMA_UF;ZMA_CODMUN;ZMA_DESC;"})
    Local oStruH      := FwFormStruct(2, 'ZMD',{|x| Alltrim(x) + ";" $ "ZMD_NCM;"})
    Local oStruI      := FwFormStruct(2, 'ZME',{|x| Alltrim(x) + ";" $ "ZME_ORIGEM;ZME_DESC;"})
    Local oStruJ      := FwFormStruct(2, 'ZMF',{|x| Alltrim(x) + ";" $ "ZMF_TIPO;"})
    Local oModel      := FwLoadModel("MCSCONF")
    Local oView       := Nil
    Local cParMast    := "ZM6MASTER"
    Local cEnvDeta    := "ZM7DETAIL"  
    Local cEnvDet1    := "ZM8DETAIL"
    Local cEnvDet2    := "ZM9DETAIL"
    Local cEnvDet3    := "ZMBDETAIL"
    Local cEnvDet4    := "ZMCDETAIL"
    Local cEnvDet5    := "ZMADETAIL"
    Local cEnvDet6    := "ZMDDETAIL"
    Local cEnvDet7    := "ZMEDETAIL"  
    Local cEnvDet8    := "ZMFDETAIL"   

    oStruB:SetProperty("ZM7_CODPER", MVC_VIEW_LOOKUP, {|| McsF3()})
    // INDICA O MODELO DA VIEW
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("VIEW_ZM6", oStruA, cParMast)

    //oStruA:RemoveField('ZM6_COD')

    oStruA:SetProperty('ZM6_ALIAS',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))

    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
    oView:AddGrid( "VIEW_ZM7", oStruB, cEnvDeta )
    oView:AddGrid( "VIEW_ZM8", oStruC, cEnvDet1 )
    oView:AddGrid( "VIEW_ZM9", oStruD, cEnvDet2 )
    oView:AddGrid( "VIEW_ZMB", oStruE, cEnvDet3 )
    oView:AddGrid( "VIEW_ZMC", oStruF, cEnvDet4 )
    oView:AddGrid( "VIEW_ZMA", oStruG, cEnvDet5 )
    oView:AddGrid( "VIEW_ZMD", oStruH, cEnvDet6 )
    oView:AddGrid( "VIEW_ZME", oStruI, cEnvDet7 )
    oView:AddGrid( "VIEW_ZMF", oStruJ, cEnvDet8 )

    // Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR' , 60 )
    oView:CreateHorizontalBox( 'INFERIOR' , 40 )
  
    //Cria o controle de Abas
    oView:CreateFolder( 'PASTA_SUPERIOR' ,'SUPERIOR' )
    oView:CreateFolder( 'PASTA_INFERIOR','INFERIOR' )
    // Cria pastas nas folders
    oView:AddSheet('PASTA_SUPERIOR', 'ABA_INI'  ,  'Parâmetros para configuração')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_PRIN' , 'Perfis relacionados')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEGU' , 'Grupos Tributários')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_TERC' , 'Município Igual (==)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUAR' , 'Município Diferente (<>)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUIN' , 'Uf')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEXT' , 'NCM Iguais (==)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SETI' , 'NCM Diferentes (<>)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_OITA' , 'Origem Produto')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_NOVE' , 'Tipo Produto')

    //Cria os Box que serão vinculados as abas
    oView:CreateHorizontalBox( 'Parâmetros' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_SUPERIOR', 'ABA_INI')
    oView:CreateHorizontalBox( 'Perfis' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_PRIN')
    oView:CreateHorizontalBox( 'Grupos Tributários' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEGU')
    oView:CreateHorizontalBox( 'Municípios Iguais' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_TERC')
    oView:CreateHorizontalBox( 'Municípios Diferentes' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUAR')
    oView:CreateHorizontalBox( 'Uf' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUIN')
    oView:CreateHorizontalBox( 'Ncm Igual' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEXT')
    oView:CreateHorizontalBox( 'Ncm Diferente' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SETI')
    oView:CreateHorizontalBox( 'Origem Produto' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_OITA')
    oView:CreateHorizontalBox( 'Tipo Produto' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_NOVE')

    //Amarra as Abas aos Views de Struct criados
    oView:SetOwnerView('VIEW_ZM6','Parâmetros')
    oView:SetOwnerView('VIEW_ZM7','Perfis')
    oView:SetOwnerView('VIEW_ZM8','Grupos Tributários')
    oView:SetOwnerView('VIEW_ZM9','Municípios Iguais')
    oView:SetOwnerView('VIEW_ZMA','Municípios Diferentes')
    oView:SetOwnerView('VIEW_ZMB','Uf')
    oView:SetOwnerView('VIEW_ZMC','Ncm Igual')
    oView:SetOwnerView('VIEW_ZMD','Ncm Diferente')
    oView:SetOwnerView('VIEW_ZME','Origem Produto')
    oView:SetOwnerView('VIEW_ZMF','Tipo Produto')

    // Liga a identificacao do componente
    oView:EnableTitleView("VIEW_ZM7","Perfis")
    oView:EnableTitleView("VIEW_ZM8","Grupos Tributários")
    oView:EnableTitleView("VIEW_ZM9","Municípios Iguais")
    oView:EnableTitleView("VIEW_ZMA","Municípios Diferentes")
    oView:EnableTitleView("VIEW_ZMB","Uf")
    oView:EnableTitleView("VIEW_ZMC","Ncm Igual")
    oView:EnableTitleView("VIEW_ZMD","Ncm Diferente")
    oView:EnableTitleView("VIEW_ZME","Origem Produto")
    oView:EnableTitleView("VIEW_ZMF","Tipo Produto")

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
    Local oModZM6   := oModel:GetModel("ZM6MASTER")
    Local xTab      := Upper(oModZM6:GetValue("ZM6_ALIAS"))
    Local xConsulta := ""
  
    //Se usado SB1, gatilha a consulta padrão do perfil de produto, senão de participante
    If Left(xTab, 1) == "3"
        xConsulta := "F20PRD"
    Else
        xConsulta := "F20PAR"
    EndIf
  
Return xConsulta

/*/{Protheus.doc} MCSValid
Valida geral ao gravar a regra
@type function
@version  
@author MCS Tecnologia
@since 1/8/2026
@return variant, return_description
/*/
User Function ValReg01()

    Local oModel     := FWModelActive()
    Local xRegra1    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA1')
    Local xRegra2    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA2')
    Local xRegra3    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA3')
    Local xRegra4    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA4')
    Local xRegra5    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA5')
    Local xRegra6    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA6')
    Local xRegra7    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA7')
    Local xRegra8    := oModel:GetValue('ZM6MASTER', 'ZM6_REGRA8')
    Local xAlias     := oModel:GetValue('ZM6MASTER', 'ZM6_ALIAS')
    Local xUf01      := oModel:GetValue('ZMBDETAIL', 'ZMB_EST')
    Local xUf02      := oModel:GetValue('ZMADETAIL', 'ZMA_UF')
    Local xUf03      := oModel:GetValue('ZM9DETAIL', 'ZM9_EST')
    Local xNcm1      := oModel:GetValue('ZMCDETAIL', 'ZMC_NCM')
    Local xNcm2      := oModel:GetValue('ZMDDETAIL', 'ZMD_NCM')
    Local xOri       := oModel:GetValue('ZMEDETAIL', 'ZME_ORIGEM')
    Local xGrup      := oModel:GetValue('ZM8DETAIL', 'ZM8_GRPTRI')
    Local xTipo      := oModel:GetValue('ZMFDETAIL', 'ZMF_TIPO')
    Local xCod       := oModel:GetValue('ZM6MASTER', 'ZM6_COD')
    Local oModelZM9  := oModel:GetModel('ZM9DETAIL')
    Local oModelZMC  := oModel:GetModel('ZMCDETAIL')
    Local oModelZMD  := oModel:GetModel('ZMDDETAIL')
    Local oModelZMA  := oModel:GetModel('ZMADETAIL')
    Local oModelZM8  := oModel:GetModel('ZM8DETAIL')
    Local oModelZMB  := oModel:GetModel('ZMBDETAIL')
    Local oModelZME  := oModel:GetModel('ZMEDETAIL')
    Local oModelZMF  := oModel:GetModel('ZMFDETAIL')
    Local xMessage01 := "Ajuste os campos das regras ou as informações contidas na aba correspondente"
    //Local xMessage02 := "Ajuste os campos Aba Município igual e Diferente e Aba UF com valores diferentes"
    Local lRet       := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valida se foi habilitada as duas abas, não deixando seguir          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xUf02) .And. !Empty(xUf03) .And. (!oModelZMB:IsDeleted()) .And. (!oModelZMA:IsDeleted())
        If xRegra2 == xRegra3
            lRet := .F.
            Help(,, "MCSCONF", , "Não é permitido configurar o campo Aba Município Igual e Municio Diferentes como 1=Sim.", 1, 0, , , , , , {})
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ A mesma NCM não pode estar contida nas duas abas                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xNcm1) .And. !Empty(xNcm2) .And. xAlias == '3' .And. (!oModelZMC:IsDeleted())
        If AllTrim(xNcm1) == AllTrim(xNcm2)
            lRet := .F.
            Help("",1,"MCSCONF",,"Não é permitido configurar a mesma NCM para a aba de NCM Igual e NCM Diferente",1)
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Valida as abas e as regras preenchidas                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xRegra1 == '2' .And. !Empty(xGrup) .And. (!oModelZM8:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 2-Não, Aba Grupos Tributários não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra1 == '1' .And. Empty(xGrup) .And. (!oModelZM8:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 1-Sim, Aba Grupos Tributários não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra2 == '2' .And. !Empty(xUf03) .And. (!oModelZM9:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 2-Não, Aba Município não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra2 == '1' .And. Empty(xUf03) .And. (!oModelZM9:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 1-Sim, Aba Município não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra3 == '2' .And. !Empty(xUf02) .And. (!oModelZMA:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 2-Não, Aba Município Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra3 == '1' .And. Empty(xUf02) .And. (!oModelZMA:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 1-Sim, Aba Município Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf   

    If xRegra4 == '2' .And. !Empty(xUf01) .And. (!oModelZMB:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 2-Não, Aba Uf Exceção não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra4 == '1' .And. Empty(xUf01) .And. (!oModelZMB:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 1-Não, Aba Uf Exceção não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '2' .And. !Empty(xNcm2) .And. (!oModelZMA:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 2-Não, Aba NCM Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '1' .And. Empty(xNcm2) .And. (!oModelZMA:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 1-Sim, Aba NCM Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra6 == '2' .And. !Empty(xNcm1) .And. (!oModelZMC:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Igual marcado como 2-Não, Aba NCM Igual não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra6 == '1' .And. Empty(xNcm1) .And. (!oModelZMC:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Igual marcado como 1-Sim, Aba NCM Igual não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra3 == '1' .And. xRegra4 == '2'
        Help(,, "MCSCONF", , "Regra Aba Município Dif marcado como 1-Sim, Regra de Estado precisa ser 1-Sim.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra7 == '2' .And. !Empty(xOri) .And. (!oModelZME:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Origem Produto marcado como 2-Não, Aba Origem Produto não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra7 == '1' .And. Empty(xOri) .And. (!oModelZME:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Origem Produto marcado como 1-Sim, Aba Origem Produto precisa ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra8 == '1' .And. Empty(xTipo) .And. (!oModelZMF:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Tipo Produto marcado como 1-Sim, Aba Tipo Produto precisa ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra8 == '2' .And. !Empty(xTipo) .And. (!oModelZMF:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Tipo Produto marcado como 2-Não, Aba Tipo Produto não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra2 == '1' .And. xRegra4 == '1' 
        Help(,, "MCSCONF", , "Não é possível utilizar a regra de Município Igual e Aba UF na mesma regra.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    /*If xRegra3 == '1' .And. xRegra4 == '1' 
        Help(,, "MCSCONF", , "Não é possível utilizar a regra de Município Diferente e Aba UF na mesma regra.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf*/

    If AllTrim(xAlias) == '3' .And. Empty(xRegra1) .And. Empty(xRegra5) .And. Empty(xRegra6) .And. Empty(xRegra7) .And. Empty(xRegra8)
        Help(,, "MCSCONF", , "Os campos de regra de NCM igual ou diferente, origem ou tipo Produto não podem ficar em branco.", 1, 0, , , , , , {"Informe 1-Sim ou 2-Não em todos os campos"})
        lRet := .F.
    ElseIf AllTrim(xAlias) $ '1/2' .And. Empty(xRegra1) .And. Empty(xRegra2) .And. Empty(xRegra3) .And. Empty(xRegra4) 
        lRet := .F.
        Help(,, "MCSCONF", , "Os campos de regra de grupo tributário, município igual ou diferente e uf não podem ficar em branco.", 1, 0, , , , , , {"Informe 1-Sim ou 2-Não em todos os campos"})
    EndIf

    If INCLUI 
        lRet := ExistChav( 'ZM6', xCod)
    EndIf

Return lRet

/*/{Protheus.doc} GATPER
Gatilho para descrição do perfil
@type function
@version  
@author MCS Tecnologia
@since 1/13/2026
@return variant, return_description
/*/
User Function GATPER(xOp)

    Local oModel     := FWModelActive()
    Local xCodPer    := oModel:GetValue('ZM7DETAIL', 'ZM7_CODPER')
    Local xAlias     := oModel:GetValue('ZM6MASTER', 'ZM6_ALIAS')
    Local xRet       := ""

    If xOp == '1'
        Do Case 
            Case AllTrim(xAlias) $ '1#2'
            xRet := Posicione("F20",1,xFilial("F20") + M->ZM7_CODPER + "02","F20_DESC")
            If Empty(xRet)
            EndIf
        Otherwise
            xRet := Posicione("F20",1,xFilial("F20") + M->ZM7_CODPER + "04","F20_DESC")
            If Empty(xRet)
            EndIf
        EndCase
    ElseIf xOp == '2'
        xRet := Posicione("SX5",1,xFilial("SX5") + "12" + M->ZMB_EST,"X5_DESCRI")
        If Empty(xRet)
        EndIf
    Else
        xRet := Posicione("SX5",1,xFilial("SX5") + "S0" + M->ZME_ORIGEM, "X5_DESCRI")
    EndIf

Return xRet

/*/{Protheus.doc} MCSWHEN
HAbilta ou não a edição do campo
@type function
@version  
@author MCS Tecnologia
@since 1/13/2026
@return variant, return_description
/*/
User Function WHEN1CF()

    Local oModel := FWModelActive()
    Local xAlias := oModel:GetValue('ZM6MASTER', 'ZM6_ALIAS')
    Local lRet   := .T. 

    If AllTrim(xAlias) == '3'
        lRet := .F.
    EndIf

Return lRet

/*/{Protheus.doc} MCSWHEN2
HAbilta ou não a edição do campo
@type function
@version  
@author MCS Tecnologia
@since 1/13/2026
@return variant, return_description
/*/
User Function WHENPRO()

    Local oModel := FWModelActive()
    Local xAlias := oModel:GetValue('ZM6MASTER', 'ZM6_ALIAS')
    Local lRet   := .T. 

    If Alltrim(xAlias) $ '1/2'
        lRet := .F.
    EndIf

Return lRet

/*/{Protheus.doc} MCSWHEN2
HAbilta ou não a edição do campo
@type function
@version  
@author MCS Tecnologia
@since 1/13/2026
@return variant, return_description
/*/
User Function WHENFOR()

    Local oModel := FWModelActive()
    Local xAlias := oModel:GetValue('ZM6MASTER', 'ZM6_ALIAS')
    Local lRet   := .T. 

    If Alltrim(xAlias) $ '2'
        lRet := .F.
    EndIf

Return lRet
