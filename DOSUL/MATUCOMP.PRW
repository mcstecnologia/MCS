#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} MATUCOMP
Ponto de entrada para gravação das tabelas de complemento
@type function
@version  
@author MCS Tecnologia
@since 12/20/2025
@return variant, return_description
/*/
User Function MATUCOMP()

	Local _cTpMov	:= Paramixb[1]
	Local _cSerie 	:= Paramixb[2]
	Local _cDoc   	:= Paramixb[3]
	Local _cCliFor	:= Paramixb[4]
	Local _cLoja  	:= Paramixb[5]
	Local lGeraCDT 	:= .F.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se for nota de entrada, executa a gravação                                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _cTpMov == "E" 
	
		_cDoc := Padr(_cDoc,TamSx3("D1_DOC")[1])
		SD1->(dbSetOrder(RetOrder(,"D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")))
		SD1->(dbSeek(xFilial("SD1")+_cDoc+_cSerie+_cCliFor+_cLoja))
		
		While !SD1->(EoF()) .And.;
				SD1->D1_FILIAL == xFilial("SD1") .And.;
				SD1->D1_DOC ==_cDoc .And.;
				SD1->D1_SERIE == _cSerie .And.;
				SD1->D1_FORNECE == _cCliFor .And.;
				SD1->D1_LOJA == _cLoja
	
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Se for devolução e a nota de origem for diferente de branco, efetiva a gravação    ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SD1->D1_TIPO == 'D' .And. !Empty(SD1->D1_NFORI) 

				DbSelectArea("CDD")
				CDD->(DbSetOrder(1))
				CDD->(DbGoTop())
				
				/*If SubStr(SD1->D1_SERIORI,1,1) == '0'
					cCli    := Posicione("SF2",1,xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI, "F2_CLIENTE")
					cLoj    := Posicione("SF2",1,xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI, "F2_LOJA") 
					cChave  := xFilial("CDD")+_cTpMov+_cDoc+_cSerie+_cCliFor+_cLoja+SD1->D1_NFORI+SD1->D1_SERIORI+cCli+cLoj
				Else
					cChave := xFilial("CDD")+_cTpMov+_cDoc+_cSerie+_cCliFor+_cLoja+SD1->D1_NFORI+SD1->D1_SERIORI+_cCliFor+_cLoja
				EndIf*/
				
				cChave := xFilial("CDD")+_cTpMov+_cDoc+_cSerie+_cCliFor+_cLoja+SD1->D1_NFORI+SD1->D1_SERIORI+_cCliFor+_cLoja
				
				cChvNfe := Posicione("SF2",1,xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI, "F2_CHVNFE")
				
				cInfComplem := "000009"
				
										
				//If ! CDD->(DbSeek(xFilial("CDD")+_cTpMov+_cDoc+_cSerie+_cCliFor+_cLoja+SD1->D1_NFORI+SD1->D1_SERIORI+_cCliFor+_cLoja))		
				If ! CDD->(DbSeek(cChave))
				
					lGeraCDT := .T.
								
					//Gravo Informacoes na CDD				
					CDD->(MsUnLock())
					CDD->(FkCommit())
					
					RecLock("CDD",.T.)
					CDD->CDD_FILIAL := xFilial("CDD")
					CDD->CDD_TPMOV  := ParamIXB[1] //Tipo movimento
					CDD->CDD_DOC    := ParamIXB[3] //Numero do documento digitado
					CDD->CDD_SERIE  := ParamIXB[2] //Serie do documetno digitado
					CDD->CDD_CLIFOR := ParamIXB[4] //Codigo CLI/FOR
					CDD->CDD_LOJA   := ParamIXB[5] //Codigo loja CLI/FOR
					CDD->CDD_DOCREF := SD1->D1_NFORI//Documento Original
					CDD->CDD_SERREF := SD1->D1_SERIORI //Serie documento original
					CDD->CDD_ENTSAI := '2'         //Tipo de Movimento Referenciado 1 = Entrada / 2 = SaÃ­da
					CDD->CDD_CHVNFE := cChvNfe     //Chave eletronica referenciada
					CDD->CDD_IFCOMP := cInfComplem					
					CDD->CDD_PARREF := _cCliFor
					CDD->CDD_LOJREF := _cLoja					
					CDD->(MsUnlock())
					
				Else
					lGeraCDT := .T.
					RecLock("CDD",.F.)
					CDD->CDD_IFCOMP := cInfComplem						
					CDD->(MsUnlock())
																	
				EndIf
			
			
			EndIF

			SD1->(DbSkip())
		
		End
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se gerou CDD, indica que deve gerar CDT, atraves do lGeraCDT ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Retirado lC110113 pois não foi setado em nenhum lugar do fonte.
	If lGeraCDT //.And. lC110113
	
		//Grava na tabela CDT - Informacao Complementar da NF - Reg C110 - Sped Fiscal
		DbSelectArea("CDT")
		CDT->(DbSetOrder(1))
		CDT->(DbGoTop())
		
		If !CDT->(DbSeek(xFilial("CDT")+_cTpMov+_cDoc+_cSerie+_cCliFor+_cLoja))
			
			RecLock("CDT",.T.)
			CDT->CDT_FILIAL := xFilial("CDT")
			CDT->CDT_TPMOV  := _cTpMov
			CDT->CDT_DOC    := _cDoc
			CDT->CDT_SERIE  := _cSerie
			CDT->CDT_CLIFOR := _cCliFor
			CDT->CDT_LOJA   := _cLoja
			CDT->CDT_IFCOMP := cInfComplem
			CDT->CDT_DCCOMP := "DEVOLUCAO DE MERCADORIA"
			CDT->(MsUnlock())
			
		Else
		
			RecLock("CDT",.F.)
			CDT->CDT_IFCOMP := cInfComplem							
			CDT->(MsUnlock())		
			
		EndIf

	EndIf		


Return	
