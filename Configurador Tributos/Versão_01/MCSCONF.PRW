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

    Private xTabMaster  := SuperGetMV("MV_XMASTER",.F.,"ZZW")
    Private xTabDetal1  := SuperGetMV("MV_XDETAL1",.F.,"ZZY")
    Private xTabDetal2  := SuperGetMV("MV_XDETAL2",.F.,"ZZX")
    Private xTabDetal3  := SuperGetMV("MV_XDETAL3",.F.,"ZZV")
    Private xTabDetal4  := SuperGetMV("MV_XDETAL4",.F.,"ZZU")
    Private xTabDetal5  := SuperGetMV("MV_XDETAL5",.F.,"ZZT")
    Private xTabDetal6  := SuperGetMV("MV_XDETAL6",.F.,"ZZS")
    Private xTabDetal7  := SuperGetMV("MV_XDETAL7",.F.,"ZZR")
    Private xTabDetal8  := SuperGetMV("MV_XDETAL8",.F.,"ZZQ")
    Private xTabDetal9  := SuperGetMV("MV_XDETAL9",.F.,"ZZP")
    Private aRotina     := MenuDef()

    If ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster);
        .Or. ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster) .Or. ExisteSX2(xTabMaster)

        dbSelectArea(xTabMaster)
        oBrowse := FWmBrowse():New()
        oBrowse:SetAlias(xTabMaster)
        oBrowse:SetDescription( "Configurador das regras por perfil - Configurador de tributos" ) 
        
        oBrowse:Activate()
    Else 
        Help(,, "MCSCONF", , "Alguma tabela de controle está ausente no dicionário de dados", 1, 0, , , , , , {"Execute o UPDMCS() para criação da tabela"})
    EndIf
 
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
    Local oStruA      := FwFormStruct(1, xTabMaster)
    Local oStruB      := FWFormStruct(1, xTabDetal1) 
    Local oStruC      := FWFormStruct(1, xTabDetal2) 
    Local oStruD      := FWFormStruct(1, xTabDetal3)
    Local oStruE      := FWFormStruct(1, xTabDetal4) 
    Local oStruF      := FWFormStruct(1, xTabDetal5) 
    Local oStruG      := FWFormStruct(1, xTabDetal6)
    Local oStruH      := FWFormStruct(1, xTabDetal7)
    Local oStruI      := FWFormStruct(1, xTabDetal8)
    Local oStruj      := FWFormStruct(1, xTabDetal9)
    Local cRelacB   := ""
    Local cRelacC   := ""
    Local cRelacD   := ""
    Local cRelacE   := ""
    Local cRelacF   := ""
    Local cRelacG   := ""
    Local cRelacH   := ""
    Local cRelacI   := ""
    Local cRelacJ   := ""
    Local xMaster   := xTabMaster+"MASTER"
    Local xDetal1   := xTabDetal1+"DETAIL"
    Local xDetal2   := xTabDetal2+"DETAIL"
    Local xDetal3   := xTabDetal3+"DETAIL"
    Local xDetal4   := xTabDetal4+"DETAIL"
    Local xDetal5   := xTabDetal5+"DETAIL"
    Local xDetal6   := xTabDetal6+"DETAIL"
    Local xDetal7   := xTabDetal7+"DETAIL"
    Local xDetal8   := xTabDetal8+"DETAIL"
    Local xDetal9   := xTabDetal9+"DETAIL"
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
    Local bLinePost := {|| u_ValGrid1()} // Validação na grid

    //Montando a string para relação das tabelas
    cRelacB := 'xFilial("'+xTabDetal1+'")'
    cRelacC := 'xFilial("'+xTabDetal2+'")'
    cRelacD := 'xFilial("'+xTabDetal3+'")'
    cRelacE := 'xFilial("'+xTabDetal4+'")'
    cRelacF := 'xFilial("'+xTabDetal5+'")'
    cRelacG := 'xFilial("'+xTabDetal6+'")'
    cRelacH := 'xFilial("'+xTabDetal7+'")'
    cRelacI := 'xFilial("'+xTabDetal8+'")'
    cRelacJ := 'xFilial("'+xTabDetal9+'")'

    //Obtendo a estrura das tabelas
    oStruA := FWFormStruct( 1, xTabMaster , /* bAvalCampo */, /* lViewUsado */ )
    oStruB := FWFormStruct( 1, xTabDetal1 , /* bAvalCampo */, /* lViewUsado */ )
    oStruC := FWFormStruct( 1, xTabDetal2 , /* bAvalCampo */, /* lViewUsado */ )
    oStruD := FWFormStruct( 1, xTabDetal3 , /* bAvalCampo */, /* lViewUsado */ )
    oStruE := FWFormStruct( 1, xTabDetal4 , /* bAvalCampo */, /* lViewUsado */ )
    oStruF := FWFormStruct( 1, xTabDetal5 , /* bAvalCampo */, /* lViewUsado */ )
    oStruG := FWFormStruct( 1, xTabDetal6 , /* bAvalCampo */, /* lViewUsado */ )
    oStruH := FWFormStruct( 1, xTabDetal7 , /* bAvalCampo */, /* lViewUsado */ )
    oStruI := FWFormStruct( 1, xTabDetal8 , /* bAvalCampo */, /* lViewUsado */ )
    oStruJ := FWFormStruct( 1, xTabDetal9 , /* bAvalCampo */, /* lViewUsado */ )
    // DEFINE O SUBMODELO COMO FIELD
    oModel := MPFormModel():New("MCSCONFA", /*bVldPre*/, bVldPos,/*bVldCom*/, /*bVldCan*/)
    oModel:AddFields(xMaster, NIL, oStruA)

    oStruA:SetProperty(xTabMaster+'_ALIAS' ,MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty(xTabMaster+'_DESC'  ,MODEL_FIELD_OBRIGAT, .T. )
    oStruA:SetProperty(xTabMaster+'_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruA:SetProperty(xTabMaster+'_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZW", "ZZW_COD")'))
    oStruA:SetProperty(xTabMaster+'_ALIAS', MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))
    oStruB:SetProperty(xTabDetal1+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruC:SetProperty(xTabDetal2+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruD:SetProperty(xTabDetal3+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruE:SetProperty(xTabDetal4+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruF:SetProperty(xTabDetal5+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruG:SetProperty(xTabDetal6+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruH:SetProperty(xTabDetal7+'_COD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))
    oStruA:SetProperty(xTabMaster+'_CONTRI'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_TIPPAR'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_SUFRAM'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_SIMPLE'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
//oStruA:SetProperty('ZZW_REGRA1'   , MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_REGRA2',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_REGRA3',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_REGRA4',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHEN1CF()'))
    oStruA:SetProperty(xTabMaster+'_REGRA5',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty(xTabMaster+'_REGRA6',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty(xTabMaster+'_REGRA7',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    oStruA:SetProperty(xTabMaster+'_REGRA8',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,    'U_WHENPRO()'))
    //	Triggers
    aGat := FwStruTrigger(xTabDetal3+"_CODMUN",xTabDetal3+"_DESC",'Posicione("CC2",1,xFilial("CC2") + M->'+xTabDetal3+'_EST+M->'+xTabDetal3+'_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruD:AddTrigger(aGat[1],aGat[2],aGat[3],aGat[4])

    aGat1:= FwStruTrigger(xTabDetal6+"_CODMUN",xTabDetal6+"_DESC",'Posicione("CC2",1,xFilial("CC2") + M->'+xTabDetal6+'_UF+M->'+xTabDetal6+'_CODMUN,"CC2_MUN" )',.F.,,,)
	oStruG:AddTrigger(aGat1[1],aGat1[2],aGat1[3],aGat1[4]) 

    aGat2:= FwStruTrigger(xTabDetal4+"_EST",xTabDetal4+"_DESC",'U_GATPER("2")',.F.,,,)
	oStruE:AddTrigger(aGat2[1],aGat2[2],aGat2[3],aGat2[4])

    aGat3:= FwStruTrigger(xTabDetal1+"_CODPER",xTabDetal1+"_DESC",'U_GATPER("1")',.F.,,,)
	oStruB:AddTrigger(aGat3[1],aGat3[2],aGat3[3],aGat3[4])

    aGat4:= FwStruTrigger(xTabDetal8+"_ORIGEM",xTabDetal8+"_DESC",'U_GATPER("3")',.F.,,,)
	oStruI:AddTrigger(aGat4[1],aGat4[2],aGat4[3],aGat4[4])

    oStruB:SetProperty('ZZY_CODPER',MODEL_FIELD_VALID,FWBuildFeature(STRUCT_FEATURE_VALID,"ExistCpo('F20',+FWFldGet('ZZY_CODPER'))"))

    // Adiciona ao modelo uma estrutura de formul?io de edi?o por grid
    oModel:AddGrid( xDetal1     , xMaster   , oStruB, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal2		, xMaster	, oStruC, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal3		, xMaster	, oStruD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal4		, xMaster	, oStruE, /*bLinePre*/, /*bLinePost, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal5		, xMaster	, oStruF, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal6		, xMaster	, oStruG, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal7		, xMaster	, oStruH, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal8		, xMaster	, oStruI, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:AddGrid( xDetal9		, xMaster	, oStruJ, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
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
    oModel:SetRelation(xDetal1, {{xTabDetal1+"_FILIAL", "FwXFilial('"+xTabDetal1+"')"}, {xTabDetal1+"_COD", xTabMaster+"_COD"}}, &(xTabDetal1+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal2, {{xTabDetal2+"_FILIAL", "FwXFilial('"+xTabDetal2+"')"}, {xTabDetal2+"_COD", xTabMaster+"_COD"}}, &(xTabDetal2+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal3, {{xTabDetal3+"_FILIAL", "FwXFilial('"+xTabDetal3+"')"}, {xTabDetal3+"_COD", xTabMaster+"_COD"}}, &(xTabDetal3+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal4, {{xTabDetal4+"_FILIAL", "FwXFilial('"+xTabDetal4+"')"}, {xTabDetal4+"_COD", xTabMaster+"_COD"}}, &(xTabDetal4+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal5, {{xTabDetal5+"_FILIAL", "FwXFilial('"+xTabDetal5+"')"}, {xTabDetal5+"_COD", xTabMaster+"_COD"}}, &(xTabDetal5+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal6, {{xTabDetal6+"_FILIAL", "FwXFilial('"+xTabDetal6+"')"}, {xTabDetal6+"_COD", xTabMaster+"_COD"}}, &(xTabDetal6+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal7, {{xTabDetal7+"_FILIAL", "FwXFilial('"+xTabDetal7+"')"}, {xTabDetal7+"_COD", xTabMaster+"_COD"}}, &(xTabDetal7+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal8, {{xTabDetal8+"_FILIAL", "FwXFilial('"+xTabDetal8+"')"}, {xTabDetal8+"_COD", xTabMaster+"_COD"}}, &(xTabDetal8+"->(IndexKey( 1 ))"))
    oModel:SetRelation(xDetal9, {{xTabDetal9+"_FILIAL", "FwXFilial('"+xTabDetal9+"')"}, {xTabDetal9+"_COD", xTabMaster+"_COD"}}, &(xTabDetal9+"->(IndexKey( 1 ))"))
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Configuração regras")

    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( xMaster ):SetDescription("Montagem da regra") 
    oModel:GetModel( xDetal1 ):SetDescription( "Perfis relacionados" )
    oModel:GetModel( xDetal2 ):SetDescription( "Suframa" )
    oModel:GetModel( xDetal3 ):SetDescription( "Município Igual (==)" )
    oModel:GetModel( xDetal4 ):SetDescription( "Município Diferente (<>)" )
    oModel:GetModel( xDetal5 ):SetDescription( "Uf" )
    oModel:GetModel( xDetal6 ):SetDescription( "NCM Iguais (==)" )
    oModel:GetModel( xDetal7 ):SetDescription( "NCM Diferentes (<>)" )
    oModel:GetModel( xDetal8 ):SetDescription( "Origem Produto" )
    oModel:GetModel( xDetal9 ):SetDescription( "Tipo Produto" )
    oModel:SetPrimaryKey({oStruA:aFields[1][3]})

    //oModel:GetModel("ZZYDETAIL"):SetOptional(.T.)
    oModel:GetModel(xDetal2):SetOptional(.T.)
    oModel:GetModel(xDetal3):SetOptional(.T.)
    oModel:GetModel(xDetal4):SetOptional(.T.)
    oModel:GetModel(xDetal5):SetOptional(.T.)
    oModel:GetModel(xDetal6):SetOptional(.T.)
    oModel:GetModel(xDetal7):SetOptional(.T.)
    oModel:GetModel(xDetal8):SetOptional(.T.)
    oModel:GetModel(xDetal9):SetOptional(.T.)

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
    Local oStruA      := FwFormStruct(2, xTabMaster)
    Local oStruB      := FWFormStruct(2, xTabDetal1,{|x| Alltrim(x) + ";" $ xTabDetal1+"_CODPER"+";"+xTabDetal1+"_DESC;"})
    Local oStruC      := FwFormStruct(2, xTabDetal2,{|x| Alltrim(x) + ";" $ xTabDetal2+"_GRPTRI;"})
    Local oStruD      := FwFormStruct(2, xTabDetal3,{|x| Alltrim(x) + ";" $ xTabDetal3+"_EST"+";"+xTabDetal3+"_CODMUN"+";"+xTabDetal3+"_DESC;"})
    Local oStruE      := FwFormStruct(2, xTabDetal4,{|x| Alltrim(x) + ";" $ xTabDetal4+"_EST"+";"+xTabDetal4+"_DESC;"})
    Local oStruF      := FwFormStruct(2, xTabDetal5,{|x| Alltrim(x) + ";" $ xTabDetal5+"_NCM;"})
    Local oStruG      := FwFormStruct(2, xTabDetal6,{|x| Alltrim(x) + ";" $ xTabDetal6+"_UF"+";"+xTabDetal6+"_CODMUN"+";"+xTabDetal6+"_DESC;"})
    Local oStruH      := FwFormStruct(2, xTabDetal7,{|x| Alltrim(x) + ";" $ xTabDetal7+"_NCM;"})
    Local oStruI      := FwFormStruct(2, xTabDetal8,{|x| Alltrim(x) + ";" $ xTabDetal8+"_ORIGEM"+";"+xTabDetal8+"_DESC;"})
    Local oStruJ      := FwFormStruct(2, xTabDetal9,{|x| Alltrim(x) + ";" $ xTabDetal9+"_TIPO;"})
    Local oModel      := FwLoadModel("MCSCONF")
    Local oView       := Nil
    Local cParMast    := xTabMaster+"MASTER"
    Local cEnvDeta    := xTabDetal1+"DETAIL"  
    Local cEnvDet1    := xTabDetal2+"DETAIL"
    Local cEnvDet2    := xTabDetal3+"DETAIL"
    Local cEnvDet3    := xTabDetal4+"DETAIL"
    Local cEnvDet4    := xTabDetal5+"DETAIL"
    Local cEnvDet5    := xTabDetal6+"DETAIL"
    Local cEnvDet6    := xTabDetal7+"DETAIL"   
    Local cEnvDet7    := xTabDetal8+"DETAIL"  
    Local cEnvDet8    := xTabDetal9+"DETAIL"  
    oStruB:SetProperty(xTabDetal1+"_CODPER", MVC_VIEW_LOOKUP, {|| McsF3()})
    // INDICA O MODELO DA VIEW
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("VIEW_"+xTabMaster, oStruA, cParMast)

    oStruA:SetProperty(xTabMaster+'_ALIAS',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))

    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
    oView:AddGrid( "VIEW_"+xTabDetal1, oStruB, cEnvDeta )
    oView:AddGrid( "VIEW_"+xTabDetal2, oStruC, cEnvDet1 )
    oView:AddGrid( "VIEW_"+xTabDetal3, oStruD, cEnvDet2 )
    oView:AddGrid( "VIEW_"+xTabDetal4, oStruE, cEnvDet3 )
    oView:AddGrid( "VIEW_"+xTabDetal5, oStruF, cEnvDet4 )
    oView:AddGrid( "VIEW_"+xTabDetal6, oStruG, cEnvDet5 )
    oView:AddGrid( "VIEW_"+xTabDetal7, oStruH, cEnvDet6 )
    oView:AddGrid( "VIEW_"+xTabDetal8, oStruI, cEnvDet7 )
    oView:AddGrid( "VIEW_"+xTabDetal9, oStruJ, cEnvDet8 )
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
    oView:SetOwnerView('VIEW_'+xTabMaster,'Parâmetros')
    oView:SetOwnerView('VIEW_'+xTabDetal1,'Perfis')
    oView:SetOwnerView('VIEW_'+xTabDetal2,'Grupos Tributários')
    oView:SetOwnerView('VIEW_'+xTabDetal3,'Municípios Iguais')
    oView:SetOwnerView('VIEW_'+xTabDetal6,'Municípios Diferentes')
    oView:SetOwnerView('VIEW_'+xTabDetal4,'Uf')
    oView:SetOwnerView('VIEW_'+xTabDetal5,'Ncm Igual')
    oView:SetOwnerView('VIEW_'+xTabDetal7,'Ncm Diferente')
    oView:SetOwnerView('VIEW_'+xTabDetal8,'Origem Produto')
    oView:SetOwnerView('VIEW_'+xTabDetal9,'Tipo Produto')
    // Liga a identificacao do componente
    oView:EnableTitleView("VIEW_"+xTabDetal1,"Perfis")
    oView:EnableTitleView("VIEW_"+xTabDetal2,"Grupos Tributários")
    oView:EnableTitleView("VIEW_"+xTabDetal3,"Municípios Iguais")
    oView:EnableTitleView("VIEW_"+xTabDetal6,"Municípios Diferentes")
    oView:EnableTitleView("VIEW_"+xTabDetal4,"Uf")
    oView:EnableTitleView("VIEW_"+xTabDetal5,"Ncm Igual")
    oView:EnableTitleView("VIEW_"+xTabDetal7,"Ncm Diferente")
    oView:EnableTitleView("VIEW_"+xTabDetal8,"Origem Produto")
    oView:EnableTitleView("VIEW_"+xTabDetal9,"Tipo Produto")
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

    Local cParMast    := xTabMaster+"MASTER"  
    Local oModel    := FwModelActive()
    Local oModZZW   := oModel:GetModel(cParMast)
    Local xTab      := Upper(oModZZW:GetValue(xTabMaster+"_ALIAS"))
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
    Local cParMast    := xTabMaster+"MASTER"
    Local cEnvDeta    := xTabDetal1+"DETAIL"  
    Local cEnvDet1    := xTabDetal2+"DETAIL"
    Local cEnvDet2    := xTabDetal3+"DETAIL"
    Local cEnvDet3    := xTabDetal4+"DETAIL"
    Local cEnvDet4    := xTabDetal5+"DETAIL"
    Local cEnvDet5    := xTabDetal6+"DETAIL"
    Local cEnvDet6    := xTabDetal7+"DETAIL" 
    Local cEnvDet7    := xTabDetal8+"DETAIL"
    Local cEnvDet8    := xTabDetal9+"DETAIL"  
    Local xRegra1    := oModel:GetValue(cParMast, xTabMaster+'_REGRA1')
    Local xRegra2    := oModel:GetValue(cParMast, xTabMaster+'_REGRA2')
    Local xRegra3    := oModel:GetValue(cParMast, xTabMaster+'_REGRA3')
    Local xRegra4    := oModel:GetValue(cParMast, xTabMaster+'_REGRA4')
    Local xRegra5    := oModel:GetValue(cParMast, xTabMaster+'_REGRA5')
    Local xRegra6    := oModel:GetValue(cParMast, xTabMaster+'_REGRA6')
    Local xRegra7    := oModel:GetValue(cParMast, xTabMaster+'_REGRA7')
    Local xRegra8    := oModel:GetValue(cParMast, xTabMaster+'_REGRA8')
    Local xAlias     := oModel:GetValue(cParMast, xTabMaster+'_ALIAS')
    Local xUf01      := oModel:GetValue(cEnvDet3, xTabDetal4+'_EST')
    Local xUf02      := oModel:GetValue(cEnvDet5, xTabDetal6+'_UF')
    Local xUf03      := oModel:GetValue(cEnvDet2, xTabDetal3+'_EST')
    Local xNcm1      := oModel:GetValue(cEnvDet4, xTabDetal5+'_NCM')
    Local xNcm2      := oModel:GetValue(cEnvDet6, xTabDetal7+'_NCM')
    Local xOri       := oModel:GetValue(cEnvDet8, xTabDetal8+'_ORIGEM')
    Local xGrup      := oModel:GetValue(cEnvDet1, xTabDetal2+'_GRPTRI')
    Local xTipo      := oModel:GetValue(cEnvDet9, xTabDetal9+'_TIPO')
    Local oModelZZV  := oModel:GetModel(cEnvDet2)
    Local oModelZZT  := oModel:GetModel(cEnvDet4)
    Local oModelZZR  := oModel:GetModel(cEnvDet6)
    Local oModelZZS  := oModel:GetModel(cEnvDet5)
    Local oModelZZX  := oModel:GetModel(cEnvDet1)
    Local oModelZZU  := oModel:GetModel(cEnvDet3)
    Local oModelZZQ  := oModel:GetModel(cEnvDet7)
    Local oModelZZP  := oModel:GetModel(cEnvDet8)

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
    //³Valida as abas e as regras preenchidas                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xRegra1 == '2' .And. !Empty(xGrup) .And. (!oModelZZX:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 2-Não, Aba Grupos Tributários não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra1 == '1' .And. Empty(xGrup) .And. (!oModelZZX:IsDeleted())
        Help(,, "MCSCONF", , "Campo Grp Tributo marcado como 1-Sim, Aba Grupos Tributários não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra2 == '2' .And. !Empty(xUf03) .And. (!oModelZZV:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 2-Não, Aba Município não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra2 == '1' .And. Empty(xUf03) .And. (!oModelZZV:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município marcado como 1-Sim, Aba Município não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf  

    If xRegra3 == '2' .And. !Empty(xUf02) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 2-Não, Aba Município Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra3 == '1' .And. Empty(xUf02) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Município Dif marcado como 1-Sim, Aba Município Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf   

    If xRegra4 == '2' .And. !Empty(xUf01) .And. (!oModelZZU:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 2-Não, Aba Uf Exceção não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra4 == '1' .And. Empty(xUf01) .And. (!oModelZZU:IsDeleted())
        Help(,, "MCSCONF", , "Campo Uf Exceção marcado como 1-Não, Aba Uf Exceção não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '2' .And. !Empty(xNcm2) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 2-Não, Aba NCM Diferente não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra5 == '1' .And. Empty(xNcm2) .And. (!oModelZZS:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Dif marcado como 1-Sim, Aba NCM Diferente não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra6 == '2' .And. !Empty(xNcm1) .And. (!oModelZZT:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Igual marcado como 2-Não, Aba NCM Igual não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra6 == '1' .And. Empty(xNcm1) .And. (!oModelZZT:IsDeleted())
        Help(,, "MCSCONF", , "Campo Ncm Igual marcado como 1-Sim, Aba NCM Igual não pode ficar em branco.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra3 == '1' .And. xRegra4 == '2'
        Help(,, "MCSCONF", , "Regra Aba Município Dif marcado como 1-Sim, Regra de Estado precisa ser 1-Sim.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf 

    If xRegra7 == '2' .And. !Empty(xOri) .And. (!oModelZZQ:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Origem Produto marcado como 2-Não, Aba Origem Produto não pode ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra7 == '1' .And. Empty(xOri) .And. (!oModelZZQ:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Origem Produto marcado como 1-Sim, Aba Origem Produto precisa ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra8 == '1' .And. Empty(xTipo) .And. (!oModelZZP:IsDeleted())
        Help(,, "MCSCONF", , "Campo Aba Tipo Produto marcado como 1-Sim, Aba Tipo Produto precisa ser preenchida.", 1, 0, , , , , , {xMessage01})
        lRet := .F.
    EndIf

    If xRegra8 == '2' .And. !Empty(xTipo) .And. (!oModelZZP:IsDeleted())
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

    Local cParMast    := xTabMaster+"MASTER"
    Local cEnvDeta    := xTabDetal1+"DETAIL"  
    Local cEnvDet3    := xTabDetal4+"DETAIL"
    Local oModel     := FWModelActive()
    Local xCodPer    := oModel:GetValue(cEnvDeta, xTabDetal1+'_CODPER')
    Local xAlias     := oModel:GetValue(cParMast, xTabMaster+'_ALIAS')
    Local xRet       := ""

    If xOp == '1'
        Do Case 
            Case AllTrim(xAlias) $ '1#2'
            xRet := Posicione("F20",1,xFilial("F20") + &("M->"+xTabDetal1+"_CODPER") + "02","F20_DESC")
            
        Otherwise
            xRet := Posicione("F20",1,xFilial("F20") + &("M->"+xTabDetal1+"_CODPER") + "04","F20_DESC")
        EndCase
    ElseIf xOp == '2'
        xRet := Posicione("SX5",1,xFilial("SX5") + "12" + &("M->"+xTabDetal4+"_EST"),"X5_DESCRI")
    Else
        xRet := Posicione("SX5",1,xFilial("SX5") + "S0" + M->ZZQ_ORIGEM, "X5_DESCRI")
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
User Function MCSWHEN()

    Local cParMast    := xTabMaster+"MASTER"
    Local oModel := FWModelActive()
    Local xAlias := oModel:GetValue(cParMast, xTabMaster+'_ALIAS')
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
    Local xAlias := oModel:GetValue('ZZWMASTER', 'ZZW_ALIAS')
    Local lRet   := .T. 

    If Alltrim(xAlias) $ '1/2'
        lRet := .F.
    EndIf

Return lRet

/*/{Protheus.doc} MCSOBRIG
Validação para obrigatoriedade dos campos
@type function
@version  
@author MCS Tecnologia
@since 1/14/2026
@return variant, return_description
/*/
User Function MCSOBRIG()

    Local cParMast    := xTabMaster+"MASTER"
    Local oModel := FWModelActive()
    Local xAlias := oModel:GetValue(cParMast, xTabMaster+'_ALIAS')
    Local lRet   := .F.

    If AllTrim(xAlias) $ '1#2'
        lRet := .T. 
    EndIf

Return lRet

/*/{Protheus.doc} MCSCOPY
Copia
@type function
@version  
@author MCS Tecnologia
@since 3/19/2026
@return variant, return_description
/*/
User Function MCSCOPY()

    Local oModel
	Local aArea        := GetArea()
	Local cTitulo      := "Copia das regras"
	Local cPrograma    := "MCSCONF"
	Local nOperation   := 3
	Local nLin         := 0
	Local nCol         := 0
	Local nTamanGrid1   := 0
    Local nTamanGrid2   := 0
    Local nTamanGrid3   := 0
    Local nTamanGrid4   := 0
    Local nTamanGrid5   := 0
    Local nTamanGrid6   := 0
    Local nTamanGrid7   := 0
    Local nTamanGrid8   := 0
    Local nTamanGrid9   := 0
    Local aCampos1      := {}
    Local aCampos2      := {}
    Local aCampos3      := {}
    Local aCampos4      := {}
    Local aCampos5      := {}
    Local aCampos6      := {}
    Local aCampos7      := {}
    Local aCampos8      := {}
    Local aCampos9      := {}

	
	//Caso precise testar em algum lugar
	__lCopia     := .T.
	
	//Carrega o modelo de dados
	oModel := FWLoadModel(cPrograma)
	oModel:SetOperation(nOperation) // Inclusão
	oModel:Activate(.T.) // Ativa o modelo com os dados posicionados
	
	//Pegando o campo de chave
	cCodCd := GetSX8Num("ZZW", "ZZW_COD")
	ConfirmSX8()
	
	//Setando os campos do cabeçalho
	oModel:SetValue("ZZWMASTER", "ZZW_COD",  cCodCd)
	oModel:SetValue("ZZWMASTER", "ZZW_DESC", Alltrim(ZZW->ZZW_DESC))
    oModel:SetValue("ZZWMASTER", "ZZW_ALIAS", Alltrim(ZZW->ZZW_ALIAS))
    oModel:SetValue("ZZWMASTER", "ZZW_TIPPAR", Alltrim(ZZW->ZZW_TIPPAR))
    oModel:SetValue("ZZWMASTER", "ZZW_CONTRI", Alltrim(ZZW->ZZW_CONTRI))    
    oModel:SetValue("ZZWMASTER", "ZZW_SIMPLE", Alltrim(ZZW->ZZW_SIMPLE))
    oModel:SetValue("ZZWMASTER", "ZZW_SUFRAM", Alltrim(ZZW->ZZW_SUFRAM))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA1", Alltrim(ZZW->ZZW_REGRA1))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA2", Alltrim(ZZW->ZZW_REGRA2))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA3", Alltrim(ZZW->ZZW_REGRA3))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA4", Alltrim(ZZW->ZZW_REGRA4))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA5", Alltrim(ZZW->ZZW_REGRA5))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA6", Alltrim(ZZW->ZZW_REGRA6))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA7", Alltrim(ZZW->ZZW_REGRA7))
    oModel:SetValue("ZZWMASTER", "ZZW_REGRA8", Alltrim(ZZW->ZZW_REGRA8))
	
	//Pegando os dados do filho
	oModelGrid1 := oModel:GetModel("ZZYDETAIL")
    oModelGrid2 := oModel:GetModel("ZZXDETAIL")
    oModelGrid3 := oModel:GetModel("ZZVDETAIL")
    oModelGrid4 := oModel:GetModel("ZZSDETAIL")
    oModelGrid5 := oModel:GetModel("ZZUDETAIL")
    oModelGrid6 := oModel:GetModel("ZZTDETAIL")
    oModelGrid7 := oModel:GetModel("ZZRDETAIL")
    oModelGrid8 := oModel:GetModel("ZZQDETAIL")
    oModelGrid9 := oModel:GetModel("ZZPDETAIL")

	oStruct1    := oModelGrid1:GetStruct()
    oStruct2    := oModelGrid2:GetStruct()
    oStruct3    := oModelGrid3:GetStruct()
    oStruct4    := oModelGrid4:GetStruct()
    oStruct5    := oModelGrid5:GetStruct()
    oStruct6    := oModelGrid6:GetStruct()
    oStruct7    := oModelGrid7:GetStruct()
    oStruct8    := oModelGrid8:GetStruct()
    oStruct9    := oModelGrid9:GetStruct()

	aCampos1    := oStruct1:GetFields()
    aCampos2    := oStruct2:GetFields()
    aCampos3    := oStruct3:GetFields()
    aCampos4    := oStruct4:GetFields()
    aCampos5    := oStruct5:GetFields()
    aCampos6    := oStruct6:GetFields()
    aCampos7    := oStruct7:GetFields()
    aCampos8    := oStruct8:GetFields()
    aCampos9    := oStruct9:GetFields()
	
	//Se não for P12, pega do aCols, senão pega do aDataModel
	nTamanGrid1 := Iif(GetVersao(.F.) < "12", Len(oModelGrid1:aCols), Len(oModelGrid1:aDataModel))
    nTamanGrid2 := Iif(GetVersao(.F.) < "12", Len(oModelGrid2:aCols), Len(oModelGrid2:aDataModel))
    nTamanGrid3 := Iif(GetVersao(.F.) < "12", Len(oModelGrid3:aCols), Len(oModelGrid3:aDataModel))
    nTamanGrid4 := Iif(GetVersao(.F.) < "12", Len(oModelGrid4:aCols), Len(oModelGrid4:aDataModel))
    nTamanGrid5 := Iif(GetVersao(.F.) < "12", Len(oModelGrid5:aCols), Len(oModelGrid5:aDataModel))
    nTamanGrid6 := Iif(GetVersao(.F.) < "12", Len(oModelGrid6:aCols), Len(oModelGrid6:aDataModel))
    nTamanGrid7 := Iif(GetVersao(.F.) < "12", Len(oModelGrid7:aCols), Len(oModelGrid7:aDataModel))
    nTamanGrid8 := Iif(GetVersao(.F.) < "12", Len(oModelGrid8:aCols), Len(oModelGrid8:aDataModel))
    nTamanGrid9 := Iif(GetVersao(.F.) < "12", Len(oModelGrid9:aCols), Len(oModelGrid9:aDataModel))
	
	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid1
	
		//Setando a linha atual
		oModelGrid1:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos1)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos1[nCol][3]) == "ZZY_CODPER"
				oModel:SetValue("ZZ3DETAIL", aCampos1[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
            If Alltrim(aCampos1[nCol][3]) == "ZZY_DESC"
				oModel:SetValue("ZZYDETAIL", aCampos1[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol

	Next nLin

	oModelGrid1:SetLine(1)  

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid2
	
		//Setando a linha atual
		oModelGrid2:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos2)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos2[nCol][3]) == "ZZX_GRPTRI"
				oModel:SetValue("ZZXDETAIL", aCampos2[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol

	Next nLin
	oModelGrid2:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid3
	
		//Setando a linha atual
		oModelGrid3:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos3)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos3[nCol][3]) == "ZZV_EST"
				oModel:SetValue("ZZVDETAIL", aCampos3[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
            //Se for a coluna desejada, irá zerar
			If Alltrim(aCampos3[nCol][3]) == "ZZV_CODMUN"
				oModel:SetValue("ZZVDETAIL", aCampos3[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
            //Se for a coluna desejada, irá zerar
			If Alltrim(aCampos3[nCol][3]) == "ZZV_DESC"
				oModel:SetValue("ZZVDETAIL", aCampos3[nCol][3], "Linha "+cValToChar(nLin))
			EndIf

		Next nCol

	Next nLin

	oModelGrid3:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid4
	
		//Setando a linha atual
		oModelGrid4:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos4)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos4[nCol][3]) == "ZZS_UF"
				oModel:SetValue("ZZSDETAIL", aCampos4[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos4[nCol][3]) == "ZZS_CODMUN"
				oModel:SetValue("ZZSDETAIL", aCampos4[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
            //Se for a coluna desejada, irá zerar
			If Alltrim(aCampos4[nCol][3]) == "ZZS_DESC"
				oModel:SetValue("ZZSDETAIL", aCampos4[nCol][3], "Linha "+cValToChar(nLin))
			EndIf            
		Next nCol

	Next nLin
	oModelGrid4:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid5
	
		//Setando a linha atual
		oModelGrid5:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos5)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos5[nCol][3]) == "ZZU_EST"
				oModel:SetValue("ZZUDETAIL", aCampos5[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos5[nCol][3]) == "ZZU_DESC"
				oModel:SetValue("ZZUDETAIL", aCampos5[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol
	Next nLin
	oModelGrid5:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid6
	
		//Setando a linha atual
		oModelGrid6:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos6)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos6[nCol][3]) == "ZZT_NCM"
				oModel:SetValue("ZZTDETAIL", aCampos6[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol

	Next nLin

	oModelGrid6:SetLine(1) 
    
    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid7
	
		//Setando a linha atual
		oModelGrid7:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos7)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos7[nCol][3]) == "ZZR_NCM"
				oModel:SetValue("ZZRDETAIL", aCampos7[nCol][3], "Linha "+cValToChar(nLin))
			EndIf

		Next nCol

	Next nLin

	oModelGrid7:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid8
	
		//Setando a linha atual
		oModelGrid8:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos8)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos8[nCol][3]) == "ZZQ_ORIGEM"
				oModel:SetValue("ZZQDETAIL", aCampos8[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
            //Se for a coluna desejada, irá zerar
			If Alltrim(aCampos8[nCol][3]) == "ZZQ_DESC"
				oModel:SetValue("ZZQDETAIL", aCampos8[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol

	Next nLin

	oModelGrid8:SetLine(1) 

    	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid9
	
		//Setando a linha atual
		oModelGrid9:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos9)
		
			//Se for a coluna desejada, irá zerar
			If Alltrim(aCampos9[nCol][3]) == "ZZP_TIPO"
				oModel:SetValue("ZZPDETAIL", aCampos9[nCol][3], "Linha "+cValToChar(nLin))
			EndIf

		Next nCol

	Next nLin

	oModelGrid9:SetLine(1) 
	
	//Executando a visualização dos dados para manipulação
	nRet     := FWExecView( cTitulo , cPrograma, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
	__lCopia := .F.
	oModel:DeActivate()
	
	//Se a cópia for confirmada
	If nRet == 0
		MsgInfo("Cópia Realizada com sucesso!", "Atenção")
	EndIf
	
	RestArea(aArea)

Return oModel
