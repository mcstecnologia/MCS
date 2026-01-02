#INCLUDE "FONT.CH"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "msole.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TOPCONN.CH"
//#include "MNTA295.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M460NUM   บ Autor ณ Carlos Eduardo     บ Data ณ  19/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracaode dados do pedido de venda                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function M460NUM()
*********************
Local aArea:=SaveArea1({"SC5"})
//Local lPosSC5460:=fPosSC5()
Local lPosSC5460
//Local aPedidos:=PARAMIXB
Local aPedidos := {}
Local aIndPed:={}
Local cNota
Local lMrkPedAlt:=SuperGetMV("VD_MKPDAL",.F.,"/C/D/")

If !IsInCallStack('MATA600')

	aPedidos:=PARAMIXB
	lPosSC5460:=fPosSC5()

	///If SC5->C5_TIPO<>"D".and.SC5->C5_TIPO<>"B" .AND.FunName()<>"VEDJBFAT" .and.!IsBlind()
	If SC5->C5_TIPO<>"D" .AND.FunName()<>"VEDJBFAT" .and.!IsBlind().and.cEmpAnt<>"99" /// Alterado em 12/03/2019.
		U_VDM460NUM(aPedidos,.T.)
		/*   08/03/2018
		ElseIf IsInCallStack("U_VEDJBFAT")
		cNumero:=ZF2->ZF2_DOC
		SX5->(DBSetOrder(1))
		If SX5->(DBSEEK(XFILIAL("SX5")+"01"+CSERIE))
		Reclock("SX5",.F.)
		SX5->X5_DESCRI:=Tira1(SX5->X5_DESCRI)  /// Neste momento o sistema jแ reservou o n๚mero da nota e estแ posicionado com a pr๓xima NF
		SX5->(MSUnlock())
		Endif
		*/
	Endif


	If(lMrkPedAlt)
		aIndPed	:= fIndPed(aPedidos)
		fMrkAltera(aIndPed)
	EndIf

	If Type("__cNDocVd")<>"U"   /// Usado na importa็ใo das notas de Entrada 01 -> Saida 99 (Servitec)
		cNumero:=__cNDocVd
	Endif
EndIf 

RestArea1(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณWillian Wamser Rosa    บ Data ณ 21/08/20บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca os pedidos selecionados como alterado no campo 		  บฑฑ
ฑฑบ          ณC5_ALTERAD.				                          		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMrkAltera(aPedMarc)

	Local i:=1
	Local aPedAnali:={}
	
	While(i<=Len(aPedMarc))
		
		If(aScan(aPedAnali , aPedMarc[i]))=0
			U_C5MrkAlt(aPedMarc[i],'1')
			aadd(aPedAnali , aPedMarc[i] )
		EndIf
		
		i+=1

	EndDO
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณMicrosiga           บ Data ณ  05/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VDM460NUM(aPedidos,lFat, lNota,lOffLine,cSequen)
**************************************************************
Local aSizeAut	 := {}
Local aSave		:=SaveArea1({"SC5","SC6","SC9","SA1","SA3","SA4","SX5"})
Local lPosSC5460:=If(lFat.and.!lOffLine,fPosSC5(),.T.)
Local aObjects 	:={},aPosObj  :={}
Local aSize    	:=MsAdvSize()
Local aInfo    	:={aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
Local cPed 		:= SC5->C5_NUM+If(!Empty(SC9->C9_AGREG),"/"+SC9->C9_AGREG,"")
Local cCli 		:= SC5->C5_CLIENTE
Local cLoja 	:= SC5->C5_LOJACLI
Local cDesCli 	:= If(SC5->C5_TIPO=="B",Posicione("SA2", 1, xFilial("SA2")+cCLi+cLoja, "A2_NOME"),Posicione("SA1", 1, xFilial("SA1")+cCLi+cLoja, "A1_NOME"))
Local cTipoCli 	:= SC5->C5_TIPOCLI
Local aTipoCli 	:= {"F=Cons.Final","L=Prod.Rural","R=Revendedor","S=Solidario","X=Exportacao/Importacao"}
Local cVend 	:= SC5->C5_VEND1
Local cDesVend 	:= Posicione("SA3", 1, xFilial("SA3")+cVend, "A3_NOME")
Local nComis 	:= SC5->C5_COMIS1
Local cTransp 	:= SC5->C5_TRANSP
Local cDesTrans := Posicione("SA4", 1, xFilial("SA4")+cTransp, "A4_NOME")
Local cRedesp 	:= SC5->C5_REDESP
Local cDesRedes := Posicione("SA4", 1, xFilial("SA4")+cRedesp, "A4_NOME")
Local nVlFrete 	:= SC5->C5_FRETE
Local cTpFrete 	:= SC5->C5_TPFRETE
Local aTpFrete 	:= {"C=CIF","F=FOB"}
Local cMsgPad 	:= SC5->C5_MENPAD
Local cMsgNF	:= SC5->C5_MENNOTA
Local cMsgPed 	:= SC5->C5_MENPED
Local aIndPed	:= fIndPed(aPedidos)
Local cEspecie1 := if(Empty(SC5->C5_ESPECI1),"CAIXA(S)",SC5->C5_ESPECI1)
Local lRet		:=.F.
Local cCadastro :="Complemento de NF"
Local aPeso
Local nPesoL
Local nPBruto
Local nVolume1
Local cNota
Local cNumero
Local lTransFil:=Funname()=="MATA310"  .or. Funname()=="VEDTRAFL"  .or. Funname()=="VEDTRAF2"
Local cVeiculo:=SC5->C5_VEICULO
Local cDesVeic := Posicione("DA3", 1, xFilial("DA3")+cVeiculo, "DA3_DESC")
Local aSX501:={}

Default lFat:=.T.
Default lNota:=.T.
Default lOffLine:=.F.
Default cSequen:=SC5->C5_VEICULO

If lFat .or. lOffLine
	aPeso	:= fSomaPeso(aPedidos,aIndPed)
	nPesoL 	:= aPeso[1]
	nPBruto := aPeso[2]
	nVolume1:= aPeso[3]
Endif

If Funname()=="VED172" .or.Funname()=="VEDTRAFL"   .or.  FunName()=="VEDTRAF2"
	CSERIE:="1  "
Endif

If lPosSC5460  .and. Funname()<>"VEDTRAFL"
	/*
	If lOffLine
	cNota := NxtSX5Nota( cSerie , .T. )
	Endif
	*/
	Private oDlgPE460
	
	AADD(aObjects,{100,020,.T.,.F.,.F.})
	AADD(aObjects,{100,100,.T.,.T.,.F.})
	aPosObj:=MsObjSize(aInfo,aObjects)
	aSizeAut	:= MsAdvSize(,.F.,100)
	
	
	DEFINE MSDIALOG oDlgPE460 TITLE cCadastro FROM 0,0 TO (aSize[4]/15),(aSize[3]/5) OF oMainWnd
	DEFINE FONT oFnt NAME "Arial" Size 10,15
	@ 005,005 SAY "Pedido: " SIZE 60,10 OF oDlgPE460 PIXEL
	@ 005,045 MSGET cPed WHEN .F. SIZE  60,10 OF oDlgPE460 PIXEL
	@ 005,110 SAY "Cliente: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 005,155 MSGET cCli WHEN .F. SIZE 50,10 OF oDlgPE460 PIXEL
	@ 005,206 MSGET cLoja WHEN .F. SIZE 10,10 OF oDlgPE460 PIXEL
	@ 005,222 MSGET cDesCli WHEN .F. SIZE 164,10 OF oDlgPE460 PIXEL
	@ 020,005 SAY "Tipo Cliente: "  SIZE 100,10 OF oDlgPE460 PIXEL
	@ 020,045 MSCOMBOBOX oTipoCli VAR cTipoCli WHEN .F. ITEMS aTipoCli Size 60,10 OF oDlgPE460 PIXEL
	@ 020,110 SAY "Vendedor: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 020,155 MSGET cVend WHEN !lFat F3 "SA3"  VALID fValVend(@cDesVend,@nComis,cVend) SIZE 50,10 OF oDlgPE460 PIXEL
	@ 020,206 MSGET cDesVend WHEN .F. SIZE 180,10 OF oDlgPE460 PIXEL
	@ 035,005 SAY "Comissao: " SIZE 60,10 OF oDlgPE460 PIXEL
	@ 035,045 MSGET nComis WHEN .F. PICTURE "@E 99.99" SIZE  50,10 OF oDlgPE460 PIXEL
	@ 035,110 SAY "Transportadora: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 035,155 MSGET cTransp WHEN (!lFat.or.lTransFil) F3 "SA4" VALID fValTransp("T",@cDesTrans,cTransp) SIZE 50,10 OF oDlgPE460 PIXEL
	@ 035,206 MSGET cDesTrans WHEN .F. SIZE 180,10 OF oDlgPE460 PIXEL
	@ 050,005 SAY "Frete: " SIZE 60,10 OF oDlgPE460 PIXEL
	@ 050,045 MSGET nVlFrete PICTURE "@E 99,999,999.99" SIZE  50,10 OF oDlgPE460 PIXEL
	@ 050,110 SAY "Redespacho: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 050,155 MSGET cRedesp F3 "SA4" VALID fValTransp("R",@cDesRedes,cRedesp) SIZE 50,10 OF oDlgPE460 PIXEL
	@ 050,206 MSGET cDesRedes WHEN .F. SIZE 180,10 OF oDlgPE460 PIXEL
	@ 065,005 SAY "Tipo Frete: "  SIZE 100,10 OF oDlgPE460 PIXEL
	@ 065,045 MSCOMBOBOX oTpFrete VAR cTpFrete ITEMS aTpFrete Size 60,10 OF oDlgPE460 PIXEL
	@ 065,110 SAY "Mens.Pedido: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 065,155 MSGET cMsgPed SIZE 231,10 OF oDlgPE460 PIXEL
	@ 080,110 SAY "Mens.Nota Fiscal: "  SIZE 60,10 OF oDlgPE460 PIXEL
	@ 080,155 MSGET cMsgNF SIZE 231,10 OF oDlgPE460 PIXEL
	@ 080,005 SAY "Mens.Padrao: " SIZE 60,10 OF oDlgPE460 PIXEL
	@ 080,045 MSGET cMsgPad F3 "SM4" VALID fValMsgPad(cMsgPad) SIZE  50,10 OF oDlgPE460 PIXEL
	@ 125,110 SAY "Veํculo: " SIZE 60,10 OF oDlgPE460 PIXEL
	@ 125,155 MSGET cVeiculo F3 "DA3" VALID fValVeic("R",@cDesVeic,cVeiculo) SIZE 50,10 OF oDlgPE460 PIXEL
	@ 125,206 MSGET cDesVeic WHEN .F. SIZE 180,10 OF oDlgPE460 PIXEL
	
	If 	lFat .or. lOffLine
		
		@ 095,005 SAY "Peso Bruto: " SIZE 60,10 OF oDlgPE460 PIXEL
		@ 095,045 MSGET nPBruto PICTURE "@E 99,999.999" SIZE  50,10 OF oDlgPE460 PIXEL //THADOR
		@ 095,110 SAY "Peso Liq.: " SIZE 60,10 OF oDlgPE460 PIXEL
		@ 095,155 MSGET nPesoL PICTURE "@E 99,999.999" SIZE  50,10 OF oDlgPE460 PIXEL //THAGOR
		
		@ 110,005 SAY "Volume: " SIZE 60,10 OF oDlgPE460 PIXEL
		@ 110,045 MSGET nVolume1 PICTURE "@E 99999" SIZE  50,10 OF oDlgPE460 PIXEL
		@ 110,110 SAY "Especie: " SIZE 60,10 OF oDlgPE460 PIXEL
		@ 110,155 MSGET cEspecie1 PICTURE SIZE  60,10 OF oDlgPE460 PIXEL
		
	Endif
	
	If lNota

		aSX501:=U_SX5RETRG("01", CSERIE,"pt-br", xFilial("SX5"))

		If(Len(aSX501)>0)
			cNota:=Alltrim(aSX501[4])  /// Neste momento o sistema jแ reservou o n๚mero da nota e estแ posicionado com a pr๓xima NF
			cNota:=Tira1(cNota)
			@ 125,005 SAY "Nota Fiscal: " SIZE 60,10 OF oDlgPE460 PIXEL
			@ 125,045 MSGET cNota WHEN .F. PICTURE SIZE  60,10 OF oDlgPE460 PIXEL
		EndIF

		/*SX5->(DBSetOrder(1))
		If SX5->(DBSEEK(XFILIAL("SX5")+"01"+CSERIE))
			cNota:=Alltrim(SX5->X5_DESCRI)  /// Neste momento o sistema jแ reservou o n๚mero da nota e estแ posicionado com a pr๓xima NF
			cNota:=Tira1(cNota)
			@ 125,005 SAY "Nota Fiscal: " SIZE 60,10 OF oDlgPE460 PIXEL
			@ 125,045 MSGET cNota WHEN .F. PICTURE SIZE  60,10 OF oDlgPE460 PIXEL
		Endif*/
		
		/*
		ElseIf lOffLine
		@ 125,005 SAY "Nota Fiscal: " SIZE 60,10 OF oDlgPE460 PIXEL
		@ 125,045 MSGET cNota WHEN .F. PICTURE SIZE  60,10 OF oDlgPE460 PIXEL
		*/
	Endif
	
	@ 140,005 BUTTON "Ok" SIZE 40,10  OF oDlgPE460 PIXEL ACTION lRet:=fCloseDlg(.T.)
	
	If !lFat
		@ 140,050 BUTTON "Sair" SIZE 40,10 OF oDlgPE460 PIXEL ACTION lRet:=fCloseDlg(.F.)  /// Op็ใo Sair neste caso nใo cancela a opera็ใo pois PE nใo tem retorno cancelando a gera็ใo da NF
	Endif
	
	ACTIVATE DIALOG oDlgPE460 CENTERED
	
	
	If lRet
		
		
		If lFat
			fZeraPesos(SC5->C5_NUM, cRedesp, cTpFrete, cEspecie1,aIndPed)  //// Zera todos os pesos e volumes dos pedidos selecionados para que apenas o primeiro componha os valores confirmados na NF
		Endif
		
		RecLock("SC5", .F.)
		
		SC5->C5_TRANSP 	:= cTransp
		SC5->C5_VEND1 	:= cVend
		SC5->C5_REDESP 	:= cRedesp
		SC5->C5_FRETE 	:= nVlFrete
		SC5->C5_TPFRETE := cTpFrete
		SC5->C5_MENPAD 	:= cMsgPad
		SC5->C5_MENPED 	:= cMsgPed
		SC5->C5_MENNOTA := cMsgNF
		SC5->C5_PBRUTO  := nPBruto
		SC5->C5_PESOL   := nPesoL
		SC5->C5_VOLUME1 := nVolume1
		SC5->C5_ESPECI1 := cEspecie1
		SC5->C5_VEICULO := cVeiculo
		
		SC5->(MsUnlock())
		
		If lOffLine
			
			RecLock("ZF2", .T.)
			
			ZF2->ZF2_FILIAL := xFilial("ZF2")
			ZF2->ZF2_SEQUEN := cSequen
			ZF2->ZF2_TRANSP := cTransp
			ZF2->ZF2_DATA 	:= DDATABASE
			ZF2->ZF2_VEND1 	:= cVend
			ZF2->ZF2_REDESP := cRedesp
			ZF2->ZF2_FRETE 	:= nVlFrete
			ZF2->ZF2_TPFRET := cTpFrete
			ZF2->ZF2_MENPAD	:= cMsgPad
			ZF2->ZF2_MENPED	:= cMsgPed
			ZF2->ZF2_MENNOT := cMsgNF
			ZF2->ZF2_PBRUTO := nPBruto
			ZF2->ZF2_PESOL  := nPesoL
			ZF2->ZF2_VOL1 	:= nVolume1
			ZF2->ZF2_ESP1 	:= cEspecie1
			ZF2->ZF2_USER 	:= PSWRet()[1][2]
			/*
			ZF2->ZF2_DOC 	:= cNota
			ZF2->ZF2_SERIE 	:= cSerie
			*/
			
			ZF2->(MsUnlock())
			
		Endif
	Endif
	
	oDlgPE460:=nil
	RestArea1(aSave)
	
Endif

//Conout("Final Chamada M460NUM gera็ใo NF "+FunName()+"  "+Time())
FWLogMsg("INFO", /*cTransactionId*/, "VED170", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Final Chamada M460NUM gera็ใo NF "+FunName()+"  "+Time(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณMicrosiga           บ Data ณ  04/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// Validacao de vendedor
Static Function fValVend(cDesVend,nComis,cVend)
***********************************************
If Empty(cVend)
	cDesVend := ""
	nComis := 0
	Return .T.
EndIf

dbSelectArea("SA3")
dbSetOrder(1)
dbGoTop()
If !dbseek(xFilial("SA3")+cVend)
	Alert("Vendedor nao cadastrado")
	Return .F.
EndIf

cDesVend := SA3->A3_NOME
nComis := SA3->A3_COMIS

Return .T.

// Validacao de transportadora/redespacho
Static Function fValTransp(cCampo,cNome,cCod)
*********************************************
Local lRet:=.f.

SA4->(DBSetOrder(1))

If Empty(cCod)
	cNome := ""
	lRet:=.T.
ElseIf SA4->(dbseek(xFilial("SA4")+cCod))
	cNome := SA4->A4_NOME
	lRet:=.T.
Else
	Alert(cCod + " nao cadastrado")
	lRet:=.F.
Endif

Return lRet

// Validacao de Veiculo
Static Function fValVeic(cCampo,cNome,cCod)
*********************************************
Local lRet:=.f.

DA3->(DBSetOrder(1))

If Empty(cCod)
	cNome := ""
	lRet:=.T.
ElseIf DA3->(dbseek(xFilial("DA3")+cCod))
	cNome := DA3->DA3_DESC
	lRet:=.T.
Else
	Alert(cCod + " nใo cadastrado")
	lRet:=.F.
Endif

Return lRet

// Validacao de mensagem padrao
Static Function fValMsgPad(cMsgPad)
***********************************
If Empty(cMsgPad)
	Return .T.
EndIf

dbSelectArea("SM4")
dbSetOrder(1)
dbGoTop()
If !dbseek(xFilial("SM4")+cMsgPad)
	Alert("Mensagem padrao nao cadastrado")
	Return .F.
EndIf

Return .T.

Static function fCloseDlg(lRet)
******************************

oDlgPE460:end()

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณMicrosiga           บ Data ณ  04/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function fPosSC5()
**************************
Local lRet:=.F.
Local nPosSC9:=PARAMIXB[1][8]  /// Registro SC9


SC9->(DBGOTO(nPosSC9)) /// Posiciona no primeiro registro da SC9 que estแ sendo faturada

SC5->(DBSetOrder(1))
lRet:=SC5->(DBSeek(xFilial("SC5")+SC9->C9_PEDIDO))

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณFabricio Cargnin    บ Data ณ  04/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca peso separado do pedido (Z06)                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSomaPeso(aPedidos,aIndPed)
******************************************
Local aPeso
Local cQuery
Local i

cQuery  := " SELECT COUNT(*) CONT, SUM(Z06_PESOL) Z06_PESOL,  SUM(Z06_PESOB) Z06_PESOB "
cQuery  += "  FROM (SELECT DISTINCT Z06_PEDIDO, Z06_CAIXA, Z06_PESOL, Z06_PESOB FROM "+RetSqlTab("Z06")
cQuery  += " WHERE "
cQuery  += "  "+RetSqlFil("Z06")+ " AND Z06_NF=' ' AND "

cQuery	+="   Z06_PEDIDO IN (  "
cQuery	+="'"+aIndPed[1]+"'"
For i:=2 to len(aIndPed)
	cQuery	+=",'"+aIndPed[i]+"'"
Next i
cQuery	+="  ) AND "

cQuery	+="   Z06_PEDIDO+Z06_PRODUT IN (  "
cQuery	+="'"+aPedidos[1][1]+aPedidos[1][6]+"'"
For i:=2 to len(aPedidos)
	cQuery	+=",'"+aPedidos[i][1]+aPedidos[i][6]+"'"
Next i
cQuery	+="  ) AND "

/*
cQuery	+="   Z06_PEDIDO IN (  "
cQuery += "SELECT DISTINCT C9_PEDIDO "
cQuery += " FROM " + RetSqlName("SC9") + " C9 (NOLOCK) "
cQuery += " WHERE C9.C9_FILIAL='" + xFilial("SC9") + "' "
cQuery +=   " AND C9.C9_PEDIDO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery +=   " AND C9.C9_CLIENTE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery +=   " AND C9.C9_LOJA BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQuery +=   " AND C9.C9_DATALIB BETWEEN '" + dTos(MV_PAR11) + "' AND '" + dTos(MV_PAR12) + "' "
cQuery +=   " AND C9.C9_NFISCAL='" + Space(TamSX3("C9_NFISCAL")[1]) + "' "
cQuery +=   " AND C9.C9_BLEST='" + Space(TamSX3("C9_BLEST")[1]) + "' "
cQuery +=   " AND C9.C9_BLCRED='" + Space(TamSX3("C9_BLCRED")[1]) + "' AND C9_VDLIBES='S' "
cQuery +=   " AND NOT C9.D_E_L_E_T_='*' ) AND "
*/

cQuery  += " Z06_AGREG='"+SC9->C9_AGREG+"'  AND "
cQuery  += "  "+RetSqlDel("Z06")+" "
cQuery  += "  ) TABAUX "


If Select("QRYZ06") <> 0
	QRYZ06->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "QRYZ06"

aPeso:={QRYZ06->Z06_PESOL,QRYZ06->Z06_PESOB,QRYZ06->CONT}

QRYZ06->(dbCloseArea())

Return aPeso


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณFabricio Cargnin    บ Data ณ  05/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณZera pedos dos demais pedidos envolvidos no faturamento     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fZeraPesos(cNum, cRedesp, cTpFrete, cEspecie1,aIndPed)
**********************************************************************
Local cQuery
Local aSave:=SC5->(GetArea())
Local i
/*

If Funname()<>"VED172"

///	Pergunte("MT461A",.F.)  /// Carrega perguntas iniciais do IndRegua

cQuery := "SELECT DISTINCT C9_PEDIDO "
cQuery += " FROM " + RetSqlName("SC9") + " C9 (NOLOCK) "
cQuery += " WHERE C9.C9_FILIAL='" + xFilial("SC9") + "' "
cQuery	+= " AND C9_PEDIDO IN ('"+aIndPed[1]+"'"
For i:=2 to len(aIndPed)
cQuery	+=",'"+aIndPed[i]+"'"
Next i
cQuery	+= " ) "
cQuery +=   " AND C9.C9_PEDIDO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery +=   " AND C9.C9_CLIENTE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery +=   " AND C9.C9_LOJA BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
cQuery +=   " AND C9.C9_DATALIB BETWEEN '" + dTos(MV_PAR11) + "' AND '" + dTos(MV_PAR12) + "' "
If __VD_lInve
cQuery +=   " AND NOT C9.C9_OK='" + __VD_cMarc + "' "
Else
cQuery +=   " AND C9.C9_OK='" + __VD_cMarc + "' "
Endif
cQuery +=   " AND C9.C9_NFISCAL='" + Space(TamSX3("C9_NFISCAL")[1]) + "' "
cQuery +=   " AND C9.C9_BLEST='" + Space(TamSX3("C9_BLEST")[1]) + "' "
cQuery +=   " AND C9.C9_BLCRED='" + Space(TamSX3("C9_BLCRED")[1]) + "' AND C9_VDLIBES='S' "
cQuery +=   " AND C9_PEDIDO<>'"+cNum+"' "
cQuery +=   " AND NOT C9.D_E_L_E_T_='*' "

///	Pergunte("MT460A",.F.) /// Recarrega perguntas do faturamento

If Select("QRYSC9") <> 0
QRYSC9->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "QRYSC9"

SC5->(DBSetOrder(1))

While QRYSC9->(!Eof())

If SC5->(DBSeek(xFilial("SC5")+QRYSC9->C9_PEDIDO))
Reclock("SC5",.F.)
SC5->C5_PBRUTO  := 0
SC5->C5_PESOL   := 0
SC5->C5_VOLUME1 := 0
SC5->C5_ESPECI1 := ""
SC5->C5_REDESP 	:= cRedesp
SC5->C5_TPFRETE := cTpFrete
SC5->C5_ESPECI1 := cEspecie1
SC5->(MSUnlock())

Endif

QRYSC9->(!DBSkip())
End

Else
*/

For i:=1 to len(aIndPed)
	If aIndPed[i]<>cNum
		If SC5->(DBSeek(xFilial("SC5")+aIndPed[i]))
			Reclock("SC5",.F.)
			SC5->C5_PBRUTO  := 0
			SC5->C5_PESOL   := 0
			SC5->C5_VOLUME1 := 0
			SC5->C5_ESPECI1 := ""
			SC5->C5_REDESP 	:= cRedesp
			SC5->C5_TPFRETE := cTpFrete
			SC5->C5_ESPECI1 := cEspecie1
			SC5->(MSUnlock())
		Endif
	Endif
Next i


///Endif

RestArea(aSave)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460NUM   บAutor  ณFabricio Cargnin    บ Data ณ  08/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna Array com pedidos distintos                         บฑฑ
ฑฑบ          ณPARAMIXB retorna array com pedido + item                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fIndPed(aPedidos)
*********************************
Local aIndPed:={}
Local i
Local nPos

For i:=1 to len(aPedidos)
	nPos := aScan(aIndPed , aPedidos[i][1] )
	If nPos==0
		aadd(aIndPed,aPedidos[i][1])
	Endif
Next i

Return aIndPed
