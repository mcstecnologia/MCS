#include 'totvs.ch'

/*/{Protheus.doc} M030Inc
PONTO DE ENTRADA: Apos inclusao do cadastro do cliente
Usado para criar o item contabil.
@author Luis.robusto
@since 21/12/2010
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function M030Inc()
	Local	_aAreaSA1	:= SA1->(GetArea())
	Local	_cRetItem	:= ""
	Local	_nOpcX		:= ParamIXB

		// Somente se tiver confirmada a opcao.		
		If	_nOpcX == 0

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
			private M->A1_EST	:= SA1->A1_EST
			private M->A1_MUN	:= SA1->A1_MUN
			private M->A1_CEP	:= SA1->A1_CEP
			private M->A1_CEPC	:= SA1->A1_CEPC
			private M->A1_REGIAO:= SA1->A1_REGIAO
			U_FAT013B()
			If	RecLock("SA1",.F.)
				Replace SA1->A1_REGIAO With M->A1_REGIAO
				SA1->(MsUnLock())
			Endif
			
			private M->A1_NOME 		:=  Alltrim(M->A1_NOME)
			private M->A1_NREDUZ 	:=  Alltrim(M->A1_NREDUZ)
			private M->A1_END 		:=  Alltrim(M->A1_END)
			private M->A1_COMPLEM 	:=  Alltrim(M->A1_COMPLEM)
			private M->A1_BAIRRO 	:=  Alltrim(M->A1_BAIRRO)
			private M->A1_EMAIL 	:=  Alltrim(M->A1_EMAIL)
			private M->A1_TEL		:=  Alltrim(M->A1_TEL)

			If Empty(M->A1_XID)
				M->A1_XID	:= U_IDSA1GAT(M->A1_CGC, M->A1_INSCR)
			EndIf

			private M->A1_XID		:=  Alltrim(M->A1_XID)

			If	RecLock("SA1",.F.)
				Replace SA1->A1_XID With M->A1_XID
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

			If	! IsBlind()
				U_MA030EMPFIL(SA1->A1_COD,SA1->A1_LOJA)
			EndIf
			
			If U_RtIsEmpFil({{"03"}})
				U_XFLAG("SA1")
			EndIf

		EndIf

		RestArea(_aAreaSA1)

Return
