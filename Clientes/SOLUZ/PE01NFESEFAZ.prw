#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
//https://tdn.totvs.com.br/display/tec/ProtheusDOC
/*{Protheus.doc} PE01NFESEFAZ
Ponto de entrada Responsavel por manipular as informações da nfe.
RGN01: Fazer a pergunta ao usuario se deseja aglu
aIPI aICMS aICMSST aPis aPISST aCOFINSST aISSQN
aICMUFDest aISS      aCOFINS
@author  Gabriel
@since   29/03/2025
@version 1.0
aProd
//18 Controle de Lote
//19 Numero do Lote
23 - Mensagem Cliente

if MV_AgrPrd  //CUSTOMIZAÇÃO PARA AGLUTINAR AS QUANTIDADES
        cInfAdic += " Lote: " + AllTrim((cAliasSD2)->D2_LOTECTL)
        ConOut( "Entrou no primeiro IF")
        //alert( "Entrou no primeiro IF")
    else
        nPosLot	:=	Ascan(aLotes, {|x| alltrim(x[1]) == Alltrim((cAliasSD2)->(D2_COD))})
        if nPosLot == 0
            aadd(aLotes,{Alltrim((cAliasSD2)->(D2_COD)),Alltrim((cAliasSD2)->D2_LOTECTL)})
        else
            if !(Alltrim((cAliasSD2)->D2_LOTECTL) $ aLotes[nPosLot][2])
                aLotes[nPosLot][2]:= aLotes[nPosLot][2]+";"+Alltrim((cAliasSD2)->D2_LOTECTL)
            endif
        endif
    endif
    //FIM CUSTOMIZAÇÃO
EndIf
		if MV_AgrPrd 	//INICIO DA CUSTOMIZAÇÃO
			for _nG := 1 to Len(aLotes)
				cMensCli+= CRLF + "Produto: "+aLotes[_nG][1]+" Lotes: " + aLotes[_nG][2]
			next
		endif
        		if MV_AgrPrd 	//INICIO DA CUSTOMIZAÇÃO
			for _nG := 1 to Len(aLotes)
				cMensCli+= CRLF + "Produto: "+aLotes[_nG][1]+" Lotes: " + aLotes[_nG][2]
			next
		endif


        	//WALTER - TSC022 - 29/04/2016
						//CUSTOMIZADO Preenchimento da TAG <infAdProd> conforme necessidade da Nycolplast
						cInfAdic := ""
						SC6->(dbSetOrder(2))
						If SC6->(MsSeek(xFilial("SD2")+(cAliasSD2)->(D2_COD+D2_PEDIDO+D2_ITEMPV)))
							If !Empty(SC6->C6_NUMPCOM)
								cInfAdic := "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)
							EndIf
							If !Empty(SC6->C6_ITEMPC)
								cInfAdic += " Seq: "+AllTrim(SC6->C6_ITEMPC)
							EndIf
						EndIf
*/
//-------------------------------------------------------------------
user function PE01NFESEFAZ()


    Local aProd      := PARAMIXB[1]
    Local cMensCli   := PARAMIXB[2]
    Local cMensFis   := PARAMIXB[3]
    Local aDest      := PARAMIXB[4]
    Local aNota      := PARAMIXB[5]
    Local aInfoItem  := PARAMIXB[6]
    Local aDupl      := PARAMIXB[7]
    Local aTransp    := PARAMIXB[8]
    Local aEntrega   := PARAMIXB[9]
    Local aRetirada  := PARAMIXB[10]
    Local aVeiculo   := PARAMIXB[11]
    Local aReboque   := PARAMIXB[12]
    Local aNfVincRur := PARAMIXB[13]
    Local aEspVol    := PARAMIXB[14]
    Local aNfVinc    := PARAMIXB[15]
    Local AdetPag    := PARAMIXB[16]
    Local aObsCont   := PARAMIXB[17]
    Local aProcRef   := PARAMIXB[18]
    Local aMed       := PARAMIXB[19]
    Local aLote      := PARAMIXB[20]
    Local aIPI       := PARAMIXB[21]
    Local aICMS      := PARAMIXB[22]
    Local aICMSST    := PARAMIXB[23]
    Local aPis       := PARAMIXB[24]
    Local aPISST     := PARAMIXB[25]
    Local aCOFINSST  := PARAMIXB[26]
    Local aISSQN     := PARAMIXB[27]
    Local aICMUFDest := PARAMIXB[28]
    Local aISS       := PARAMIXB[29]
    Local aCOFINS    := PARAMIXB[30]

    Local aRetorno  := {}
    // Local cMsg      := " "
    Local MV_AgrPrd		:= SuperGetMV("MV_AgrPrd",  ,"F")  //PARAMETRO PARA AGLUTINAR POR LOTE CUSTOMIZADO
    Local aLotes := {}           //VARIAVEL CUSTOMIZADA PARA AGLUTINAR QUANTIDADES
    Local n1 := 0
    Local _nG := 0
    Local nPosLT := 0
    Local aArea := GetArea()
    IF FWAlertYesNo( "Deseja aglutinar quantidades ?", "Aglutina" )

        MV_AgrPrd := .T.

    Else

        MV_AgrPrd := .F.
    Endif
    if MV_AgrPrd
        /*Declaração de Variaveis para uso e controle*/
        aProdNew    := {}
        aProdOld    := aProd
        aIPINew     := {}
        aIPIOld     := aIPI
        aICMSNew    := {}
        aICMSSTN    := {}
        aPisN       := {} //aPis
        aPISSTN     := {} //aPISST
        aCOFINSSTN  := {} //aCOFINSST
        aISSQNN     := {} //aISSQN
        aICMUFDstN  := {} //aICMUFDest
        aISSN       := {} //aISS
        aCOFINSN    := {} //aCOFINS


        aICMSOld   := aICMS
        aICMSSTOld := aICMSST
        aPisOld    :=   aPis
        aPISSTOld  :=   aPISST
        aCOFINSSTO :=   aCOFINSST
        aISSQNOld  :=   aISSQN
        aICMUFDstO :=   aICMUFDest
        aISSOld    :=   aISS
        aCOFINSOld :=   aCOFINS

        For  n1 := 1 to Len(aProd)

            /*********************************************\
            | Quando é a primeira posição não faz a busca |
            \*********************************************/
            if n1==1

                nPos := 1
                aadd(aProdNew,{})
                aadd(aIPINew,{})
                aadd(aPisN,{})
                aadd(aPISSTN,{})
                aadd(aCOFINSSTN,{})
                aadd(aISSQNN,{})
                aadd(aICMUFDstN,{})
                aadd(aISSN,{})
                aadd(aCOFINSN,{})
                aadd(aICMSNew,{})
                aadd(aICMSSTN,{})
                aProdNew[nPos] := (AClone(aProd[n1]))
                aadd(aLotes,{aProd[n1][2],alltrim(aProd[n1][19])})
                if  !(alltrim(aProd[n1][19]) $aProdNew[nPos][25] )
                    aProdNew[nPos][25] += " Lote: "+ alltrim(aProd[n1][19])+CRLF
                endif
                aProdNew[nPos][19] := ""
                DBSelectArea("SC6")
                SC6->(dbSetOrder(2))

                If SC6->(MsSeek(xFilial("SD2")+aProd[n1][2]+aProd[n1][38]+aProd[n1][39]   ))
                    If !Empty(SC6->C6_NUMPCOM) .and. !Empty(SC6->C6_ITEMPC)
                        if !(("Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)+ " Seq: "+AllTrim(SC6->C6_ITEMPC))$  aProdNew[nPos][25])
                            if !Empty(  aProdNew[nPos][25])

                                aProdNew[nPos][25]+= CRLF

                            EndIf
                            aProdNew[nPos][25] +=  "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)+ " Seq: "+AllTrim(SC6->C6_ITEMPC)+" "

                        EndIf
                    Elseif !Empty(SC6->C6_NUMPCOM) .and. !Empty(SC6->C6_ITEMPC)
                        if !Empty(  aProdNew[nPos][25])

                            aProdNew[nPos][25]+= CRLF

                        EndIf
                        aProdNew[nPos][25] +=  "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)

                    ElseIf !Empty(SC6->C6_ITEMPC) .and.Empty(SC6->C6_NUMPCOM)
                        aProdNew[nPos][25] += " Seq: "+AllTrim(SC6->C6_ITEMPC)

                        //  EndIf
                    EndIf


                    // If !Empty(SC6->C6_NUMPCOM)
                    //     aProdNew[nPos][25] +=  " Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)
                    // EndIf
                    // If !Empty(SC6->C6_ITEMPC)
                    //     aProdNew[nPos][25] += " Seq: "+AllTrim(SC6->C6_ITEMPC)
                    // EndIf
                EndIf
                /**************************\
                | Tratativa demais Arrays  |
                \**************************/
                aIPINew   [nPos] := (AClone(aIPI[n1]))
                aPisN     [nPos] := (AClone(aPis[n1]))
                aPISSTN   [nPos] := (AClone(aPISST[n1]))
                aCOFINSSTN[nPos] := (AClone(aCOFINSST[n1]))
                aISSQNN   [nPos] := (AClone(aISSQN[n1]))
                if len(aICMUFDstN)> 0
                    aICMUFDstN[nPos] := (AClone(aICMUFDest[n1]))
                endif
                if len(aISS)> 0
                    aISSN     [nPos] := (AClone(aISS[n1]))
                endif
                aCOFINSN  [nPos] := (AClone(aCOFINS[n1]))
                aICMSNew  [nPos] := (AClone(aICMS[n1]))
                aICMSSTN  [nPos] := (AClone(aICMSST[n1]))
                loop
            endif

            //, [ nStart ], [ nCount ]
            //nPosField := AScan(aVector[1], {|x| AllTrim(x[1]) == "W2_COND_PA"})
            //Busca o produto da Posição 1 ate a posição anterior atual
            cCodProd := aProd[n1][2]
            nPos :=Ascan(aProdNew, {|x| alltrim(x[2]) == alltrim(cCodProd)},1,n1-1)
            if nPos >0
                /*Valores*/
                aProdNew[nPos][9] += aProd[n1][9]
                aProdNew[nPos][10]+= aProd[n1][10]
                aProdNew[nPos][12]+= aProd[n1][12]
                aProdNew[nPos][13]+= aProd[n1][13]
                aProdNew[nPos][14]+= aProd[n1][14]
                aProdNew[nPos][15]+= aProd[n1][15]
                aProdNew[nPos][30]+= aProd[n1][30]
                aProdNew[nPos][33]+= aProd[n1][33]
                aProdNew[nPos][35]+= aProd[n1][35]
                aProdNew[nPos][36]+= aProd[n1][36]
                aProdNew[nPos][37]+= aProd[n1][37]


                /*texto*/
                /*Numero do Lote*/
                //18 Controle de Lote
                //19 Numero do Lote
                // 23 - Mensagem Cliente
                //   (cAliasSD2)->D2_PEDIDO,;	 //aProd[38]
                //       (cAliasSD2)->D2_ITEMPV,;	 //aProd[39]
                DBSelectArea("SC6")
                SC6->(dbSetOrder(2))

                If SC6->(MsSeek(xFilial("SD2")+aProd[n1][2]+aProd[n1][38]+aProd[n1][39]   ))

                    If !Empty(SC6->C6_NUMPCOM) .and. !Empty(SC6->C6_ITEMPC)
                        if !(("Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)+ " Seq: "+AllTrim(SC6->C6_ITEMPC))$  aProdNew[nPos][25])
                            if !Empty(  aProdNew[nPos][25])

                                aProdNew[nPos][25]+= CRLF

                            EndIf
                            aProdNew[nPos][25] +=  "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)+ " Seq: "+AllTrim(SC6->C6_ITEMPC)

                        EndIf
                    Elseif !Empty(SC6->C6_NUMPCOM) .and. !Empty(SC6->C6_ITEMPC)
                        if !Empty(  aProdNew[nPos][25])

                            aProdNew[nPos][25]+= CRLF

                        EndIf
                        aProdNew[nPos][25] +=  "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)

                    ElseIf !Empty(SC6->C6_ITEMPC) .and.Empty(SC6->C6_NUMPCOM)

                        aProdNew[nPos][25] += " Seq: "+AllTrim(SC6->C6_ITEMPC)

                    EndIf


                EndIf


                aProdNew[nPos][19]:=""
                //  aadd(aLotes,{aProd[n1][2],alltrim(aProd[n1][19])})
                /**************************\
                | Tratativa demais Arrays  |
                \**************************/
                if len(aIPI[n1])>0
                    aIPINew[nPos][6] +=  aIPI[n1][6]
                    aIPINew[nPos][7] +=  aIPI[n1][7]
                    aIPINew[nPos][10]+=  aIPI[n1][10]
                endif
                if len(aPIS[n1])>0
                    aPISN[nPos][2] += aPIS[n1][2]
                    aPISN[nPos][4] += aPIS[n1][4]
                    aPISN[nPos][5] += aPIS[n1][5]
                endif
                if len(aICMSST[n1])>0
                    aICMSSTN[nPos][5] := aICMSST[n1][5]
                    aICMSSTN[nPos][7] := aICMSST[n1][7]
                    aICMSSTN[nPos][9] := aICMSST[n1][9]
                endif
                if len(aICMS[n1])>0
                    aICMSNew[nPos][5] += aICMS[n1][5]
                    aICMSNew[nPos][7] += aICMS[n1][7]
                    aICMSNew[nPos][9] += aICMS[n1][9]
                endif
                if len(aPISST[n1])>0
                    aPISSTn[nPos][2] += aPISST[n1][2]
                    aPISSTn[nPos][4] += aPISST[n1][4]
                    aPISSTn[nPos][5] += aPISST[n1][5]
                endif
                if len(aCOFINSST[n1])>0
                    aCOFINSSTN[nPos][2] += aCOFINSST[n1][2]
                    aCOFINSSTN[nPos][4] += aCOFINSST[n1][4]
                    aCOFINSSTN[nPos][5] += aCOFINSST[n1][5]
                endif
                if len(aISSQN[n1])>0
                    aISSQNN[nPos][1]    += aISSQN[n1][1]
                    aISSQNN[nPos][3]    += aISSQN[n1][3]
                endif
                if len(aICMUFDest[n1])> 0
                    aICMUFDstN[nPos][1] += aICMUFDest[n1][1]
                    aICMUFDstN[nPos][8] += aICMUFDest[n1][8]
                endif
                if len(aISS)> 0
                    if len(aISS[n1])> 0
                        aISSN[nPos]         +=aISS[n1]
                        aISSN[nPos]         +=aISS[n1]
                        aISSN[nPos]         +=aISS[n1]
                    endif
                endif
                if len(aCOFINS[n1])> 0
                    aCOFINSN[nPos][2]    += aCOFINS[n1][2]
                    aCOFINSN[nPos][4]    += aCOFINS[n1][4]
                    aCOFINSN[nPos][5]    += aCOFINS[n1][5]
                endif

            else

                aadd(aProdNew,{})
                aadd(aIPINew,{})
                aadd(aICMSNew,{})
                aadd(aICMSSTN,{})
                aadd(aPisN,{})
                aadd(aPISSTN,{})
                aadd(aCOFINSSTN,{})
                aadd(aISSQNN,{})
                aadd(aICMUFDstN,{})
                aadd(aISSN,{})
                aadd(aCOFINSN,{})


                nPos := len(aProdNew)

                aProdNew[nPos] := (AClone(aProd[n1]))
                aadd(aLotes,{aProd[n1][2],alltrim(aProd[n1][19])})
                aProdNew[nPos][25] +="Lote: "+ alltrim(aProd[n1][19])
                aProdNew[nPos][19] := ""
                DBSelectArea("SC6")
                SC6->(dbSetOrder(2))

                If SC6->(MsSeek(xFilial("SD2")+aProd[n1][2]+aProd[n1][38]+aProd[n1][39]   ))
                    If !Empty(SC6->C6_NUMPCOM)
                        if !Empty(  aProdNew[nPos][25])

                            aProdNew[nPos][25]+= CRLF

                        EndIf
                        aProdNew[nPos][25] +=  "Pedido Cliente: "+AllTrim(SC6->C6_NUMPCOM)
                    EndIf
                    If !Empty(SC6->C6_ITEMPC)
                        aProdNew[nPos][25] += " Seq: "+AllTrim(SC6->C6_ITEMPC)
                    EndIf
                EndIf
                /**************************\
                | Tratativa demais Arrays  |
                \**************************/
                aIPINew [nPos]   := (AClone(aIPI[n1]))
                aICMSNew[nPos]   := (AClone(aICMS[n1]))
                aICMSSTN[nPos]   := (AClone(aICMSST[n1]))
                aPISN[nPos]      := (AClone(aPIS[n1]))
                aPISSTn[nPos]    := (AClone(aPISST[n1]))
                aCOFINSSTN[nPos] := (AClone(aCOFINSST[n1]))
                aISSQNN[nPos]    := (AClone(aISSQN[n1]))
                aICMUFDstN[nPos] := (AClone(aICMUFDest[n1]))
                if len(aISS)> 0
                    aISSN[nPos]      := (AClone(aISS[n1]))
                endif
                aCOFINSN[nPos]   := (AClone(aCOFINS[n1]))


            endif

        Next n1
        aProd      := AClone(aProdNew)
        aIPI       := AClone(aIPINew)
        aICMS      := AClone(aICMSNew)
        aICMSST    := AClone(aICMSSTN)
        aPIS       := AClone(aPISN)
        aPISST     := AClone(aPISSTn)
        aCOFINSST  := AClone(aCOFINSSTN)
        aISSQN     := AClone(aISSQNN)
        aICMUFDest := AClone(aICMUFDstN)
        if len(aISS)> 0
            aISS       := AClone(aISSN)
        endif
        aCOFINS    := AClone(aCOFINSN)
    else

        // For  n1 := 1 to Len(aProd)
        //     aadd(aLotes,{aProd[n1][2],alltrim(aProd[n1][19])})
        // Next n1
        //  for _nG := 1 to Len(aLotes)
        //      if !(( "Produto: "+aLotes[_nG][1]+" Lotes: " + aLotes[_nG][2]) $cMensCli)
        //          cMensCli+=   "Produto: "+aLotes[_nG][1]+" Lote: " + aLotes[_nG][2]+CRLF
        //      endif
        //  next _nG
    Endif

    //for _nG := 1 to Len(aLotes)
    //    if !(( "Produto: "+aLotes[_nG][1]+" Lotes: " + aLotes[_nG][2]) $cMensCli)
    //        cMensCli+=   "Produto: "+aLotes[_nG][1]+" Lotes: " + aLotes[_nG][2]+CRLF
    //    endif
    //next _nG

    aadd(aRetorno,aProd)
    aadd(aRetorno,cMensCli)
    aadd(aRetorno,cMensFis)
    aadd(aRetorno,aDest)
    aadd(aRetorno,aNota)
    aadd(aRetorno,aInfoItem)
    aadd(aRetorno,aDupl)
    aadd(aRetorno,aTransp)
    aadd(aRetorno,aEntrega)
    aadd(aRetorno,aRetirada)
    aadd(aRetorno,aVeiculo)
    aadd(aRetorno,aReboque)
    aadd(aRetorno,aNfVincRur)
    aadd(aRetorno,aEspVol)
    aadd(aRetorno,aNfVinc)
    aadd(aRetorno, AdetPag    )
    aadd(aRetorno, aObsCont )
    aadd(aRetorno, aProcRef )
    aadd(aRetorno, aMed )
    aadd(aRetorno, aLote )
    aadd(aRetorno, aIPI )
    aadd(aRetorno, aICMS )
    aadd(aRetorno, aICMSST )
    aadd(aRetorno, aPis )
    aadd(aRetorno, aPISST )
    aadd(aRetorno, aCOFINSST )
    aadd(aRetorno, aISSQN )
    aadd(aRetorno, aICMUFDest )
    aadd(aRetorno, aISS )
    aadd(aRetorno, aCOFINS )

    //// Ajuste na aDetPag
    //AdetPag  := {}

    //aadd(aDetPag,;
    //    {"14",;// Forma de pagamento
    //    470.00,;// Valor do Pagamento
    //    0.00})//Troco
    //aadd(aDetPag,;

    //{"03",; // Forma de pagamento
    //    550.00,; // Valor do Pagamento
    //    20.00,; //Troco
    //    "1",; // Tipo de Integração para pagamento //Opcional se levar deverá preencher os itens abaixo com valor ou "".
    //    "32331472001195",; //CNPJ da Credenciadora de cartão de crédito e/ou débito // Opcional
    //    "01",; //Bandeira da operadora de cartão de crédito e/ou débito //opcional
    //    "123456"}) //Número de autorização da operação cartão de crédito e/ou débito //opcional

    //aadd(aRetorno,aDetPag)
    restarea(aArea)
RETURN aRetorno
