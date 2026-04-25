#Include 'Protheus.CH'

/*/{Protheus.doc} MCSDEBCRE
description
@type function
@version  
@author MCS Tecnologia
@since 4/16/2026
@return variant, return_description
/*/

User Function MCSDEBCR()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Encerramento/Exclusão de Ordens de Produção em Aberto               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSays			:= {}
	Local aButtons		:= {}
	Local aPar          := {}
	Private cCadastro	:= "Geração de nota débito e crédito"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array auxiliar para a criacao da tela de Batch                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aSays,"Esta rotina tem o objetivo gerar as notas de débito e crédito ")
	aadd(aSays,"mediante parametrização pré definida.")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criação dos botões                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aButtons, { 5,.T.,{|| aPar := MCSPARAM()}})
	aadd(aButtons, { 1,.T.,{|| (FechaBatch(), Processa({|lEnd| MCSPROC(aClone(aPar))}))}})
	aadd(aButtons, { 2,.T.,{|| FechaBatch()}})


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao que cria tela de Batch                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FormBatch( cCadastro, aSays, aButtons )

Return

/*/{Protheus.doc} MCSPROC
Processa os parâmetros informados
@type function
@version  
@author MCS Tecnologia
@since 4/16/2026
@param aPar, array, param_description
@return variant, return_description
/*/
Static Function MCSPROC(aPar)

	Local oBrowse
	Local oDlg
	Local oGrp1
	Local oOk      := LoadBitmap(GetResources(),"LBOK")
	Local oNo      := LoadBitmap(GetResources(),"LBNO")
	Local aRet      := {}
	Local aBrowse   := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a consulta conforme parametrização indicada                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRet := BUSCAREG(aPar)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do Array para a Tela                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aBrowse := aClone(aRet)


	//If aPar[10] == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da Tela                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE "Geração nota débito e crédito" FROM 000, 000  TO 500, 900 PIXEL
	@ 220, 005 GROUP oGrp1 TO 247, 445 PROMPT "" OF oDlg PIXEL
	oBrowse := TCBrowse():New(005,005,440,210,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrowse:AddColumn(TCColumn():New(" "		 , {|| IIf(aBrowse[oBrowse:nAt,01],oOk,oNo)}        ,,,,,,  .T.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Documento" , {||     aBrowse[oBrowse:nAt,02]	}             ,,,,,50,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Série"     , {||     aBrowse[oBrowse:nAt,03]	}             ,,,,,20,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Cli/For"   , {||     aBrowse[oBrowse:nAt,04]	}             ,,,,,30,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Loja"      , {||     aBrowse[oBrowse:nAt,05]	}             ,,,,,15,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Nome   "   , {||     aBrowse[oBrowse:nAt,06]	}             ,,,,,100,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Produto"   , {||     aBrowse[oBrowse:nAt,07]	}             ,,,,,60,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Descricao" , {||     aBrowse[oBrowse:nAt,08]	}             ,,,,,100,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Item"      , {||     aBrowse[oBrowse:nAt,09]	}             ,,,,,20,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Local"     , {||     aBrowse[oBrowse:nAt,10]	}             ,,,,,50,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Valor"     , {||     Transform(aBrowse[oBrowse:nAt,11],"@E 999,999,999.99")	}             ,,,,,30,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("Chave NFe" , {||     aBrowse[oBrowse:nAt,12]	}             ,,,,,150,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("UF"        , {||     aBrowse[oBrowse:nAt,13]	}             ,,,,,20,.F.,.F.,,,,.F.,))
	oBrowse:AddColumn(TCColumn():New("TES"       , {||     aBrowse[oBrowse:nAt,14]	}             ,,,,,20,.F.,.T.,,,,.F.,))

	//Else

	//EndIf

	oBrowse:SetArray(aBrowse)
	oBrowse:bWhen         := { || Len(aBrowse) > 0 }
	oBrowse:blDblClick    := { || aBrowse[oBrowse:nAt,01] :=  !aBrowse[oBrowse:nAt,01]}

	DEFINE SBUTTON oBtnOk FROM 228, 350 TYPE 01 Action(nOpc := 1,oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oBtnNo FROM 228, 410 TYPE 02 Action(nOpc := 0,oDlg:End()) OF oDlg ENABLE

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Validação dos documentos informados                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lOk := FValidArray(aBrowse,aPar[10])
		If lOk
			GERANOTA(aBrowse,aPar[10],aPar[8],aPar[9])
		Else
			FwAlertWarning("Para o tipo de nota de débito é crédito selecionado, não é possível selecionar mais de um documento","Totvs")
		EndIf
	EndIf


Return

/*/{Protheus.doc} MCSPARAM
Tela e parâmetros
@type function
@version  
@author MCS Tecnolgoia
@since 4/16/2026
@return variant, return_description
/*/
Static Function MCSPARAM()

	Local aParams  := {}
	Local aRet     := {}
	Local aRetPar  := {}

	aadd(aParams, { 1, "Emissao de  "      , Ctod(Space(08)), , '.T.','   ', '.T.', 65, .F. })
	aadd(aParams, { 1, "Emissao Até "      , Ctod(Space(08)), , '.T.','   ', '.T.', 65, .F. })
	aadd(aParams, { 1, "Documento de "	   , Space(GetSx3Cache("F2_DOC"   ,  "X3_TAMANHO" )), , '.T.','  ' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Documento até "	   , Space(GetSx3Cache("F2_DOC"   ,  "X3_TAMANHO" )), , '.T.','  ' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Série "	   	       , Space(GetSx3Cache("F2_DOC"   ,  "X3_TAMANHO" )), , '.T.','  ' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Cli/For "	       , Space(GetSx3Cache("A1_COD"   ,  "X3_TAMANHO" )), , '.T.','SA1',	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Loja   "	       , Space(GetSx3Cache("A1_LOJA"  ,  "X3_TAMANHO" )), , '.T.','  ' ,	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Tes"	           , Space(GetSx3Cache("F4_CODIGO",  "X3_TAMANHO" )), , '.T.','SF4',	'.T.',	65,	.F.})
	aadd(aParams, { 1, "Cond.Pagto"	       , Space(GetSx3Cache("E4_CODIGO",  "X3_TAMANHO" )), , '.T.','SE4',	'.T.',	65,	.F.})
	aadd(aParams, { 2, "Tipo"              , 4 , {"1-Transferência de créditos para cooperativas","2-Anulação de créditos por saídas imunes/isentas","3-Débitos de notas fiscais processadas na apuração","4-Multa e juros", "5-Transferência de crédito de sucesso","6-Pagamento antecipado","7-Perda em estoque","8-Desenquadramento do Simples Nacional"}                            , 100, ".T.", .T.})


	If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,"MCSDEBCRE",.T.,.T.)
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

/*/{Protheus.doc} BUSCAREG
Busca os dados mediante 
@type function
@version  
@author rodri
@since 4/16/2026
@param aPar, array, param_description
@return variant, return_description
/*/
Static Function BUSCAREG(aPar)

	Local aRet   := {}
	Local xQuery := ""
	Local xAlias := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa query para buscar tudo que for relacionado a saída          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPar[10] == 3 .Or. aPar[10] == 4 .Or. aPar[10] == 8
		xQuery := "SELECT D2_DOC AS DOC, D2_SERIE AS SERIE, D2_CLIENTE AS CLIFOR, D2_LOJA AS LOJA, A1_NOME AS NOME, D2_COD AS PROD, B1_DESC AS DESCRICAO, D2_ITEM AS ITEM, B1_LOCPAD AS LOCPAD, D2_PRCVEN AS VALOR, D2_QUANT AS QUANT, F2_CHVNFE AS CHVNFE, D2_EST AS UF " + chr(13)
		xQuery += "FROM " +RetSqlName("SD2") + " D2 " + chr(13)
		xQuery += "INNER JOIN " +RetSqlName("SA1") + " A1" + chr(13)
		xQuery += "ON A1.A1_COD = D2.D2_CLIENTE AND A1.A1_LOJA = D2.D2_LOJA " + chr(13)
		xQuery += "AND A1.A1_FILIAL = '" + FwxFilial("SA1") + "' " + chr(13)
		xQuery += "INNER JOIN " +RetSqlName("SB1") + " B1" + chr(13)
		xQuery += "ON B1.B1_COD = D2.D2_COD" + chr(13)
		xQuery += "AND B1.B1_FILIAL = '" + FwxFilial("SB1") + "' " + chr(13)
		xQuery += "INNER JOIN " +RetSqlName("SF2") + " SF2" + chr(13)
		xQuery += "ON SF2.F2_FILIAL = D2.D2_FILIAL AND SF2.F2_DOC = D2.D2_DOC AND SF2.F2_SERIE = D2.D2_SERIE " + chr(13)
		xQuery += " AND SF2.F2_CLIENTE = D2.D2_CLIENTE AND SF2.F2_LOJA = D2.D2_LOJA " + chr(13)
		xQuery += "WHERE D2_FILIAL = '" + FwxFilial("SD2") + "' " + chr(13)
		xQuery += "AND D2_DOC BETWEEN '"+aPar[3]+"' AND '"+aPar[4]+"' " + chr(13)
		xQuery += "AND D2_SERIE = '"+AllTrim(aPar[5])+"' " + chr(13)
		xQuery += "AND D2_CLIENTE = '"+AllTrim(aPar[6])+"' " + chr(13)
		xQuery += "AND D2_LOJA = '"+AllTrim(aPar[7])+"' " + chr(13)
		xQuery += "AND D2_EMISSAO BETWEEN '"+dTos(aPar[1])+"' AND '"+dTos(aPar[2])+"' " + chr(13)
		xQuery += "AND D2.D_E_L_E_T_ = ' ' " + chr(13)
		xQuery += "AND B1.D_E_L_E_T_ = ' ' " + chr(13)
		xQuery += "AND A1.D_E_L_E_T_ = ' ' " + chr(13)
	Else
		xQuery := "SELECT D1_DOC AS DOC, D1_SERIE AS SERIE, D1_FORNECE AS CLIFOR, D1_LOJA AS LOJA, D1_COD AS PROD, B1_DESC AS DESCRICAO, D1_VUNIT AS VALOR, D1_QUANT AS QUANT " + chr(13)
		xQuery += "FROM " +RetSqlName("SD1") + " D1 " + chr(13)
		xQuery += "WHERE D1_FILIAL = '01' " + chr(13)
		xQuery += "AND D1_DOC = '"+AllTrim(aPar[3])+"' " + chr(13)
		xQuery += "AND D1_SERIE = '"+AllTrim(aPar[4])+"' " + chr(13)
		xQuery += "AND D1_CLIENTE = '"+AllTrim(aPar[5])+"' " + chr(13)
		xQuery += "AND D1_LOJA = '"+AllTrim(aPar[6])+"' " + chr(13)
		xQuery += "AND D1_DTDIGIT BETWEEN '"+dTos(aPar[1])+"' AND '"+dTos(aPar[2])+"' " + chr(13)
		xQuery += "AND D_E_L_E_T_ = ' ' " + chr(13)
	EndIf

	MpSysOpenQuery(xQuery, xAlias)

	(xAlias)->(dbGoTop())

	While (xAlias)->(!Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no array para montagem do oBrowse              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aRet, { .F., (xAlias)->DOC, (xAlias)->SERIE, (xAlias)->CLIFOR, (xAlias)->LOJA, AllTrim((xAlias)->NOME), AllTrim((xAlias)->PROD), AllTrim((xAlias)->DESCRICAO),(xAlias)->ITEM, (xAlias)->LOCPAD, (xAlias)->VALOR, (xAlias)->CHVNFE, (xAlias)->UF,aPar[8] })
		(xAlias)->(dbSkip())

	EndDo

	(xAlias)->(dbCloseArea())

Return (aRet)

/*/{Protheus.doc} GERANOTA
Efetiva a geração da nota de débito e crédito
@type function
@version  
@author rodri
@since 4/16/2026
@param aRegs, array, param_description
@param nTipo, numeric, param_description
@return variant, return_description
/*/
Static Function GERANOTA(aRegs,nTipo,xTes,xCond)

	Local xSerie        := SuperGetMV("MV_NDCSERI",.F.,"1")
	Local aArea         := SF4->(GetArea("SF4"))
	Local xInc          := 0
	Local xEst          := GetMV("MV_ESTADO")
	Local aDocumentos   := {}
	Local jFld600       := JsonObject():new()
	Local oDoc1         := JsonObject():New()
	Local oDoc2         := JsonObject():New()

	Private oModelNCND   := Nil
	Private jDocRef      := JsonObject():new()

	SF4->(dbSelectArea("SF4"))
	SF4->(dbSetOrder(1))

	SF4->(dbSeek(xFilial("SF4")+xTes))

	jFld600["F2_TPCOMPL"] := AllTrim(Str(nTipo))

	jFld600["F2_SERIE"] := xSerie
	jFld600["A1_COD"] := aRegs[1][4]
	jFld600["A1_LOJA"] := aRegs[1][5]

	//INICIA AS VARIAVEIS PARA REALIZAR A EXECAUTO DO MATA600
	A600IniObj(jFld600)

	oModelNCND := FwLoadModel('MATA600')

	//SETA A OPERACAO PARA INCLUSAO DA NF
	oModelNCND:SetOperation(3)

	oModelNCND:Activate()

	If oModelNCND:IsActive()

		If nTipo == 3 .Or. nTipo == 4 .Or. nTipo == 8
			//CABEÇALHO
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" , jFld600["F2_TPCOMPL"])
			oModelNCND:LoadValue( "CABMASTER"   , "F2_CLIENTE" , jFld600["A1_COD"]) //**IMPORTANTE ESSE CAMPO DEVE SER UTILIZADO SOMENTE LOADVALUE PARA PREENCHIMENTO
			oModelNCND:SetValue( "CABMASTER"    , "F2_LOJA"    , jFld600["A1_LOJA"])
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    , xCond)
			//oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  , "000001")

			For xInc := 1 To Len(aRegs)
				If aRegs[xInc][1] == .T.
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    , PadL(AllTrim(Str(xInc)), 2, '0'))
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     , aRegs[xInc][7])
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_QUANT"   , 1)
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , aRegs[xInc][11])
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TOTAL"   , aRegs[xInc][11])
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     , xTes)
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_CF"      , Iif(xEst == aRegs[xInc][13], "5"+SubStr(SF4->F4_CF,2,3),"6"+SubStr(SF4->F4_CF,2,3)))
					oModelNCND:SetValue( "ITENSDETAIL"    , "D2_LOCAL"   , aRegs[xInc][10])

					//DOCUMENTOS DE REFERENCIA
					jDocRef["itens"] := {JsonObject():new()}
					jDocRef["itens"][1]["item"] := PadL(AllTrim(Str(xInc)), 2, '0') //Código do item da nota de débito
					jDocRef["itens"][1]["produto"] := aRegs[xInc][7]                  //Código do produto da nota de débito

					jDocRef["itens"][1]["documentos"] :={JsonObject():new()}
					jDocRef["itens"][1]["documentos"][1]["item"]         := aRegs[xInc][9]  //Item da nota referenciada
					jDocRef["itens"][1]["documentos"][1]["documento"]    := aRegs[xInc][2]  //Número da nota referenciada
					jDocRef["itens"][1]["documentos"][1]["serie"]        := aRegs[xInc][3]   //Série da nota referenciada
					jDocRef["itens"][1]["documentos"][1]["cliente"]      := aRegs[xInc][4]    //Código do Cliente da nota referenciada
					jDocRef["itens"][1]["documentos"][1]["loja"]         := aRegs[xInc][5]    //Código da Loja do Cliente da nota referenciada
					jDocRef["itens"][1]["documentos"][1]["chave"]        := aRegs[xInc][12]      //Chave NFe do documento referenciado
					jDocRef["itens"][1]["documentos"][1]["intemxml"]     := PadL(AllTrim(Str(xInc)), 4, '0')  //Item XML utilizado apenas para notas de debito 4 (Campo D2_ITEM) e 7 (Campo D1_ITXML).
				EndIf
			Next xInc
		Else
			//CABEÇALHO
			oModelNCND:SetValue( "CABMASTER"    , "F2_TPCOMPL" ,jFld600["F2_TPCOMPL"])
			oModelNCND:LoadValue( "CABMASTER"    , "F2_CLIENTE" ,jFld600["A1_COD"]) //**IMPORTANTE ESSE CAMPO DEVE SER UTILIZADO SOMENTE LOADVALUE PARA PREENCHIMENTO
			oModelNCND:SetValue( "CABMASTER"    , "F2_LOJA"    ,jFld600["A1_LOJA"])
			oModelNCND:SetValue( "CABMASTER"    , "F2_COND"    ,"000")
			oModelNCND:SetValue( "CABMASTER"    , "F2_CODA1U"  ,"000001")

			//ITENS
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    ,"01")
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     ,"FAT001                        ")
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , 50)
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     ,"999")

			oModelNCND:GetModel('ITENSDETAIL'):AddLine()

			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_ITEM"    ,"02")
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_COD"     ,"FAT002                        ")
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_PRCVEN"  , 100)
			oModelNCND:SetValue( "ITENSDETAIL"    , "D2_TES"     ,"999")

			//DOCUMENTOS DE REFERENCIA

			// Documento 1
			oDoc1["documento"] := "PGVR02   " //Número da nota referenciada
			oDoc1["serie"]     := "1  " //Série da nota referenciada
			oDoc1["chave"]     := "                                            " //Chave NFe da nota referenciada
			oDoc1["cliente"]   := "PGVR01" //Código do Cliente da nota referenciada
			oDoc1["loja"]      := "01" //Código da Loja do Cliente da nota referenciada

			AAdd(aDocumentos, oDoc1)

			// Documento 2
			oDoc2["documento"] := "PGVR03   " //Número da nota referenciada
			oDoc2["serie"]     := "1  " //Chave NFe da nota referenciada
			oDoc2["chave"]     := "                                            " //Série da nota referenciada
			oDoc2["cliente"]   := "PGVR01" //Código do Cliente da nota referenciada
			oDoc2["loja"]      := "01" //Código da Loja do Cliente da nota referenciada

			AAdd(aDocumentos, oDoc2)

			// Atribui array ao JSON principal
			jDocRef["documentos"] := aDocumentos

		EndIf
		If oModelNCND:VldData()
			oModelNCND:CommitData()
			ConOut('Registros Incluidos com Sucesso !')
		Else
			MostraErro()
		EndIf
	EndIf

	oModelNCND:Destroy()
	FwFreeObj(oModelNCND)

	RestArea(aArea)

Return

/*/{Protheus.doc} FValidArray
Valida array
@type function
@version  
@author MCS Tecnologia
@since 4/16/2026
@param aDados, array, param_description
@return variant, return_description
/*/
Static Function FValidArray(aDados,xPar)

	Local nNext  := 0
	Local lRet   := .T.
	Local xDoc   := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Só entra nos tipos corretos                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If xPar == 3 .Or. xPar == 4 .Or. xPar == 7
		For nNext := 1 to Len(aDados)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Guarda o documento para comparação                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			xDoc := aDados[nNext][2]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a validação se o documento                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nNext > 1 .And. aDados[nNext][1] == .T.
				If xDoc <> aDados[nNext][2]
					Return lRet := .F.
				EndIf
			EndIf

		Next nNext
	EndIf

Return lRet

