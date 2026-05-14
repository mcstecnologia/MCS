#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 24/04/02

User Function SF1100I()        // incluido pelo assistente de conversao do AP6 IDE em 24/04/02


Local cCliDifalSC	:= GetNewPar("MV_XCLIDIF", "00391701#00504301")
Private  cICMPAD:= GetMv('MV_ICMPAD')
aArea := GetArea()


SetPrvt("CLOTE,")

Reclock("SF1",.F.)
SF1->F1_userbud := Substr(cUsuario,7,15)
SF1->(MsUnLock())

If SF1->F1_TIPO <> "D" .And. SF1->F1_TIPO <> "B"
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.T.)
		RecLock("SF1",.F.)
		SF1->F1_NOMFORN := SA2->A2_NOME
		MsUnLock("SF1")
	EndIf
Else
	// Nota Fiscal Devolucao, busca nome do cliente.
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.T.)
		RecLock("SF1",.F.)
		SF1->F1_NOMFORN := SA1->A1_NOME
		MsUnLock("SF1")
	Endif
Endif

IF ALLTRIM(SF1->F1_ESPECIE) == "NFEF"
	cLote := space(06)
	@ 0,0 TO 70,250 DIALOG oDIG TITLE "Digitacao"
	@ 05,10 Say "Informe o Nr.Lote: "
	@ 05,70 GET cLote PICTURE "@K" VALID naovazio().and.existcpo("SZH",cLote)
	@ 20,60 BMPBUTTON TYPE 1 ACTION (oDIG:End(), Processa({|| FazNota()}) )
	@ 20,90 BMPBUTTON TYPE 2 ACTION oDIG:End()
	ACTIVATE DIALOG oDIG CENTER
	
ENDIF

IF	SF1->F1_TIPO == 'N'
	If	(Select('TSD1')<>0)
		dbSelectArea('TSD1')
		dbCloseArea()
	EndIf
	
	BeginSql Alias 'TSD1'
		%noparser%
		SELECT D1_OP, SC2.R_E_C_N_O_ AS C2_RECNO, D1_QUANT, D1_TP
		FROM %Table:SD1% SD1 (NOLOCK), %Table:SC2% SC2 (NOLOCK)
		WHERE
		SC2.%NotDel% AND C2_FILIAL = %xFilial:SC2% AND
		SD1.%NotDel% AND D1_FILIAL = %xFilial:SD1% AND
		D1_OP = C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD AND
		C2_SITAOP = '3' AND D1_DOC = %exp:SF1->F1_DOC% AND
		D1_SERIE   = %exp:SF1->F1_SERIE% AND
		D1_FORNECE = %exp:SF1->F1_FORNECE% AND
		D1_LOJA    = %exp:SF1->F1_LOJA% AND
		C2_DATRF   = ' '
	EndSql
	
	TcSetField('TSD1','C2_RECNO','N',12,00)
	
	TSD1->(dbGotop())
	While !TSD1->(Eof())
		Begin Transaction
		SC2->(dbGoto(TSD1->C2_RECNO))
		RecLock('SC2',.F.)
		SC2->C2_SITAOP := '5'
		MsUnlock()
			
		// Alan Leandro - 27/05/2010 - inicio
		// Altera o status da Op Pai tambem, se todas as ops intermediarias
		// ja estiverem com Status 5.
		/////////////////////////////////////////////////////////////////////////////////
		If SC2->C2_sequen <> "001"
			cOpPaiAux := SC2->C2_NUM+SC2->C2_ITEM+"001"+SC2->C2_ITEMGRD
			lOpPaiAux := .T.
			
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+Substr(cOpPaiAux,1,8),.T.))
			While !SC2->(Eof()) .and. SC2->C2_FILIAL == xFilial("SC2") .and. SC2->(C2_NUM+C2_ITEM) == Substr(cOpPaiAux,1,8)
				If SC2->C2_sequen <> "001"
					If SC2->C2_SITAOP == '3'
						lOpPaiAux := .F.
					EndIf
				EndIf
				SC2->(dbSkip())
			EndDo
			
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+cOpPaiAux))
			If lOpPaiAux .and. SC2->(Found())
				RecLock("SC2",.F.)
				SC2->C2_SITAOP := "5"
				MsUnLock()
			Endif
		EndIf
		// Alan Leandro - 27/05/2010 - fim
		/////////////////////////////////////////////////////////////////////////////////
		End Transaction
		TSD1->(DbSkip())
	EndDo

    If	FunName()=='UZXIMP'  // JONAS - PARA FINS DE CALCULO DIFAL (IMPORTACAO) 23/12/2020
			cTES:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TE")
            cCF:= Posicione("SF4",1,xFilial("SF4")+cTES,"F4_CF")

		If AllTrim(SF1->F1_FORNECE) + AllTrim(SF1->F1_LOJA) $ cCliDifalSC	//Cliente + Loja utilizado para validar o DIFAL SC
	        
		      
				If	(Select('TSD1A')<>0)
		             dbSelectArea('TSD1A')
		             dbCloseArea()
	            EndIf
	
				BeginSql Alias 'TSD1A'
					%noparser%
					SELECT D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_ICMSCOM,D1_BASEICM,D1_PICM,(D1_BASEICM * ((%exp:cICMPAD%-D1_PICM)/100)) AS ICMSCOM
					FROM %Table:SD1% SD1 (NOLOCK)
					WHERE SD1.%NotDel% 
					AND D1_FILIAL  = %xFilial:SD1% 
					AND	D1_DOC     = %exp:SF1->F1_DOC% 
					AND D1_SERIE   = %exp:SF1->F1_SERIE% 
					AND D1_FORNECE = %exp:SF1->F1_FORNECE% 
					AND D1_LOJA    = %exp:SF1->F1_LOJA% 
					AND D1_CF      IN ('1556','1551') 
					
				EndSql
				DbSelectArea("SD1")
	            DbSetOrder(1)

				While !TSD1A->(Eof())

				    If SD1->(DbSeek(xFilial("SD1")+TSD1A->D1_DOC+TSD1A->D1_SERIE+TSD1A->D1_FORNECE+TSD1A->D1_LOJA+TSD1A->D1_COD+TSD1A->D1_ITEM))  //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

                       SD1->(RecLock("SD1",.F.)) 

			           SD1->D1_ICMSCOM :=  (((((D1_BASEICM-D1_VALICM)/0.83)*17/100)-D1_VALICM),2) ///TSD1A->ICMSCOM      ///SD1->D1_BASEICM * (((cICMPAD)- SD1->D1_PICM)/100)  Alteração conforme solicitação do setor fiscal.

					   SD1->D1_ALIQCMP := 17  // Inclusão Murilo 20/10/2021
						
			           SD1->(MsUnlock("SD1")) 

					EndIf

				    TSD1A->(dbSkip())
		        EndDo

		EndIf
    EndIf	 	

EndIf

RestArea(aArea)
//Roberto Fausto - TSC 243 -> Chamada de programa para alimentar tag's de importacao da nota eletronica 2.00
IF SA2->A2_EST == "EX"
	IF (cEmpAnt == "01" .or. cEmpAnt == "02") .AND. (FunName()=='MATA103' .OR. FunName()=='UZXIMP') //!Upper(AllTrim(FunName())) $ 'BUD373'
		ExecBlock("BUD997",.F.,.F.) 
	ENDIF
ENDIF


RETURN

// Substituido pelo assistente de conversao do AP6 IDE em 24/04/02 ==> Function FazNota
Static Function FazNota()
****************
dbSelectArea("SZH")
dbSetorder(1)
procregua(reccount())
dbSeek(xFilial("SZH")+cLote,.T.)
While !eof() .and. SZH->ZH_filial == xFilial("SZH")  .and.;
	SZH->ZH_lote   == cLote
	
	incproc()
	
	reclock("SZH",.F.)
	SZH->ZH_docent := SF1->F1_doc
	SZH->ZH_serent := SF1->F1_serie
	msUnlock("SZH")
	
	dbSelectArea("SZH")
	dbskip()
End
return 
