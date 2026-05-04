#Include "Protheus.ch"
#Include "TOTVS.CH"
#Include "FWMVCDef.CH"
/*/{Protheus.doc} MCSGERA
description
@type function
@version  
@author MCS Tecnologia
@since 4/29/2026
@return variant, return_description
/*/
User Function MCSGERA()

    Local aPar           := MCSPARAM()
    Local aCampos        :=  {}

    Private xTitulo     := "Notas de Débito"
    Private xAliasGrid   := GetNextAlias()
    Private oBrowse    :=  Nil    
    Private oGrd1

    If Len(aPar) > 0

        If aPar[8] == 4

            If oGrd1 <> Nil
                oGrd1:Delete()
                oGrd1  :=  Nil
            Endif
 
            oGrd1  :=  FWTemporaryTable():New(xAliasGrid)


            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Campos da tabela temporária                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            //Add(aCampos,{"SELE"    ,"L",1,00})
            aAdd(aCampos,{"FILIAL"  ,"C",10,00})
            aAdd(aCampos,{"FIN_PREF","C",30,00})
            aAdd(aCampos,{"FIN_NUM" ,"C",15,2})
            aAdd(aCampos,{"FIN_PAR" ,"C",15,2})
            aAdd(aCampos,{"FIN_TIP","N",15,2})
            aAdd(aCampos,{"FIN_CLI","N",15,2})
            aAdd(aCampos,{"FIN_LOJ","N",15,2})
            aAdd(aCampos,{"FAT_NCL","N",15,2})
            aAdd(aCampos,{"FAT_DOC","N",15,2})
            aAdd(aCampos,{"FIN_EMI","D",15,2})
            aAdd(aCampos,{"FIN_VCT","D",10,0})
            aAdd(aCampos,{"FIN_BAX","D",10,0})
            aAdd(aCampos,{"FIN_VLT","N",15,2})
            aAdd(aCampos,{"FIN_VJU","N",15,2})
            aAdd(aCampos,{"FAT_QTI","N",15,2})
            aAdd(aCampos,{"FAT_CIB","C",1,0})
            aAdd(aCampos,{"FIN_JPI","N",15,2})
            aAdd(aCampos,{"FAT_DKN","C",1,0})
            
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Nome dos campos                                                    ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            aTitulos := {'Filial', "Prefixo", "Título", "Parcela.","Tipo","Cliente","Loja","Nome" ,"Documento","Série" ,"Emissão", "Vencimento", "Baixa",;
                         "Valor", "Vlr.Juros", "Qtde. Itens", "CBS/IBS", "Juros por item", "DKN"}
            
            aGrd1 := MCSCPBRO(aCampos,aTitulos)
 
 
            oGrd1:SetFields(aCampos)
            oGrd1:AddIndex("1", {"FILIAL","FIN_PREF","FIN_NUM","FIN_PAR"})
            oGrd1:Create()
            //Obtenho o nome "verdadeiro" da tabela no BD (criada como tempor ria)
            xTableGr1  :=  oGrd1:GetRealName()


            MsgRun("Carregando dados de para montagem da tela...",,{||CursorWait(),MCSGRV(aPar),CursorArrow()})

            dbSelectArea(xAliasGrid)

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Montagem do browse                                     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            oBrowse :=  FwMBrowse():New()
            oBrowse:SetDescription("Dados para geração da nota de débito") 
            oBrowse:SetAlias(xAliasGrid) 
            oBrowse:SetWalkThru(.F.)
            oBrowse:SetAmbiente(.T.) 
            oBrowse:SetTemporary(.T.)
            oBrowse:SetFields(aCampos)
            /*oBrowse:AddLegend( "DIF_VAL == 0", "GREEN", "Correto" )
            oBrowse:AddLegend( "DIF_VAL <> 0", "RED",   "Incorreto" )*/
            oBrowse:Activate()

            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Excluindo tabela temporária                                   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If oGrd1 <> Nil
                oGrd1:Delete()
                oGrd1  :=  Nil
            Endif

        Else 
            
        EndIf
    Else 
        FWAlertWarning("Não foram informados os parâmetros necessários para geração da nota de débito.")
    EndIf

Return

/*/{Protheus.doc} MenuDef
description
@type function
@version  
@author rodri
@since 4/29/2026
@return variant, return_description
/*/
Static Function MenuDef()
    Local aRot  :=  {}
     
    ADD OPTION aRot TITLE 'Detalhes'    ACTION 'VIEWDEF.MCON001'OPERATION 4 ACCESS 0 
    ADD OPTION aRot TITLE 'Relatorio'   ACTION 'U_MCON01A()'    OPERATION 4 ACCESS 0 
 
Return(Aclone(aRot))

/*/{Protheus.doc} ModelDef
Modelo de dados da tabela 
@type function
@version  
@author MCS Tecnologia
@since 4/29/2026
@return variant, return_description
/*/
Static Function ModelDef()
    Local oModel   :=  Nil
    Local osGrd1   :=  FWFormModelStruct():New()
    Local nX
    /*Local bPre     :=  {|oModel, cAction, cIDField, xValue| validPre(oModel, cAction, cIDField, xValue)}
    Local bPos     :=  {|oModel| fieldValidPos(oModel)}*/
    Local bLoaGr1  :=  {|oModel, lCopy| loadGrd(oModel, lCopy,"GR1")}
 
    For nX := 1 to Len(aBrows)
        aBrows[nX,6]=.F.
    Next
    osCabec:AddTable(cAlisCab, {"ID"}, "Concilicao Financeira")
 
    For nX := 1 to Len(aGrd1)
        aadd(aGrd1[nX],.F.)
    Next
 
    /*----------------------------------------------------------------------
    Estrutura do array para montagem dos campos usados na funcao MntStrut
        1 - Descricao
        2 - Nome do Campo
        3 - Tipo do campo
        4 - Tamanho do campo
        5 - Decimal
        6 - Se campo e editavel
    ------------------------------------------------------------------------*/
   
    MntStrut(@osGrd1,cAlisGr1,aGrd1)  
 
    osGrd1:AddTable(cAlisGr1,, "Nota Débito"    ,{|| oGrd1:GetRealName()})   
 
    oModel  :=  FWFormModel():New( 'XMCSGERA',,,{|oModel| commit()},{|oModel| cancel()})   
 
     
    //oModel:AddFields( 'ID_M_FLD', , osCabec,bPre,bPos,bLoad)
    oModel:AddGrid( 'ID_M_GRD1', 'ID_M_FLD', osGrd1, /*bLinePre*/, /*{|oModelZA2| ValLinha(oModelZA2)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, bLoaGr1/*bLoad1*/)
 
    //oModel:SetRelation( 'ID_M_GRD1', {{'ID','ID'}}, (cAlisGr1)->(IndexKey(1)))
 
    oModel:GetModel( 'ID_M_GRD1' ):SetUniqueLine( { 'ITEM'} )
    oModel:SetPrimaryKey({ 'ID' })
 
    //oModel:AddCalc( 'TOTAL', 'ID_M_FLD', 'ID_M_GRD1',  'SALDO'    , '_nVlrOcor', 'SUM' , ,,'Total Saldo',/*{ |oModel| AGL300H( oModel)} */  )
 
    oModel:SetDescription( 'Registros para nota de débito' )
    oModel:GetModel( 'ID_M_GRD1' ):SetDescription( 'Contabilidade' )
     
Return oModel

/*/{Protheus.doc} ViewDef
Monta a view 
@type function
@version  
@author rodri
@since 4/29/2026
@return variant, return_description
/*/
Static Function ViewDef()
    Local oModel  :=  FWLoadModel("MCSGERA")
    Local osGrd1  :=  FWFormViewStruct():New()
    Local oView  :=  Nil
    Local nX
    Local aDadCab  := {}
    Local aDadGr1  := {}
    Local aDadGr2  := {}
 
    /*----------------------------------------------------------------------
    Estrutura do array para montagem dos campos usados na funcao MntView
        1 - Nome do Campo
        2 - Ordem
        3 - Titulo do campo
        4 - Tipo do campo
        5 - Picture
        6 - Se campo e editavel
    ------------------------------------------------------------------------*/
    For nX := 1 to Len(aGrd1)
        IF aGrd1[nX,3] = "C"
            cPict := "@!"
        ElseIF aGrd1[nX,3] = "N"
            cPict := "@E 9,999,999.99"
        Else
            cPict := ""
        EnDIF
        aADD(aDadGr1,{aGrd1[nX,2],StrZero(nX,2),aGrd1[nX,1],aGrd1[nX,3],cPict,.F.})
    Next
 
    For nX := 1 to Len(aGrd2)
         IF aGrd2[nX,3] = "C"
             cPict := "@!"
         ElseIF aGrd2[nX,3] = "N"
             cPict := "@E 9,999,999.99"
         Else
             cPict := ""
         EnDIF
        aADD(aDadGr2,{aGrd2[nX,2],StrZero(nX,2),aGrd2[nX,1],aGrd2[nX,3],cPict,.F.})
    Next

    MCSVIEW(@osGrd1,aDadGr1)
 
    oView  :=  FWFormView():New()
    oView:SetModel(oModel)
 
    oView:AddGrid("ID_V_GRD1", osGrd1, "ID_M_GRD1") 
 
    oView:CreateHorizontalBox("SUPERIOR",100)
    /*oView:CreateVerticalBox('ESQUERDA', 50 , 'INFERIOR')
    oView:CreateVerticalBox("DIREITA",  50 , 'INFERIOR')*/
     
    oView:SetOwnerView( 'ID_V_GRD1'   , 'SUPERIOR' )
 
    //Colocando título do formulário

    oView:EnableTitleView('ID_V_GRD1', 'Registros para nota de débito' )  
   
    oView:SetCloseOnOk({||.T.})

Return oView

/*/{Protheus.doc} MCSCPBRO
Campso do Broswse
@type function
@version  
@author rodri
@since 4/29/2026
@param aCampos, array, param_description
@param aTitulos, array, param_description
@return variant, return_description
/*/
Static Function MCSCPBRO(aCampos,aTitulos)
    Local nX
    Local aBrows := {}
 
    For nX := 1 to Len(aCampos)
        aAdd(aBrows,{aTitulos[nX], aCampos[nX,1] ,aCampos[nX,2] ,aCampos[nX,3] ,aCampos[nX,4]})
    Next

Return aBrows

/*/{Protheus.doc} MCSVIEW
Monta a view
@type function
@version  
@author MCS Tecnologia
@since 4/29/2026
@param oObj, object, param_description
@param aCampos, array, param_description
@return variant, return_description
/*/
Static Function MCSVIEW(oObj,aCampos)

    Local nX
 
    For nX := 1 to Len(aCampos)
        //Adicionando campos da estrutura
        oObj:AddField(;
            aCampos[nX,1],;                  // [01]  C   Nome do Campo
            aCampos[nX,2],;                  // [02]  C   Ordem
            aCampos[nX,3],;                  // [03]  C   Titulo do campo
            aCampos[nX,3],;                  // [04]  C   Descricao do campo
            Nil,;                            // [05]  A   Array com Help
            aCampos[nX,4],;                  // [06]  C   Tipo do campo
            aCampos[nX,5],;                  // [07]  C   Picture
            Nil,;                            // [08]  B   Bloco de PictTre Var
            Nil,;                            // [09]  C   Consulta F3
            aCampos[nX,6],;                  // [10]  L   Indica se o campo é alteravel
            Nil,;                            // [11]  C   Pasta do campo
            Nil,;                            // [12]  C   Agrupamento do campo
            Nil,;                            // [13]  A   Lista de valores permitido do campo (Combo)
            Nil,;                            // [14]  N   Tamanho maximo da maior opção do combo
            Nil,;                            // [15]  C   Inicializador de Browse
            Nil,;                            // [16]  L   Indica se o campo é virtual
            Nil,;                            // [17]  C   Picture Variavel
            Nil;                             // [18]  L   Indica pulo de linha após o campo
        )
    Next
 
Return

/*/{Protheus.doc} MCSSTR
Monta a estrutura
@type function
@version  
@author rodri
@since 4/29/2026
@param oObj, object, param_description
@param cAlias, character, param_description
@param aCampos, array, param_description
@return variant, return_description
/*/
Static Function MCSSTR(oObj,cAlias, aCampos)

    Local nX
    Default aCampos := {}
 
    For nX := 1 to Len(aCampos)
        oObj:AddField(;
            aCampos[nX,1],;                                                                                  // [01]  C   Titulo do campo
            aCampos[nX,1],;                                                                                  // [02]  C   ToolTip do campo
            aCampos[nX,2],;                                                                                  // [03]  C   Id do Field
            aCampos[nX,3],;                                                                                  // [04]  C   Tipo do campo
            aCampos[nX,4],;                                                                                  // [05]  N   Tamanho do campo
            aCampos[nX,5],;                                                                                  // [06]  N   Decimal do campo
            Nil,;                                                                                            // [07]  B   Code-block de validação do campo
            Nil,;                                                                                            // [08]  B   Code-block de validação When do campo
            {},;                                                                                             // [09]  A   Lista de valores permitido do campo
            .F.,;                                                                                            // [10]  L   Indica se o campo tem preenchimento obrigatório
            FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,('"+cAlias+"')->"+aCampos[nX,2]+",'')" ),;   // [11]  B   Code-block de inicializacao do campo
            .T.,;                                                                                            // [12]  L   Indica se trata-se de um campo chave
            aCampos[nX,6],;                                                                                  // [13]  L   Indica se o campo pode receber valor em uma operação de update.
            .F.;                                                                                             // [14]  L   Indica se o campo é virtual
        )
 
        IF aCampos[nX,6]
            oObj:SetProperty(aCampos[nX,2], MODEL_FIELD_WHEN, { || .T.})
            oObj:SetProperty(aCampos[nX,2], MODEL_FIELD_NOUPD,.F.)
        EndIF
    Next
Return

/*/{Protheus.doc} MCSPARAM
Tela e parâmetros
@type function
@version  
@author MCS Tecnologia
@since 4/16/2026
@return variant, return_description
/*/
Static Function MCSPARAM()

	Local aParams  := {}
	Local aRet     := {}
	Local aRetPar  := {}

	aadd(aParams, { 1, "Data de  "      , Ctod(Space(08)), , '.T.','   ', '.T.', 65, .F. })
	aadd(aParams, { 1, "Data Até "      , Ctod(Space(08)), , '.T.','   ', '.T.', 65, .F. })
	aadd(aParams, { 1, "Documento de "	   , Space(GetSx3Cache("F2_DOC"   ,  "X3_TAMANHO" )), , '.T.','SF2' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Documento até "	   , Space(GetSx3Cache("F2_DOC"   ,  "X3_TAMANHO" )), , '.T.','SF2' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Série "	   	       , Space(GetSx3Cache("F2_SERIE" ,  "X3_TAMANHO" )), , '.T.','SF2' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Cli/For "	       , Space(GetSx3Cache("A1_COD"   ,  "X3_TAMANHO" )), , '.T.','SA1',	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Loja   "	       , Space(GetSx3Cache("A1_LOJA"  ,  "X3_TAMANHO" )), , '.T.','  ' ,	'.T.',	65,	.F.})
	aadd(aParams, { 2, "Tipo"              , 4 , {"1-Transferência de créditos para cooperativas","2-Anulação de créditos por saídas imunes/isentas","3-Débitos de notas fiscais processadas na apuração","4-Multa e juros", "5-Transferência de crédito de sucesso","6-Pagamento antecipado","7-Perda em estoque","8-Desenquadramento do Simples Nacional"}                            , 100, ".T.", .T.})


	If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,"Nota Débito",.T.,.T.)
		aRetPar := AjRetPar(aRet,aParams)
	Endif

Return(aRetPar)


Static Function AjRetPar(aRet,aParams)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta os Parâmetros                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local xInc := 0

	If ValType(aRet) == "A" .and. Len(aRet) == Len(aParams)
		For xInc := 1 To Len(aParams)
			If aParams[xInc,1] == 1
				aRet[xInc] := aRet[xInc]
			ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
				aRet[xInc] := aScan(aParams[xInc,4], {|x| Alltrim(x) == aRet[xInc]})
			ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
				aRet[xInc] := aRet[xInc]
			ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "N"
				aRet[xInc] := aRet[xInc]
			Endif
		Next xInc
	Endif

Return(aClone(aRet))

/*/{Protheus.doc} MCSGRV
Grava os registros na tabela temporária
@type function
@version  
@author MCS Tecnologia
@since 4/29/2026
@param aPar, array, param_description
@return variant, return_description
/*/
Static function MCSGRV(aPar)

    Local aArea    := FWGetArea()
    Local xQuery   := ""
    Local aCampos  :=  {}
    Local oTabela 

    aAdd(aCampos,{"FILIAL"   ,"C",6,0})
    aAdd(aCampos,{"PREFIXO"  ,"C",TamSx3("E1_PREFIXO")[1],0})
    aAdd(aCampos,{"NUMERO"   ,"C",TamSx3("E1_NUM")[1],0})
    aAdd(aCampos,{"PARCELA"  ,"C",TamSx3("E1_PREFIXO")[1],0})
    aAdd(aCampos,{"TIPO"     ,"C",TamSx3("E1_TIPO")[1],0})
    aAdd(aCampos,{"CLIENTE"  ,"C",TamSx3("E1_CLIENTE")[1],0})
    aAdd(aCampos,{"LOJA"     ,"C",TamSx3("E1_LOJA")[1],0})
    aAdd(aCampos,{"DOCUMENTO","C",TamSx3("F2_DOC")[1],0})
    aAdd(aCampos,{"SERIE"    ,"C",TamSx3("F2_SERIE")[1],0})
    aAdd(aCampos,{"EMISSAO"  ,"D",TamSx3("E1_EMISSAO")[1],0})
    aAdd(aCampos,{"VENCTO"   ,"D",TamSx3("E1_VENCTO")[1],0})
    aAdd(aCampos,{"BAIXA"    ,"D",TamSx3("E1_BAIXA")[1],0})
    aAdd(aCampos,{"VLRTIT"   ,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]})
    aAdd(aCampos,{"VLRJUR"   ,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]})
    aAdd(aCampos,{"QTDITE"   ,"N",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2]})
    aAdd(aCampos,{"CALCIBS"  ,"C",1,0})
    aAdd(aCampos,{"JURITE"   ,"N",TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2]})
    aAdd(aCampos,{"DKN"      ,"C",1,0})
 
    oTabela  :=  FWTemporaryTable():New( "xTabDeb" )
    oTabela:SetFields(aCampos)
    oTabela:AddIndex("1", {"FILIAL","PREFIXO","NUMERO","PARCELA"})
    //------------------
    //Criação da tabela temporaria
    //------------------
    oTabela:Create()
 
    xQuery := "SELECT " + chr(13)
    xQuery += "    E1.E1_FILIAL      AS FILIAL, " + chr(13)
    xQuery += "    E1.E1_PREFIXO     AS PREFIXO, " + chr(13)
    xQuery += "    E1.E1_NUM         AS TITULO, " + chr(13)
    xQuery += "    E1.E1_PARCELA     AS PARCELA, " + chr(13)
    xQuery += "    E1.E1_TIPO        AS TIPO, " + chr(13)
    xQuery += "    E1.E1_CLIENTE     AS COD_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA        AS LOJA, " + chr(13)
    xQuery += "    D2.D2_DOC         AS DOCUMENTO, " + chr(13)
    xQuery += "    D2.D2_SERIE       AS SERIE, " + chr(13)
    xQuery += "    E1.E1_NOMCLI      AS NOME_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_EMISSAO     AS DT_EMISSAO, " + chr(13)
    xQuery += "    E1.E1_VENCTO      AS DT_VENCIMENTO, " + chr(13)
    xQuery += "    E1.E1_BAIXA       AS DT_BAIXA, " + chr(13)
    xQuery += "    E1.E1_VALOR       AS VALOR_TITULO, " + chr(13)
    xQuery += "    E1.E1_JUROS       AS VALOR_JUROS, " + chr(13)
    xQuery += "    COUNT(D2.D2_ITEM) AS QTDE_ITENS_SD2, " + chr(13)
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN ISNULL(MAX(D2.D2_IDTRIB),'') <> '' THEN 'SIM' " + chr(13)
    xQuery += "        ELSE 'NÃO' " + chr(13)
    xQuery += "    END AS CALCULA_IBS_CBS, " + chr(13)
    xQuery += "    CASE " + chr(13) 
    xQuery += "        WHEN COUNT(D2.D2_ITEM) > 0 " + chr(13) 
    xQuery += "        THEN E1.E1_JUROS / COUNT(D2.D2_ITEM) " + chr(13)
    xQuery += "        ELSE 0 " + chr(13)
    xQuery += "    END AS VALOR_JUROS_POR_ITEM, " + chr(13)
    xQuery += "    CASE " + chr(13)
    xQuery += "        WHEN MAX(CASE WHEN DKN.DKN_DOCREF IS NOT NULL THEN 1 ELSE 0 END) = 1 " + chr(13)
    xQuery += "        THEN 'SIM' " + chr(13)
    xQuery += "        ELSE 'NÃO' " + chr(13)
    xQuery += "    END AS EXISTE_DKN " + chr(13)
    xQuery += "FROM " +RetSqlName("SE1")+ " E1 " + chr(13)
    xQuery += "LEFT JOIN " +RetSqlName("SD2")+ " D2 " + chr(13)
    xQuery += "    ON  D2.D2_FILIAL  = E1.E1_FILIAL " + chr(13)
    xQuery += "    AND D2.D2_DOC     = E1.E1_NUM " + chr(13)
    xQuery += "    AND D2.D2_SERIE   = E1.E1_PREFIXO " + chr(13)
    xQuery += "    AND D2.D2_CLIENTE = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND D2.D2_LOJA    = E1.E1_LOJA " + chr(13)
    xQuery += "    AND D2.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "LEFT JOIN " +RetSqlName("DKN")+ " DKN " + chr(13)
    xQuery += "    ON  DKN.DKN_FILIAL = E1.E1_FILIAL " + chr(13)
    xQuery += "    AND DKN.DKN_DOCREF = E1.E1_NUM " + chr(13)
    xQuery += "    AND DKN.DKN_SERREF = E1.E1_PREFIXO " + chr(13)
    xQuery += "    AND DKN.DKN_CLIFOR = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND DKN.DKN_LOJA   = E1.E1_LOJA " + chr(13)
    xQuery += "    AND DKN.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "INNER JOIN " +RetSqlName("SA1")+ " A1 " + chr(13)
    xQuery += "    ON  A1.A1_FILIAL  = '" +FwxFilial("SA1") + "' " + chr(13)
    xQuery += "    AND A1.A1_COD     = E1.E1_CLIENTE " + chr(13)
    xQuery += "    AND A1.A1_LOJA    = E1.E1_LOJA " + chr(13)
    xQuery += "WHERE E1.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "  AND E1.E1_BAIXA BETWEEN '"+dTos(aPar[1])+"' AND '"+dTos(aPar[2])+"' " + chr(13)
    xQuery += "  AND E1.E1_CLIENTE BETWEEN '"+aPar[6]+"' AND '"+aPar[6]+"' " + chr(13)
    xQuery += "  AND E1.E1_LOJA    BETWEEN '"+aPar[7]+"' AND '"+aPar[7]+"' " + chr(13)
    xQuery += "  AND ISNULL(E1.E1_JUROS,0) > 0 " + chr(13)
    xQuery += "GROUP BY " + chr(13)
    xQuery += "    E1.E1_FILIAL, " + chr(13)
    xQuery += "    E1.E1_PREFIXO, " + chr(13)
    xQuery += "    E1.E1_NUM, " + chr(13)
    xQuery += "    E1.E1_PARCELA, " + chr(13)
    xQuery += "    E1.E1_TIPO, " + chr(13)
    xQuery += "    E1.E1_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA, " + chr(13)
    xQuery += "    D2.D2_DOC, " + chr(13)
    xQuery += "    D2.D2_SERIE, " + chr(13)
    xQuery += "    E1.E1_NOMCLI, " + chr(13)
    xQuery += "    E1.E1_EMISSAO, " + chr(13)
    xQuery += "    E1.E1_VENCTO, " + chr(13)
    xQuery += "    E1.E1_BAIXA, " + chr(13)
    xQuery += "    E1.E1_VALOR, " + chr(13)
    xQuery += "    E1.E1_JUROS " + chr(13)
    xQuery += "ORDER BY " + chr(13)
    xQuery += "    E1.E1_CLIENTE, " + chr(13)
    xQuery += "    E1.E1_LOJA, " + chr(13)
    xQuery += "    E1.E1_NUM, " + chr(13)
    xQuery += "    E1.E1_PARCELA " + chr(13)

 
    //dbUseArea(.T., "TOPCONN", TCGenQry(,,xQuery), 'TRBSE1', .F., .T.)
    MpSysOpenQuery(xQuery, "TRBSE1", .F., .T.)

    //dbselectarea("TRBSE1")

    While !TRBSE1->(Eof())
        dbSelectArea(xAliasGrid)
         (xAliasGrid)->(dbSetOrder(1))
        Reclock((xAliasGrid),.t.)
        //Replace SELE    With .F.
        Replace FILIAL   With TRBSE1->FILIAL
        Replace PREFIXO  With TRBSE1->PREFIXO
        Replace FIN_PREF With TRBSE1->PREFIXO
        Replace FIN_NUM  With TRBSE1->E1_NUM
        Replace FIN_PAR  With TRBSE1->E1_PARCELA
        Replace FIN_TIP  With TRBSE1->E1_TIPO
        Replace FIN_CLI  With TRBSE1->E1_CLIENTE
        Replace FIN_LOJ  With TRBSE1->E1_LOJA
        Replace FAT_NCL  With TRBSE1->E1_NOMCLI
        Replace FAT_DOC  With TRBSE1->DOCUMENTO
        Replace FAT_SER  With TRBSE1->E1_SERIE
        Replace FIN_EMI  With TRBSE1->E1_EMISSAO
        Replace FIN_VCT  With TRBSE1->E1_VENCTO
        Replace FIN_BAX  With TRBSE1->E1_BAIXA
        Replace FIN_VLT  With TRBSE1->E1_VALOR
        Replace FIN_VJU  With TRBSE1->E1_JUROS
        Replace FAT_QTI  With TRBSE1->QTDE_ITENS_SD2
        Replace FAT_CIB  With TRBSE1->SALDO_ATUAL
        Replace FIN_JPI  With TRBSE1->TOTAL_DEBITOS
        Replace FAT_DKN  With TRBSE1->TOTAL_CREDITOS
        MsUnlock()
    EndDo
     
    FWRestArea(aArea)

Return
