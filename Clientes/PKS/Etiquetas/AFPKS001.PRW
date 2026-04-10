#Include "Protheus.ch"

Static Enter := Chr(13) + Chr(10)

User Function AFPKS01()

	Local cFunTOk	:= "U_AFPKS01B()"
	Local cDelOk	:= "U_AFPKS01A()"
	Local aRotAdic	:= {}

	aAdd( aRotAdic , { "Importacao CSV" ,"U_AFPKS01C", 0 , 3 })

	DbSelectArea("ZD8")
	ZD8->( DbGoTop() )

	AxCadastro( "ZD8" , "Clientes" , cDelOk , cFunTOk , aRotAdic )

Return(.T.)
//========================================================================================================================================================================================================================
//========================================================================================================================================================================================================================
User Function AFPKS01A()
Return .T.
//========================================================================================================================================================================================================================
//========================================================================================================================================================================================================================
User Function AFPKS01B()

	If Inclui
		DbSelectArea("ZD8")
		ZD8->(DbSetOrder(1))
		If ZD8->( DbSeek( xFilial("ZD8") + M->ZD8_PRODUT ) )
			MsgInfo("<b>Produto ja cadastrado</b>")
			Return .F.

		Endif

	Endif

Return .T.
//========================================================================================================================================================================================================================
//========================================================================================================================================================================================================================
User Function AFPKS01C()

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cAlias	:= ""

	cQuery	:= " SELECT " + Enter
	cQuery	+= "	DISTINCT " + Enter
	cQuery	+= "	B1_COD, " + Enter
	cQuery	+= "	CASE " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'GU' THEN 'PET' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'BA' THEN 'PP' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CL' THEN 'PP' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CS' THEN 'PP' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CT' THEN 'PP' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CC' THEN 'PS' " + Enter
	cQuery	+= "	END AS TIPO, " + Enter
	cQuery	+= "	CASE " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'GU' THEN 'PP' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'BA' THEN ' ' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CL' THEN ' ' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CS' THEN ' ' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CT' THEN 'PS' " + Enter
	cQuery	+= "		WHEN SUBSTRING(B1_COD,1,2) = 'CC' THEN ' ' " + Enter
	cQuery	+= "	END AS TIPO2 " + Enter
	cQuery	+= " " + Enter
	cQuery	+= " FROM SB1010 " + Enter
	cQuery	+= " WHERE D_E_L_E_T_ = ' ' " + Enter
	cQuery	+= "	AND SUBSTRING(B1_COD,1,2) IN ('GU','BA','CL','CS','CT','CC') " + Enter

	cAlias	:= GetNextAlias()

	MpSysOpenQuery( cQuery , cAlias )

	While !(cAlias)->(Eof())

		cProd	:= (cAlias)->B1_COD
		cItem1	:= (cAlias)->TIPO
		cItem2	:= (cAlias)->TIPO2

		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		If SB1->( DbSeek( xFilial("SB1") + cProd ) )

			DbSelectArea("ZD8")
			ZD8->(DbSetOrder(1))
			If ! ( ZD8->( DbSeek( xFilial("ZD8") + cProd ) ) )

				Begin Transaction
					If RecLock("ZD8",.T.)
						ZD8->ZD8_FILIAL := xFilial("ZD8")
						ZD8->ZD8_PRODUT := cProd
						ZD8->ZD8_MAT1	:= cItem1
						ZD8->ZD8_MAT2	:= cItem2

						ZD8->( MsUnLock() )

					Endif

				End Transaction

			Endif

		Endif

		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())

	RestArea(aArea)

Return
