#Include 'Protheus.CH'

/*/{Protheus.doc} GRVCMP
Grava o registro na tabela complementar
@type function
@version  
@author MCS Tecnologia
@since 01/2/2026
@param cFilAnt, character, param_description
@param cDoc, character, param_description
@param cSerie, character, param_description
@param cEntSai, character, param_description
@return variant, return_description
/*/
User Function GRVCMP(cFilAnt, cDoc, cSerie, cEntSai, xEsp)

    Local xQuery    := ""
    Local xAlias    := GetNextAlias()
    Local aAreaC6   := SC6->(GetArea())
    Local aArea     := GetArea()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Abrindo a tabela e setando os indices                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SC6->(dbSelectArea("SC6"))
    SC6->(dbSetOrder(1))
    F0A->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Query para busca dos registro                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xQuery := "SELECT D2_FILIAL, D2_ITEM, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_PEDIDO, D2_ITEMPV, D2_EMISSAO, D2_COD "
	xQuery += "FROM "+ RetSqlName("SD2") +" SD2 "
    xQuery += "WHERE D2_FILIAL = '"+ xFilial("SD2") +"' "
	xQuery += "AND D2_DOC = '"+ cDoc +"' "
	xQuery += "AND D2_SERIE = '"+ cSerie +"' "
	xQuery += "AND SD2.D_E_L_E_T_ = ' ' "

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

    While (xAlias)->(!Eof())

        Begin Transaction
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Posiciona na SC6 para buscar o C6_XOP                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC6->(MsSeek(xFilial("SC6")+(xAlias)->D2_PEDIDO+(xAlias)->D2_ITEMPV+(xAlias)->D2_COD))

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se já existe o registro na tabela de rastreio             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !F0A->(MsSeek(xFilial("F0A")+cEntSai+(xAlias)->D2_SERIE+(xAlias)->D2_DOC))
            RecLock("F0A", .T.)
                F0A->F0A_FILIAL	    := (xAlias)->D2_FILIAL
                F0A->F0A_ITEM	    := (xAlias)->D2_ITEM
                F0A->F0A_TPMOV	    := cEntSai
                F0A->F0A_DOC		:= (xAlias)->D2_DOC
                F0A->F0A_SERIE	    := (xAlias)->D2_SERIE
                F0A->F0A_CLIFOR	    := (xAlias)->D2_CLIENTE
                F0A->F0A_LOJA	    := (xAlias)->D2_LOJA
                F0A->F0A_COD		:= (xAlias)->D2_COD
                F0A->F0A_LOTE       := SC6->C6_XOP
                F0A->F0A_QTDLOT     := SC6->C6_QTDVEN
            F0A->(MsUnlock())
        Else
            RecLock("F0A", .F.)
                F0A->F0A_ITEM	    := (xAlias)->D2_ITEM
                F0A->F0A_COD		:= (xAlias)->D2_COD
                F0A->F0A_LOTE       := SC6->C6_XOP
                F0A->F0A_QTDLOT     := SC6->C6_QTDVEN
            F0A->(MsUnlock())
        EndIf

        End Transaction
        
        (xAlias)->(dbSkip())
    EndDo 

    (xAlias)->(dbCloseArea())

    RestArea(aAreaC6)
    RestArea(aArea)

Return
