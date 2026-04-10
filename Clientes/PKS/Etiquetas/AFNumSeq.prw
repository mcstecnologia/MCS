#Include "Protheus.ch"
#Include "Totvs.ch"

User Function AFNumSeq( _cOri )

	Local cNumSeq	:= ""
	Local cQuery	:= ""
	Local cAlias	:= ""

	Default _cOri	:= ""


	If !Empty( _cOri )

		DbSelectArea( _cOri )

		cCampo	:= SubStr( _cOri , 2 , 2 ) + "_NUMSEQ"
		cCmpFil	:= SubStr( _cOri , 2 , 2 ) + "_FILIAL"
		
		If (_cOri)->(FieldPos( cCampo )) > 0 .And. (_cOri)->(FieldPos( cCmpFil )) > 0
		
			cQuery	:= " SELECT MAX("+cCampo+") MAX FROM "+RetSqlName(_cOri)+" WHERE "+cCmpFil+" = '"+xFilial(_cOri)+"' AND D_E_L_E_T_ = ' ' "

			cAlias	:= GetNextAlias()

			MpSysOpenQuery( cQuery , cAlias )

			If !( (cAlias)->(Eof()) )

				cNumSeq	:= Soma1( (cAlias)->MAX )

				(cAlias)->( DbCloseArea() )

			Endif

		Endif

	Endif

Return cNumSeq
