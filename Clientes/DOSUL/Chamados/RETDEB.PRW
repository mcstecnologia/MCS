
#Include 'Protheus.CH'

/*/{Protheus.doc} RETDEB
Retorna a conta débito
@type function
@version  
@author MCS Tecnologia
@since 12/24/2025
@return variant, return_description
/*/
User Function RETDEB()

    Local aArea := CT5->(GetArea("CT5"))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Abro a CT5 pois ela não vem posicionada                          ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    CT5->(dbSelectArea("CT5"))
    CT5->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Faço Seek usando a CTK, pois é uma tabela posicioando com a LP usada ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    If CT5->(dbSeek(xFilial("CT5")+CTK->CTK_LP+CTK->CTK_LPSEQ))
        xConta := AllTrim(SubStr(CT5->CT5_DEBITO,1,1))
    EndIf

    RestArea(aArea)

Return xConta

/*/{Protheus.doc} RETCRED
Retorna conta crédito
@type function
@version  
@author MCS Tecnologia
@since 12/24/2025
@return variant, return_description
/*/
User Function RETCRED()

    Local aArea := CT5->(GetArea("CT5"))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Abro a CT5 pois ela não vem posicionada                          ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    CT5->(dbSelectArea("CT5"))
    CT5->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Faço Seek usando a CTK, pois é uma tabela posicioando com a LP usada ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    If CT5->(dbSeek(xFilial("CT5")+CTK->CTK_LP+CTK->CTK_LPSEQ))
        xConta := AllTrim(SubStr(CT5->CT5_CREDITO,1,1))
    EndIf
    
    RestArea(aArea)
 
Return xConta



