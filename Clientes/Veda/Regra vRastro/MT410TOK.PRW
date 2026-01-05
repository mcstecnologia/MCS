#Include 'Protheus.CH'

/*/{Protheus.doc} MT410TOK
description
@type function
@version  
@author MCS Tecnologia
@since 1/2/2026
@param nOpc, numeric, param_description
@return variant, return_description
/*/
User Function MT410TOK(nOpc)

    Local lRet      := .T. // Conteúdo de retorno
    Local nNext     := 0
    Local lAtv      := SuperGetMV("VD_ATVRAST",.F.,.T.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se for exclusão não valida regra                                           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpc <> 5
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Se a regra estiver ativada e existir o campo, prossegue                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lAtv .And. FieldPos("C6_XOP") > 0
            For nNext := 1 to len(aCols)
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Verifica se a linha não está deletada                                       ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If !aCols[nNext][Len(aHeader)+1]
                    If Empty(GdFieldGet("C6_LOCAL",nNext))
                        Help('',1,"MT410TOK",,"Para o cliente informado, é necessário informar o campo C6_XOP para geração da tag vRastro na nota fiscal",1,0)
                        lRet := .F.
                    EndIf
                EndIf
            Next nNext
        EndIf
    EndIf

Return lRet
