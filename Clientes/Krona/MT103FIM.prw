
/*
/=========================================================================\
|Titulo      : MT103FIM - Operação após gravação da NFE                	  |
|=========================================================================|
|Programa    : MT103FIM.PRW     | Responsável: Robson J. Pavanelli        |
|=========================================================================|
|Descricao   : O ponto de entrada MT103FIM encontra-se no final da função |
|              A103NFISCAL. Após o destravamento de todas as tabelas      |
|              envolvidas na gravação do documento de entrada, depois de  |
|              fechar a operação realizada neste.						  |
|              É utilizado para realizar alguma operação após a gravação  |
|              da NFE.      											  |
|=========================================================================|
|Data        : 17/04/2024 												  |
|=========================================================================|
|OBS		 : Migrado função MT103FIM() do GATIPE para este fonte.    	  |
\=========================================================================/
*/


User Function MT103FIM()
	Local aArea         := GetArea()
	Local aCmp   := aClone(PARAMIXB)
	Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
	Local nPosCod   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
	Local nInc		:= 0
	Local cItem     := ""
	Local cProduto  := ""
	Local cCliDifalSC	:= GetNewPar("MV_XCLIDIF", "00391701#00504301") //Cliente + Loja utilizado para validar o DIFAL SC
	Local cICMPAD	 := GetMv('MV_ICMPAD')
	Local cChave	    := ""
	Local lAtuDifal	:= .F.
	Local aAreaSD1	:= {}
	Local aAreaSFT	:= {}
	Local aAreaSF3	:= {}

	Local _nDesp	:= 0 //29/04/2025 - PERSONALITEC
	Local lNovaTrat   := SuperGetMv("BD_AFIL103",.F.,.F.) //parametro que ativa a nova tratativa de processos vindos da Afill

	// Ponto de chamada ConexãoNF-e sempre como primeira instrução.

	If  cEmpAnt == '01'
		U_GTPE002() 
	EndIf
	//Restaura parametro da tela da GNRe
	//A tratativa abaixo trabalha em complemento a customização do PE SD1100I
	//ROBERTO - PERSONALITEC
	If cEmpAnt == "01"
		PUTMV("MV_GNRENF", .T.)
	EndIF

	//CHAMADA PARA ROTINA QUE ENVIA EMAIL - AVISANDO SOLICITANTE CHEGADA DE ALGUM MATERIAL
	//SÓ É DISPARADO NA INCLUSÃO DA NOTA
	If  (aCmp[1] == 3 .OR. aCmp[1] == 4 ) .AND. aCmp[2] == 1
		U_BUD1205()

		// Ajusta tipo dos títulos SE2:
		If cEmpant == '01'
			If (AllTrim(FunName()) == 'MATA103' .OR. FunName()=='UZXIMP')
				MsgRun("Verificando títulos de ICM...", "Aguarde", {|| U_BUD1347() })

			End If
		End If
	Endif

	If  aCmp[1] == 3 .AND. aCmp[2] == 1 //Se Inclusao e Confirmou

		//Restaura parametro da tela da GNRe
		//A tratativa abaixo trabalha em complemento a customização do PE SD1100I
		//ROBERTO - PERSONALITEC
		//If cEmpAnt == "01" .and. mv_par18 == 1 .and. mv_par19 == 1 .AND. SF1->F1_EST == "EX" .And. SF1->F1_FORMUL == "S" .And. AllTrim(SF1->F1_ESPECIE) == "SPED"
		//lTelagnre := GetMV("MV_GNRENF")
		//If  !lTelagnre
		//PUTMV("MV_GNRENF", .T.)
		//EndIf
		//EndIF

		/*
		//Conforme pedido da Monica de importacao/exportacao, foi criado uma rotina para envio de NF de entrada
		//automatico para o Sefaz
		*/
		If  SF1->F1_EST == "EX" .And. SF1->F1_FORMUL == "S" .And. AllTrim(SF1->F1_ESPECIE) == "SPED"
			U_BUD1287()
		EndIf

		/*
		//Conforme pedido do Marcelo, precisa atualizar o campo D1_CUSTO, sera aberto um chamado para tratar no padrao
		//Murilo - GoOne - 04/02/18
		*/
		If cTipo == "N"

			aAreaSD1 := SD1->(GetArea())

			SD1->(DbSetOrder(1))

			For nInc := 1 to Len(aCols)
				If !aCols[nInc][Len(aHeader)+1]
					cItem     	:= aCols[nInc][nPosItem]
					cProduto  	:= aCols[nInc][nPosCod]

					If AllTrim(SF1->F1_FORNECE) + AllTrim(SF1->F1_LOJA) $ cCliDifalSC	//Cliente + Loja utilizado para validar o DIFAL SC
						If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+cProduto+cItem))  //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
							If SD1->D1_ICMSCOM > 0 .And. SubStr(SD1->D1_CF,1,1) <> "1" .And. SD1->D1_TES $ "242#243"
								SD1->(RecLock("SD1",.F.))
								SD1->D1_CF := "1"+SubStr(SD1->D1_CF,2)
								SD1->(MsUnlock("SD1"))

								lAtuDifal := .T.
							EndIf
						EndIf
					EndIf

					If	FunName()=='UZXIMP'
						cTES:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TE")
						cCF:= Posicione("SF4",1,xFilial("SF4")+cTES,"F4_CF")

						If AllTrim(SF1->F1_FORNECE) + AllTrim(SF1->F1_LOJA) $ cCliDifalSC	//Cliente + Loja utilizado para validar o DIFAL SC
							If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_COD+SD1->D1_ITEM))  //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
								If AllTrim(cCF) $ "1556#1551"

									SD1->(RecLock("SD1",.F.))
									SD1->D1_ICMSCOM := (((((D1_BASEICM-D1_VALICM)/0.83)*17/100)-D1_VALICM),2)  //D1_BASEICM * (((cICMPAD)- D1_PICM)/100)
									SD1->(MsUnlock("SD1"))

								EndIf
							EndIf
						EndIf
					EndIf

				EndIf
			Next nInc

			If lAtuDifal

				SF1->(RecLock("SF1",.F.))
				SF1->F1_EST := "SC"
				SF1->(MsUnlock("SF1"))

				aAreaSFT := SFT->(GetArea())

				SFT-> ( dbSetOrder(1) )

				cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
				If SFT->(dbSeek(cChave))
					While 	SFT-> ( ! Eof() )	.And. ;
							cChave == SFT->FT_FILIAL + "E" + SFT->FT_SERIE + SFT->FT_NFISCAL + SFT->FT_CLIEFOR + SFT->FT_LOJA

						SFT->(RecLock("SFT"))
						SFT->FT_ESTADO 	:= "SC"
						SFT->FT_CFOP   	:= "1"+SubStr(SFT->FT_CFOP,2)
						SFT->(MsUnLock())

						SFT->(dbSkip())	// Avanca o ponteiro do registro no arquivo
					EndDo
				EndIf

				aAreaSF3 := SF3->(GetArea())

				SF3-> ( dbSetOrder(4) )

				cChave	:= SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
				If SF3->(dbSeek(cChave))
					While 	SF3-> ( ! Eof() )	.And.;
							cChave == SF3->F3_FILIAL + SF3->F3_CLIEFOR + SF3->F3_LOJA + SF3->F3_NFISCAL + SF3->F3_SERIE

						SF3->(RecLock("SF3"))
						SF3->F3_ESTADO 	:= "SC"
						SF3->F3_CFO   	:= "1"+SubStr(SF3->F3_CFO,2)
						SF3->(MsUnLock())

						SF3->(dbSkip()) // Avanca o ponteiro do registro no arquivo
					EndDo
				EndIf

				SFT->(RestArea(aAreaSFT))
				SF3->(RestArea(aAreaSF3))

			EndIf

			SD1->(RestArea(aAreaSD1))
		EndIf
	EndIf

	//Chamada da funcao para reprocessar as NFs com Difal.
	//Murilo - 20/10/2021
	If  aCmp[1] == 3 .AND. aCmp[2] == 1 //Se Inclusao e Confirmou
		If AllTrim(SF1->F1_FORNECE) + AllTrim(SF1->F1_LOJA) $ cCliDifalSC	//Cliente + Loja utilizado para validar o DIFAL SC
			Reprocessa()
		EndIf
	EndIf
	//Fim Murilo

	//Tratamento SF6/SE2/CDA - Notas de Importação
	IF (aCmp[1] == 3 .OR. aCmp[1] == 4 ) .AND. aCmp[2] == 1 .AND. SF1->F1_EST == "EX" .AND. SF1->F1_DIFIMP > 0
	
		IF (cEmpAnt == "01" .or. cEmpAnt == "02") .AND. (FunName()=='MATA103' .OR. FunName()=='UZXIMP' )
			U_BUD1344(SF1->F1_DOC,SF1->F1_SERIE)	
		ENDIF
	ENDIF

	//29/04/2025 - PERSONALITEC
	//23/06/2025 - JONAS SOLICITOU PARA COMENTAR ESTA TRATATIVA
	/*If lNovaTrat .and. FunName()=='UZXIMP'
		If cEmpAnt == "01"  .AND. (aCmp[1] == 3 .OR. aCmp[1] == 4 ) .AND. aCmp[2] == 1 .AND. SF1->F1_EST == "EX"
			DbSelectArea("SD1")  
			SD1->(dbSetOrder(1))
			SD1->(dbgotop()) 
			SD1->(dbseek(XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.t.))  

			While SD1->(!eof()) .and. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE = SF1->F1_FORNECE .and. SD1->D1_LOJA = SF1->F1_LOJA
				_AtuAfill(SD1->D1_ITEM)
				_nDesp += SD1->D1_DESPESA
				SD1->(DBSkip())
			End

			SF1->(RecLock("SF1",.F.))
				SF1->F1_DESPESA := _nDesp
			SF1->(MsUnlock("SF1"))
		Endif
	EndIf*/

RestArea(aArea)

Return


//Funcao para reprocessar as NFs com Difal
//Murilo - 20/10/2021
Static Function Reprocessa()
	Local aParam  		:= array(11)
	Local lRotAut 		:= .T.
	Local cFunNameBkp 	:= FunName()

	SetFunName("MATA930")
	Pergunte("MTA930",.F.)

	aParam[1]  := dToc(SF1->F1_DTDIGIT) 	//Data Inicial
	aParam[2]  := dToc(SF1->F1_DTDIGIT) 	//Data Final
	aParam[3]  := 1          				//1-Entrada 2-Saída 3-Ambos
	aParam[4]  := SF1->F1_DOC       		//Nota Fiscal Incial
	aParam[5]  := SF1->F1_DOC   			//Nota Fiscal Final
	aParam[6]  := SF1->F1_SERIE     		//Série Incial
	aParam[7]  := SF1->F1_SERIE     		//Série Final
	aParam[8]  := SF1->F1_FORNECE   		//Cli/For Inicial
	aParam[9]  := SF1->F1_FORNECE  			//Cli/For Final
	aParam[10] := SF1->F1_LOJA      		//Loja Incial
	aParam[11] := SF1->F1_LOJA      		//Loja Final

	MATA930(lRotAut,aParam)

	Pergunte("MTA103",.F.)
	SetFunName(cFunNameBkp)

Return
//Fim Murilo




Static Function _AtuAfill(cItem)
Local cD1ITEM     := cItem
Local cMVFORNEAF  := GetMv("MV_FORNEAF") //27/03/2025  - Personalitec - Marcelo definiu para usar este parâmetro

//27/03/2025  - PERSONALITEC - 3. Ajuste nas despesas de processo conta e ordem (DIFAL)
/*
03/06/2025 - PERSONALITEC - COMENTADO ESTA VALIDAÇÃO - AJUSTES RESOLVIDO DIRETO NA AFILL VIA PACOTE DE ATUALIZAÇAO
If !(SF1->F1_STATUS $ "B|C") .And. AllTrim(SF1->F1_FORNECE) $ cMVFORNEAF

	If (Select("_BD01") <> 0)
		_BD01->(dbCloseArea())
	EndIf

	BeginSQL ALIAS "_BD01"
		SELECT D1_FILIAL, D1_DTDIGIT, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NOME, A2_SIMPNAC, D1_TES, D1_CF, D1_COD,
		D1_ITEM, D1_TOTAL, D1_BASEICM, D1_PICM, D1_VALICM, D1_VALIPI, D1_CUSTO, D1_ICMSCOM,D1_XVALII, Z15_VALII,
		ROUND(((((D1_BASEICM-D1_VALICM)/0.83)*17/100)-D1_VALICM),2) as DIFAL_DENTRO 
		FROM %TABLE:SD1% D1
		INNER JOIN %TABLE:SA2%  A2 ON A2_FILIAL = %xFilial:SA2% AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND A2.%NOTDEL%
		INNER JOIN %TABLE:Z15%  Z15 ON Z15_FILIAL=  %xFilial:Z15%  AND Z15_PROC=D1_CONHEC  AND  Z15_CODIT=D1_COD AND Z15.%NOTDEL%
		WHERE D1.%NOTDEL%
		AND D1_FILIAL IN ('01','09','10')
		AND D1_DTDIGIT >= '20250213'
		AND D1_DOC = %exp:cNFiscal%
		AND D1_SERIE = %exp:cSerie%
		AND D1_FORNECE = %exp:CA100FOR%
		AND D1_LOJA = %exp:cLOJA%     
		AND D1_ITEM = %exp:cD1ITEM%
		ORDER BY 10                    
	EndSql

	While !_BD01->(Eof()) 
		DbSelectArea("SD1")
		DbSetOrder(1)
		
		If dbSeek(xFilial("SD1")+ AvKey(_BD01->D1_DOC, "D1_DOC") + AvKey(_BD01->D1_SERIE, "D1_SERIE") + AvKey(_BD01->D1_FORNECE, "D1_FORNECE")  + AvKey(_BD01->D1_LOJA, "D1_LOJA") + AvKey(_BD01->D1_COD , "D1_COD")+  AvKey(_BD01->D1_ITEM , "D1_ITEM")) 
			RecLock('SD1',.F.)
				SD1->D1_ICMSCOM := _BD01->DIFAL_DENTRO
				SD1->D1_XVALII 	:= _BD01->Z15_VALII
				SD1->D1_ALIQCMP	:= 17
			MsUnlock('SD1')
		Endif

		_BD01->(DBSKIP())
	EndDo

	If (Select("_BD01") <> 0)
		_BD01->(dbCloseArea())
	EndIf

ElseIf !(SF1->F1_STATUS $ "B|C")   */            

	//27/03/2025  - PERSONALITEC - 1. Ajuste de base de ICMS
	/*Definido pelo Marcelo
	Todas as notas que estiverem com o conteúdo D1_BASEICM diferente do Z15_BASICM, deve ser ajustada.
	*/
	/*If (Select("_BD02") <> 0)
		_BD02->(dbCloseArea())
	EndIf
	
	BeginSQL ALIAS "_BD02"
		SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_BASEICM, 
		Z15_FILIAL, Z15_DOC, Z15_SERIE, Z15_FORN, Z15_LOJA,Z15_CODIT,Z15_ITNF,Z15_BASICM
		FROM SD1010 D1
		INNER JOIN SF1010  F1  ON F1_FILIAL =  %xFilial:SF1%  AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1.%NOTDEL% 
		INNER JOIN Z15010  Z15 ON Z15_FILIAL=  %xFilial:Z15%  AND Z15_PROC=D1_CONHEC  AND  Z15_CODIT=D1_COD  AND Z15_ITNF=D1_ITEM AND Z15.%NOTDEL%
		WHERE D1.%NOTDEL%
		AND D1_FILIAL = %xFilial:SD1%
		AND D1_DOC = %exp:cNFiscal%
		AND D1_SERIE = %exp:cSerie%
		AND D1_FORNECE = %exp:CA100FOR%
		AND D1_LOJA = %exp:cLOJA%  
		AND D1_ITEM = %exp:cD1ITEM%'
	EndSql

	DbSelectArea("SD1")
	DbSetOrder(1) 
	
	If dbSeek(xFilial("SD1")+ AvKey(_BD02->D1_DOC, "D1_DOC") + AvKey(_BD02->D1_SERIE, "D1_SERIE") + AvKey(_BD02->D1_FORNECE, "D1_FORNECE")  + AvKey(_BD02->D1_LOJA, "D1_LOJA") + AvKey(_BD02->D1_COD , "D1_COD")+  AvKey(_BD02->D1_ITEM , "D1_ITEM")) 
		If _BD02->D1_BASEICM != _BD02->Z15_BASICM
			RecLock('SD1',.F.)
				SD1->D1_BASEICM := _BD02->Z15_BASICM
			MsUnlock('SD1')
		EndIf
	Endif

	If (Select("_BD02") <> 0)
		_BD02->(dbCloseArea())
	EndIf
	*/
If !(SF1->F1_STATUS $ "B|C")  	
	//2. Ajuste de retirada de AFRMM em nota de revenda
	/*Definido pelo Marcelo
	Todas as notas que tiverem CFOP 3102 (D1_CF) deverão sofrer o ajuste abaixo:
	Alteração banco de dados campos:
	D1_DESPESAS = D1_XTXSIS
	D1_XDICM = deixar em branco
	F1_DESPESAS = D1_XTXSIS
	F1_VALBRUT = Valor passado
	*/
	If (Select("_BD03") <> 0)
			_BD03->(dbCloseArea())
	EndIf
	
	BeginSQL ALIAS "_BD03"
		SELECT D1_DESPESA,D1_XTXSIS,D1_XDICM, D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_BASEICM
		FROM %TABLE:SD1% D1
		INNER JOIN %TABLE:SF1%  F1    ON F1_FILIAL = %xFilial:SF1% AND F1.%NOTDEL%  AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA 
		INNER JOIN %TABLE:SB1%  B1    ON B1_FILIAL = %xFilial:SB1% AND B1.%NOTDEL%  AND B1_COD=D1_COD  
		INNER JOIN %TABLE:Z15%  Z15   ON Z15_FILIAL= %xFilial:Z15% AND Z15.%NOTDEL% AND Z15_ITNF=D1_ITEM AND Z15_PROC=D1_CONHEC  AND  Z15_CODIT=D1_COD 
		INNER JOIN %TABLE:Z14%  Z14   ON Z14_FILIAL= %xFilial:Z14% AND Z14.%NOTDEL% AND Z14_PROC = Z15_PROC 
		INNER JOIN %TABLE:SC7%  C7    ON C7_FILIAL = %xFilial:SC7% AND C7.%NOTDEL%  AND C7_NUM=Z15_PEDIDO   AND  C7_PRODUTO=Z15_CODIT AND C7_ITEM=Z15_ITEMPC 
		INNER JOIN %TABLE:SF4%  F4    ON F4_FILIAL = %xFilial:SF4% AND F4.%NOTDEL%  AND F4_CODIGO=C7_TES
		WHERE D1.%NOTDEL%
		AND D1_FILIAL  = %xFilial:SD1%
		AND D1_DOC     = %exp:cNFiscal%
		AND D1_SERIE   = %exp:cSerie%
		AND D1_FORNECE = %exp:CA100FOR%
		AND D1_LOJA    = %exp:cLOJA%  
		AND D1_ITEM    = %exp:cD1ITEM%'
		AND F4_CF      = '3102'
	EndSql

	DbSelectArea("SD1")
	DbSetOrder(1) 
	
	If dbSeek(xFilial("SD1")+ AvKey(_BD03->D1_DOC, "D1_DOC") + AvKey(_BD03->D1_SERIE, "D1_SERIE") + AvKey(_BD03->D1_FORNECE, "D1_FORNECE")  + AvKey(_BD03->D1_LOJA, "D1_LOJA") + AvKey(_BD03->D1_COD , "D1_COD")+  AvKey(_BD03->D1_ITEM , "D1_ITEM")) 
		RecLock('SD1',.F.)
			SD1->D1_VALICM  := 0
			SD1->D1_DESPESA := SD1->D1_XTXSIS
			SD1->D1_XDICM	:= 0
		MsUnlock('SD1')					   
	Endif 

	If (Select("_BD03") <> 0)
		_BD03->(dbCloseArea())
	EndIf    

EndIf
Return
