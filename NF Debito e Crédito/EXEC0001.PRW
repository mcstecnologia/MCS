#Include 'Totvs.ch'
#Include 'FWMVCDef.ch'
  
Static cTitle   := "Grupo de Produtos em MVC"
Static cKey     := "FAKE"
Static nTamFake := 15
  
/*/{Protheus.doc} User Function zGrid
Visualizacao de Grupos de Produtos em MVC (com tabela temporaria)
@type  Function
@author Atilio
@since  14/06/2020
@version version
@obs Foi baseado no exemplo de Izac Ciszevski (https://centraldeatendimento.totvs.com/hc/pt-br/articles/360047143634-MP-ADVPL-Criando-uma-tela-MVC-s%C3%B3-com-GRID)
/*/
  
User Function zGrid()
    Local aArea := GetArea()
    Private cAliasTmp := "TMPSBM"
    Private oTempTable
  
    //Cria a temporária
    oTempTable := FWTemporaryTable():New(cAliasTmp)
      
    //Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
    aFields := {}
    aAdd(aFields, {"XXCODIGO",  "C", TamSX3('BM_GRUPO')[01],   0})
    aAdd(aFields, {"XXDESCRI",  "C", TamSX3('BM_DESC')[01],    0})
    aAdd(aFields, {"XXDATA",    "D", 8,                        0})
      
    //Define as colunas usadas, adiciona indice e cria a temporaria no banco
    oTempTable:SetFields( aFields )
    oTempTable:AddIndex("1", {"XXCODIGO"} )
    oTempTable:Create()
  
    //Executa a inclusao na tela
    FWExecView('GRID Sem Cabeçalho', "VIEWDEF.zGrid", MODEL_OPERATION_INSERT, , { || .T. }, , 30)
  
    //Agora percorre todos os dados digitados
    (cAliasTmp)->(DbGoTop())
    While ! (cAliasTmp)->(EoF())
        MsgInfo("Código: " + (cAliasTmp)->XXCODIGO + ", Descrição: " + (cAliasTmp)->XXDESCRI, "Atenção")
        (cAliasTmp)->(DbSkip())
    EndDo
  
    //Deleta a temporaria
    oTempTable:Delete()
      
    RestArea(aArea)
Return
  
Static Function ModelDef()
    Local oModel  As Object
    Local oStrField As Object
    Local oStrGrid As Object
    Local bLoad := {|oModel| fCarrGrid(oModel)}
    Local aGatilhos := {}
    Local nAtual    := 0
  
    //Criamos aqui uma estrutura falsa que sera uma tabela que ficara escondida no cabecalho
    oStrField := FWFormModelStruct():New()
    oStrField:AddTable('' , { 'XXTABKEY' } , cTitle, {|| ''})
    oStrField:AddField('String 01' , 'Campo de texto' , 'XXTABKEY' , 'C' , nTamFake)
  
    //Criamos aqui a estrutura da grid
    oStrGrid := FWFormModelStruct():New() 
    oStrGrid:AddTable(cAliasTmp, {'XXTABKEY', 'XXCODIGO', 'XXDESCRI', 'XXDATA'}, "Temporaria")
       
    //Adiciona os campos da estrutura
    oStrGrid:AddField(;
        "Codigo",;                                                                                  // [01]  C   Titulo do campo
        "Codigo",;                                                                                  // [02]  C   ToolTip do campo
        "XXCODIGO",;                                                                                // [03]  C   Id do Field
        "C",;                                                                                       // [04]  C   Tipo do campo
        04,;                                                                                        // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, cAliasTmp+"->XXCODIGO" ),;                           // [11]  B   Code-block de inicializacao do campo
        .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual
    oStrGrid:AddField(;
        "Descricao",;                                                                               // [01]  C   Titulo do campo
        "Descricao",;                                                                               // [02]  C   ToolTip do campo
        "XXDESCRI",;                                                                                // [03]  C   Id do Field
        "C",;                                                                                       // [04]  C   Tipo do campo
        50,;                                                                                        // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, cAliasTmp+"->XXDESCRI" ),;                           // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual
    oStrGrid:AddField(;
        "Data",;                                                                                    // [01]  C   Titulo do campo
        "Data",;                                                                                    // [02]  C   ToolTip do campo
        "XXDATA",;                                                                                  // [03]  C   Id do Field
        "D",;                                                                                       // [04]  C   Tipo do campo
        8,;                                                                                         // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, cAliasTmp+"->XXDATA" ),;                             // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual
  
    //Adicionando um gatilho, do codigo para data
    aAdd(aGatilhos, FWStruTriggger( ;
        "XXCODIGO",;                                //Campo Origem
        "XXDATA",;                                  //Campo Destino
        "u_zGridGat()",;                            //Regra de Preenchimento
        .F.,;                                       //Irá Posicionar?
        "",;                                        //Alias de Posicionamento
        0,;                                         //Índice de Posicionamento
        '',;                                        //Chave de Posicionamento
        NIL,;                                       //Condição para execução do gatilho
        "01");                                      //Sequência do gatilho
    )
  
    //Percorrendo os gatilhos e adicionando na Struct
    For nAtual := 1 To Len(aGatilhos)
        oStrGrid:AddTrigger( ;
            aGatilhos[nAtual][01],; //Campo Origem
            aGatilhos[nAtual][02],; //Campo Destino
            aGatilhos[nAtual][03],; //Bloco de código na validação da execução do gatilho
            aGatilhos[nAtual][04];  //Bloco de código de execução do gatilho
        )
    Next
 
    //Agora criamos o modelo de dados da nossa tela
    oModel := MPFormModel():New('zGridM')
    oModel:AddFields('CABID', , oStrField, , , bLoad)
    oModel:AddGrid('GRIDID', 'CABID', oStrGrid, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPos*/, bLoad)
    oModel:SetRelation('GRIDID', { { 'XXTABKEY', 'XXTABKEY' } })
    oModel:SetDescription(cTitle)
    oModel:SetPrimaryKey({ 'XXTABKEY' })
  
    //Ao ativar o modelo, irá alterar o campo do cabeçalho mandando o conteúdo FAKE pois é necessário alteração no cabeçalho
    oModel:SetActivate({ | oModel | FwFldPut("XXTABKEY", cKey) })
Return oModel
  
Static Function ViewDef()
    Local oView    As Object
    Local oModel   As Object
    Local oStrCab  As Object
    Local oStrGrid As Object
  
    //Criamos agora a estrtutura falsa do cabeçalho na visualização dos dados
    oStrCab := FWFormViewStruct():New()
    oStrCab:AddField('XXTABKEY' , '01' , 'String 01' , 'Campo de texto', , 'C')
  
    //Agora a estrutura da Grid
    oStrGrid := FWFormViewStruct():New()
   
    //Adicionando campos da estrutura
    oStrGrid:AddField(;
        "XXCODIGO",;                // [01]  C   Nome do Campo
        "01",;                      // [02]  C   Ordem
        "Codigo",;                  // [03]  C   Titulo do campo
        "Codigo",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStrGrid:AddField(;
        "XXDESCRI",;                // [01]  C   Nome do Campo
        "02",;                      // [02]  C   Ordem
        "Descricao",;               // [03]  C   Titulo do campo
        "Descricao",;               // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStrGrid:AddField(;
        "XXDATA",;                  // [01]  C   Nome do Campo
        "03",;                      // [02]  C   Ordem
        "Data",;                    // [03]  C   Titulo do campo
        "Data",;                    // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
  
    //Carrega o ModelDef
    oModel  := FWLoadModel('zGrid')
  
    //Agora na visualização, carrega o modelo, define o cabeçalho e a grid, e no cabeçalho coloca 0% de visualização, e na grid coloca 100%
    oView := FwFormView():New()
    oView:SetModel(oModel)
    oView:AddField('CAB', oStrCab, 'CABID')
    oView:AddGrid('GRID', oStrGrid, 'GRIDID')
    oView:CreateHorizontalBox('TOHID', 0)
    oView:CreateHorizontalBox('TOSHOW', 100)
    oView:SetOwnerView('CAB' , 'TOHID')
    oView:SetOwnerView('GRID', 'TOSHOW')
    oView:SetDescription(cTitle)
Return oView
 
//Função acionada no bLoad, por se tratar de uma temporária com cabeçalho fake, foi usado FWLoadByAlias para carregar o default e depois adicionar via ponto de entrada
Static Function fCarrGrid(oSubModel)
    Local aReg  := {}
     
    If ( oSubModel:GetId() == "GRIDID" )
        aReg := FWLoadByAlias(oSubModel,oTempTable:GetAlias(),oTempTable:GetRealName())
    Else
        aReg := {{cKey},0}  
    EndIf
Return aReg
 
/*/{Protheus.doc} User Function zGridGat
Função que será acionada pelo gatilho do campo código para o campo data
@type  Function
@author Atilio
@since 26/05/2022
/*/
 
User Function zGridGat()
    Local aArea      := FWGetArea()
    Local dDtRetorno := Date()
 
    FWRestArea(aArea)
Return dDtRetorno
 
 
/*/{Protheus.doc} User Function zGridM
Ponto de entrada zGridM
@author Atilio
@since 27/05/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
     *-------------------------------------------------*
     Por se tratar de um p.e. em MVC, salve o nome do 
     arquivo diferente, por exemplo, zGridM_pe.prw 
     *-----------------------------------------------*
     A documentacao de como fazer o p.e. esta disponivel em https://tdn.totvs.com/pages/releaseview.action?pageId=208345968 
@see http://autumncodemaker.com
/*/
 
User Function zGridM()
    Local aArea := FWGetArea()
    Local aParam := PARAMIXB 
    Local xRet := .T.
    Local oObj := Nil
    Local cIdPonto := ""
    Local cIdModel := ""
    Local nLinha
    Local oModel
    Local oModelGrid
    Local oView
     
    //Se tiver parametros
    If aParam != Nil
         
        //Pega informacoes dos parametros
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
         
        //Após carregar toda a tela e estar na adição de botões
        If cIdPonto == "BUTTONBAR"
            xRet := {}
 
            //Intercepta o Model, a Grid e a View
            oModel      := FWModelActive()
            oModelGrid  := oModel:GetModel("GRIDID")
            oView        := FWViewActive()
 
            //Limpando a grid
            If oModelGrid:CanClearData()
                oModelGrid:ClearData()
            EndIf
             
            //Percorrendo 5 linhas
            For nLinha := 1 To 5
                oModelGrid:AddLine()
                oModelGrid:GoLine(nLinha)
                oModelGrid:LoadValue("XXCODIGO", "GRP" + cValToChar(nLinha))
                oModelGrid:LoadValue("XXDESCRI", "Grupo teste " + cValToChar(nLinha))
                oModelGrid:LoadValue("XXDATA",   DaySub(Date(), nLinha))
            Next
 
            //Posiciona na linha 1
            oModelGrid:GoLine(1)
            oView:Refresh()
 
        EndIf
         
    EndIf
     
    FWRestArea(aArea)
    
Return xRet
