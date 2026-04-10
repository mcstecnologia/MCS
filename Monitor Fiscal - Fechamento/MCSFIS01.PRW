#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"



//------------------------------------------------------------------
/*/{Protheus.doc} FISA170

Rotina com a concetração de todos os cadastros do motor fiscal tributário

@author Erick G. Dias
@since 21/06/1028
@version 12.1.17

/*/
//------------------------------------------------------------------
User Function MCSFIS01()

	Private oBrowse
	Private oPanelBrw
	Private lclicked      := .T.
	Private lclickedI     := .T.
	Private lclickedO     := .T.
	Private c170AlsHist   := ""
    Private xTabela       := SuperGetMV("MV_XTABFIS",.F.,"WZA")

	DbSelectArea ("F20")
				
	FWExecView("Rotina de Monitor Fiscal",'MCSFIS01', MODEL_OPERATION_INSERT,, { || .T. } ,{ || .T. }  ) //"Rotinas do Motor de Cálculo de Tributos Fiscais"

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function MenuDef()
 
Local aRotina := {}

Return ( aRotina )


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel
Local oStructABA := FWFormStruct( 1, xTabela)

oModel	:=	MPFormModel():New('MODEL_ABA',,{|oModel| .T. },{|oModel| .T. })
oModel:AddFields( 'MODEL_ABA' ,, oStructABA )
oModel:SetPrimaryKey( { 'ABA_CMP1'} )
oModel:SetDescription( 'MCS')

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function ViewDef()
    Local oModel    := FWLoadModel( 'MCSFIS01' )
    Local oView     := FWFormView():New()
    Local oStruABA   := FWFormStruct( 2, xTabela )

    oView:SetModel( oModel )

    oView:AddField( 'VIEW_ABA', oStruABA, 'MODEL_ABA' )

    //Retiro o ID da view
    oStruABA:RemoveField(xTabela+'_ID')

    oView:AddOtherObject( 'PANEL_TREE',  { |oPanel| MONTATREE( oPanel ) } )
    oView:AddOtherObject( 'PANEL_EMPTY', { |oPanel| } )
    oView:AddOtherObject( 'PANEL_BROWSE',{ |oPanel| oPanelBrw := oPanel, FBrowseMon( oPanel ) } )

    oView:EnableTitleView('PANEL_TREE',"Rotinas") //"Rotinas Disponíveis"

    oView:CreateHorizontalBox( 'INFO_FUNC'	  	,00 )
    oView:CreateHorizontalBox( 'EVENTO_FUNC'	,98 )
    oView:CreateHorizontalBox( 'FIM_TELA'   	,02 )

    oView:CreateVerticalBox( 'INFO_FUNC_ESQ'		, 100	,'INFO_FUNC' )
    oView:CreateVerticalBox( 'EVENTO_FUNC_ESQ'		, 27	,'EVENTO_FUNC' )
    oView:CreateVerticalBox( 'EVENTO_FUNC_CENTER'	, 01	,'EVENTO_FUNC' )
    oView:CreateVerticalBox( 'EVENTO_FUNC_DIR'		, 72	,'EVENTO_FUNC' )
    oView:CreateVerticalBox( 'FIM_TELA_EMPTY'		, 100	, 'FIM_TELA' )

    oView:SetOwnerView( 'VIEW_ABA'		, 'INFO_FUNC_ESQ' )
    oView:SetOwnerView( 'PANEL_TREE'	, 'EVENTO_FUNC_ESQ' )
    oView:SetOwnerView( 'PANEL_EMPTY'	, 'EVENTO_FUNC_CENTER' )
    oView:SetOwnerView( 'PANEL_BROWSE'	, 'EVENTO_FUNC_DIR' )
    oView:SetOwnerView( 'PANEL_EMPTY'	, 'FIM_TELA_EMPTY' )

    oView:AddUserButton("Rotinas Disponíveis","", {|| MCSROTINAS() }) //"Relação de Rotinas"

Return oView       

//-------------------------------------------------------------------
/*/{Protheus.doc} x174Rotinas

@author joao.pellegrini
@since 26/10/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function MCSROTINAS()

    Local oDialog := NIL
    Local aRotinas := {}
    Local aLines := {}
    Local aSize := MsAdvSize()
    Local oBrwRot := NIL
    Local oColluns := NIL
    Local oPanel := NIL
    Local nX := 0
    Local aData := {}

    Default lAutomato := .F.


    aAdd(aRotinas, {"MCSFIS01.PRW", "Rotina Principal"}) 
    aAdd(aRotinas, {"MCSFIS02.PRW", "Criar Cenário Análise"}) 
    aAdd(aRotinas, {"MCSFIS03.PRW", "Gerar Análise"}) 
    aAdd(aRotinas, {"MCSFIS04.PRW", "Consulta"})

    oDialog := FWDialogModal():New()
    oDialog:SetBackground(.T.) // .T. -> escurece o fundo da janela 
    oDialog:SetTitle("Relação das Rotinas") //"Relação de Rotinas"
    oDialog:SetEscClose(.F.)//permite fechar a tela com o ESC
    oDialog:SetSize(aSize[4] * 0.8, aSize[3] * 0.8) // chamar sempre antes do CreateDialog
    oDialog:EnableFormBar(.T.) 
    oDialog:CreateDialog() //cria a janela (cria os paineis)
    oDialog:addCloseButton()
    oDialog:CreateFormBar()//cria barra de botoes

    // Crio as linhas do browse com base na lista de rotinas relacionadas
    For nX := 1 to Len(aRotinas)

        aData := GetAPOInfo( aRotinas[nX, 1] )

        If Len(aData) >= 5

            aAdd(aLines, {})
            aAdd(aLines[Len(aLines)], .F.)
            aAdd(aLines[Len(aLines)], aRotinas[nX, 1]) // Rotina
            aAdd(aLines[Len(aLines)], aRotinas[nX, 2]) // Descrição
            aAdd(aLines[Len(aLines)], DtoC(aData[4])) // Data no RPO
            aAdd(aLines[Len(aLines)], aData[5]) // Horário no RPO

        EndIf

    Next nX

    oPanel := oDialog:GetPanelMain()

    DEFINE FWBROWSE oBrwRot DATA ARRAY ARRAY aLines LINE BEGIN 1 OF oPanel

    ADD COLUMN oColluns DATA &("{ || aLines[oBrwRot:At()][2]}") TITLE "Rotina" SIZE 10 OF oBrwRot // "Rotina"
    ADD COLUMN oColluns DATA &("{ || aLines[oBrwRot:At()][3]}") TITLE "Descricao" SIZE 100 OF oBrwRot // "Descrição"
    ADD COLUMN oColluns DATA &("{ || aLines[oBrwRot:At()][4]}") TITLE "Data" SIZE 10 OF oBrwRot // "Data no RPO"
    ADD COLUMN oColluns DATA &("{ || aLines[oBrwRot:At()][5]}") TITLE "Hora" SIZE 10 OF oBrwRot // "Hora no RPO"

    oBrwRot:OptionConfig(.F.)


    ACTIVATE FWBROWSE oBrwRot
    oDialog:Activate()
    

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MontaTree
Função que cria tree com as rotinas disponíveis

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------

STATIC FUNCTION MontaTree(oPanel)

Local oTree
Local aCoors 	:= {} //FWGetDialogSize( oPanel )
Local bChange 	:= { || FChgTree( oTree )  }
Local aNodes	:= {}
Local IMAGE1 	:= "FOLDER5"
Local IMAGE2 	:= "FOLDER6"
Local Icon		:= "PMSEDT3"

aadd(aNodes,{'00',"000","","Geração das análises",IMAGE1,IMAGE2})  //"Regras Fiscais"
//Cadastro
aadd(aNodes,{'01',"000","","Cadastro",IMAGE1,IMAGE2})  //"Cadastros"
aadd(aNodes,{'02',"001","","Cenário" + Space(10),Icon,Icon})  //"Tributo"
//Analise
aadd(aNodes,{'01',"000","","Análise",IMAGE1,IMAGE2})  //"Perfis"
aadd(aNodes,{'02',"002","","Gerar Análise",Icon,Icon})  //"Perfil de Produto"
//Consulta
aadd(aNodes,{'01',"000","","Consulta",IMAGE1,IMAGE2})  //"Perfis"
aadd(aNodes,{'02',"003","","Consulta Fechamento",Icon,Icon})  //"Perfil de Produto"



oSize := FwDefSize():New(.T.,,,.T.)
oSize:AddObject('PANEL_TREE'  ,100,100,.T.,.T.)
oSize:lProp 	:= .T. // Proporcional             
oSize:aMargins 	:= { 0, 0, 0, 0 } // Espaco ao lado dos objetos 0, entre eles 3 
oSize:Process()

aAdd(aCoors,{oSize:GetDimension("PANEL_TREE", "COLINI"),oSize:GetDimension("PANEL_TREE", "LININI"),oSize:GetDimension("PANEL_TREE", "YSIZE")*0.97,oSize:GetDimension("PANEL_TREE", "COLEND")*0.26})

oTree := DbTree():New( aCoors[1][2], aCoors[1][1], aCoors[1][3], aCoors[1][4], oPanel,bChange , , .T. )
oTree:PTSendTree( aNodes )
oTree:CurrentNodeId := "000" 
oTree:TreeSeek("000")
oTree:SetScroll(1,.T.)
oTree:SetScroll(2,.T.)
//oTree:SetCss(GetCssTree())
oTree:PTRefresh()

Return ()

//-------------------------------------------------------------------
/*/{Protheus.doc} FChgTree 

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------

Static Function FChgTree(oTree) 

    Local cIdTreePos := ""

    Local aInfTree := {}

    //Busco a identificação de qual item da Tree estamos posicionadoss
    oTree:PTRefresh()
    cIdTreePos := oTree:CurrentNodeId
    oPanelBrw:FreeChildren()
    oBrowse:DeActivate()
    aInfTree := MCSFUNC( cIdTreePos )
    FBrowseMon( oPanelBrw, aInfTree[1], aInfTree[2], aInfTree[3], aInfTree[4] , oTree:GetPrompt(.T.) == "Regras Financeiras", cIdTreePos,aInfTree[5]) //"Regras Financeiras"
    oBrowse:Refresh()

Return ( Nil )

//-------------------------------------------------------------------
/*/{Protheus.doc} FSA170FUNC
Função que identifica a opção selecionada pelo usuário e abre a rotina
pertinente a opção selecionada.

@author Erick G. Dias
@since 21/06/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function MCSFUNC( cIdTreePos )

Local aRet   			:= Array( 05 )


    Do Case

        //*************************
        //CADASTROS
        //*************************
        Case cIdTreePos == "001" //Tributo
            aRet[1] 	:= 'MCSFIS02'
            aRet[2] 	:= "WZA"
            aRet[3] 	:= ""
            aRet[4] 	:= "Cenário"	 //"Tributo"
        Case cIdTreePos == "002" // unidade referencial fiscal		
            aRet[1] 	:= 'MCSFIS03'
            aRet[2] 	:= "F29"
            aRet[3] 	:= ""
            aRet[4] 	:= "Gerar Análise" //"Unidade Ref. Fiscal"*/	
        Case cIdTreePos == "003" // unidade referencial fiscal		
            aRet[1] 	:= 'MCSFIS04'
            aRet[2] 	:= "F29"
            aRet[3] 	:= ""
            aRet[4] 	:= "Consulta" //"Unidade Ref. Fiscal"*/
        OtherWise
            aRet[1] 	:= ""
            aRet[2] 	:= ""
            aRet[3] 	:= ""
            aRet[4] 	:= ""		      

    EndCase

Return ( aRet )

//------------------------------------------------------------------
/*/{Protheus.doc} GetCssTree

Função que monta o CSS do menu lateral

@author Erick G. Dias
@since 04/02/2020
@version 12.1.30
/*/
//------------------------------------------------------------------
static function GetCssTree()

    Local cCSS	:= ""

    cCSS +=	 "QTreeView{"
    cCSS += "  font-size: 14px; /*tamanho do fonte*/"
    cCSS +="  border: 2px solid #40698d; /*cor da borda*/"
    cCSS +="  background: #F5FBE7"
    cCSS +="}"
    cCSS +="/*Caracteristicas do item*/"
    cCSS +="QTreeView::item {"
    cCSS +="  color: #40698d; /*cor da font*/"
    cCSS +=""
    cCSS +="  /*Pintura da barra esquerda do item selecionado*/"
    cCSS +="  border: 1px solid #40698d; "
    cCSS +="  border-top-color: transparent;"
    cCSS +="  border-bottom-color: transparent;"
    cCSS +="}"
    cCSS +="/*Caracteristicas do item selecionado*/"
    cCSS +="QTreeView::item:selected {"
    cCSS +="  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,"
    cCSS +="              stop: 0 #FAC08F, stop: 1 #FDEADA); /*cor de fundo*/"
    cCSS +="}"
    cCSS +="/*Caracteristicas do item, quando mouse posicionado sobre ele*/"
    cCSS +="QTreeView::item:hover {"
    cCSS +="  background: #d8dfe7; /*cor de fundo*/"
    cCSS += "}"

Return cCSS

//-------------------------------------------------------------------
/*/{Protheus.doc} FBrowseMon

@author Erick G. Dias
@since 07/03/2018
@version 12.1.17

/*/
//-------------------------------------------------------------------
Static Function FBrowseMon( oPanel, cFonteTree, cAliasTree, cFiltroBrw, cDescBrw, lFinanceiro, cIdTreePos, cIndxBrw )

    Local cFunc := "MethIsMemberOf"

    Default cFonteTree := ""
    Default cAliasTree := ""
    Default cFiltroBrw := ""
    Default cDescBrw   := ""
    Default cIndxBrw   := ""
    Default cIdTreePos	:= "000"

    oBrowse := FWmBrowse():New()

    If &cFunc.(oBrowse,"SetMainProc")
        oBrowse:SetMainProc("MCSFIS01")
    EndIf

    If Empty( cFonteTree ) .And. Empty( cAliasTree ) 
        aInf := MCSFUNC("")

        cFonteTree := aInf[1]
        cAliasTree := aInf[2]
        cFiltroBrw := aInf[3]
        cDescBrw   := aInf[4]		
        cIndxBrw   := aInf[5]
    EndIf

    If !Empty(cAliasTree)
        oBrowse:SetOwner( oPanel )
        oBrowse:SetDescription( cDescBrw )
        oBrowse:SetAlias( cAliasTree )

        If (cIdTreePos >= "200" .And. cIdTreePos <= "300")
            (cAliasTree)->(DbSetOrder(2))
        EndIf

        IF !Empty(cIndxBrw)
            (cAliasTree)->(DbSetOrder(cIndxBrw))
        Endif

        /*Do Case
            Case cAliasTree == "FKK"
                oBrowse:AddLegend( "FKK_ATIVO == '1' " , "GREEN", STR0029 )  //"Regra Financeira Ativa"
                oBrowse:AddLegend( "FKK_ATIVO == '2' " , "RED"  , STR0030 )  //"Regra Financeira Inativa"
            Case cAliasTree == "F2H"
                oBrowse:AddLegend( "F2H_STATUS == '1' " , "BR_VERMELHO" , STR0031 ) //"Saldo Devedor - Não Gerou Título"
                oBrowse:AddLegend( "F2H_STATUS == '2' " , "BR_AMARELO"  , STR0032 ) //"Saldo Devedor - Título Gerado"
                oBrowse:AddLegend( "F2H_STATUS == '3' " , "BR_AZUL"     , STR0033 ) //"Saldo Credor"
                oBrowse:AddLegend( "F2H_STATUS == '4' " , "BR_BRANCO"   , STR0034 ) //"Sem Saldos"
                oBrowse:AddLegend( "F2H_STATUS == '5' " , "BR_VERDE"    , STR0035 ) //"Contabilizado"
            Case cAliasTree == "F2B" .and. F2B->(FieldPos("F2B_STATUS")) > 0
                oBrowse:AddLegend("F2B_STATUS == '1'", "YELLOW", "Regra em teste")
                oBrowse:AddLegend("F2B_STATUS == '2' .Or. F2B_STATUS == ' '", "GREEN", "Regra aprovada")
        EndCase*/

        oBrowse:SetMenuDef( cFonteTree )
        oBrowse:DisableDetails()
        oBrowse:SetFilterDefault( cFiltroBrw )

        oBrowse:Activate()
    EndIF

Return ( Nil )
