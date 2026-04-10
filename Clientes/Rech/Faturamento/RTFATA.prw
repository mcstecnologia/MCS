#include "Protheus.ch"
#Include "FWPrintSetup.ch"
#Include "RPTDef.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

#DEFINE CORGREY		RGB(128,128,128)
#DEFINE CORGREEN 	RGB(152,251,152)
#DEFINE CORRED 		RGB(255,160,122)
#DEFINE CORBLUE  	RGB(135,206,250)
#DEFINE CORORANGE	RGB(255,165,0)
#DEFINE CORPINK 	RGB(255,182,193)
#DEFINE CORNO 		RGB(240,248,255)
#DEFINE CORCIA 		RGB(95,158,160)
#DEFINE CORBROWN	RGB(184,134,11)
#DEFINE CR			chr(13)+chr(10)

/*/{Protheus.doc} RTFATA
Rotina Automatização de Geração de Notas Fiscais (Faturamento), Transmissão e Monitoramento e impressões
@type function
@version 2.0
@author Vitor.seide
@since 10/12/2021
/*/
User Function RtFata(cFilialX,cPedidoX,lAutoX,cUsuAutoX,cNomAutoX,cRecHumX,cModoExec)
Local aAreas			:= {}
Local lConectEnv 		:= .F.
Local aParBol 			:= {}
Local aBoletos 			:= {}
Local cThreadAtual 		:= ''
Local aDadosExec 		:= {}
Local nThread 			:= 0
Local cTipoExec 		:= ''
Private lGerarNota 		:= .T.
Private lTransmitir 	:= .T.
Private lMonitorar 		:= .T.
Private lImprimir 		:= .T.
Private aRetFat 		:= {}
Private lImpDnfBol 		:= .F.
Private lImpEtq			:= .F.
Private cXImpDCD  		:= ''
Private cXImpDCDFila	:= ''
Private fSalvaConsole	:= .F.
Private cXNameSrvImp	:= ''
Private lWms 			:= .F.
Private cUrlSped 		:= ""
Private cIdEnt 			:= ""
Private aLog 			:= {}
Private cFACodFil 		:= ''
Private cFANumPed 		:= ''
Private lAuto 			:= .F.
Private cUsuAuto 		:= ''
Private cNomAuto 		:= ''
Private cRHAuto 		:= ''
Private cConfer   		:= ''
Private aRecnoSc9 		:= {}
Default cFilialX 		:= "" 
Default cPedidoX 		:= ""
Default lAutoX 			:= .T.
Default cUsuAutoX 		:= ''
Default cNomAutoX 		:= ''
Default cRecHumX		:= ""
Default cModoExec		:= ''

	// Define as variaveis private com o conteudo recebido
	cFACodFil	:= cFilialX
	cFANumPed   := cPedidoX
	lAuto		:= lAutoX
	cUsuAuto	:= cUsuAutoX
	cNomAuto	:= cNomAutoX
	cRHAuto		:= cRecHumX

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Validações de parametros obrigatorios para funcionamento
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If Empty(cFACodFil) .or. Empty(cFANumPed)
			// Não precisa fazer restore de area pois nem abriu
			Return
		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Caso necessario faz a conexão com ambiente
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lAutoX
			//Prepare Environment Empresa '01' Filial cFACodFil Modulo "FAT" 
			RpcSetEnv("01",cFACodFil,,,,GetEnvServer(),{})
			lConectEnv := .t.			
		EndIf	

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Faz posicionamento na filial e carregamento de algumas configurações
	/////
	//////////////////////
	//////////////////////
	////////////////////// 

		// Faz backup das areas
		aAreas 		:= { GetArea(),;
						 SC5->(GetArea()),;
						 SC6->(GetArea()),;
						 SC9->(GetArea()),;
						 SF2->(GetArea()),;
						 Z8C->(GetArea()),;
						 SM0->(GetArea());
						}

		// Faz o posicionamento na filial
		cFilBkp := cFilAnt
		cFilAnt := cFACodFil
		DbSelectArea("SM0")
		SM0->(DbSetOrder(1))
		SM0->(DbSeek(cEmpAnt + cFilAnt))

		// Pega alguns dados gerais para uso
		fSalvaConsole 	:= SuperGetMV('RT_RTLOGFA',.F.,.F.)
		cUrlSped 		:= AllTrim(SuperGetMV("MV_SPEDURL",.F.,"",cFilAnt))
		cXNameSrvImp	:= Alltrim(SuperGetMv("RT_XSRVIMP",.F.,'\\SRV-IMP\',cFilAnt))
		cTipoExec		:= AllTrim(SuperGetMV("RC_FATAUTT",.F.,"COLETOR",cFilAnt))
		cIdEnt 			:= RetIdEnti(.F.)
		lWms			:= IntDl()

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Verifica o tipo de execução que esta configurado
	/////
	//////////////////////
	//////////////////////
	////////////////////// 

		// Faturamento manual sempre permite executar, independente o modo configurado
		If !(cModoExec == 'MANUAL' .or. cModoExec == 'MANUALPADRAO')
			If cTipoExec == 'MISTO'
				If cModoExec = 'COLETOR'
					If !(Posicione("SC5",1,xFilial("SC5",cFACodFil)+cFANumPed,'C5_PRIORI') $ '1/4') // 1-Cliente Balcão e 4-Cliente Retira
						AEval(aAreas, {|area| RestArea(area)}) 
						Return
					EndIf
				EndIf

			// Faturamento por coletor permite apenas engatilhado pelo coletor
			ElseIf cTipoExec == 'COLETOR' .and. cModoExec <> 'COLETOR'
				AEval(aAreas, {|area| RestArea(area)}) 
				Return
			
			// Faturamento por scheduler permite apenas faturamento por scheduler
			ElseIf cTipoExec == 'SCHEDULER' .and. cModoExec <> 'SCHEDULER' 
				AEval(aAreas, {|area| RestArea(area)}) 
				Return

			EndIf
		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Verifica se já não possui uma em execução
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
	
		cThreadAtual := fActionsLog('CONSULTA','Z8C_THREAD')
		If !Empty(Alltrim(cThreadAtual))
			fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO',"Já existe algum outro processo executando este faturamento com a thread " + Alltrim(cThreadAtual),.T.)
			
			AEval(aAreas, {|area| RestArea(area)}) 
			Return

		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Valida se o pedido de venda pode ser faturado
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
	
		
		// Pega os dados de execução
		// https://tdn.totvs.com/display/tec/GetUserInfoArray
		aDadosExec 	:= GetUserInfoArray()
		nThread 	:= aScan(aDadosExec,{|x| x[3] == ThreadId() })
		// aDadosExec[nThread][1] -> Nome de usuário
		// aDadosExec[nThread][2] -> Nome da máquina local
		// aDadosExec[nThread][3] -> ID da Thread
		// aDadosExec[nThread][4] -> Servidor (caso esteja usando Balance; caso contrário é vazio)

		// Gera uma separação de inicio de processo
		fActionsLog('GRAVAR','Z8C_RETFAT','','INICIO','----------------------------------------- Iniciando processo.',.T.)
		// Salva a Thread que irá executar
		fActionsLog('GRAVAR','Z8C_THREAD',cValToChar(aDadosExec[nThread][3]),'INICIO','Gravando ThreadID de inicio de faturamento automatico do pedido.')
		// Soma o numero de tentativas
		fActionsLog('GRAVAR','Z8C_NTNTVS',1,'INICIO','Incrementando contador de tentativas de faturamento automatico do pedido.')
		
		// Validações de pedido
		fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Inicio de validação do pedido para identificar se esta apto a faturar.",.T.)
		// Função que faz todas validações
		ValidPedFat()
			
		If lGerarNota
			// Preenche a data de inicio
			fActionsLog('GRAVAR','Z8C_DTINI',dDataBase,'INICIO','Gravando data de inicio de faturamento automatico do pedido.')
			fActionsLog('GRAVAR','Z8C_HRINI',TimeFull(),'INICIO','Gravando hora de inicio de faturamento automatico do pedido.')
			// Reseta as datas de final
			fActionsLog('GRAVAR','Z8C_DTFIM',Ctod(' / / '),'INICIO',"Resetando data de fim de faturamento automatico do pedido.")
			fActionsLog('GRAVAR','Z8C_HRFIM','','INICIO','Resetando hora de fim de faturamento automatico do pedido.')
			// Atualiza o modo de execução
			fActionsLog('GRAVAR','Z8C_MODEXE',Alltrim(cModoExec),'INICIO','Gravando o modo de execução na tentativa de faturamento automatico.',.F.)
			// Salva o nome da maquina local que irá executar
			fActionsLog('GRAVAR','Z8C_MAQLOC',cValToChar(aDadosExec[nThread][2]),'INICIO','Gravando o nome da Maquina Local de inicio de faturamento automatico do pedido.')
			// Salva o nome do servidor que irá executar
			fActionsLog('GRAVAR','Z8C_MAQSRV',cValToChar(aDadosExec[nThread][4]),'INICIO','Gravando o nome do Servidor de inicio de faturamento automatico do pedido.')
			
			// Atualiza o usuario da ultima execução
			fActionsLog('GRAVAR','Z8C_USER',Alltrim(UsrRetName(cUsuAuto)),'INICIO','Gravando usuario conectado na tentativa de faturamento automatico.')

			// Grava que foi considerado apto para mostrar ao usuario
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido considerado apto a ser faturado automaticamente.",.T.)
		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Geração da nota fiscal de saida
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lGerarNota
			
			fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO','Inicio de geração de nota fiscal.',.T.)
				
			aRetFat := Faturar()
			If Len(aRetFat) > 0
				// Trata indices de produtos sonolentos, dormentes
				U_FPEDSZP()
			Else
				lTransmitir := .F.
				lMonitorar 	:= .F.
				lImprimir 	:= .F.
			EndIf
			
			fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO','Fim de geração de nota fiscal.',.T.)

		EndIf
		
	
	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Transmissão da nota fiscal de saida
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lTransmitir
			
			fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO','Inicio de transmissão de nota fiscal.',.T.)
			lMonitorar := Transmitir(aRetFat[1][2],aRetFat[1][1])
			fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Fim de transmissão de nota fiscal.",.T.)
		
		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Monitoramento da nota fiscal de saida
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lMonitorar
				
			Sleep(10000)
			
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Inicio de monitoramento de nota fiscal.",.T.)
			If !Monitorar(aRetFat[1][2],aRetFat[1][1])
				lImprimir := .F.
			EndIf
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Fim de monitoramento de nota fiscal.",.T.)

		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Impressão de danfe, boletos e etiquetas
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lImprimir
			
			fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"Inicio de impressão de nota fiscal.",.T.)
			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			If SF2->(DbSeek(cFilAnt + aRetFat[1][1] + aRetFat[1][2]))
				aAdd(aParBol,SF2->F2_SERIE) 					// 1 Prefixo Inicial
				aAdd(aParBol,SF2->F2_SERIE) 					// 2 Prefixo Final
				aAdd(aParBol,SF2->F2_DOC) 						// 3 Numero Inicial
				aAdd(aParBol,SF2->F2_DOC) 						// 4 Numero Final
				aAdd(aParBol,Space(TamSx3("E1_PORTADO")[1]) )	// 5 Portador Inicial
				aAdd(aParBol,Replicate('Z',TamSx3("E1_PORTADO")[1])) // 6 Portador Final
				aAdd(aParBol,SF2->F2_CLIENTE) 					// 7 Cliente Inicial
				aAdd(aParBol,SF2->F2_CLIENTE) 					// 8 Cliente Final
				aAdd(aParBol,SF2->F2_LOJA) 						// 9 Loja
				aAdd(aParBol,SF2->F2_LOJA)						// 10 Loja Final
				aAdd(aParBol,dDataBase-365) 					// 11 Vencimento
				aAdd(aParBol,dDataBase+1000)					// 12 Ate o vencimento
				aAdd(aParBol,dDataBase-365) 					// 13 Emissao
				aAdd(aParBol,dDataBase)							// 14 Ate a emissao
				aAdd(aParBol,2) 								// 15 (1=Seleciona titulos,2=Nao seleciona)
				aAdd(aParBol,Space(6)) 							// 16 Bordero
				aAdd(aParBol,"ZZZZZZ") 							// 17 Bordero Final
				aAdd(aParBol,3) 								// 18 1=Somente nao impressos, 2=Somente impressos,3=Todos
				aAdd(aParBol,3) 								// 19 1=Simples/registrado, 2=Carteira,3=Todos
				aAdd(aParBol," ") 								// 20 Filiais separadas por virgula
				Sleep(2000)
				cXImpDCD:= Alltrim(cXNameSrvImp+cXImpDCD)

				If lImpDnfBol
					
					// Gera impressão da DANFE
					If GeraDanfe({aRetFat[1][1],aRetFat[1][1],aRetFat[1][2]},"/spool/",cXImpDCD)
						fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"SUCESSO Gera Danfe da Nota Saída/Série: " + aRetFat[1][1] + " / " + aRetFat[1][2] + ".")
					Else
						fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"ERRO Gera Danfe da Nota Saída/Série: " + aRetFat[1][1] + " / " + aRetFat[1][2] + ".",.T.)
					EndIf
					fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"Fim de impressão de nota fiscal.",.T.)

					// Transfere o titulo para portador
					U_FAT001B(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_COND)
					
					// Gera impressão do BOLETO
					fActionsLog('GRAVAR','Z8C_RETFAT','','BOLETO',"Inicio de impressão de boleto.",.T.)
					U_LF14R(aParBol,.F.,.T.,.F.,aBoletos,,cXImpDCD)
					fActionsLog('GRAVAR','Z8C_RETFAT','','BOLETO',"Fim de impressão de boleto.",.T.)
						
					// Gera impressão de ETIQUETAS
					fActionsLog('GRAVAR','Z8C_RETFAT','','ETIQUETA',"Inicio de impressão de etiquetas.",.T.)
					If lImpEtq
						U_RTETQDSP(.T.,{{xFilial("SC5"),cFANumPed}},cXImpDCDFila)
						fActionsLog('GRAVAR','Z8C_RETFAT','','ETIQUETA',"Entrou na fila de impressao-"+cFANumPed+""+cXImpDCDFila+"-"+UsrRetName(cConfer)+" para Nota Fiscal: " + aRetFat[1][1] + " OK")
					Else
						fActionsLog('GRAVAR','Z8C_RETFAT','','ETIQUETA',"Não havia impressora para etiquetas.")
					EndIf	
					fActionsLog('GRAVAR','Z8C_RETFAT','','ETIQUETA','Fim de impressão de etiquetas.',.T.)
					
				Else
					fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE','Não havia impressoras configuradas.',.T.)
				EndIf	
			Else
				fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"ERRO Posicionamento SF2 da Filial/Nota Saída/Série: " + cFilAnt + " / " + aRetFat[1][1] + " / " + aRetFat[1][2] + ".",.T.)
			EndIf
			
		EndIf

	//////////////////////
	//////////////////////
	//////////////////////
	/////
	///// ETATA -> Finalizar processo
	/////
	//////////////////////
	//////////////////////
	////////////////////// 
		If lGerarNota
			
			// Limpa o nome da maquina local que irá executar
			fActionsLog('GRAVAR','Z8C_MAQLOC','','FINAL','Limpando o nome da Maquina Local de inicio de faturamento automatico do pedido.')
			// Limpa o nome do servidor que irá executar
			fActionsLog('GRAVAR','Z8C_MAQSRV','','FINAL','Limpando o nome do Servidor de inicio de faturamento automatico do pedido.')
			// Grava data e hora final
			fActionsLog('GRAVAR','Z8C_DTFIM',dDataBase,'FINAL',"Gravando data de fim de faturamento automatico do pedido.")
			fActionsLog('GRAVAR','Z8C_HRFIM',TimeFull(),'FINAL','Gravando hora de fim de faturamento automatico do pedido.')
			// Limpando o campo de espera
			fActionsLog('GRAVAR','Z8C_WAITFT','','FINAL','Limpando o campo de data e hora marcado para aguardar..',.F.)
			fActionsLog('GRAVAR','Z8C_WAITUS','','FINAL','Limpando o campo de usuario que marcou para aguardar.',.F.)
			
		EndIf
		// Limpa a Thread que estava executando
		fActionsLog('GRAVAR','Z8C_THREAD','','FINAL','Limpando ThreadID ao finalizar o faturamento automatico do pedido.')
		// Gera uma separação de fim de processo
		fActionsLog('GRAVAR','Z8C_RETFAT','','FINAL','----------------------------------------- Finalizando processo.',.T.)	

	// Restaura os backups
	SM0->(DbCloseArea())
	cFilAnt := cFilBkp
	AEval(aAreas, {|area| RestArea(area)}) 

	// Encerra a conexão
	If lAutoX .and. lConectEnv
		RpcClearEnv()
	EndIf
	
Return

/*/{Protheus.doc} ValidPedFat
Checagem de liberação do pedido de maneira centralizada. VerIfica ZY1 e SC9 para analise se o pedido está apto a ser faturado de maneira automatica.
@author Lucas.schoeffel
@since 04/10/2022
@version 1.0
@type function
/*/
Static Function ValidPedFat()
Local aAreaSA1 	:= SA1->(GetArea())
Local aAreaSA2 	:= SA2->(GetArea())
Local aAreaSC9  := SC9->(GetArea())
Local aAreaDCD 	:= DCD->(GetArea())
Local aAreaZAB  := ZAB->(GetArea())
Local lValido 	:= .T.
Local aBloq		:= {}
Local nY 		:= 1
Local cFaturar 	:= ""
Local lSepar 	:= .F.
Local lConfer 	:= .F.
Local cXErroWs  := ''
Local cPendFat  := ''
Local aColet	:= {}
Local lPedZZL	:= .F.
	
	// Faz validações gerais de ambiente da filial
	If Empty(cUrlSped) .or. Empty(cIdEnt)
		fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"VerIficar parâmetro MV_SPEDURL ou ID Entidade (TSS)",.T.)
		lValido := .F.
	EndIf
	If !U_XisConnTSS(@cXErroWs)
		fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"O WebService esta fora ("+cXErroWs+")",.T.)
		lValido := .F.
	EndIf

	// Valida se há pendências de faturamento
	If !U_RCNFTran(.F.,@cPendFat)
		fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Existem notas fiscais pendentes de transmissão que impedem novos faturamentos: " + cPendFat,.T.)
		lValido := .F.
	EndIf 

	//Valida se pedido foi gerado por ajuste de perda ZZL
	lPedZZL := fValPedZZL(cFACodFil,cFANumPed)

	// Posiciona no SC5 para validações no pedido
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(MsSeek(xFilial("SC5",cFACodFil) + cFANumPed))
		// Não fatura com tranrpotadora desse codigo
		If SC5->C5_TRANSP = '000006'
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido utilizando transportadora 000006 que não gera faturamento automatico.",.T.)	
			lValido := .F.
		EndIf
		// Verific se tem bloqueio de tipo de cliente
		If !SuperGetMV("RT_FTAUTEX",.F.,.T.,cFilAnt)
			If SC5->C5_TIPOCLI = 'X' 
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido para exportação e faturamento automatico esta desabilitado para esse funcionamento. (RT_FTAUTEX)",.T.)
				lValido := .F.
			EndIf
		EndIf
		// Verifica se possui pendência de bloqueio venda a vista
		If AllTrim(SC5->C5_CONDPAG) $ AllTrim(SuperGetMv("RT_CPVVIST",,"999|380|381|382|383|384|385|386",))
			DbSelectArea("ZY1")
			ZY1->(DbSetOrder(3))
			If ZY1->(DbSeek(SC5->C5_FILIAL + "V1" + SC5->C5_NUM + SC5->C5_CLIENTE + SC5->C5_LOJACLI + "1"))
				If AllTrim(ZY1->ZY1_STATUS) == "1"
					fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido Venda a Vista necessita de aprovação para ser faturado.",.T.)
					lValido := .F.
				EndIf
			EndIf
			ZY1->(DbCloseArea())
		EndIf
		// Não pode já ter sido faturado
		If !Empty(Alltrim(SC5->C5_NOTA))
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido já faturado.",.T.)
			aAdd(aRetFat,{SC5->C5_NOTA,SC5->C5_SERIE})
			lValido := .F.
		EndIf
		// Precisa ter volume preenchido
		If SC5->C5_VOLUME1 <= 0 .And. !lPedZZL
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Volume não preenchido no pedido.",.T.)
			lValido := .F.
		Else
			cFaturar += "V"
		EndIf
		// Precisa ter especie preenchida
		If Empty(SC5->C5_ESPECI1) .And. !lPedZZL
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Espécie não preenchida no pedido.",.T.)
			lValido := .F.
		Else
			cFaturar += "E"
		EndIf

		// Valida se houve corte no pedido e se é do SF
		If SuperGetMv("RC_ABORTSF",.F.,"N") == 'S'
			// Apenas pedidos do SalesForce
			DbSelectArea("ZAB")
			ZAB->(DbSetOrder(1))
			If ZAB->(DbSeek(xFilial("ZAB",SC5->C5_FILIAL)+Padr('CRM',TamSx3("ZAB_OWNER")[1])+Padr('PEDCLI',TamSx3("ZAB_TIPO")[1])+Padr('SC5',TamSx3("ZAB_TABELA")[1])+Padr(SC5->C5_FILIAL+SC5->C5_NUM,TamSx3("ZAB_CHAVE")[1])))
				If !fValPedSF(SC5->C5_FILIAL,SC5->C5_NUM)
					fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Pedido do SalesForce sem permissao para faturar - Aborto: "+SC5->C5_XABORTA,.T.)
					lValido := .F.
				EndIf
			EndIf
		EndIf

	Else
		fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Não encontrado na tabela SC5.",.T.)
		lValido := .F.
	EndIf

	// Valida liberação do cadastro do cliente/fornecedor
	If SC5->C5_TIPO <> 'D'
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1",SC5->C5_FILIAL)+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If SA1->(DBRLock(SA1->(Recno()))) 
				SA1->(DBRUnLock(SA1->(Recno()))) 
			Else
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Cadastro do Cliente está sendo usado neste momento. Pedidos precisam de exclusividade nessa tabela. (SA1)",.T.)
				lValido := .F.
			EndIf
		EndIf
	Else
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		If SA2->(DbSeek(xFilial("SA2",SC5->C5_FILIAL)+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If SA2->(DBRLock(SA2->(Recno()))) 
				SA2->(DBRUnLock(SA2->(Recno()))) 
			Else
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Cadastro do Fornecedor está sendo usado neste momento. Pedidos precisam de exclusividade nessa tabela. (SA2)",.T.)
				lValido := .F.
			EndIf
		EndIf
	ENdIf

	// Posiciona no SC9 para validações nas liberações
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	If SC9->(DbSeek(xFilial("SC9",cFACodFil) + cFANumPed))

		// Pega status do WMS
		If lWms
			aColet := fExpStatWms(SC9->C9_FILIAL,SC9->C9_PEDIDO)
		EndIf
		
		Do While !SC9->(Eof()) .And. ;
			SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9",cFACodFil) + cFANumPed 
			
			// Limpa variaveis
			cFaturar 	:= ""
			lSepar 		:= .F.
			lConfer 	:= .F.
			
			If !Empty(SC9->C9_BLCRED) .and. Alltrim(SC9->C9_BLCRED) <> '10'
				aAdd(aBloq,'BLQCRD')
			Else
				cFaturar += "C"
			EndIf

			If lWms
				If SC9->C9_BLWMS <> '05'
					aAdd(aBloq,"BLQWMS")
				Else
					cFaturar += "W"
				EndIf
			Else
				cFaturar += "W"
			EndIf

			If !Empty(Alltrim(SC9->C9_BLEST)) .and. Alltrim(SC9->C9_BLEST) <> '10'
				aAdd(aBloq,"BLQEST")
			Else
				cFaturar += "E"
			EndIf

			For nY := 1 To Len(aColet)
				If AllTrim(SC9->C9_PRODUTO) == AllTrim(aColet[nY][2])
					If AllTrim(aColet[nY][7]) == "SEPARACAO"
						lSepar := .T.
					ElseIf AllTrim(aColet[nY][7]) == "CONFERENCIA"
						lConfer := .T.
					EndIf
				EndIf
			Next nY

			If lSepar .Or. !Empty(SC9->C9_SEPAR) .Or. lPedZZL
				cFaturar += "S"
			Else
				aAdd(aBloq,"NAOSEPAR")
			EndIf

			If lConfer .Or. !Empty(SC9->C9_CONFER) .Or. lPedZZL
				cFaturar += "C"
			Else
				aAdd(aBloq,"NAOCONFER")
			EndIf

			// Verifica se esta locado por algum movimento
			If SC9->(DBRLock(SC9->(Recno()))) 
				SC9->(DBRUnLock(SC9->(Recno()))) 
			Else
				aAdd(aBloq,"RECLOCKSC9")
			EndIf

			If cFaturar == "CWESC"
				aAdd(aRecnoSC9,SC9->(Recno()))
			Else
				lValido := .F.
			EndIf
			
			SC9->(DbSkip())

		EndDo
		
		// Se teve algum impeditivo, demonstra para o usuario
		If Len(aBloq) > 0

			lValido := .F.

			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'BLQCRD' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens do pedido com bloqueio de crédito.",.T.)
			EndIf
			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'BLQWMS' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens do pedido com bloqueio de WMS.",.T.)
			EndIf
			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'BLQEST' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens do pedido com bloqueio de estoque.",.T.)
			EndIf
			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'NAOSEPAR' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens do pedido ainda pendêntes de separação.",.T.)
			EndIf
			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'NAOCONFER' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens do pedido ainda pendêntes de conferência.",.T.)
			EndIf
			If aScan(aBloq,{|x| Alltrim(Upper(x)) = 'RECLOCKSC9' }) > 0
				fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Há itens na tabela de liberação (SC9) que estão sendo usados por outro registro.",.T.)
			EndIf

		EndIf

	EndIf

	// Faz verificação do usuario responsavel pela conferencia para chamar a impressão
	If lValido
		cConfer := fLoadConfer(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
	// Se estiver em branco, usa o usuario conectado
	If Empty(Alltrim(cConfer))
		cConfer := IIf(!Empty(cRHAuto),cRHAuto,cUsuAuto)
	EndIf

	// Só realiza se a filial possuir WMS
	If lWms
		// Valida as configurações de impressão. Não é impeditivo 
		DBSelectArea("DCD")
		DBSetOrder(1)
		If DCD->(DBSeek(xFilial("DCD") + cConfer )) 
			cXImpDCD 		:= AllTrim(DCD->DCD_XIMPFT)
			cXImpDCDFila	:= AllTrim(DCD->DCD_XFILA)
		EndIf
		If 	Empty(Alltrim(cXImpDCD))
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"O campo DCD_XIMPFT tem que estar preenchido para seguir com impressao de Boleto/Danfe automaticamente. Chave de Busca -> " + xFilial("DCD")+"-"+UsrRetName(cConfer),.T.)
		Else
			lImpDnfBol	:= .T.
		EndIf
		If 	Empty(Alltrim(cXImpDCDFila)) 
			fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"O campo DCD->DCD_XFILA tem que estar preenchido para seguir com impressao Etiqueta automaticamente. Chave de Busca -> " + xFilial("DCD")+"-"+UsrRetName(cConfer),.T.)
		Else
			lImpEtq 	:= .T.
		EndIf	
	EndIf

	// Se não for valido, desmarca as etapas
	If !lValido
		lGerarNota 		:= .F.
		lTransmitir 	:= .F.
		lMonitorar 		:= .F.
		lImprimir 		:= .F.
		// Se ja possuir nota, avalia se precisa ser retransmitido ou monitorado.. modifica as variaveis das etapas dentro da propria função
		If Len(aRetFat) > 0
			fReTrans(SC5->C5_FILIAL, aRetFat)
		EndIf
	Endif

	// Retorna as areas
	RestArea(aAreaDCD)
	RestArea(aAreaSA1)
	RestArea(aAreaSA2)
	RestArea(aAreaSC9)
	RestArea(aAreaZAB)

Return lValido

/*/{Protheus.doc} fLoadConfer
Busca quem foram os conferentes para enviar e imprimir as notas, boletos e etiquetas
@type function
@version 1.0
@author vitor.seide
@since 12/19/2022
@param cCodFil, character, Codigo da Filial
@param cNumPed, character, Codigo do Pedido
/*/
Static Function fLoadConfer(cCodFil,cNumPed)
Local cAliasQry := GetNextAlias()
Local cQuery    := ''
Local cRecConf  := ''

    cQuery := " SELECT DB.DB_RECHUM, DCD.DCD_NOMFUN "
    cQuery += " FROM " + RetSqlName("SDB") + " DB "
    cQuery += " LEFT JOIN " + RetSqlName("DCD") + " DCD   "
    cQuery += "    ON DCD_FILIAL = DB.DB_FILIAL "
    cQuery += "    AND DCD_CODFUN = DB_RECHUM  "
    cQuery += "    AND DCD.D_E_L_E_T_ = ' '  "
    cQuery += " WHERE DB.DB_FILIAL = '" + xFilial("SDB",cCodFil) + "' " 
    cQuery += " AND DB.DB_DOC = '" + Alltrim(cNumPed) + "' "
    cQuery += " AND DB.DB_ORIGEM = 'SC9' "
    cQuery += " AND DB.DB_ATUEST = 'N' "
    cQuery += " AND DB.DB_ESTORNO = ' ' "
    cQuery += " AND DB.DB_TAREFA IN ('014') "
    cQuery += " AND DB.DB_STATUS IN ('3','1') "
    cQuery += " AND DB.DB_QTDLID = DB_QUANT "
    cQuery += " AND DB.D_E_L_E_T_ = ' '  "
    cQuery += " GROUP BY DB.DB_RECHUM, DCD.DCD_NOMFUN "
    DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)

    If (cAliasQry)->(!Eof())
        While (cAliasQry)->(!Eof())

            cRecConf := Alltrim((cAliasQry)->DB_RECHUM)

            (cAliasQry)->(DbSkip())
        EndDo
    EndIf
    (cAliasQry)->(DbCloseArea())

Return cRecConf

/*/{Protheus.doc} fReTrans
Função que verifica se a nota precisa ser retransmitida ou monitorada
@type function
@version 1.0 
@author vitor.seide
@since 23/11/2022
@param cCodFil, character, Codigo da Filial
@param aNota, array, Arary contendo o numero e serie da nota fiscal
/*/
Static Function fReTrans(cCodFil,aNota)
Local cAliasQry := GetNextAlias()
Local cQuery    := ''
Default cCodFil := cFilAnt
Default aNota	:= {}

	cQuery := " SELECT F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE, F2.F2_LOJA, "
	cQuery += " NVL(SPED.STATUS,0) STATUS, NVL(SPED.STATUSCANC,0) STATUSCANC, SPED.DATE_ENFE, SPED.TIME_NFE "
	cQuery += " FROM " + RetSqlName("SF2") + " F2 "
	cQuery += " LEFT JOIN SPEDRECH.SPED050 SPED ON SPED.ID_ENT = (SELECT X6.X6_CONTEUD FROM SX6010 X6 WHERE X6_FIL = F2.F2_FILIAL AND X6_VAR = 'MV_ID_NFE' AND X6.D_E_L_E_T_ = ' ') AND SPED.NFE_ID = F2.F2_SERIE||F2.F2_DOC AND SPED.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE F2.F2_FILIAL = '" + xFilial("SF2",cCodFil) + "' "
	cQuery += " AND F2.F2_DOC = '" + aNota[1][1] + "' "
	cQuery += " AND F2.F2_SERIE = '" + aNota[1][2] + "' "
	cQuery += " AND F2.D_E_L_E_T_ = ' ' "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)

	If	(cAliasQry)->( ! Eof() )

			// Status de transmissão da nota
			// STATUSCANC
			//   0 - Sem cancelamento
			//   1 - NFe Recebida 
			//   2 - NFe Cancelada 
			//   3 - NFe com falha de cancelamento/inutilização. 

			// STATUS
			//   0 - Sem cancelamento
			//   1 - NFe Recebida 
			//   2 - NFe Assinada
			//   3 - NFe com falha no schema XML
			//   4 - NFe transmitida
			//   5 - NFe com problemas
			//   6 - NFe autorizada
			//   7 - NFE Cancelada

			If (cAliasQry)->STATUSCANC = 0
				If (cAliasQry)->STATUS = 0 .or. (cAliasQry)->STATUS = 5 .or. (cAliasQry)->STATUS = 3
					lTransmitir := .T.
					lMonitorar 	:= .T.
					fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Nota já gerada mas pendente de transmissão.",.T.)
				ElseIf (cAliasQry)->STATUS <> 6
					lMonitorar 	:= .T.
					fActionsLog('GRAVAR','Z8C_RETFAT','','VALIDACAO',"Nota já gerada e transmitida mas pendente de monitoramento do retorno.",.T.)
				EndIf

			EndIf

		EndIf

Return


/*/{Protheus.doc} fValPedSF
Valida Pedidos do SalesForece
@type function
@version 1.0 
@author Alessandro.cascaes
@since 12/27/2022
@param cFilWMS, variant, Codigo da Filial
@param cPedWMS, variant, Numero do pedido
/*/
Static Function fValPedSF(cFilWMS,cPedWMS)
Local cQryLast	:= ''
Local cAliasQry := GetNextAlias()
Local _lRet 	:= .T.

	cQryLast := " SELECT C5_NUM,C5_XDEVWMS,C5_XABORTA "
	cQryLast += " ,COUNT(Z89_STATUS) AS CORTEZ89,COUNT(Z53_PEDIDO) AS CORTEZ53 "
	cQryLast += " ,COUNT(ZAB_CHAVE) AS SALESFOR,COUNT(C9_STSERV) AS C9STSERV,COUNT(DB_STATUS) AS DBSTATUS "
	cQryLast += " FROM "+RetSqlName('SC5')+" C5 "
	cQryLast += " LEFT JOIN "+RetSqlName('ZAB')+" ZA ON TRIM(ZAB_FILIAL) = SUBSTR(TRIM(C5_FILIAL),1,5) AND ZAB_OWNER = 'CRM' AND ZAB_TIPO = 'PEDCLI' AND ZAB_TABELA = 'SC5' AND ZAB_CHAVE = C5_FILIAL||C5_NUM AND ZA.D_E_L_E_T_ = ' ' "
	cQryLast += " LEFT JOIN "+RetSqlName('Z89')+" Z8 ON Z89_FILIAL = C5_FILIAL AND Z89_PEDIDO = C5_NUM AND Z89_STATUS = '1' AND Z8.D_E_L_E_T_ = ' ' "
	cQryLast += " LEFT JOIN "+RetSqlName('Z53')+" Z5 ON Z53_FILIAL = C5_FILIAL AND Z53_PEDIDO = C5_NUM AND Z53_ROTINA = 'MATA455' AND Z5.D_E_L_E_T_ = ' '"
	cQryLast += " LEFT JOIN "+RetSqlName('SC9')+" C9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9_STSERV <> '3' AND C9_BLEST = ' ' AND C9.D_E_L_E_T_ = ' ' "
	cQryLast += " LEFT JOIN "+RetSqlName('SDB')+" DB ON DB_FILIAL = C5_FILIAL AND DB_DOC = C5_NUM AND DB_ESTORNO = ' ' AND DB_ATUEST = 'N' AND DB_STATUS NOT IN ('1','M') AND DB.D_E_L_E_T_ = ' ' "
	cQryLast += " WHERE C5_FILIAL = '" + xFilial('SC5',cFilWMS) + "' " 
	cQryLast += " AND C5_NUM = '" + cPedWMS + "' " 
	cQryLast += " AND C5.D_E_L_E_T_ = ' ' "
	cQryLast += " GROUP BY C5_NUM,C5_XDEVWMS,C5_XABORTA "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQryLast),cAliasQry,.F.,.T.)

	If (cAliasQry)->(!Eof())

		If !Empty((cAliasQry)->SALESFOR)
			If (cAliasQry)->C5_XABORTA == 'S' .Or. (cAliasQry)->C5_XDEVWMS == 'S'
				_lRet := .F.
			ElseIf !Empty((cAliasQry)->CORTEZ89) .Or. !Empty((cAliasQry)->CORTEZ53)
				_lRet := .F.				
			ElseIf !Empty((cAliasQry)->C9STSERV) .Or. !Empty((cAliasQry)->DBSTATUS)
				_lRet := .F.		
			EndIf 
		EndIf	
		
	EndIf
	(cAliasQry)->(DbCloseArea())

Return _lRet

/*/{Protheus.doc} Faturar
Faturamento para a Filial Corrente
@type function
@version 12.1.25
@author Ricardo Munhoz
@since 10/12/2021
/*/
Static Function Faturar()
Local aAreaSC5 		:= SC5->(GetArea())
Local aAreaSC6 		:= SC6->(GetArea())
Local aAreaSC9 		:= SC9->(GetArea())
Local aAreaSE4 		:= SE4->(GetArea())
Local aAreaSB1 		:= SB1->(GetArea())
Local aAreaSB2 		:= SB2->(GetArea())
Local aAreaSF4 		:= SF4->(GetArea())
Local aArea 		:= GetArea()
Local nRec			:= 0
Local aNfGerada		:= {}
Local cSerie 		:= ""
Local cNumDcto 		:= ""
Local aPvlNFs 		:= {}
Local _cEstOri      := " "
Local _cFilOri      := " "
Local _cEstDes      := " "
Local _cCgcDes      := " "
Local _cFilDes 		:= " "
Local _cGrpOri		:= " "
Local _cGrpDes		:= " "
Local lVldRetST	  	:= SuperGetMv('RT_VLDREST',.f.,.F.,cFilAnt)
Local cEspecie 		:= SuperGetMv("MV_ESPECIE",.f.,'',cFilAnt)
Local aEspecie 		:= ''
Local nEspecie 		:= 0
Local nPrzEnt       := SuperGetMV("RT_PRZENT",.F.,5)
Local dPrevEntrega  := CTOD("")

	DbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	DbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	DbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	DbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	DbSelectArea("SB2")
	SB2->(dbSetOrder(1))
	DbSelectArea("SF4")
	SF4->(dbSetOrder(1))
	If SC5->(MsSeek(xFilial("SC5") + cFANumPed)) .And. ;
		SC6->(MsSeek(xFilial("SC6") + cFANumPed))

		// Posiciona na Condição de Pagamento
		SE4->(DbSeek(xFilial("SE4") + SC5->C5_CONDPAG))

		For nRec := 1 To Len(aRecnoSc9)
								
				If lVldRetST .AND. SC5->C5_TIPO == "N"
					
					_cCgcDes    := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC"))

					_cFilOri    := SC5->C5_FILIAL
					_cFilDes    := Alltrim(Posicione("Z01",3,xFilial("Z01")+_cCgcDes,"Z01_FIL"))

					_cEstOri    := Alltrim(Posicione("Z01",1,xFilial("Z01")+cEmpAnt+SC5->C5_FILIAL,"Z01_EST"))
					_cEstDes    := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"))
					
					_cGrpOri    := Alltrim(Posicione("Z01",1,xFilial("Z01")+cEmpAnt+SC5->C5_FILIAL,"Z01_GRPECO"))
					_cGrpDes    := Alltrim(Posicione("Z01",3,xFilial("Z01")+_cCgcDes,"Z01_GRPECO"))
					
					_cFilfra    := Alltrim(Posicione("Z01",3,xFilial("Z01")+_cCgcDes,"Z01_EMPFRQ"))

					If _cEstOri <> _cEstDes .and. _cGrpOri == _cGrpDes .and. _cFilfra == "N" .and. !Empty(Alltrim(_cFilDes))
						fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO',"Enviou para recalculo ST")
						u_MaltPeSt(SC5->C5_NUM,_cEstOri,_cEstDes,_cFilOri,_cFilDes)	
					EndIf
				EndIf
				
				SC9->(DbGoTo(aRecnoSc9[nRec]))
				SC6->(DbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO))
				SB1->(DbSeek(xFilial("SB1") + SC9->C9_PRODUTO))
				SB2->(DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL))
				SF4->(DbSeek(xFilial("SF4") + SC6->C6_TES))

				aAdd(aPvlNFs,{SC9->C9_PEDIDO,;
								SC9->C9_ITEM,;
								SC9->C9_SEQUEN,;
								SC9->C9_QTDLIB,;
								SC9->C9_PRCVEN,;
								SC9->C9_PRODUTO,;
								.F.,;
								SC9->(Recno()),;
								SC5->(Recno()),;
								SC6->(Recno()),;
								SE4->(Recno()),;
								SB1->(Recno()),;
								SB2->(Recno()),;
								SF4->(Recno());
					})
		Next nRec
		
		// Faz a verificação da serie a ser usada
		aEspecie	:= StrTokArr(cEspecie,";")
		nEspecie	:= aScan(aEspecie,{|x| 'SPED' $ Alltrim(Upper(x)) })
		If nEspecie > 0
			
			// Pega o codigo da serie
			cEspecie := SubStr(Alltrim(aEspecie[nEspecie]),1,At('=',Alltrim(aEspecie[nEspecie]))-1)
			
			// Verifica se existe na SX5
			DbSelectArea("SX5")
			SX5->(DbSetOrder(1))
			If SX5->(DbSeek(cFilAnt + Padr("01",TamSx3("X5_TABELA")[1]) + Padr(cEspecie,TamSx3("X5_CHAVE")[1]) ))
				cSerie := Padr(cEspecie,TamSx3("F2_SERIE")[1])		
			EndIf

		EndIf
		
		// Chama a função de gerar a nota fiscal
		If !Empty(Alltrim(cSerie)) .and. Len(aPvlNFs) > 0
			//Tratamento para data de entrada, rejeição 1155
			dPrevEntrega := IIf(Empty(SC5->C5_FECENT) .or. SC5->C5_FECENT <= Date(), Date() + nPrzEnt, SC5->C5_FECENT)
			Pergunte("MT460A",.F.)
			SetMVValue("MT460A","MV_PAR28", dPrevEntrega, .T. ) //data de entrega
			cNumDcto := MaPvlNfs(aPvlNFs,cSerie,.F.,.T.,.F.,.F.,.F.,0,0,.F.,.F.)
		Else
			fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO',"FALHA na Geração Nota Fiscal - Falta de identificação da Serie ou nenhum item liberado para geração.",.T.)
		EndIF
		SX5->(MsUnLock())

		If cNumDcto == Space(TamSx3("F2_DOC")[1]) .Or. Empty(cNumDcto)
			fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO',"FALHA na Geração Nota Fiscal - Faturamento.",.T.)
		Else
			aAdd(aNfGerada,{cNumDcto,cSerie})
		EndIf

	Else
		fActionsLog('GRAVAR','Z8C_RETFAT','','FATURAMENTO',"FALHA no Posicionamento SC5, SC6 e SC9.",.T.)

	EndIf

	// Restar areas
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	RestArea(aAreaSE4)
	RestArea(aAreaSB1)
	RestArea(aAreaSB2)
	RestArea(aAreaSF4)
	RestArea(aArea)

Return aNfGerada

/*/{Protheus.doc} Transmitir
Transmissão de Notas Fiscais
@type function
@version 12.1.25
@author Ricardo Munhoz
@since 10/12/2021
/*/
Static Function Transmitir(cSerie,cNota)
Local aArea 			:= GetArea()
Local aXML 				:= {}
Local cRetorno 			:= ""
Local cModalidade 		:= ""
Local cAmbiente 		:= ""
Local cVersao 			:= ""
Local cMonitorSEF 		:= ""
Local cSugestao 		:= ""
Local cUsaColab 		:= ""
Local cUSERNEOG 		:= ""
Local cPASSWORD 		:= ""
Local cCONFALL 			:= ""
Local cDocsColab 		:= ""
Local cConteudo 		:= ""
Local nRetCol 			:= 0
Local nAmbCTeC 			:= 0
Local nAmbNFeC	 		:= 0
Local lOk 				:= .T.
Local cModel 			:= "55"
Local lNfeCancEven 		:= Nil //Cancelamento de NF-e por Evento
Local nX 				:= 0
Local lEnd
Local aRetRecusada		:= ''
Local nTipo  			:= 2
Local lAutoXmato		:= .T.
Local cXretMonit		:= ''
Local cIdNFe 			:= cSerie+cNota
Local _cCrLf			:= Chr(13) + Chr(10)
Private oWS 			:= Nil

	cUsaColab 	 := AllTrim(SuperGetMV("MV_SPEDCOL",.F.,"N",cFilAnt))
	cUSERNEOG 	 := AllTrim(SuperGetMV("MV_USERCOL",.F.,"",cFilAnt))
	cPASSWORD 	 := AllTrim(SuperGetMV("MV_PASSCOL",.F.,"",cFilAnt))
	cCONFALL 	 := AllTrim(SuperGetMV("MV_CONFALL",.F.,"",cFilAnt))
	cDocsColab 	 := AllTrim(SuperGetMV("MV_DOCSCOL",.F.,"0",cFilAnt))
	nRetCol 	 := SuperGetMV("MV_NRETCOL",.F.,10,cFilAnt)
	nAmbCTeC 	 := SuperGetMV("MV_AMBICOL",.F.,2,cFilAnt)
	nAmbNFeC 	 := SuperGetMV("MV_AMBCTEC",.F.,2,cFilAnt)
	lNfeCancEven := SuperGetMV("MV_NFECAEV",.F.,.F.,cFilAnt)

	If Empty(cUsaColab)
		cUsaColab := AllTrim(SuperGetMV("MV_SPEDCOL",.F.,"N",))
	EndIf
	If Empty(cUSERNEOG)
		cUSERNEOG := AllTrim(SuperGetMV("MV_USERCOL",.F.,"",))
	EndIf
	If Empty(cPASSWORD)
		cPASSWORD := AllTrim(SuperGetMV("MV_PASSCOL",.F.,"",))
	EndIf
	If Empty(cCONFALL)
		cCONFALL := AllTrim(SuperGetMV("MV_CONFALL",.F.,"",))
	EndIf
	If Empty(cDocsColab)
		cDocsColab := AllTrim(SuperGetMV("MV_DOCSCOL",.F.,"0",))
	EndIf
	If nRetCol == 0
		nRetCol := AllTrim(SuperGetMV("MV_NRETCOL",.F.,10,))
	EndIf
	If nAmbCTeC == 0
		nAmbCTeC := AllTrim(SuperGetMV("MV_AMBICOL",.F.,2,))
	EndIf
	If nAmbNFeC == 0
		nAmbNFeC := AllTrim(SuperGetMV("MV_AMBCTEC",.F.,2,))
	EndIf
	If ValType(lNfeCancEven) == "U"
		lNfeCancEven := AllTrim(SuperGetMV("MV_NFECAEV",.F.,.F.,))
	EndIf

	//Obtem o ambiente de execucao do Totvs Services SPED
	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nAmbiente  := 0
	oWS:_URL       := AllTrim(cUrlSped)+"/SPEDCFGNFe.apw"

	lOk 	  := oWS:CFGAMBIENTE()
	cAmbiente := oWS:cCfgAmbienteResult
	If lOk
		lOk := oWs:CfgTSSVersao()
	EndIf

	//Obtem a modalidade de comunicacao com a SEFAZ TSS ou TOTVS Colaboracao
	If lOk .And. oWs:cCfgTssVersaoResult >= "1.35"
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt			
		oWS:cUSACOLAB  := cUsaColab
		oWS:nNUMRETNF  := nRetCol
		oWS:nAMBIENTE  := Val(Substr(cAmbiente,1,1))
		oWS:nMODALIDADE:= 1
		oWS:cVERSAONFE := ""
		oWS:cVERSAONSE := ""
		oWS:cVERSAODPEC:= ""
		oWS:cVERSAOCTE := ""
		oWS:cUSERNEOG  := cUSERNEOG
		oWS:cPASSWORD  := cPASSWORD
		oWS:cCONFALL   := cCONFALL                      
		If oWs:cCfgTssVersaoResult >= "1.43"
			If "1" $ Upper(cDocsColab)
				cConteudo += "1"
			EndiF
			If "2" $ Upper(cDocsColab)
				cConteudo += "2"
			EndIf
			If "3" $ Upper(cDocsColab)
				cConteudo += "3"
			EndIf                    
			If "4" $ Upper(cDocsColab)
				cConteudo := "4"
			EndIf
			If "0" $ Upper(cDocsColab)
				cConteudo := "0"
			EndIf

			//Cancelamento por Evento
			If oWs:cCfgTssVersaoResult >= "2.15"
				oWS:lNFeCancEvento := lNFeCancEven
			EndIf			
			oWS:cDOCSCOL := cConteudo
			oWS:nAMBNFECOLAB:= IIf(nAmbNFeC >= 1 .And. nAmbNFeC <= 2,nAmbNFeC,2)
			oWS:nAMBCTECOLAB:= IIf(nAmbCTeC >= 1 .And. nAmbCTeC <= 2,nAmbCTeC,2)
		EndIf
		oWS:_URL := AllTrim(cUrlSped)+"/SPEDCFGNFe.apw"
		oWS:CFGPARAMSPED()		
	EndIf

	//Obtém a modalidade de execução do Totvs Services SPED
	If lOk
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:nModalidade:= 0
		oWS:_URL       := AllTrim(cUrlSped) + "/SPEDCFGNFe.apw"
		oWS:cModelo   := cModel

		lOk := oWS:CFGModalidade()
		cModalidade    := oWS:cCfgModalidadeResult
	EndIf

	//Obtém a versão de trabalho da NFe do Totvs Services SPED
	If lOk
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:cVersao    := "0.00"
		oWS:_URL       := AllTrim(cUrlSped) + "/SPEDCFGNFe.apw"

		lOk := oWS:CFGVersao()
		cVersao        := oWS:cCfgVersaoResult
	EndIf				

	//VerIfica o status na SEFAZ
	If lOk
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:_URL       := AllTrim(cUrlSped) + "/NFeSBRA.apw"

		lOk := oWS:MONITORSEFAZMODELO()
		If lOk
			aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
			For nX := 1 To Len(aXML)
				Do Case
					Case aXML[nX]:cModelo == "55"
						cMonitorSEF += "- NFe" + CRLF
						cMonitorSEF += "Versao do layout: " + cVersao+CRLF	
						If !Empty(aXML[nX]:cSugestao)
							cSugestao += "Sugestão" + "(NFe)" + ": " + aXML[nX]:cSugestao+CRLF 
						EndIf													
				EndCase
				cMonitorSEF += "Versão da mensagem" + ": " + aXML[nX]:cVersaoMensagem + CRLF 
				cMonitorSEF += "Código do Status" + ": " + aXML[nX]:cStatusCodigo + "-" + aXML[nX]:cStatusMensagem + CRLF 
				cMonitorSEF += "UF Origem" + ": " + aXML[nX]:cUFOrigem 
				If !Empty(aXML[nX]:cUFResposta)
					cMonitorSEF += "("+aXML[nX]:cUFResposta+")" + CRLF 
				Else
					cMonitorSEF += CRLF
				EndIf
				If aXML[nX]:nTempoMedioSEF <> Nil
					cMonitorSEF += "Tempo de espera" + ": " + Str(aXML[nX]:nTempoMedioSEF,6) + CRLF 
				EndIf
				If !Empty(aXML[nX]:cMotivo)
					cMonitorSEF += "Motivo" + ": " + aXML[nX]:cMotivo + CRLF 
				EndIf
				If !Empty(aXML[nX]:cObservacao)
					cMonitorSEF += "Observação" + ": " + aXML[nX]:cObservacao + CRLF 
				EndIf
			Next nX
		EndIf
	EndIf

	If (lOk == .T. .or. lOk == Nil)
		If ValType(cAmbiente) = 'C' .and. ValType(cModalidade) = 'C' .and. ValType(cVersao) = 'C'
			cRetorno := SpedNFeTrf("SF2",cSerie,cNota,cNota,cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
		Else
			fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Erro na tentativa de transmissão da nota fiscal.",.T.)
			If ValType(cAmbiente) <> 'C'
				fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Não identificado o ambiente para transmissão.",.T.)
			EndIf
			If ValType(cModalidade) <> 'C'
				fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Não identificado a modalidade para transmissão.",.T.)
			EndIf
			If ValType(cVersao) <> 'C'
				fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Não identificado a versão para transmissão.",.T.)
			EndIf
		EndIf
		aRetRecusada:= strtoarray(cRetorno,"recusadas") 
		If Len(aRetRecusada) == 2
			U_XBt3NFeMnt(cIdEnt,cIdNFe,nTipo,,,lAutoXmato,,,,@cXretMonit)
			fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Nota Fiscal: " + cNota + " " + cSerie + ", Rotina transmissao efetuada com nota recusada. "+_cCrLf+" Retorno Sefaz : "+cXretMonit,.T.)
			lOK := .F.		

		Else
			fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Nota Fiscal: " + cNota + " " + cSerie + ", Rotina transmissao efetuada com sucesso")
			
		EndIf
	
	Else
		fActionsLog('GRAVAR','Z8C_RETFAT','','TRANSMISSAO',"Nota Fiscal: " + cNota + " " + cSerie + ", Rotina transmissao com erro: "+cRetorno,.T.)

	EndIf
	RestArea(aArea)

Return lOK


/*/{Protheus.doc} Monitorar
Monitoramento de Notas Fiscais
@type function
@version 12.1.25
@author Ricardo Munhoz
@since 10/12/2021
/*/
Static Function Monitorar(cSerie,cNota)
Local aArea 			:= GetArea()
Local aRetMon 			:= {}
Local lRet 				:= .T.
Local nContador 		:= 0
Local cXChvNfeFatAuto	:=''
Local aRetMonBKP		:= {}

	Do While Len(aRetMon) == 0 .And. nContador < 7
		Sleep(6000)
		
		fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"TENTATIVA n° " + cValToChar(nContador) + " Monitoramento da Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie)
		nContador++

		aRetMon := procMonitorDoc(cIdEnt,cUrlSped,{cSerie,cNota,cNota,,},1,"55",.F.,"",.F.)
		If Len(aRetMon) > 0			
			// Se tiver já a chave, para de monitorar
			If Empty(aRetMon[1][4]) 
				aRetMonBKP 	:= aRetMon
				aRetMon     := {}
			EndIf
		EndIf		

	EndDo

	If Len(aRetMon) > 0 
		
		fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"SUCESSO Monitoramento da Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie)

		cXChvNfeFatAuto:= aRetMon[1][4]
		If !Empty(cXChvNfeFatAuto) 
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Monitoramento com  "+cValTochar(nContador)+" Tentativas OK Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie +" Retorno Monitor :"+aRetMon[1][9])
		
		Else
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Monitoramento com  "+cValTochar(nContador)+" Tentativas OK Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie +" Retorno Monitor :"+aRetMon[1][9])
			
		EndIf	
	Else
		
		fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"ERRO Monitoramento da Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie,.T.)
	
		lRet := .F.
		If Len(aRetMonBKP) > 0
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Monitramento  "+cValTochar(nContador)+" Tentativas ERRO Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie +" Retorno Monitor :"+aRetMonBKP[1][9],.T.)
			
		Else
			fActionsLog('GRAVAR','Z8C_RETFAT','','MONITORAMENTO',"Monitramento  "+cValTochar(nContador)+" Tentativas ERRO Filial/Nota Saída/Série: " + cFilAnt + " / " + cNota + " / " + cSerie,.T.)
		
		EndIf	
	EndIf

	RestArea(aArea) 

Return lRet


/*/{Protheus.doc} GeraDanfe
Gera a nota fiscal
@type function
@version 1.0  
@author rmunh
@since 23/12/2021
@param aNota, array, Dados para nota
@param cDiretorio, character, Diretorio
/*/
Static Function GeraDanfe(aNota,cDiretorio,cXImpDCD)
Local aArea 			:= GetArea()
Local cArquivo 			:= ""
Local cZ13 				:= ""
Local oSetup 			:= Nil
Local oDanfe 			:= Nil
Local lEnd 				:= .F.
Local lRet 				:= .T.
Local aImpressoras 		:= GetImpWindows(.T.)
Local aPortas 			:= GetPortActive(.T.)
Local nX 				:= 0
Local cDocFatAuto   	:= ''
Default aNota 			:= {}
Default cDiretorio 		:= ""
Private lExistNFe 		:= .F.
Private PixelX 			:= 0
Private PixelY 			:= 0
Private nConsNeg 		:= 0
Private nConsTex		:= 0
Private oRetNF 			:= Nil
Private nColAux 		:= 0

	fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"*** Lista de Impressoras")	
	For nX := 1 To Len(aImpressoras)
		fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',aImpressoras[nX])
	Next nX

	fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"*** Lista de Portas")
	For nX := 1 To Len(aPortas)
		fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',aPortas[nX])
	Next nX

	cZ13 := AllTrim(cXImpDCD)
	
	cArquivo := aNota[1] + "_" + DToS(Date()) + "_" + StrTran(Time(), ":", "-") 

	Pergunte("NFSIGW",.F.)
	MV_PAR01 := aNota[1] 
	MV_PAR02 := aNota[2] 
	MV_PAR03 := aNota[3] 
	MV_PAR04 := 2
	MV_PAR05 := 1
	MV_PAR06 := 2
	MV_PAR07 := dDatabase - 10000
	MV_PAR08 := dDatabase

 	cDocFatAuto   	:= aNota[1]
 	cSerieFatAuto 	:= aNota[3]

	FWWriteProfString(GetPrinterSession(),"DEFAULT",cZ13,.T.)
	//oDanfe := FWMSPrinter():New(cArquivo,IMP_SPOOL,.F.,cDiretorio,.T.,,,cZ13,.T.,,,.F.,)
	oDanfe :=FWMSPrinter():New(cArquivo,IMP_PDF,.F.,"\spool\",.T.,,,,.T.,,,.F.,)  //Add. em 21/10/2025 para release 2410. Imprimir direto na porta/spool esta travando no oDanfe:Print(). Cesar.gruppe
	oDanfe:SetResolution(78)
	oDanfe:SetPortrait()
	oDanfe:SetPaperSize(DMPAPER_A4)
	oDanfe:SetMargin(60,60,60,60)
	oDanfe:lServer := .T.
	oDanfe:lInJob := .T.
	oDanfe:setCopies(1)
	//oDanfe:nDevice := IMP_SPOOL  
	oDanfe:nDevice := 6  //Add. em 21/10/2025 para release 2410. Imprimir direto na porta/spool esta travando no oDanfe:Print(). Cesar.gruppe
	oDanfe:cPrinter := cZ13

	PixelX    := oDanfe:nLogPixelX()
	PixelY    := oDanfe:nLogPixelY()
	nConsNeg  := 0.4
	nConsTex  := 0.5
	oRetNF    := Nil
	nColAux   := 0

	U_DanfeProc(@oDanfe,@lEnd,cIdent,,,@lExistNFe,.F.,,.F.)
	oDanfe:Print()

	__CopyFile("\spool\" + AllTrim(Lower(cArquivo)) + ".pdf", cZ13) //Add. em 21/10/2025 para release 2410. Imprimir direto na porta/spool esta travando no oDanfe:Print(). Cesar.gruppe

	Sleep(3000)

	oDanfe := Nil
	FreeObj(oDanfe)

	// Verifica se o bucket esta por GATILHO ou SCHEDULER	
	If SuperGetMV("RC_BUCKET",.F.,'',cFilAnt) = 'GATILHO'

		cArquivo := aNota[1] + "_" + DToS(Date()) + "_" + StrTran(Time(), ":", "-") + ".pdf"

		//oXXDfe := FWMSPrinter():New(cArquivo,IMP_PDF,.F.,"\spool\",.T.,,,cZ13,.T.,,,.F.,)
		oXXDfe := FWMSPrinter():New(cArquivo,IMP_PDF,.F.,"\spool\",.T.,,,,.T.,,,.F.,)
		oXXDfe:SetResolution(78)
		oXXDfe:SetPortrait()
		oXXDfe:SetPaperSize(DMPAPER_A4)
		oXXDfe:SetMargin(60,60,60,60)
		oXXDfe:lServer := .T.
		oXXDfe:lInJob := .T.
		oXXDfe:setCopies(1)
		oXXDfe:nDevice := IMP_PDF
		oXXDfe:cPrinter := cZ13

		PixelX    := oXXDfe:nLogPixelX()
		PixelY    := oXXDfe:nLogPixelY()
		nConsNeg  := 0.4
		nConsTex  := 0.5
		oRetNF    := Nil
		nColAux   := 0

		U_DanfeProc(@oXXDfe,@lEnd,cIdent,,,@lExistNFe,.F.,,.F.)
		oXXDfe:Print()

		Sleep(3000)

		oXXDfe := Nil
		FreeObj(oXXDfe)

		cNamArqBuc	:= Alltrim(SF2->F2_FILIAL)+"_"+Alltrim(SF2->F2_DOC)+"_"+Alltrim(SF2->F2_SERIE)+"_"+Alltrim(+SF2->F2_CLIENTE)+"_"+Alltrim(SF2->F2_LOJA)+".pdf"
		lCopBuck	:= .F.
		lCopBuck 	:= __CopyFile('\spool\'+cArquivo, _cPastaBuc + cNamArqBuc)

		If lCopBuck
			// Apaga localmente
			FErase('\spool\'+cArquivo)
			
			// Grava o nome do arquivo
			If RecLock("SF2",.F.)
				Replace SF2->F2_XBUCKET With cNamArqBuc
				SF2->(MsUnlock())
			EndIf
		Endif

	Endif
	If lExistNfe
		fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"Danfe impresso com Sucesso,Enviado para a Impressora ("+cZ13+")-Arquivo-"+cArquivo)
	
	Else
		fActionsLog('GRAVAR','Z8C_RETFAT','','DANFE',"PROBLEMAS com impressão da DANFE")
		lRet := .F.

	EndIf

	oSetup := Nil
	FreeObj(oSetup)

	RestArea(aArea)

Return lRet 

/*/{Protheus.doc} XisConnTSS
Função auxiliar do faturamento automático. VerIfica conexão com o TSS.
@type function
@version 12.1.33
@author Ricardo Munhoz
@since 10/12/2021
/*/
User Function XisConnTSS(cError)
local aConn		:= { seconds(), date() }
local cURL 		:= ""
local lRet 		:= .T.
local oWS 		:= nil
Local UID		:="TSSCONFIG"

	cUrl := Alltrim( if( FunName() == "LOJA701" .and. !Empty( getNewPar("MV_NFCEURL","")), PadR(GetNewPar("MV_NFCEURL","http://"),250),padR(getNewPar("MV_SPEDURL","http://"),250 )) )

	varSetUID(UID, .T.)

	If(  !varGetAD(UID, "CFGCONNECT" + cUrl, @aConn) .or. ( seconds() - aConn[1] )  > 10 .or. date() > aConn[2] )

		oWs := WsSpedCfgNFe():New()
		oWs:cUserToken	:= "TOTVS"
		oWS:_URL 		:= AllTrim(cURL)+"/SPEDCFGNFe.apw"

		If( !execWSRet(oWs, "CFGCONNECT") )
			cError := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			lRet := .F.

		else
			aConn := array(2)
			aConn[1] := seconds()
			aConn[2] := date()

			varSetAD(UID, "CFGCONNECT" + cUrl, aConn)

			aSize(aConn, 0)
			aConn := nil

		endIf

		freeObj(oWS)
		oWS := nil

	endIf

Return lRet

/*/{Protheus.doc} XBt3NFeMnt
Função auxiliar do faturamento automatico. Checagem e monitoramento de status de Nota Fiscal.
@type function
@version 12.1.33
@author Ricardo Munhoz
@since 10/12/2021
/*/
User Function XBt3NFeMnt(cIdEnt,cIdNFe,nTipo,lUsaColab,cModelo,lAutoXmato,lRetXml,cXmlRet,lCancel,cXretMonit)
Local cURL     		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMsg     		:= ""
Local oWS
Private oDoc		:= Nil
DEFAULT nTipo     	:= 1
DEFAULT lUsaColab 	:= .F.
DEFAULT cModelo	  	:= "55"
DEFAULT lAutoXmato 	:= .F.
DEFAULT lRetXML   	:= .F. // Não exibe a tela, apenas retorna o XML
DEFAULT lCancel   	:= .T.
DEFAULT cXmlRet   	:= ""  // Quando o argumento lRetXml é verdadeiro, passar este como referência para o retorno
DEFAULT cXretMonit	:= ""

	If !lUsaColab

		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt
		oWS:oWSNFEID          := NFESBRA_NFES2():New()
		oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
		aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := cIdNfe
		oWS:nDIASPARAEXCLUSAO := 0
		oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"

		If oWS:RETORNANOTAS()
			If Len(oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
				If nTipo == 1
					Do Case
						Case lCancel .And. oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA <> Nil
							If !lAutoXmato .And. !lRetXml
								Aviso("SPED",oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML,{"XXXXXX"},3)
							ElseIf lAutoXmato
								MemoWrite(GetSrvProfString("RootPath","") + "\baseline\TSSRecXML.xml", oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML)
							ElseIf lRetXml
								cMsg := oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
								cMsg += oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXMLPROT
							EndIf
						OtherWise
							If !lAutoXmato .And. !lRetXml
								Aviso("SPED",oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML,{"XXXXXX"},3)
							ElseIf lAutoXmato
								MemoWrite(GetSrvProfString("RootPath","") + "\baseline\TSSRecXML.xml", oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML)
							ElseIf lRetXml
								cMsg := oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
								cMsg += oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXMLPROT
							EndIf
					EndCase
				Else
					cMsg := AllTrim(oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML)

					If !Empty(cMsg) .And. !lRetXml
						If !lAutoXmato
							Aviso("SPED",@cMsg,{"XXXXXX"},3,/*cCaption2*/,/*nRotAutDefault*/,/*cBitmap*/,.T.)
						ElseIf lAutoXmato
							//MemoWrite(GetSrvProfString("RootPath","") + "\baseline\TSSSchema.txt", cMsg)
						EndIf
						oWS:= WSNFeSBRA():New()
						oWS:cUSERTOKEN     := "TOTVS"
						oWS:cID_ENT        := cIdEnt
						oWs:oWsNFe:oWSNOTAS:=  NFeSBRA_ARRAYOFNFeS():New()
						aadd(oWs:oWsNFe:oWSNOTAS:oWSNFeS,NFeSBRA_NFeS():New())
						oWs:oWsNFe:oWSNOTAS:oWsNFes[1]:cID := cIdNfe
						oWs:oWsNFe:oWSNOTAS:oWsNFes[1]:cXML:= EncodeUtf8(cMsg)
						oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"

						If oWS:Schema()
							If Empty(oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM)
								cXretMonit := "Nf Sem retorno do Sefaz"
							Else
								If !lAutoXmato
									If ( MsgYesNo("XXX343") ) //"Schema com erro. Deseja visualizar as possibilidades que podem ter causado o erro?"
									Else
										Aviso("SPED",IIf(Empty(oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM),"XXXX91",oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM),{"XXXXXX"},3)
									EndIf
								ElseIf lAutoXmato
									cXretMonit:= oWS:oWSSCHEMARESULT:oWSNFES4[1]:cMENSAGEM
								EndIf

							EndIf
						Else
							Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"XXXXXX"},3)
						EndIf
					ElseIf !Empty(cMsg) .And. lRetXml
						cMsg := oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
						cMsg += oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXMLPROT
					EndIf
				EndIf
			EndIf
		ElseIf !lRetXML
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"XXXXXX"},3)
		EndIf
	Else
		oDoc 			:= ColaboracaoDocumentos():new()
		oDoc:cModelo	:= IIf(cModelo=="55","NFE",IIf(cModelo=="57","CTE",IIf(cModelo=="58","MDF","")))
		oDoc:cTipoMov	:= "1"
		oDoc:cIDERP	:= cIdNFe + FwGrpCompany()+FwCodFil()

		If odoc:consultar()
			If nTipo == 1
				If !Empty(oDoc:cXmlRet)
					If !lRetXml
						Aviso("SPED",DecodeUtf8(oDoc:cXmlRet),{"XXXXXX"},3)
					Else
						cMsg := DecodeUtf8(oDoc:cXmlRet)
					EndIf
				ElseIf !lRetXml
					Aviso("SPED",oDoc:cXml,{"XXXXXX"},3)
				EndIf

			ElseIf !lRetXml
				Aviso("SPED","Validação de Schema indisponível para TOTVS Colaboração - 2.0",{"XXXXXX"},3)
			EndIf
		ElseIf !lRetXml
			Aviso("SPED",oDoc:cCodErr+" - "+oDoc:cMsgErr,{"XXXXXX"},3)
		EndIf
		oDoc := Nil
		DelClassIntF()
	EndIf

	//-- o Argumento cXmlRet deve ser passado como referência
	If lRetXml
		cXmlRet := cMsg
	EndIf

Return .T.


/*/{Protheus.doc} FPEDSZP
Função auxiliar do faturamento automatico. Faz atualização no giro de produto quando o mesmo esta dIferente de NORMAL.
@type function
@version 12.1.33
@author Bruno Reis
@since 01/08/2022
/*/
User Function FPEDSZP()
Local aArea 	:= GetArea()
Local aAreaSC6 	:= SC6->(GetArea())
Local aAreaSZP 	:= SZP->(GetArea())

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(Dbseek(xFilial("SC6")+cFANumPed))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cFANumPed
		DbSelectArea("SZP")
		SZP->(DbSetOrder(1))
		If	SZP->(DbSeek(SC6->C6_FILIAL+Padr(SC6->C6_PRODUTO,TamSx3("ZP_COD")[1])))
			If SZP->ZP_CGIROSD <> 'N'
				If	RecLock("SZP",.F.)
					Replace SZP->ZP_CGIROSD	With "N" // Normal
					SZP->(MsUnLock())
				EndIf 
			EndIf
		EndIf	
		SC6->(DbSkip())
	EndDo 

	RestArea(aArea)
	RestArea(aAreaSC6)
	RestArea(aAreaSZP)

Return

/*/{Protheus.doc} fExpStatWms
Função para pegar o status dos itens do pedido no WMS
@type function
@version 1.0 
@author Lucas.schoeffel
@since 20/10/2022
@param cFilPed, character, Filial a ser filtrado
@param cNumPed, character, Pedido a ser filtrado
@return array, Array contendo status
/*/
Static Function fExpStatWms(cFilPed,cNumPed)
Local	cQuery		:= ''
Local 	aQryAlias	:= GetNextAlias()
Local   aColetores	:= {}
Default cFilPed		:= SC5->C5_FILIAL
Default cNumPed		:= SC5->C5_NUM
	
	cQuery := " SELECT DB_SERIE, DB_PRODUTO, DB_LOCAL, DB_LOCALIZ, " 
	cQuery += " DB_QUANT,"
	cQuery += " (CASE WHEN DB_TAREFA = '012' THEN 'SEPARACAO' "
	cQuery += "		WHEN DB_TAREFA = '014' THEN 'CONFERENCIA'"
	cQuery += " 		ELSE ' ' END) TIPO,"
	cQuery += " (CASE WHEN DB_STATUS IN ('4','-') THEN 'PENDENTE' "
	cQuery += "      WHEN DB_STATUS IN ('4','-') AND DB_QTDLID > 0 AND DB_TAREFA = '014' THEN 'ANDAMENTO'"
	cQuery += "      WHEN DB_STATUS IN ('3','1') AND DB_QTDLID <> DB_QUANT THEN 'ANDAMENTO'"
	cQuery += "      WHEN DB_STATUS IN ('3','1') AND DB_QTDLID = DB_QUANT THEN 'OK FINALIZADO'"
	cQuery += "      WHEN DB_STATUS = '2' THEN 'COM PROBLEMA'"
	cQuery += "      ELSE 'OK FINALIZADO' END) STATUS,"
	cQuery += " DB_DATA, DB_HRINI, DB_DATAFIM, DB_HRFIM,"
	cQuery += " DCD_NOMFUN "
	cQuery += " FROM " + RetSqlName("SDB") + " DB LEFT JOIN " + RetSqlName("DCD") + " DCD ON ( "
	cQuery += " 			DCD_FILIAL = '" + xFilial("DCD") + "' "
	cQuery += " 			AND DCD_CODFUN = DB_RECHUM "
	cQuery += " 			AND DCD.D_E_L_E_T_ = ' ') "
	cQuery += " WHERE DB_FILIAL = '" + cFilPed + "' "
	cQuery += " AND DB_DOC = '" + cNumPed + "'"
	cQuery += " AND DB_ORIGEM = 'SC9'"
	cQuery += " AND DB_ATUEST = 'N'"
	cQuery += " AND DB_ESTORNO = ' '"
	cQuery += " AND DB_TAREFA IN ('012','014')"
	cQuery += " AND DB.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY DB_TAREFA, DB_DATA, DB_HRINI "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),aQryAlias,.F.,.T.)
	TCSetField(aQryAlias,'DB_DATA','D')
	TCSetField(aQryAlias,'DB_DATAFIM','D')
		
	While	(aQryAlias)->( ! Eof() )
			aadd(aColetores, {	Alltrim((aQryAlias)->DB_SERIE),;
								Alltrim((aQryAlias)->DB_PRODUTO),;
								Alltrim(Posicione("SB1",1,xFilial("SB1")+Alltrim((aQryAlias)->DB_PRODUTO),"B1_DESC")),;
								Alltrim((aQryAlias)->DB_LOCAL),;
								Alltrim((aQryAlias)->DB_LOCALIZ),;
								(aQryAlias)->DB_QUANT,;
								(aQryAlias)->TIPO,;
								(aQryAlias)->STATUS,;
								Alltrim((aQryAlias)->DCD_NOMFUN),;
								(aQryAlias)->DB_DATA,;
								(aQryAlias)->DB_HRINI,;
								(aQryAlias)->DB_DATAFIM,;
								(aQryAlias)->DB_HRFIM} )		
			(aQryAlias)->(DbSkip())
	End
	(aQryAlias)->(DbCloseArea())

Return aColetores

/*/{Protheus.doc} fActionsLog
Função que grava ou consulta logs do registro na Z8C
@type function
@version 1.0 
@author vitor.seide
@since 20/10/2022
@param cAction, character, Ação a ser realizada: GRAVAR ou CONSULTAR
@param cEtapa, character, Etapa de gravação ou campo a ser consultado
@param cMensagem, character, Mensagem a ser gravada
/*/
Static Function fActionsLog(cAction,cCampo,xConteudo,cEtapa,cMensagem,lSalvaLog)
Local  lExistZ8C	:= .F.
Local  xReturn 		
Local  cConteudo 	:= ''
Local  cFullMens	:= ''
Default cAction		:= 'CONSULTA'
Default cCampo		:= ''
Default xConteudo	:= '' 
Default cEtapa		:= ''
Default cMensagem	:= ''
Default lSalvaLog	:= .F.

	If Empty(Alltrim(cFACodFil)) .or. Empty(Alltrim(cFANumPed))
		Do Case 
			Case cAction = 'CONSULTA'
				Return ''
			Case cAction = 'GRAVA'
				Return xReturn
		EndCase
	EndIf

	Do Case
		Case ValType(xConteudo) = 'D'
			cConteudo := DtoC(xConteudo)
		Case ValType(xConteudo) = 'N'
			cConteudo := cValToChar(xConteudo)
		OtherWise
			cConteudo := Alltrim(xConteudo)
	EndCase

	// Monta a string completa para salvar
	cFullMens := DtoC(dDataBase) + " / " + SubStr(TimeFull(),1,8) + " -> " + cEtapa + Iif(Empty(Alltrim(cConteudo)),'', " (" + cCampo + ") -> " + cConteudo )  + " -> " + Alltrim(cMensagem)

	// Verifica se esta vindo pela rotina de simulação
	If Type("lSimulacao") = 'L'
		If lSimulacao
			aAdd(aSimula,cFullMens)
			Return
		EndIf 
	EndIf

	// Abre a area
	DbSelectArea("Z8C")
	Z8C->(DbSetOrder(1))

	// Verifica se foi enviado um campo valido
	If Z8C->(FieldPos(cCampo)) > 0

		// Verifica se ja existe ou cria
		lExistZ8C := Z8C->(DbSeek(xFilial("Z8C",cFACodFil)+cFANumPed))

		If RecLock("Z8C",!lExistZ8C)
			
			// Se estiver inserindo, cria o cabeçalho
			If !lExistZ8C
				Replace Z8C->Z8C_FILIAL With xFilial("Z8C",cFACodFil)
				Replace Z8C->Z8C_PEDIDO With cFANumPed
			EndIf

			// Sempre grava no log totalizador
			If cAction = 'GRAVA'
				If lSalvaLog
					Replace Z8C->Z8C_RETFAT With cFullMens + CR + Z8C->Z8C_RETFAT // Ordenado para a ultima linha sempre ficar por cima
				EndIf
			EndIf

			Do Case
				Case cAction = 'CONSULTA' // Se estiver enviando um campo da tabela, retorna o conteudo dele
					
					xReturn := &("Z8C->"+Alltrim(cCampo))
					
				Case cAction = 'GRAVA'
					
					If cCampo = 'Z8C_NTNTVS' // Contador
						If &("Z8C->"+Alltrim(cCampo)) >= 99
							Replace &("Z8C->"+Alltrim(cCampo)) With 1
						Else
							Replace &("Z8C->"+Alltrim(cCampo)) With &("Z8C->"+Alltrim(cCampo))+1
						EndIf
					Else
						If cCampo <> 'Z8C_RETFAT'
							Replace &("Z8C->"+Alltrim(cCampo)) With xConteudo
						EndIf
					
					EndIf

			EndCase
			Z8C->(MsUnlock())
		EndIf

	EndIf

	// Chama a função de gravação de console em arquivo fisico
	fAddConsole(cFullMens)

Return xReturn

/*/{Protheus.doc} fAddConsole
Função default para chamar com qualquer log a ser gavado na rotina
@type function
@version 1.0  
@author vitor.seide
@since 20/10/2022
@param cMensagem, character, Mensagem a ser gravada
/*/
Static Function fAddConsole(cMensagem)
Default cMensagem	:= ''
	
	If fSalvaConsole
		If !Empty(Alltrim(cMensagem))
			u_LogAutoPad('FIL ' + cFACodFil + ' - PED ' + cFANumPed + ' -> ' + Alltrim(cMensagem),,,"RTFATA",,,,,.t.)
		EndIf
	EndIf

Return


/*/{Protheus.doc} RcFatLog
Função de visualizaçãodo log de faturamento automatico
@type function
@version 1.0 
@author vitor.seide
@since 12/12/2022
@param cAlias, character, Alias da tabela (SC5, SF2, SD2) para posicionamento
@param cChave, character, Chave dos campos para posicionamento
/*/
User Function RcFatLog(cAlias,cChave,lReload)
Local aAreaZ8C  	:= Z8C->(GetArea())
Local aAreaSD2  	:= SD2->(GetArea())
Local aAreaSC5  	:= SC5->(GetArea())
Local lContinua		:= .T.
Local oFntCabTxt	:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Local nLinha 		:= 05
Private aCab 		:= {}
Private cLog 		:= ''
Private cStatus		:= ''
Private nCorStat	:= ''
Private cCodFil 	:= ''
Private cCodPed 	:= ''
Private cThread 	:= ''
Private lAutoReload	:= .F.
Private oDlgPrc 
Private oTimer
Private oPanelSup
Private oBrwDad 
Private oPanelInf
Private oMsgLog 
Private oBarBut	
Private oButton
Private bVldEnd		:= {||/*bValid*/,.T.}
Private oBtFil
Private oBtPed
Private oBtTp
Private oBtCli
Private oBtDtPed
Private oBtHrVV
Private oBtDtLib
Private oBtHrLib
Private oBtDtConf
Private oBtHrConf
Private oBtNTen
Private oBtUsr
Private oBtTime
Private oBtDtInFat
Private oBtHrInFat
Private oBtDtFmFat
Private oBtHrFmFat
Private oBtThread
Private oBtModExe
Private oBtNumNf
Private oBtSerNf
Private oBtDtNf
Private oBtChvNf
Private oBtStTr
Private oBtStCan
Private oBtDtTr
Private oBtHrtr
Private oBtRetSef
Private oPnStatus
Private oSyStatus
Default cAlias 		:= ''
Default cChave		:= ''
Default lReload		:= .f.
	
	// Recebe se deve ficar atualizando
	lAutoReload := lReload

	// Realiza validações dos dados enviados para a função.
	If Empty(Alltrim(cAlias)) .or. Empty(Alltrim(cChave)) .or. !(cAlias $ 'SF2/SD2/SC5')
		MsgAlert("Não foi possivel posicionar no registro.")
		lContinua := .F.
	EndIf

	// Bloco para identificação do registro de pedido
	If lContinua

		If cAlias == 'SF2' .or. cAlias == 'SD2'
			DbSelectArea("SD2")
			SD2->(DbSetOrder(1))
			If SD2->(DbSeek(cChave))
				If !Empty(Alltrim(SD2->D2_PEDIDO))
					cCodFil := Padr(SD2->D2_FILIAL,TamSx3("Z8C_FILIAL")[1])
					cCodPed	:= Padr(SD2->D2_PEDIDO,TamSx3("Z8C_PEDIDO")[1])
				EndIf
			EndIf
		ElseIf cAlias == 'SC5'
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(cChave))
				cCodFil	:= Padr(SC5->C5_FILIAL,TamSx3("Z8C_FILIAL")[1]) 
				cCodPed	:= Padr(SC5->C5_NUM,TamSx3("Z8C_PEDIDO")[1])
			EndIf
		EndIf
		If Empty(Alltrim(cCodFil)) .or. Empty(Alltrim(cCodPed))
			MsgAlert("Não foi possivel posicionar no registro.")
			lContinua := .F.
		EndIf

	EndIf

	// Demonstra a tela e traz os dados
	If lContinua

		// Chama função de buscar dados
		Processa( {|| fLoadDados(cCodFil,cCodPed)}, "Carregando", "Carregando dados do pedido...", .F.)
		
		// Monta a Tela
		oDlgPrc := TDialog():New(1,1,600,1000,OemToAnsi('Log de Faturamento Automatico'),,,,,CLR_BLACK,CLR_WHITE,,,.T.)
		oDlgPrc:lEscClose  	:= .t.  
		oDlgPrc:lMaximized 	:= .f.
		
		// Painel superior
		oPanelSup := tPanel():New(01,01,,oDlgPrc,,.f.,,/*COR_TEXTO*/,,800,150)
		oPanelSup:Align:=CONTROL_ALIGN_TOP

		// Linha com status resumido
		fMontaBanner(nLinha)
		nLinha+=30

		// 1° Linha de campos
		oBtFil 		:= TGet():New(nLinha,005,{|| aCab[1] },oPanelSup,75,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Filial: ',2,)
		oBtPed 		:= TGet():New(nLinha,100,{|| aCab[2] },oPanelSup,59,010,"@!",,,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Pedido: ',2,)
		oBtTp  		:= TGet():New(nLinha,200,{|| aCab[3] },oPanelSup,57,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Tipo: ',2,)
		oBtCli 		:= TGet():New(nLinha,300,{|| aCab[4]+"/"+aCab[5]+" - "+aCab[6] },oPanelSup,165,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Cliente: ',2,)
		nLinha+=15

		// 2° Linha de campos
		oBtDtPed 	:= TGet():New(nLinha,005,{|| DtoC(aCab[7]) },oPanelSup,56,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Pedido: ',2,)
		oBtNTen 	:= TGet():New(nLinha,100,{|| aCab[9] },oPanelSup,40,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'N° Tentativas: ',2,)
		oBtUsr		:= TGet():New(nLinha,200,{|| aCab[10] },oPanelSup,47,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Usuario Fat: ',2,)
		oBtThread	:= TGet():New(nLinha,300,{|| aCab[15] },oPanelSup,56,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Thread: ',2,)
		oBtModExe	:= TGet():New(nLinha,400,{|| aCab[26] },oPanelSup,65,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Modo: ',2,)
		nLinha+=15

		// 3° Linha de campos
		oBtHrVV		:= TGet():New(nLinha,005,{|| aCab[31] },oPanelSup,30,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Lib Vend Vista: ',2,)
		oBtDtLib	:= TGet():New(nLinha,100,{|| aCab[27] },oPanelSup,43,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Lib Ped: ',2,)
		oBtHrLib	:= TGet():New(nLinha,200,{|| aCab[28] },oPanelSup,40,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Lib Ped: ',2,)
		oBtDtConf	:= TGet():New(nLinha,300,{|| aCab[29] },oPanelSup,42,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Fim Conf: ',2,)
		oBtHrConf	:= TGet():New(nLinha,400,{|| aCab[30] },oPanelSup,45,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Fim Conf: ',2,)
		nLinha+=15

		// 4° Linha de campos
		oBtDtInFat	:= TGet():New(nLinha,005,{|| DtoC(aCab[11]) },oPanelSup,52,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Ini Fatur: ',2,)
		oBtHrInFat 	:= TGet():New(nLinha,100,{|| aCab[12] },oPanelSup,42,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Ini Fatur: ',2,)
		oBtDtFmFat 	:= TGet():New(nLinha,200,{|| DtoC(aCab[13]) },oPanelSup,34,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Fim Fatur: ',2,)
		oBtHrFmFat 	:= TGet():New(nLinha,300,{|| aCab[14] },oPanelSup,42,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Fim Fatur: ',2,)
		oBtTime 	:= TGet():New(nLinha,410,{|| aCab[25] },oPanelSup,40,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Tempo Exec: ',2,)
		nLinha+=15

		// 5° Linha de campos
		oBtNumNf 	:= TGet():New(nLinha,005,{|| aCab[16] },oPanelSup,57,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Numero NF: ',2,)
		oBtSerNf 	:= TGet():New(nLinha,100,{|| aCab[17] },oPanelSup,53,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Serie NF: ',2,)
		oBtDtNf		:= TGet():New(nLinha,200,{|| DtoC(aCab[18]) },oPanelSup,41,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Emissão NF: ',2,)
		oBtChvNf	:= TGet():New(nLinha,300,{|| aCab[19] },oPanelSup,156,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Chave NF: ',2,)
		nLinha+=15

		// 6° Linha de campos
		oBtStTr		:= TGet():New(nLinha,005,{|| aCab[20] },oPanelSup,50,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Status Transm: ',2,)
		oBtStCan	:= TGet():New(nLinha,100,{|| aCab[21] },oPanelSup,40,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Status Cancel: ',2,)
		oBtDtTr		:= TGet():New(nLinha,200,{|| DtoC(aCab[22]) },oPanelSup,39,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Data Transm: ',2,)
		oBtHrtr		:= TGet():New(nLinha,300,{|| aCab[23] },oPanelSup,149,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Hora Transm: ',2,)
		nLinha+=15

		// 7° Linha de campos
		oBtRetSef	:= TGet():New(nLinha,005,{|| aCab[24] },oPanelSup,440,010,"@!",,0,,oFntCabTxt,.F.,,.T.,,.F.,,,.F.,,.T.,.F.,,,,,,,,,'Retorno Sefaz: ',2,)
		nLinha+=15

		// Painel inferior com ferramentas
		oBarBut := TBar():New(oDlgPrc,30,30,.T.,,,,.F.)
		oBarBut:Align := CONTROL_ALIGN_BOTTOM
		oButton := thButton():New(01,01,"&Sair",oBarBut,{|| oDlgPrc:End() },30,20)
		oButton:Align := CONTROL_ALIGN_RIGHT
		oButton := thButton():New(01,01,"&Atualizar",oBarBut,{|| Processa( {|| fLoadDados(cCodFil,cCodPed)}, "Carregando", "Carregando dados do pedido...", .F.) },30,20)
		oButton:Align := CONTROL_ALIGN_RIGHT
		oButton := thButton():New(01,01,"&Simular",oBarBut,{|| Processa( {|| SimulValidPed(cCodFil,cCodPed) }, "Simulando", "Executando validações de faturamento...", .F.) },30,20)
		oButton:Align := CONTROL_ALIGN_RIGHT
		If U_RtCheckE("EV_ALT_FAT_DEL_THREAD_FATAUT" ,.f.,,,,,,,,,"RCFATLOG","RcFatLog", "Libera acesso a opção de Remover Thread do processo de faturamento automatico.")
			oButton := thButton():New(01,01,"&Desvincular Thread",oBarBut,{|| fChangeThread(cCodFil,cCodPed) },60,20)
			oButton:Align := CONTROL_ALIGN_LEFT
		EndIf

	
		// Painel do meio com log
		oPanelInf := tPanel():New(01,01,,oDlgPrc,,.f.,,/*COR_TEXTO*/,,800,140)
		oPanelInf:Align:=CONTROL_ALIGN_BOTTOM
		oMsgLog:=TSimpleEditor():New(005,005,oPanelInf,530,110,' ',.T./*readonly*/,,,.T./*pixel*/)
		oMsgLog:Align:=CONTROL_ALIGN_ALLCLIENT
		oMsgLog:TextFormat(2) //1-HTML | 2-Texto simples
		oMsgLog:Load(cLog)
		oMsgLog:Refresh() 

		// Seta o objeto de auto atualizar caso tenha thread ativa -> 7000 = 7 segundos
		oTimer	:= TTimer():New(7000,{|| Processa( {|| fLoadDados(cCodFil,cCodPed)}, "Carregando", "Carregando dados do pedido...", .F.) }, oDlgPrc ) 
		If !Empty(Alltrim(cThread)) .or. lAutoReload
			oTimer:Activate()
		Else
			oTimer:DeActivate()
		EndIf

		oDlgPrc:Activate(,,,.T.,bVldEnd)		

	EndIf

	// Restaura as areas.
	RestArea(aAreaZ8C)
	RestArea(aAreaSD2)
	RestArea(aAreaSC5)

Return

/*/{Protheus.doc} fChangeThread
Função que remove a Thread do vinculo da Z8C
@type function
@version 1.0
@author vitor.seide
@since 12/14/2022
@param cCodFil, character, Codigo da Filial
@param cCodPed, character, Codigo do pedido
/*/
Static Function fChangeThread(cCodFil, cCodPed)
Default cCodFil 	:= ''
Default cCodPed 	:= ''

	DbSelectArea("Z8C")
	Z8C->(DbSetOrder(1))
	If Z8C->(DbSeek(cCodFil+cCodPed))
		If !Empty(Alltrim(Z8C->Z8C_THREAD))
			If MsgYesNo("Tem certeza que deseja desvincular essa thread do faturamento automatico? Deve ser conferido se a thread continua ativa no DbAccess.")
				If RecLock("Z8C",.F.)
					Replace Z8C->Z8C_THREAD With ' '
					Z8C->(MsUnlock())

					Processa( {|| fLoadDados(cCodFil,cCodPed)}, "Carregando", "Carregando dados do pedido...", .F.)
				EndIf
			EndIf
		Else
			MsgInfo("Nenhuma thread atualmente executando esse faturamento.")
		EndIf
	EndIf

Return

/*/{Protheus.doc} fMontaBanner
Funçao para montar o painel principal demonstrativo de status
@type function
@version 1.0 
@author vitor.seide
@since 12/12/2022
@param nLinha, numeric, Linha que deverá ser iniciado
/*/
Static Function fMontaBanner(nLinha)
Local oFntStat
Default nLinha 	:= 05

	// Define o tamanho da fonte
	If Len(Alltrim(cStatus)) >= 50
		oFntStat	:= TFont():New("Helvetica",,20,,.T.,,,,,.F.)
	Else
		oFntStat	:= TFont():New("Helvetica",,30,,.T.,,,,,.F.)
	EndIf

	fResetObj()
	oPnStatus 	:= tPanel():New(nLinha,05,cStatus,oPanelSup,oFntStat,.T.,,/*COR_TEXTO*/,nCorStat,490,25,,.T.)

Return

/*/{Protheus.doc} fResetObj
Função que destroi o painel para reconstruir
@type function
@version 1.0
@author vitor.seide
@since 12/12/2022
/*/
Static Function fResetObj()
	
	/// Reseta variaveis ja estiverem em tela
	If ValType(oPnStatus) = 'O'
		FreeObj(oPnStatus)
	EndIf
	
Return

/*/{Protheus.doc} fLoadDados
Função que carrega os dados do pedido 
@type function
@version 1.0 
@author vitor.seide
@since 12/12/2022
@param cCodFil, character, Codigo da Filial
@param cCodPed, character, Codigo do pedido
/*/
Static Function fLoadDados(cCodFil, cCodPed)
Local cAliasQry 	:= GetNextAlias()
Local cQueryZ8C		:= ''
Local cStatSPED		:= ''
Local cStatCancSped	:= ''
Local aDadSM0 		:= {}
Local cTmpExec 		:= ''
Local cMsgTrans 	:= ''
Local aDatHrProc 	:= {}
Default cCodFil 	:= ''
Default cCodPed 	:= ''

	// Limpa variaveis
	aCab 	:= {}
	cLog	:= ''

	// Posiciona na Z8C para pegar o campo MEMO
	DbSelectArea("Z8C")
	Z8C->(DbSetOrder(1))
	If Z8C->(DbSeek(cCodFil+cCodPed))
		cLog := Z8C->Z8C_RETFAT
	EndIf
	If Empty(Alltrim(cLog))
		cLog := 'Sem LOG de faturamento automatico para este pedido.'
	EndIf

	// Query relacionando todas tabelas com dados necessarios na demonstração
	cQueryZ8C := " SELECT C5.C5_FILIAL, C5.C5_NUM, C5.C5_TIPO, C5.C5_CLIENTE, C5.C5_LOJACLI, C5.C5_EMISSAO, C5.C5_CONDPAG, "
	cQueryZ8C += " Z8C.Z8C_NTNTVS, Z8C.Z8C_USER, Z8C.Z8C_DTINI, Z8C.Z8C_HRINI, Z8C.Z8C_DTFIM, Z8C.Z8C_HRFIM, Z8C.Z8C_THREAD, Z8C.Z8C_MODEXE, Z8C.Z8C_WAITFT, Z8C.Z8C_WAITUS, Z8C.Z8C_MODEXE, "
	cQueryZ8C += " D2.D2_DOC, D2.D2_SERIE, D2.D2_EMISSAO, F2.F2_CHVNFE, "
	cQueryZ8C += " NVL(SPED.STATUS,0) STATUS, NVL(SPED.STATUSCANC,0) STATUSCANC, SPED.DATE_ENFE, SPED.TIME_NFE, "
	cQueryZ8C += " ( SELECT XMOT_SEFR FROM "
    cQueryZ8C += " 		(SELECT SPED54.XMOT_SEFR FROM SPEDRECH.SPED054 SPED54 WHERE ID_ENT = (SELECT X6.X6_CONTEUD FROM SX6010 X6 WHERE X6_FIL = C5.C5_FILIAL AND X6_VAR = 'MV_ID_NFE' AND X6.D_E_L_E_T_ = ' ') AND SPED54.NFE_ID = D2.D2_SERIE||D2.D2_DOC AND SPED54.D_E_L_E_T_ = ' ' ORDER BY R_E_C_N_O_ DESC) "
    cQueryZ8C += " 	WHERE ROWNUM = 1) MENSAGEMSPED54 "
	cQueryZ8C += " FROM " + RetSqlName("SC5") + " C5 "
	cQueryZ8C += " LEFT JOIN " + RetSqlName("Z8C") + " Z8C ON Z8C.Z8C_FILIAL = C5.C5_FILIAL AND Z8C.Z8C_PEDIDO = C5.C5_NUM AND Z8C.D_E_L_E_T_ = ' ' "
	cQueryZ8C += " LEFT JOIN " + RetSqlName("SD2") + " D2 ON D2.D2_FILIAL = C5.C5_FILIAL AND D2.D2_PEDIDO = C5.C5_NUM AND D2.D_E_L_E_T_ = ' ' "
	cQueryZ8C += " LEFT JOIN " + RetSqlName("SF2") + " F2 ON F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.D_E_L_E_T_ = ' ' "
	cQueryZ8C += " LEFT JOIN SPEDRECH.SPED050 SPED ON SPED.ID_ENT = (SELECT X6.X6_CONTEUD FROM SX6010 X6 WHERE X6_FIL = C5.C5_FILIAL AND X6_VAR = 'MV_ID_NFE' AND X6.D_E_L_E_T_ = ' ') AND SPED.NFE_ID = D2.D2_SERIE||D2.D2_DOC AND SPED.D_E_L_E_T_ = ' ' "
	cQueryZ8C += " WHERE C5.C5_FILIAL = '" + xFilial("SC5",cCodFil) + "' "
	cQueryZ8C += " AND C5.C5_NUM = '" + cCodPed + "' "
	cQueryZ8C += " AND C5.D_E_L_E_T_ = ' ' "
	cQueryZ8C += " GROUP BY C5.C5_FILIAL, C5.C5_NUM, C5.C5_TIPO, C5.C5_CLIENTE, C5.C5_LOJACLI, C5.C5_EMISSAO, C5.C5_CONDPAG, "
	cQueryZ8C += " Z8C.Z8C_NTNTVS, Z8C.Z8C_USER, Z8C.Z8C_DTINI, Z8C.Z8C_HRINI, Z8C.Z8C_DTFIM, Z8C.Z8C_HRFIM, Z8C.Z8C_THREAD, Z8C.Z8C_MODEXE, Z8C.Z8C_WAITFT, Z8C.Z8C_WAITUS, Z8C.Z8C_MODEXE, "
	cQueryZ8C += " D2.D2_DOC, D2.D2_SERIE, D2.D2_EMISSAO, F2.F2_CHVNFE, "
	cQueryZ8C += " SPED.TIME_NFE, SPED.STATUS, SPED.STATUSCANC, SPED.DATE_ENFE, SPED.TIME_NFE "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryZ8C),cAliasQry,.F.,.T.)

	If	(cAliasQry)->( ! Eof() )

			cStatSPED		:= ''
			cMsgTrans		:= ''
			cStatCancSped	:= ''
			nCorStat		:= ''
			cTmpExec		:= ''
			aDadSM0 		:= FWSM0Util():GetSM0Data(cEmpAnt,(cAliasQry)->C5_FILIAL,{"M0_FILIAL"})
			cThread			:= Alltrim((cAliasQry)->Z8C_THREAD)
			aDatHrProc		:= fLoadDtHr((cAliasQry)->C5_FILIAL,(cAliasQry)->C5_NUM)

			// Status de transmissão da nota
			Do Case 
				Case (cAliasQry)->STATUS = 1
					cStatSPED := "NFe Recebida"
				Case (cAliasQry)->STATUS = 2
					cStatSPED := "NFe Assinada"
				Case (cAliasQry)->STATUS = 3
					cStatSPED := "NFe com falha no schema XML"
				Case (cAliasQry)->STATUS = 4
					cStatSPED := "NFe transmitida"
				Case (cAliasQry)->STATUS = 5
					cStatSPED := "NFe com problemas"
				Case (cAliasQry)->STATUS = 6
					cStatSPED := "NFe autorizada"
				Case (cAliasQry)->STATUS = 7
					cStatSPED := "NFE Cancelada"
				OtherWise 
					cStatSPED := ''
			EndCase

			// Status do cancelamento da nota
			Do Case 
				Case (cAliasQry)->STATUSCANC = 1
					cStatCancSped := "NFe Recebida"
				Case (cAliasQry)->STATUSCANC = 2
					cStatCancSped := "NFe Cancelada"
				Case (cAliasQry)->STATUSCANC = 3
					cStatCancSped := "NFe com falha de cancelamento/inutilização."
				OtherWise 
					cStatCancSped := ''
			EndCase		

			// Define o status resumido
			Do Case
				Case (cAliasQry)->STATUS = 7
					cStatus		:= 'Nota Cancelada'
					nCorStat	:= CORGREY

				Case !Empty(Alltrim(cStatSPED)) .and. ( (cAliasQry)->STATUS = 3 .or. (cAliasQry)->STATUS = 5 )
					cStatus		:= 'Nota transmitida e rejeitada'
					nCorStat	:= CORRED
				
				Case !Empty(Alltrim(cStatSPED)) .and. ( (cAliasQry)->STATUS = 6 )
					cStatus		:= 'Nota transmitida e aprovada'
					nCorStat	:= CORGREEN

				Case !Empty(Alltrim(cStatSPED)) .and. ( (cAliasQry)->STATUS = 1 .or. (cAliasQry)->STATUS = 2 .or. (cAliasQry)->STATUS = 4 )
					cStatus		:= 'Nota transmitida em monitoramento'
					nCorStat	:= CORBLUE
				
				Case !Empty(Alltrim((cAliasQry)->D2_DOC))
					cStatus		:= 'Nota gerada'
					nCorStat	:= CORORANGE
				
				Case Empty(Alltrim((cAliasQry)->D2_DOC)) .and. !Empty(Alltrim((cAliasQry)->Z8C_THREAD))
					cStatus		:= 'Ainda sem Nota Fiscal'
					nCorStat	:= CORPINK
				
				Case Empty(Alltrim((cAliasQry)->D2_DOC)) .and. Empty(Alltrim((cAliasQry)->Z8C_THREAD)) .and. !Empty(Alltrim((cAliasQry)->Z8C_WAITFT))
					cStatus		:= 'Faturamento Automatico pausado por ' + Alltrim((cAliasQry)->Z8C_WAITUS) + " ás " + Alltrim((cAliasQry)->Z8C_WAITFT)
					nCorStat	:= CORBROWN

				Case Empty(Alltrim((cAliasQry)->D2_DOC)) .and. Empty(Alltrim((cAliasQry)->Z8C_THREAD)) .and. (cAliasQry)->Z8C_NTNTVS > 0
					cStatus		:= 'Tentativas de faturamento sem sucesso'
					nCorStat	:= CORCIA
			
				OtherWise
					cStatus		:= 'Sem status'
					nCorStat	:= CORNO

			EndCase

			If (cAliasQry)->STATUS = 3 .and. Empty(Alltrim((cAliasQry)->MENSAGEMSPED54))
				cMsgTrans := 'Falha no Schema do XML. Realizar consulta no monitoramento.'
			Else
				cMsgTrans := Alltrim((cAliasQry)->MENSAGEMSPED54)
			EndIf

			// Calcula o tempo de execução
			If !Empty(Alltrim(SubStr(Alltrim((cAliasQry)->Z8C_HRFIM),1,8)))
				cTmpExec := ElapTime(SubStr(Alltrim((cAliasQry)->Z8C_HRINI),1,8),SubStr(Alltrim((cAliasQry)->Z8C_HRFIM),1,8))
			ElseIf !Empty(Alltrim((cAliasQry)->Z8C_THREAD))
				If !Empty(Alltrim(SubStr(Alltrim((cAliasQry)->Z8C_HRINI),1,8)))
					cTmpExec := ElapTime(SubStr(Alltrim((cAliasQry)->Z8C_HRINI),1,8),SubStr(Alltrim(TimeFull()),1,8))
				EndIf
			Else
				cTmpExec := "00:00:00"
			EndIf

			// Verifica se ainda esta em execução
			If !Empty(Alltrim((cAliasQry)->Z8C_THREAD))
				cStatus := "EM EXECUÇÃO -> " + cStatus
			EndIf

			aCab := 	{(cAliasQry)->C5_FILIAL + "-" + AllTrim(Upper(aDadSM0[1][2])),;
						(cAliasQry)->C5_NUM,;
						Iif((cAliasQry)->C5_TIPO=='N','Normal',Iif((cAliasQry)->C5_TIPO=='D','Devolução','Outros')),;
						(cAliasQry)->C5_CLIENTE,;
						(cAliasQry)->C5_LOJACLI,;
						Iif((cAliasQry)->C5_TIPO=='D',Alltrim(Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->C5_CLIENTE+(cAliasQry)->C5_LOJACLI,'A2_NREDUZ')),Alltrim(Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->C5_CLIENTE+(cAliasQry)->C5_LOJACLI,'A1_NREDUZ'))),;
						StoD((cAliasQry)->C5_EMISSAO) ,;
						Alltrim((cAliasQry)->C5_CONDPAG),;
						(cAliasQry)->Z8C_NTNTVS,;
						Alltrim((cAliasQry)->Z8C_USER),;
						StoD((cAliasQry)->Z8C_DTINI),;
						SubStr(Alltrim((cAliasQry)->Z8C_HRINI),1,8),;
						Stod((cAliasQry)->Z8C_DTFIM),;
						SubStr(Alltrim((cAliasQry)->Z8C_HRFIM),1,8),;
						Alltrim((cAliasQry)->Z8C_THREAD),;
						Alltrim((cAliasQry)->D2_DOC),;
						Alltrim((cAliasQry)->D2_SERIE),;
						StoD((cAliasQry)->D2_EMISSAO),;
						Alltrim((cAliasQry)->F2_CHVNFE),;
						cStatSPED,;
						cStatCancSped,;
						StoD((cAliasQry)->DATE_ENFE),;
						Alltrim((cAliasQry)->TIME_NFE),;
						cMsgTrans,;
						cTmpExec,;
						Alltrim((cAliasQry)->Z8C_MODEXE),;
						aDatHrProc[1],;
						aDatHrProc[2],;
						aDatHrProc[3],;
						aDatHrProc[4],;
						aDatHrProc[5]} 
		
	EndIf
	(cAliasQry)->(DbCloseArea())

	// Realiza aviso
	If Len(aCab) <= 0
		MsgAlert("Não foi possivel encontrar dados sobre este faturamento.")
		aAdd(aCab,{     '',;
						'',;
						'',;
						'',;
						'',;
						'',;
						StoD(' / / ') ,;
						'',;
						0,;
						'',;
						StoD(' / / '),;
						'',;
						Stod(' / / '),;
						'',;
						'',;
						'',;
						'',;
						StoD(' / / '),;
						'',;
						'',;
						'',;
						StoD(' / / '),;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						''})
	EndIf

	// Chama função para dar refresh  objetos
	fRefreshObj()

Return

Static Function fLoadDtHr(cCodFil,cCodPed)
Local aAreaZY1 	:= ZY1->(GetArea())
Local aRetorno 	:= {' - ',' - ',' - ',' - ',' - '}
Local cQuery 	:= ''
Local cAliasQry := GetNextAlias()
Local lWMS      := IntDl()
Default cCodFil := ''
Default cCodPed := ''

	// Pega a data de liberação
	cQuery := " SELECT MAX(C9_DATALIB||C9_HORALIB) DATA_HORA_LIB"
	cQuery += " FROM " + RetSqlName("SC9") + " "
	cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9",cCodFil) + "' "
	cQuery += " AND C9_PEDIDO = '" + cCodPed + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)
	If	(cAliasQry)->( ! Eof() )
		If !Empty(Alltrim((cAliasQry)->DATA_HORA_LIB))
			aRetorno[1] := DtoC(StoD(Alltrim(SubStr((cAliasQry)->DATA_HORA_LIB,1,8))))
			aRetorno[2] := Alltrim(SubStr((cAliasQry)->DATA_HORA_LIB,9))
		EndIf
	EndIf
	(cAliasQry)->(DbCloseArea())

	// Verifica a se encerrou a conferencia e a data e hora
	If lWMS
		cQuery := " SELECT MAX(DB.DB_DATAFIM||DB.DB_HRFIM) DATA_HORA_CONF "
		cQuery += " FROM " + RetSqlName("SDB") + " DB "
		cQuery += " WHERE DB.DB_FILIAL = '" + xFilial("SDB",cCodFil) + "' " 
		cQuery += " AND DB.DB_DOC = '" + Alltrim(cCodPed) + "' "
		cQuery += " AND DB.DB_ORIGEM = 'SC9' "
		cQuery += " AND DB.DB_ATUEST = 'N' "
		cQuery += " AND DB.DB_ESTORNO = ' ' "
		cQuery += " AND DB.DB_TAREFA IN ('012','014')"
		cQuery += " AND DB.DB_STATUS NOT IN ('4','-','3','2')  "
		cQuery += " AND (  SELECT COUNT(*) 
		cQuery += "        FROM " + RetSqlName("SDB") + " DB2 "
		cQuery += "        WHERE DB2.DB_FILIAL = DB.DB_FILIAL "
		cQuery += "        AND DB2.DB_DOC = DB.DB_DOC "
		cQuery += "        AND DB2.DB_ORIGEM = 'SC9' "
		cQuery += "        AND DB2.DB_ATUEST = 'N' "
		cQuery += "        AND DB2.DB_ESTORNO = ' ' "
		cQuery += "        AND DB2.DB_TAREFA IN ('012','014') "
		cQuery += "        AND DB2.DB_STATUS IN ('4','-','3','2') "
		cQuery += "        AND DB2.DB_QTDLID <> DB2.DB_QUANT "
		cQuery += "        AND DB2.D_E_L_E_T_ = ' ' ) <= 0 "
		cQuery += " AND DB.D_E_L_E_T_ = ' '  "
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)
	Else
		cQuery := " SELECT MAX(C9_DTCONFE||C9_HRCONFE) DATA_HORA_CONF"
		cQuery += " FROM " + RetSqlName("SC9") + " C9 "
		cQuery += " WHERE C9.C9_FILIAL = '" + xFilial("SC9",cCodFil) + "' "
		cQuery += " AND C9.C9_PEDIDO = '" + cCodPed + "' "
		cQuery += " AND (  SELECT COUNT(*) 
		cQuery += "        FROM " + RetSqlName("SC9") + " C92 "
		cQuery += "        WHERE C92.C9_FILIAL = C9.C9_FILIAL "
		cQuery += "        AND C92.C9_PEDIDO = C9.C9_PEDIDO "
		cQuery += "        AND ( C92.C9_BLEST IN ('02','03') OR C92.C9_BLCRED NOT IN (' ','10') ) "
		cQuery += "        AND C92.C9_DTCONFE = ' ' "
		cQuery += "        AND C92.D_E_L_E_T_ = ' ' ) <= 0 "
		cQuery += " AND C9.D_E_L_E_T_ = ' ' "
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasQry,.F.,.T.)		
	EndIf
	If (cAliasQry)->(!Eof())
		If !Empty(Alltrim((cAliasQry)->DATA_HORA_CONF))
			aRetorno[3] := DtoC(StoD(Alltrim(SubStr((cAliasQry)->DATA_HORA_CONF,1,8))))
			aRetorno[4] := Alltrim(SubStr((cAliasQry)->DATA_HORA_CONF,9))
		EndIf
	EndIf
	(cAliasQry)->(DbCloseArea())
	
	// Verifica hora de liberação venda a vista
	DbSelectArea("ZY1")
	ZY1->(DbSetOrder(3))
	If ZY1->(DbSeek(xFilial("SC5",cCodFil) + "V1" + cCodPed ))
		If AllTrim(ZY1->ZY1_STATUS) = "2"
			aRetorno[5] := ZY1->ZY1_HRANAL
		Else	
			aRetorno[5] := 'PENDENTE'			
		EndIf
	EndIf
	ZY1->(DbCloseArea())

	// Retorna a area
	RestArea(aAreaZY1)
	
Return aRetorno

/*/{Protheus.doc} fRefreshObj
Função pra atualização dos objetos
@type function
@version 1.0  
@author vitor.seide
@since 12/12/2022
/*/
Static Function fRefreshObj()

	// Atualiza os objetos
	If ValType(oMsgLog) = 'O'
		oMsgLog:Load(cLog)
		oMsgLog:Refresh()  
	EndIf
	If ValType(oBrwDad) = 'O'
		oBrwDad:SetArray(aCab)
		oBrwDad:DrawSelect()
		oBrwDad:Refresh()
	EndIf
	If ValType(oBtFil) = 'O'
		oBtFil:Refresh()
	EndIf
	If ValType(oBtPed) = 'O'
		oBtPed:Refresh()
	EndIf
	If ValType(oBtTp) = 'O'
		oBtTp:Refresh()
	EndIf
	If ValType(oBtCli) = 'O'
		oBtCli:Refresh()
	EndIf
	If ValType(oBtDtPed) = 'O'
		oBtDtPed:Refresh()
	EndIf
	If ValType(oBtHrVV) = 'O'
		oBtHrVV:Refresh()
	EndIf
	If ValType(oBtDtLib) = 'O'
		oBtDtLib:Refresh()
	EndIf
	If ValType(oBtHrLib) = 'O'
		oBtHrLib:Refresh()
	EndIf
	If ValType(oBtDtConf) = 'O'
		oBtDtConf:Refresh()
	EndIf
	If ValType(oBtHrConf) = 'O'
		oBtHrConf:Refresh()
	EndIf
	If ValType(oBtNTen) = 'O'
		oBtNTen:Refresh()
	EndIf
	If ValType(oBtUsr) = 'O'
		oBtUsr:Refresh()
	EndIf
	If ValType(oBtTime) = 'O'
		oBtTime:Refresh()
	EndIf
	If ValType(oBtDtInFat) = 'O'
		oBtDtInFat:Refresh()
	EndIf
	If ValType(oBtHrInFat) = 'O'
		oBtHrInFat:Refresh()
	EndIf
	If ValType(oBtDtFmFat) = 'O'
		oBtDtFmFat:Refresh()
	EndIf
	If ValType(oBtHrFmFat) = 'O'
		oBtHrFmFat:Refresh()
	EndIf
	If ValType(oBtThread) = 'O'
		oBtThread:Refresh()
	EndIf
	If ValType(oBtModExe) = 'O'
		oBtModExe:Refresh()
	EndIf
	If ValType(oBtNumNf) = 'O'
		oBtNumNf:Refresh()
	EndIf
	If ValType(oBtSerNf) = 'O'
		oBtSerNf:Refresh()
	EndIf
	If ValType(oBtDtNf) = 'O'
		oBtDtNf:Refresh()
	EndIf
	If ValType(oBtChvNf) = 'O'
		oBtChvNf:Refresh()
	EndIf
	If ValType(oBtStTr) = 'O'
		oBtStTr:Refresh()
	EndIf
	If ValType(oBtStCan) = 'O'
		oBtStCan:Refresh()
	EndIf
	If ValType(oBtDtTr) = 'O'
		oBtDtTr:Refresh()
	EndIf
	If ValType(oBtHrtr) = 'O'
		oBtHrtr:Refresh()
	EndIf
	If ValType(oBtRetSef) = 'O'
		oBtRetSef:Refresh()
	EndIf
	If ValType(oPnStatus) = 'O'
		fMontaBanner(05)
	EndIf
	If ValType(oTimer) = 'O'
		If !Empty(Alltrim(cThread)) .or. lAutoReload
			oTimer:Activate()
		Else
			oTimer:DeActivate()
		EndIf
	EndIf

Return

/*/{Protheus.doc} RcUpdFat
Função chamada de pontos de entrada externos para atualizar Z8C
@type function
@version 1.0 
@author vitor.seide
@since 12/22/2022
@param cCodFil, character, Filial do Pedido
@param cNumPed, character, Numero do Pedido
@param aFields, array, Campos e conteudos a serem atualizados
/*/
User Function RcUpdFat(cCodFil,cNumPed,aFields,lLogProc)
Local  aAreaZ8C 	:= Z8C->(GetArea())
Local  lExistZ8C	:= .F.
Local  nCmp 		:= 0
Default cCodFil		:= ''
Default cNumPed		:= ''
Default aFields		:= {}
Default lLogProc	:= .F.

	If Empty(Alltrim(cCodFil)) .or. Empty(Alltrim(cNumPed)) .or. Len(aFields) <= 0
		RestArea(aAreaZ8C)
		Return
	EndIf

	// Abre a area
	DbSelectArea("Z8C")
	Z8C->(DbSetOrder(1))

	// Verifica se ja existe ou cria
	lExistZ8C := Z8C->(DbSeek(xFilial("Z8C",cCodFil)+cNumPed))

	If RecLock("Z8C",!lExistZ8C)
		
		// Se estiver inserindo, cria o cabeçalho
		If !lExistZ8C
			Replace Z8C->Z8C_FILIAL With xFilial("Z8C",cCodFil)
			Replace Z8C->Z8C_PEDIDO With cNumPed
		EndIf

		// Passa por cada um dos campos e conteudo
		For nCmp := 1 to Len(aFields)
			// Verifica se foi enviado um campo valido
			If Z8C->(FieldPos(aFields[nCmp][1])) > 0
				If aFields[nCmp][1] <> 'Z8C_RETFAT'
					Replace &("Z8C->"+Alltrim(aFields[nCmp][1])) With aFields[nCmp][2]
				Else
					Replace &("Z8C->"+Alltrim(aFields[nCmp][1])) With aFields[nCmp][2] + CR + &("Z8C->"+Alltrim(aFields[nCmp][1]))
				EndIf
			EndIf
		Next nCmp

		Z8C->(MsUnlock())
	EndIf

	RestArea(aAreaZ8C)

Return

/*/{Protheus.doc} SimulValidPed
Função para chamar simulação de validação do pedido para ver se esta apto a faturar
@type function
@version 1.0 
@author vitor.seide
@since 12/25/2022
@param cFilSim, character, Codigo da Filial
@param cPedSim, character, Numero do pedido
/*/
Static Function SimulValidPed(cFilSim,cPedSim)
Local cBkpFil 		:= cFilAnt
Local aAreaSC5		:= SC5->(GetArea())
Local aAreaZ8C		:= Z8C->(GetArea())
Local lValido 		:= .F.
Local nMsg 			:= 1
Local cMensagens 	:= ''
Private aRetFat 	:= {}
Private lGerarNota 	:= .F.
Private lTransmitir := .F.
Private lMonitorar 	:= .F.
Private lImprimir 	:= .F.
Private lSimulacao  := .T.
Private aSimula		:= {}
Private cUrlSped	:= ''
Private cIdEnt		:= ''
Private cConfer 	:= ''
Private cRHAuto		:= ''
Private cUsuAuto	:= ''
Private cFACodFil	:= ''
Private cFANumPed 	:= ''
Default cFilSim 	:= ''
Default cPedSim		:= ''
Private aRecnoSc9 	:= {}

	// Valida os parametros passados
	If Empty(Alltrim(cFilSim)) .or. Empty(Alltrim(cPedSim))
		MsgAlert("Não foi passado os parametros para a função de simulação.")
		RestArea(aAreaSC5)
		RestArea(aAreaZ8C)
		Return
	Else
		cFACodFil	:= cFilSim
		cFANumPed	:= cPedSim
	EndIf

	// Posiciona na filial devida
	If cFilAnt <> cFilSim
		cFilAnt := cFilSim
	EndIf

	// Pega dados necessarios para validação
	cUrlSped 		:= AllTrim(SuperGetMV("MV_SPEDURL",.F.,"",cFilAnt))
	cIdEnt 			:= RetIdEnti(.F.)
	
	// Chama função de validação.
	lValido := ValidPedFat()
	
	// Adiciona o titulo principal com o veredito 
	If lValido
		cMensagens := ' --- PEDIDO VALIDO PARA FATURAMENTO AUTOMATICO --- ' + CR
	Else
		cMensagens := ' ---!! PEDIDO NÃO VALIDO PARA FATURAMENTO AUTOMATICO !!--- ' + CR
	EndIF

	// Adiciona cada uma das validações
	For nMsg := 1 to Len(aSimula)
		cMensagens += CR + Alltrim(aSimula[nMsg])
	Next nMsg

	// Demonstra os dados
	If lValido
		MsgInfo(cMensagens,'Valido')
	Else
		MsgAlert(cMensagens,'Não Valido')
	EndIf

	// Restaura a filial
	If cFilAnt <> cBkpFil
		cFilAnt := cBkpFil
	EndIf
	RestArea(aAreaSC5)
	RestArea(aAreaZ8C)

Return


//Valida se pedido foi gerado por Ajuste de Perda ZZL
Static Function fValPedZZL(pFilial,pDoc)
Local lRet 				:= .F.
Local cAreaZZL      	:= GetArea()
Local cQuery        	:= ""
Local cAliasQZZL     	:= GetNextAlias()

    cQuery   := "SELECT COUNT(ZZL_PEDIDO)  AS QTPED FROM "+RetSqlName('ZZL')+" ZZL WHERE ZZL_FILIAL = '"+pFilial+"' AND ZZL_PEDIDO = '"+pDoc+"' AND ZZL.D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasQZZL,.F.,.T.)

    While !(cAliasQZZL)->(Eof())	

		If !Empty((cAliasQZZL)->QTPED)
			lRet := .T.	
		EndIf 

        (cAliasQZZL)->(DBSkip())
    EndDo

    (cAliasQZZL)->(dbCloseArea())
    RestArea(cAreaZZL)

Return(lRet)
