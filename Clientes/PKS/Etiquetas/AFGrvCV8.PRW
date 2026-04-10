#Include "Protheus.CH"
#Include "Totvs.CH"
#Include "Rwmake.ch"
#Include 'ParmType.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} AFGrvCV8
Function generica pra gravar dados na tabela CV8 - Log Processamento
@type function
@version 1
@author andre.loos
@since 05/03/2025
@param aDados, array, aDados[1] - Usuario; aDados[2] - Rotina; aDados[3] Mensagem
/*/

User Function AFGrvCV8( aDados , aEmp )

	Local lRpc		:= .F.

	Default aDados	:= {}
	Default aEmp	:= {}

	If Select("SM0") == 0

		If Len( aEmp ) == 2

			RpcSetType(3)
			RpcSetEnv( aEmp[1] , aEmp[2] )
			lRpc	:= .T.

		Else
			Return .F.

		Endif

	Endif

	If Len( aDados ) == 3

		Begin Transaction

			If RecLock("CV8",.T.)

				CV8->CV8_FILIAL	:= FWxFilial("CV8")
				CV8->CV8_DATA	:= Date()
				CV8->CV8_HORA	:= SubStr(Time(),1,5)
				CV8->CV8_USER	:= IIF(Empty(aDados[1]),"JOB",aDados[1])
				CV8->CV8_PROC	:= aDados[2]
				CV8->CV8_MSG	:= aDados[3]
				CV8->(MsUnLock())

			Endif

		End Transaction

	Endif

	If lRpc
		RpcClearEnv()

	Endif

Return .T.
