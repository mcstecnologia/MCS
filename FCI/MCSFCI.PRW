#include "rwmake.ch"
#include "protheus.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MCSFCI
Tela para realizar a manutenção dos dados da FCI
@type function
@version  
@author rodrigo.giesau
@since 01/07/2022
@return variant, return_description
/*/
User function MCSFCI()

	Local cAlias
	Private cCadastro := "Ficha de Conteúdo de Importação"

	cAlias := "CFD"
	chkFile(cAlias)
	dbSelectArea(cAlias)
	dbSetOrder(1)	
	aRotina := {;
		{ "Pesquisar", "AxPesqui", 0, 1},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir", "AxInclui", 0, 3},;
		{ "Alterar", "AxAltera", 0, 4},;
		{ "Importa", "U_IMPFCI", 0, 4},;
		{ "Exporta", "U_EXPFCI", 0, 4},;
		{ "Duplica", "U_DUPFCI", 0, 4},;
		{ "Exlcuir", "AxDeleta", 0, 5};
	}
	dbSelectArea(cAlias)
	mBrowse( 6, 1, 22, 75, cAlias)

Return

/*/{Protheus.doc} IMPFCI
Função que realiza a importação dos dados da FCI para a tabela CFD
@type function
@version  
@author rodrigo.giesau
@since 01/07/2022
@return variant, return_description
/*/
User Function IMPFCI()

	Local cDir
	Private oDlg1
	Private oGet
	Private Say
	Private oButConfirm
	Private oButClose

	DEFINE MSDIALOG oDlg1 Title "Importação FCI" From 100,55 to 400,500 Pixel

	@010,010 SAY "Pesquise abaixo o arquivo para importação" SIZE 200, 10 OF oDlg1 PIXEL
	@020,010 MSGET cDir SIZE 160,010 When .F. Of oDlg1 Pixel
	@020,175 BUTTON "Localizar" SIZE 32,12 ACTION cDir:= Alltrim(cGetFile('Arquivos de Texto (*.CSV)|*.csv|',OemToAnsi("Selecione o Arquivo"),0,"",.T.,GETF_LOCALHARD))  Of oDlg1 Pixel
	@045,010 BUTTON "Importar"  SIZE 32,12 ACTION fCarregaArq(cDir)  Of oDlg1 Pixel
	@045,055 BUTTON "Fechar"	SIZE 32,12 ACTION oDlg1:End() of oDlg1 Pixel
	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o tratamento no arquivo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarregaArq(cDir)

	Local aDados  := {}
	Local nhandle := 0
	Local nLinha  := 0
	Local cLinha  := ""
	Local oSay 

	If Empty(cDir)
		MsgStop("Não foi informado o arquivo para importação!", "Verifique")
	Else
		//abre o arquivo
		nHandle := FT_FUse(cDir)

			If nHandle = -1

				MsgStop("Erro ao abrir o arquivo!", "Verifique")

			Else
				//posiciona na primeira linha do arquivo
				FT_FGoTop()
				//retorna o numero de linhas
				nLinha := FT_FlastRec()

					If nLinha == 0

						MsgStop("Não foram encontrados registros/linhas no arquivo", "Verifique")

					Else

						while !FT_FEOF()
							//lendo e retornando a linha
							cLinha := FT_FREADLN()
							//adicionando as linhas no array
							aadd(aDados,separa(cLinha,";",.T.))

							FT_FSKIP()
						EndDo
					EndIF
			EndIF
	EndIF
	//Fechando o arquivo
	FT_FUse()

	If MsgYesNo("Foram carregados " + cValToChar(nLinha) + " registros, deseja realizar a importação?", "Confirma?")

		FwMsgRun(NIL, {|oSay| fImportCSV(oSay,aDados)}, "Processando", "Importando registros da FCI...")
		//Processa( {||fImportCSV(aDados)}, "Aguarde, importando registros")

	Else

		Alert("Cancelado pelo usuário")

	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava os dados na tabela                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImportCSV(oSay,aDados)

	Local aArea  := CFD->(GetArea())
	Local x 	 := 0
	Local cProd  := Space(15)
	Local cCod

	//Setando indices e abrindo a tabela
	CFD->(dbSelectArea("CFD"))
	CFD->(DbSetOrder(1))
	CFD->(DbGoTop())

	Begin Transaction

		//inicia a transação de alteração
		For x := 1 to Len(aDados)
	
			/*If !Empty(aDados[x,1]) .And. !Empty(aDados[x,2]) .And. !Empty(aDados[x,3]) .And. !Empty(aDados[x,4]);
			 .And. !Empty(aDados[x,5]) .And. !Empty(aDados[x,6]) .And. !Empty(aDados[x,7]) .And. !Empty(aDados[x,8])*/
	
				cCod := aDados[x,3]

				cProd := Stuff(cProd,1,len(Alltrim(cCod)),Alltrim( aDados[x,3]  ))

				If CFD->(dbSeek(xFilial("CFD")+ AllTrim(aDados[x,1]) + AllTrim(aDados[x,2] + cProd),.f.))

					RecLock('CFD', .F.)

						CFD->CFD_FILIAL	:= FWxFilial("CFD")
						CFD->CFD_PERCAL := aDados[x,1]
						CFD->CFD_PERVEN	:= aDados[x,2]
						CFD->CFD_COD	:= cProd
						CFD->CFD_VPARIM	:= val(aDados[x,4])
						CFD->CFD_VSAIIE	:= val(aDados[x,5])
						CFD->CFD_CONIMP	:= val(aDados[x,6])
						CFD->CFD_FCICOD	:= aDados[x,7]
						CFD->CFD_ORIGEM	:= aDados[x,8]
						CFD->(MsUnlock())

					ConfirmSX8()
				Else
					//efetua a inclusão de um novo registro
					RecLock('CFD', .T.)

						CFD->CFD_FILIAL	:= FWxFilial("CFD")
						CFD->CFD_PERCAL := aDados[x,1]
						CFD->CFD_PERVEN	:= aDados[x,2]
						CFD->CFD_COD	:= cProd
						CFD->CFD_VPARIM	:= val(aDados[x,4])
						CFD->CFD_VSAIIE	:= val(aDados[x,5])
						CFD->CFD_CONIMP	:= val(aDados[x,6])
						CFD->CFD_FCICOD	:= aDados[x,7]
						CFD->CFD_ORIGEM	:= aDados[x,8]
						CFD->(MsUnlock())
					ConfirmSX8()
				EndIF
			//EndIf

	Next x

	//finaliza a transação
	End Transaction

	MsgInfo("Registros incluídos/alterados com sucesso!!", "Sucesso")
	CFD->(RestArea(aArea))

Return

/*/{Protheus.doc} EXPFCI
Função que realiza a exportação de um período da FCI
@type function
@version  
@author rodrigo.giesau
@since 01/07/2022
@return variant, return_description
/*/
User Function EXPFCI()

	Local cAlias        := GetNextAlias()
	Local cArquivo      := cEmpAnt + "_" + DToS(Date()) + "-" + StrTran(Time(),":","_")
	LOCAL cDirDocs      := MsDocPath()
	Local cPath		    := AllTrim(GetTempPath())
	Local cQuery		:= ""
	Local cPerCal       := ""
	Local nHandle       := 0
	Local cCrLf         := Chr(13) + Chr(10)

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	cQuery := "SELECT * FROM " + RetSqlName("CFD") + " "
	cQuery += "WHERE D_E_L_E_T_ = ' ' 
	cQuery += "ORDER BY R_E_C_N_O_ DESC "

	cQuery := ChangeQuery(cQuery)

	MpSysOpenQuery(cQuery,cAlias)

	(cAlias)->(dbGoTop())

	If !(cAlias)->(Eof())

		If MsgYesNo("Deseja exportar os dados da FCI do último período gravado: " + AllTrim((cAlias)->CFD_PERCAL)+"?" , "Sim/Não")

			cPercal := (cAlias)->CFD_PERCAL

			fWrite(nHandle, "Ficha FCI;")
			fWrite(nHandle, cCrLf)

			While !(cAlias)->(Eof()) .And. (cAlias)->CFD_PERCAL == cPercal
				//Criando as linhas do arquivo
				fWrite(nHandle, (cAlias)->CFD_PERCAL+ ";" )
				fWrite(nHandle, (cAlias)->CFD_PERVEN+ ";" )
				fWrite(nHandle, AllTrim((cAlias)->CFD_COD)+";" )
				fWrite(nHandle, cValToChar((cAlias)->CFD_VPARIM)+ ";" )
				fWrite(nHandle, cValToChar((cAlias)->CFD_VSAIIE)+ ";" )
				fWrite(nHandle, cValToChar((cAlias)->CFD_CONIMP)+ ";" )
				fWrite(nHandle, AllTrim((cAlias)->CFD_FCICOD)+ ";" )
				fWrite(nHandle, (cAlias)->CFD_ORIGEM)
				fWrite(nHandle, cCrLf ) // Pula linha

				(cAlias)->(dbSkip())

			EndDo

			fClose(nHandle)
			CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

			//Verifico se é excel
			If ! ApOleClient( 'MsExcel' )
				ShellExecute( "Open", "soffice","-calc -o "+cPath+cArquivo+".CSV","C:\", 1 )
			Else
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
				oExcelApp:SetVisible(.T.)
			Endif

			MsgInfo("Término da exportação do dados do período " + cPercal,"Sucesso")

		Else

			MsgAlert("Você finalizou o processo de exportação dos dados", "Aviso")

		EndIf

	EndIf

	(cAlias)->(dbCloseArea())

Return

/*/{Protheus.doc} DUPFCI
Função que duplica os registros da FCI
@type function
@version  
@author rodrigo.giesau
@since 25/07/2022
@return variant, return_description
/*/
User Function DUPFCI()

	Local cQuery    := ""
	Local cAlias    := GetNextAlias()
	Local cAliasCFD := GetNextAlias()

	cQuery := "SELECT * FROM " + RetSqlName("CFD") + " "
	cQuery += "WHERE D_E_L_E_T_ = ' ' 
	//cQuery += "AND CFD_PERCAL = '" + AllTrim(cPerAtu) + "' "
	cQuery += "ORDER BY R_E_C_N_O_ DESC "

	cQuery := ChangeQuery(cQuery)

	MpSysOpenQuery(cQuery,cAlias)

	(cAlias)->(dbGoTop())

	Conout("Inicio da gravação da FCI")

	cPerCal := fPerCal((cAlias)->CFD_PERCAL)
	cPerVen	:= fPerVen((cAlias)->CFD_PERVEN, cPerCal)

	cQuery := "SELECT * FROM " + RetSqlName("CFD") + " "
	cQuery += "WHERE D_E_L_E_T_ = ' ' 
	cQuery += "AND CFD_PERCAL = '" + (cAlias)->CFD_PERCAL + "' "
	cQuery += "ORDER BY R_E_C_N_O_ DESC "

	cQuery := ChangeQuery(cQuery)

	MpSysOpenQuery(cQuery,cAliasCFD)

	(cAliasCFD)->(dbGoTop())

	While !(cAliasCFD)->(Eof())
		//efetua a inclusão de um novo registro
		RecLock('CFD', .T.)
			CFD->CFD_FILIAL	:= FWxFilial("CFD")
			CFD->CFD_PERCAL := cPerCal
			CFD->CFD_PERVEN	:= cPerVen
			CFD->CFD_COD	:= (cAliasCFD)->CFD_COD
			CFD->CFD_VPARIM	:= (cAliasCFD)->CFD_VPARIM
			CFD->CFD_VSAIIE	:= (cAliasCFD)->CFD_VSAIIE
			CFD->CFD_CONIMP	:= (cAliasCFD)->CFD_CONIMP
			CFD->CFD_FCICOD	:= (cAliasCFD)->CFD_FCICOD
			CFD->CFD_ORIGEM	:= (cAliasCFD)->CFD_ORIGEM
			CFD->(MsUnlock())
		ConfirmSX8()

		(cAliasCFD)->(dbSkip())
			
	EndDo

	Conout("Gravação do periodo de calculo FCI " + (cAliasCFD)->CFD_PERCAL + "gerado com sucesso")

	MsgInfo("Gravação do periodo de calculo FCI " + (cAliasCFD)->CFD_PERCAL + "gerado com sucesso")

	(cAlias)->(dbCloseArea())
	(cAliasCFD)->(dbCloseArea())

Return


/*/{Protheus.doc} fPerCal
Retorna o período de calculo para gravar na CFD
@type function
@version  
@author rodrigo.giesau
@since 13/02/2023
@param cCalculo, character, param_description
@return variant, return_description
/*/
Static Function fPerCal(cCalculo)

	Local cMes  := ""
	Local nMes  := ""
	Local cAno  := ""

	cAno := Year2Str(dDataBase) 

	cMes := SubStr(cCalculo,1,2)
	nMes := Val(cMes)

	If nMes == 12
		cMes := "0" + AllTrim(Str(1))
	Else
		nMes++
		If nMes < 10
			cMes := "0" + AllTrim(Str(nMes))
		Else
			cMes := AllTrim(Str(nMes))
		EndIf
	EndIf

	cPerCal := cMes + cAno


Return cPerCal


/*/{Protheus.doc} fPerVen
Retorna o periodo de venda para gravar na CFD
@type function
@version  
@author rodrigo.giesau
@since 13/02/2023
@param cVenda, character, param_description
@return variant, return_description
/*/
Static Function fPerVen(cVenda, cCalculo)

	Local cMes    := ""
	Local nMes    := ""
	Local cMesCal := ""
	Local cAno 	  := ""

	cAno := Year2Str(dDataBase) 

	cMes := SubStr(cVenda,1,2)
	cMesCal := SubStr(cCalculo,1,2)
	nMes := Val(cMes)

	If cMesCal == "01" .Or. cMesCal == "02"
		cAno := SubsTr(cVenda,3,4)
	EndIf

	If nMes == 12
		cMes := "0" + AllTrim(Str(1))
	Else
		nMes++
		If nMes < 10
			cMes := "0" + AllTrim(Str(nMes))
		Else
			cMes := AllTrim(Str(nMes))
		EndIf
	EndIf

	cPerVen := cMes + cAno


Return cPerVen
