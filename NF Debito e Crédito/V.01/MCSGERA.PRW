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
User Function MCSGERA(xDoc,xSerie,xCli,xLoja,xTipo,nVal)

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
	Local xTitulo   := ""

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
				xId     := &(xAliDoc+"->"+xAliDoc+"_ID")
				nVal    := Iif(xTipo == '4',&(xAliDoc+"->"+xAliDoc+"_VLRJUR"),0)

				aRegs := fBuscaSD2(xDoc, xSerie, xCli, xLoja)

				U_GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal,xId)

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
		//³ Trato, pois se a rotina de JOB estiver na pilha, já vem os dados    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !IsInCallStack('U_MCSJOB')

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
			xId     := &(xAliDoc+"->"+xAliDoc+"_ID")
			nVal    := Iif(xTipo == '4',&(xAliDoc+"->"+xAliDoc+"_VLRJUR"),0)

		EndIf

		If xTipo $ '4/5'
			aRegs := fBuscaSD2(xDoc, xSerie, xCli, xLoja)
		Else 
			aRegs := fBuscaSC6(xDOc,xCli,xLoja)
		EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Chamo a função que efetiva a gravação da nota                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal,xId)

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
User Function GERANOTA(xDoc,xSerie,xCli,xLoja,xTipo,aRegs,nVal,xId)

	Local xSerCple        	:= SuperGetMV("MV_NDCSERI",.F.,"9")
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
	Local xId               := ""
	Local nQtdTot           := 0
	Local nValJur           := 0
	Local nNexId            := 0
	Local aIdFK7            := {}

	Private lAutoErrNoFile 	:= .T.
	Private lMsErroAuto     := .F.
	Private oModelNCND   	:= Nil
	Private jDocRef      	:= JsonObject():new()


    aAreaTab := &(xAliDoc+"->"+"(GetArea())")
	&(xAliDoc+"->"+"(DbGoTop())")

	SF4->(dbSelectArea("SF4"))
	SF4->(dbSetOrder(1))

	SF4->(dbSeek(xFilial("SF4")+xTes))

	jFld600["F2_TPCOMPL"] := AllTrim(xTipo)

	jFld600["F2_SERIE"] := xSerCple
	jFld600["A1_COD"]   := xCli
	jFld600["A1_LOJA"]  := xLoja

	//INICIA AS VARIAVEIS PARA REALIZAR A EXECAUTO DO MATA600
	A600IniObj(jFld600)

	oModelNCND := FwLoadModel('MATA600')

	//SETA A OPERACAO PARA INCLUSAO DA NF
	oModelNCND:SetOperation(3)

	oModelNCND:Activate()

	nQtdTot := GetQtdTot(xDoc,xSerie,xCli,xLoja)

	If oModelNCND:IsActive()

		If xTipo == '3' .Or. xTipo == '4' .Or. xTipo == '7'
			//CABEÇALHO
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" , jFld600["F2_TPCOMPL"])
			oModelNCND:LoadValue( "CABMASTER"   , "F2_CLIENTE" , jFld600["A1_COD"]) //**IMPORTANTE ESSE CAMPO DEVE SER UTILIZADO SOMENTE LOADVALUE PARA PREENCHIMENTO
			oModelNCND:SetValue( "CABMASTER"    , "F2_LOJA"    , jFld600["A1_LOJA"])
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    , '000')
			//oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  , "000001")

			For xInc := 1 To Len(aRegs)

				xTes := fRetTes(SubStr(aRegs[xInc][12],2,3))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Controle para TES não encontrada na rotina de CF x TES              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty(xTes)
					xId  := &(xAliDoc+"->"+xAliDoc+"_ID")
					MCSGRVLOG("1",xTipo,xCli+xLoja+"registro"+xId,"Erro na inclusão - TES não encontrada na rotina de CF x Tes, verifique")
					Return
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz o rateio proporcional dos juros conforme a quantidade de cada prod          ³
				//https://tdn.totvs.com/pages/releaseview.action?pageId=1013620273
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If xTipo == '4'
					nValJur := (aRegs[xInc][13] / nQtdTot) * nVal
				EndIf

				oModelNCND:GetModel('ITENSDETAIL'):AddLine()
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    , PadL(AllTrim(Str(xInc)), 2, '0'))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     , aRegs[xInc][5])
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_QUANT"   , 1)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , Iif(xTipo == '4',nValJur,aRegs[xInc][8]))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TOTAL"   , Iif(xTipo == '4',nValJur,aRegs[xInc][8]))
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

		ElseIf xTipo == '6'
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" ,xTipo) //PAGAMENTO ANTECIPADO
			oModelNCND:LoadValue("CABMASTER"   , "F2_CLIENTE" ,xCli)
			oModelNCND:SetValue("CABMASTER"     , "F2_LOJA"    ,xLoja)
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    ,"000")
			//oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  ,"000001")

			For xInc := 1 To Len(aRegs)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Controle para TES não encontrada na rotina de CF x TES              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				xTes := fRetTes(SubStr(aRegs[xInc][4],2,3))

				oModelNCND:GetModel('ITENSDETAIL'):AddLine()
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    ,PadL(AllTrim(Str(xInc)), 2, '0'))
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     ,aRegs[xInc][1])
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  ,aRegs[xInc][2])
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     ,xTes)
				oModelNCND:SetValue( "ITENSDETAIL"    , "D2_LOCAL"   ,aRegs[xInc][3])

			Next xInc

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Busca os IDS da FK7 dos títulos amarrados na antecipação           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aIdFK7 := QryIDDOC(xDoc,xCli,xLoja)

			jParam['billBranch']       := FWxFilial("SE1") //Filial do Protheus que será consultada (informar código completo)
			jParam['participantCode']  := xCli //Código do Cliente
			jParam['participantUnit']  := xLoja //Loja do Cliente
			jParam['documentBranch']   := cFilant //Variável cFilAnt
			jParam['documentSeries']   := jFld600["F2_SERIE"] //Série da Nota Fiscal
			jParam['mainSourceTable']  := "SF2" //Tabela de origem
			jParam['identification']   := {} //Identificadores (chave) dos títulos (RA) - FK7_IDDOC

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava para cada id encontradp                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nNexId := 1 To Len(aIdFK7)
				AADD(jParam['identification'], aIdFK7[nNexId] ) //FK7_IDDOC
			Next nNexId
     
        SetJVAdt(jParam)

		EndIf

		If oModelNCND:VldData()
			oModelNCND:CommitData()
			ConOut('Registros Incluidos com Sucesso !')
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetua o reclock no registro da tabela de controle                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock(xAliDoc, .F.)
   				&(xAliDoc+"->"+xAliDoc+"_NFEOK")    := "S"
				&(xAliDoc+"->"+xAliDoc+"_DKN")      := "S"
				&(xAliDoc+"->"+xAliDoc+"_NFSF2")    := DKN->DKN_DOC //Vem posicionado
				&(xAliDoc+"->"+xAliDoc+"_SERSF2")   := DKN->DKN_SERIE //Vem posicionado
			&(xAliDoc+"->"+"(MsUnlock())")

			If !IsBlind()
				FWAlertSuccess("Nota Fiscal de Débito/Crédito inserida com sucesso : " + DKN->DKN_DOC, "Totvs")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama função para gravação dos logs de processamento                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MCSGRVLOG("0",xTipo,xCli+xLoja+"||"+xDoc+xSerie,"Processo realizado com sucesso, nota gerada: " + DKN->DKN_DOC + " série: " + DKN->DKN_SERIE)
		Else
			If !IsBlind()
				MostraErro()
			Else 
				aError := GetAutoGRLog()
			EndIf
			ConOut('Erro')
			MCSGRVLOG("1",xTipo,xCli+xLoja+"||"+xDoc+xSerie,"Erro na inclusão: " + Iif(Len(aError) > 0, aError[1], "Erro desconhecido"))
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

	xQuery := "SELECT D2_DOC AS DOC, D2_SERIE AS SERIE, D2_CLIENTE AS CLIFOR, D2_LOJA AS LOJA, D2_COD AS PROD, D2_ITEM AS ITEM, " + chr(13)
	xQuery += "B1_LOCPAD AS LOCPAD, D2_PRCVEN AS VALOR, D2_QUANT AS QUANT, F2_CHVNFE AS CHVNFE, D2_EST AS UF, D2_CF AS CF, D2_QUANT AS QTD " + chr(13)
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

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravo os itens e retorno para uso na gravação da nota               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(xAlias)->(Eof())
		aAdd(aRegs,{(xAlias)->DOC, (xAlias)->SERIE, (xAlias)->CLIFOR, (xAlias)->LOJA, (xAlias)->PROD, (xAlias)->ITEM, (xALias)->LOCPAD, (xAlias)->VALOR, (xAlias)->QUANT, (xAlias)->CHVNFE, (xAlias)->UF, (xAlias)->CF, (xAlias)->QTD})
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

/*/{Protheus.doc} fRetTes
Retorna o TES para nota de débito
@type function
@version  
@author MCS Tecnologia
@since 6/5/2026
@param xCf, variant, param_description
@return variant, return_description
/*/
Static Function fRetTes(xCf)

	Local xTes      := ""
	Local xTabela   := SuperGetMV("MV_XMCS002",.F.,"WW2") //Guarda o alias da tabela de TES x CFOP
	Local aArea 	:= (xTabela)->(GetArea(xTabela))

	(xTabela)->(dbSelectArea(xTabela))
	(xTabela)->(dbSetOrder(2))

	If (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("5"+xCf),.F.)) .Or. (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("6"+xCf),.F.));
		.Or. (xTabela)->(dbSeek(xFilial(xTabela)+AllTrim("7"+xCf),.F.))
		xTes := &(xTabela+"->"+xTabela+"_TES")
	EndIf

	RestArea(aArea)

Return xTes

/*/{Protheus.doc} GetQtdTot
Retorna a quantidade total de itens da nota
@type function
@version  
@author MCS Tecnologia
@since 6/9/2026
@param xDoc, variant, param_description
@param xSerie, variant, param_description
@param xCli, variant, param_description
@param xLoja, variant, param_description
@return variant, return_description
/*/
Static Function GetQtdTot(xDoc, xSerie, xCli, xLoja)

	Local nQtdTot  := 0
	Local xAlias   := GetNextAlias()
	Local xQuery   := ""

	xQuery := "SELECT SUM(D2_QUANT) AS QTD FROM " +RetSqlName("SD2") + " D2 " + chr(13)
	xQuery += "WHERE D2_FILIAL = '" + FwxFilial("SD2") + "' " + chr(13)
	xQuery += "AND D2_DOC = '"+xDoc+"' " + chr(13)
	xQuery += "AND D2_SERIE = '"+AllTrim(xSerie)+"' " + chr(13)
	xQuery += "AND D2_CLIENTE = '"+AllTrim(xCli)+"' " + chr(13)
	xQuery += "AND D2_LOJA = '"+AllTrim(xLoja)+"' "+ chr(13)
	xQuery += "AND D2.D_E_L_E_T_ = ' ' " + chr(13)

	MpSysOpenQuery(xQuery,xAlias)

	(xAlias)->(dbGoTop())

	If (xAlias)->(Eof())
		nQtdTot := (xAlias)->QTD
	EndIf

	(xAlias)->(DbCloseArea())

Return nQtdTot

/*/{Protheus.doc} QryAntec
Query para busca dos recebimento antecipado
@type function
@version  
@author MCS Tecnologia
@since 6/5/2026
@return variant, return_description
/*/
Static Function QryIDDOC(xDoc,xCli,xLoja)

    Local xQuery    := ""
    Local xAlias    := GetNextAlias()
    Local aIdFk7    := {}
    
    xQuery := "SELECT FK7_IDDOC" + chr(13)
    xQuery += "FROM " + RetSqlName("SC5") + " C5 " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 " + chr(13)
    xQuery += "ON E4_CODIGO = C5_CONDPAG " + chr(13)
    xQuery += "AND E4_FILIAL = '" + FwxFilial("SE4") + "' " + chr(13)
    xQuery += "AND E4_CTRADT = '1' " + chr(13)
    xQuery += "INNER JOIN " + RetSqlName("FIE") + " FIE " + chr(13)
    xQuery += "ON FIE.FIE_FILIAL = C5_FILIAL " + chr(13)
    xQuery += "AND FIE.FIE_PEDIDO = C5_NUM " + chr(13)
    xQuery += "AND FIE_CLIENTE = C5_CLIENTE " + chr(13)
    xQuery += "AND FIE_LOJA = C5_LOJACLI " + chr(13)
	xQuery += "INNER JOIN " + RetSqlName('FK7') + " FK7 " + chr(13)
	xQuery += "ON FK7_FILIAL = C5_FILIAL " + chr(13)
	xQuery += "AND FK7_CLIEFOR = C5_CLIENTE " + chr(13)
	xQuery += "AND FK7_LOJA = C5_LOJA " + chr(13)
	xQuery += "AND FK7_NUM = FIE_NUM " + chr(13)
    xQuery += "WHERE C5_FILIAL = '" + FwxFilial("SC5") + "' " + chr(13)
	xQuery += "AND C5_NUM = '" + AllTrim(xDoc) + "' " + chr(13)
	xQuery += "AND C5_CLIENTE = '" + AllTrim(xCli) + "' " + chr(13)
	xQuery += "AND C5_LOJACLI = '" + AllTrim(xLoja) + "' " + chr(13)
	xQuery += "AND FK7_ALIAS = 'SE1' " + chr(13)
	xQuery += "AND FK7_TIPO = 'RA' " + chr(13)
	xQuery += "AND C5.D_E_L_E_T_ = ' ' " + chr(13)
    xQuery += "AND SE4.D_E_L_E_T_ = ' ' " + chr(13)
	xQuery += "AND FK7.D_E_L_E_T_ = ' ' "

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

    While !(xAlias)->(Eof())
        aAdd(aIdFk7, {(xAlias)->IDDOC})
        (xAlias)->(dbSkip())
    EndDo

    (xAlias)->(dbCloseArea())

Return aIdFk7

/*/{Protheus.doc} fBuscaSC6
Busca os dados do pedido para nota de débito tipo 06
@type function
@version  
@author MCS Tecnologia
@since 6/9/2026
@param xPed, variant, param_description
@param xCli, variant, param_description
@param xLoja, variant, param_description
@return variant, return_description
/*/
Static Function fBuscaSC6(xPed,xCli,xLoja)

	Local xAlias := GetNextAlias()
	Local xQuery := ""
	Local aRegs  := {}

	xQuery := "SELECT C6_PRODUTO, C6_PRCVEN, C6_LOCAL, C6_CF "+ chr(13)
	xQuery += "FROM " + RetSqlName("SC6") + " C6 " + chr(13)
	xQuery += "WHERE C6_FILIAL = '" + FwxFilial("SC6") + "' " + chr(13)
	xQuery += "AND C6_NUM = '" + AllTrim(xPed) + "' " + chr(13)
	xQuery += "AND C6_CLI = '" + AllTrim(xCli) + "' " + chr(13)
	xQuery += "AND C6_LOJA = '" + AllTrim(xLoja) + "' " + chr(13)
	xQuery += "AND D_E_L_E_T_ = ' ' " + chr(13)

	MpSysOpenQuery(xQuery,xAlias)

	(xAlias)->(dbGoTop())

	While !(xAlias)->(Eof())
		aAdd(aRegs,{(xAlias)->C6_PRODUTO, (xAlias)->C6_PRCVEN, (xAlias)->C6_LOCAL, (xAlias)->C6_CF})
		(xAlias)->(dbSkip())
	EndDo

	(xAlias)->(DbCloseArea())

Return aRegs
