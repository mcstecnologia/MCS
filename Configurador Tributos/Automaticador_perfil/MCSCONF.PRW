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
    Local aGat      := {}
    Local aGat1     := {}
    Local bVldPos   := {|| U_ValReg01()} //Validação ao clicar no Confirmar
    Local bLinePost := {|| u_ValGrid1()} // Validação na grid

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
    oStruA:SetProperty('ZZW_CONTRI'   , MODEL_FIELD_WHEN, {||  (oModel:GetValue ('MCSCONFA',"ZZW_ALIAS")=="3") })
    oStruA:SetProperty('ZZW_TIPPAR'   , MODEL_FIELD_WHEN, {||  (oModel:GetValue ('MCSCONFA',"ZZW_ALIAS")=="3") })
    oStruA:SetProperty('ZZW_SUFRAM'   , MODEL_FIELD_WHEN, {||  (oModel:GetValue ('MCSCONFA',"ZZW_ALIAS")=="3") })
    oStruA:SetProperty('ZZW_SIMPLE'   , MODEL_FIELD_WHEN, {||  (oModel:GetValue ('MCSCONFA',"ZZW_ALIAS")=="3") })

    //	Triggers
    aGat := FwStruTrigger("ZZV_CODMUN","ZZV_DESC",'Posicione("CC2",1,xFilial("CC2") + M->ZZV_EST+M->ZZV_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruD:AddTrigger(aGat[1],aGat[2],aGat[3],aGat[4])

    aGat1:= FwStruTrigger("ZZS_CODMUN","ZZS_DESC",'Posicione("CC2",1,xFilial("CC2") + M->ZZS_UF+M->ZZS_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruG:AddTrigger(aGat1[1],aGat1[2],aGat1[3],aGat1[4]) 

    // Adiciona ao modelo uma estrutura de formul?io de edi?o por grid
    oModel:AddGrid( 'ZZYDETAIL'     , 'ZZWMASTER'   , oStruB, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZXDETAIL'		, 'ZZWMASTER'	, oStruC, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZVDETAIL'		, 'ZZWMASTER'	, oStruD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( 'ZZUDETAIL'		, 'ZZWMASTER'	, oStruE, /*bLinePre*/, /*bLinePost, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
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
    oModel:GetModel( 'ZZYDETAIL' ):SetDescription( "Perfis relacionados" )
    oModel:GetModel( 'ZZXDETAIL' ):SetDescription( "Suframa" )
    oModel:GetModel( 'ZZVDETAIL' ):SetDescription( "Município Igual (==)" )
    oModel:GetModel( 'ZZSDETAIL' ):SetDescription( "Município Diferente (<>)" )
    oModel:GetModel( 'ZZUDETAIL' ):SetDescription( "Uf Exceção" )
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
    Local oStruG      := FwFormStruct(2, 'ZZS',{|x| Alltrim(x) + ";" $ "ZZS_UF;ZZS_CODMUN;ZZS_DESC;"})
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

    /*oStruA:AddGroup( 'GRUPO01', OemToAnsi(STR0003), '', 2 ) // "Definição da Alíquota"
    oStruA:AddGroup( 'GRUPO02', OemToAnsi(STR0004), '', 2 ) // "Aliquota Informada Manualmente"*/

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
    oView:AddSheet('PASTA_INFERIOR', 'ABA_PRIN' , 'Perfis relacioandos')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEGU' , 'Grupos Tributários')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_TERC' , 'Município Igual (==)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUAR' , 'Município Diferente (<>)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_QUIN' , 'Uf Exceção')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SEXT' , 'NCM Iguais (==)')
    oView:AddSheet('PASTA_INFERIOR', 'ABA_SETI' , 'NCM Diferentes (<>)')

    //Cria os Box que serão vinculados as abas
    oView:CreateHorizontalBox( 'Parâmetros' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_SUPERIOR', 'ABA_INI')
    oView:CreateHorizontalBox( 'Perfis' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_PRIN')
    oView:CreateHorizontalBox( 'Grupos Tributários' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEGU')
    oView:CreateHorizontalBox( 'Municípios Iguais' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_TERC')
    oView:CreateHorizontalBox( 'Municípios Diferentes' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUAR')
    oView:CreateHorizontalBox( 'Uf Exceção' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_QUIN')
    oView:CreateHorizontalBox( 'Ncm Igual' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SEXT')
    oView:CreateHorizontalBox( 'Ncm Diferente' ,100, /*owner*/, /*lUsePixel*/, 'PASTA_INFERIOR', 'ABA_SETI')

    //Amarra as Abas aos Views de Struct criados
    oView:SetOwnerView('VIEW_ZZW','Parâmetros')
    oView:SetOwnerView('VIEW_ZZY','Perfis')
    oView:SetOwnerView('VIEW_ZZX','Grupos Tributários')
    oView:SetOwnerView('VIEW_ZZV','Municípios Iguais')
    oView:SetOwnerView('VIEW_ZZS','Municípios Diferentes')
    oView:SetOwnerView('VIEW_ZZU','Uf Exceção')
    oView:SetOwnerView('VIEW_ZZT','Ncm Igual')
    oView:SetOwnerView('VIEW_ZZR','Ncm Diferente')

    // Liga a identificacao do componente
    oView:EnableTitleView("VIEW_ZZY","Perfis")
    oView:EnableTitleView("VIEW_ZZX","Grupos Tributários")
    oView:EnableTitleView("VIEW_ZZV","Municípios Iguais")
    oView:EnableTitleView("VIEW_ZZS","Municípios Diferentes")
    oView:EnableTitleView("VIEW_ZZU","Uf Exceção")
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
@author MCS Tecnologia
@since 1/8/2026
@return variant, return_description
/*/
User Function ValReg01()

    Local oModel     := FWModelActive()
    Local xRegra1    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA1')
    Local xRegra2    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA2')
    Local xRegra3    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA3')
    Local xRegra4    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA4')
    Local xRegra5    := oModel:GetValue('ZZWMASTER', 'ZZW_REGRA5')
    Local xAlias     := oModel:GetValue('ZZWMASTER', 'ZZW_ALIAS')
    Local xUf01      := oModel:GetValue('ZZUDETAIL', 'ZZU_EST')
    Local xUf02      := oModel:GetValue('ZZSDETAIL', 'ZZS_UF')
    Local xUf03      := oModel:GetValue('ZZVDETAIL', 'ZZV_EST')
    Local xNcm1      := oModel:GetValue('ZZTDETAIL', 'ZZT_NCM')
    Local xNcm2      := oModel:GetValue('ZZRDETAIL', 'ZZR_NCM')
    Local xGrup      := oModel:GetValue('ZZXDETAIL', 'ZZX_GRPTRI')
    Local oModelZZV  := oModel:GetModel('ZZVDETAIL')
    Local oModelZZT  := oModel:GetModel('ZZTDETAIL')
    Local oModelZZR  := oModel:GetModel('ZZRDETAIL')
    Local oModelZZS  := oModel:GetModel('ZZSDETAIL')
    Local oModelZZX  := oModel:GetModel('ZZXDETAIL')
    Local oModelZZU  := oModel:GetModel('ZZUDETAIL')
    Local xMessage01 := "Ajuste os campos das regras ou as informações contidas na aba correspondente"
    //Local xMessage02 := "Ajuste os campos Aba Município igual e Diferente e Aba UF com valores diferentes"
    Local lRet       := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valida se foi habilitada as duas abas, não deixando seguir          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xUf02) .And. !Empty(xUf03) .And. (!oModelZZU:IsDeleted()) .And. (!oModelZZS:IsDeleted())
        If xRegra2 == xRegra3
            lRet := .F.
            Help(,, "MCSCONF", , "Não é permitido configurar o campo Aba Município Igual e Municio Diferentes como 1=Sim.", 1, 0, , , , , , {})
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ A mesma NCM não pode estar contida nas duas abas                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xNcm1) .And. !Empty(xNcm2) .And. xAlias == '3' .And. (!oModelZZT:IsDeleted())
        If AllTrim(xNcm1) == AllTrim(xNcm2)
            lRet := .F.
            Help("",1,"MCSCONF",,"Não é permitido configurar a mesma NCM para a aba de NCM Igual e NCM Diferente",1)
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Valida se a aba de municipios está preenchida se não é utilizada     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xRegra1 == '2' .And. !Empty(xGrup) .And. (!oModelZZX:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 2 - Não, Aba Grupos Tributários não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra1 == '1' .And. Empty(xGrup) .And. (!oModelZZX:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 1 - Sim, Aba Grupos Tributários não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra2 == '2' .And. !Empty(xUf03) .And. (!oModelZZV:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 2 - Não, Aba Município não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra2 == '1' .And. Empty(xUf03) .And. (!oModelZZV:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 1 - Sim, Aba Município não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra3 == '2' .And. !Empty(xUf02) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 2 - Não, Aba Município Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra3 == '1' .And. Empty(xUf02) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 1 - Sim, Aba Município Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf   

    If xRegra4 == '2' .And. !Empty(xUf01) .And. (!oModelZZU:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 2 - Não, Aba Uf Exceção não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra4 == '1' .And. Empty(xUf01) .And. (!oModelZZU:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 1 - Não, Aba Uf Exceção não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '2' .And. !Empty(xNcm2) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 2 - Não, Aba NCM Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '1' .And. Empty(xNcm2) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 1 - Sim, Aba NCM Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

Return lRet

/*/{Protheus.doc} MCSGATIL
Gatilhos da rotina
@type function
@version  
@author MCS Tecnologia
@since 1/12/2026
@param nCampo, numeric, param_description
@return variant, return_description
/*/
User Function MCSGATIL(nCampo)

    Local cCampo := ""
    Local cRetorno := 0 
    Default nCampo := 2

    If nCampo == 1  
        If INCLUI
            xRetorno := Posicione("CC2",1,xFilial("CC2") + M->ZZV_EST+M->ZZV_CODMUN,'CC2_MUN' )   
        Else 
            xRetorno := Posicione("CC2",1,xFilial("CC2") + ZZV->ZZV_EST+ZZV->ZZV_CODMUN,'CC2_MUN' ) 
        EndIf    
    ElseIf 	nCampo == 2 
        If INCLUI
            xRetorno := Posicione("CC2",1,xFilial("CC2") + M->ZZS_UF+M->ZZS_CODMUN,'CC2_MUN' )   
        Else 
            xRetorno := Posicione("CC2",1,xFilial("CC2") + ZZS->ZZS_UF+ZZS->ZZS_CODMUN,'CC2_MUN' ) 
        EndIf       

    ElseIf 	nCampo == 3 


    ElseIf 	nCampo == 4 

    EndIf
	
Return(xRetorno)

