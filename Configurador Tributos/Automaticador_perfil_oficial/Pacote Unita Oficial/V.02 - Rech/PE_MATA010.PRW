#include "protheus.ch"
#include "parmtype.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function ITEM
    P.E. para rotina MVC MATA010 - Cadastro de Produto
    @type  Function
    @author Bruno Rosa
    @since 07/12/2021
    @version 12.1.33
    @example
    (examples)
    @see https://tdn.totvs.com/display/public/PROT/PEST01015+-+MATA010+-+Pontos+de+Entrada+no+Cadastro+de+Produtos+MVC
/*/
User Function ITEM()
    
    Local   _aParam     := PARAMIXB
    Local   _xRet       := .T.
	Local 	_lUsAltPrd  := U_RtCheckE("EV_ALT_ALL_CADASTRO_PRODUTOS ",.f.)
	Local 	_lUsIncPrd  := U_RtCheckE("EV_INC_ALL_CADASTRO_PRODUTOS ",.f.)
    Local   oObj        := ""
    Local   cIdPonto    := ""
    Local   _cIdModel   := ""
	Local 	oModel      := FWModelActive()
	Local 	cFlagNCM	:= ""
	Local 	cFlagSimp	:= ""
    Local 	_oModel     
	Local 	aAreaSZM	:= SZM->(GetArea())

    If _aParam <> NIL
        oObj        := _aParam[1]
        cIdPonto    := _aParam[2]
        _cIdModel   := _aParam[3]
		_nOper      := oObj:GetOperation()

		Do Case

			Case cIdPonto == "MODELVLDACTIVE"
				If _nOper == 5
					If !FWIsInCallStack("U_RTIMPBAS")
						If !_lUsIncPrd
							Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Voc๊ nใo tem acesso a incluir/excluir o cadastro de produto.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Evento: EV_INC_ALL_CADASTRO_PRODUTOS"})
							_xRet := .F.
						Else
							If !IsBlind() .and. SB1->(FieldPos("B1_XPRECAD")) > 0
								If SB1->B1_XPRECAD == "S"
									If FWAlertYesNo("Este ้ um pr้ cadastro de produto, caso siga em frente e este item tenha registro nas tabelas SB5 e SBZ serใo excluํdos os registros caso prossiga.<br><br>Gostaria de excluir?")
										// Limpa SB5
										DbSelectArea("SB5")
										DbSetOrder(1)
										If SB5->(DBSeek(FWxFilial("SB5")+SB1->B1_COD))
											lMsErroAuto := .F.
											aCab:= {     {"B5_COD"  ,SB1->B1_COD  ,Nil}}  // C๓digo identificador do produto            
											MSExecAuto({|x,y| Mata180(x,y)},aCab,5) //Exclusใo
											If lMsErroAuto
												MostraErro()
											EndIf
										EndIf

										//Limpa SBZ
										fLimpaSBZ(SB1->B1_COD)
									Else
										Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Voc๊ cancelou a exclusใo do cadastro de produto.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Aviso!"})
										_xRet := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf _nOper == 4
					If !FWIsInCallStack("U_RTIMPBAS")
						// Se o produto estiver bloqueado permite a altera็ใo se for o mesmo usuแrio que incluiu
						If SB1->B1_STATUS == "N" .and. SB1->B1_MSBLQL == "1"
							If SB1->(FieldPos("B1_XUSRINC")) > 0 .and. SB1->(FieldPos("B1_XPRECAD")) > 0
								If Alltrim(SB1->B1_XUSRINC) == RetCodUsr() .and. SB1->B1_XPRECAD == "S"
									_xRet := .T.
								Elseif !_lUsAltPrd
									Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Voc๊ nใo tem acesso a alterar o cadastro de produto.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Evento: EV_ALT_ALL_CADASTRO_PRODUTOS"})
									_xRet := .F.
								EndIf
							EndIf
						ElseIf !_lUsAltPrd
								Help(NIL, NIL, ProcName()+" - Linha "+cValtoChar(ProcLine()), NIL, "Voc๊ nใo tem acesso a alterar o cadastro de produto.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Evento: EV_ALT_ALL_CADASTRO_PRODUTOS"})
								_xRet := .F.
						EndIf
					EndIf
				EndIf

			Case cIdPonto == 'FORMPOS'
             	_xRet := U_A10OK(_cIdModel)
				If _nOper == 3
					
					oModel   := FWModelActive()
					
					While U_VldSeqId(oModel:GetValue("SB1MASTER","B1_XID"))

						oModel:SetValue("SB1MASTER", "B1_XID",  U_RtSeqId())
					
					EndDo
				
				EndIf
				cFlagNCM := iif(_nOper == 3, "M->B1_POSIPI", "SB1->B1_POSIPI")
				cFlagSimp := iif(_nOper == 3, "M->B1_CODSIMP", "SB1->B1_CODSIMP")
				if substr(&(cFlagNCM),1,4) $ SuperGetMv("RC_NCMSIMP",.F.,"2710") .and. Empty(&(cFlagSimp))
					oModel:SetValue("SB1MASTER", "B1_CODSIMP",  SuperGetMv("RC_CSIMPAD",.F.,"610501001" ))
				EndiF

				If _nOper == 3 .or. _nOper == 4
					If SB1->B1_MASTER <> M->B1_MASTER
						// Caso o master antigo nใo exista mais em nenhum produto ele ้ excluํdo
						If !U_lExtMster(SB1->B1_MASTER,SB1->B1_COD)
							U_vldMaster(.t.,SB1->B1_MASTER)
						Else
							U_vldMaster(,SB1->B1_MASTER,SB1->B1_DESC)
						EndIF
					EndIf
				EndIf 

        	Case cIdPonto == 'MODELCOMMITNTTS'
        		_oModel := oModel:GetModel("SB1MASTER")
								
				// Inclusใo ou altera็ใo
        		If oObj:noperation == 3 .or. oObj:noperation == 4

					U_MCSTRIB()
				   
	        		// Ajusta a base de conversoes de similares de produtos
					U_UPDSB1TOSZY(,SB1->B1_MASTER,SB1->B1_COD,SB1->B1_DESC,SB1->B1_LINHA,100,'0')

					//Valida se existe o master cadastrado na tabela de controle de master
					U_vldMaster(,SB1->B1_MASTER,SB1->B1_DESC)
			 
					// Atualiza dados do SBZ
					u_RtUpdBZ(SB1->B1_COD)
				
					// Faz ajuste das combinacoes de TAG do produto da descricao
					If	SB1->B1_BLQCAD<>"S" .or. Empty(Posicione("Z36",2,xFilial("Z36")+SB1->B1_COD,"Z36_TAG"))
						U_Est10Tag(SB1->B1_COD,SB1->B1_DESC,.t.)
					EndIf
					U_XFLAG("SB1")
					
					// Ajusta informacoes no SZM - Prospect de Produtos
					DbSelectArea('SZM')
					SZM->(DbSetOrder(1))
					If	SZM->(DbSeek(xFilial('SZM') + SB1->B1_COD))
						While	SZM->( ! Eof() ) .and. ( SZM->ZM_PRODUTO == SB1->B1_COD )
								If	RecLock('SZM',.F.)
									SZM->(DbDelete())
								    MsUnLock()
								Else
									Help(' ',1,'REGNOIS')
								EndIf
							SZM->(DbSkip())
						End
					EndIf
					
					// Ajusta tabela de similares, mesmo para produtos, pois ambos estao inseridos no SZY.
					U_UPDSB1TOSZY(,SB1->B1_MASTER,SB1->B1_COD,SB1->B1_DESC,SB1->B1_LINHA,100,'0')
							
					//Verifica Pesos Bruto e Liquido p/ replicar aos demais produtos amarrados
					If	( SB1->B1_PESO > 0 .or. SB1->B1_PESBRU > 0 ) .and. ( AllTrim(FunName()) <> "COM090A" ) .and. ( ! IsBlind() )
						If MsgYesNo(OemToAnsi("Deseja replicar os Pesos Bruto e Lํquido deste Produto para todos os Produtos Amarrados a este?"))
							_cQrySB1 := " UPDATE " + RetSqlName("SB1") 
							_cQrySB1 += " SET B1_PESO 		= "		+ Alltrim(Str(SB1->B1_PESO))
							_cQrySB1 += " , B1_PESBRU 		= "   	+ Alltrim(Str(SB1->B1_PESBRU))
							_cQrySB1 += " WHERE B1_FILIAL 	= '"  	+ xFilial("SB1")   				+ "' "
							_cQrySB1 += " AND B1_MASTER		= '"	+ SB1->B1_MASTER				+ "' "
							_cQrySB1 += " AND B1_COD		<> '" 	+ SB1->B1_COD					+ "' "
							_cQrySB1 += " AND B1_PESO		<> " 	+ Alltrim(Str(SB1->B1_PESO))	+ " "
							_cQrySB1 += " AND B1_PESBRU		<> " 	+ Alltrim(Str(SB1->B1_PESBRU))	+ " "
							_cQrySB1 += " AND D_E_L_E_T_	= ' ' "
							TcSqlExec(_cQrySB1)
							MsgInfo("Processo concluido!")
						Endif
					EndIf	
					
					If AllTrim(FunName()) == "MATA010" .and. U_RtIsEmpFil({{"06"}})
						U_RtNewSB1(_oModel:GetValue("B1_COD"),_oModel:GetValue("B1_LINHA"),_oModel:GetValue("B1_GRUPO"),,_oModel:GetValue("B1_DESC"))
					EndIf

					
				
				ElseIf oObj:noperation == 5 // Exclusใo
				/*
					// Verifica os dados dos campos.
					nPos    := aScan(aGets,{ |x| Subs(x,9,10) == "B1_COD    " } )
					cCod    := aTela[Val(Subs(aGets[nPos],1,2))][Val(Subs(aGets[nPos],3,1))*2]
					nPos    := aScan(aGets,{ |x| Subs(x,9,10) == "B1_MASTER " } )
					cMaster := aTela[Val(Subs(aGets[nPos],1,2))][Val(Subs(aGets[nPos],3,1))*2]
					nPos    := aScan(aGets,{ |x| Subs(x,9,10) == "B1_DESC   " } )
					cDesc   := aTela[Val(Subs(aGets[nPos],1,2))][Val(Subs(aGets[nPos],3,1))*2]
					nPos    := aScan(aGets,{ |x| Subs(x,9,10) == "B1_LINHA  " } )
					cLinha  := aTela[Val(Subs(aGets[nPos],1,2))][Val(Subs(aGets[nPos],3,1))*2]
			
					// Faz os ajustes no SZY.
					If	MsgYesNo("Deseja excluir o produto " + AllTrim(cCod) + " no 'Grupo de Similares' ? ")
						U_UPDSB1TOSZY(.T.,,cCod) // Excluir o registro
					Else
						U_UPDSB1TOSZY(.F.,cMaster,cCod,cDesc,cLinha,100,'1') // Ajusta o registro
					EndIf
					*/
				EndIf
        	
			Case cIdPonto == "MODELPOS"

            	_xRet := U_A10OK(_cIdModel)

			Case cIdPonto == "BUTTONBAR"
				If _nOper == 3 .or. _nOper == 4
					_xRet := {{"Cadastro de Similares", "BOTรO", {|| fCadSim()}}}
				EndIf

		EndCase
		
		
		
	EndIf
	
	// Retorna a area anterior do sistema.
	RestArea(aAreaSZM)
    
Return _xRet

/*/{Protheus.doc} vldMaster
Valida se o master existe na tabela de cadastro de master para incluir
@type function
@version  1.0
@author joao.carvalho
@since 05/07/2022
@param cMaster, character, c๓digo do master
@param cDescPrd, character, descri็ใo do produto 
/*/
User Function vldMaster(ldeleta,cMaster, cDescPrd)
Local lInclui := .t.
Local _aAreaOld	    := SB1->(GetArea())
Default cMaster := ''
Default cDescPrd := ''
Default lDeleta := .f.

	if Empty(cMaster)
		Return
	EndIF

	DbSelectArea('SZ8')
	SZ8->(DbSetOrder(1))
	If	SZ8->(DbSeek(xFilial('SZ8') + cMaster))
		lInclui := .f.
	EndIf

		// Executa a inclusao/alteracao do registro.
	If	( ! ldeleta .and. lInclui ) // Incluir e/ou alterar
		if RecLock('SZ8',.t.)
			Replace SZ8->Z8_MASTER  With cMaster
			Replace SZ8->Z8_NOME 	With cDescPrd
			MsUnLock()
		ELSE
			Help(' ',1,'REGNOIS')
		EndIf
	ElseIf ldeleta // Excluir
		If	!lInclui // Caso encontrou o registro no SZY
			If	RecLock('SZ8',lInclui)
				SZ8->(DbDelete())
				SZ8->(MsUnLock())
			Else
				Help(' ',1,'REGNOIS')
			EndIf
		EndIf
	EndIf

	// Restaura a area anterior ao processamento
	RestArea(_aAreaOld) 
Return 

/*/{Protheus.doc} User Function A10OK
    (long_description)
    @type  Function
    @author Bruno Rosa
    @since 07/12/2021
    @version 12.1.33
    @param _cIdModel
    @return _lRet
    /*/
User Function A10OK(_cIdModel)
    Local _lRet         := .T.
    Local oModel        := FWModelActive()    
    Local _oModel       := oModel:GetModel(_cIdModel)
    Local _aAreaOld	    := SYD->(GetArea())
	Local _cParam       := GetNewPar("MV_XTPPLT","ME;MF;MJ;MI;PP;MS")
	Private _cMsgErro	:= ""
    Private lInsumo		:= .F.
	Private	lProdDesp	:= .F.
	Private	oCritical	:= Critical():New() 

	If !_cIdModel $"SB1MASTER"
		Return _lRet
	EndIf

	lProdDesp := !Empty(U_RtProdDp(_oModel:GetValue("B1_TIPO"),_oModel:GetValue("B1_LINHA"),_oModel:GetValue("B1_GRUPO"),,1))

	//Retira os espa็os indevidos antes de fazer a valida็ใo, para garantir a inclusใo sem espa็os indesejados.
	_oModel:SetValue("B1_COD",  RTRIM(_oModel:GetValue("B1_COD")))
	_oModel:SetValue("B1_DESC",  RTRIM(_oModel:GetValue("B1_DESC")))
    //CHUMBA O CODIGO DE BARRRAS COM O CODIGO DE PRODUTO
	If Empty(Alltrim(_oModel:GetValue("B1_CODBAR"))) .or. !U_vldCharEsp(_oModel:GetValue("B1_CODBAR"), "B1_CODBAR", .f. )
		_oModel:SetValue("B1_CODBAR", _oModel:GetValue("B1_COD"))
	EndIf
	
	If _oModel:GetValue("B1_TIPO") $ _cParam
		_oModel:SetValue("B1_RASTRO", "L")
	EndIf
	
	//WMS ATIVO
	If IntDl()
		If _oModel:GetValue("B1_TIPO") $ _cParam
			U_CriaSBZ(_oModel:GetValue("B1_COD"),'BZ_LOCALIZ','S',cEmpAnt,cFilAnt,.T.)
		EndIf
	EndIf
	
	// Caso nao seja atraves de rotina automatica ou rotinas que criam automaticamente o produto
	// nao executa as valida็๕es, deixa incluir sem preencher estes dados...
	If	(( IsBlind() ) .or. ( AllTrim(FunName()) $ 'COM001A' .OR. IsInCallStack('U_FAT12UPD') )) .and. Type("cErroApiProd") ==  "U"
		Return _lRet
	EndIf

	// Valida a quantidade usada por maquina
	If	_oModel:GetValue("B1_TIPO") $ "ME/MF/MI/MJ"
		If	_oModel:GetValue("B1_QUMQ") <= 0
			_lRet := .F.
			if Type("cErroApiProd") <>  "U"
				cErroApiProd	:= "Produto sem quantidade usada por maquina informada."
			else
				Help('',1,'A010TOK',,OemToAnsi('Produto sem quantidade usada por maquina informada.'),1)
			EndIF			
		EndIf
	EndIf


	// Valida c๓digo
	_lRet := U_vldCharEsp(_oModel:GetValue("B1_COD"), "B1_COD" )

	// Valida Descri็ใo
	if !U_vldCharEsp(_oModel:GetValue("B1_DESC"), "B1_DESC", .f.) .and. _lRet
		_lRet := U_vldCharEsp(_oModel:GetValue("B1_DESC"), "B1_DESC")
	EndIF

	// Valida o percentual de % IPI informado x % IPI da NCM
	  IF ( ! Empty(_oModel:GetValue("B1_POSIPI")) )	
	  // Realizado inclusใo da valida็ใo se o campo B1_EX_NCM estiver preenchido Chamado 4175
	   IF ( ! Empty(_oModel:GetValue("B1_EX_NCM")) )	
		If	SYD->(DbSeek(xFilial("SYD") + M->B1_POSIPI + M->B1_EX_NCM))
			If	SYD->YD_PER_IPI <> M->B1_IPI
				_lRet := .f.
				if Type("cErroApiProd") <>  "U"
					cErroApiProd	:= "O percentual de IPI informado estแ divergente do percentual cadastrado na NCM."
				else
					Help('',1,'A010TOK',,OemToAnsi('O percentual de IPI informado estแ divergente do percentual cadastrado na NCM.'),1)
				EndIF				
			Endif
		Else
			_lRet := .f.
			if Type("cErroApiProd") <>  "U"
				cErroApiProd	:= "Produto com NCM informada invแlida, verifique o campo e preencha corretamente."
			else
				Help('',1,'A010TOK',,OemToAnsi('Produto com NCM informada invแlida, verifique o campo e preencha corretamente.'),1)
			EndIF				
		EndIf
	
	    ELSEIF	SYD->(DbSeek(xFilial("SYD") + M->B1_POSIPI))
			If	SYD->YD_PER_IPI <> M->B1_IPI
				_lRet := .f.
				if Type("cErroApiProd") <>  "U"
					cErroApiProd	:= "O percentual de IPI informado estแ divergente do percentual cadastrado na NCM."
				else
					Help('',1,'A010TOK',,OemToAnsi('O percentual de IPI informado estแ divergente do percentual cadastrado na NCM.'),1)
				EndIF	
				
			Endif
		Else
			_lRet := .f.
			if Type("cErroApiProd") <>  "U"
				cErroApiProd	:= "Produto com NCM informada invแlida, verifique o campo e preencha corretamente."
			else
				Help('',1,'A010TOK',,OemToAnsi('Produto com NCM informada invแlida, verifique o campo e preencha corretamente.'),1)
			EndIF
		EndIf
	Endif

	If	! _oModel:GetValue("B1_ORIGEM") $ "0#2#3#4#5#7#8"
		_lRet := .F.
		if Type("cErroApiProd") <>  "U"
			cErroApiProd	:= "Por favor verifique os campos Prod. Import,  Origem."
		else
			Help('',1,'A010TOK',,OemToAnsi('Por favor verifique os campos Prod. Import,  Origem.'),1)
		EndIF
		
	Endif

	// Valida o codigo do item da marca
	If	_lRet
		_lRet := U_VLDMARCACOM(_oModel:GetValue("B1_FABRIC"),.T.)
	EndIf
	
	If ! ALTERA
	
		//VALIDA O PRODUTO DE DESPESA, CASO NรO SEJA O COORDENADOR DO SETOR FISCAL
		If ! U_RtCheckE("EV_APV_COM_ALT_PROD_DIRETO",.F.)   
			//VALIDA B1_TIPO
			If ! lVldTipo(_oModel:GetValue("B1_TIPO"))
				_cMsgErro += "- Inconsist๊ncia no campo Tipo."
			EndIf
			//VALIDA B1_LINHA
			If ! lVldLinha(_oModel:GetValue("B1_LINHA"))
				If !Empty(_cMsgErro)
					_cMsgErro += "<br>"
				EndIf
				_cMsgErro += "- Inconsist๊ncia no campo Linha."
			EndIf
			//VALIDA B1_GRUPO
			If ! lVldGrupo(_oModel:GetValue("B1_GRUPO"))
				If !Empty(_cMsgErro)
					_cMsgErro += "<br>"
				EndIf
				_cMsgErro += "- Inconsist๊ncia no campo Grupo."
			EndIf
		
			//VALIDA B1_COD
			If ! lVldCod(_oModel:GetValue("B1_COD"))
				If !Empty(_cMsgErro)
					_cMsgErro += "<br>"
				EndIf
				_cMsgErro += "- Inconsist๊ncia no campo C๓digo."
			EndIf
		
			//VALIDA B1_GRTRIB
			If ! lVldGrTr(_oModel:GetValue("B1_GRTRIB"))
				If !Empty(_cMsgErro)
					_cMsgErro += "<br>"
				EndIf
				_cMsgErro += "- Inconsist๊ncia no campo Grupo Tributa็ใo."
			EndIf
			
			If lProdDesp .and. ! lVldDesp(_oModel:GetValue("B1_TIPO"),_oModel:GetValue("B1_LINHA"),_oModel:GetValue("B1_GRUPO")) .and. !lInsumo
				If !Empty(_cMsgErro)
					_cMsgErro += "<br>"
				EndIf
				_cMsgErro += "- O produto de despesa nใo estแ de acordo com a combina็ใo de Linha+Grupo+Tipo."
			Endif
		
			If !Empty(_cMsgErro)
				FWAlertWarning(_cMsgErro, "CRอTICAS - "+ProcName()+" - Linha "+cValtoChar(ProcLine()))
				if Type("cErroApiProd") <>  "U"
					cErroApiProd	+= _cMsgErro	
				ENDIF
			EndIf

		EndIf
	EndIf

	If _lRet .and. ALTERA
		If Alltrim(SB1->B1_GRTRIB) <>  Alltrim(_oModel:GetValue("B1_GRTRIB"))
			U_EventRec('COM01AGRTRIB',{RetSqlName('SB1'),xFilial('SB1')+SB1->B1_COD,1,'B1_GRTRIB',Alltrim(SB1->B1_GRTRIB),Alltrim(M->B1_GRTRIB)})
			U_fAjuSbz(SB1->B1_COD, M->B1_GRTRIB,IIF(M->B1_IPI<>SB1->B1_IPI,M->B1_IPI,SB1->B1_IPI))
		EndIf
	EndIf
	

	// Restaura a area anterior ao processamento
	RestArea(_aAreaOld)    

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RtProdDp บAutor  ณMatheus Cunha     บ Data ณ 05/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o produto ้ de despesa 		  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA010             							  			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function RtProdDp(cTipo,cLinha,cGrupo,lShowMsg,nRetorno)
	Local	aTipos		as array
	Local	aLinhas		as array
	Local	aGrupos		as array
	Local	cRet		as character	
	Local	lMata010	as logical 
	Local	nX			as numeric
	Local	nY			as numeric
	Local	nZ			as numeric
	Local 	cSimb		:= "D"
    Local   oModel      := FWModelActive()
    Local   _oModel     := oModel:GetModel("SB1MASTER")
	Local   cNamTip     := ''
	Default	cTipo		:= Space(TamSX3("B1_TIPO")[1])
	Default	cLinha		:= Space(TamSX3("B1_LINHA")[1])
	Default	cGrupo		:= Space(TamSX3("B1_GRUPO")[1])
	Default	lShowMsg	:= .F.
	Default	nRetorno	:= 0
	
	//Inicializa as variแveis
	cRet	:= ""
	aTipos 	:= StrTokArr(GetNewPar("MV_DTIPO" ,""),";")
	aLinhas	:= StrTokArr(GetNewPar("MV_DLINHA",""),";")
	aGrupos	:= StrTokArr(GetNewPar("MV_DGRUPO",""),";")
	lMata010:= IIf(AllTrim(FunName()) == "MATA010",.T.,.F.)
	
	//Verfica็ใo incluํda para ignorar quando ้ chamado via EXECAUTO
	If ! lMata010
		If nRetorno == 1
			cRet := _oModel:GetValue("B1_COD")
		Else
			cRet := _oModel:GetValue("B1_GRTRIB")
		EndIf
		
		Return cRet
	EndIf
	
	If ALTERA
		If nRetorno == 1
			cRet := _oModel:GetValue("B1_COD")
		Else
			cRet := _oModel:GetValue("B1_GRTRIB")
		EndIf
		
		Return cRet
	EndIf

	//Remove espa็os das variแveis necessแrias
	cTipo	:= AllTrim(cTipo)
	cLinha	:= AllTrim(cLinha)
	cGrupo	:= AllTrim(cGrupo)

	if cGrupo == '6500'
		cNamTip := 'Marketing'
		cSimb 	:= "MK"
		lInsumo := .t. 
	EndIF
	if cGrupo == '6600'
		cNamTip := 'despesa'
		cSimb 	:= "IN"
		lInsumo := .t. 
	EndIF
	if cGrupo == '6700'
		cNamTip := 'EndoMarketing'
		cSimb 	:= "EM"
		lInsumo := .t. 
	EndIF
	if cGrupo == '6800'
		cNamTip := 'Seguran็a'
		cSimb 	:= "SG"
		lInsumo := .t. 
	EndIF

	//Prossegue se tiverem todos preenchidos
	If ! Empty(cTipo) .and. ! Empty(cLinha) .and. ! Empty(cGrupo) 
		//Verifica o tipo
		For nX := 1 To Len(aTipos)
			If cTipo == aTipos[nX]
				//Verifica a linha
				For nY := 1 To Len(aLinhas)
					If cLinha == aLinhas[nY]
						//Verifica o grupo
						For nZ := 1 To Len(aGrupos)
							If cGrupo == aGrupos[nZ]
								Do Case
									//CำDIGO
									Case nRetorno == 1
									cRet := cSimb+cLinha+cGrupo+u_cSeqDsp(cLinha,cGrupo)
									//GRUPO TRIBUTAวรO
									Case nRetorno == 2
									cRet := cFindGtr(cTipo)
								EndCase
								If lShowMsg
									MsgInfo("O sistema identificou que o produto sendo cadastro ้ de " + cNamTip + ", portando o c๓digo do produto foi alterado, caso nใo esteja de acordo, revise o cadastro.","PRODUTO DE " + Upper(cNamTip))
								EndIf
							EndIf
						Next nZ
					EndIf
				Next nY
			EndIf
		Next nX
	EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |cSeqDsp บAutor  ณMatheus Cunha     บ Data ณ 07/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o produto ้ de despesa 		  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RtProdDp              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function cSeqDsp(cLinha,cGrupo)
	Local	aAreaSB1	as array
	Local	aParams		as array
	Local	lSeq		as logical
	Local	cQuery 		as character
	Local	cAliasQry	as character
	Local	cRet		as character
	Local	oStm		as object
	Local 	cSimb 		:= "D"
	Default	cLinha		:= Space(TamSX3("B1_LINHA")[1])	
	Default	cGrupo		:= Space(TamSX3("B1_GRUPO")[1])	

	//Inicializa as variแveis
	aAreaSB1	:= GetArea()
	aParams		:= {}
	lSeq		:= .T.
	cAliasQry	:= GetNextAlias()
	oStm		:= FWPreparedStatement():New()
	cRet		:= "000"

	//Adiciona os parโmetros de busca
	if cGrupo == '6600'
		cSimb := "IN"
	EndIF

	aAdd(aParams,xFilial("SB1"))
	aAdd(aParams,cSimb+cLinha+cGrupo+"%")
	aAdd(aParams,cLinha)
	aAdd(aParams,cGrupo)

	//Busca os ๚ltimos produtos cadastrados
	cQuery	:= " SELECT MAX(SB1.B1_COD) CODIGO"
	cQuery 	+= " FROM " + RetSqlName("SB1") + " SB1"
	cQuery 	+= " WHERE SB1.B1_FILIAL = ?"
	cQuery 	+= " AND SB1.B1_COD LIKE ?"
	cQuery 	+= " AND SB1.B1_LINHA = ?"
	cQuery 	+= " AND SB1.B1_GRUPO = ?"
	oStm:setQuery(cQuery)
	oStm:setParams(aParams)
	cQuery := oStm:getFixQuery()
	oStm:destroy()
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)

	(cAliasQry)->(DbGoTop())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If (cAliasQry)->( ! EoF() )
		cRet := SubStr((cAliasQry)->CODIGO,9,11)
		//Percorre at้ encontrar um c๓digo que nใo existe
		While lSeq
			cRet := StrZero(Val(SomaStr(cRet,"001")),3,0)
			//Verifica se nใo existe
			If ! SB1->(DbSeek(xFilial("SB1")+cSimb+PadR(cLinha,TamSX3("B1_LINHA")[1])+PadR(cGrupo,TamSX3("B1_GRUPO")[1])+cRet))
				lSeq := .F.
			EndIf
		EndDo

	EndIf

	(cAliasQry)->(DbCloseArea())


	RestArea(aAreaSB1)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVdlTipo บAutor  ณMatheus Cunha     บ Data ณ 07/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o campo Tipo (B1_TIPO)	  				 			  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MTA010OK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldTipo(cTipo)
	Local	aTipo 	as array
	Local	lRet	as logical
	Local	nX		as numeric

	//Inicializa as variแveis necessแrias
	lRet	:= .T.
	aTipo 	:= StrTokArr(GetNewPar("MV_DTIPO" ,{}),";")

	If ! lProdDesp
		For nX := 1 To Len(aTipo)
			If AllTrim(cTipo) == aTipo[nX]
				_cMsgErro += "- O Tipo informado ้ exclusivo para produtos de despesa."
				lRet := .F.
				Exit
			EndIf
		Next nX
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVldLinha บAutor  ณMatheus Cunha     บ Data ณ 07/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o campo Linha (B1_LINHA)	  		  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MTA010OK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldLinha(cLinha)
	Local	aLinha 	as array
	Local	lRet	as logical
	Local	nX		as numeric

	//Inicializa as variแveis necessแrias
	lRet	:= .T.
	aLinha 	:= StrTokArr(GetNewPar("MV_DLINHA" ,{}),";")

	If ! lProdDesp
		For nX := 1 To Len(aLinha)
			If AllTrim(cLinha) == aLinha[nX]
				_cMsgErro += "- A Linha informada ้ exclusivo para produtos de despesa."
				lRet := .F.
				Exit
			EndIf
		Next nX
	EndIf

Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVldGrupo บAutor  ณMatheus Cunha     บ Data ณ 07/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o campo Grupo (B1_GRUPO)			  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MTA010OK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldGrupo(cGrupo)
	Local	aGrupo 	as array
	Local	lRet	as logical
	Local	nX		as numeric

	//Inicializa as variแveis necessแrias
	lRet	:= .T.
	aGrupo 	:= StrTokArr(GetNewPar("MV_DGRUPO" ,{}),";")

	If ! lProdDesp
		For nX := 1 To Len(aGrupo)
			If AllTrim(cGrupo) == aGrupo[nX]
				_cMsgErro += "- O Grupo informado ้ exclusivo para produtos de despesa."
				lRet := .F.
				Exit
			EndIf
		Next nX
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVldCod บAutor  ณMatheus Cunha     บ Data ณ 07/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o campo C๓digo (B1_COD)			  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MTA010OK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldCod(cCod)
	Local	aArea	as array
	Local	lRet	as logical
	Local	cLinha	as character
	Local	cGrupo	as character
	Local	cSeq	as character
    Local   oModel      := FWModelActive()
    Local   _oModel     := oModel:GetModel("SB1MASTER")

	//Inicializa as variแveis necessแrias
	aArea	:= GetArea()
	cLinha	:= AllTrim(_oModel:GetValue("B1_LINHA"))
	cGrupo	:= AllTrim(_oModel:GetValue("B1_GRUPO"))
	lRet	:= .T.
	cSeq	:= U_cSeqDsp(_oModel:GetValue("B1_LINHA"),_oModel:GetValue("B1_GRUPO"))

	//Verifica se ้ produto de despesa
	If lProdDesp .and. !lInsumo
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())

		Do Case
			//Verifica se a linha estแ de acordo com o que foi preenchido
			Case cLinha <> SubStr(cCod,2,3)
				_cMsgErro += "- A linha informada no c๓digo de produto nใo estแ de acordo com o campo Linha."
				lRet := .F.
			//verifica se o grupo estแ de acordo com o que foi preenchido
			Case cGrupo <> SubStr(cCod,5,4)
				_cMsgErro += "- O grupo informado no c๓digo de produto nใo estแ de acordo com o campo Grupo."
				lRet := .F.
			Case cSeq <> SubStr(cCod,9,3)
				_cMsgErro += "- A pr๓xima sequ๊ncia de c๓digo deve ser D"+cLinha+cGrupo+cSeq+"."
				lRet := .F.
			//verifica se o c๓digo de despesa jแ existe
			Case SB1->(DbSeek(xFilial("SB1")+cCod))
				_cMsgErro += "- O c๓digo do produto de despesa utilizado jแ existe."
				lRet := .F.
		EndCase

		SB1->(DbCloseArea())
	EndIf
	RestArea(aArea)

Return lRet


/*/{Protheus.doc} vldCharEsp
Fun็ใo para validar caracteres especiais noFEO
@type function
@version 1.0 
@author joao.carvalho
@since 11/10/2022
@param cCod, character, c๓digo de produto
@return variant, retorno
/*/
User Function vldCharEsp(cCod, cField, lShowErr)
Local	nSizeCod 	:= Len(cCod)
Local 	cMsgErro 	:= ""
Local 	nPart	 	:= 0
local 	lEspChar 	:= .f.
Local 	lRet	 	:= .t.
Local 	_cEspecial	:= "@!#$%&*()_+=][{};:?"
Local 	cChars		:= ""
Default cField 		:= "B1_COD"
Default lShowErr	:= .t.

	if  SubStr(cCod,1,1) == " " .or. !(IsAlpha( SubStr(cCod,1,1) ) .or. IsDigit( SubStr(cCod,1,1) ))
		cMsgErro += " Foi encontrado espa็o ou caracter diferente de letra e n๚mero antes d"  + iif(cField == "B1_COD","o c๓digo", "a descri็ใo" ) +  " do produto, retire-os para prosseguir!" + "<br>"
	EndIF
	if  !(IsAlpha( SubStr(cCod,len(Alltrim(cCod)),1) ) .or. IsDigit( SubStr(cCod,len(Alltrim(cCod)),1) ))
		cMsgErro += " Foi caracter diferente de letra e n๚mero no fim d"  + iif(cField == "B1_COD","o c๓digo", "a descri็ใo" ) +  " do produto, retire-os para prosseguir!" + "<br>"
	EndIF
	// Faz os tratamentos retirando coisas que nao sejam letas e nem numeros
	For nPart := 1 to nSizeCod
		If SubStr(cCod,nPart,1) <> " "  .and. ( !(IsAlpha( SubStr(cCod,nPart,1) ) .or. IsDigit( SubStr(cCod,nPart,1) ) .or. ;
			 cValtoChar(Asc(SubStr(cCod,nPart,1))) $ '|44|45|46|47') .or.   SubStr(cCod,nPart,1) $ _cEspecial )
			lEspChar := .t. 
			cChars +=  SubStr(cCod,nPart,1) +  ", "
		EndIf
	Next nPart
	cChars := Left(cChars,len(cChars)-1)
	if lEspChar
		cMsgErro += " Foi encontrado caraceteres especiais (" + cChars + ") n" + iif(cField == "B1_COD","o c๓digo", "a descri็ใo" ) +  " do produto, retire-os para prosseguir!" + "<br>"
	EndIF

	if !Empty(cMsgErro)
		if lShowErr
			MsgStop(cMsgErro, "Erro caractere especial")
		EnDIF
		lRet := .f.
	EndIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVldGrTr บAutor  ณMatheus Cunha     บ Data ณ 13/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o campo C๓digo (B1_GRTRIB)			  				  บฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MTA010OK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldGrTr(cGrupoTrib)
	Local	cGrTrib	as character
	Local	lRet	as logical
    Local   oModel  := FWModelActive()
    Local   _oModel := oModel:GetModel("SB1MASTER")

	//Inicializa as variแves
	cGrTrib := cFindGtr(_oModel:GetValue("B1_TIPO"))
	lRet	:= .T.

	//Valida o grupo de tributa็ใo, de acordo com o tipo informado
	If ! Empty(AllTrim(cGrTrib)) .and. cGrupoTrib <> cGrTrib
		_cMsgErro += "- O campo Tipo estแ preenchido com " + _oModel:GetValue("B1_TIPO") + ", portanto o Grupo Tributa็ใo deve ser " + cGrTrib
		lRet := .F.
	EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |cFindGtr บAutor  ณMatheus Cunha     บ Data ณ 08/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o grupo de tributa็ใo do produto de despesa.		   ฑฑ
ฑฑบ           															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RtProdDp              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function cFindGtr(cTipo)
	Local	cRet	as character

	Do Case
		Case cTipo == "AI"
		cRet := "P97"
		Case cTipo == "MC"
		cRet := "P99"
		Case cTipo == "OI"
		cRet := "P98"
		Case cTipo == "SV"
		cRet := "P98"
		Otherwise
		cRet := Space(TamSX3("B1_GRTRIB")[1])
	EndCase

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |lVldDesp บAutor  ณMatheus Cunha     บ Data ณ 08/11/18  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o produto de despesa de acordo com a planilha 		   ฑฑ
ฑฑบ           definida pelo setor fiscal e controladoria				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ A010TOK              							  		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function lVldDesp(cTipo,cLinha,cGrupo)
	Local	aLinhas		as array
	Local	aGrupos		as array
	Local	cTabelaSX5	as character
	Local	lRet		as logical
	
	//Inicializa as variแveis
	cTabelaSX5	:= "9L"
	aLinhas 	:= StrTokArr(Posicione("SX5",1,xFilial("SX5")+cTabelaSX5+PadR(cTipo,TamSX3("X5_CHAVE")[1]),"X5_DESCRI"),";")
	aGrupos		:= StrTokArr(GetNewPar("MV_"+cTipo+"GRUPD",""),";")
	lRet		:= .F.
	
	//Verifica a combina็ใo
	If aScan(aLinhas, { |x| AllTrim(x) == cLinha }) > 0 .and. aScan(aGrupos, { |x| AllTrim(x) == cGrupo }) > 0
		lRet := .T.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณUPDSB1TOSZYบAutor ณLuis Henrique Robustoบ Data ณ  14/11/06  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯอออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para fazer a atualiza dos dados do SZY com base nos บฑฑ
ฑฑบ          ณ dados do cadastro de produto.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ lDelete  : Se .t. (exclusao), .f. (ou vazio) altera/incluiบฑฑ
ฑฑบ          ณ cMaster  : Codigo da Familia de Produtos                  บฑฑ
ฑฑบ          ณ cProduto : Codigo do Produto                              บฑฑ
ฑฑบ          ณ cDesc    : Descricao do produto                           บฑฑ
ฑฑบ          ณ cLinha   : Linha do produto                               บฑฑ
ฑฑบ          ณ nPerc    : Percetual do preco de venda (ainda nao implem) บฑฑ
ฑฑบ          ณ cTipo    : Tipo do similar (0=Produto,1=Similar)          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Todo Produto deve ser um similar, mas nem todo similar eh  บฑฑ
ฑฑบ          ณ um produto, foi feito dessa forma tendo em vista as consul-บฑฑ
ฑฑบ          ณ tas de produtos, para nao mudar o padrao de consultas F3.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA010                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA  ณ  MOTIVO                                        บฑฑ
ฑฑฬออออออออออุอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ           ณ                                                บฑฑ
ฑฑศออออออออออฯอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UPDSB1TOSZY(lDelete,cMaster,cProduto,cDesc,cLinha,nPerc,cTipo,cCodMudou)
Local	lInclui	:= .t.
Local	cCodSim	:= cProduto
Default lDelete	:= .f.
Default cTipo		:= '0'
Default	cCodMudou	:= ''

		// Ajusta o codigo simples (sem simbolos e caracteres estranhos)
		cCodSim := xTratCodSim(cCodSim)

		// Verifica se existe o registro dentro do SZY.
		DbSelectArea('SZY')
		SZY->(DbSetOrder(2))
		If	SZY->(DbSeek(xFilial('SZY') + cProduto))
			lInclui := .f.
		EndIf

		// Executa a inclusao/alteracao do registro.
		If	( ! lDelete ) // Incluir e/ou alterar
			If	RecLock('SZY',lInclui)
				Replace SZY->ZY_FILIAL 		With xFilial('SZY')
				Replace SZY->ZY_MASTER 		With cMaster
				Replace SZY->ZY_PROD		With cProduto
				Replace SZY->ZY_DESC		With cDesc
				Replace SZY->ZY_LINHA		With cLinha
				Replace SZY->ZY_PERPRC		With nPerc
				Replace SZY->ZY_TPSIM		With cTipo
				If	( lInclui ) // Salva o usuario que incluiu...
					Replace SZY->ZY_DTINC	With dDataBase
					Replace SZY->ZY_USINC	With SubStr(cUserName,1,25)
				Else // Salva o usuario que alterou...
					Replace SZY->ZY_DTALT	With dDataBase
					Replace SZY->ZY_USALT	With SubStr(cUserName,1,25)
				EndIf
				Replace SZY->ZY_CODSIM		With cCodSim 
				Replace SZY->ZY_MUDCOD		With cCodMudou
				SZY->(MsUnLock())
			Else
				Help(' ',1,'REGNOIS')
			EndIf
		Else // Excluir
			If	!lInclui // Caso encontrou o registro no SZY
				If	RecLock('SZY',lInclui)
					SZY->(DbDelete())
					SZY->(MsUnLock())
				Else
					Help(' ',1,'REGNOIS')
				EndIf
			EndIf
		EndIf

Return

Static Function xTratCodSim(cCodSim)
Local	nSizeCod := Len(cCodSim)
Local	cCodRet  := ""
Local 	nPart	 := 0

		// Faz os tratamentos retirando coisas que nao sejam letas e nem numeros
		For nPart := 1 to nSizeCod
			If	( SubStr(cCodSim,nPart,1) <> " " ) .and. ( IsAlpha( SubStr(cCodSim,nPart,1) ) .or. IsDigit( SubStr(cCodSim,nPart,1) ) )
				cCodRet += SubStr(cCodSim,nPart,1)
			EndIf
		Next nPart

Return cCodRet

/*/{Protheus.doc} VldSeqId
Valida/Ajusta o ID sequencia para B1_XID
@type function
@version 1.0 
@author Leandro.brutus
@since 16/02/2022
/*/
User Function VldSeqId(nIdSeq)

Local lRet  	:= .T.
Local aAreaSB1	:= SB1->(GetArea())

dbSelectArea("SB1")
DBOrderNickname("FSXID")

lRet  := MsSeek(xFilial("SB1")+cValToChar(nIdSeq))

// Retorna a area anterior do sistema.
RestArea(aAreaSB1)

Return lRet

Static Function fLimpaSBZ(cCodAjst)

    Local cAliasSBZ := GetNextAlias()

    BeginSQL Alias cAliasSBZ
        SELECT 
            BZ_FILIAL
            , BZ_COD
            , BZ_GRTRIB
            , R_E_C_N_O_ RECNO_BZ
        FROM TOTVSRECH.SBZ010
        WHERE D_E_L_E_T_ = ' '
        AND BZ_COD = %Exp:cCodAjst%
    EndSQL

    While (cAliasSBZ)->(!Eof())
        DbSelectArea("SBZ")
        SBZ->(DbGoto((cAliasSBZ)->RECNO_BZ))
        If RecLock("SBZ", .F.)
            SBZ->(DbDelete())   
            SBZ->(MsUnlock())
        EndIf
        (cAliasSBZ)->(DBSkip())
    Enddo

    (cAliasSBZ)->(DBCloseArea())
	
Return

/*/{Protheus.doc} fCadSim
	(long_description)
	@type  Static Function
	@author user
	@since 04/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fCadSim
	
	Local aParamBox := {}
	Local aRet		:= {}
	Local cCod		:= Space(TamSX3("B1_COD")[1])
	Local cDesc		:= Space(TamSX3("B1_DESC")[1])
	Local cMaster	:= Space(TamSX3("B1_MASTER")[1])
	Local nIDSIM	:= Space(TamSX3("B1_XID")[1])

	If Type("_lCodSim") <> "U"
		If _lCodSim
			cCod	:= _cSimCod
			cDesc	:= _cSimDes
			cMaster	:= _cSimMst
			nIDSIM	:= _cSimXID
		EndIf
	EndIf

	aAdd(aParamBox,{1,"Cod. Similar",cCod,"","U_RTVldSim(1,'B1_COD')","SB1","",120,.F.})
	aAdd(aParamBox,{1,"ID Similar",nIDSIM,"","U_RTVldSim(21,'B1_XID')","","",109,.F.})
	aAdd(aParamBox,{1,"Descri็ใo",cDesc,"","","",".F.",109,.F.})
	aAdd(aParamBox,{1,"Master Similar",cMaster,"","","",".F.",109,.F.})

	If ParamBox(aParamBox,"Cadastro de Similares",@aRet)
		FWAlertSucess("Informa็๕es salvas!<br>Ao finalizar o cadastro, serแ gravado a amarra็ใo do produto similar.","SUCESSO - "+ProcName()+" - Linha "+cValtoChar(ProcLine()))
	Else
		FWAlertWarnig("Informa็๕es nใo foram salvas!","ATENวรO - "+ProcName()+" - Linha "+cValtoChar(ProcLine()))
	EndIf

Return


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 04/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function RTVldSim(nIndSB1,cCampo)

	Local aAreaSB1  := GetArea()
	Local lRet		:= .T.
	Local oModel   	:= FWModelActive()    
	Local _oModel  	:= oModel:GetModel("SB1MASTER")

	SB1->(DbSetOrder(nIndSB1))

	If cCampo == "B1_COD"

		If SB1->(DbSeek(FWxFilial("SB1")+MV_PAR01))
			MV_PAR02 := SB1->B1_XID
			MV_PAR03 := SB1->B1_DESC
			MV_PAR04 := SB1->B1_MASTER
		Else
			lRet := .F.
			FWAlertWarning("C๓digo nใo encontrado<br>Verifique!","ATENวรO - "+ProcName()+" - Linha "+cValtoChar(ProcLine()))
		EndIf

	ElseIf cCampo == "B1_XID"

		If SB1->(DbSeek(FWxFilial("SB1")+Str(MV_PAR02, TamSX3("B1_XID")[1], TamSX3("B1_XID")[2])))
			MV_PAR01 := SB1->B1_COD
			MV_PAR03 := SB1->B1_DESC
			MV_PAR04 := SB1->B1_MASTER
		Else
			lRet := .F.
			FWAlertWarning("ID nใo encontrado<br>Verifique!","ATENวรO - "+ProcName()+" - Linha "+cValtoChar(ProcLine()))
		EndIf

	EndIf

	If lRet
		_SetNamedPrvt("_cSimCod",SB1->B1_COD,"MATA010")
		_SetNamedPrvt("_cSimXID",SB1->B1_XID,"MATA010")
		_SetNamedPrvt("_cSimDes",SB1->B1_DESC,"MATA010")
		_SetNamedPrvt("_cSimMst",SB1->B1_MASTER,"MATA010")
		_SetNamedPrvt("_lCodSim",.T.,"MATA010")
		_oModel:SetValue("B1_MASTER",  _cSimMst)
	Else
		If Type("_lCodSim") <> "U"
			_cSimCod := ""
			_cSimXID := ""
			_cSimDes := ""
			_cSimMst := ""
			_lCodSim := .F.
		EndIf
	Endif

	RestArea(aAreaSB1)

Return lRet
