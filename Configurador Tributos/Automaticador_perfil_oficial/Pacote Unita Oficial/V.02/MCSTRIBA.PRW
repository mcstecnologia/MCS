#Include 'Protheus.CH'

/*/{Protheus.doc} MCSTRIBA
Rotina para associar perfis em lote
@type function
@version  
@author MCS Tecnologia
@since 4/25/2026
@return variant, return_description
/*/
User Function MCSTRIBA()

    Local oButton1
    Local oButton2
    Local oComboBo1
    Local cVar      := ""
    Local oGroup1
    Local oSay1
    Local oSay
    Local aPerf     := {}
    Static oDlg

    aAdd(aPerf , "1=Cliente")
    aAdd(aPerf , "2=Fornecedor")
    aAdd(aPerf , "3=Produto")

    DEFINE MSDIALOG oDlg TITLE "Associar Perfis em Lote" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

        @ 005, 006 GROUP oGroup1 TO 093, 243 PROMPT "Associar Perfil" OF oDlg COLOR 0, 16777215 PIXEL
        @ 044, 085 MSCOMBOBOX oComboBo1 VAR cVar ITEMS aPerf SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 027, 042 SAY oSay1 PROMPT "Selecione abaixo qual perfil deseja realizar a associação automatica" SIZE 174, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 073, 158 BUTTON oButton1 PROMPT "Continuar" SIZE 037, 012 Action FwMsgRun(,{ |oSay| MCSTELA(oSay,cVar) }, "Aguarde...", "Realizando a pesquisa.") OF oDlg PIXEL
        @ 073, 199 BUTTON oButton2 PROMPT "Fechar" SIZE 037, 012 OF oDlg PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/{Protheus.doc} MCSBUSCA
Realiza a busca dos registros
@type function
@version  
@author MCS Tecnologia
@since 4/25/2026
@param oSay, object, param_description
@param nSel, numeric, param_description
@return variant, return_description
/*/
Static Function MCSBUSCA(cSel)

    Local xQuery   := ""
    Local xAlias   := GetNextAlias()
    Local aRegs    := {}

    Do Case 
        Case cSel == "1"
            xQuery := "SELECT A1_COD AS COD, A1_LOJA AS LOJA, A1_NOME AS NOME, A1_DTCAD AS DTCAD " + chr(13)
            xQuery += "FROM " +RetSqlName("SA1")+ " A1 " + chr(13)
            xQuery += "WHERE A1.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND A1.A1_MSBLQL <> '1' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F22")+ " F22 " + chr(13) 
            xQuery += "WHERE F22.F22_CLIFOR = A1.A1_COD " + chr(13)
            xQuery += "AND F22.F22_LOJA   = A1.A1_LOJA " + chr(13)
            xQuery += "AND F22.F22_TPPART = '2' " + chr(13)
            xQuery += "AND F22.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
        Case cSel == "2"
            xQuery := "SELECT A2_COD AS COD, A2_LOJA AS LOJA, A2_NOME AS NOME, '' AS DTCAD " + chr(13)
            xQuery += "FROM " +RetSqlName("SA2")+ " A2 " + chr(13)
            xQuery += "WHERE A2.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND A2.A2_MSBLQL <> '1' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F22")+ " F22 " + chr(13) 
            xQuery += "WHERE F22.F22_CLIFOR = A2.A2_COD " + chr(13)
            xQuery += "AND F22.F22_TPPART = '1' " + chr(13)
            xQuery += "AND F22.F22_LOJA   = A2.A2_LOJA " + chr(13)
            xQuery += "AND F22.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
        Otherwise
            xQuery := "SELECT B1_COD AS COD, B1_DESC AS NOME " + chr(13)
            xQuery += "FROM " +RetSqlName("SB1")+ " B1 " + chr(13)
            xQuery += "WHERE B1.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND B1.B1_MSBLQL <> '1' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F24")+ " F24 " + chr(13) 
            xQuery += "WHERE F24.F24_CDPROD = B1.B1_COD " + chr(13)
            xQuery += "AND F24.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
    EndCase

    MpSysOpenQuery(xQuery,xAlias)

    (xAlias)->(dbGoTop())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Instancia o objeto e cria o xml                                     ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    While (xAlias)->(!Eof())

        Do Case 
            Case cSel == "1"
                aadd(aRegs,{.F., (xAlias)->COD, (xAlias)->LOJA, (xAlias)->NOME, (xAlias)->DTCAD,"1" })
            Case cSel == "2"
                aadd(aRegs,{.F., (xAlias)->COD, (xAlias)->LOJA, (xAlias)->NOME, (xAlias)->DTCAD,"2" })
            Otherwise
                aadd(aRegs,{.F., (xAlias)->COD, (xAlias)->NOME, "3" })
        EndCase

        (xAlias)->(dbSkip())
    EndDo

    (xAlias)->(dbCloseArea())

Return (aRegs)

/*/{Protheus.doc} MCSTELA
Tela para seleção dos registros
@type function
@version  
@author MCS Tecnologia
@since 4/25/2026
@param aSay, array, param_description
@param nSel, numeric, param_description
@return variant, return_description
/*/
Static Function MCSTELA(oSay,cSel)

    Local oBrowse
	Local oDlg
	Local oGrp1
	Local oOk      := LoadBitmap(GetResources(),"LBOK")
	Local oNo      := LoadBitmap(GetResources(),"LBNO")
	Local aRet      := {}
	Local aBrowse   := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a consulta conforme parametrização indicada                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRet := MCSBUSCA(cSel)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do Array para a Tela                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aBrowse := aClone(aRet)


    If cSel == "3"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Montagem da Tela                                                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        DEFINE MSDIALOG oDlg TITLE "Seleção dos Produtos" FROM 000, 000  TO 500, 900 PIXEL
        @ 220, 005 GROUP oGrp1 TO 247, 445 PROMPT "" OF oDlg PIXEL
        oBrowse := TCBrowse():New(005,005,440,210,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
        oBrowse:AddColumn(TCColumn():New(" "		     , {|| IIf(aBrowse[oBrowse:nAt,01],oOk,oNo)}        ,,,,,,  .T.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Produto"       , {||     aBrowse[oBrowse:nAt,02]	}             ,,,,,50,.F.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Descrição"     , {||     aBrowse[oBrowse:nAt,03]	}             ,,,,,20,.F.,.F.,,,,.F.,))
    Else 
        DEFINE MSDIALOG oDlg TITLE "Seleção de cliente e fornecedor" FROM 000, 000  TO 500, 900 PIXEL
        @ 220, 005 GROUP oGrp1 TO 247, 445 PROMPT "" OF oDlg PIXEL
        oBrowse := TCBrowse():New(005,005,440,210,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
        oBrowse:AddColumn(TCColumn():New(" "		    , {|| IIf(aBrowse[oBrowse:nAt,01],oOk,oNo)}        ,,,,,,  .T.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Código"       , {||     aBrowse[oBrowse:nAt,02]	}             ,,,,,50,.F.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Loja"         , {||     aBrowse[oBrowse:nAt,03]	}             ,,,,,20,.F.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Nome"         , {||     aBrowse[oBrowse:nAt,04]	}             ,,,,,30,.F.,.F.,,,,.F.,))
        oBrowse:AddColumn(TCColumn():New("Cadastro"     , {||     aBrowse[oBrowse:nAt,05]	}             ,,,,,15,.F.,.F.,,,,.F.,))
    EndIf

	oBrowse:SetArray(aBrowse)
	oBrowse:bWhen         := { || Len(aBrowse) > 0 }
	oBrowse:blDblClick    := { || aBrowse[oBrowse:nAt,01] :=  !aBrowse[oBrowse:nAt,01]}

	DEFINE SBUTTON oBtnOk FROM 228, 350 TYPE 01 Action(nOpc := 1,oDlg:End()) OF oDlg ENABLE
	DEFINE SBUTTON oBtnNo FROM 228, 410 TYPE 02 Action(nOpc := 0,oDlg:End()) OF oDlg ENABLE

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para validação e cadastro                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MCSVAL(aBrowse)
	EndIf

Return

/*/{Protheus.doc} MCSVAL
Valida e executa o processo de gravaçao dos perfis
@type function
@version  
@author MCS Tecnologia
@since 4/25/2026
@param aRegistros, array, param_description
@return variant, return_description
/*/
Static Function MCSVAL(aRegistros)

    Local aArea 
    Local nNext := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se é produto ou participante                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aRegistros[1]) > 4
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se for 1 é cliente, senão é fornecedor                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If aRegistros[1,6] == "1"
            aArea := SA1->(GetArea())
            SA1->(DbSelectArea("SA1"))
            SA1->(dbSetOrder(1))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Efetua o laço para integação                                        ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            For nNext := 1 To Len(aRegistros)
                If SA1->(dbSeek(xFilial("SA1")+aRegistros[nNext,2]+aRegistros[nNext,3]))
                U_fInsertPer("","","","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS,"2")
                EndIf

            Next nNext
        Else
            aArea := SA2->(GetArea())
            SA2->(DbSelectArea("SA2"))
            SA2->(dbSetOrder(1))
                        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Efetua o laço para integação                                        ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            For nNext := 1 To Len(aRegistros)
                If SA2->(dbSeek(xFilial("SA2")+aRegistros[nNext,2]+aRegistros[nNext,3]))
                    U_fInsertPer("","","","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,,SA2->A2_TIPO,SA2->A2_CONTRIB,SA2->A2_EST,SA2->A2_COD_MUN,"",SA2->A2_SIMPNAC,SA2->A2_PAIS,"1")
                EndIf
            Next nNext
        EndIf
    Else 
        aArea := SB1->(GetArea())
        SB1->(DbSelectArea("SB1"))
        SB1->(dbSetOrder(1))
    EndIf



Return
