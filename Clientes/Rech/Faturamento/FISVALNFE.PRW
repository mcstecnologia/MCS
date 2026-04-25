#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FISVALNFบAutor ณLuis Henrique Robustoบ Data ณ  22/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PONTO DE ENTRADA: Valida a transmissao da nota fiscal      บฑฑ
ฑฑบ          ณ Se o retorno for falso nao deixa transmitir a Nf-e         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SPEDNFE - Transmissao de Nota Fiscal Eletronica            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ PARAMIXB	(Array of Record)                                 บฑฑ
ฑฑบ          ณ [1] - cTipo-tipo da Nota(E-Entrada/S- Saida)               บฑฑ
ฑฑบ          ณ [2] - Filial                                               บฑฑ
ฑฑบ          ณ [3] - Emissใo                                              บฑฑ
ฑฑบ          ณ [4] - Numero da NF                                         บฑฑ
ฑฑบ          ณ [5] - Serie                                                บฑฑ
ฑฑบ          ณ [6] - Cliente/Fornecedor                                   บฑฑ
ฑฑบ          ณ [7] - Loja                                                 บฑฑ
ฑฑบ          ณ [8] - Especie                                              บฑฑ
ฑฑบ          ณ [9] - Formulario                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FISVALNF()

    Local 	cTipo		:= PARAMIXB[1]
    Local 	cFil		:= PARAMIXB[2]
    Local 	cEmissao	:= PARAMIXB[3]
    Local 	cNota		:= PARAMIXB[4]
    Local 	cSerie		:= PARAMIXB[5]
    Local 	cClieFor	:= PARAMIXB[6]
    Local 	cLoja		:= PARAMIXB[7]
    Local 	cEspec		:= PARAMIXB[8]
    Local 	cFormul		:= PARAMIXB[9]
    Local 	_aAreaSd2	:= {}
    Local	_aAreaCd9	:= {}
    Local	_cVeicNovo	:= GetNewPar("MV_VEICNV","")   
    Local	_cQryCD9	:= ' '
    Local 	lTran		:= .T.
    Local	_lUserPerm	:= U_RtCheckE("EV_ALT_FAT_TRANS_NF_DT_RETROAT",.f.)
    Local	cUFObrgPeso := SuperGetMV("MV_UFPESO",,"RO/SC/GO")//"RO/SC/GO" // Estados emitindo nota fiscal ou recebendo emiss๕es de notas de outras empresas no SIGAMAT.
    Local	aDocUfPes	:= xGetUfPesDoc(cTipo,cFil,cNota,cSerie,cClieFor,cLoja)
    Local 	lDocAtiv	:= xGetImob(cTipo,cFil,cNota,cSerie,cClieFor,cLoja)
    Local   lDocDebCrd  := (Alltrim(cSerie) == Alltrim(SuperGetMv("RT_SERDEB",.f.,'9')))

    //Solicita็ใo de Juliano e Fabiana.
    //Nใo permite transmitir caso o m๊s de emissใo nใo seja o m๊s atual.
    If	( Month(cEmissao) <> Month(Date()) .or. Year(cEmissao) <> Year(Date()) ) .and. !_lUserPerm
        MsgStop("Data de emissใo diferente do m๊s atual. D๚vidas falar com o setor Contแbil ou Controladoria.")
        Return .F.
    EndIf

    // Valida somente em notas fiscais de saida.
    If	AllTrim(cTipo) == "S" .and. !Empty(_cVeicNovo)

        // Salva a area anterior do SD2 pois ira reposiciona-la.
        _aAreaSd2 := SD2->(GetArea())
        _aAreaCd9 := CD9->(GetArea())

        // Posiciona na tabela complementar de NF-e sobre veiculos novos
        DbSelectArea("CD9")
        CD9->(DbSetOrder(1)) //CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD

        // Posiciona no SD2 e verifica registro por registro (item a item)
        DbSelectArea("SD2")	
        SD2->(DbSetOrder(3))
        SD2->(Dbseek(cFil+cNota+cSerie+cClieFor+cLoja))
        While	SD2->( ! Eof()) .and. ( SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFil+cNota+cSerie+cClieFor+cLoja )
            
            // Se o item for do grupo de veiculos novos (parametro padrao)
            If	( AllTrim(SD2->D2_GRUPO) $ _cVeicNovo )   

                _cQryCD9 := " SELECT COUNT(*) NREG "
                _cQryCD9 += " FROM "+ RetSqlName("CD9")
                _cQryCD9 += " WHERE CD9_FILIAL = '"+SD2->D2_FILIAL+"'  "
                _cQryCD9 += " AND CD9_TPMOV = 'S' "
                _cQryCD9 += " AND CD9_SERIE	= '"+SD2->D2_SERIE+"' "
                _cQryCD9 += " AND CD9_DOC = '"+SD2->D2_DOC+"'  "
                _cQryCD9 += " AND CD9_CLIFOR = '"+SD2->D2_CLIENTE+"' "
                _cQryCD9 += " AND CD9_LOJA = '"+SD2->D2_LOJA+"'  "
                _cQryCD9 += " AND CD9_ITEM = '"+SD2->D2_ITEM+"'  "
                _cQryCD9 += " AND CD9_COD = '"+SD2->D2_COD+"'  "
                DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryCD9),"TRA",.F.,.T.)
                If	TRA->(Eof()) .or. TRA->NREG == 0
                    // Desabilitado temporariamente em funcao do modulo veiculos levar os dados
                    // lTran := .F.
                    /*If	!U_RtIsEmpFil({{"03"}})
                        lTran := .F.
                    EndIf*/
                EndIf
                TRA->(DbCloseArea())
            EndIf
            If	! lTran
                MsgAlert(OemToAnsi("Esta nota fiscal nใo poderแ ser TRANSMITIDA sem informar os dados complementares do Equipamento. Item: "+SD2->D2_ITEM))
                Exit
            EndIf

            SD2->(DbSkip())

        End

        // Restaura a area anterior do processamento.
        RestArea(_aAreaSd2)
        RestArea(_aAreaCd9)

    EndIf
    
    // Faz a validacao obrigatoria do PESO
    If !lDocAtiv .and. !lDocDebCrd // Nใo valida para notas de Ativo ou notas de D้bito/Cr้dito

        // aDocUfPes[1] => .t. se for para validar, em notas que nao devem validar, colocar .F., nem entra nas checagens (mesma cidade, outros tipos de documentos, etc)
        // aDocUfPes[2] => UF do cliente ou fornecedor, para checagem dos Estados/UF obrigat๓rios.
        // aDocUfPes[3] => Peso preenchido no documento fiscal. 
        If	( Len(aDocUfPes) > 0 ) .and. AllTrim(cTipo) == "S"
            If	( aDocUfPes[1] ) // Verifica se deve validar o peso
                If	( SuperGetMv("MV_ESTADO") $ cUFObrgPeso .or. aDocUfPes[2] $ cUFObrgPeso )
                    // Verifica o peso total da nota fiscal para validar e obrigar informar o peso antes da transmissใo do documento fiscal.
                    If	( aDocUfPes[3] = 0 )
                        MsgAlert(OemToAnsi("Existe(m) Nota(s) Fiscal(is) sem PESO informado e nใo poderแ ser transmitida sem o preenchimento deste campo, bem como os demais dados de transporte. Documento: "+cNota))
                        lTran := .f.
                    EndIf
                Else // Locais que nao sใo obrigatorios.
                    If	( aDocUfPes[3] = 0 )
                        If	MsgYesNo(OemToAnsi("A Nota fiscal: "+cNota+", estแ sem PESO preenchido, bem como os demais dados de transporte, ้ recomendแvel sempre PREENCHER os campos ADICIONAIS: Transportadora, Peso, Volumes, etc. Deseja voltar e preencher ?"))
                            lTran := .f.
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

Return lTran

Static Function xGetUfPesDoc(cTipo,cFil,cNota,cSerie,cClieFor,cLoja)
Local	cQryDoc 	:= ""
Local	aRetDet		:= {.F.,Space(2),0} //1=.t. se valida, 2=UF, 3=Peso Documento

    // Monta query para verificar UF, PESO e demais dados
    If	( cTipo = "S" ) // Saida
        cQryDoc := " SELECT F2_COND COND_PAG, F2_TIPO TIPODOC, F2_EST ESTADO, F2_PLIQUI PESO_LIQ, F2_PBRUTO PESO_BRU, F4_CODIGO TES, F4_OPEMOV OPERACAO "
        cQryDoc += " FROM " + RetSqlName("SF2") + " SF2 "
        cQryDoc += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON ( SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D_E_L_E_T_ = ' ' ) "
        cQryDoc += " LEFT JOIN " + RetSqlName("SF4") + " SF4 ON ( SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' ) "
        cQryDoc += " WHERE SF2.F2_FILIAL = '"+cFil+"' "
        cQryDoc += " AND SF2.F2_DOC = '"+cNota+"' "
        cQryDoc += " AND SF2.F2_SERIE = '"+cSerie+"' "
        cQryDoc += " AND SF2.F2_CLIENTE  = '"+cClieFor+"' "
        cQryDoc += " AND SF2.F2_LOJA = '"+cLoja+"' "
        cQryDoc += " AND SF2.D_E_L_E_T_ = ' ' "
    Else // Entradas
        cQryDoc := " SELECT '   ' COND_PAG, F1_TIPO TIPODOC, F1_EST ESTADO, F1_PLIQUI PESO_LIQ, F1_PBRUTO PESO_BRU, F4_CODIGO TES, F4_OPEMOV OPERACAO "
        cQryDoc += " FROM " + RetSqlName("SF1") + " SF1 "
        cQryDoc += " LEFT JOIN " + RetSqlName("SD1") + " SD1 ON ( SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D_E_L_E_T_ = ' ' ) "
        cQryDoc += " LEFT JOIN " + RetSqlName("SF4") + " SF4 ON ( SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ = ' ' ) "
        cQryDoc += " WHERE SF1.F1_FILIAL = '"+cFil+"' "
        cQryDoc += " AND SF1.F1_DOC = '"+cNota+"' "
        cQryDoc += " AND SF1.F1_SERIE = '"+cSerie+"' "
        cQryDoc += " AND SF1.F1_FORNECE  = '"+cClieFor+"' "
        cQryDoc += " AND SF1.F1_LOJA = '"+cLoja+"' "
        cQryDoc += " AND SF1.D_E_L_E_T_ = ' ' "
    EndIf
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDoc),"TRA",.F.,.T.)
    //If	( TRA->COND_PAG <> "999" ) // Vendas a Vista nao precisa obrigar informa็ใo do PESO. (NAO VALIDAR A VISTA POIS AS TRANSFERENCIAS SAO GERADAS COMO A VISTA).
        While	TRA->( ! Eof() )
                // Verifica se deve ser validado o PESO obrigatoriamente, o estado do cliente ou fornecedor bem como PESO informado na nota fiscal.
                aRetDet[1] := Iif(!TRA->OPERACAO$"01/06/07/08/11/13/14/15/16/17",.T.,aRetDet[1]) // verifica se a TES no Item nao esta na lista que nao precisa informar PESO obrigatorio.
                aRetDet[2] := TRA->ESTADO
                aRetDet[3] := Iif(TRA->PESO_LIQ>0.and.TRA->PESO_BRU>0,TRA->PESO_BRU,0) // Passa o peso somente se os dois campos estierem preenchidos....
                // Caso algum item ja retorne para validar, ja fecha e valida os dados....
                If	( aRetDet[1] )
                    Exit
                EndIf
            TRA->(DbSkip())
        End
    //EndIf
    TRA->(DbCloseArea())

Return aRetDet

Static Function xGetFCI(cTipo,cFil,cNota,cSerie,cClieFor,cLoja)
Local	cQryDoc2 		:= ""
Local	cRetDet2		:= .f.

    // Monta query para verificar Origem e FCI
    If	( cTipo == "S" ) // Saida
        cQryDoc2 := "SELECT B1_ORIGEM ORIGEM, D2_FCICOD FCI "
        cQryDoc2 += "FROM " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1 "
        cQryDoc2 += "WHERE SD2.D2_FILIAL = SF2.F2_FILIAL "
        cQryDoc2 += "AND SD2.D2_DOC = SF2.F2_DOC "
        cQryDoc2 += "AND SD2.D2_SERIE = SF2.F2_SERIE " 
        cQryDoc2 += "AND SD2.D2_CLIENTE = SF2.F2_CLIENTE " 
        cQryDoc2 += "AND SD2.D2_LOJA = SF2.F2_LOJA "
        cQryDoc2 += "AND SF2.F2_FILIAL = '" + cFil + "' "
        cQryDoc2 += "AND SF2.F2_DOC = '" + cNota + "' "
        cQryDoc2 += "AND SF2.F2_SERIE = '" + cSerie + "' " 
        cQryDoc2 += "AND SF2.F2_CLIENTE  = '" + cClieFor + "' " 
        cQryDoc2 += "AND SF2.F2_LOJA = '" + cLoja + "' "
        cQryDoc2 += "AND SD2.D2_COD = SB1.B1_COD "
        cQryDoc2 += "AND SF2.D_E_L_E_T_ = ' ' "
        cQryDoc2 += "AND SD2.D_E_L_E_T_ = ' ' "
        cQryDoc2 += "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDoc2),"TRB",.F.,.T.)
            
        While	TRB->( ! Eof() )
                // Verifica se a origem do item necessita preenchimento do FCI na saida (Origens 3,4,5,8)
                If	TRB->ORIGEM $ "3/4/5/8"
                    If	Empty(TRB->FCI) // Verifica se o campo D2_FCICOD esta em branco, se sim retorna .t.
                        MsgAlert(OemToAnsi("Existe(m) Nota(s) Fiscal(is) sem FCI informado em itens de origem (B1_ORIGEM) 3,4,5 ou 8 e nใo poderแ ser transmitida sem o preenchimento deste campo. Documento: "+cNota))
                        cRetDet2 := .t.
                    Else
                        If FindFunction("u_FPARSEFC")
                            If  u_FPARSEFC(TRB->FCI) //verifica se o FCI preenchido esta valido. 
                                cRetDet2 := .t.
                            EndIf
                        EndIf
                    EndIf
                EndIf
                // Caso algum item ja retorne para validar, ja fecha e valida os dados....
                If	( cRetDet2 == .t. )
                    Exit
                EndIf
                
            TRB->(DbSkip())
        End
        TRB->(DbCloseArea())
    
    EndIf

Return cRetDet2

Static Function xGetImob(cTipo,cFil,cNota,cSerie,cClieFor,cLoja)
Local	cQryDoc3 		:= ""
Local	lRetDetAtiv		:= .f.		
		
    cQryDoc3 := "SELECT D2_CF CFOP "
    cQryDoc3 += "FROM " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1 "
    cQryDoc3 += "WHERE SF2.F2_FILIAL = '"+cFil+"' "
    cQryDoc3 += "AND SD2.D2_FILIAL = SF2.F2_FILIAL "
    cQryDoc3 += "AND SD2.D2_DOC = SF2.F2_DOC "
    cQryDoc3 += "AND SD2.D2_SERIE = SF2.F2_SERIE " 
    cQryDoc3 += "AND SD2.D2_CLIENTE = SF2.F2_CLIENTE " 
    cQryDoc3 += "AND SD2.D2_LOJA = SF2.F2_LOJA " 
    cQryDoc3 += "AND SD2.D2_COD = SB1.B1_COD "
    cQryDoc3 += "AND SF2.F2_DOC = '"+cNota+"' "
    cQryDoc3 += "AND SF2.F2_SERIE = '"+cSerie+"' " 
    cQryDoc3 += "AND SF2.F2_CLIENTE  = '"+cClieFor+"' " 
    cQryDoc3 += "AND SF2.F2_LOJA = '"+cLoja+"' "
    cQryDoc3 += "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
    cQryDoc3 += "AND SB1.B1_COD = SD2.D2_COD "
    cQryDoc3 += "AND SB1.B1_TIPO IN ('AI','MC') "
    cQryDoc3 += "AND SF2.D_E_L_E_T_ = ' ' "
    cQryDoc3 += "AND SD2.D_E_L_E_T_ = ' ' "
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDoc3),"TRC",.F.,.T.)
    
    If	TRC->( ! Eof() )
        lRetDetAtiv := .T.
    End
    TRC->(DbCloseArea())		

Return lRetDetAtiv
