#include 'totvs.ch'

/*/{Protheus.doc} MTA416PV
PONTO DE ENTRADA: Utilizado para realizar gravacao de campos personalizados do orcamento para o pedido de venda.
@author Edi Nei Goetz
@since 21/03/2005
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function MTA416PV()
	Local	_aAreaSE4	:= SE4->(GetArea())
	Local	_nConta		:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_CONTA'})
	Local	_nEquiv		:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_EQUIV'})
	Local	_nCFOP		:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_CF'})
	Local	_nItemCli	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_ITEMPC'})
	Local	_nOrcCli	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_NUMPCOM'})
	Local	_nPClFis	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_CLASFIS'})
	Local	_nPosLoc	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_LOCAL'})
	Local	nCodServ	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_SERVIC'})
	Local	nEndPad		:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_ENDPAD'})
	Local   nTESProd	:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_TES'})
	Local 	nPrUnit		:= aScan(_aHeader,{|x| Alltrim(x[2])=='C6_PRUNIT'})
	Local	nPRtpmm		:= 0 
	Local 	_nLin		:= ParamIXB
	Local 	nPrzEnt       := SuperGetMV("RT_PRZENT",.F.,5)

	// TSCC22
	Local lIntGFE       := SuperGetMv( "MV_INTGFE", .F., .F. )
	//Local	lMVLOCALIZ	:= IIf(AllTrim(GetNewPar("MV_LOCALIZ","N")) == "S",.T.,.F.)

	// Adicionado por solicitado do Landoaldo, para mostrar no orcamento o tipo de frete
	// Esse trecho abaixo foi inserido para levar para o Pedido a negociacao do orcamento.

	If	SCJ->(FieldPos("CJ_TPFRETE"))<>0
		M->C5_TPFRETE := SCJ->CJ_TPFRETE
		//VENDA PRESENCIAL
		If SCJ->CJ_TPFRETE == "S" .and. SCJ->CJ_ENTLOCA == "S"
			M->C5_INDPRES			:= "1"
			M->C5_FRETE 			:= 0
			M->C5_ENTLOCA 			:= "S"
			_aCols[_nLin][_nCFOP]	:= Posicione("SF4",1,xFilial("SF4")+_aCols[_nLin][nTESProd],"F4_CF")
		EndIf
	EndIf

	If	SCJ->(FieldPos("CJ_TRANSUG"))<>0
		M->C5_TRANSUG := SCJ->CJ_TRANSUG
	EndIf

	If	SCJ->(FieldPos("CJ_TRANSUG"))<>0 .and. SCJ->(FieldPos("CJ_PRIORI"))<>0
		If SCJ->CJ_PRIORI == "3"
			M->C5_TRANSP := SCJ->CJ_TRANSUG
		EndIf 
	EndIf

	If	SCJ->(FieldPos("CJ_PRAZENT"))<>0
		//M->C5_PRAZENT := SCJ->CJ_PRAZENT
		//Tratamento para previsão de entrega 
		If (SCJ->CJ_PRAZENT - dDatabase) < nPrzEnt
			M->C5_FECENT := dDataBase + nPrzEnt
		Else 
			M->C5_FECENT := SCJ->CJ_PRAZENT 
		EndIf

	EndIf

	If	SCJ->(FieldPos("CJ_DATAFIX"))<>0
		M->C5_DATAFIX := SCJ->CJ_DATAFIX
	EndIf

	If	SCJ->(FieldPos("CJ_PRIORI"))<>0
		M->C5_PRIORI := SCJ->CJ_PRIORI
	EndIf

	//Leva o acrescimo financeiro do orcamento
	If	SCJ->(FieldPos("CJ_ACRSFIN")) > 0 
		M->C5_ACRSFIN := SCJ->CJ_ACRSFIN
	Else
		DbSelectArea("SE4")
		SE4->(DbSetOrder(1))
		If	SE4->(DbSeek(xFilial("SE4")+SCJ->CJ_CONDPAG))
			M->C5_ACRSFIN := SE4->E4_ACRSFIN
		EndIf
	EndIf
	
	//Atualiza a filial origem que está sendo gerado o pedido
	M->C5_MSFIL	:= SCJ->CJ_MSFIL
	
	//Atualiza a rotina de origem que gerou o PV
	M->C5_ORIGEM := "MATA415"

    // Verifica a tabela de venda
    If SCJ->CJ_MSFIL <> cFilAnt
        // Verifica novo controle de preço por tabela
        If SuperGetMv("RC_NEWPRC",.F.,.F.,cFilAnt)
            M->C5_TABELA     := u_RtTabCli(xFilial("DA1"),M->C5_CLIENTE,M->C5_LOJACLI,SCJ->CJ_TABELA)
        EndIf
    EndIf

	// Ajusta o codigo do produto / equivalente / solicitado x vendido.
	_aCols[_nLin][_nEquiv]	:= SCK->CK_EQUIV // Grava produto equivalente
	_aCols[_nLin][_nItemCli]:= SCK->CK_ITECLI //Grava o item do orçamento do cliente
	_aCols[_nLin][_nOrcCli]	:= SCK->CK_COTCLI //Grava o numero do orçamento do cliente
	_aCols[_nLin][_nConta]	:= IIf(!Empty(AllTrim(SCK->CK_CONTA)),SCK->CK_CONTA,Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_CONTA"))
	_aCols[_nLin][nPrUnit]	:= SCK->CK_PRUNIT //Grava preço de lista do orçamento

	//Preço mínimo
	If SCK->(FieldPos("CK_RTPMM")) > 0
		nPRtpmm := aScan(_aHeader,{|x| Alltrim(x[2])=='C6_RTPMM'})
		_aCols[_nLin][nPRtpmm]	:= IIf(SCK->CK_RTPMM > 0,SCK->CK_RTPMM,Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_RTPMM")) 
	EndIf

	//WMS ATIVO
	If Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_ESTOQUE") = 'S'
		If Empty(Alltrim(nCodServ))
			_aCols[_nLin][nCodServ]	:= u_RtWServc(SCK->CK_PRODUTO)
			If !Empty(Alltrim(_aCols[_nLin][nCodServ]))
				_aCols[_nLin][nEndPad]	:= "DOCA01"
			EndIf
		EndIf
	EndIf

	// Atualiza a classificação fiscal caso esteja diferente (errada) - adicionado por Tiago Leão
	SB1->(DbSetOrder(1))
	SF4->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1')+SCK->CK_PRODUTO))
		If SF4->(DbSeek(xFilial('SF4')+SCK->CK_TES))
			_aCols[_nLin][_nPClFis]:= U_RtDefCst(SB1->B1_ORIGEM+SF4->F4_SITTRIB,_aCols[_nLin][_nPosLoc],SB1->B1_POSIPI,SB1->B1_ORIGEM,SB1->B1_EX_NCM,SB1->B1_COD)
		EndIf
	EndIf

	// Adicionado em 15/10/15 - Luis Robusto
	// Apos problema com liberacao de pedido quando esta configurado liberacao por pedido, ajustado
	// nao estava respeitando o C5_TIPLIB (inicialiador padrão) por item
	// 08/02 - Lucas Schoeffel - Modificado para liberaçao por pedido (2) para testes. 

	M->C5_TIPLIB := "2" // Liberacao por pedido.

	M->C5_VEND1 := SCJ->CJ_VEND1
	M->C5_VEND2 := SCJ->CJ_VEND2
	M->C5_VEND3 := SCJ->CJ_VEND3

	// TSCC22
	If lIntGFE

		If !A416ValidaCamposRedespacho()

			FWAlertInfo( "Campos do Redespacho inconsistentes")
		EndIf

		// Já está sendo levado " por padrão "
		If  .F.  .and.  SCJ->CJ_TPFRETE == "C"
		
			M->C5_FRETE := SCJ->CJ_FRETE
		EndIf

	EndIf

	// copia numero do pedido Pieta
	If SCJ->(FieldPos("CJ_XNPIETA")) != 0
		M->C5_XNPIETA := SCJ->CJ_XNPIETA
	EndIf

	// Restaura a area anterior
	RestArea(_aAreaSE4)

Return

/*/{Protheus.doc} A416ValidaCamposREDESacho
@author TSCC22 - Luciano Souza
@since 
@version 1.0

	Efetuado ajuste nos campos do redespacho 1 - TSCC22 - 15/09/2021
	
/*/
Static Function A416ValidaCamposRedespacho()
Local lRetorno        := .T.
Local nCntFor         := 1

	For nCntFor := 1 To 5

		lCampoOk := SCJ->(ColumnPos( 'CJ_REDESP' + Str( nCntFor, 1 ) )) > 0  .and. ;
					SCJ->(ColumnPos( 'CJ_TFRDP'  + Str( nCntFor, 1 ) )) > 0  .and. ;
					SCJ->(ColumnPos( 'CJ_ESTRDP' + Str( nCntFor, 1 ) )) > 0  .and. ;
					SCJ->(ColumnPos( 'CJ_CMURDP' + Str( nCntFor, 1 ) )) > 0

		Do Case
		case nCntFor = 1  .and.  lCampoOk
			M->C5_REDESP  := SCJ->CJ_REDESP1
			M->C5_TFRDP1  := SCJ->CJ_TFRDP1
			M->C5_ESTRDP1 := SCJ->CJ_ESTRDP1
			M->C5_CMURDP1 := SCJ->CJ_CMURDP1

		case nCntFor = 2  .and.  lCampoOk
			M->C5_REDESP2 := SCJ->CJ_REDESP2
			M->C5_TFRDP2  := SCJ->CJ_TFRDP2
			M->C5_ESTRDP2 := SCJ->CJ_ESTRDP2
			M->C5_CMURDP2 := SCJ->CJ_CMURDP2

		case nCntFor = 3  .and.  lCampoOk
			M->C5_REDESP3 := SCJ->CJ_REDESP3
			M->C5_TFRDP3  := SCJ->CJ_TFRDP3
			M->C5_ESTRDP3 := SCJ->CJ_ESTRDP3
			M->C5_CMURDP3 := SCJ->CJ_CMURDP3

		case nCntFor = 4  .and.  lCampoOk
			M->C5_REDESP4 := SCJ->CJ_REDESP4
			M->C5_TFRDP4  := SCJ->CJ_TFRDP4
			M->C5_ESTRDP4 := SCJ->CJ_ESTRDP4
			M->C5_CMURDP4 := SCJ->CJ_CMURDP4

		case nCntFor = 5  .and.  lCampoOk
			M->C5_REDESP5 := SCJ->CJ_REDESP5
			M->C5_TFRDP5  := SCJ->CJ_TFRDP5
			M->C5_ESTRDP5 := SCJ->CJ_ESTRDP5
			M->C5_CMURDP5 := SCJ->CJ_CMURDP5
		EndCase
	Next nCntFor

Return lRetorno


