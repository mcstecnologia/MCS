#include "Protheus.ch"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} CRMA980
dPonto de entrada MVC para o novo cadastro de cliente, chamando as funções antigas.
@type function
@version 1 
@author joao.carvalho
@since 24/08/2022
@return variant, depende do PE que entrar.
/*/
User Function CRMA980() ///cXXX1,cXXX2,cXXX3,cXXX4,cXXX5,cXXX6
    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local lIsGrid       := .F.
    Local _aIncRot      := {}
    Local cIDPonto      := ''
    Local cIDModel      := ''
    Local oObj          := NIL


    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)

        nOpc := oObj:GetOperation() // PEGA A OPERAÇÃO

        If (cIdPonto == "MODELPOS")
            //Chamada na validação total do modelo.
            //cMsg += "ID " + cIdModel + CRLF
            xRet := .t.
            
        ElseIf (cIdPonto == "MODELVLDACTIVE")
            If  nOpc == 4
                 xRet :=  U_M030Alt()
            EndIF
        ElseIf (cIdPonto == "FORMPOS")     
            //Chamada na validação total do formulário   
            if cIdModel == "SA1MASTER" .and. (nOpc == 3 .or. nOpc == 4) 
                xRet := U_MA030TOK()
            EndIF
        ElseIf (cIdPonto =="FORMLINEPRE")
            //Chamada na pre validação da linha do formulário
            If aParam[5] =="DELETE"
                //Onde esta se tentando deletar uma linh
                xRet := U_M030DEL()
            EndIf
        ElseIf (cIdPonto =="FORMLINEPOS")
            //Chamada na validação da linha do formulário
            
        ElseIf (cIdPonto =="MODELCOMMITTTS")
            //Chamada apos a gravação total do modelo e dentro da transação
            If oObj:noperation == 3
                ExecBlock("M030Inc", .F.,.F.,0)
            elseif oObj:noperation == 4
                ExecBlock("MALTCLI", .F.,.F.)
            elseif oObj:noperation == 5
                ExecBlock("M030EXC", .F.,.F.)
            EndIf
            
        ElseIf (cIdPonto =="MODELCOMMITNTTS")
            //Chamada apos a gravação total do modelo e fora da transação       
            U_MCSTRIB()
        ElseIf (cIdPonto =="FORMCOMMITTTSPRE")
           
        ElseIf (cIdPonto =="FORMCOMMITTTSPOS")
            //Chamada apos a gravação da tabela do formulário          
        ElseIf (cIdPonto =="MODELCANCEL")
            //Chamada no BotÃ£o Cancelar
        ElseIf (cIdPonto =="BUTTONBAR")
            //dicionando Botao na Barra de Botoes 
            xRet := _aIncRot 
        EndIf
 EndIf
Return xRet

/*/{Protheus.doc} CRM980MDef
Substitui o PE MA030ROT - Inclusão de novas rotinas
@type function
@version 1.0
@author joao.carvalho
@since 24/08/2022
@return variant, novas rotinas
/*/
User Function CRM980MDef()

Local	_aIncRot 	:= {} // Array com as opcoes adicionais.

Local	aSubSched	:= {{'Abertura de Solicitação de Credito', 'U_MA30NEWSC()', 0 , 4, 0 , NIL} } // Abertura de Solicitação de Credito
	
		// Adiciona os botoes que serao incluidos na rotina de cadastro de clientes.
		aAdd(_aIncRot,{OemToAnsi('Anexos do Cliente'),'U_MRT30Z0W("SA1",,,SA1->A1_COD,SA1->A1_LOJA)',0,7})
	
		If U_RtCheckE("EV_EXC_FIN_CLEAN_CGC_CLIENTE",.F.)
			aAdd(_aIncRot,{OemToAnsi('Remover CGC'),'U_REMCGCCL(SA1->A1_COD,SA1->A1_LOJA)',0,4})
		EndIf
	
		If U_RtCheckE("EV_VIS_FIN_MATA030_LOG_ALT",.F.)
			aAdd(_aIncRot,{OemToAnsi('Log de Alteracao'),'U_M30LOGR()',0,7})
		EndIf
	
		aAdd(_aIncRot,{OemToAnsi('Observações'),'U_GetObsNew("SA1",,,SA1->A1_COD,SA1->A1_LOJA)',0,7})
		aAdd(_aIncRot,{OemToAnsi('Hist. Solicitações'),'U_FIN07VIE(SA1->A1_COD,SA1->A1_LOJA)',0,7})
		aAdd(_aIncRot,{OemToAnsi('Hist. Cliente'),'U_VGETPOSCLI(SA1->A1_COD,SA1->A1_LOJA)',0,7})
		aAdd(_aIncRot,{OemToAnsi('Cad. Bancos'),'U_FIN010A("SA1",RECNO())',0,7})				
		aAdd(_aIncRot,{OemToAnsi('Máquinas'),'U_GetMaqCli(4,"","")',0,7})
		aAdd(_aIncRot,{OemToAnsi('Ficha'),'U_FIN005R({SA1->A1_COD,SA1->A1_LOJA})',0,7})
		aAdd(_aIncRot,{OemToAnsi('Saldo'),'U_MT450XELIM(SA1->A1_COD,SA1->A1_LOJA)',0,7})
		aAdd(_aIncRot,{'Destacar Cliente',"U_CLIESPE(SA1->A1_COD,SA1->A1_LOJA)",0,7})
		//aAdd(_aIncRot,{OemToAnsi('Integ. Serasa'),'U_SerasaView(SA1->A1_CGC)',0,7})
		If	U_RtUsaSensor()
			aAdd(_aIncRot,{'Agendamentos',aSubSched,0,7})
		EndIf
        
        
		// Cria como publica (para ser usado em rotinas locais) as variaveis abaixo
		// Estas validacoes fazem parte do Modo de edicao X3_WHEN de varios campos do SA1
		Public	_LUSRDIRT	:= U_RtCheckE("EV_ANA_DIR_INFO_DIRETORIA",.F.)
		Public	_LUSRCRED 	:= U_RtCheckE("EV_ANA_FIN_FUNC_MESA_CREDITO",.F.) .or. U_RtCheckE("EV_ALT_FIN_ALTERA_PEFIN_CLIENT",.F.)
		Public	_LUSRFINA 	:= U_RtCheckE("EV_ANA_FIN_FUNCOES_FINANCEIRO",.F.)
		Public	_LUSRRTVEN	:= U_RtCheckE("EV_ALT_FIN_RESTR_VENDA_CLIENTE",.F.)
		Public  _LPERMPER 	:= .F.
		Public  _LCOBINT	:= .F.    //Controla se e um cobrador interno
		// Verifica a autorizacao e dados do cobrador
	
		DbSelectArea("SAQ")
		SAQ->(DbSetOrder(4))
		If	SAQ->(DbSeek(xFilial("SAQ") + RetCodUsr()))
			If	xFilial("SAQ")+RetCodUsr() == SAQ->AQ_FILIAL+SAQ->AQ_USER
				_LPERMPER 	:= ( SAQ->AQ_INSIPER == "1" )
				_LCOBINT	:= ( SAQ->AQ_MSBLQL <> '1' .AND. !Empty(SAQ->AQ_FILMAT) .AND.;
				!Empty(SAQ->AQ_MATFUN) .AND. !Empty(SAQ->AQ_EMPFRES) .AND. SAQ->AQ_TPCOB == '1' )
			EndIf
		End
Return( _aIncRot )
