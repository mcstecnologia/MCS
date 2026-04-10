#Include "Protheus.CH"
#Include "TOTVS.CH"

User Function ALIMPEAN()	//	U_ALIMPEAN

	Local aArea			:= GetArea()

	Private aDados		:= {}

	lSavTTS		:= __TTSInUse
	__TTSInUse	:= .T.

	U_AFGrvCV8( { cUserName , "ALIMPEAN" , "INICIO ROTINA" } )

	aDados	:= U_AFImpCsv( "Atualiza EAN - Produtos" )

	If Len(aDados) > 0
		Processa( {|| GeraLanc() } ,"Aguarde, carregando dados..." )

	Endif

	RestArea(aArea)

	U_AFGrvCV8( { cUserName , "ALIMPEAN" , "FIM ROTINA" } )

	__TTSInUse	:= lSavTTS

Return
//================================================================================================================================================================================================================================================================
//	Processa os registros
//================================================================================================================================================================================================================================================================
Static Function GeraLanc()

	Local cLog	:= ""
	Local nX	:= 1

	For nX := 2 To Len( aDados )

		cProd	:= Padr(Alltrim( aDados[nX][2] ),15)
		cEan	:= Alltrim( aDados[nX][6] )

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->( DbSeek( xFilial("SB1") + cProd ) ) .And. !Empty(cEan)

			Begin Transaction

				If RecLock("SB1",.F.)
					SB1->B1_CODBAR	:= cEan
					SB1->(MsUnLock())

				Endif

			End Transaction

		Endif

	Next nX

	If !Empty(cLog)
		MsgInfo( cLog , "" )

	Endif

Return
