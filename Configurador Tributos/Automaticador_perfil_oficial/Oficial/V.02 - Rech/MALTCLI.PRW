#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MALTCLI  ºAutor ³Luis Henrique Robustoº Data ³  21/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA: Apos alteracao do cadastro do cliente    º±±
±±º          ³ Usado para ajustar o item contabil.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MALTCLI()
	Local	_aAreaSA1	:= SA1->(GetArea())
	Local	_cRetItem	:= ""

		//Chamada MCS para o automatizador
			U_MCSTRIB()


		// Chama rotina especifica para excluir item contabil caso seja possivel ser feita essa operacao.
		_cRetItem := U_CTB007B("CLI"+SubStr(SA1->A1_COD,1,6),SA1->A1_NOME)
		If	! Empty(_cRetItem)
			If	RecLock("SA1",.F.)
				Replace SA1->A1_ITEM	With _cRetItem
				SA1->(MsUnLock())
			EndIf
		EndIf
		
		// Atualiza a regiao do cliente.
		//private M->A1_EST	:= SA1->A1_EST
		//private M->A1_MUN	:= SA1->A1_MUN
		//private M->A1_CEP	:= SA1->A1_CEP
		//private M->A1_CEPC	:= SA1->A1_CEPC
		// M->A1_REGIAO:= SA1->A1_REGIAO
		

		U_FAT013B()
		If	RecLock("SA1",.F.)
			Replace SA1->A1_REGIAO With M->A1_REGIAO
			SA1->(MsUnLock())
		Endif

		// Verifica o codigo DIEF do municipio (exclusivo - Para)
		If	SA1->A1_EST == "PA"
			// Cria uma variavel para controlar o codigo do municipio para DIEF (localizando do cadastro de municipios do IBGE)
			Private _cCodDief	:= Space(TamSx3("A1_DIEF")[1])
			// Posiciona no cadastro de municipios para localizar o codigo
			DbSelectArea("CC2")
			CC2->(DbSetOrder(1)) // FILIAL + EST + COD_MUN
			// Verifica se encontra o municipio
			If	CC2->(DbSeek(xFilial("CC2")+SA1->A1_EST+SA1->A1_COD_MUN))
				_cCodDief := CC2->CC2_DIEF
			EndIf
			// Atualiza no Cadastro
			If	RecLock("SA1",.F.)
				Replace SA1->A1_DIEF	With _cCodDief
				SA1->(MsUnLock())
			EndIf
		EndIf
		
		If	RecLock("SA1",.F.)
			Replace SA1->A1_NOME 	With  Alltrim(StrTran(SA1->A1_NOME, Chr(09) , "" ))
			Replace SA1->A1_NREDUZ 	With  Alltrim(StrTran(SA1->A1_NREDUZ, Chr(09) , "" ))
			Replace SA1->A1_END 	With  Alltrim(StrTran(SA1->A1_END, Chr(09) , "" ))
			Replace SA1->A1_COMPLEM With  Alltrim(StrTran(SA1->A1_COMPLEM, Chr(09) , "" ))
			Replace SA1->A1_BAIRRO 	With  Alltrim(StrTran(SA1->A1_BAIRRO, Chr(09) , "" ))
			Replace SA1->A1_BAIRRO 	With  Alltrim(StrTran(SA1->A1_BAIRRO, Chr(09) , "" ))
			Replace SA1->A1_TEL 	With  Alltrim(SA1->A1_TEL)
			Replace SA1->A1_EMAIL 	With  Alltrim(SA1->A1_EMAIL)
			SA1->(MsUnLock())
		EndIf
		
		U_MA030EMPFIL(SA1->A1_COD, SA1->A1_LOJA)

		RestArea(_aAreaSA1) 

Return

User Function MA030EMPFIL(_cCliente, _cLoja)
Local	_oWinUpdCLi
Local	_nOpcX		:= 0
Local	_cCodEmp
Local	_cCodFil
Local	_cNomeFil
Local	_lWhenCpo	:= .f.
Local	_lReturn    := .T.
		
		DbSelectArea("SA1")
		SA1->(DBSetOrder(1))
		DbSeek(xFilial("SA1")+_cCliente+_cLoja)
		
		_cCodEmp	:= SA1->A1_MSEMP
		_cCodFil	:= SA1->A1_MSFIL
		_cNomeFil	:= FWFilName(_cCodEmp,_cCodFil)
		
//		If Alltrim(_cCodEmp) = '09'
//			If !U_RtCheckE("EV_ANA_FIN_FUNC_MESA_CREDITO",.f.,,"09")
//				Return .t.
//			EndIf
//		EndIf
		If	IsInCallStack('U_RtCenCrd')
			_lWhenCpo := U_RtCheckE("EV_ANA_FIN_FUNC_MESA_CREDITO",.f.) 
		Else
			_lWhenCpo := U_RtCheckE("EV_ANA_FIN_FUNC_MESA_CREDITO",.f.) .and. (INCLUI .OR. ALTERA)
		EndIf
		
		
		// Janela para definicao do usuario.
		If	( _lWhenCpo .AND. !isBlind())
			DEFINE MSDIALOG _oWinUpdCLi TITLE OemToAnsi('Determinação de Empresa e Filial de Origem') From 10,00 To 25,38 OF oMainWnd
			@ 005,005 To 080, 146 Of _oWinUpdCLi Pixel
			@ 010,015 Say OemToAnsi('Informe abaixo a Empresa e Filial ') Of _oWinUpdCLi Pixel
			@ 020,015 Say OemToAnsi('Responsável pelo cadastro deste Cliente.') Of _oWinUpdCLi Pixel
			//@ 035,015 Say OemToAnsi('Empresa:') Of _oWinUpdCLi Pixel
			//@ 033,050 MsGet _cCodEmp When .F. Picture ('@!') Valid U_RtExistEmp(_cCodEmp,_cCodFil,1) Size 035, 009 Of _oWinUpdCLi F3 "QM0" Pixel
			@ 050,015 Say OemToAnsi('Filial:') Of _oWinUpdCLi Pixel
			@ 048,050 MsGet _cCodFil When _lWhenCpo Picture ('@!') Valid U_RtExistEmp(_cCodEmp,_cCodFil,2) Size 035, 009 Of _oWinUpdCLi Pixel 
			@ 065,015 Say OemToAnsi('Nome:') Of _oWinUpdCLi Pixel
			@ 065,050 Say FWFilialName(_cCodEmp,_cCodFil) Of _oWinUpdCLi Pixel
			DEFINE SBUTTON FROM 095, 050 TYPE 01 ACTION Iif(U_RtExistEmp(_cCodEmp,_cCodFil,2).and._cCodFil<"50".and.VldFilEmp(_cCodFil),(_nOpcX:=1,_oWinUpdCLi:End()),nil) ENABLE Of _oWinUpdCLi
			DEFINE SBUTTON FROM 095, 080 TYPE 02 ACTION (_nOpcX:=0,_oWinUpdCLi:End()) ENABLE Of _oWinUpdCLi
			ACTIVATE MSDIALOG _oWinUpdCLi CENTERED
		EndIf

		// Salva os dados ajustados em variavel de memoria, aguardando o usuario confirmar as alteracoes do cliente.
		// Foi necessario fazer isso porque nao teve jeito de colocar o campo _MSFIL para aparecer para o usuario.
		If	( _lWhenCpo ) .and. ( _nOpcX == 1 )
			// Se for alterado, salva log da pessa que fez a alteração e os dados
			If SA1->A1_MSEMP <> _cCodEmp .or. SA1->A1_MSFIL <> _cCodFil
				If	RecLock("Z82",.T.)
					Replace Z82->Z82_ARQUIV	With "SA1040"
					Replace Z82->Z82_CAMPO	With "A1_MSFIL"
					Replace Z82->Z82_ROTINA	With "MA030EMPFIL"
					Replace Z82->Z82_USER		With U_RtGetName(RetCodUsr())
					Replace Z82->Z82_DATA		With dDataBase
					Replace Z82->Z82_HORA		With Time()
					Replace Z82->Z82_ANTES	With SA1->A1_MSEMP + "/" + SA1->A1_MSFIL
					Replace Z82->Z82_DEPOIS	With _cCodEmp + "/" + _cCodFil
					Z82->( MsUnLock() )
				EndIf
			EndIf
			//Atualiza Empresa e Filial.
			If	RecLock("SA1",.F.)
				Replace SA1->A1_MSEMP	With	_cCodEmp
				Replace SA1->A1_MSFIL	With  	_cCodFil
				//Deve ser alterado a variável de memória para funcionar via solicitação de crédito.
				M->A1_MSFIL := _cCodFil
				SA1->(MsUnLock())
			EndIf
			MsgInfo("Registro de Empresa/Filial de Origem do Cadastro de cliente, foi incluido para: " + _cCodEmp + " - " + _cCodFil)
		EndIf

Return _lReturn   

/*/{Protheus.doc} VldFilEmp
Valida Vinculo de Empresa/Filial
@type function
@version 1.0 
@author Leandro.brutus
@since 16/02/2022
/*/
Static Function VldFilEmp(_cCodFil)

Local lRet		:= .T.
Local cNomeEmp	:= " - "+Alltrim(FWCompanyName())
//Local cNomeEmp := FWSM0Util():GetSM0Data( cEmpAnt , cfilant , { "M0_FILIAL" } )[1][2]

/*
If at("-",cNomeEmp) > 0 
	cNomeEmp := " - "+alltrim(substr(cNomeEmp,1,at("-",cNomeEmp)-1))
Else
	cNomeEmp := " - "+alltrim(cNomeEmp)
EndIf
*/

If Substr(_cCodFil,1,5) <> Substr(cFilAnt,1,5) 

	MsgInfo("Filial: "+_cCodFil+" não pertence à empresa: " +Substr(cFilAnt,1,5)+cNomeEmp+". Favor selecionar uma filial da mesma empresa de cadastro do cliente.")
	lRet  	:= .F.

EndIf

Return lRet
