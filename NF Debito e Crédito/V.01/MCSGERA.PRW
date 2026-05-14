#Include "Protheus.ch"


/*/{Protheus.doc} GERANOTA
Execauto para gravação da nota de debito e crédito
@type function
@version  
@author rodri
@since 4/30/2026
@param aRegs, array, param_description
@param nTipo, numeric, param_description
@param xTes, variant, param_description
@param xCond, variant, param_description
@return variant, return_description
/*/
User Function MCSGERA()

	Local aArea     := ""
    Local xAliDoc   := SuperGetMV("XX_ALIAS",.F.,"WW1")
	Local xDoc      := ""
	Local xSerie    := ""
	Local xCli      := ""
	Local xLoja     := ""
	Local xTipo     := ""
	Local nVal	  	:= 0
	Local cMarca    := ""
    Local lInverte  
	Local nCt       
	Local xId       := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ GetArea para a tabela de monitoramento                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aArea := &(xAliDoc+"->"+"(GetArea())")

    &(xAliDoc+"->"+"(DbGoTop())")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valido se vem da tela de marcação                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FunName() == "MCSTELA1"

		cMarca    := oMark:Mark()
		lInverte  := oMark:IsInvert()

		While &(xAliDoc+"->"+"(!EoF())")		

		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        	//³ Valida se não foi gerada nota e está marcado no browse             ³
        	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If &(xAliDoc+"->"+xAliDoc+"_NFEOK") == 'N' .And. oMark:IsMark(cMarca)
				xDoc 	:= &(xAliDoc+"->"+xAliDoc+"_DOCUME")
				xSerie 	:= &(xAliDoc+"->"+xAliDoc+"_SERIE")
				xCli 	:= &(xAliDoc+"->"+xAliDoc+"_CLIENT")
				xLoja 	:= &(xAliDoc+"->"+xAliDoc+"_LOJA")
				xTipo   := &(xAliDoc+"->"+xAliDoc+"_TPNOTA")
				nVal    := Iif(xTipo == '4',&(xAliDoc+"->"+xAliDoc+"_JURITE"),0)

				aRegs := fBuscaSD2(xDoc, xSerie, xCli, xLoja)

				U_GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal)

				nCt++
					/*//Limpando a marca
					RecLock(xAliDoc, .F.)
						ZZ1_OK := ''
					ZZ1->(MsUnlock())*/
			EndIf 
			//Pulando registro
			(xAliDoc)->(DbSkip())
    	EndDo

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Valida se o registro selecionado esteja com NF gerada                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If &(xAliDoc+"->"+xAliDoc+"_NFEOK") == 'S'
			xDoc := &(xAliDoc+"->"+xAliDoc+"_DOCUMEN")
			xId  := &(xAliDoc+"->"+xAliDoc+"_ID")
			FWAlertWarning("Para o registro ID: " + xId +" Nota: " + xDoc + "já foi gerada NF","Totvs")
			Return
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Armazena nas variáveis para envio a rotina de geração              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xDoc 	:= &(xAliDoc+"->"+xAliDoc+"_DOCUME")
		xSerie 	:= &(xAliDoc+"->"+xAliDoc+"_SERIE")
		xCli 	:= &(xAliDoc+"->"+xAliDoc+"_CLIENT")
		xLoja 	:= &(xAliDoc+"->"+xAliDoc+"_LOJA")
		xTipo   := &(xAliDoc+"->"+xAliDoc+"_TPNOTA")
		nVal    := Iif(xTipo == '4',&(xAliDoc+"->"+xAliDoc+"_JURITE"),0)

		aRegs := fBuscaSD2(xDoc, xSerie, xCli, xLoja)

		U_GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal)

	EndIf

	FwRestArea(aArea)

Return

/*/{Protheus.doc} GERANOTA
Gera nota de débito e crédito
@type function
@version  
@author rodri
@since 5/2/2026
@param xDoc, variant, param_description
@param xSerie, variant, param_description
@param xCli, variant, param_description
@param xLoja, variant, param_description
@param xTipo, variant, param_description
@return variant, return_description
/*/
User Function GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal)

	Local xSerie        	:= SuperGetMV("MV_NDCSERI",.F.,"9")
	Local xAliDoc       	:= SuperGetMV("XX_ALIAS",.F.,"WW1")
	Local aArea         	:= ""
	Local aAreaF4       	:= SF4->(GetArea("SF4"))
	Local aAreaF2       	:= SF2->(GetArea("SF2"))
	Local xInc          	:= 0
	Local xEst          	:= GetMV("MV_ESTADO")
	Local aDocumentos   	:= {}
	Local jFld600       	:= JsonObject():new()
	Local oDoc1         	:= JsonObject():New()
	Local oDoc2         	:= JsonObject():New()
	Local xTes          	:= "506"
	Local aMsg          	:= {}

	Private lAutoErrNoFile 	:= .F.
	Private lMsErroAuto     := .F.
	Private oModelNCND   	:= Nil
	Private jDocRef      	:= JsonObject():new()

	SF4->(dbSelectArea("SF4"))
	SF4->(dbSetOrder(1))

	SF4->(dbSeek(xFilial("SF4")+xTes))

	jFld600["F2_TPCOMPL"] := AllTrim(xTipo)

	jFld600["F2_SERIE"] := xSerie
	jFld600["A1_COD"]   := xCli
	jFld600["A1_LOJA"]  := xLoja

	//INICIA AS VARIAVEIS PARA REALIZAR A EXECAUTO DO MATA600
	A600IniObj(jFld600)

	oModelNCND := FwLoadModel('MATA600')

	//SETA A OPERACAO PARA INCLUSAO DA NF
	oModelNCND:SetOperation(3)

	oModelNCND:Activate()

	If oModelNCND:IsActive()

		If xTipo == '3' .Or. xTipo == '4' .Or. xTipo == '8'
			//CABEÇALHO
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" , jFld600["F2_TPCOMPL"])
			oModelNCND:LoadValue( "CABMASTER"   , "F2_CLIENTE" , jFld600["A1_COD"]) //**IMPORTANTE ESSE CAMPO DEVE SER UTILIZADO SOMENTE LOADVALUE PARA PREENCHIMENTO
			oModelNCND:SetValue( "CABMASTER"    , "F2_LOJA"    , jFld600["A1_LOJA"])
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    , '000')
			//oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  , "000001")

			For xInc := 1 To Len(aRegs)

				oModelNCND:GetModel('ITENSDETAIL'):AddLine()
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    , PadL(AllTrim(Str(xInc)), 2, '0'))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     , aRegs[xInc][5])
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_QUANT"   , 1)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , Iif(xTipo == '4',nVal,aRegs[xInc][8]))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TOTAL"   , Iif(xTipo == '4',nVal,aRegs[xInc][8]))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     , xTes)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_CF"      , Iif(xEst == aRegs[xInc][11], "5"+SubStr(SF4->F4_CF,2,3),"6"+SubStr(SF4->F4_CF,2,3)))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_LOCAL"   , aRegs[xInc][7])
					//DOCUMENTOS DE REFERENCIA
				jDocRef["itens"] := {JsonObject():new()}
				jDocRef["itens"][1]["item"] := PadL(AllTrim(Str(xInc)), 2, '0') //Código do item da nota de débito
				jDocRef["itens"][1]["produto"] := aRegs[xInc][5]                  //Código do produto da nota de débito

				jDocRef["itens"][1]["documentos"] :={JsonObject():new()}
				jDocRef["itens"][1]["documentos"][1]["item"]         := aRegs[xInc][6]  //Item da nota referenciada
				jDocRef["itens"][1]["documentos"][1]["documento"]    := xDoc  //Número da nota referenciada
				jDocRef["itens"][1]["documentos"][1]["serie"]        := xSerie   //Série da nota referenciada
				jDocRef["itens"][1]["documentos"][1]["cliente"]      := xCli    //Código do Cliente da nota referenciada
				jDocRef["itens"][1]["documentos"][1]["loja"]         := xLoja    //Código da Loja do Cliente da nota referenciada
				jDocRef["itens"][1]["documentos"][1]["chave"]        := aRegs[xInc][10]      //Chave NFe do documento referenciado
				jDocRef["itens"][1]["documentos"][1]["intemxml"]     := PadL(AllTrim(Str(xInc)), 4, '0')  //Item XML utilizado apenas para notas de debito 4 (Campo D2_ITEM) e 7 (Campo D1_ITXML).
			
			Next xInc

		ElseIf xTipo == '5'
			//CABEÇALHO
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" ,jFld600["F2_TPCOMPL"])
			oModelNCND:LoadValue( "CABMASTER"   , "F2_CLIENTE" ,jFld600["A1_COD"]) //**IMPORTANTE ESSE CAMPO DEVE SER UTILIZADO SOMENTE LOADVALUE PARA PREENCHIMENTO
			oModelNCND:SetValue( "CABMASTER"    , "F2_LOJA"    ,jFld600["A1_LOJA"])
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    ,"000")
			oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  ,"000001")

			For xInc := 1 To Len(aRegs)
				//ITENS
				oModelNCND:GetModel('ITENSDETAIL'):AddLine()
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    ,PadL(AllTrim(Str(xInc)), 2, '0'))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     ,aRegs[xInc][5])
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , 50)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     ,"506")

				/*oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    ,"02")
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     ,"FAT002                        ")
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , 100)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     ,"999")*/

				//DOCUMENTOS DE REFERENCIA

				// Documento 1
				oDoc1["documento"] := xDoc //Número da nota referenciada
				oDoc1["serie"]     := xSerie //Série da nota referenciada
				oDoc1["chave"]     := aRegs[xInc][10] //Chave NFe da nota referenciada
				oDoc1["cliente"]   := xCli //Código do Cliente da nota referenciada
				oDoc1["loja"]      := xLoja //Código da Loja do Cliente da nota referenciada

				AAdd(aDocumentos, oDoc1)

			Next xInc

			/*// Documento 2
			oDoc2["documento"] := "PGVR03   " //Número da nota referenciada
			oDoc2["serie"]     := "1  " //Chave NFe da nota referenciada
			oDoc2["chave"]     := "                                            " //Série da nota referenciada
			oDoc2["cliente"]   := "PGVR01" //Código do Cliente da nota referenciada
			oDoc2["loja"]      := "01" //Código da Loja do Cliente da nota referenciada

			AAdd(aDocumentos, oDoc2)*/

			// Atribui array ao JSON principal
			jDocRef["documentos"] := aDocumentos

		EndIf
		If oModelNCND:VldData()
			oModelNCND:CommitData()
			ConOut('Registros Incluidos com Sucesso !')

			RecLock(xAliDoc, .F.)
   				&(xAliDoc+"->"+xAliDoc+"_NFEOK")    := "S"
				&(xAliDoc+"->"+xAliDoc+"_DKN")      := "S"
			&(xAliDoc+"->"+"(MsUnlock())")

			If !IsBlind()
				FWAlertSuccess("Nota Fiscal de Débito/Crédito inserida com sucesso :" + SF2->F2_DOC, "Totvs")
			EndIf

			MCSGRVLOG("0",xTipo,xCli+xLoja+"||"+xDoc+xSerie,"Processo realizado com sucesso")
		Else
			MostraErro()
			ConOut('Erro')
			MCSGRVLOG("1",xTipo,xCli+xLoja+"||"+xDoc+xSerie,"Erro na inclusão")
		EndIf
	EndIf

	oModelNCND:Destroy()
	FwFreeObj(oModelNCND)

	RestArea(aAreaF4)
	RestArea(aAreaF2)
	RestArea(aArea)

Return

/*/{Protheus.doc} fBuscaSD2
Busca os dados da gravação da nota de débito
@type function
@version  
@author rodri
@since 5/2/2026
@param xDoc, variant, param_description
@param xSerie, variant, param_description
@param xCli, variant, param_description
@param xLoja, variant, param_description
@return variant, return_description
/*/
Static Function fBuscaSD2(xDoc, xSerie, xCli, xLoja)

	Local aRegs 	:= {}
	Local xAlias 	:= GetNextAlias()
	Local xQuery 	:= ""

	xQuery := "SELECT D2_DOC AS DOC, D2_SERIE AS SERIE, D2_CLIENTE AS CLIFOR, D2_LOJA AS LOJA, D2_COD AS PROD, D2_ITEM AS ITEM, B1_LOCPAD AS LOCPAD, D2_PRCVEN AS VALOR, D2_QUANT AS QUANT, F2_CHVNFE AS CHVNFE, D2_EST AS UF " + chr(13)
	xQuery += "FROM " +RetSqlName("SD2") + " D2 " + chr(13)
	xQuery += "INNER JOIN " +RetSqlName("SB1") + " B1" + chr(13)
	xQuery += "ON B1.B1_COD = D2.D2_COD" + chr(13)
	xQuery += "AND B1.B1_FILIAL = '" + FwxFilial("SB1") + "' " + chr(13)
	xQuery += "INNER JOIN " +RetSqlName("SF2") + " SF2" + chr(13)
	xQuery += "ON SF2.F2_FILIAL = D2.D2_FILIAL AND SF2.F2_DOC = D2.D2_DOC AND SF2.F2_SERIE = D2.D2_SERIE " + chr(13)
	xQuery += " AND SF2.F2_CLIENTE = D2.D2_CLIENTE AND SF2.F2_LOJA = D2.D2_LOJA " + chr(13)
	xQuery += "WHERE D2_FILIAL = '" + FwxFilial("SD2") + "' " + chr(13)
	xQuery += "AND D2_DOC = '"+xDoc+"' " + chr(13)
	xQuery += "AND D2_SERIE = '"+AllTrim(xSerie)+"' " + chr(13)
	xQuery += "AND D2_CLIENTE = '"+AllTrim(xCli)+"' " + chr(13)
	xQuery += "AND D2_LOJA = '"+AllTrim(xLoja)+"' " + chr(13)
	xQuery += "AND D2.D_E_L_E_T_ = ' ' " + chr(13)
	xQuery += "AND B1.D_E_L_E_T_ = ' ' " + chr(13)

	MpSysOpenQuery(xQuery,xAlias)

	(xAlias)->(dbGoTop())

	While !(xAlias)->(Eof())
		aAdd(aRegs,{(xAlias)->DOC, (xAlias)->SERIE, (xAlias)->CLIFOR, (xAlias)->LOJA, (xAlias)->PROD, (xAlias)->ITEM, (xALias)->LOCPAD, (xAlias)->VALOR, (xAlias)->QUANT, (xAlias)->CHVNFE, (xAlias)->UF})
		(xAlias)->(dbSkip())
	EndDo

	(xAlias)->(DbCloseArea())

Return aRegs


/*/{Protheus.doc} MCSGRVLOG
Grava o log do registro do monitor
@type function
@version  
@author MCS Tecnologia
@since 5/8/2026
@param xStatus, variant, param_description
@param xChave, variant, param_description
@return variant, return_description
/*/
Static Function MCSGRVLOG(xStatus,xTipo,xChave,xMsg)

	
    Local xAliDoc   := SuperGetMV("XX_ALILOG",.F.,"WW3")
	LOcal aArea := &(xAliDoc+"->"+"(GetArea())")
    Local xDoc      := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Executa o reclock - executando em macro &                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xDoc := GetSx8Num(xAliDoc,xAliDoc+"_ID")

    Begin Transaction

        RecLock(xAliDoc, .T.)
            &(xAliDoc+"->"+xAliDoc+"_FILIAL")   := FWxFilial(xAliDoc)
            &(xAliDoc+"->"+xAliDoc+"_ID")       := xDoc
            &(xAliDoc+"->"+xAliDoc+"_TIPO")     := xTipo
            &(xAliDoc+"->"+xAliDoc+"_CHAVE")    := xChave
            &(xAliDoc+"->"+xAliDoc+"_DATA")     := dDataBase
			&(xAliDoc+"->"+xAliDoc+"_HORA")     := Time()
			&(xAliDoc+"->"+xAliDoc+"_USER")     := UsrRetName(__cUserId)
			&(xAliDoc+"->"+xAliDoc+"_MSG")      := xMsg
			&(xAliDoc+"->"+xAliDoc+"_STATUS")   := xStatus
        &(xAliDoc+"->"+"(MsUnlock())")

    	ConfirmSx8()

	End Transaction

    //U_MCSLOG("INFO","MCSJOB","Execução da rotina de gravação da: " + xAliDoc)
    Conout("Log gravado com sucesso ")
            
    RestArea(aArea)

Return
