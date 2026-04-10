#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA330TRB  ºAutor  ³Microsiga           º Data ³  03/24/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para tratar as transferencias internas no processamento  º±±
±±º          ³do Custo Medio.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA330TRB()
************************
Local aArea 	:= GetArea()
Local aSaveTRB	:=TRB->(GetArea())
Local cQuery	:=""
Local cOPAnt	:=""
Local cSequen	:=""
Local dDatade	:=GetMV("MV_ULMES")+1
Local dDataAte	:=LastDay(dDatade)
Local lAjuste	:=.F.
Local lSeq300VD:=SuperGetMV("VD_SEQ300",.F.,.F.)

If lSeq300VD
	
	///TRB_FILIAL, TRB_FILTRA, TRB_ALIAS, TRB_RECNO, TRB_ORDEM, TRB_CHAVE, TRB_NIVEL ,TRB_NIVSD3 ,TRB_COD, TRB_DTBASE, TRB_OP, TRB_CF, TRB_SEQ, TRB_SEQPRO, TRB_DTORIG, TRB_RECSD1, TRB_TES, TRB_DOC, TRB_SERIE, TRB_TIPO, TRB_LOCAL, TRB_RECSBD, TRB_RECTRB, TRB_TIPONF, TRB_QINI, TRB_QUANT, TRB_QFIM, TRB_FLAG, TRB_RNOAUX
	///TRB->(DBSetOrder(7)) /// TRB_FILIAL + TRB_OP + TRB_CF  --> Não seta o indice por OP
	dbSelectArea("TRB")
	dbGoTop()
	//Copy to CUSTOANT // Ajustes realizados para passar no code analisys.
	TRB->(DBSetOrder(0))
	TRB->(dbGoTop())
	
	While TRB->(!Eof())
		//	If Alltrim(TRB->TRB_OP)=="00000901001" .and. Alltrim(TRB->TRB_COD)=="21599"
		lAjuste:=.F.
		If !Empty(TRB->TRB_OP) .and. Subs(TRB->TRB_CF,1,2) $ "/RE/DE/" .and. TRB->TRB_CF<>"RE5"  /// Apropriação direta NF
			
			If TRB->TRB_CF <>"RE0" .and. TRB->TRB_CF <>"DE0".and. TRB->TRB_CF <>"DE6".and. TRB->TRB_CF <>"RE6"
				///			cQuery:=" SELECT TOP 1 D3_OP FROM "+RetSqlTab("SD3")+" WHERE "+RetSqlFil("SD3")+" AND D3_OP='"+TRB->TRB_OP+"' AND D3_EMISSAO BETWEEN "+DTOS(dDatade)+" AND "+DTOS(dDataAte)+" AND D3_CF IN ('RE0','DE0') AND D3_ESTORNO<>'S'   AND "+RetSqlDel("SD3")
				cQuery:=" SELECT TOP 1 D3_OP FROM "+RetSqlTab("SD3")+" WHERE D3_FILIAL ='"+TRB->TRB_FILIAL+"' AND D3_OP='"+TRB->TRB_OP+"' AND D3_CF IN ('RE0','DE0','RE6','DE6') AND D3_ESTORNO<>'S' AND D3_COD NOT LIKE 'MOD%'  AND D3_EMISSAO BETWEEN '"+DTOS(dDatade)+"' AND '"+DTOS(dDataAte)+"'  AND "+RetSqlDel("SD3")
///				cQuery:=" SELECT TOP 1 D3_OP FROM "+RetSqlTab("SD3")+" WHERE D3_FILIAL ='"+TRB->TRB_FILIAL+"' AND D3_OP='"+TRB->TRB_OP+"' AND D3_CF IN ('RE0','DE0','RE6','DE6') AND D3_ESTORNO<>'S' AND D3_COD NOT LIKE 'MOD%'  AND D3_EMISSAO <= '"+DTOS(dDataAte)+"'  AND "+RetSqlDel("SD3")
				
				If Select("TMPTRB2") <> 0
					TMPTRB2->(dbCloseArea())
				End
				DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMPTRB2",.T.,.F.)
				lAjuste:=TMPTRB2->(!Eof())
			Else
				lAjuste:=.T.
			Endif
			
			If  lAjuste
				
				If cOPAnt<>TRB->TRB_OP
					cQuery:=" SELECT TOP 1 D3_NUMSEQ FROM "+RetSqlTab("SD3")+" WHERE D3_FILIAL ='"+TRB->TRB_FILIAL+"' AND D3_OP='"+TRB->TRB_OP+"' AND D3_CF LIKE 'PR%' AND D3_ESTORNO<>'S' AND D3_EMISSAO BETWEEN '"+DTOS(dDatade)+"' AND '"+DTOS(dDataAte)+"'  AND "+RetSqlDel("SD3")+" ORDER BY D3_NUMSEQ "
					//				conout("Query MA330TRB "+cQuery)
					If Select("TMPTRB2") <> 0
						TMPTRB2->(dbCloseArea())
					End
					DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMPTRB2",.T.,.F.)
					cSequen	:=TMPTRB2->D3_NUMSEQ
					cOPAnt	:=TRB->TRB_OP
				Endif
				
				If !Empty(cSequen).and.cOPAnt==TRB->TRB_OP
					Reclock("TRB",.F.)
					///				TRB_SEQ		:=cSequen
					TRB_SEQPRO	:=cSequen
					TRB->(MSUnlock())
				Endif
				
				
			Endif
			
		Endif
	
		If Subs(TRB->TRB_DOC,1,2)=="SK"
			Reclock("TRB",.F.)
			TRB_ORDEM	:="100Z"
			TRB->(MSUnlock())
		Endif
		//	Endif
		TRB->(DBSkip())
	End
	
	dbSelectArea("TRB")
	dbGoTop()
	//Copy to CUSTOAPOS
	
Endif

RestArea(aSaveTRB)
RestArea(aArea)

Return
