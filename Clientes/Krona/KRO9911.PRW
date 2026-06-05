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

/*/{Protheus.doc} KRO9911
Condição para o gatilho
@type function
@version  
@author MCS Tecnologia
@since 5/25/2026
@return variant, return_description
/*/
User Function KRO9911A()

    Local lRet      := .F.
    Local aAreaF4   := SF4->(GetArea())
    Local aAreaB1   := SB1->(GetArea())
    Local aAreaA2   := SA2->(GetArea())
    Local nPosClasf := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLASFIS"})
    Local nPosCF    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
    Local nPosPIcms := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PICM"})
    Local nNext     := 0

    SA2->(dbSelectArea("SA2"))
    SA2->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Apesar de vir posiconado e com a informação, é para garantir         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SA2->(dbSeek(xFilial("SA2") + CA100FOR + CLOJA,.F.))

    For nNext := 1 to Len(aCols)
        If AllTrim(aCols[nNext][nPosCF]) == '1556' .Or. AllTrim(aCols[nNext][nPosCF]) == '1551' .And. AllTrim(aCols[nNext][nPosClasf]) == '1' .And. SA2->A2_EST == 'SC';
            .Or. aCols[nNext][nPosPIcms] == 4
            lRet := .T.
        EndIf
    Next nNext

    FwRestArea(aAreaF4)
    FwRestArea(aAreaB1)
    FwRestArea(aAreaA2)

Return (lRet)

/*/{Protheus.doc} KRO9911B
Gatilho para preenchimento em tela do valor do icms complementar e aliquota
@type function
@version  
@author rodri
@since 5/25/2026
@return variant, return_description
/*/
User Function KRO9911B(xTipo)

    Local nRet      := 0
    Local aAreaF1   := SF1->(GetArea())
    Local aAreaF4   := SF4->(GetArea()) 
    Local nPosClasf := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLASFIS"})
    Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
	Local nPosCod   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
    Local nPosBase  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_BASEICM"}) 
    //Local nPosAliq  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ALIQCMP"})
    Local nPosCF    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
    Local nPosIcmCo := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ICMSCOM"})
    Local nPosPIcms := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PICM"})
    Local nNext     := 0
    Local nAliq     := 0
    Local xClasfis  := ""
    Local xCf       := ""

    For nNext := 1 to Len(aCols)
        If !aCols[nNext][Len(aHeader)+1]
            xItem   := aCols[nNext][nPosItem]
            xProd  	:= aCols[nNext][nPosCod]
            xBase   := aCols[nNext][nPosBase]
            xClasFis:= aCols[nNext][nPosClasf]
            //nAliq   := aCols[nNext][nPosAliq]
            xCf     := SubStr(aCols[nNext][nPosCF],1,1)
            If AllTrim(xClasFis) == '1' .Or. aCols[nNext][nPosPIcms] == 4 .And. AllTrim(xCf) $ "1556#1551" 
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Altera o aCols conforme o gatilho feito, gravo duas vezes para garantir ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                If xTipo == "BASE"
                    aCols[nNext][nPosIcmCo] := Round(aCols[nNext][nPosBase] * 0.13,2)
                    //aCols[nNext][nPosAliq] := 13
                /*Else
                    aCols[nNext][nPosIcmCo] := Round(aCols[nNext][nPosBase] * 0.13,2)
                    //aCols[nNext][nPosAliq] := 13*/
                EndIf
            EndIf
        EndIf
    Next nNext


    FwRestArea(aAreaF1)
    FwRestArea(aAreaF4)

Return (nRet)
