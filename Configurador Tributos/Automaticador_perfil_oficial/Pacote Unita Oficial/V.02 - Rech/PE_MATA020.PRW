#include 'protheus.ch'
#include "parmtype.ch"

/*/{Protheus.doc} User Function CUSTOMERVENDOR
    P.E. para rotina MVC MATA020 - Cadastro de fornecedor
    @type  Function
    @author Bruno Rosa
    @since 30/11/2021
    @version 12.1.33
    @example
    (examples)
    @see https://tdn.totvs.com/display/public/PROT/ADV0044_PE_MVC_MATA020_P12
/*/
User Function CUSTOMERVENDOR()
    
    Local   _aParam   	:= PARAMIXB
    Local   _xRet    	:= .T.
    Local   oObj        := ""
    Local   cIdPonto    := ""
    Local   _cIdModel	:= ""
    Local	_aAreaSA2	:= SA2->(GetArea())
    Local	_cRetItem	:= ""
	Local	_nOper		:= 0
	Local 	_lUsIncFor	:= U_RtCheckE("EV_INC_ALL_CADASTRO_FORNECEDOR",.f.)
	Local 	_lUsAltFor	:= U_RtCheckE("EV_ALT_ALL_CADASTRO_FORNECEDOR",.f.)

    If _aParam <> NIL

        oObj        := _aParam[1]
        cIdPonto    := _aParam[2]
        _cIdModel   := _aParam[3]
		_nOper      := oObj:GetOperation()

		If _nOper == 3
			If !_lUsIncFor
				Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Você não tem acesso a incluir o cadastro de fornecedor.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Evento: EV_INC_ALL_CADASTRO_FORNECEDOR"})
				Return .F.
			EndIf 
		EndIF 

		If cIdPonto == "MODELVLDACTIVE"

			If _nOper == 4  // Alteração
				If SA2->A2_MSBLQL == "1" .and. Alltrim(SA2->A2_XUSRINC) == RetCodUsr()
					_xRet := .T.
				ElseIf !_lUsAltFor
					Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Você não tem acesso a alterar o cadastro de fornecedor.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Evento: EV_ALT_ALL_CADASTRO_FORNECEDOR"})
					_xRet := .F.
				EndIf
			EndIf

        //Chamada na validação total do formulário
        ElseIf cIdPonto == "FORMPOS"

            //_xRet := U_M20ALT(_cIdModel)
            _xRet := U_M20ALT('SA2MASTER')

			u_RcPutSuf('SA2MASTER')

        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
            
            //Transformado ponto de entrada M020INC transformado em MVC
            // Verifica o Item Contabil
            _cRetItem := U_CTB007B("FOR"+SubStr(SA2->A2_COD,1,6),SA2->A2_NOME)
            If	! Empty(_cRetItem)
                If	RecLock("SA2",.F.)
                    Replace SA2->A2_ITEM	With _cRetItem
                    SA2->(MsUnLock())
                EndIf
            EndIf
            
            If	RecLock("SA2",.F.)
                Replace SA2->A2_NOME 	With  Alltrim(StrTran(SA2->A2_NOME, Chr(09) , "" ))
                Replace SA2->A2_NREDUZ 	With  Alltrim(StrTran(SA2->A2_NREDUZ, Chr(09) , "" ))
                Replace SA2->A2_END 	With  Alltrim(StrTran(SA2->A2_END, Chr(09) , "" ))
                Replace SA2->A2_COMPLEM With  Alltrim(StrTran(SA2->A2_COMPLEM, Chr(09) , "" ))
                Replace SA2->A2_BAIRRO 	With  Alltrim(StrTran(SA2->A2_BAIRRO, Chr(09) , "" ))
                Replace SA2->A2_EMAIL	With  Alltrim(StrTran(SA2->A2_EMAIL, Chr(09) , "" ))
                Replace SA2->A2_TEL 	With  Alltrim(StrTran(SA2->A2_TEL, Chr(09) , "" ))
                If Empty(SA2->A2_SIMPNAC)
                    Replace SA2->A2_SIMPNAC With "2"
                Else
                    Replace SA2->A2_SIMPNAC With AllTrim(SA2->A2_SIMPNAC)
                EndIf
                SA2->(MsUnLock())
            EndIf

            // Verifica o codigo DIEF do municipio (exclusivo - Para)
            If	SA2->A2_EST == "PA"
                // Cria uma variavel para controlar o codigo do municipio para DIEF (localizando do cadastro de municipios do IBGE)
                Private _cCodDief	:= Space(TamSx3("A2_DIEF")[1])
                // Posiciona no cadastro de municipios para localizar o codigo
                DbSelectArea("CC2")
                CC2->(DbSetOrder(1)) // FILIAL + EST + COD_MUN
                // Verifica se encontra o municipio
                If	CC2->(DbSeek(xFilial("CC2")+SA2->A2_EST+SA2->A2_COD_MUN))
                    _cCodDief := CC2->CC2_DIEF
                EndIf
                // Atualiza no Cadastro
                If	RecLock("SA2",.F.)
                    Replace SA2->A2_DIEF	With _cCodDief
                    SA2->(MsUnLock())
                EndIf
            
            EndIf

            /// Sincroniza informações auxiliares de contas bancarias
            U_fZ35Sync('SA2',2) // Inclusão

            If U_RtIsEmpFil({{"03"}})
                U_XFLAG("SA2")
            EndIf
            
            RestArea(_aAreaSA2)

		ElseIf cIdPonto == "MODELCOMMITNTTS"   
            U_MCSTRIB()
        EndIf

    EndIf
    
Return _xRet

/*/{Protheus.doc} User Function RcPutSuf
    (long_description)
    @type  Function
    @author Lucas.schoeffel
    @since 24/03/2023
    @version version
    Função com a validação/criação de sufixo para fornecedor. EV_ALT_COM_MODIFICA_SUFIXO    
/*/
User Function RcPutSuf(_cIdModel)
Local oModel    := FWModelActive()   
Local _oModel  
Local _cCnpj	 := ""
Local _cFor		 := ""
Local _cSuf		 := ""

	_oModel		:= oModel:GetModel('SA2MASTER') 
    _cCnpj 		:= _oModel:GetValue("A2_CGC")
	_cFor		:= _oModel:GetValue("A2_FORNECE") //verifica se é fornecedor de estoque

	If _cFor = 'S' .and. !Empty(_cCnpj)
		If (U_RtGetFran(,,.F.) <> "F")
			_cSuf := u_RcBusSuf(_cCnpj)
			If Empty(_cSuf)
				_cSuf := u_RcNewSuf(_cCnpj)
			EndIf 
		EndIf 
	EndIf 

	If !Empty(_cSuf)
		_oModel:SetValue("A2_SUFIXO",Alltrim(_cSuf))
	EndIf 


Return 


/*/{Protheus.doc} User Function M20ALT
    (long_description)
    @type  Function
    @author user
    @since 02/12/2021
    @version version
    Função com as validações do fonte MA020ALT e MA020TOK, ponto de entrada transformado em MVC
/*/
User Function M20ALT(_cIdModel)
    Local _lReturn   := .T.
	Local oModel    := FWModelActive()    
	Local _oModel     
    Local _cMensagem := ""
	Local _cQuery	 := ' '
    Local _cCnpj	 := ""
    Local _cCodFor   := ""
	Local _cAgencia	 := ""
	Local _cConta	 := ""
	Local _cCaracEsp := "áéíóúÁÉÍÓÚãõÃÕâêîôûÂÊÎÔÛçÇàÀºª"+chr(19)+chr(20)+chr(21)+chr(34)+chr(35)+chr(36)+chr(37)+chr(38)+chr(39)+chr(40)+chr(41)+chr(42)+chr(43)+chr(44)+chr(46)+chr(47)+chr(58)+chr(59)+chr(60)+chr(61)+chr(62)+chr(63)+chr(64)+chr(91)+chr(92)+chr(93)+chr(94)+chr(95)+chr(123)+chr(124)+chr(125)+chr(126)+chr(127)
	Local _Nx
	Local xn		 := 0

    _oModel		:= oModel:GetModel('SA2MASTER') //_cIdModel)
    _cCnpj 		:= _oModel:GetValue("A2_CGC")
    _cCodFor 	:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_COD")
	_cAgencia 	:= _oModel:GetValue("A2_AGENCIA")
	_cConta 	:= _oModel:GetValue("A2_NUMCON")

    If	_oModel:GetOperation() == 3 .AND. !Empty(_cCnpj) .and. Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_CGC") = _cCnpj
		MsgAlert("CNPJ já cadastrado!!! Favor pesquisar o cadastro e fazer as devidas alterações. Fornecedor>>" + _cCodFor)
        _lReturn := .F.
	EndIf

	_cCodFor := AllTrim(_oModel:GetValue("A2_COD"))
	//If	_oModel:GetOperation() == 3 .AND. !Empty(_cCnpj) .AND. _oModel:GetValue("A2_TIPO") $ "F|J" .AND. AllTrim(_oModel:GetValue("A2_EST")) <> "EX" .AND. !Empty(_cCodFor)
	If	_oModel:GetOperation() == 3 .AND. !Empty(_cCodFor)	
		For _nX := 1 To Len(_cCodFor) 

			If !Substr(_cCodFor,_nX,1) $ '0123456789'
				_cMensagem += "Utilizar somente numeros no codigo do fornecedor!"
        		_lReturn := .F.
				Exit
			EndIf
		
		Next _nx

	EndIf
    //Validação: O campo não pode ser preenchido com o valor zerado caso o A1_EST seja diferente de EX. Chamado: 00062965
	If At(Iif(_oModel:GetValue("A2_TIPO") == "F","000000000","000000000000"),AllTrim(_oModel:GetValue("A2_CGC"))) == 1 .and. AllTrim(_oModel:GetValue("A2_EST")) <> "EX" .and. !(AllTrim(_oModel:GetValue("A2_NATUREZ")) $ SuperGetMV("RC_NATCGC",,""))
        MsgAlert("O CPF/CNPJ não pode ser preenchido com o valor zerado, pois o estado é diferente de EX=Estrangeiro. ")
        _lReturn := .F.
	EndIf

	//Validação: O campo não pode ser preenchido com o valor zerado caso o A1_EST seja diferente de EX. Chamado: 00062965
	If Empty(AllTrim(_oModel:GetValue("A2_CGC"))) .and. AllTrim(_oModel:GetValue("A2_EST")) <> "EX" .and. !(AllTrim(_oModel:GetValue("A2_NATUREZ")) $ SuperGetMV("RC_NATCGC",,""))
        MsgAlert("O CPF/CNPJ não pode estar vazio, pois o estado é diferente de EX=Estrangeiro. ")
        _lReturn := .F.
	EndIf

	For	xn := 1 To Len(_cCaracEsp)
		If	Substr(_cCaracEsp,xn,1) $ _cAgencia .or. Substr(_cCaracEsp,xn,1) $ _cConta
			_cMensagem += "Agência ou conta não podem ter caractere especial. Encontrado: " + Substr(_cCaracEsp,xn,1) + Chr(10) + Chr(13)
			_lReturn := .F.
			Exit
		EndIf
	Next xn

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida o campo nome e nome fantasia.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	"'" $ _oModel:GetValue("A2_NOME") .or. "'" $ _oModel:GetValue("A2_NREDUZ")
		_cMensagem += "Não use o caracter aspas simples nos campos nome e nem nome fantasia." + Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf

	If	"&" $ _oModel:GetValue("A2_NOME")
		_cMensagem += "Não use o caracter & no campo Nome, substitua por E." + Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf

	// Verificacao da quantidade de digitos
	If	Len(AllTrim(_oModel:GetValue("A2_COD"))) <> 6
		_cMensagem += "Preencha o campo Codigo do Fornecedor com 6 digitos." + Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf
	If	Len(AllTrim(_oModel:GetValue("A2_LOJA"))) <> 2
		_cMensagem += "Preencha o campo Loja do Fornecedor com 2 digitos." + Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf

	If	_oModel:GetValue("A2_SIMPNAC") == '1'
		If _oModel:GetValue("A2_GRPTRIB") $ "2BR" 
			_cMensagem += "Grupo de tributação incorreto (2BR), substituido por 2SN." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","2SN") 
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "3BR" 
			_cMensagem += "Grupo de tributação incorreto (3BR), substituido por 3SN." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","3SN")  
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "6BR" 
			_cMensagem += "Grupo de tributação incorreto (6BR), substituido por 6SN." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","6SN")   
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "7BR" 
			_cMensagem += "Grupo de tributação incorreto (7BR), substituido por 7SN." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","7SN")   
			_lReturn := .F.
		EndIf
	Else
		If _oModel:GetValue("A2_GRPTRIB") $ "2SN" 
			_cMensagem += "Grupo de tributação incorreto (2SN), substituido por 2BR." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","2BR")  
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "3SN" 
			_cMensagem += "Grupo de tributação incorreto (3SN), substituido por 3BR." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","3BR")   
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "6SN" 
			_cMensagem += "Grupo de tributação incorreto (6SN), substituido por 6BR." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","6BR")   
			_lReturn := .F.
		ElseIf _oModel:GetValue("A2_GRPTRIB") $ "7SN" 
			_cMensagem += "Grupo de tributação incorreto (7SN), substituido por 7BR." + Chr(10) + Chr(13)
			_oModel:SetValue("A2_GRPTRIB","7BR")   
			_lReturn := .F.
		EndIf
	EndIf

	If _oModel:GetValue("A2_EST") == "EX" .and. _oModel:GetValue("A2_TIPO") <> "X"
		_lReturn := .F.
		MsgAlert("Fornecedores estrangeiros o Tipo deve ser preenchido com X=Outros")
	EndIf

	If _oModel:GetValue("A2_EST") == "EX" .and. _oModel:GetValue("A2_CEP") <> "00000000"
		_lReturn := .F.
		MsgAlert("Fornecedores estrangeiros o CEP deve ser preenchido com 00000-000")
	EndIf

	If _oModel:GetValue("A2_EST") == "EX" .and. _oModel:GetValue("A2_PAIS") == "105"
		_lReturn := .F.
		MsgAlert("Fornecedores estrangeiros o País não pode ser nacional.")
	EndIf

	If !IsBlind()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adicionado para validar o campo A2_DDI, A2_DDD, A2_TEL, A2_FAX, A2_EMAIL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	! Empty(_oModel:GetValue("A2_DDI")+_oModel:GetValue("A2_DDD")+_oModel:GetValue("A2_TEL")) .or. ;
            ! Empty(_oModel:GetValue("A2_DDI")+_oModel:GetValue("A2_DDD")+_oModel:GetValue("A2_FAX")) 
			If	Empty(_oModel:GetValue("A2_DDI"))
				_cMensagem += "Preencha o campo DDI" + Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
			If	Empty(_oModel:GetValue("A2_DDD"))
				_cMensagem += "Preencha o campo DDD"+ Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
			If	Empty(_oModel:GetValue("A2_TEL"))
				_cMensagem += "Preencha o campo telefone no formato: 9999-9999."+ Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
			If	!Len(AllTrim(_oModel:GetValue("A2_TEL"))) > 0 .and. ;
				!(Len(AllTrim(_oModel:GetValue("A2_TEL"))) == 9 .or. Len(AllTrim(_oModel:GetValue("A2_TEL"))) == 10) ;
				.and. !( "-" $ _oModel:GetValue("A2_TEL") )
				_cMensagem += "Preencha o campo telefone no formato: 9999-9999 ou 99999-9999."+ Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
			//If	Len(AllTrim(M->A2_FAX)) > 0 .and. ( Len(AllTrim(M->A2_FAX)) <> 9 .or. (Len(AllTrim(M->A2_FAX)) <> 12 .and. Empty(M->A2_DDD)))
			If	Len(AllTrim(_oModel:GetValue("A2_FAX"))) > 0 .and. !( Len(AllTrim(_oModel:GetValue("A2_FAX"))) == 9 .or. ;
                Len(AllTrim(_oModel:GetValue("A2_FAX"))) == 10 )
				_cMensagem += "Preencha o campo fax no formato: 9999-9999 ou 99-9999-9999."+ Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
			If	Len(AllTrim(_oModel:GetValue("A2_FAX"))) > 0 .and. Len(AllTrim(_oModel:GetValue("A2_FAX"))) == 12 .and. ;
                SubStr(_oModel:GetValue("A2_FAX"),1,2) == _oModel:GetValue("A2_DDD")
				_cMensagem += "Nao precisa preencher o Fax com DDD, preencha no formato: 9999-9999"+ Chr(10) + Chr(13)
				_lReturn := .F.
			EndIf
		EndIf
	EndIf        

	If	( ! Empty(_oModel:GetValue("A2_EMAIL")) ) .and. ( " " $ RTrim(_oModel:GetValue("A2_EMAIL")) ) 
		_cMensagem += "Retire os espacos do campo e-mail."+ Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf

	If	( ! Empty(_oModel:GetValue("A2_EMAIL")) ) .and. ( ! "@" $ _oModel:GetValue("A2_EMAIL") )
		_cMensagem += "O conteudo preenchido no campo e-mail nao parece ser um e-mail de verdade, atualize o campo corretamente."+ Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf

	// Valida o preenchimento do campo de Inscricao Estadual e Inscricao Municipal
	// CI = Comercio e Industria
	// PF = Pessoa Fisica
	// OS = Prestadores de Servicos
	// Esta validacao tem que funcionar mesmo para cadastros antigos e desabilitados, pois se for gerado sintegra e DIEF tem que ir estes dados.
	// validacao criada principalmente para atender reclamacao da OJE Consultoria, em se tratando da dificuldade de enviar os sintegras com cadastros faltando a inscricao estadual.
	If	_oModel:GetValue("A2_EST") <> "EX" // Caso sejam fornecedores do Brasil
		If	! IsBlind()
			Do	Case
				Case 	AllTrim(_oModel:GetValue("A2_TPESSOA")) == "CI" .and. Empty(_oModel:GetValue("A2_INSCR")) // Caso sejam Com/Ind e sem inscricao estadual preenchida.
				_cMensagem += "O Preenchimento do campo Inscrição Estadual é obrigatório para Industrias e Comércios."+ Chr(10) + Chr(13)
				_lReturn := .F.
				Case 	AllTrim(_oModel:GetValue("A2_TPESSOA")) == "OS" .and. Empty(_oModel:GetValue("A2_INSCRM")) // Caso seja prestador de servico sem inscricao municipal preenchida.
				_cMensagem += "O Preenchimento do campo Inscrição Municipal é obrigatório para Prestadores de Serviços."+ Chr(10) + Chr(13)
				_lReturn := .F.
			End Case
		EndIf
	Else

		If _oModel:GetValue("A2_CODPAIS") == '01058'
			_cMensagem += "Este fornecedor e de um pais estrangeiro, por favor altere o codigo do Pais Bacen para o pais correspondente a ele."+ Chr(10) + Chr(13)
			_lReturn := .F.
		EndIf

	EndIf

	If	Select("TRA")>0
		TRA->(DbCloseArea())
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o fornecedor é vinculado a vendedor e se o cadastro esta bloqueado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery	+=	" SELECT SA3.A3_MSBLQL A3_MSBLQL"
	_cQuery	+=	" FROM "+RetSqlName("SA3")+" SA3, "+RetSqlName("SA2")+" SA2"
	_cQuery	+=	" WHERE	SA2.A2_COD 	= SA3.A3_FORNECE "
	_cQuery	+=	" AND SA2.A2_LOJA = SA3.A3_LOJA "
	_cQuery	+=	" AND SA2.A2_FILIAL = '" + xFilial('SA2') + "' "
	_cQuery	+=	" AND SA2.A2_COD = '" + _oModel:GetValue("A2_COD") + " ' "      
	_cQuery	+=	" AND SA2.A2_LOJA = '" + _oModel:GetValue("A2_LOJA") + "' "
	_cQuery	+=	" AND SA3.A3_FILIAL = '" + xFilial('SA3') + "' "
	_cQuery	+=	" AND SA3.D_E_L_E_T_ = ' ' "
	_cQuery	+=	" AND SA2.D_E_L_E_T_ = ' ' "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TRA',.F.,.T.)
	
    If	( TRA->(!EoF()) ) .AND. ( TRA->A3_MSBLQL <> '1' .AND. _oModel:GetValue("A2_MSBLQL") == '1')
		_cMensagem := "Atencão este fornecedor esta sendo utilizado no cadastro de vendedores, não será possível bloquea-lo sem antes bloquear o cadastro de vendedor." + Chr(10) + Chr(13)
		_lReturn := .F.
	EndIf	

	TRA->(DbCloseArea())

	// Apresenta a mensagem ao usuario impedindo sua continuidade
	If	! _lReturn
		FwAlertError(_cMensagem)
	
		if Type("cErroApiFor") <> "U"
			cErroApiFor += _cMensagem
		EndIf
	EndIF

    //Limpa os campos		
	_oModel:SetValue("A2_NOME",     Alltrim(StrTran(_oModel:GetValue("A2_NOME"),     Chr(09) , "" )))
	_oModel:SetValue("A2_NREDUZ",   Alltrim(StrTran(_oModel:GetValue("A2_NREDUZ"),   Chr(09) , "" )))
	_oModel:SetValue("A2_END",      Alltrim(StrTran(_oModel:GetValue("A2_END"),      Chr(09) , "" )))
	_oModel:SetValue("A2_COMPLEM",  Alltrim(StrTran(_oModel:GetValue("A2_COMPLEM"),  Chr(09) , "" )))
	_oModel:SetValue("A2_BAIRRO",   Alltrim(StrTran(_oModel:GetValue("A2_BAIRRO"),   Chr(09) , "" )))
	_oModel:SetValue("A2_EMAIL",    Alltrim(StrTran(_oModel:GetValue("A2_EMAIL"),    Chr(09) , "" )))
	_oModel:SetValue("A2_TEL",      Alltrim(_oModel:GetValue("A2_TEL")))

Return _lReturn
