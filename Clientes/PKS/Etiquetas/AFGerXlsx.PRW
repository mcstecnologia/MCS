#Include "Protheus.CH"
#Include "Totvs.CH"
#Include "Rwmake.ch"
#Include 'ParmType.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} AFGerXlsx
Function generica para gerar arquivo xlsx com base na informação recebida
@type Function
@version 1
@author andre.loos
@since 05/03/2025
@param cTitulo, character, titulo do arquivo
@param aCabec, array, colunas do arquivo
@param aLinha, array, array multidimensional com os dados das colunas, cada linha do array deve ter as mesmas quantidade de colunas do que a aCabec
#Documentacao TOTVS: https://tdn.totvs.com/display/public/framework/FWMsExcelEx
/*/
User Function AFGerXlsx( cTitulo , aCabec , aLinha , cPath , cQuery )

	Local oFwMsExcel	:= FwMsExcelXlsx():New()
	Local oExcel		:= Nil
	Local cArquivo		:= ""
	Local nX			:= 0

	Default cTitulo		:= "Export_Xslx"
	Default cPath		:= "C:\RELATO\"
	Default cQuery		:= ""
	Default aCabec		:= {}
	Default aLinha		:= {}

	If !Empty(cQuery)
		aReturn	:= ProcQry( cQuery )
		aCabec	:= aReturn[1]
		aLinha	:= aReturn[2]

	Endif

	If U_kSmartWeb() .And. !U_kWebAgent()
		Return cArquivo

	Endif

	If Len(aCabec) == 0 .Or. Len(aLinha) == 0
		Return cArquivo

	Endif

	If !ExistDir( cPath )
		MakeDir(cPath)

	Endif

	cArquivo	:= cPath + cTitulo + ".xlsx"

	oFWMsExcel:= FwMsExcelXlsx():New()

	oFWMsExcel:AddworkSheet(cTitulo)

//	Criando a Tabela
	oFWMsExcel:AddTable( cTitulo , cTitulo , .F.)

	For nX := 1 To Len(aCabec)
		oFWMsExcel:AddColumn( cTitulo , cTitulo , aCabec[nX]	, 1 , 1 )	// 01

	Next nX

	For nX := 1 To Len(aLinha)

		If Len(aLinha[nX]) == Len(aCabec)
			oFWMsExcel:AddRow( cTitulo , cTitulo , aLinha[nX] )

		Endif

	Next nX

//	Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	If ApOleClient("MsExcel")
//		Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()		//Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo)	//Abre uma planilha
		oExcel:SetVisible(.T.)			//Visualiza a planilha
		oExcel:Destroy()

	Else
		MsgInfo( "Arquivo gerado: " + cArquivo )

	Endif

Return cArquivo
//===================================================================================================================================================================================================================================
//	Processa a query e gera o array
//===================================================================================================================================================================================================================================
Static Function ProcQry( cQuery )

	Local aReturn	:= Array(2)
	Local aDados1	:= {}
	Local aDados2	:= {}
	Local cAlias	:= ""
	Local nX

	cQuery	:= ChangeQuery( cQuery )

	cAlias	:= GetNextAlias()

	MpSysOpenQuery( cQuery , cAlias )

	aStruct := (cAlias)->(DbStruct())

	For nX := 1 To Len( aStruct )

		aAdd( aDados1, aStruct[nX][1] )

	Next nX

	(cAlias)->(DbGoTop())

	While !( (cAlias)->(Eof()) )

		aTemp := Array( Len( aDados1 ) )

		For nX := 1 To Len( aDados1 )
			aTemp[nX] := &( "(cAlias)->" + aDados1[nX] )

		Next nX

		aAdd( aDados2 , aTemp )

		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())

	aReturn[1] := aDados1
	aReturn[2] := aDados2

Return aReturn
