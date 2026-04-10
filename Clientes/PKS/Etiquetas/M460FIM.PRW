#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Topconn.ch"


//	Ponto de entrada no fim da geração da nota fiscal

User function M460FIM()

	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSE1	:= SE1->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())
	Local aArea		:= GetArea()

	If !Empty(SF2->F2_DUPL)
		//Seleciona todos os titulos com o mesmo numero
		SE1->( DbSetOrder(2))
		SE1->( DbSeek( xFilial("SE1") + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ) ) // posiciona no titulo da nota

		//Repete para todos os titulos
		While SE1->(!Eof()) .And. SE1->E1_FILIAL == xFilial('SE1');
				.And. SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC

			//Altera titulo, adicionando estado no campo customizado no titulo posicionado
			If RecLock( "SE1" , .F. )
				SE1->E1_ZEST	:= Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_EST")
				SE1->(MsUnLock())

			Endif

			SE1->(DbSkip())

		EndDo

	Endif

	DbSelectArea("SD2")
	SD2->(DbSetorder(3))
	If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

		While !(Eof()) .And. ( SD2->D2_FILIAL == xFilial("SD2");
				.And. SD2->D2_DOC == SF2->F2_DOC ;
				.And. SD2->D2_SERIE == SF2->F2_SERIE ;
				.And. SD2->(D2_CLIENTE+D2_LOJA) == SF2->(F2_CLIENTE+F2_LOJA) )

			If VldDup( SD2->( Recno() ) , SD2->D2_NUMSEQ )

				If RecLock("SD2",.F.)

					SD2->D2_NUMSEQ	:= U_AFNumSeq("SD2")
					SD2->( MsUnLock() )

				Endif

			Endif

			SD2->( DbSkip() )

		EndDo()

	Endif

//	GRAVA QUANTIDADE DE VOLUMES DE ACORDO COM CHECKOUT - PARA A EMPRESA AZZO
	If cEmpAnt == '02'
		M460VOL1()

	Endif

	RestArea( aAreaSF2	)
	RestArea( aAreaSD2	)
	RestArea( aAreaSC5	)
	RestArea( aAreaSE1	)
	RestArea( aAreaSA1	)
	RestArea( aArea		)

Return
//================================================================================================================================================================================
//	GRAVA A QUANTIDADE DE VOLUMES NO DOCUMENTO DE ENTRADA
//================================================================================================================================================================================
Static Function M460VOL1()

	Local aArea		:= GetArea()
	Local _nVolumes	:= 0

	cQuery	:= " SELECT MAX(ZL_CAIXA) AS VOLUME FROM "+RetSqlName('SC9')+" C9 "
	cQuery	+= "	INNER JOIN "+RetSqlName('SZL')+" ZL ON (ZL.ZL_PEDIDO = C9_PEDIDO AND ZL.ZL_C9RECNO = C9.R_E_C_N_O_ "
	cQuery	+= "		AND ZL.D_E_L_E_T_ = ' ' AND ZL_FILIAL = '"+xFilial('SZL')+"' ) "
	cQuery	+= " WHERE C9_NFISCAL ='" + SF2->F2_DOC + "' AND C9_SERIENF = '" + SF2->F2_SERIE + "' "
	cQuery	+= "	AND C9.D_E_L_E_T_ = ' ' AND C9_FILIAL = '"+xFilial('SC9')+"' "

	cAlias	:= GetNextAlias()

	MpSysOpenQuery( cAlias )

	(cAlias)->(DbGoTop())

	If (cAlias)->(!Eof())

		_nVolumes	:= Val((cAlias)->VOLUME)

		If Reclock("SF2",.F.)

			If ! Empty(_nVolumes) // THIAGO PARA NAO ZERA VOLUMES, QUE NAO PASSEM NO CHECKOUT PADRAO
				SF2->F2_VOLUME1 := _nVolumes

			Endif

			SF2->F2_ESPECI1 := "CX"

			SF2->(MsUnLock())

		Endif

	Endif

	(cAlias)->(DbCloseArea())

	RestArea(aArea)

Return
//================================================================================================================================================================================
//================================================================================================================================================================================
Static Function VldDup( nRecSD2, cNumSeq )

	Local aArea		:= GetArea()
	Local lRet		:= .F.
	Local cQuery	:= ""
	Local cAlias	:= ""

	cQuery	:= " SELECT 1 FROM SD2010 "
	cQuery	+= " WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
	cQuery	+= "	AND D_E_L_E_T_ = ' ' "
	cQuery	+= "	AND R_E_C_N_O_ != '"+cValToChar(nRecSD2)+"' "
	cQuery	+= "	AND D2_NUMSEQ = '"+cValToChar(cNumSeq)+"' "

	cAlias	:= GetNextAlias()

	MpSysOpenQuery( cQuery , cAlias )

	If !( (cAlias)->(Eof()) )
		lRet	:= .T.

	Endif

	(cAlias)->(DbCloseArea())

	RestArea(aArea)

Return lRet
