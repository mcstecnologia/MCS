#Include 'Protheus.CH'
/*/{Protheus.doc} CONCI003
Rotina que efetua a conciliação dos dados da SF2 x SD2 x SAT e ANFE
@type function
@version  
@author Daiane Leandro
@since 12/18/2024
@return variant, return_description
/*/
User Function CONCI003()

    Local cPerg       := "CONCI003"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Chama a Tela com as Perguntas                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aPar := Params(cPerg)
    If Len(aPar) > 0

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Efetua a Montagem do  Browse                                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        FwMsgRun(,{ |oSay| fConc003(oSay,aPar)}, "Aguarde, Reunindo dados das tabelas fiscais..")
    Endif

Return

/*/{Protheus.doc} fConc003
Função principal para conciliar os dados do Protheus com planilhas do SAT e Anfe
@type function
@version  
@author Daiane Leandro
@since 12/18/2024
@return variant, return_description
/*/
Static Function fConc003(aParam)


    //Busco os dados do Protheus para iniciar a conciliação
    xAlias := fGetQuery()

    While (xAlias)->(Eof())




    EndDo


Return

/*/{Protheus.doc} fConc003
Busca os dados da D2 e F2
@type function
@version  
@author Rodrigo
@since 12/18/2024
@param aParan, array, param_description
@return variant, return_description
/*/
Static Function fGetQuery()

    Local xAlias := GetNextAlias()
    Local xQuery := ""

    xQuery := " SELECT "
    xQuery += "	F2.F2_DTDIGIT,"
    xQuery += "	F2.F2_ESPECIE,"
    xQuery += "	F2.F2_EST,"
    xQuery += "	F2.F2_DOC,"
    xQuery += "	F2.F2_SERIE,"
    xQuery += "	F2.F2_EMISSAO,"
    xQuery += "	D2.D2_TES,"
    xQuery += "	D2.D2_CF,"
    xQuery += "	D2.D2_CONTA,"
    xQuery += "	F2.F2_CLIENTE,"
    xQuery += "	D2.D2_TOTAL,"
    xQuery += "	D2.D2_PICM,"
    xQuery += "	D2.D2_VALICM,"
    xQuery += "	D2.D2_VALIPI,"
    xQuery += "	D2.D2_ICMSCOM,"
    xQuery += "	D2.D2_VALISS,"
    xQuery += "	D2.D2_VALIRRF,"
    xQuery += "	D2.D2_VALPIS,"
    xQuery += "	D2.D2_VALCOF,"
    xQuery += "	D2.D2_VALINS,"
    xQuery += "	D2.D2_DESCON,"
    xQuery += "	D2.D2_VALFRE,"
    xQuery += "	D2.D2_PEDIDO,"
    xQuery += "	D2.D2_LOCAL,"
    xQuery += "	F2.F2_CHV,"
    xQuery += " FROM SF2990 F2"
    xQuery += " INNER JOIN SD2990 D2"
    xQuery += " ON F2.F2_FILIAL = D2.D2_FILIAL"
    xQuery += " AND F2.F2_DOC = D2.D2_DOC"
    xQuery += " AND F2.F2_SERIE = D2.D2_SERIE"
    xQuery += " AND F2.F2_CLIENTE = D2.D2_CLIENTE"
    xQuery += " AND F2.F2_LOJA = D2.D2_LOJA"
    xQuery += " AND F2.F2_EMISSAO BETWEEN '" + dTos(aPar[1]) + "' AND '" + dTos(aPar[2]) + '""
    xQuery += " AND F2.D_E_L_E_T_ =  ' '"
    xQuery += " AND D2.D_E_L_E_T_ = ' '"

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

Return xAlias

/*/{Protheus.doc} Params
Monta os parâmetros
@type function
@version  
@author Rodrigo
@since 12/18/2024
@param xNomPer, variant, param_description
@return variant, return_description
/*/
Static Function Params(xNomPer)

    Local aParams  := {}
    Local aRet     := {}
    Local aRetPar  := {}

    aadd(aParams, { 1, "Data de"           , Ctod(Space(08))              , "@!"                , '.T.','   '   , '.T.', 50, .F. })
    aadd(aParams, { 1, "Data até "         , Ctod(Space(08))              , "@!"                , '.T.','   '   , '.T.', 50, .F. })


    If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,xNomPer,.T.,.T.)
        aRetPar := AjRetPar(aRet,aParams)
    Endif

Return(aClone(aRetPar))
