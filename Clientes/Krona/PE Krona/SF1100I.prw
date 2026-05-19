#Include "topconn.ch"
#Include "Rwmake.ch"
#Include "tbiconn.ch"
#Include "Colors.ch"
#Include "protheus.ch"

User Function SF1Cem0()
u_sf1100i(1)
Return

User Function SF1100I(nOpx)

Local cMailFun2     := SuperGetMV('MV_KCFUNC2',.f.,'vania.goes@krona.com.br;')
Local cMailFun1     := GETMV('MV_KCOMFUN')
Local aSegSE2		:= SE2->(GetArea())
Local aSegSD1		:= SD1->(GetArea())
Local aSegSF1		:= SF1->(GetArea())
Local aSegSE4		:= SE4->(GetArea())
Local aSegSFT		:= SFT->(GetArea())
Local aSegCD2		:= CD2->(GetArea())
Local aSegSF3		:= SF3->(GetArea())
Local aSegSC7		:= SC7->(GetArea())
Local aSegSA2		:= SA2->(GetArea())
Local aSegSF4		:= SF4->(GetArea())
Local aSegSA1		:= SA1->(GetArea())
Local aSegSF2		:= SF2->(GetArea())
Local lKroAtuPed	:= .T.
Local lKEspelho		:= .T.
Local lKDivCond		:= .T.
Local lAbrirTela	:= .T.
Local lKBloqPag		:= .T.
Local lKEPedRep 	:= .F.
Local aMsg			:= {}
Local aMsgCond		:= {}
Local aMsgNFEmis	:= {}
Local aPEndCab		:= {}
Local aCabecalho	:= {}
Local aMail			:= {}
Local aItAux		:= {}
Local cKMDivCond	:= ""
Local cKMDivNFEmis	:= ""
Local cAxDivCond	:= ""
Local cPEndItens	:= ""
Local cKroAxMail	:= ""
Local cObsPedido	:= ""
Local cKEPedRep 	:= ""
Local cNomeComp		:= ""
Local cKNomForn		:= ""
Local cKMailEsp		:= ""
Local cBloqComp		:= ""
Local cKroMail		:= ""
Local cPedCond		:= ""
Local cFile542		:= ""
Local cBloqPed		:= ""
Local cPEndCab		:= ""
Local cMailUsu		:= ""
Local cDir542		:= ""
Local cUsuAux		:= ""
Local cIDComp		:= ""
Local cPath		    := ""
Local nTotalFrete	:= 0
Local nPosDescri	:= 0
Local nPosProFor	:= 0
Local nPosIDComp	:= 0
Local nPosPEndIt	:= 0
Local nTotalIPI		:= 0
Local nTotalPed		:= 0
Local nPosVUnit		:= 0
Local nKTolQtd		:= 0
Local nPosProd		:= 0
Local nKTolTot		:= 0
Local nPosPed2		:= 0
Local nPosItPc		:= 0
Local nPosCfOp		:= 0
Local nPosQtd		:= 0
Local nPosTot		:= 0
Local nPosPed		:= 0
Local nCalc1		:= 0
Local nPosIt		:= 0
Local _x			:= 0
Local nCalPer       := 0
Local nTolVlUnit    := SuperGetMv("KR_SF11TOL",.F.,1)
Local lPrivez 		:= .t.
Local lKDivNFEmis	:= .f.
Local nDInterv		:= SuperGetMV("KR_SF11DIA",.F.,7)

Private cComprador	:= " "
Private cEmailComp2	:= " "

SetPrvt("oDlgx,oGet1,oSay2,oGet3,oSay4,oSBtn5,oSBtn6,aRotina")

cDir542		:= Alltrim(GetMv("MV_XMLDIR"))+"OLD\"
cPath		:= Alltrim(GetMv("MV_XMLDIR"))

// Alan Leandro - Inicio - Vou no Frete Embarcador buscar alguns campos customizados para a SF1
/////////////////////////////////////////////////////////////////////////////////////////////////////
If Substr(FunName(),1,4) == "GFEA"
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		GW3->(DbSetOrder(10))
		//GW3_FILIAL+GW3_EMISDF+GW3_SERDF+GW3_NRDF
		If GW3->(DbSeek(xFilial("GW3")+SA2->A2_cgc+Padr(SF1->F1_serie,5)+Padr(SF1->F1_doc,16)))
			GW4->(DbSetOrder(1))
			//GW4_FILIAL+GW4_EMISDF+GW4_CDESP+GW4_SERDF+GW4_NRDF+DTOS(GW4_DTEMIS)+GW4_EMISDC+GW4_SERDC+GW4_NRDC+GW4_TPDC
			GW4->(DbSeek(xFilial("GW4")+GW3->GW3_emisdf+GW3->GW3_cdesp+GW3->GW3_serdf+GW3->GW3_nrdf+Dtos(GW3->GW3_dtemis),.T.))
			While !GW4->(Eof()) .And. GW4->GW4_filial	== xFilial("GW4") .And. GW4->GW4_emisdf == GW3->GW3_emisdf .And. GW4->GW4_cdesp			== GW3->GW3_cdesp ;
				.And. GW4->GW4_serdf	== GW3->GW3_serdf .And. GW4->GW4_nrdf	== GW3->GW3_nrdf .And. Dtos(GW4->GW4_dtemis)	== Dtos(GW3->GW3_dtemis)
				
				cFlagCtr := "N"
				If GW3->GW3_tpdf $ "2,3"
					cFlagCtr := "C"
				ElseIf GW3->GW3_tpdf $ "4,5,6"
					cFlagCtr := "R"
				Endif
				
				RecLock("SF1",.F.)
				SF1->F1_notas	:= GW4->GW4_nrdc
				SF1->F1_series	:= GW4->GW4_serdc
				SF1->F1_ser_ori	:= SF1->F1_serie
				SF1->F1_origem2	:= FunName()
				SF1->F1_flagctr	:= cFlagCtr
				SF1->(MsUnLock())
				
				If cFlagCtr == "N"
					SF2->(DbSetOrder(1))
					If SF2->(DbSeek(xFilial("SF2")+Padr(GW4->GW4_nrdc,9)+Padr(GW4->GW4_serdc,3),.T.))
						If SF2->F2_doc == Padr(GW4->GW4_nrdc,9)
							RecLock("SF2",.F.)
							SF2->F2_notae	:= SF1->F1_doc
							SF2->F2_seriee	:= SF1->F1_serie
							SF2->F2_fornece	:= SF1->F1_fornece
							SF2->F2_lojae	:= SF1->F1_loja
							//SF2->F2_estent	:= cEstRed // Conforme conversado com o Sid, deixamos em branco
							//SF2->F2_capint	:= "C" // Conforme conversado com o Sid, deixamos em branco
							SF2->F2_tipomp	:= "N"
							SF2->(MsUnLock("SF2"))
						Endif
					Endif
				Endif
				
				GW4->(DbSkip())
			EndDo
			
			GXG->(DbSetOrder(5))
			GXG->(DbSeek(GW3->GW3_cte))
			While !GXG->(Eof()) .And. GXG->GXG_cte == GW3->GW3_cte
				If GXG->GXG_filial == xFilial("GXG") .And. GXG->GXG_edisit == "4" .And. !Empty(GXG->GXG_ediarq)
					cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq),cPath,"")
					If !File(cDir542+cFile542)
						cDir542		:= cPath+"ERR\"
						cFile542	:= StrTran(Alltrim(GXG->GXG_ediarq),cPath,"")
						If !File(cDir542+cFile542)
							U_KFastMail('ti.desenvolvimento@krona.com.br','','ALERTA - Arquivamento de XML NFe/CTe - ['+Alltrim(SM0->M0_nome)+'] - '+Dtoc(MsDate()),{"Arquivo não encontrado na XML_CTE"})
						Endif
					Endif
					aMsgEmail 	:= {}
					aEmail 		:= {}
				Endif
				GXG->(DbSkip())
			EndDo
		Endif
	Endif
Endif

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
aMsg := {}
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
cPEndItens	:= ""
cPEndCab	:= ""
aPEndCab	:= {}
aCabecalho	:= {}
cIDComp		:= ""
cMailUsu	:= ""
cBloqPed	:= ""
cBloqComp	:= ""
aItAux		:= {}
aMail		:= {}
nKTolQtd	:= GetMv("MV_K532TQU")
nKTolTot	:= GetMv("MV_K532TTO")
SD1->(DbSetOrder(1))
SD1->(DbSeek(xFilial("SD1")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja,.T.))
While !SD1->(Eof()) .And. SD1->D1_filial == xFilial("SD1") .And. SD1->D1_doc == SF1->F1_doc .And. SD1->D1_serie == SF1->F1_serie .And. SD1->D1_fornece == SF1->F1_fornece .And. SD1->D1_loja == SF1->F1_loja
	
	cPEndItens	:= ""
	cKEPedRep := SD1->D1_pedido
	
	If SD1->D1_quant > 0
		SF4->(DbSetOrder(1))
		If SF4->(DbSeek(xFilial("SF4")+SD1->D1_tes))
			If SF4->F4_estoque == "S"
				lKEspelho := .T.
			Endif
		Endif
	Endif
	
	If !Empty(SD1->D1_pedido) .And. !Empty(SD1->D1_itempc)
		
		dbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		
		If SC7->(DbSeek(xFilial("SC7")+SD1->D1_pedido+SD1->D1_itempc))
			
			// Se for pedido Afill, não avalia divergências - Jacson
			If FieldPos("C7_XPDAFIL") > 0 .And. Alltrim(SC7->C7_XPDAFIL) == "S"
				dbSelectArea("SD1")
				SD1->(DbSkip())
				loop
			Endif
			
			// Aqui tenho que colocar o campo que será criado para identificar que é pedido de compra de Representante.
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			If SC7->C7_kpedrep == "S"
				lKEPedRep := .T.
			Endif
			
			nTotalPed 	+= SC7->C7_TOTAL
			nTotalFrete += SC7->C7_VALFRE
			nTotalIPI	+= SC7->C7_VALIPI
			
			dbSelectArea("SF1")

			if SF1->F1_EMISSAO <= MsDate() .and. !(SF1->F1_TIPO $ 'D/B')
				dbselectarea("SE2")
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
				cPEndCab	:= "Condição de Pagamento Divergente PC x NF -> "+SD1->d1_pedido+". PC: "+SC7->C7_cond+" - "+;
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
					If(Alltrim(cPedCond))<>""
						cPedCond += "/"+SC7->C7_num
					Else
						cPedCond += SC7->C7_num
					Endif
					If !Empty(SC7->C7_user)
						PswOrder(1)
						If PswSeek(Alltrim(SC7->C7_user),.t.)
							cAxDivCond :=PswRet(1)[1][14]
							If !(cAxDivCond $ cKMDivCond)
								cKMDivCond += cAxDivCond + ";"
								cIDComp		:= SC7->C7_user
								cNomeComp	:= PswRet(1)[1][2]
							Endif
						Endif
					Endif
				Endif
			Endif
			
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
						If(Alltrim(cPedCond))<>""
							cPedCond += "/"+SC7->C7_num
						Else
							cPedCond += SC7->C7_num
						Endif
						
						If !Empty(SC7->C7_user)
							PswOrder(1)
							If PswSeek(Alltrim(SC7->C7_user),.t.)
								cAxDivCond :=PswRet(1)[1][14]
								If !(cAxDivCond $ cKMDivCond)
									cKMDivCond += cAxDivCond+";"
									cIDComp		:= SC7->C7_user
									cNomeComp	:= PswRet(1)[1][2]
								Endif
							Endif
						Endif
						
					Endif
				Endif
			Endif
			
			// Busca a Quantidade Entregue do Pedido Antes desta Nota
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			nKQuje		:= 0
			nPKItem	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM"})
			nKPosAtu	:= aScan(aCols, {|KLinha| KLinha[nPKItem] == SD1->D1_item })
			
			If nKPosAtu > 0 .And. !GDDeleted(nKPosAtu)
				nKQuje	:= GdFieldGet("D1_KQUJE",nKPosAtu)
				//MsgStop(nKQuje)
			Endif
			
			If (SC7->C7_quant - nKQuje - SC7->C7_qtdacla) <= 0
				cPEndItens	+= "Item de Pedido já encerrado: "+SD1->d1_pedido+"/"+SD1->d1_itempc+". Quant: "+Alltrim(Transform(SC7->C7_quant,"@E 99999999.99"))+" Q.Ent: "+Alltrim(Transform(nKQuje,"@E 99999999.99"))+" Q.Clas.: "+Alltrim(Transform(SC7->C7_qtdacla,"@E 99999999.99"))+" Q.NF: "+Alltrim(Transform(SD1->D1_quant,"@E 99999999.99"))
				lKBloqPag	:= .T.
				If !(SC7->C7_num $ cPedCond)
					If(Alltrim(cPedCond))<>""
						cPedCond += "/"+SC7->C7_num
					Else
						cPedCond += SC7->C7_num
					Endif
				Endif
				
				If !Empty(SC7->C7_user)
					PswOrder(1)
					If PswSeek(Alltrim(SC7->C7_user),.t.)
						cAxDivCond :=PswRet(1)[1][14]
						If !(cAxDivCond $ cKMDivCond)
							cKMDivCond += cAxDivCond+";"
							cIDComp		:= SC7->C7_user
							cNomeComp	:= PswRet(1)[1][2]
						Endif
					Endif
				Endif
				
			ElseIf (SC7->C7_quant - nKQuje - SC7->C7_qtdacla) < SD1->D1_quant
				nCalc1		:= ( ( SD1->D1_quant * 100 ) / ( SC7->C7_quant - nKQuje - SC7->C7_qtdacla ) ) - 100
				If nCalc1 > nKTolQtd
					cPEndItens	+= "Problema Qtd PC x NF: "+SD1->d1_pedido+"/"+SD1->d1_itempc+". Quant: "+Alltrim(Transform(SC7->C7_quant,"@E 99999999.99"))+" Q.Ent: "+Alltrim(Transform(nKQuje,"@E 99999999.99"))+" Q.Clas.: "+Alltrim(Transform(SC7->C7_qtdacla,"@E 99999999.99"))+" Q.NF: "+Alltrim(Transform(SD1->D1_quant,"@E 99999999.99"))
					lKBloqPag	:= .T.
				Endif
				If !(SC7->C7_num $ cPedCond)
					If(Alltrim(cPedCond))<>""
						cPedCond += "/"+SC7->C7_num
					Else
						cPedCond += SC7->C7_num
					Endif
				Endif
				
				If !Empty(SC7->C7_user)
					PswOrder(1)
					If PswSeek(Alltrim(SC7->C7_user),.t.)
						cAxDivCond :=PswRet(1)[1][14]
						If !(cAxDivCond $ cKMDivCond)
							cKMDivCond += cAxDivCond+";"
							cIDComp		:= SC7->C7_user
							cNomeComp	:= PswRet(1)[1][2]
						Endif
					Endif
				Endif
			Endif
			
			If Empty(cIDComp)
				cIDComp		:= SC7->C7_user
			Endif
			If Empty(cNomeComp)
				cNomeComp	:= PswRet(1)[1][2]
			Endif
			
			If !Empty(SC7->C7_numsc) .And. !Empty(SC7->C7_itemsc)
				
				SC1->(DbSetOrder(1))
				If SC1->(DbSeek(xFilial("SC1")+SC7->C7_numsc+SC7->C7_itemsc))
					
					If SD1->D1_conta <> SC1->C1_conta .Or. SD1->D1_cc <> SC1->C1_cc
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
						Endif
						
						If SD1->D1_cc <> SC1->C1_cc
							aadd(aMsg ,"Centro de Custo SC.....: <font color='red'><b>"+SC1->C1_cc+"</b></font>")
							aadd(aMsg ,"Centro de Custo Nota...: <font color='red'><b>"+SD1->D1_cc+"</b></font>")
							aadd(aMsg ,"------------------------------------")
						Endif
						
						aadd(aMsg ,"<br>")
						
						lKroAtuPed		:= .T.
						
						PswOrder(2)
						If PswSeek(Alltrim(SC1->C1_solicit),.T.)
							cKroAxMail := ""
							If !(PswRet(1)[1][17])
								cKroAxMail := PswRet(1)[1][14]
							Endif
							If !( cValToChar(cKroAxMail) $ cValToChar(cKroMail))
								cKroMail += cKroAxMail+";"
							Endif
						Endif
						If !(SC7->C7_num $ cPedCond)
							If(Alltrim(cPedCond))<>""
								cPedCond += "/"+SC7->C7_num
							Else
								cPedCond += SC7->C7_num
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	
	If( ! Empty(cPEndItens))
		aadd(aItAux,{	{	"D1_ITEM"	, SD1->D1_item					, Nil},;
						{	"D1_COD"				, SD1->D1_cod					, Nil},;
						{	"D1_PROFOR"				, Space(6)						, Nil},;
						{	"D1_DESCRI"				, SD1->D1_descri				, Nil},;
						{	"D1_QUANT" 				, SD1->D1_quant					, Nil},;
						{	"C7_QUANT" 				, SC7->C7_QUANT					, Nil},;
						{	"D1_VUNIT" 				, SD1->D1_vunit					, Nil},;
						{	"C7_PRECO" 				, SC7->C7_preco					, Nil},;
						{	"D1_TOTAL" 				, SD1->D1_total					, Nil},;
						{	"C7_TOTAL" 				, SC7->C7_total					, Nil},;
						{	"D1_PEDIDO"				, SD1->D1_pedido				, Nil},;
						{	"D1_ITEMPC"				, SD1->D1_itempc				, Nil},;
						{	"C1_NUM"				, SC1->C1_num					, Nil},;
						{	"C1_ITEM"				, SC1->C1_item					, Nil},;
						{	"D1_CF" 				, SD1->D1_cf					, Nil},;
						{	"PENDITEM"				, cPEndItens					, Nil},;
						{	"D1_IDCOMP"				, cIDComp						, Nil}})
		
		cObsPedido += SC7->C7_ITEM + ': ' + Alltrim(SC7->C7_OBS1)+CHR(13)+CHR(10)
		
	Endif
	
	If(! Empty(cPEndCab))
		nPosPed := aScan(aPEndCab,{|x| x[1] == SD1->D1_pedido})
		If(nPosPed == 0)
			aadd(aPEndCab,{SD1->D1_pedido,cIDComp,cPEndCab})
			cPEndCab := ""
		Endif
	Endif
	
	SD1->(DbSkip())
EndDo

If lKroAtuPed .And. !Empty(cKroMail)
	U_FastMail(cKroMail,"","Nota Fiscal "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie)+" com CC/Conta divergente da Solicitação ",aMsg)
Endif

If lKEspelho
	cKMailEsp := GetMv("MV_K607MAI")
	If !Empty(cKMailEsp)
		If SF1->F1_tipo $ "D/B"
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SF1->F1_fornece+SF1->F1_loja))
			cKNomForn := SA1->A1_nome
		Else
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
			cKNomForn := SA2->A2_nome
		Endif
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
	Endif
Endif

// Mando Workflow de Aviso de divergência de Condição de Pagamento.
//////////////////////////////////////////////////////////////////////////////
If lKDivCond
	cComprador := TrazComprador(SC7->C7_User)
	if !Empty(SC7->C7_UsrName)
		cEmailComp2 := PswRet(1)[1][14]
		if Empty(cEmailComp2)
			cEmailComp2 := 'denise@krona.com.br;'
		Endif
		//u_fastmail('','',"Divergência Condição de Pagamento - Nota de Entrada: "+Alltrim(SF1->F1_doc)+""+Alltrim(SF1->F1_serie),aMsgCond)
	Else
		cEmailCom2p := 'denise@krona.com.br;'
	Endif
	
	U_FastMail(cEmailComp2,'',"Divergência Condição de Pagamento - Nota de Entrada: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),aMsgCond)
Endif

// Aviso aos responsáveis da Acessórios que a Nota foi classificada na Krona Tubos
///////////////////////////////////////////////////////////////////////////////////////////////
If U_kEmpFil() == "0101" .And. !(SF1->F1_tipo $ ("D,B")) .And. SF1->F1_fornece == "002818"
	U_FastMail(GetMv("MV_KNFACES"),,"Nota classificada na Krona Tubos: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),{"Nota classificada na Krona Tubos: "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie)})
Endif

// Gravo o pedido de Compra quando for representante
///////////////////////////////////////////////////////////////////////////////////////////////
If lKEPedRep
	SE2->(DbSetOrder(6))
	SE2->(DbSeek(xFilial("SE2")+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc,.T.))
	While !SE2->(Eof()) .And. SE2->E2_filial== xFilial("SE2") .And. SE2->E2_prefixo == SF1->F1_serie .And. SE2->E2_num == SF1->F1_doc .And. SE2->E2_fornece == SF1->F1_fornece .And. SE2->E2_loja == SF1->F1_loja
		RecLock("SE2",.F.)
		SE2->E2_kpedido := cKEPedRep
		SE2->(MsUnLock())
		SE2->(DbSkip())
	EndDo
Endif

// Alan - Análise da Nota Fiscal com o Pedido de Compra - Forço a liberação do título - Inicio
////////////////////////////////////////////////////////////////////////////////////////////////
If SuperGetMv("KR_BLOQPAG",.F.,.F.)
	If !lKBloqPag .Or. SF1->F1_tipo <> "N" .Or. lKEPedRep
		RecLock("SF1",.F.)
		SF1->F1_kropEnd := Space(6)
		SF1->(MsUnLock())
		
		SE2->(DbSetOrder(6))
		SE2->(DbSeek(xFilial("SE2")+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc,.T.))
		While !SE2->(Eof()) .And. SE2->E2_filial== xFilial("SE2") .And. SE2->E2_prefixo == SF1->F1_serie .And. SE2->E2_num == SF1->F1_doc .And. SE2->E2_fornece == SF1->F1_fornece .And. SE2->E2_loja == SF1->F1_loja
			RecLock("SE2",.F.)
			SE2->E2_datalib := dDataBase
			SE2->E2_usualib := "Administrador"
			SE2->E2_statlib := "03"
			SE2->(MsUnLock())
			SE2->(DbSkip())
		EndDo
		
	ElseIf lKBloqPag .And. SF1->F1_tipo == "N"
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		aadd(aCabecalho,SF1->F1_doc)
		aadd(aCabecalho,SF1->F1_serie)
		aadd(aCabecalho,SF1->F1_fornece)
		aadd(aCabecalho,SF1->F1_loja)
		aadd(aCabecalho,SA2->A2_nome)
		aadd(aCabecalho,IIF(Empty(SA2->A2_DDD),"",Alltrim(SA2->A2_DDD)+" - ") + Alltrim(SA2->A2_TEL))
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
		ZZ3->(DbSetOrder(2))
		ZZ3->(DbSeek(xFilial("ZZ3")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja))
		While !ZZ3->(Eof()) .And. ZZ3->ZZ3_filial== xFilial("ZZ3") .And. ZZ3->ZZ3_doc == SF1->F1_doc .And. ZZ3->ZZ3_serie == SF1->F1_serie .And. ZZ3->ZZ3_fornece == SF1->F1_fornece .And. ZZ3->ZZ3_loja == SF1->F1_loja
			cKXml := ZZ3->ZZ3_xml
			RecLock("ZZ3",.F.)
			dbDelete()
			ZZ3->(MsUnLock())
			ZZ3->(DbSkip())
		EndDo
		
		RecLock("SF1",.F.)
		SF1->F1_kropEnd := "S"
		SF1->(MsUnLock())
		
		If(Len(aItAux) > 0)
			// Busca as posições dos campos no array.
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			nPosIt	 	:= aScan(aItAux[1],{|x| x[1] == "D1_ITEM"		})
			nPosProd 	:= aScan(aItAux[1],{|x| x[1] == "D1_COD"		})
			nPosProFor 	:= aScan(aItAux[1],{|x| x[1] == "D1_PROFOR"		})
			nPosQtd		:= aScan(aItAux[1],{|x| x[1] == "D1_QUANT"		})
			nPosVUnit	:= aScan(aItAux[1],{|x| x[1] == "D1_VUNIT" 		})
			nPosTot		:= aScan(aItAux[1],{|x| x[1] == "D1_TOTAL"	 	})
			nPosPed		:= aScan(aItAux[1],{|x| x[1] == "D1_PEDIDO"	 	})
			nPosItPc	:= aScan(aItAux[1],{|x| x[1] == "D1_ITEMPC"	 	})
			nPosDescri	:= aScan(aItAux[1],{|x| x[1] == "D1_DESCRI"	 	})
			nPosCfOp	:= aScan(aItAux[1],{|x| x[1] == "D1_CF"		 	})
			nPosPEndIt	:= aScan(aItAux[1],{|x| x[1] == "PENDITEM"	 	})
			nPosIDComp	:= aScan(aItAux[1],{|x| x[1] == "D1_IDCOMP"	 	})
		Endif
		For _x := 1 To Len(aItAux)
			// Trato os pedidos para imprimir no workflow
			/////////////////////////////////////////////////////////////////////
			If !(aItAux[_x][nPosPed][2] $ cBloqPed)
				cBloqPed += aItAux[_x][nPosPed][2]+"/"
			Endif
			
			// Busca os emails dos compradores
			/////////////////////////////////////////////////////////////////////
			cUsuAux := UsrRetName(aItAux[_x][nPosIDComp][2])
			PswOrder(2)
			If PswSeek(Alltrim(cUsuAux),.T.)
				If !(Alltrim(PswRet(1)[1][14]) $ cMailUsu)
					cMailUsu += Alltrim(PswRet(1)[1][14])+";"
				Endif
			Endif
			If !(Alltrim(cUsuAux) $ cBloqComp)
				cBloqComp += Alltrim(cUsuAux)+"/"
			Endif
		Next _x
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		
		
		aadd(aMail,'Pagamento Bloqueado da Nota de Entrada : '+Alltrim(SF1->F1_doc)+'/'+Alltrim(SF1->F1_serie)+'<br><br>')
		aadd(aMail,'Fornecedor: '+Alltrim(SF1->F1_fornece)+'/'+SF1->F1_loja+' - '+Alltrim(SA2->A2_nome)+'<br>')
		aadd(aMail,'Pedido....: '+cBloqPed+'<br>')
		aadd(aMail,'Comprador.: '+cBloqComp+'<br><br>')
		
		If(Len(aItAux) > 0)
			nPosPed2 := 0
			// Se existir pEndencias, varro os itens do array gerado pelo XML para gravar as PEndencias
			// na tabela ZZ3 - PEndencias para importação de NF.
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
				ZZ3->ZZ3_xml	:= cKXml
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
				nPosPed2 := aScan(aPEndCab,{|x| x[1] == aItAux[_x][nPosPed][2]})
				If(nPosPed2 > 0)
					ZZ3->ZZ3_pencab	:= aPEndCab[nPosPed2][3]
				Endif
				ZZ3->ZZ3_penite	:= aItAux[_x][nPosPEndIt][2]
				ZZ3->ZZ3_idcomp	:= aItAux[_x][nPosIDComp][2]
				ZZ3->(MsUnLock())
				
			Next _x
		ElseIf(Len(aPEndCab)>0)
			For _x := 1 To Len(aPEndCab)
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
				ZZ3->ZZ3_xml	:= cKXml
				ZZ3->ZZ3_pedido	:= aPEndCab[_x][1]
				ZZ3->ZZ3_idcomp	:= aPEndCab[_x][2]
				ZZ3->ZZ3_pencab	:= aPEndCab[_x][3]
				ZZ3->(MsUnLock())
			Next _x
		Endif
		U_KRO833(aCabecalho,aPEndCab,aItAux)
		U_FastMail(SuperGetMv("KR_KRO833A",.F.,"contasapagar@krona.com.br;"),"","Pagamento Bloqueado da Nota de Entrada : "+Alltrim(SF1->F1_doc)+"/"+Alltrim(SF1->F1_serie),aMail)
	Endif
	
	// Desbloqueio os títulos que não são do tipo NF, mas que tem o mesmo número de nota, serie e data de emissao,
	// mesmo sEndo de fornecedor diferente, para contemplar os títulos de impostos.
	cQuery:=" update "+RetSqlName("SE2")+" set e2_datalib = '"+Dtos(dDataBase)+"', e2_usualib = 'Administrador', e2_statlib = '03' "
	cQuery+=" where e2_filial = '"+xFilial("SE2")+"' and d_e_l_e_t_ = ' ' and e2_prefixo = '"+SF1->F1_serie+"' and e2_num = '"+SF1->F1_doc+"' and "
	cQuery+=" e2_emissao = '"+Dtos(SF1->F1_emissao)+"' and e2_fornece <> '"+SF1->F1_fornece+"' and e2_tipo <> 'NF' and e2_statlib <> '03' "
	TcSqlExec(cQuery)
	If !Empty(TcSqlError())
		U_KFastMail("ti.desenvolvimento@krona.com.br","","[ERRO UPDATE SE2] "+SF1->F1_fornece+SF1->F1_loja+SF1->F1_serie+SF1->F1_doc+Dtoc(MsDate()),{TcSqlError()})
	Endif
Endif
// Alan - Análise da Nota Fiscal com o Pedido de Compra - Forço a liberação do título - Fim
////////////////////////////////////////////////////////////////////////////////////////////////

// Alan Leandro - Fim- Chamados A0065J, A006N1, A007KW, A007NP e A007R6
//////////////////////////////////////////////////////////////////////////////////


//chamada para enviar comprovante de nota recebida a representante

//Rateia o Valor do pedagio nos Itens
RatPedagio(SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO)



If !IsBlind()
	u_kro590()
Endif

//chamada para enviar workflow transferência entre almoxarifados
//If !IsBlind()
	u_kro470()
//Endif

if Empty(nOpx)
	nOpx := 3
Endif
if nOpx == 0
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' TABLES 'SF1,SF2,SC5,SA1,SA2'
Elseif nOpx == 1
	If !Isblind()
		cCadastro:='Notas de Entrada'
		aRotina	:= {	{OemToAnsi("Pesquisar"),'AxPesqui',0,1},;
		{OemToAnsi("Atualizar"),'ExecBlock("SF1CemI",.f.,.f.)',0,2},;
		{ OemToAnsi('LegEnda'),"A103LegEnda"	, 0 , 2} }		//"LegEnda"
		
		aCores:= {	{ 'Empty(F1_STATUS)', 'ENABLE' },;	// NF Nao Classificada
		{'F1_TIPO=="N" .And. !F1_ESPECIE $ "CTR/CTE"'	 , 'DISABLE'},;		// NF Normal
		{'F1_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
		{'F1_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
		{'F1_ESPECIE $ "CTR/CTE"' , 'BR_PINK'},;		// NF de Compl. Preco/Frete
		{'F1_TIPO=="B"'	 , 'BR_CINZA'},;		// NF de Beneficiamento
		{'F1_TIPO=="D"', 'BR_AMARELO'} }	// NF de Devolucao
		
		mBrowse( 6, 1,22,75 , "SF1",,,,,,aCores)
	Endif
Else
	xchave:=SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO
	If !IsBlind()
		u_SF1CemI(xChave)
	Endif
Endif

// tela para digitacao dos dados da DI PARA NOTA FISCAL ELETRONICA 2.0
lSair2 := .F.
cDI			:= Space(10)
dDtDI		:= ddatabase
cLocDesemb	:= Space(30)
cUfDesemb	:= Space(2)
dDtDesemb	:= ddatabase
cProcesso	:= Space(100)

dbselectarea("SF1")
if FieldPos("F1_XPROC") > 0 // Se existir campo afill
	if !Empty(Alltrim(SF1->F1_XPROC)) // Só abre tela se não for NF de importação AFILL. Campo tem que estar vazio
		lAbrirTela := .f.
	Endif
Endif

if lAbrirTela .And. !IsBlind()
	if !FWIsInCallStack("SchedComCol") .And. Alltrim(sf1->f1_especie) != 'CTR' .And. Alltrim(sf1->f1_especie) != 'CTE' .And. Alltrim(sf1->f1_especie) != 'CA'
		If !IsBlind()
			@ 100,238 To 200,500 Dialog odlgx1 Title OemToAnsi("DADOS ADICIONAIS NF")
			
			@ 028,005 Say OemToAnsi("Nr. Processo:")Size 46,10 OF odlgx1 PIXEL
			@ 028,054 get cProcesso 	size 35,10             OF odlgx1 PIXEL
			@ 008,095 BmpButton Type 01 Action GravaDI(cDI,dDtDI,cLocDesemb,cUfDesemb,dDtDesemb, cProcesso)
			
			Activate Dialog oDlgx1 centered valid lSair2
		Endif
	Endif
Endif


If !IsBlind()
	If (Alltrim(sf1->f1_tipo) == 'D' .And. FunName() $ 'MATA103' .And. !Empty(Alltrim(SF1->F1_DUPL)))
		
		cEmail:= ' '
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
		If !Empty(Alltrim(SA1->A1_USRRESP))
			PswOrder(1)
			if PswSeek(Alltrim(SA1->A1_USRRESP))
				cEmail+=';'
				cEmail +=PswRet(1)[1][14]
			Endif
		Else
			SD1->(DbSetOrder(1))
			If(SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
				SF2->(DbSetOrder(1))
				If(SF2->(DbSeek(xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA)))
					SF2->(DbSetOrder(1))
					If(SA3->(DbSeek(xFilial("SA3")+SF2->F2_VEnd1)))
						PswOrder(1)
						if PswSeek(Alltrim(SA3->A3_USRNAME))
							cEmail+=';'
							cEmail +=PswRet(1)[1][14]
						Endif
					Endif
				Endif
			Endif
		Endif
		u_fastMail(cEmail,'','Atenção!!! Foi lançada uma devolução de vEndas para o cliente '+SF1->F1_FORNECE+' - '+Alltrim(SA1->A1_NOME)+' NCC Nr. '+SF1->F1_DUPL,{'Favor entrar em contato com o cliente para combinar em qual nota fiscal/parcela a Devolução de vEndas em questão deve ser compensada. Numero NCC '+SF1->F1_DUPL})
	Endif
Endif

If !Isblind()
	if lAbrirTela
		If (Alltrim(sf1->f1_tipo) == 'N' .And. FunName() $ 'MATA103' .And. !Empty(Alltrim(SF1->F1_DUPL)))
			U_kro622(SF1->F1_SERIE,SF1->F1_DUPL,SF1->F1_FORNECE,SF1->F1_LOJA)
		Endif
	Endif
Endif


If !IsBlind()
	//aviso sobre NOTAS DE DEVOLUÇÃO DE FUNCIONARIO - camargo
	If (Alltrim(sf1->f1_tipo) == 'D' .And. FunName() $ 'MATA103' )//.And. Empty(Alltrim(SF1->F1_DUPL)))
		
		cEmail:= ' '
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
		
		SD1->(DbSetOrder(1))
		If(SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
			SF2->(DbSetOrder(1))
			If(SF2->(DbSeek(xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA)))
				/////////////////////////////////////////////////////////////////////////////////
				//camargo - integracao com rh - valor futuros
				DbSelectArea('SE4')
				SE4->(DbSetOrder(1))
				If SE4->(DbSeek(xFilial("SE4")+SF2->F2_COND))
					If SE4->E4_TIPO == '9'
						
						cQuery:="select DISTINCT(D2_PEDIDO) "
						cQuery+="from "+RetSqlName('SD2')+" "
						cQuery+="where d2_filial = '"+xFilial('SD2')+"' "
						cQuery+=" and d2_doc = '"+SF2->F2_DOC+"' "
						cQuery+=" and d2_serie = '"+SF2->F2_SERIE+"' "
						cQuery+=" and d2_cliente = '"+SF2->F2_CLIENTE+"' "
						cQuery+=" and d2_loja = '"+SF2->F2_LOJA+"' "
						cQuery+=" and d_e_l_e_t_ = ' ' "
						cQuery:=ChangeQuery(cQuery)
						
						iF (Select("TSD2A") <> 0 )
							TSD2A->(DbCloseArea())
						Endif
						
						TcQuery cQuery new alias "TSD2A"
						TSD2A->(DbGotop())
						
						SC5->(DbSetOrder(1))
						If SC5->(DbSeek(xFilial("SC5")+TSD2A->D2_PEDIDO))
							DbSelectArea("SA1")
							DbSetOrder(1)
							DbGoTop()
							if DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
								if SC5->C5_PARC6 > 0
									nParcela	:= 	6
								Elseif SC5->C5_PARC5 > 0
									nParcela	:= 	5
								Elseif SC5->C5_PARC4 > 0
									nParcela	:= 	4
								Elseif SC5->C5_PARC3 > 0
									nParcela	:= 	3
								Elseif SC5->C5_PARC2 > 0
									nParcela	:= 	2
								Elseif SC5->C5_PARC1 > 0
									nParcela	:= 	1
								Endif
								
								nVlrParc	:=	SC5->C5_PARC1
								dVencRea	:= SC5->C5_DATA1
								nDoc		:= SUBS(SF2->F2_DOC,4,6)
								
								If sa1->a1_tipo == 'F'
									
									cQuery:="select R_E_C_N_O_ AS REG "
									cQuery+="from "+RetSqlName('SRA')+" "
									cQuery+="where ra_filial = '"+xFilial('SRA')+"' "
									cQuery+="	and ra_cic = '"+SA1->A1_CGC+"' "
									cQuery+="	and ra_demissa= ' ' "
									cQuery+="	and d_e_l_e_t_ = ' ' "
									cQuery:=ChangeQuery(cQuery)
									iF (Select("TSRA") <> 0 )
										TSRA->(DbCloseArea())
									Endif
									TcQuery cQuery new alias "TSRA"
									TcSetField('TSRA','REG','N',9,0)
									TSRA->(DbGotop())
									While !Eof()
										dbSelectArea("SRA")
										Dbgoto(TSRA->REG)
										IF Empty(TSRA->REG)
											EXIT
										Endif
										
										cEmail := cMailFun1
										cEmail += cMailFun2
										
										DbSelectArea("CTT")
										DbSetOrder(1)
										DbSeek(xFilial("CTT")+SRA->RA_CC)
										
										u_fastMail(cEmail,'','Nota fiscal faturada para o funcionario foi DEVOLVIDA na NOTA '+SF1->F1_DOC+' - '+Alltrim(SRA->RA_NOME)+' Centro de Custo '+ Alltrim(SRA->RA_CC) +'-'+Alltrim(CTT->CTT_DESC01)+' !',{'O funcionario: '+Alltrim(SRA->RA_MAT)+' - '+Alltrim(SRA->RA_NOME)+' que havia comprado na LOJA KRONA com desconto em folha conforme a NF : '+SD2->D2_DOC+' devolveu na nota '+SF1->F1_DOC+' o valor de R$ '+STR(SF1->F1_VALBRUT)+' . OBS: Valor de cada parcela da NF ORIGINAL: (R$) '+str(nVlrParc)+' sEndo que foram '+Alltrim(str(nParcela))+' parcelas e o TOTAL DA NOTA ORIGINAL FOI R$ '+STR(SF2->F2_VALBRUT)})
										
										TSRA->(DbSkip())
										Loop
									EndDo
								Endif
							Endif
						Endif
					Endif
				Endif
				/////////////////////////////////////////////////////////////////////////////////
			Endif
		Endif
	Endif
Endif

If !IsBlind()
	//AVISO CONFORME CHAMADO A009AF - DOCUMENTO DE ENTRADA COM A TES 062
	If cEmpant == '08'
		cQuery:="select DISTINCT(D1_tes) "
		cQuery+="from "+RetSqlName('SD1')+" "
		cQuery+="where d1_filial = '"+xFilial('SD2')+"' "
		cQuery+="and d1_doc = '"+SF1->F1_DOC+"' "
		cQuery+="and d1_serie = '"+SF1->F1_SERIE+"' "
		cQuery+="and d1_fornece = '"+SF1->F1_FORNECE+"' "
		cQuery+="and d1_loja = '"+SF1->F1_LOJA+"' "
		cQuery+="and d1_tes = '062' "
		cQuery+="and d_e_l_e_t_ = ' ' "
		cQuery:=ChangeQuery(cQuery)
		
		
		iF (Select("TSD1A") <> 0 )
			TSD1A->(DbCloseArea())
		Endif
		
		TcQuery cQuery new alias "TSD1A"
		TSD1A->(DbGotop())
		IF !Empty(TSD1A->D1_TES)
			cEmail:= SuperGetMv("MV_KAVI062",.F.,"ariana.almeida@krona.com.br")
			//				cEmail:= ' '
			u_fastMail(cEmail,'','Nota fiscal LANÇADA com a TES 062 '+SF1->F1_DOC+'-'+SF1->F1_SERIE+' Valor Total R$'+STR(SF1->F1_VALBRUT),{''})
		Endif
		
	Endif
Endif

//FIM REF TRATAMENTO CHAMADO A009AF
RestArea(aSegSF4)
RestArea(aSegSF2)
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

If (Alltrim(sf1->f1_tipo) == 'D' .And. FunName() $ 'MATA103' ) //Se for NCC, Apaga a parcela.
	
	cQuery:="UPDATE "+RetSqlName('SE1')+ " SET E1_PARCELA = ' ' "
	cQuery+="where E1_filial = '"+ xFilial('SE1') +"' "
	cQuery+="	and E1_NUM = '"+ SF1->F1_DOC +"' "
	cQuery+="	and E1_serie = '"+ SF1->F1_SERIE +"' "
	cQuery+="	and E1_CLIENTE = '"+ SF1->F1_FORNECE +"' "
	cQuery+="	and E1_loja	= '"+ SF1->F1_LOJA +"' "
	cQuery+="	and E1_TIPO	= 'NCC' "
	cQuery+="	and ( E1_ORIGEM	= 'MATA100' OR E1_ORIGEM	= 'MATA103' ) "
	cQuery+="	and E1_SALDO 	> 0 "
	cQuery+="	and E1_PARCELA	<> ' '"
	cQuery+="	and D_e_l_e_t_ = ' ' "
	TcSqlExec(cQuery)
	
Endif

//	Chama a Funcao para aGravacao dos Insumos
If U_kEmpFil() $ "0101/0501/0801/0802"
	GeraIns()
Endif

Return
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
User Function SF1CemI(cChave)

l9Pos:=GETMV('MV_P10R2')

if !Empty(cChave)
	xChave:=cChave
Else
	xchave:=SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO
Endif

lDevolucao:=.f.
lSair	:=.f.

if l9Pos
	cNota :=Space(09)
Else
	cNota :=Space(06)
Endif

cSerie	:=Space(03)
cCliente:=Space(06)
cLoja	:=Space(02)
cTipoMo :=Space(01)
cTipoReg:=Space(01)
cEstado :=Space(02)
lApaga	:=.f.

If (Alltrim(sf1->f1_especie) == 'CTR' .Or. Alltrim(sf1->f1_especie) == 'CTE' .Or. Alltrim(sf1->f1_especie) == 'NFST') .And. FunName() $ 'MATA103/SF1CEM0'
	
	@ 100,238 To 300,500 Dialog odlgx Title OemToAnsi("Nota/Serie de Saida")
	@ 008,021 Say OemToAnsi("Nota:")		Size 26,10   OF odlgx PIXEL
	//@ 008,064 Get cLibera					Size 15,10 Picture "!" VALID cLibera$'SN'
	@ 008,054 get cNota valid naovazio()	size 35,10   OF odlgx PIXEL
	@ 020,021 Say OemToAnsi("Serie:")		Size 26,10   OF odlgx PIXEL
	@ 020,054 get cSerie valid naovazio()	Size 35,10   OF odlgx PIXEL
	
	@ 032,021 Say OemToAnsi("Cliente:")		Size 26,10   OF odlgx PIXEL
	@ 032,054 get cCliente					Size 35,10   OF odlgx PIXEL
	
	@ 044,021 Say OemToAnsi("Loja:")		Size 26,10   OF odlgx PIXEL
	@ 044,054 get cLoja						size 35,10   OF odlgx PIXEL
	
	@ 056,021 Say OemToAnsi("M.P.(S/N)?")	Size 26,10   OF odlgx PIXEL
	@ 056,054 get cTipoMo					size 35,10 valid pertence('SN') .And. naovazio()   OF odlgx PIXEL
	
	@ 068,021 Say OemToAnsi("Fr.Pg.ate")	Size 26,10   OF odlgx PIXEL
	@ 068,054 get cEstado					size 35,10 valid Vazio() .Or. ExistCpo('SX5','12'+cEstado)   OF odlgx PIXEL
	
	@ 080,021 Say OemToAnsi("Tp Regiao")	Size 26,10   OF odlgx PIXEL
	@ 080,054 get cTipoReg					size 35,10 valid pertence('CI')   OF odlgx PIXEL
	
	if FunName() # 'MATA103'
		@ 092,021 checkbox 'Apaga da CTR da NF Acima ' var lApaga object oapaga
	Endif
	
	@ 008,095 BmpButton Type 01 Action Gravadados(cNota,cSerie,cCliente,cLoja,cTipoMo,cEstado,cTipoReg,xChave,lApaga) //Button OemToAnsi("_Ok") Size 36,16 Action Busca_Itens()
	
	@ 024,095 BmpButton Type 02 Action Fechar()//Close(odlg)
	
	Activate Dialog oDlgx centered //valid lSair
	
Endif

Return
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
Static Function GravaDados(xNota,xSerie,xCliente,xLoja,xtipo,xEstado,xTpReg,xChave,lApaga)
Local lComplem:=.f.

if l9Pos
	xNotaE	:=Subs(xChave,1,9)
	xSerieE :=Subs(xChave,10,3) //inserido por sidnei em 21/08/09
	xFornece:=Subs(xChave,13,6)
	xLojaE	:=Subs(xChave,19,2)
Else
	xNotaE	:=Subs(xChave,1,6)
	xSerieE :=Subs(xChave,7,3)
	xFornece:=Subs(xChave,10,6)
	xLojaE	:=Subs(xChave,16,2)
Endif

if !Empty(SF1->F1_NOTAS)
	MsgStop('Nota de Saida informado neste CTR!!!')
	IF SF1->F1_TIPO == 'D'
		Return .f.
	Endif
Endif
if Empty(xTipo)
	MsgStop('preencha o campo tipo!!!')
	Return .f.
Endif
DbSelectArea("SF2")
DbSetOrder(1)
if DbSeek(xFilial("SF2")+xNota+xSerie+xCliente+xLoja)
	if !Empty(SF2->F2_NOTAE)
		if !MsgYesno('Um CTR já foi associado anteriormente a esta NF. É Complemento?','Escolha','Yesno')
			if FunName() == 'SF1CEM0'
				if !MsgBox('CTR inf. anteriormente na NF saida. Regrava? ','Confirma?','YESNO')
					Return .f.
				Endif
			Else
				MsgStop('CTR inf. anteriormente na NF saida. ')
				Return .f.
			Endif
		Else
			lComplem:=.t.
			DbSelectArea("SF1")
			Begin Transaction
			
			If !(SF1->(Eof()))
				DbSelectArea("SF1")
				SF1->(DbSetOrder(1))
				SF1->( DbSeek( xFilial("SF1") + xChave ) )
				
			Endif
			
			If RecLock('SF1',.F.)
				SF1->F1_FLAGCTR	:= 'C'
				SF1->F1_NOTAS	:= xNota
				SF1->F1_SERIES	:= xSerie
				SF1->(MsUnlock())
				
			Endif
			End Transaction
		Endif
	Endif
	Begin Transaction
	Sele SF2
	if !lComplem
		if !lApaga
			RecLock('SF2',.f.)
			SF2->F2_NOTAE	:= xNotaE
			SF2->F2_SERIEE	:= xSerieE
			SF2->F2_FORNECE	:= xFornece
			SF2->F2_LOJAE	:= xlojaE
			SF2->F2_TIPOMP	:= xTipo
			SF2->F2_ESTENT	:= xEstado
			SF2->F2_CAPINT	:= xTpReg
			MsUnlock('SF2')
		Else
			RecLock('SF2',.f.)
			
			if l9Pos
				SF2->F2_NOTAE	:= Space(09)
			Else
				SF2->F2_NOTAE	:= Space(06)
			Endif
			
			SF2->F2_SERIEE	:= Space(03)
			SF2->F2_FORNECE	:= Space(06)
			SF2->F2_LOJAE	:= Space(02)
			SF2->F2_TIPOMP	:= Space(01)
			SF2->F2_ESTENT	:= Space(02)
			SF2->F2_CAPINT	:= Space(01)
			MsUnlock('SF2')
		Endif
	Endif
	End Transaction
	
	if !MsgBox('Mais alguma Nota relacionada a este CTR?','Escolha','YESNO')
		//		Close(oDlgx)
		lSair:=.t.
		Fechar()
		Return .t.
	Else
		if l9Pos
			cNota	:=Space(09)
		Else
			cNota	:=Space(06)
		Endif
		
		cSerie	:=Space(03)
		cCliente:=Space(06)
		cLoja	:=Space(02)
		cTipoMo :=Space(01)
		cEstado :=Space(02)
		cTipoReg:=Space(01)
	Endif
Else
	if MsgBox('Nota nao encontrada. É uma Devolução ?','Atencao','YESNO')
		lDevolucao:=.t.
		
		Sele SF1
		DbSetOrder(9)
		if DbSeek(xFilial('SF1')+xNota+xSerie)
			MsgStop('Nf devolucao já utiliza CTR')
			DbSetOrder(1)
			DbSeek(xChave)
			Return .f.
		Endif
		
		Sele SF1
		DbSetOrder(1)
		if DbSeek(xFilial("SF1")+xNota+xSerie+xCliente+xLoja+'D')
			sele SF1
			if DbSeek(xFilial("SF1")+xChave)
				Begin Transaction
				RecLock('SF1',.f.)
				SF1->F1_NOTAS := xNota
				SF1->F1_SERIES:= xSerie
				MsUnlock('SF1')
				End Transaction
				lSair:=.t.
				//				Close(oDlgx)
				Fechar()
			Endif
		Else
			MsgStop('Nota não encontrada!!!')
		Endif
		
	Else
		MsgStop('Nota não encontrada!!!')
		
	Endif
	
Endif

Return .t.
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
Static Function Valida()

if Empty(cNota)
	MsgStop('Informe o nr. da Nota fiscal')
	Return .f.
Endif
lSair:=.t.
//Close(oDlgx)
Fechar()
Return .t.

Static Function Fechar()
oDlgx:End()
Return .t.
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
Static Function GravaDI(cDI,dDtDI,cLocDesemb,cUfDesemb,dDtDesemb, cProcesso)

Local aSegSe2:= SE2->(GetArea())

Begin Transaction
IF RecLock('SF1',.f.)
	SF1->F1_KPROCIMP:= cProcesso
	MsUnlock('SF1')
	
Endif
lSair2:=.T.
oDlgx1:End()
End Transaction

SE2->(DbSetOrder(6))
If(SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC),.T.))
	While ( SE2->( ! Eof() ) .And.;
		SE2->E2_Filial	== xFilial('SE2') .And.;
		SE2->E2_Prefixo == SF1->F1_SERIE .And.;
		SE2->E2_Num		== SF1->F1_DOC .And.;
		SE2->E2_FORNECE == SF1->F1_FORNECE .And.;
		SE2->E2_LOJA	== SF1->F1_LOJA)
		
		RecLock('SE2',.f.)
		SE2->E2_KPROCIM := ' Processo: '+ Alltrim(cProcesso)
		dbselectarea("SA2")
		SA2->(DbSetOrder(1))
		If(SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA),.T.))
			SE2->E2_RUBCOF	:= SA2->A2_RUBCOF
			SE2->E2_RUAGEF	:= SA2->A2_RUAGEF
			SE2->E2_RUDGAGF := SA2->A2_RUDGAGF
			SE2->E2_RUDCCF	:= SA2->A2_RUDCCF
			SE2->E2_RUDGCCF := SA2->A2_RUDGCCF
		Endif
		MsUnlock('SE2')
		SE2->( DbSkip() )
	EndDo
Endif

RestArea(aSegSe2)

Return
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
Static function TrazComprador(cUsr)
Local cComprador:=''
if subs(cUsr,1,1) $ '0/1/2/3/4/5/6/7/8/9/'
	PswOrder(1) //PESQUISA PELO CODIGO
	if PswSeek(Alltrim(cUsr),.t.)
		cComprador :=PswRet(1)[1][2]
	Endif
Else
	PswOrder(2) //PESQUISA PELO NOME
	if PswSeek(Alltrim(cUsr),.t.)
		cComprador :=PswRet(1)[1][2]
	Endif
Endif

Return( cComprador )
//===============================================================================================================================================================================================================================================================
//===============================================================================================================================================================================================================================================================
Static Function GeraINS()
//	Efetua a Geracao dos insumos no Manutenção de Ativos
Local aArea		:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSTJ	:= STJ->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())

Local xCodPro	:= ""
Local xTipoIns	:= ""
Local xUnidIns	:= ""

STJ->(DbSetOrder(1)) //TJ_FILIAL+TJ_ORDEM+TJ_PLANO+TJ_TIPOOS+TJ_CODBEM+TJ_SERVICO+TJ_SEQRELA
SF4->(DbSetOrder(1)) //F4_FILIAL+F4_CODIGO

SD1->(DbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))
	While !SD1->(Eof()) .And. SD1->D1_FILIAL == SD1->(xFilial("SD1")) .And. SD1->D1_DOC = SF1->F1_DOC .And. SD1->D1_SERIE == SF1->F1_SERIE .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SF1->F1_LOJA == SD1->D1_LOJA
		
		If !Empty(SD1->D1_ORDEM)
			If STJ->(DbSeek(xFilial("STJ")+SD1->D1_ORDEM,.F.))
				
				SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES,.F.))
				SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD,.F.))
				
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
				/*23    */Nil,;                //vCalEnd,  //CalEndario
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
		SD1->(DbSkip())
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
