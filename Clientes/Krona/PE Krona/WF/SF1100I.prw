#Include "topconn.ch"
#Include "Rwmake.ch"
#Include "tbiconn.ch"
#Include "Colors.ch"

User Function SF1Cem0()
	u_sf1100i(1)
return

User Function SF1100I(nOpx)
	***************************
	Local aMsg, lKroAtuPed, cKroMail, cKroAxMail, lKEspelho, cKNomForn, cKMailEsp, aMsgCond, lKDivCond, cPedCond, cKMDivCond, cAxDivCond, cDir542, cFile542, lKBloqPag, aMail, cBloqPed, cBloqComp,aPendCab,aCabecalho
	Local cIDComp, cPendItens, cPendCab, nKTolQtd, nKTolTot, nCalc1, aItAux, nPosIt, nPosProd, nPosProFor, nPosQtd, nPosVUnit, nPosTot, nPosPed, nPosPed2, nPosItPc, nPosDescri, nPosCfOp, nPosPendIt, nPosIDComp, cUsuAux, cMailUsu
	Local nTotalPed	:= 0
	Local nTotalFrete:= 0
	Local nTotalIPI	:= 0
	Local cObsPedido:= ""
	Local cNomeComp	:= ""
	Local aSegSE2	:= SE2->(GetArea())
	Local aSegSD1	:= SD1->(GetArea())
	Local aSegSF1	:= SF1->(GetArea())
	Local aSegSE4	:= SE4->(GetArea())
	Local aSegSFT	:= SFT->(GetArea())
	Local aSegCD2	:= CD2->(GetArea())
	Local aSegSF3	:= SF3->(GetArea())
	Local aSegSC7	:= SC7->(GetArea())
	Local aSegSA2	:= SA2->(GetArea())
	Local aSegSF4	:= SF4->(GetArea())
	Local aSegSA1	:= SA1->(GetArea())
	Local lKEPedRep := .F.
	Local cKEPedRep := ""
	Local _x 		:= 0
    Local nCalPer  	:= 0
    Local nTolVlUnit:= SuperGetMv("KR_SF11TOL",.F.,1)
	Local lPriVez	:= .t.
	Local lKDivNFEmis := .f.
	Local cKMDivNFEmis	:= ""
	Local nDInterv		:= SuperGetMV("KR_SF11DIA",.F.,7)

	Private cComprador := " "
	Private cEmailComp2 := " "


	SetPrvt("oDlgx,oGet1,oSay2,oGet3,oSay4,oSBtn5,oSBtn6,aRotina")
	lTec015 := u_TEC015()
// Alan Leandro - Inicio - Vou no Frete Embarcador buscar alguns campos customizados para a SF1
/////////////////////////////////////////////////////////////////////////////////////////////////////
	If Substr(FunName(),1,4) == "GFEA"
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
			GW3->(dbSetOrder(10))
			//GW3_FILIAL+GW3_EMISDF+GW3_SERDF+GW3_NRDF
			If GW3->(dbSeek(xFilial("GW3")+SA2->A2_cgc+Padr(SF1->F1_serie,5)+Padr(SF1->F1_doc,16)))
				GW4->(dbSetOrder(1))
				//GW4_FILIAL+GW4_EMISDF+GW4_CDESP+GW4_SERDF+GW4_NRDF+DTOS(GW4_DTEMIS)+GW4_EMISDC+GW4_SERDC+GW4_NRDC+GW4_TPDC
				GW4->(dbSeek(xFilial("GW4")+GW3->GW3_emisdf+GW3->GW3_cdesp+GW3->GW3_serdf+GW3->GW3_nrdf+Dtos(GW3->GW3_dtemis),.T.))
				While !GW4->(Eof()) .and. GW4->GW4_filial	== xFilial("GW4") .and. GW4->GW4_emisdf == GW3->GW3_emisdf .and. GW4->GW4_cdesp			== GW3->GW3_cdesp        ;
						.and. GW4->GW4_serdf	== GW3->GW3_serdf .and. GW4->GW4_nrdf	== GW3->GW3_nrdf   .and. Dtos(GW4->GW4_dtemis)	== Dtos(GW3->GW3_dtemis)

					cFlagCtr := "N"
					If GW3->GW3_tpdf $ "2,3"
						cFlagCtr := "C"
					ElseIf GW3->GW3_tpdf $ "4,5,6"
						cFlagCtr := "R"
					EndIf

					RecLock("SF1",.F.)
					SF1->F1_notas	:= GW4->GW4_nrdc
					SF1->F1_series	:= GW4->GW4_serdc
					SF1->F1_ser_ori	:= SF1->F1_serie
					SF1->F1_origem2	:= FunName()
					SF1->F1_flagctr	:= cFlagCtr
					SF1->(MsUnLock())

					If cFlagCtr == "N"
						SF2->(dbSetOrder(1))
						If SF2->(dbSeek(xFilial("SF2")+Padr(GW4->GW4_nrdc,9)+Padr(GW4->GW4_serdc,3),.T.))
							If SF2->F2_doc == Padr(GW4->GW4_nrdc,9)
								RecLock("SF2",.F.)
								SF2->F2_notae	:= SF1->F1_doc
								SF2->F2_seriee	:= SF1->F1_serie
								SF2->F2_fornece	:= SF1->F1_fornece
								SF2->F2_lojae	:= SF1->F1_loja
								SF2->F2_tipomp	:= "N"
								SF2->(MsUnLock("SF2"))
							EndIf
						EndIf
					EndIf

					GW4->(dbSkip())
				EndDo

				GXG->(dbSetOrder(5))
				GXG->(dbSeek(GW3->GW3_cte))
				_cDir := Alltrim(GetMv("MV_XMLDIR"))+"OLD\"
				_cDirErro := Alltrim(GetMv("MV_XMLDIR"))+"ERR\"
				_cFile := Alltrim(GetMv("MV_XMLDIR"))
				_cFileErro := Alltrim(GetMv("MV_XMLDIR"))
				While !GXG->(Eof()) .and. GXG->GXG_cte == GW3->GW3_cte
					If GXG->GXG_filial == xFilial("GXG") .and. GXG->GXG_edisit == "4" .and. !Empty(GXG->GXG_ediarq)
						cDir542		:= _cDir //Alltrim(GetMv("MV_XMLDIR"))+"OLD\"
						//cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq), Alltrim(GetMv("MV_XMLDIR")),"")
						cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq), _cFile ,"")
						If !File(cDir542+cFile542)
							cDir542		:= _cDirErro //Alltrim(GetMv("MV_XMLDIR"))+"ERR\"
							//cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq),Alltrim(GetMv("MV_XMLDIR")),"")
							cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq),_cFileErro,"")
							If !File(cDir542+cFile542)
								U_KFastMail('ti.desenvolvimento@krona.com.br','','ALERTA - Arquivamento de XML NFe/CTe - ['+Alltrim(SM0->M0_nome)+'] - '+Dtoc(MsDate()),{"Arquivo não encontrado na XML_CTE"})
							EndIf
						EndIf
						aMsgEmail 	:= {}
						aEmail 		:= {}
					EndIf
					GXG->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf

	cPedCond	:= ""
	cKMDivCond	:= ""
	aMsgCond	:= {}
	aadd(aMsgCond ,"Nota Fiscal com Condição de Pagamento divergente do Pedido de Compra:")
	aadd(aMsgCond ,"<br>")
	aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgCond ,">>>>>> Nota Fiscal de Entrada: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie))
	aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgCond ,">>>>>> Fornecedor: "+Alltrim(SF1->F1_fornece)+"/"+Alltrim(SF1->F1_loja)+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja,"A2_NOME")))
	aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgCond ,">>>>>> Condição de Pagamento da NF: "+Alltrim(SF1->F1_cond))
	aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
	aMsg		:= {}
	aadd(aMsg ,"Nota Fiscal com CC/Conta divergente da Solicitação:")
	aadd(aMsg ,"<br>")

	cKMDivNFEmis:= ""
	aMsgNFEmis	:= {}
	aadd(aMsgNFEmis, "Nota Fiscal com data de emissao retroativa. Titulo(s) vencido(s)" )
	aadd(aMsgNFEmis, "<br>")
	aadd(aMsgNFEmis ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgNFEmis ,">>>>>> Nota Fiscal de Entrada: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie))
	aadd(aMsgNFEmis ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgNFEmis ,">>>>>> Fornecedor: "+Alltrim(SF1->F1_fornece)+"/"+Alltrim(SF1->F1_loja)+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja,"A2_NOME")))
	aadd(aMsgNFEmis ,"-------------------------------------------------------------------------------------------")
	aadd(aMsgNFEmis ,">>>>>> Data de Emissao da NF: " + dtoc(SF1->F1_EMISSAO))
	aadd(aMsgNFEmis ,"-------------------------------------------------------------------------------------------")

	lKEspelho	:= .F.
	lKroAtuPed	:= .F.
	lKDivCond	:= .F.
	cKroMail	:= ""
	lKBloqPag	:= .F.
	cPendItens	:= ""
	cPendCab	:= ""
	aPendCab	:= {}
	aCabecalho	:= {}
	cIDComp		:= ""
	cMailUsu	:= ""
	cBloqPed	:= ""
	cBloqComp	:= ""
	aItAux		:= {}
	aMail		:= {}
	nKTolQtd	:= GetMv("MV_K532TQU")
	nKTolTot	:= GetMv("MV_K532TTO")
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja,.T.))
	While !SD1->(Eof()) .and. SD1->D1_filial == xFilial("SD1") .and. SD1->D1_doc == SF1->F1_doc .and. SD1->D1_serie == SF1->F1_serie .and. SD1->D1_fornece == SF1->F1_fornece .and. SD1->D1_loja == SF1->F1_loja

		cPendItens	:= ""
		cKEPedRep := SD1->D1_pedido

		If SD1->D1_quant > 0
			SF4->(dbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+SD1->D1_tes))
				If SF4->F4_estoque == "S"
					lKEspelho := .T.
				EndIf
			EndIf
		EndIf

		If !Empty(SD1->D1_pedido) .and. !Empty(SD1->D1_itempc)

			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial("SC7")+SD1->D1_pedido+SD1->D1_itempc))

				// Aqui tenho que colocar o campo que será criado para identificar que é pedido de compra de Representante.
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				If SC7->C7_kpedrep == "S"
					lKEPedRep := .T.
				EndIf

				nTotalPed 	+= SC7->C7_TOTAL
				nTotalFrete += SC7->C7_VALFRE
				nTotalIPI	+= SC7->C7_VALIPI

				if SF1->F1_EMISSAO <= MsDate() .and. !(SF1->F1_TIPO $ 'D/B')
					dbSelectArea("SE2")
					SE2->(DbSetOrder(6))
					SE2->(DbSeek(xFilial("SE2")+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc,.T.))
					While !SE2->(Eof()) .And. SE2->E2_filial== xFilial("SE2") .And. SE2->E2_prefixo == SF1->F1_serie .And. SE2->E2_num == SF1->F1_doc .And. SE2->E2_fornece == SF1->F1_fornece .And. SE2->E2_loja == SF1->F1_loja
						if SE2->E2_VENCREA <= (MsDate()+nDInterv)
							if (RecLock("SE2",.F.))
								SE2->E2_statlib := '04'
								SE2->(MsUnLock())
							endif
							if lpriVez
								cPEndCab += "Problema com emissao retroativa de NF. Titulo(s) vencido(s) ou fora do prazo minimo para pagamento <br> "
								lPriVez := .f.
							endif
							cPEndCab += " Parcela: " + SE2->E2_PARCELA + " Vencimento: " + DToC(SE2->E2_VENCREA) + "<br>"
							if !lKBloqPag
								lKBloqPag := .T.
							endif
						endif
							
						SE2->(DbSkip())

					EndDo
					dbselectarea("SC7")
					IF lKBloqPag
						If !Empty(SC7->C7_user)
							PswOrder(1)
							If PswSeek(Alltrim(SC7->C7_user),.t.)
								cAxDivCond :=PswRet(1)[1][14]
								If !(cAxDivCond $ cKMDivCond)
									cKMDivNFEmis += cAxDivCond + ";"
									cIDComp		:= SC7->C7_user
									cNomeComp	:= PswRet(1)[1][2]
								Endif
							Endif
						Endif
					EndIf

					dbSelectArea("SF1")
					lKDivNFEmis:= .T.
				endif

				If SF1->F1_cond <> SC7->C7_cond
					cPendCab  := 	"Condição de Pagamento Divergente PC x NF -> "+SD1->d1_pedido+". PC: "+SC7->C7_cond+" - "+;
									Alltrim(Posicione("SE4",1,xFilial("SE4")+SC7->C7_cond,"E4_DESCRI"))+", NF: "+SF1->F1_cond+" - "+;
									Alltrim(Posicione("SE4",1,xFilial("SE4")+SF1->F1_cond,"E4_DESCRI"))+"."
					lKBloqPag := .T.
					lKDivCond := .T.
					If !(SC7->C7_num $ cPedCond)
						aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
						aadd(aMsgCond ,">>>>>> Pedido de Compra: "+Alltrim(SC7->C7_num))
						aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
						aadd(aMsgCond ,">>>>>> Condição de Pagamento do PC: "+Alltrim(SC7->C7_cond))
						aadd(aMsgCond ,"-------------------------------------------------------------------------------------------")
						If(AllTrim(cPedCond))<>""
							cPedCond += "/"+SC7->C7_num
						Else
							cPedCond += SC7->C7_num
						EndIf
						If !Empty(SC7->C7_user)
							PswOrder(1)
							If PswSeek(Alltrim(SC7->C7_user),.t.)
								cAxDivCond :=PswRet(1)[1][14]
								If !(cAxDivCond $ cKMDivCond)
									cKMDivCond += cAxDivCond + ";"
									cIDComp    := SC7->C7_user
									cNomeComp  := PswRet(1)[1][2]
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf

				// Se tiver diferença de preço
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				If noround(SC7->C7_preco, 3) <> noround(SD1->D1_vunit, 3) // Considera diferença de preço nas 3 primeiras casas decimais após a vírgula
					
                    nCalPer     := 0
                    nCalPer     := (100 - Round(((SD1->D1_VUNIT * 100)/(SC7->C7_PRECO)),2))
                    nCalPer     := (nCalPer * IIf(nCalPer < 0,-1,1))

					If (nCalPer > nTolVlUnit)
						cPendItens	+= "Problema Preco PC x NF > ("+Alltrim(TransForm(nTolVlUnit,"@E 99.99"))+"%)-> "+SD1->d1_pedido+"/"+SD1->d1_itempc+". Preco PC: "+Alltrim(Transform(SC7->C7_PRECO,PesqPict("SC7","C7_PRECO")))+" - Preco NF: "+Alltrim(Transform(SD1->D1_VUNIT,PesqPict("SD1","D1_VUNIT")))+" - Desvio(" +  Alltrim(TransForm(nCalPer,"@E 99.99")) + "%). " 
					
						lKBloqPag	:= .T.
						If !(SC7->C7_num $ cPedCond)
							If(AllTrim(cPedCond))<>""
								cPedCond += "/"+SC7->C7_num
							Else
								cPedCond += SC7->C7_num
							EndIf

							If !Empty(SC7->C7_user)
								PswOrder(1)
								If PswSeek(Alltrim(SC7->C7_user),.t.)
									cAxDivCond :=PswRet(1)[1][14]
									If !(cAxDivCond $ cKMDivCond)
										cKMDivCond += cAxDivCond+";"
										cIDComp    := SC7->C7_user
										cNomeComp  := PswRet(1)[1][2]
									EndIf
								EndIf
							EndIf

						EndIf
					EndIf
				EndIf

				// Busca a Quantidade Entregue do Pedido Antes desta Nota
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				nKQuje		:= 0
				nPKItem	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM"})
				nKPosAtu	:= aScan(aCols, {|KLinha| KLinha[nPKItem] == SD1->D1_item })

				If nKPosAtu > 0 .And. !GDDeleted(nKPosAtu)
					nKQuje	:= GdFieldGet("D1_KQUJE",nKPosAtu)
				EndIf

				If (SC7->C7_quant - nKQuje - SC7->C7_qtdacla) <= 0
					cPendItens	+= "Item de Pedido já encerrado: "+SD1->d1_pedido+"/"+SD1->d1_itempc+". Quant: "+Alltrim(Transform(SC7->C7_quant,"@E 99999999.99"))+" Q.Ent: "+Alltrim(Transform(nKQuje,"@E 99999999.99"))+" Q.Clas.: "+Alltrim(Transform(SC7->C7_qtdacla,"@E 99999999.99"))+" Q.NF: "+Alltrim(Transform(SD1->D1_quant,"@E 99999999.99"))
					lKBloqPag	:= .T.
					If !(SC7->C7_num $ cPedCond)
						If(AllTrim(cPedCond))<>""
							cPedCond += "/"+SC7->C7_num
						Else
							cPedCond += SC7->C7_num
						EndIf
					EndIf

					If !Empty(SC7->C7_user)
						PswOrder(1)
						If PswSeek(Alltrim(SC7->C7_user),.t.)
							cAxDivCond :=PswRet(1)[1][14]
							If !(cAxDivCond $ cKMDivCond)
								cKMDivCond += cAxDivCond+";"
								cIDComp    := SC7->C7_user
								cNomeComp  := PswRet(1)[1][2]
							EndIf
						EndIf
					EndIf

				ElseIf (SC7->C7_quant - nKQuje - SC7->C7_qtdacla) < SD1->D1_quant
					nCalc1		:= ( ( SD1->D1_quant * 100 ) / ( SC7->C7_quant - nKQuje - SC7->C7_qtdacla ) ) - 100
					If nCalc1 > nKTolQtd
						cPendItens	+= "Problema Qtd PC x NF: "+SD1->d1_pedido+"/"+SD1->d1_itempc+". Quant: "+Alltrim(Transform(SC7->C7_quant,"@E 99999999.99"))+" Q.Ent: "+Alltrim(Transform(nKQuje,"@E 99999999.99"))+" Q.Clas.: "+Alltrim(Transform(SC7->C7_qtdacla,"@E 99999999.99"))+" Q.NF: "+Alltrim(Transform(SD1->D1_quant,"@E 99999999.99"))
						lKBloqPag	:= .T.
					EndIf
					If !(SC7->C7_num $ cPedCond)
						If(AllTrim(cPedCond))<>""
							cPedCond += "/"+SC7->C7_num
						Else
							cPedCond += SC7->C7_num
						EndIf
					EndIf

					If !Empty(SC7->C7_user)
						PswOrder(1)
						If PswSeek(Alltrim(SC7->C7_user),.t.)
							cAxDivCond :=PswRet(1)[1][14]
							If !(cAxDivCond $ cKMDivCond)
								cKMDivCond += cAxDivCond+";"
								cIDComp    := SC7->C7_user
								cNomeComp  := PswRet(1)[1][2]
							EndIf
						EndIf
					EndIf
				EndIf

				If Empty(cIDComp)
					cIDComp    := SC7->C7_user
				EndIf
				If Empty(cNomeComp)
					cNomeComp  := PswRet(1)[1][2]
				EndIf

				If !Empty(SC7->C7_numsc) .and. !Empty(SC7->C7_itemsc)

					SC1->(dbSetOrder(1))
					If SC1->(dbSeek(xFilial("SC1")+SC7->C7_numsc+SC7->C7_itemsc))

						If SD1->D1_conta <> SC1->C1_conta .or. SD1->D1_cc <> SC1->C1_cc
							// Mando Workflow de Aviso das alterações feitas no Pedido.
							///////////////////////////////////////////////////////////////////
							aadd(aMsg ,"------------------------------------")
							aadd(aMsg ,">>>>>> Item da Nota: "+SD1->D1_item+" / Produto: "+Alltrim(SD1->D1_cod)+" - "+Alltrim(SD1->D1_descri))
							aadd(aMsg ,"------------------------------------")
							aadd(aMsg ,">>>>>> Número da SC: "+SC1->C1_num+" / Item da SC: "+SC1->C1_item+" / Solicitante: <font color='red'><b>"+SC1->C1_solicit+"</b></font>")
							aadd(aMsg ,"------------------------------------")

							If SD1->D1_conta <> SC1->C1_conta
								aadd(aMsg ,"Conta Contábil SC.....: <font color='red'><b>"+SC1->C1_conta+"</b></font>")
								aadd(aMsg ,"Conta Contábil Nota...: <font color='red'><b>"+SD1->D1_conta+"</b></font>")
								aadd(aMsg ,"------------------------------------")
							EndIf

							If SD1->D1_cc <> SC1->C1_cc
								aadd(aMsg ,"Centro de Custo SC.....: <font color='red'><b>"+SC1->C1_cc+"</b></font>")
								aadd(aMsg ,"Centro de Custo Nota...: <font color='red'><b>"+SD1->D1_cc+"</b></font>")
								aadd(aMsg ,"------------------------------------")
							EndIf

							aadd(aMsg ,"<br>")

							lKroAtuPed		:= .T.

							PswOrder(2)
							If PswSeek(Alltrim(SC1->C1_solicit),.T.)
								cKroAxMail := PswRet(1)[1][14]
								If !(cKroAxMail $ cKroMail)
									cKroMail += cKroAxMail+";"
								EndIf
							EndIf
							If !(SC7->C7_num $ cPedCond)
								If(AllTrim(cPedCond))<>""
									cPedCond += "/"+SC7->C7_num
								Else
									cPedCond += SC7->C7_num
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		If( ! Empty(cPendItens))
			aadd(aItAux,{	{	"D1_ITEM"	  	, SD1->D1_item					, Nil},;
							{	"D1_COD"	  	, SD1->D1_cod					, Nil},;
							{	"D1_PROFOR"	  	, Space(6)						, Nil},;
							{	"D1_DESCRI"		, SD1->D1_descri				, Nil},;
							{	"D1_QUANT" 		, SD1->D1_quant					, Nil},;
							{	"C7_QUANT" 		, SC7->C7_QUANT					, Nil},;
							{	"D1_VUNIT" 		, SD1->D1_vunit					, Nil},;
							{	"C7_PRECO" 		, SC7->C7_preco					, Nil},;
							{	"D1_TOTAL" 		, SD1->D1_total					, Nil},;
							{	"C7_TOTAL" 		, SC7->C7_total					, Nil},;
							{	"D1_PEDIDO"		, SD1->D1_pedido				, Nil},;
							{	"D1_ITEMPC"		, SD1->D1_itempc				, Nil},;
							{	"C1_NUM"		, SC1->C1_num					, Nil},;
							{	"C1_ITEM"		, SC1->C1_item					, Nil},;
							{	"D1_CF" 		, SD1->D1_cf					, Nil},;
							{	"PENDITEM"		, cPendItens					, Nil},;
							{	"D1_IDCOMP"		, cIDComp						, Nil}})

			cObsPedido += SC7->C7_ITEM + ': ' + alltrim(SC7->C7_OBS1)+CHR(13)+CHR(10)

		EndIf

		If(! Empty(cPendCab))
			nPosPed := aScan(aPendCab,{|x| x[1] == SD1->D1_pedido})
			If(nPosPed == 0)
				aadd(aPendCab,{SD1->D1_pedido,cIDComp,cPendCab})
				cPendCab := ""
			EndIf
		EndIf

		SD1->(dbSkip())
	EndDo

	If lKroAtuPed .and. !Empty(cKroMail)
		U_FastMail(cKroMail,"","Nota Fiscal "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie)+" com CC/Conta divergente da Solicitação ",aMsg)
	EndIf

	If lKEspelho
		cKMailEsp := GetMv("MV_K607MAI")
		If !Empty(cKMailEsp)
			If SF1->F1_tipo $ "D/B"
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SF1->F1_fornece+SF1->F1_loja))
				cKNomForn := SA1->A1_nome
			Else
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
				cKNomForn := SA2->A2_nome
			EndIf
			aMsg := {}
			aadd(aMsg ,"FAVOR EMITIR O ESPELHO DE RECEBIMENTO DA NOTA FISCAL ABAIXO: ")
			aadd(aMsg ,"<br>")
			aadd(aMsg ,"-------------------------------------------------------------------")
			aadd(aMsg ,"Nota Fiscal: "+SF1->F1_doc+"/"+SF1->F1_serie)
			aadd(aMsg ,"Fornecedor: "+SF1->F1_fornece+"/"+SF1->F1_loja+" - "+Alltrim(cKNomForn))
			aadd(aMsg ,"Emissão: "+Dtoc(SF1->F1_emissao))
			aadd(aMsg ,"Digitação: "+Dtoc(SF1->F1_dtdigit))
			aadd(aMsg ,"-------------------------------------------------------------------")
			U_FastMail(cKMailEsp,"","Espelho de Recebimento Nota Fiscal "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),aMsg)
		EndIf
	EndIf

// Mando Workflow de Aviso de divergência de Condição de Pagamento.
//////////////////////////////////////////////////////////////////////////////
	If lKDivCond
		cComprador := TrazComprador(SC7->C7_User)
		if !empty(SC7->C7_UsrName)
			cEmailComp2 := PswRet(1)[1][14]
			if empty(cEmailComp2)
				cEmailComp2 := 'denise@krona.com.br;'
			endif
			//u_fastmail('','',"Divergência Condição de Pagamento - Nota de Entrada: "+Alltrim(SF1->F1_doc)+""+Alltrim(SF1->F1_serie),aMsgCond)
		else
			cEmailCom2p := 'denise@krona.com.br;'
		endif

		U_FastMail(cEmailComp2,'',"Divergência Condição de Pagamento - Nota de Entrada: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),aMsgCond)
	EndIf

// Aviso aos responsáveis da Acessórios que a Nota foi classificada na Krona Tubos
///////////////////////////////////////////////////////////////////////////////////////////////
	If U_kEmpFil() == "0101" .and. !(SF1->F1_tipo $ ("D,B")) .and. SF1->F1_fornece == "002818"
		U_FastMail(GetMv("MV_KNFACES"),,"Nota classificada na Krona Tubos: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),{"Nota classificada na Krona Tubos: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie)})
	EndIf

// Gravo o pedido de Compra quando for representante
///////////////////////////////////////////////////////////////////////////////////////////////
	If lKEPedRep
		SE2->(dbSetOrder(6))
		SE2->(dbSeek(xFilial("SE2")+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc,.T.))
		While !SE2->(Eof()) .and. SE2->E2_filial  == xFilial("SE2") .and. SE2->E2_prefixo == SF1->F1_serie .and. SE2->E2_num == SF1->F1_doc .and. SE2->E2_fornece == SF1->F1_fornece .and. SE2->E2_loja == SF1->F1_loja
			RecLock("SE2",.F.)
			SE2->E2_kpedido := cKEPedRep
			SE2->(MsUnLock())
			SE2->(dbSkip())
		EndDo
	EndIf

// Alan - Análise da Nota Fiscal com o Pedido de Compra - Forço a liberação do título - Inicio
////////////////////////////////////////////////////////////////////////////////////////////////
	If SuperGetMv("KR_BLOQPAG",.F.,.F.)
		If !lKBloqPag .or. SF1->F1_tipo <> "N" .or. lKEPedRep
			RecLock("SF1",.F.)
			SF1->F1_kropend := Space(6)
			SF1->(MsUnLock())

			SE2->(dbSetOrder(6))
			SE2->(dbSeek(xFilial("SE2")+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc,.T.))
			While !SE2->(Eof()) .and. SE2->E2_filial  == xFilial("SE2") .and. SE2->E2_prefixo == SF1->F1_serie .and. SE2->E2_num == SF1->F1_doc .and. SE2->E2_fornece == SF1->F1_fornece .and. SE2->E2_loja == SF1->F1_loja
				RecLock("SE2",.F.)
				SE2->E2_datalib := dDataBase
				SE2->E2_usualib := "Administrador"
				SE2->E2_statlib := "03"
				SE2->(MsUnLock())
				SE2->(dbSkip())
			EndDo

		ElseIf lKBloqPag .and. SF1->F1_tipo == "N"

			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
			aadd(aCabecalho,SF1->F1_doc)
			aadd(aCabecalho,SF1->F1_serie)
			aadd(aCabecalho,SF1->F1_fornece)
			aadd(aCabecalho,SF1->F1_loja)
			aadd(aCabecalho,SA2->A2_nome)
			aadd(aCabecalho,IIF(Empty(SA2->A2_DDD),"",AllTrim(SA2->A2_DDD)+" - ") + Alltrim(SA2->A2_TEL))
			aadd(aCabecalho,SF1->F1_cond +"-"+ Alltrim(Posicione("SE4",1,xFilial("SE4")+SF1->F1_cond,"E4_DESCRI")))
			aadd(aCabecalho,cIDComp+" - "+cNomeComp)

			if !(empty(cKMDivCond))
				aadd(aCabecalho,cKMDivCond)
			else
				if !empty(cKMDivNFEmis)
					aadd(aCabecalho,cKMDivNFEmis)
				endif
			endif

			aadd(aCabecalho,Dtoc(SF1->F1_emissao))
			aadd(aCabecalho,Dtoc(SF1->F1_dtdigit))
			aadd(aCabecalho,nTotalPed)
			aadd(aCabecalho,nTotalFrete)
			aadd(aCabecalho,nTotalIPI)
			aadd(aCabecalho,cObsPedido)
			aadd(aCabecalho,cNomeComp)
			aadd(aCabecalho,cPedCond)
			aadd(aCabecalho,SF1->F1_CHVNFE)

			cKXml := "NÃO TEM XML"
			ZZ3->(dbSetOrder(2))
			ZZ3->(dbSeek(xFilial("ZZ3")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja))
			While !ZZ3->(Eof()) .and. ZZ3->ZZ3_filial  == xFilial("ZZ3") .and. ZZ3->ZZ3_doc == SF1->F1_doc .and. ZZ3->ZZ3_serie == SF1->F1_serie .and. ZZ3->ZZ3_fornece == SF1->F1_fornece .and. ZZ3->ZZ3_loja == SF1->F1_loja
				cKXml := ZZ3->ZZ3_xml
				RecLock("ZZ3",.F.)
				dbDelete()
				ZZ3->(MsUnLock())
				ZZ3->(dbSkip())
			EndDo

			RecLock("SF1",.F.)
			SF1->F1_kropend := "S"
			SF1->(MsUnLock())

			If(Len(aItAux) > 0)
				// Busca as posições dos campos no array.
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				nPosIt	 	:= aScan(aItAux[1],{|x| x[1] == "D1_ITEM"		})
				nPosProd 	:= aScan(aItAux[1],{|x| x[1] == "D1_COD"		})
				nPosProFor 	:= aScan(aItAux[1],{|x| x[1] == "D1_PROFOR"		})
				nPosQtd  	:= aScan(aItAux[1],{|x| x[1] == "D1_QUANT"		})
				nPosVUnit	:= aScan(aItAux[1],{|x| x[1] == "D1_VUNIT" 		})
				nPosTot		:= aScan(aItAux[1],{|x| x[1] == "D1_TOTAL"	 	})
				nPosPed		:= aScan(aItAux[1],{|x| x[1] == "D1_PEDIDO"	 	})
				nPosItPc	:= aScan(aItAux[1],{|x| x[1] == "D1_ITEMPC"	 	})
				nPosDescri	:= aScan(aItAux[1],{|x| x[1] == "D1_DESCRI"	 	})
				nPosCfOp	:= aScan(aItAux[1],{|x| x[1] == "D1_CF"		 	})
				nPosPendIt	:= aScan(aItAux[1],{|x| x[1] == "PENDITEM"	 	})
				nPosIDComp	:= aScan(aItAux[1],{|x| x[1] == "D1_IDCOMP"	 	})
			Endif
			For _x := 1 To Len(aItAux)
				// Trato os pedidos para imprimir no workflow
				/////////////////////////////////////////////////////////////////////
				If !(aItAux[_x][nPosPed][2] $ cBloqPed)
					cBloqPed += aItAux[_x][nPosPed][2]+"/"
				EndIf

				// Busca os emails dos compradores
				/////////////////////////////////////////////////////////////////////
				cUsuAux := UsrRetName(aItAux[_x][nPosIDComp][2])
				PswOrder(2)
				If PswSeek(Alltrim(cUsuAux),.T.)
					If !(Alltrim(PswRet(1)[1][14]) $ cMailUsu)
						cMailUsu += Alltrim(PswRet(1)[1][14])+";"
					EndIf
				EndIf
				If !(Alltrim(cUsuAux) $ cBloqComp)
					cBloqComp += Alltrim(cUsuAux)+"/"
				EndIf
			Next _x

			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))


			aadd(aMail,'Pagamento Bloqueado da Nota de Entrada : '+Alltrim(SF1->F1_doc)+'/'+Alltrim(SF1->F1_serie)+'<br><br>')
			aadd(aMail,'Fornecedor: '+Alltrim(SF1->F1_fornece)+'/'+SF1->F1_loja+' - '+Alltrim(SA2->A2_nome)+'<br>')
			aadd(aMail,'Pedido....: '+cBloqPed+'<br>')
			aadd(aMail,'Comprador.: '+cBloqComp+'<br><br>')

			If(Len(aItAux) > 0)
				nPosPed2 := 0
				// Se existir pendencias, varro os itens do array gerado pelo XML para gravar as Pendencias
				// na tabela ZZ3 - Pendencias para importação de NF.
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				For _x := 1 To Len(aItAux)
					RecLock("ZZ3",.T.)
					ZZ3->ZZ3_filial	:= xFilial("ZZ3")
					ZZ3->ZZ3_doc	:= SF1->F1_doc
					ZZ3->ZZ3_serie	:= SF1->F1_serie
					ZZ3->ZZ3_cgc	:= SA2->A2_cgc
					ZZ3->ZZ3_fornec := SF1->F1_fornece
					ZZ3->ZZ3_loja	:= SF1->F1_loja
					ZZ3->ZZ3_tipo	:= "N"
					ZZ3->ZZ3_emissa	:= SF1->F1_emissao
					ZZ3->ZZ3_dtimp 	:= MsDate()
					ZZ3->ZZ3_xml    := cKXml
					ZZ3->ZZ3_item	:= aItAux[_x][nPosIt][2]
					ZZ3->ZZ3_cod	:= aItAux[_x][nPosProd][2]
					ZZ3->ZZ3_profor	:= aItAux[_x][nPosProFor][2]
					ZZ3->ZZ3_descri	:= aItAux[_x][nPosDescri][2]
					ZZ3->ZZ3_quant	:= aItAux[_x][nPosQtd][2]
					ZZ3->ZZ3_vunit	:= aItAux[_x][nPosVUnit][2]
					ZZ3->ZZ3_total	:= aItAux[_x][nPosTot][2]
					ZZ3->ZZ3_cf		:= aItAux[_x][nPosCfOp][2]
					ZZ3->ZZ3_pedido	:= aItAux[_x][nPosPed][2]
					ZZ3->ZZ3_itempc	:= aItAux[_x][nPosItPc][2]
					nPosPed2 := aScan(aPendCab,{|x| x[1] == aItAux[_x][nPosPed][2]})
					If(nPosPed2 > 0)
						ZZ3->ZZ3_pencab	:= aPendCab[nPosPed2][3]
					EndIf
					ZZ3->ZZ3_penite	:= aItAux[_x][nPosPendIt][2]
					ZZ3->ZZ3_idcomp	:= aItAux[_x][nPosIDComp][2]
					ZZ3->(MsUnLock())

				Next _x
			ElseIf(Len(aPendCab)>0)
				For _x := 1 To Len(aPendCab)
					RecLock("ZZ3",.T.)
					ZZ3->ZZ3_filial	:= xFilial("ZZ3")
					ZZ3->ZZ3_doc	:= SF1->F1_doc
					ZZ3->ZZ3_serie	:= SF1->F1_serie
					ZZ3->ZZ3_cgc	:= SA2->A2_cgc
					ZZ3->ZZ3_fornec := SF1->F1_fornece
					ZZ3->ZZ3_loja	:= SF1->F1_loja
					ZZ3->ZZ3_tipo	:= "N"
					ZZ3->ZZ3_emissa	:= SF1->F1_emissao
					ZZ3->ZZ3_dtimp 	:= MsDate()
					ZZ3->ZZ3_xml    := cKXml
					ZZ3->ZZ3_pedido	:= aPendCab[_x][1]
					ZZ3->ZZ3_idcomp	:= aPendCab[_x][2]
					ZZ3->ZZ3_pencab	:= aPendCab[_x][3]
					ZZ3->(MsUnLock())
				Next _x
			EndIf
			U_KRO833(aCabecalho,aPendCab,aItAux)
			U_FastMail(SuperGetMv("KR_KRO833A",.F.,"contasapagar@krona.com.br;"),"","Pagamento Bloqueado da Nota de Entrada : "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),aMail)
		EndIf

		// Desbloqueio os títulos que não são do tipo NF, mas que tem o mesmo número de nota, serie e data de emissao,
		// mesmo sendo de fornecedor diferente, para contemplar os títulos de impostos.
		cQuery:=" update "+RetSqlName("SE2")+" set e2_datalib = '"+Dtos(dDataBase)+"', e2_usualib = 'Administrador', e2_statlib = '03' "
		cQuery+=" where e2_filial = '"+xFilial("SE2")+"' and d_e_l_e_t_ = ' ' and e2_prefixo = '"+SF1->F1_serie+"' and e2_num = '"+SF1->F1_doc+"' and "
		cQuery+=" e2_emissao = '"+Dtos(SF1->F1_emissao)+"' and e2_fornece <> '"+SF1->F1_fornece+"' and e2_tipo <> 'NF' and e2_statlib <> '03' "
		TcSqlExec(cQuery)
		If !Empty(TcSqlError())
			U_KFastMail("ti.desenvolvimento@krona.com.br","","[ERRO UPDATE SE2] "+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc+Dtoc(MsDate()),{TcSqlError()})
		EndIf
	Endif
// Alan - Análise da Nota Fiscal com o Pedido de Compra - Forço a liberação do título - Fim
////////////////////////////////////////////////////////////////////////////////////////////////

	RestArea(aSegSA1)
	RestArea(aSegSA2)
	RestArea(aSegSC7)
	RestArea(aSegSD1)
	RestArea(aSegSE2)
	RestArea(aSegSF4)

	RestArea(aSegSF4)
	RestArea(aSegSA1)
	RestArea(aSegSE2)
	RestArea(aSegSD1)
	RestArea(aSegSF1)
	RestArea(aSegSE4)
	RestArea(aSegSFT)
	RestArea(aSegCD2)
	RestArea(aSegSF3)
	RestArea(aSegSC7)
	RestArea(aSegSA2)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a Funcao para aGravacao dos Insumos                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If cEmpAnt $ "01/05/08"
		GeraIns()
	Endif
Return

User Function SF1CemI(cChave)

	l9Pos:=GETMV('MV_P10R2')

	if !empty(cChave)
		xChave:=cChave
	else
		xchave:=SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO
	endif

	lDevolucao:=.f.
	lSair   :=.f.

	if l9Pos
		cNota :=space(09)
	else
		cNota :=space(06)
	endif

	cSerie  :=space(03)
	cCliente:=space(06)
	cLoja   :=space(02)
	cTipoMo :=space(01)
	cTipoReg:=Space(01)
	cEstado :=Space(02)
	lApaga  :=.f.
	if (alltrim(sf1->f1_especie) == 'CTR' .or. alltrim(sf1->f1_especie) == 'CTE' .or. alltrim(sf1->f1_especie) == 'NFST') .and. FUNNAME() $ 'MATA103/SF1CEM0'
		@ 100,238 To 300,500 Dialog odlgx Title OemToAnsi("Nota/Serie de Saida")
		@ 008,021 Say OemToAnsi("Nota:")    Size 26,10
		//@ 008,064 Get cLibera                  Size 15,10 Picture "!" VALID cLibera$'SN'
		@ 008,054 get cNota valid naovazio() size 35,10
		@ 020,021 Say OemToAnsi("Serie:")    Size 26,10
		@ 020,054 get cSerie valid naovazio() size 35,10

		@ 032,021 Say OemToAnsi("Cliente:")    Size 26,10
		@ 032,054 get cCliente size 35,10

		@ 044,021 Say OemToAnsi("Loja:")    Size 26,10
		@ 044,054 get cLoja  size 35,10

		@ 056,021 Say OemToAnsi("M.P.(S/N)?")    Size 26,10
		@ 056,054 get cTipoMo  size 35,10 valid pertence('SN') .and. naovazio()

		@ 068,021 Say OemToAnsi("Fr.Pg.ate")    Size 26,10
		@ 068,054 get cEstado  size 35,10 valid Vazio() .or. ExistCpo('SX5','12'+cEstado)

		@ 080,021 Say OemToAnsi("Tp Regiao")  Size 26,10
		@ 080,054 get cTipoReg size 35,10 valid pertence('CI')

		if FUNNAME() # 'MATA103'
			@ 092,021 checkbox 'Apaga da CTR da NF Acima '    var lApaga object oapaga
		endif

		@ 008,095 BmpButton Type 01 Action Gravadados(cNota,cSerie,cCliente,cLoja,cTipoMo,cEstado,cTipoReg,xChave,lApaga) //Button OemToAnsi("_Ok")      Size 36,16 Action Busca_Itens()
		//if FUNNAME() # 'MATA103'
		@ 024,095 BmpButton Type 02 Action Fechar()//Close(odlg)
		//endif
		Activate Dialog oDlgx centered //valid lSair
	endif
Return

Static Function GravaDados(xNota,xSerie,xCliente,xLoja,xtipo,xEstado,xTpReg,xChave,lApaga)
	Local lComplem:=.f.

	if l9Pos
		xNotaE  :=Subs(xChave,1,9)
		xSerieE :=Subs(xChave,10,3) //inserido por sidnei em 21/08/09
		xFornece:=Subs(xChave,13,6)
		xLojaE  :=Subs(xChave,19,2)
	else
		xNotaE  :=Subs(xChave,1,6)
		xSerieE :=Subs(xChave,7,3)
		xFornece:=Subs(xChave,10,6)
		xLojaE  :=Subs(xChave,16,2)
	endif


	if !empty(SF1->F1_NOTAS)
		U_KRO1041('Nota de Saida informado neste CTR!!!')
		IF SF1->F1_TIPO == 'D'
			return .f.
		endif
	endif
	if empty(xTipo)
		U_KRO1041('preencha o campo tipo!!!')
		return .f.
	endif
	DbSelectArea("SF2")
	DbSetOrder(1)
	if Dbseek(xFilial("SF2")+xNota+xSerie+xCliente+xLoja)
		if !empty(SF2->F2_NOTAE)
			if !MsgYesno('Um CTR já foi associado anteriormente a esta NF. É Complemento?','Yesno')
				if funname() == 'SF1CEM0'
					if !msgbox('CTR inf. anteriormente na NF saida. Regrava? ','Confirma?','YESNO')
						return .f.
					endif
				else
					U_KRO1041('CTR inf. anteriormente na NF saida. ')
					return .f.
				endif
			else
				lComplem:=.t.
				DbSelectArea("SF1")
				begin transaction
					RecLock('SF1',.F.)
					SF1->F1_FLAGCTR:='C'
					SF1->F1_NOTAS := xNota
					SF1->F1_SERIES:= xSerie
					MsUnlock()
				end transaction
			endif
		endif
		begin transaction
			Sele SF2
			if !lComplem
				if !lApaga
					RecLock('SF2',.f.)
					SF2->F2_NOTAE  := xNotaE
					SF2->F2_SERIEE := xSerieE
					SF2->F2_FORNECE:= xFornece
					SF2->F2_LOJAE  := xlojaE
					SF2->F2_TIPOMP := xTipo
					SF2->F2_ESTENT := xEstado
					SF2->F2_CAPINT := xTpReg
					MsUnlock('SF2')
				Else
					RecLock('SF2',.f.)

					if l9Pos
						SF2->F2_NOTAE  := Space(09)
					else
						SF2->F2_NOTAE  := Space(06)
					endif

					SF2->F2_SERIEE := Space(03)
					SF2->F2_FORNECE:= Space(06)
					SF2->F2_LOJAE  := Space(02)
					SF2->F2_TIPOMP := Space(01)
					SF2->F2_ESTENT := Space(02)
					SF2->F2_CAPINT := Space(01)
					MsUnlock('SF2')
				endif
			endif
		end transaction

		if !msgbox('Mais alguma Nota relacionada a este CTR?','Escolha','YESNO')
			//		Close(oDlgx)
			lSair:=.t.
			Fechar()
			return .t.
		else
			if l9Pos
				cNota   :=space(09)
			else
				cNota   :=space(06)
			endif

			cSerie  :=space(03)
			cCliente:=space(06)
			cLoja   :=space(02)
			cTipoMo :=space(01)
			cEstado :=space(02)
			cTipoReg:=space(01)
		endif
	else
		if MsgBox('Nota nao encontrada. É uma Devolução ?','Atencao','YESNO')
			lDevolucao:=.t.

			Sele SF1
			DbSetOrder(9)
			if DbSeek(xFilial('SF1')+xNota+xSerie)
				U_KRO1041('Nf devolucao já utiliza CTR')
				DbsetOrder(1)
				DbSeek(xChave)
				return .f.
			endif

			Sele SF1
			DbSetOrder(1)
			if Dbseek(xFilial("SF1")+xNota+xSerie+xCliente+xLoja+'D')
				sele SF1
				if Dbseek(xFilial("SF1")+xChave)
					begin transaction
						RecLock('SF1',.f.)
						SF1->F1_NOTAS := xNota
						SF1->F1_SERIES:= xSerie
						MsUnlock('SF1')
					end transaction
					lSair:=.t.
					//				Close(oDlgx)
					Fechar()
				endif
			else
				U_KRO1041('Nota não encontrada!!!')
			endif

		else
			U_KRO1041('Nota não encontrada!!!')
		endif
	endif
Return .t.

Static Function Valida()

	if empty(cNota)
		U_KRO1041('Informe o nr. da Nota fiscal')
		return .f.
	endif
	lSair:=.t.
//Close(oDlgx)
	Fechar()
return .t.

Static Function Fechar()
	oDlgx:End()
return .t.


Static Function GravaDI(cDI,dDtDI,cLocDesemb,cUfDesemb,dDtDesemb, cProcesso)
	******************************************************************

	Local aSegSe2:= SE2->(GetArea())

	begin transaction
		RecLock('SF1',.f.)
//	SF1->F1_DI_NUM	:= cDI
//	SF1->F1_DTREG_D	:= dDtDI
//	SF1->F1_LOCALN	:= cLocDesemb
//	SF1->F1_UFDESEM	:= cUfDesemb
//	SF1->F1_DT_DESE	:= dDtDesemb
		SF1->F1_KPROCIMP:= cProcesso
		MsUnlock('SF1')
		lSair2:=.T.
		oDlgx1:End()
	end transaction

//If !Empty(Alltrim(cProcesso))
	SE2->(dbSetOrder(6))
	If(SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC),.T.))
		While ( SE2->( ! eof() ) .and.;
				SE2->E2_Filial  == xFilial('SE2')  .and.;
				SE2->E2_Prefixo == SF1->F1_SERIE .and.;
				SE2->E2_Num     == SF1->F1_DOC .and.;
				SE2->E2_FORNECE == SF1->F1_FORNECE .and.;
				SE2->E2_LOJA == SF1->F1_LOJA)

			RecLock('SE2',.f.)
			SE2->E2_KPROCIM := ' Processo: '+ Alltrim(cProcesso)
			dbselectarea("SA2")
			SA2->(dbSetOrder(1))
			If(SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA),.T.))
				SE2->E2_RUBCOF  := SA2->A2_RUBCOF
				SE2->E2_RUAGEF  := SA2->A2_RUAGEF
				SE2->E2_RUDGAGF := SA2->A2_RUDGAGF
				SE2->E2_RUDCCF  := SA2->A2_RUDCCF
				SE2->E2_RUDGCCF := SA2->A2_RUDGCCF
			endif
			MsUnlock('SE2')
			SE2->( dbSkip() )
		EndDo
	EndIf

	RestArea(aSegSe2)

//EndIf

Return
	********************************************************************************************************************
Static function TrazComprador(cUsr)
	Local cComprador:=''
	if subs(cUsr,1,1) $ '0/1/2/3/4/5/6/7/8/9/'
		PswOrder(1)  //PESQUISA PELO CODIGO
		if PswSeek(ALLTRIM(cUsr),.t.)
			cComprador :=PswRet(1)[1][2]
		endif
	else
		PswOrder(2) //PESQUISA PELO NOME
		if PswSeek(ALLTRIM(cUsr),.t.)
			cComprador :=PswRet(1)[1][2]
		endif
	endif

Return( cComprador )
	****************************************************************************************************************************************************************************************************************************************


Static Function GeraINS()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua a Geracao dos insumos no Manutenção de Ativos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea    := GetArea()
	Local aAreaSD1 := SD1->(GetArea())
	Local aAreaSTJ := STJ->(GetArea())
	Local aAreaSF4 := SF4->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())

	Local xCodPro  := ""
	Local xTipoIns := ""
	Local xUnidIns := ""

	STJ->(dbSetOrder(1)) //TJ_FILIAL+TJ_ORDEM+TJ_PLANO+TJ_TIPOOS+TJ_CODBEM+TJ_SERVICO+TJ_SEQRELA
	SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO

	SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	If SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))
		While !SD1->(Eof()) .and. SD1->D1_FILIAL == SD1->(xFilial("SD1")) .and. SD1->D1_DOC = SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SF1->F1_LOJA == SD1->D1_LOJA

			If !Empty(SD1->D1_ORDEM)
				If STJ->(dbSeek(xFilial("STJ")+SD1->D1_ORDEM,.F.))

					SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES,.F.))
					SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD,.F.))

					xCodPro   := IIf(!Empty(SB1->B1_CODISS),SD1->D1_FORNECE,SD1->D1_COD)
					xTipoIns  := IIf(!Empty(SB1->B1_CODISS),"T","P")
					xUnidIns  := IIf(xTipoIns == "T","H",SD1->D1_UM)

					RetInsumo("0",;               //vTarefa,  //Tarefa da Manutenção
                    /*02    */xTipoIns      ,;    //vTipoIns, //Tipo de Insumo
                    /*03    */xCodPro       ,;     //vCodigo,  //Codigo do Insumo
                    /*04    */SD1->D1_QUANT ,;     //vQuantid, //Quantidade do Insumo
                    /*05    */xUnidIns      ,;     //vUnidade, //Unidade do Insumo
                    /*06    */"",;                 //vDestino, //Destino do Insumo
                    /*07    */"",;                 //vDescric, //Integracao de Mensagem Unica
                    /*08    */dDatabase,;          //vDataIni  //Data de Aplicacao do Insumo
                    /*09    */SubStr(Time(),1,5),; //vHoraIni  //Hora de Aplicacao do Insumo
                    /*10    */SD1->D1_CODBEM ,;    //pCodBem   //Codigo do Bem              (Somente para Gerar OS nova)
                    /*11    */STJ->TJ_SERVICO,;    //pServico  //Codigo do Servico          (Somente para Gerar OS nova)
                    /*12    */SD1->D1_ORDEM  ,;    //pOrdem    //Codigo da Ordem de Servico (Somente para Gerar OS nova)
                    /*13    */STJ->TJ_PLANO  ,;    //pPlano,   //Codigo do Plano            (Somente para Gerar OS nova)
                    /*14    */Nil,;                //pSequenc, //Sequencia da Manutenção    (Somente para Gerar OS nova)
                    /*15    */Nil,;                //pDataIni, //Nao Usado
                    /*16    */Nil,;                //pHoraIni, //Não Usado
                    /*17    */"",;                 //pLocal,   //Almoxarifado para baixa
                    /*18    */"",;                 //pLotec,   //Lote
                    /*19    */"",;                 //pNumLote, //Numero do Lote
                    /*20    */Nil,;                //pDtValid, //Validade do Lote
                    /*21    */"",;                 //pLocaliz, //Endereço
                    /*22    */Nil,;                //pErmDoEv, //Percentual de Execução da Tarefa
                    /*23    */Nil,;                //vCalend,  //Calendario
                    /*24    */Nil,;                //vGarant,  //Garantia do Insumo
                    /*25    */Nil,;                //vLocApl,  //Local da aplicação da Garantia do Insumo
                    /*26    */Nil ,;               //vQtdGar,  //Quantidade em Garantia
                    /*27    */Nil,;                //vUniGar,  //Unidade em Garantia
                    /*28    */Nil ,;               //vConGar,  //Contador em Garantia
                    /*29    */IIf(SF4->F4_ESTOQUE == "S",.T.,.F.) ,;  //plEst,    //Indica se Movimenta Estoque
                    /*30    */SD1->D1_TOTAL )      //nCusto    //Custo do Insumo


					STL->(Reclock("STL",.F.))
					STL->TL_FORNEC  := SD1->D1_FORNECE
					STL->TL_LOJA    := SD1->D1_LOJA
					STL->TL_NOTFIS  := SD1->D1_DOC
					STL->TL_SERIE   := SD1->D1_SERIE
					STL->TL_DESTINO := "S"
					STL->TL_CUSTO   := SD1->D1_TOTAL
					STL->(MsUnlock())

				Endif
			Endif
			SD1->(dbSkip())
		EndDo
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura as Ordens e Recnos posicionados Originalmente              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD1->(RestArea(aAreaSD1))
	STJ->(RestArea(aAreaSTJ))
	SF4->(RestArea(aAreaSF4))
	SB1->(RestArea(aAreaSB1))
	RestArea(aArea)
Return



Static Function RatPedagio(xFil,xDoc,xSerie,xFornece,xLoja,xTipo)
//Distribui o Valor de Pedagio nos Itens para Contabilização no LP 650 021
Local aAreaSF1    := SF1->(GetArea())
Local aAreaSD1    := SD1->(GetArea())
Local aArea       := GetArea() 
Local nVlrPdg     := 0 
Local aItensPdg   := {}
Local nItens      := 0
Local nInc        := 0
Local nVlrParc    := 0


//Se os Campos Existem
If SF1->(FieldPos("F1_VALPEDG")) > 0 .and. SD1->(FieldPos("D1_KVLPEDG")) > 0

  //Seta Os Incices
  SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
  SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM  

  //Pesquisa a Nota Fiscal
  If SF1->(dbSeek(xFil+xDoc+xSerie+xFornece+xLoja+xTipo,.F.))
    If SF1->F1_VALPEDG > 0

        //Obtem o Valor do Pedagio
        nVlrPdg := SF1->F1_VALPEDG
          
        //Pesquisa os Itens da  Nota  
        If SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))
            While !SD1->(Eof()) .and. SD1->D1_FILIAL == SF1->F1_FILIAL .and. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE  .and.  SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA  == SF1->F1_LOJA
                  aadd(aItensPdg,{SD1->(Recno()),0})
                  SD1->(dbSkip())
            EndDo
        Endif
        
        //Obtem a Quantidade de Itens
        nItens := Len(aItensPdg)
        
        If nItens > 0
          
          For nInc := nItens  To  1  Step -1
              
              //Divide o Saldo em Valor do Pedagio Pelo restante de Itens
              nVlrParc := Round(nVlrPdg/nInc,2)
              //Atualiza o Saldo Do Pedagio
              nVlrPdg  := (nVlrPdg - nVlrParc)
              //Abastece o Valor do Pedagio para o Item
              aItensPdg[nInc,2] := nVlrParc
              
              //Vai ate o Item para gravar o Parcial do Pedagio Por Item
              SD1->(dbgoto(aItensPdg[nInc,1]))
              If SD1->(Recno()) == aItensPdg[nInc,1]
                  SD1->(Reclock("SD1",.F.))
                  SD1->D1_KVLPEDG :=  nVlrParc 
                  SD1->(MsUnlock())  
              Endif
          Next nInc
        
        Endif 
    Endif
  Endif
Endif

//Restaura as Ordens e  Posições Originais das Tabelas
SF1->(RestArea(aAreaSF1))
SD1->(RestArea(aAreaSD1))
RestArea(aArea)
Return
