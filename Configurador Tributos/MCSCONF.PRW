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
    ChkFile("ZZX")
    ChkFile("ZZV")
    ChkFile("ZZU")
    ChkFile("ZZT")
    ChkFile("ZZS")
    ChkFile("ZZR")

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
    Local oStruC      := FWFormStruct(1, "ZZX") 
    Local oStruD      := FWFormStruct(1, "ZZV")
    Local oStruE      := FWFormStruct(1, "ZZU") 
    Local oStruF      := FWFormStruct(1, "ZZT") 
    Local oStruG      := FWFormStruct(1, "ZZS")
    Local oStruH      := FWFormStruct(1, "ZZR")
    Local cRelacB   := ""
    Local cRelacC   := ""
    Local cRelacD   := ""
    Local cRelacE   := ""
    Local cRelacF   := ""
    Local cRelacG   := ""
    Local cRelach   := ""
    Local aRelacB	:= {}
    Local aRelacC	:= {}
    Local aRelacD	:= {}
    Local aRelacE	:= {}
    Local aRelacF	:= {}
    Local aRelacG	:= {}
    Local aRelacH	:= {}
    Local aGAtilhos := {}
    Local bVldPos := {|| U_ValReg01()} //Validação ao clicar no Confirmar

    aAdd(aGatilhos, FWStruTriggger( ;
        "ZZV_CODMUN",;                              //Campo Origem
        "ZZV_DESC",;                                //Campo Destino
        "POSICIONE('CC2',1,xFilial('CC2') + ZZV_EST + ZZV_CODMUN,'CC2_MUN')",;           //Regra de Preenchimento
        .F.,;                                       //Irá Posicionar?
        "",;                                        //Alias de Posicionamento
        0,;                                         //Índice de Posicionamento
        '',;                                        //Chave de Posicionamento
        NIL,;                                       //Condição para execução do gatilho
        "01");                                      //Sequência do gatilho
    )

    //Montando a string para relação das tabelas
    cRelacB := 'xFilial("ZZY")'
    cRelacC := 'xFilial("ZZX")'
    cRelacD := 'xFilial("ZZV")'
    cRelacE := 'xFilial("ZZU")'
    cRelacF := 'xFilial("ZZT")'
    cRelacG := 'xFilial("ZZS")'
    cRelacH := 'xFilial("ZZR")'

    //Obtendo a estrura das tabelas
    oStruA := FWFormStruct( 1, 'ZZW' , /* bAvalCampo */, /* lViewUsado */ )
    oStruB := FWFormStruct( 1, 'ZZY' , /* bAvalCampo */, /* lViewUsado */ )
    oStruC := FWFormStruct( 1, 'ZZX' , /* bAvalCampo */, /* lViewUsado */ )
    oStruD := FWFormStruct( 1, 'ZZV' , /* bAvalCampo */, /* lViewUsado */ )
    oStruE := FWFormStruct( 1, 'ZZU' , /* bAvalCampo */, /* lViewUsado */ )
    oStruF := FWFormStruct( 1, 'ZZT' , /* bAvalCampo */, /* lViewUsado */ )
    oStruG := FWFormStruct( 1, 'ZZS' , /* bAvalCampo */, /* lViewUsado */ )
    oStruH := FWFormStruct( 1, 'ZZR' , /* bAvalCampo */, /* lViewUsado */ )

    // DEFINE O SUBMODELO COMO FIELD
    oModel := MPFormModel():New("MCSCONFA", /*bVldPre*/, bVldPos,/*bVldCom*/, /*bVldCan*/)
    oModel:AddFields('ZZWMASTER', NIL, oStruA)

    oStruA:SetProperty('ZZW_ALIAS',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_REGRA1',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_REGRA2',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_REGRA3',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_REGRA4',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_REGRA5',MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty('ZZW_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruA:SetProperty('ZZW_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZW", "ZZW_COD")'))
    oStruA:SetProperty('ZZW_ALIAS', MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))
    oStruB:SetProperty('ZZY_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruC:SetProperty('ZZX_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruD:SetProperty('ZZV_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruE:SetProperty('ZZU_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruF:SetProperty('ZZT_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruG:SetProperty('ZZS_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruH:SetProperty('ZZR_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))


    // Adiciona ao modelo uma estrutura de formul?io de edi?o por grid
    oModel:AddGrid( 'ZZYDETAIL'		, 'ZZWMASTER'	, oStruB, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZXDETAIL'		, 'ZZWMASTER'	, oStruC, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZVDETAIL'		, 'ZZWMASTER'	, oStruD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZUDETAIL'		, 'ZZWMASTER'	, oStruE, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZTDETAIL'		, 'ZZWMASTER'	, oStruF, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZSDETAIL'		, 'ZZWMASTER'	, oStruG, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZRDETAIL'		, 'ZZWMASTER'	, oStruH, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

    //Relacionamento da tabela 
    /*aAdd(aRelacB,{ oStruB:aFields[1][3]	, cRelacB	})
    aAdd(aRelacC,{ oStruC:aFields[1][3]	, cRelacC	})
    aAdd(aRelacD,{ oStruD:aFields[1][3]	, cRelacB	})
    aAdd(aRelacD,{ oStruD:aFields[1][3]	, cRelacB	})*/

    aAdd(aRelacB,{ oStruB:aFields[1][3]	, cRelacB	})
    aAdd(aRelacC,{ oStruC:aFields[1][3]	, cRelacC	})
    aAdd(aRelacD,{ oStruD:aFields[1][3]	, cRelacB	})
    aAdd(aRelacE,{ oStruE:aFields[1][3]	, cRelacB	})
    aAdd(aRelacF,{ oStruF:aFields[1][3]	, cRelacB	})
    aAdd(aRelacG,{ oStruG:aFields[1][3]	, cRelacB	})
    aAdd(aRelacH,{ oStruH:aFields[1][3]	, cRelacB	})

    // Faz relaciomaneto entre os compomentes do model
    oModel:SetRelation("ZZYDETAIL", {{"ZZY_FILIAL", "FwXFilial('ZZY')"}, {"ZZY_COD", "ZZW_COD"}}, ZZY->(IndexKey( 1 )))
    oModel:SetRelation("ZZXDETAIL", {{"ZZX_FILIAL", "FwXFilial('ZZX')"}, {"ZZX_COD", "ZZW_COD"}}, ZZX->(IndexKey( 1 )))
    oModel:SetRelation("ZZVDETAIL", {{"ZZV_FILIAL", "FwXFilial('ZZV')"}, {"ZZV_COD", "ZZW_COD"}}, ZZV->(IndexKey( 1 )))
    oModel:SetRelation("ZZUDETAIL", {{"ZZU_FILIAL", "FwXFilial('ZZU')"}, {"ZZU_COD", "ZZW_COD"}}, ZZU->(IndexKey( 1 )))
    oModel:SetRelation("ZZTDETAIL", {{"ZZT_FILIAL", "FwXFilial('ZZT')"}, {"ZZT_COD", "ZZW_COD"}}, ZZT->(IndexKey( 1 )))
    oModel:SetRelation("ZZSDETAIL", {{"ZZS_FILIAL", "FwXFilial('ZZS')"}, {"ZZS_COD", "ZZW_COD"}}, ZZS->(IndexKey( 1 )))
    oModel:SetRelation("ZZRDETAIL", {{"ZZR_FILIAL", "FwXFilial('ZZR')"}, {"ZZR_COD", "ZZW_COD"}}, ZZR->(IndexKey( 1 )))
 
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Configuração regras")

    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZZWMASTER' ):SetDescription("Montagem da regra") 
    oModel:GetModel( 'ZZYDETAIL' ):SetDescription( "Perfis realcionados" )
    oModel:GetModel( 'ZZXDETAIL' ):SetDescription( "Suframa" )
    oModel:GetModel( 'ZZVDETAIL' ):SetDescription( "Código Municípios (Suframa)" )
    oModel:GetModel( 'ZZSDETAIL' ):SetDescription( "UF" )
    oModel:GetModel( 'ZZUDETAIL' ):SetDescription( "UF Exceção" )
    oModel:GetModel( 'ZZTDETAIL' ):SetDescription( "NCM Iguais (==)" )
    oModel:GetModel( 'ZZRDETAIL' ):SetDescription( "NCM Diferentes (<>)" )

    oModel:SetPrimaryKey({oStruA:aFields[1][3]})

    //oModel:GetModel("ZZYDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZXDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZVDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZUDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZTDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZSDETAIL"):SetOptional(.T.)
    oModel:GetModel("ZZRDETAIL"):SetOptional(.T.)

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
    Local oStruA      := FwFormStruct(2, 'ZZW')
    Local oStruB      := FWFormStruct(2, 'ZZY',{|x| Alltrim(x) + ";" $ "ZZY_CODPER;ZZY_DESC;"})
    Local oStruC      := FwFormStruct(2, 'ZZX',{|x| Alltrim(x) + ";" $ "ZZX_GRPTRI;"})
    Local oStruD      := FwFormStruct(2, 'ZZV',{|x| Alltrim(x) + ";" $ "ZZV_EST;ZZV_CODMUN;ZZV_DESC;"})
    Local oStruE      := FwFormStruct(2, 'ZZU',{|x| Alltrim(x) + ";" $ "ZZU_EST;"})
    Local oStruF      := FwFormStruct(2, 'ZZT',{|x| Alltrim(x) + ";" $ "ZZT_NCM;"})
    Local oStruG      := FwFormStruct(2, 'ZZS',{|x| Alltrim(x) + ";" $ "ZZS_UF;"})
    Local oStruH      := FwFormStruct(2, 'ZZR',{|x| Alltrim(x) + ";" $ "ZZR_NCM;"})
    Local oModel      := FwLoadModel("MCSCONF")
    Local oView       := Nil
    Local cParMast    := "ZZWMASTER"
    Local cEnvDeta    := "ZZYDETAIL"  
    Local cEnvDet1    := "ZZXDETAIL"
    Local cEnvDet2    := "ZZVDETAIL"
    Local cEnvDet3    := "ZZUDETAIL"
    Local cEnvDet4    := "ZZTDETAIL"
    Local cEnvDet5    := "ZZSDETAIL"
    Local cEnvDet6    := "ZZRDETAIL"   

    oStruB:SetProperty("ZZY_CODPER", MVC_VIEW_LOOKUP, {|| McsF3()})
    // INDICA O MODELO DA VIEW
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("VIEW_ZZW", oStruA, cParMast)

    oStruA:SetProperty('ZZW_ALIAS',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))

    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
    oView:AddGrid( "VIEW_ZZY", oStruB, cEnvDeta )
    oView:AddGrid( "VIEW_ZZX", oStruC, cEnvDet1 )
    oView:AddGrid( "VIEW_ZZV", oStruD, cEnvDet2 )
    oView:AddGrid( "VIEW_ZZU", oStruE, cEnvDet3 )
    oView:AddGrid( "VIEW_ZZT", oStruF, cEnvDet4 )
    oView:AddGrid( "VIEW_ZZS", oStruG, cEnvDet5 )
    oView:AddGrid( "VIEW_ZZR", oStruH, cEnvDet6 )

    // Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR' , 60 )
    oView:CreateHorizontalBox( 'INFERIOR' , 40 )
  
    //Cria o controle de Abas
    oView:CreateFolder( 'PASTA_SUPERIOR' ,'SUPERIOR' )
    oView:CreateFolder( 'PASTA_INFERIOR','INFERIOR' )
    // Cria pastas nas folders
    oView:AddSheet('PASTA_SUPERIOR', 'ABA_INI'  ,  'Parâmetros para configuração')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_PRIN' , 'Perfis realcionados')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEGU' , 'Grupos Tributários')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_TERC' , 'Código Municipio (Suframa)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUAR' , 'UF')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUIN' , 'UF Exceção')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEXT' , 'NCM Iguais (==)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SETI' , 'NCM Diferentes (<>)')

    //Cria os Box que serão vinculados as abas
    oView:CreateHorizontalBox( 'Parâmetros' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_SUPERIOR', 'ABA_INI')
    oView:CreateHorizontalBox( 'Perfis' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_PRIN')
    oView:CreateHorizontalBox( 'Grupos Tributários' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEGU')
    oView:CreateHorizontalBox( 'Municípios' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_TERC')
    oView:CreateHorizontalBox( 'Estados' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUAR')
    oView:CreateHorizontalBox( 'Exceção' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUIN')
    oView:CreateHorizontalBox( 'Ncm Igual' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEXT')
    oView:CreateHorizontalBox( 'Ncm Diferente' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SETI')

    //Amarra as Abas aos Views de Struct criados
    oView:SetOwnerView('VIEW_ZZW','Parâmetros')
    oView:SetOwnerView('VIEW_ZZY','Perfis')
    oView:SetOwnerView('VIEW_ZZX','Grupos Tributários')
    oView:SetOwnerView('VIEW_ZZV','Municípios')
    oView:SetOwnerView('VIEW_ZZS','Estados')
    oView:SetOwnerView('VIEW_ZZU','Exceção')
    oView:SetOwnerView('VIEW_ZZT','Ncm Igual')
    oView:SetOwnerView('VIEW_ZZR','Ncm Diferente')

    // Liga a identificacao do componente
    oView:EnableTitleView("VIEW_ZZY","Perfis")
    oView:EnableTitleView("VIEW_ZZX","Grupos Tributários")
    oView:EnableTitleView("VIEW_ZZV","Municípios")
    oView:EnableTitleView("VIEW_ZZS","Estados")
    oView:EnableTitleView("VIEW_ZZU","Exceção")
    oView:EnableTitleView("VIEW_ZZT","Ncm Igual")
    oView:EnableTitleView("VIEW_ZZR","Ncm Diferente")

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

/*/{Protheus.doc} MCSValid
Valida na confirmação a regra 02 e regra 03
@type function
@version  
@author Rodrigo
@since 1/8/2026
@return variant, return_description
/*/
User Function ValReg01()

    Local oModel     := FWModelActive()
    Local xRegra2    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA2')
    Local xRegra3    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA3')
    Local xUf01      := oModel:GetValue('ZZUDETAIL', 'ZZU_EST')
    Local xUf02      := oModel:GetValue('ZZSDETAIL', 'ZZS_UF')
    Local xNcm1      := oModel:GetValue('ZZTDETAIL', 'ZZT_NCM')
    Local xNcm2      := oModel:GetValue('ZZRDETAIL', 'ZZR_NCM')
    Local lRet       := .T.
     
    If xRegra2 == xRegra3
        lRet := .F.
        Help("",1,"MCSCONF",,"Não é permitido configurar a Regra 02 e Regra 03 com os mesmos valores",1)
    EndIf

    If xUf01 == xUf02
        lRet := .F.
        Help("",1,"MCSCONF",,"Não é permitido configurar a mesma UF para a aba de UF e Exceção",1)
    EndIf

    If AllTrim(xNcm1) == AllTrim(xNcm2)
        lRet := .F.
        Help("",1,"MCSCONF",,"Não é permitido configurar a mesma NCM para a aba de NCM Igual e NCM Diferente",1)
    EndIf
     
Return lRet

