#Include 'Protheus.CH'

/*/{Protheus.doc} MCSTRIBR
Emite relatório com participantes ou produtos fora de perfis
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@return variant, return_description
/*/
User Function MCSTRIBR()


Return


/*/{Protheus.doc} Params
Monta dela de parâmetros
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@param xNomPer, variant, param_description
@return variant, return_description
/*/
Static Function Params(xNomPer)

    Local aParams  := {}
    Local aRet     := {}
    Local aRetPar  := {}

    aadd(aParams, { 2, "Qual perfil?"      , 2 , {"Cliente", "Fornecedor","Produto"}           , 100, ".T.", .T.})

    If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,xNomPer,.T.,.T.)
        aRetPar := AjRetPar(aRet,aParams)
    Endif

Return(aClone(aRetPar))
