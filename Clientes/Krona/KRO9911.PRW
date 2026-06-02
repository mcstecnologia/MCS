#Include 'Protheus.CH'


/*/{Protheus.doc} KRO9911
Query para buscar os itens que devem receber o icms complementar de 13% e efetuar a gravação do valor e da aliquota
@type function
@version  
@author MCS Consultoria
@since 5/25/2026
@param xDoc, variant, param_description
@param xSerie, variant, param_description
@param xFornec, variant, param_description
@param xLoja, variant, param_description
@param xEspe, variant, param_description
@return variant, return_description
/*/
User Function KRO9911()

    Local aArea     := GetArea()
    Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
	Local nPosCod   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
    Local xItem     := ""
    Local xProd     := ""
    Local nInc      := 0
    Local aFil      := {}
    Local aCmp      := { ;
        "M0_CODIGO",;    //Posição [1]
        "M0_CODFIL",;    //Posição [2]
        "M0_NOMECOM",;   //Posição [3]
        "M0_CGC",;       //Posição [4]
        "M0_INSCM",;     //Posição [5]
        "M0_CIDENT",;    //Posição [6]
        "M0_ESTENT",;    //Posição [7]
        "M0_ENDENT",;    //Posição [8]
        "M0_BAIRENT",;   //Posição [9]
        "M0_CEPENT",;    //Posição [10]
        "M0_COMPENT",;   //Posição [11]
        "M0_TEL";        //Posição [12]
    }
    
 
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pego os dados da filial para buscar o estado da filial              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aFil := FWSM0Util():GetSM0Data(, FwCodFil(), aCmp)
 
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Regra de ICMS Complementar apenas para SC P/ SC                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aFil) > 0 .And. aFil[7][2] == 'SC' .And. SF1->F1_EST == 'SC'
        For nInc := 1 to Len(aCols)
            If !aCols[nInc][Len(aHeader)+1]
                xItem   := aCols[nInc][nPosItem]
                xProd  	:= aCols[nInc][nPosCod]
                If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+xProd+xItem))  
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Conforme alinhado, somente para esses CFOP's e aliq icms 4%         ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If AllTrim(SD1->D1_CF) $ "1556#1551" .And. SD1->D1_PICM == 4 
                        SD1->(RecLock("SD1",.F.))
                        SD1->D1_ICMSCOM := ROUND(SD1->D1_BASEICM * 0.13, 2)
                        SD1->D1_ALIQCMP := 13
                        SD1->(MsUnlock("SD1"))
                    EndIf
                EndIf
            EndIf
        Next nInc
    EndIf

    FwRestArea(aArea)

Return
