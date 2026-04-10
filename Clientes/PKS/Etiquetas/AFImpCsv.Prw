#Include "totvs.ch"
#Include "protheus.ch"

Static Enter	:= Chr(13)+Chr(10)

/*/{Protheus.doc} U_AFImpCsv
Retorna o conteudo de um arquivo CSV para um array
@Type function
@Version 1
@Author andre.loos
@Since 03/01/2025
@Param _cTitulo, character, titulo da dialog a ser criada
@Param _lJob, logical, se é execução via JOB
@Param _cModelo, character, nome do arquivo modelo
@Return array, array com o conteudo do CSV
/*/

User Function AFImpCsv( _cTitulo , _lJob , _cModelo , _cArquivo )

	Local bCancel		:= { || lOk := .F. , oDlg:End() }
	Local bOk			:= { || lOk := .T. , oDlg:End() }
	Local lOk			:= .F.
	Local aArray		:= {}
	Local nLin			:= 20
	Local nCol1			:= 15

	Default _cTitulo	:= "Importacao CSV"
	Default _cArquivo	:= Space(10)
	Default _cModelo	:= Space(10)
	Default _lJob		:= .F.

	Private cModelo		:= Upper(Alltrim(_cModelo))
	Private cNomeCsv	:= Space(120)
	Private cNomeSEM	:= Space(120)
	Private lJob		:= _lJob
	Private aDados		:= {}
	Private oDlg

	If !lJob

		DEFINE MSDIALOG oDlg Title _cTitulo From 7,10 To 30,60 OF oMainWnd

		@ nLin,nCol1 SAY OemToAnsi('Arquivo:') 									Of oDlg Pixel

		nLin += 30

		@ nLin , nCol1	MsGet	cNomeCsv		Size 130,012 When .F. 			Of oDlg Pixel
		@ nLin , 150	Button	"Localizar"		Size 032,012 Action DefArq()	Of oDlg Pixel

		nLin += 30
		@ nLin , nCol1 Button	"Baixar Modelo"	Size 166,012 Action Modelo()	Of oDlg Pixel

		nLin += 30

		Activate MsDialog oDlg On Init Enchoicebar( oDlg , bOk , bCancel ) Centered

	Else
	
		If !Empty( _cArquivo )
			cNomeCsv	:= _cArquivo
			lOk			:= .T.

		Else
			lOk			:= .F.

		Endif

	Endif

	If lOk

		cNomeCsv	:= Alltrim(cNomeCsv)
		cNomeSEM	:= Alltrim(cNomeCsv)
		nPosS		:= Rat(".",cNomeSEM)

		If nPosS > 0
			cNomeSEM := SubStr(cNomeSEM,1,nPosS-1)

		Endif

		If IntegraDados()
			aArray	:= aDados

		Endif

	Endif

Return aArray
//================================================================================================================================================================================================================================================================================================================================================================================================================
//	Conversao de arquivo - U_AFImpCsv
//================================================================================================================================================================================================================================================================
Static Function IntegraDados()

	Local lRet := .F.

//	Carrega do csv para um array
	If !lJob
		Processa( {|| lRet := CargaArray() } , "Aguarde, carregando planilha..." + Enter + "")

	Else
		lRet := CargaArray()

	Endif

Return lRet
//================================================================================================================================================================================================================================================================
//	Carrega os dados do .CSV para um array - U_AFImpCsv
//================================================================================================================================================================================================================================================================
Static Function CargaArray( )

	Local cFile		:= cNomeSEM + ".csv"
	Local cLinha	:= ""
	Local nLin		:= 2
	Local nHandle	:= 0

	aDados	:= {}

	If !File(cFile)
		If !lJob
			MsgInfo("Arquivo " + cFile + " não foi encontrado!")

		Endif
		Return .F.

	Endif

//	Abre o arquivo csv gerado na temp
	nHandle := Ft_Fuse(cFile)

	If nHandle == -1
		Return .F.

	Endif

	Ft_FGoTop()
	nLinTot := FT_FLastRec()-1
	ProcRegua(nLinTot)

//	Percorre todas linhas do arquivo csv
	Do While !Ft_FEof()
//		Exibe a linha a ser lida
		IncProc("Carregando Linha "+Alltrim(Str(nLin))+" de "+Alltrim(Str(nLinTot-1)))
		nLin++
//		Le a linha
		cLinha := Ft_FReadLn()

		IF SubStr(cLinha,1,3) != ';;;'

			If !(';' $ cLinha)
				cLinha := StrTran(cLinha,',',';')

			Endif

//			Verifica se a linha esta em branco, se estiver pula
			If Empty(Alltrim(StrTran(cLinha,';','')))
				Ft_FSkip()
				Loop

			Endif
//			Transforma as aspas duplas em aspas simples
			cLinha := StrTran(cLinha,'"',"'")

			cLinha := '{"'+cLinha+'"}'

//			Adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
			cLinha := StrTran(cLinha,';','","')

			aAdd(aDados, &cLinha)

		Endif

//		Passa para a próxima linha
		FT_FSkip()

	EndDo

//	Libera o arquivo CSV
	FT_FUse()

Return .T.
//================================================================================================================================================================================================================================================================
//	Funcao define arquivo - U_AFImpCsv
//================================================================================================================================================================================================================================================================
Static Function DefArq(aArrAuto,cTipo,lEditShape)

	Local cMask		:= "Arquivos de Texto (*.CSV)|*.csv|"
	Local nOpcoes	:= (GETF_ONLYSERVER,GETF_LOCALHARD)
	Local cTitulo	:= "Selecione o Arquivo CSV"

	cNomeCsv	:= Alltrim(cGetFile( cMask , cTitulo, , , , nOpcoes ))

Return
//================================================================================================================================================================================================================================================================================================================================================================================================================
//	copia o modelo do CSV para a maquina local
//================================================================================================================================================================================================================================================================================================================================================================================================================
Static Function Modelo()

	Local cLocal	:= Upper('C:\RELATO\'+cModelo+'\')
	Local cServer	:= Upper('\modelos\'+cModelo+'\')
	Local cArquivo	:= Upper(cModelo+'.csv')

	If !ExistDir(cLocal)
		MakeDir(cLocal)

	Endif

	If !File(cServer+cArquivo)

		If !lJob
			MsgInfo("Arquivo modelo nao configurado")

		Endif

	Endif

	If File(cLocal+cArquivo)
		FErase( cLocal+cArquivo )

	Endif

	If __CopyFile( cServer + cArquivo , cLocal + cArquivo )
		MsgInfo('Arquivo ' + cArquivo + ' copiado para a pasta ' + cLocal)

	Endif

Return
