#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#include "Tbiconn.ch"

/*/{Protheus.doc} MT103FIM
(PE MT103FIM, executado no final do MATA103)
@type function
@author Murilo Sensus
@since 20/12/2016
@version 1.0
@history 28/10/2025, Marcos Paulo Klein, Ticket 137255 - ajustado para enviar espelho da nota por email para conferÍncia do almoxarifado.
/*/

User Function MT103FIM()
	Local lRet        := .T.
	Local nOpc        := PARAMIXB[1]
	Local nBotOK      := PARAMIXB[2]
	Local aCab        := {}
	Local lWF         := .f.
	Local cDataEmis   := dtos(SF1->F1_EMISSAO)
	Local cDataDig    := dtos(SF1->F1_DTDIGIT)
	Local cEmail      := SuperGetMV("KR_MT103CC",.f., 'renato.jolinski@krona.com.br;' )
//	Local cHoraServer := nil
//	Local cHoraVerao  := nil
//	Local cHoraOk     := nil
	Local lVerba      := SuperGetmv("KR_VERBATV",.F.,.F.)
	Local i           := 0

	If !IsBlind()
		If(nOpc == 5 .And. ! INCLUI .And. ! ALTERA) //nOpc == 5 DEVOLUCAO
			///////////////////////////////////////////////////////////////////////////////////
			//Tratamento para manter o processo de devolu¡Ño, para quando a NF for excluida.//
			///////////////////////////////////////////////////////////////////////////////////
			If(!Empty(SF1->F1_KPRCDEV) .And. GetNewPar("KR_KRO826A", .T.))
				U_KRO826E(2)	//Opcao 1 - Guarda nas variaveis aCabKRO826 e aItKRO826 e opcao 2 faz a gravacao por MSExecAuto
			EndIf

			//	if SF1->F1_TIPO == "D"  .and. nBotOK == 1 .and. lVerba
			//		u_KVrbCop(.T.)
			//	endif

		EndIf
	Endif


	// Code Crafters - XML Import.
	If SuperGetMV("XI_MT103F", .F., .T.) .And. AllTrim(SF1->F1_ESPECIE) == "SPED" .And. (nOpc == 3 .Or. nOpc == 4) .And. nBotOK == 1
		//U_XIPE()
		SendAlcis()
		If !IsBlind()
			// PrintMirror()
		Endif
	EndIf

	If AllTrim(SF1->F1_ESPECIE) == "SPED" .And. nBotOK == 1 .And. (nOpc == 3 .Or. nOpc == 4) // Inclus„o ou alteraÁ„o
 		PrintWf()
	EndIf

//extrato de verba cooperada              //nBotOK == 1 Confirmar
	if INCLUI .And. SF1->F1_TIPO == "D" .and. nBotOK == 1 .and. lVerba
		u_KVrbCop(.F.)
	endIf

	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA )
	cNomeFornece := alltrim(SA2->A2_NOME)

	If INCLUI
		aCab := {}
		lWF := .f.
		cDataEmis:= dtos(SF1->F1_EMISSAO)
		cDataDig:= dtos(SF1->F1_DTDIGIT)
		If cEmpAnt == '08' .and. lRet
			If (Substr(cDataEmis,1,6) <> Substr(cDataDig,1,6)) .and. (SD1->D1_TES <> '241')
				for i:=1 to len(aCols)
					if (aCols[i][1] >= 'A001') .and. (aCols[i][1]  <= 'A023') .and. (aCols[i][1]  <> 'A005')
						lWF := .t.
					Endif
				next i
			Endif
			if lWF
				cCab := ' '
				aadd(aCab, 'N?mero da Nota: ' + SF1->F1_Doc + ' - S»rie: ' + SF1->F1_SERIE)
				aadd(aCab, 'Fornecedor: ' + SF1->F1_FORNECE +' - ' +SF1->F1_LOJA + ' - ' + cNomeFornece)
				aadd(aCab, 'Valor Total da Nota: R$' + alltrim(Transform(SF1->F1_VALBRUT,'@E 999,999,999.99')))
				aadd(aCab, 'Data de Digita¡Ño: ' + cValToChar(SF1->F1_DTDIGIT))
				aadd(aCab, 'Data de EmissÑo: ' + cValToChar(SF1->F1_EMISSAO))
			/*for i:=1 to len(aCab)
				cCab += aCab[i] + '<br/>'
			next i*/
			u_fastmail(cEmail,'','ALERTA - Nota De Servi¡o digitada ap€s emissao!!',aCab)
		endif
	Endif
Endif

dDtInicio 	:= cValToChar(SuperGetMv("MV_HVERAOI",.f.,"20181104"))
dDtFim		:= cValToChar(SuperGetMv("MV_HVERAOF",.f.,"20190221"))
dDtEmissao	:= cValToChar(SF1->F1_EMISSAO)

if inclui .and. cEmpAnt == '08' //quando for inclusÑo na empresa nordeste
	if dDtEmissao >= dDtInicio .and. dDtEmissao <= dDtFim
		if ALLTRIM(SF1->F1_HORA) >= '01:01' .AND. ALLTRIM(SF1->F1_HORA) <= '23:59'
			RecLock("SF1",.F.)
			SF1->F1_HORA := StrTran(StrZero(SubHoras( SF1->F1_HORA,'01:00' ),5,2),'.',':')
			MsUnlock()
		endif
	endif
endif

//?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
//?Envia E-mail para o Fornecedor no Caso de Nota Fiscal Antecipada           ?
//øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
MsgFornece(nOpc)


If SuperGetMv("KR_103MCTB",.F.,.T.)
	If Inclui
	   //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	   //?Marca o CTE como contabilizado                                             ?
	   //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	   If Upper(Alltrim(SF1->F1_ORIGEM)) = "GFEA065"
	      SF1->(Reclock("SF1",.F.))
	      SF1->F1_DTLANC := dDatabase
	      SF1->(MsUnLock())
	   Endif
	Endif
Endif



	// Quando for exclus„o de NF, retornar database conforme variavel declarada em MT103CTB
    If nOpc == 5 .and. Type("dDigitInc") != "U"
        dDataBase := dDigitInc
    EndIf

Return lRet

/*/{Protheus.doc} SendAlcis
Fun¡Ño para fazer o envio da NF ao Alcis.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 18/04/2022
/*/
Static Function SendAlcis()

	Local aFields	:= {}
	Local oTmpTable := Nil

	If cEmpAnt == "08" .Or. CanSendAlcis()
		AAdd(aFields,{"TRB_OK", "C", 2, 0})
		AAdd(aFields,{"TRB_REG", "N", 12, 0})

		oTmpTable := FWTemporaryTable():New("TRBBRW")
		oTmpTable:SetFields(aFields)
		oTmpTable:Create()

		TRBBRW->(RecLock("TRBBRW", .T.))
			TRBBRW->TRB_OK := "XX"
			TRBBRW->TRB_REG := SF1->(Recno())
		TRBBRW->(MsUnLock())

		&('StaticCall(ALC020, ExpRegs, "", {})')

		oTmpTable:Delete()
	EndIf

Return

/*/{Protheus.doc} CanSendAlcis
Fun¡Ño validar se deve realizar o envio da NF ao Alcis.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 18/04/2022
@return logical, se deve enviar ao Alcis.
/*/
Static Function CanSendAlcis()

	Local cAlias 	:= GetNextAlias()
	Local lOk 		:= .F.

	BeginSQL Alias cAlias
		SELECT
			SD1.R_E_C_N_O_
		FROM
			%Table:SD1% SD1
		WHERE
				D1_FILIAL = %XFilial:SD1%
			AND D1_DOC = %Exp:SF1->F1_DOC%
			AND D1_SERIE = %Exp:SF1->F1_SERIE%
			AND D1_FORNECE = %Exp:SF1->F1_FORNECE%
			AND D1_LOJA = %Exp:SF1->F1_LOJA%
			AND D1_LOCAL != '80'
			AND SD1.%NotDel%
	EndSQL

	lOk := !(cAlias)->(EOF())

	(cAlias)->(DBCloseArea())

Return lOk

Static Function PrintMirror()

    Local cPrinter  := SuperGetMV("KR_PRTESP", .F., "")

    MV_PAR01 := SF1->F1_DOC
    MV_PAR02 := SF1->F1_SERIE
    MV_PAR03 := dDataBase
    MV_PAR04 := 2
    MV_PAR05 := 0
    MV_PAR06 := 1

	If U_kEmpFil() == "0101" .And. CanPrintMirror()
		U_KRO607(cPrinter)
	EndIf

Return

/*/{Protheus.doc} CanPrintMirror
Fun¡Ño validar se deve realizar a impressÑo do espelho da NF.
@type function
@version 1.0
@author comercial@codecrafters.com.br
@since 18/04/2022
@return logical, se deve imprimir o espelho.
/*/
Static Function CanPrintMirror()

	Local cAlias 	:= GetNextAlias()
	Local lOk 		:= .F.

	BeginSQL Alias cAlias
		SELECT
			SD1.R_E_C_N_O_
		FROM
			%Table:SD1% SD1
		WHERE
				D1_FILIAL = %XFilial:SD1%
			AND D1_DOC = %Exp:SF1->F1_DOC%
			AND D1_SERIE = %Exp:SF1->F1_SERIE%
			AND D1_FORNECE = %Exp:SF1->F1_FORNECE%
			AND D1_LOJA = %Exp:SF1->F1_LOJA%
			AND D1_LOCAL = '80'
			AND SD1.%NotDel%
	EndSQL

	lOk := !(cAlias)->(EOF())

	(cAlias)->(DBCloseArea())

Return lOk

//Ticket 137255
Static Function PrintWf() 

	Local cEmail1    := "" 
	Local cPrinter   := ""
	Local lSendPdf   := .F.
	Local cDiretorio := ""
	Local cArquivo   := ""
	Local cFullPath  := ""

	// Enviar espelho como anexo por e-mail. 
	// Caso contr·rio, mantÈm o comportamento anterior de imprimir na a impressora configurada.s

	If U_kEmpFil() == "0101"
		cEmail1:= SuperGetMV("KR_EMLSP01", .F., "almoxarifado.matriz@krona.com.br" )      //KR_EMLSP01 almoxarifado.matriz@krona.com.br
	ElseIf cEmpAnt == "05"
		cEmail1:= SuperGetMV("KR_EMLSP05", .F., "almoxarifado.acessorios@krona.com.br" )  //KR_EMLSP05 almoxarifado.acessorios@krona.com.br
	ElseIf cEmpAnt == "08"
		cEmail1:= SuperGetMV("KR_EMLSP08", .F., "almoxarifado.ne@krona.com.br" )          //KR_EMLSP08 almoxarifado.ne@krona.com.br
	ElseIf cEmpAnt == "10" 
		cEmail1:= SuperGetMV("KR_EMLSP10", .F., "almoxarifado.ultraterm@krona.com.br" )   //KR_EMLSP10 almoxarifado.ultraterm@krona.com.br
	EndIf

	// Se foi passado um e-mail, tenta gerar um PDF em diretÛrio tempor·rio
	If !Empty(AllTrim(cEmail1))
		// monta caminho tempor·rio para o PDF
		// suposiÁ„o: enviar o caminho como 'printer' para U_KRO607 far· a rotina gerar o PDF nesse arquivo
		cDiretorio := "\spool\"
		cArquivo   := "espelho_nf_" + AllTrim(SF1->F1_DOC) + "_" + StrTran(FWTimeStamp(1), ":", "") + ".pdf"
		cPrinter   := cDiretorio + cArquivo
		lSendPdf   := .T.
		
	EndIf

	cDocImp  := SF1->F1_DOC
	cSerImp  := SF1->F1_SERIE
	dDateImp := DATE()

	cBody := "Em anexo, espelho da  " + Chr(13) + Chr(10)
	cBody += "nota fiscal " + cDocImp + Chr(13) + Chr(10)
	cBody += "sÈrie " + cSerImp + Chr(13) + Chr(10)

	If U_kEmpFil() == "0101" .And. CanPrintEsp() //n„o pode ser apenas na filial 01
		// Chama a rotina de impress„o; quando cPrinter for um caminho .pdf deve criar o arquivo
		U_KRO607(cArquivo)

		// Se enviar por e-mail lSendPdf == .T., ent„o o anexa o PDF e envia.
		If lSendPdf
			cFullPath := cPrinter // cPrinter = cDiretorio + cArquivo
			If File(cFullPath)
				//KNewFastMail(email,cÛpia,assunto,corpo,anexo)
				U_KNewFastMail( cEmail1, "", "Espelho NF " + cDocImp + ", SÈrie " + cSerImp + ".", cBody, cFullPath )

				// limpa arquivo tempor·rio apÛs envio
				fErase(cFullPath)
			Else
				// n„o gerou o PDF, envia aviso simples
				u_fastmail( cEmail1, "", "Espelho NF " + cDocImp + " - falha ao gerar PDF", {"N„o foi possivel gerar o PDF do espelho para envio." + cBody} )
			EndIf
		EndIf
	EndIf

Return

//Ticket
/*/{Protheus.doc} CanPrintEsp 
FunÁ„o para validar se deve realizar a impress„o do espelho da NF.
@type function
@version 1.0
@author MARCOS PAULO KLEIN
@since 21/10/2025
@return logical, se deve imprimir o espelho.
/*/
Static Function CanPrintEsp() 

	Local cAlias := GetNextAlias()
	Local lOk    := .F.

	BeginSQL Alias cAlias
		SELECT
			SD1.R_E_C_N_O_
		FROM
			%Table:SD1% SD1
		WHERE
				D1_FILIAL = %XFilial:SD1%
			AND D1_DOC = %Exp:SF1->F1_DOC%
			AND D1_SERIE = %Exp:SF1->F1_SERIE%
			AND D1_FORNECE = %Exp:SF1->F1_FORNECE%
			AND D1_LOJA = %Exp:SF1->F1_LOJA%
			AND ((D1_LOCAL = '01' AND D1_TP = 'MK') OR D1_LOCAL IN ('48','49','50','80'))
			AND D1_CF IN ('1116','1124','1551','1556','1902','1908','1912','1916','1949','2551', '2556', '2909','2911','2949')
			AND SD1.%NotDel%
	EndSQL

	lOk := !(cAlias)->(EOF())

	(cAlias)->(DBCloseArea())

Return lOk
//FIM Ticket 137255

Static Function MsgFornece(nOpc)
//?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
//?Envia E-mail para o Fornecedor no Caso de Nota Fiscal Antecipada           ?
//øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
//Local xCondAnt := SuperGetMv("KR_KRO895C",.F.,"001/M76")
Local aTxtMail := {}
Local xTitMail := ""
Local lSE2     := .F.
Local aTxt     := {}
Local cEmail2  := SuperGetMV("KR_MT103US",.f.,'maiara.cunhago@krona.com.br;')

If (INCLUI .and. SF1->F1_TIPO == "N") .Or. (nOpc == 4 .and. ALTERA  )
	//?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	//?Se for InclusÑo e o Tipo da Nota for normal                                ?
	//øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?

   //If SF1->F1_COND $ xCondAnt
		//?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
		//?Se a Condi¡Ño de Pagamento for Antecipada                                  ?
		//øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?

	    //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	    //?Seta os Indices Utilizados                                                 ?
	    //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
        SA2->(dbSetOrder(1)) //A2_FILIAL+A2_COD+A2_LOJA
        SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO

       If SA2->(dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))
	      //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	      //?Pesquisa p Cliente da Nota Fiscal                                          ?
	      //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?

          If SA2->A2_KLANTNF == "S" .and. !Empty(SA2->A2_KNFMAIL)
		      //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
		      //?Se o Fornecedor estiver configurado para Enviar o Email                    ?
	    	  //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?

              xTitMail := "NOTA FISCAL " + SF1->F1_DOC + IIf(!Empty(SF1->F1_SERIE), "-" +  SF1->F1_SERIE,"") + " - LANCADA (KRONA TUBOS E CONEXOES - "+IIf(U_kEmpFil() == "0101","MATRIZ",IIf(cEmpAnt == "05","ACESSORIOS",IIf(cEmpAnt == "08","NORDESTE","")))+")"
              aadd(aTxtMail,"Caro fornecedor.")
			  aadd(aTxtMail,"Informamos que recebemos sua nota fiscal e que encontra-se lan&ccedil;ada em nosso sistema para programa&ccedil;&atilde;o de pagamento conforme abaixo:")
              aadd(aTxtMail," <br />")
              aadd(aTxtMail,"Fornecedor  :" + "<b>" + SF1->F1_FORNECE + SF1->F1_LOJA + " " + SA2->A2_NOME + "</b>"  )
              aadd(aTxtMail,"Nota Fiscal :" + "<b>" + SF1->F1_DOC     + IIf(!Empty(SF1->F1_SERIE), "-" +  SF1->F1_SERIE,"") + "</b>")
              aadd(aTxtMail,"Valor       :" + "<b>" + Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")+ "</b>")
              aadd(aTxtMail,"<br />")
              aadd(aTxtMail,"Vencimentos :")



              SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC,.F.))
              While !SE2->(Eof()) .and. SE2->E2_FILIAL == SE2->(xFilial()) .and. SE2->E2_FORNECE == SF1->F1_FORNECE .and. SE2->E2_LOJA == SF1->F1_LOJA .and. SE2->E2_PREFIXO == SF1->F1_SERIE .and. SE2->E2_NUM = SF1->F1_DOC

			        //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
			        //?Abastece o Vetor com os dados do tÃtulo                                    ?
		     	    //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
                    aadd(aTxtMail,"->" + "<b>" + SE2->E2_PREFIXO + "-" + SE2->E2_NUM + IIf(!Empty(SE2->E2_PARCELA),"-" + SE2->E2_PARCELA,"") + " VENCIMENTO  ("+Dtoc(SE2->E2_VENCREA)+")" + " VALOR "  + TransForm(SE2->E2_SALDO,"@E 999,999,999.99")  + "</b>")

                    lSE2 := .T.
                    SE2->(dbSkip())
              EndDo
              aadd(aTxtMail," <br />")
              aadd(aTxtMail,"Atenciosamente, ")

              If U_kEmpFil() == "0101"
                 aadd(aTxtMail,"Krona Tubos e Conexoes ")
			     aadd(aTxtMail,"Telefone: 47 - 3431-7800")
			  ElseIf cEmpAnt == "08"
                 aadd(aTxtMail,"Krona Tubos e Conexoes do Nordeste ")
			     aadd(aTxtMail,"Telefone: 82 - 3263-3300")
              ElseIf cEmpAnt == "05"
                 aadd(aTxtMail,"Krona Acessorios Hidraulicos")
			     aadd(aTxtMail,"Telefone: 47 - 3431-7912")
			  Endif


              If lSE2
	              If Len(aTxtMail) > 0
				      //?ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
				      //?Envia o E-mail para o Fornecedor                                           ?
			     	  //øÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ?
	                  U_FastMail(Alltrim(SA2->A2_KNFMAIL),'',xTitMail,aTxtMail)
	              Endif
              Endif

          Endif
      Endif
   //Endif
Endif
//////////////////////////////////////////////////////////////////////////////
//Envia WF quando for NF de retorno//
//////////////////////////////////////////////////////////////////////////////
If (nOpc == 3)
	SD1->(dbSetOrder(1))
	If SD1->(dbSeek(xFilial("SD1")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja,.F.))
		If (INCLUI)
			If(cEmpAnt == "05" .or. U_kEmpFil() == "0101")
				If (SD1->D1_TES == '222' .OR. SD1->D1_TES == '062') .AND. (SD1->D1_FORNECE != '003078')
					aTxt := {}
					aadd(aTxt, 'As notas de retorno de remessas em conserto e industrializacao estao entrando na Krona. ')
					aadd(aTxt, 'N?mero da Nota: ' + SF1->F1_Doc + ' - S»rie: ' + SF1->F1_SERIE)
					aadd(aTxt, 'Fornecedor: ' + SF1->F1_FORNECE +' - ' +SF1->F1_LOJA + ' - ' + cNomeFornece)
					aadd(aTxt, 'Data de Digitacao: ' + cValToChar(SF1->F1_DTDIGIT))
					aadd(aTxt, 'Data de Emissao: ' + cValToChar(SF1->F1_EMISSAO))

					u_kfastmail(cEmail2,'','ALERTA - Retorno de Remessas !!',aTxt)
				Endif
			Endif
		Endif
	Endif
Endif
Return

User function KVrbCop(lCancela)

	local aDados  := {}
	local nValor  := 0
	local _cQuery := ""
	local _cAlias := GetNextAlias()
	local aRet898 := {}
	local aMsgErr := {}
	local cTimeIn := Time()
	local dDataIn := Date()

	_cQuery += " select D1_QUANT, D1_NFORI, D1_SERIORI, D1_DOC, D1_SERIE, D2_PEDIDO, D2_ITEMPV, D1_TOTAL "
	_cQuery += "       ,C6_KVRBCOP, C6_KVRBPER, C6_KVRBVLR, C6_QTDVEN, D2_CLIENTE, D2_LOJA, D2_COD "
	_cQuery += " from " + RetSqlTab("SD1")
	_cQuery += " inner join " + RetSqlTab("SD2")
	_cQuery += "    on " + RetSqlCond("SD2")
	_cQuery += "   and SD2.D2_DOC = SD1.D1_NFORI "
	_cQuery += "   and SD2.D2_SERIE = SD1.D1_SERIORI "
	_cQuery += "   and SD2.D2_ITEM = SD1.D1_ITEMORI "
	_cQuery += "   and SD2.D2_CLIENTE = SD1.D1_FORNECE "
	_cQuery += "   and SD2.D2_LOJA = SD1.D1_LOJA "
	_cQuery += " inner join " + RetSqlTab("SC6")
	_cQuery += "    on " + RetSqlCond("SC6")
	_cQuery += "   and SC6.C6_NUM = SD2.D2_PEDIDO "
	_cQuery += "   and SC6.C6_ITEM = SD2.D2_ITEMPV "
	_cQuery += "   and SC6.C6_KVRBCOP <> ' '  "
	_cQuery += " where " + RetSqlCond("SD1")
	_cQuery += "   and SD1.D1_DOC = " + ValToSql( SF1->F1_DOC )
	_cQuery += "   and SD1.D1_LOJA = " + ValToSql( SF1->F1_LOJA )
	_cQuery += "   and SD1.D1_SERIE = " + ValToSql( SF1->F1_SERIE )
	_cQuery += "   and SD1.D1_FORNECE = " + ValToSql( SF1->F1_FORNECE )

//	if lCancela
//		_cQuery := StrTran(_cQuery, "SD1.D_E_L_E_T_ = ' '", "SD1.D_E_L_E_T_ = '*'")
//	endIf

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),_cAlias, .T., .T.)

	while (_cAlias)->( ! EoF() )

		aDados := {}

		AADD(aDados, (_cAlias)->D2_COD     )
		AADD(aDados, (_cAlias)->D2_CLIENTE )
		AADD(aDados, (_cAlias)->D2_LOJA    )
		AADD(aDados, (_cAlias)->D2_PEDIDO  )
		AADD(aDados, (_cAlias)->D2_ITEMPV  )
		AADD(aDados, (_cAlias)->D1_DOC     )
		AADD(aDados, (_cAlias)->D1_SERIE   )
		AADD(aDados, (_cAlias)->D1_NFORI   )
		AADD(aDados, (_cAlias)->D1_SERIORI )

		nValor := ( (_cAlias)->C6_KVRBVLR / (_cAlias)->C6_QTDVEN ) * (_cAlias)->D1_QUANT
		nValor := nValor * IIF(lCancela, 1, -1) //no caso de devolu¡Ño, deve devolver o saldo

		nVlrAc := (_cAlias)->D1_TOTAL
		nVlrAc := nVlrAc * IIF(lCancela, 1, -1) //no caso de devolu¡Ño, deve devolver o saldo

		aRet898 := U_K898Mvto(	(_cAlias)->C6_KVRBCOP  ,;
								"D"                    ,;
								aDados                 ,;
								nValor                 ,;
								(_cAlias)->C6_KVRBPER  ,;
								IIF(lCancela, "cancelada NF devolucao", "devolucao de venda")   ,;
								"MT103FIM"             ,;
								nVlrAc                 ,;
								cTimeIn                ,;
								dDataIn                 )

		if ! aRet898[1]
			AADD(aMsgErr, aRet898[2])
		endIf

		(_cAlias)->( DbSkip() )

	endDo

	(_cAlias)->( DbCloseArea() )

	if ! Empty(aMsgErr)
		U_FastMail("ti.desenvolvimento@krona.com.br", "", "ocorreram erros ao efetivar a nota de devolu¡Ño com verba cooperada", aMsgErr)
	endIf

return

//revisao 001 - fabricio reche - 05/03/2019 - ajuste para verba cooperada
