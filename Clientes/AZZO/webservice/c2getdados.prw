#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"

User Function c2getdados()

	Local cHtml  := "", oObj
	Local linha
	Local xIte
	Local xUsrAdm := ""
	Local xPssAdm := ""

	//Tratamento para login e senha via parâmetro, como o parâmetro já está criado, vai buscar da SX6
	xUsrAdm	:= Alltrim(SuperGetMv("AZ_USRADM",.F.,"Admin"	))
	xPssAdm	:= Alltrim(SuperGetMv("AZ_PSSADM",.F.,"Azul*azzo20251"))

	WEB EXTENDED INIT cHtml

//Verifica o tipo da consulta
	if httpGet->tipo == 'METAFAT'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Meta de Faturamento - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:METAFAT( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Meta de Faturamento - fim: '+time())

			cHtml := oObj:cMETAFATRESULT

		endif

	elseif httpGet->tipo == 'METAFAT2'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Meta de Faturamento - Devolucoes - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:META2FAT( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Meta de Faturamento - Devolucoes - fim: '+time())

			cHtml := oObj:cMETA2FATRESULT

		endif

	elseif httpGet->tipo == 'METAFAT3'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Meta de Faturamento - Metas - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:META3FAT( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Meta de Faturamento - Metas - fim: '+time())

			cHtml := oObj:cMETA3FATRESULT

		endif

	elseif httpGet->tipo == 'FATPER'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Faturamento por periodo - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATPER( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->periodo)

			conout('==> WS Faturamento por periodo - fim: '+time())

			cHtml := oObj:cFATPERRESULT

		endif

	elseif httpGet->tipo == 'FATACUM'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Faturamento Acumulado - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATACUM( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Faturamento Acumulado - fim: '+time())

			cHtml := oObj:cFATACUMRESULT

		endif

	elseif httpGet->tipo == 'FATREG'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Faturamento por regiao - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATREG( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Faturamento por regiao - fim: '+time())

			cHtml := oObj:cFATREGRESULT

		endif

	elseif httpGet->tipo == 'FATCLI'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Faturamento por cliente - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATCLI( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Faturamento por cliente - fim: '+time())

			cHtml := oObj:cFATCLIRESULT

		endif

	elseif httpGet->tipo == 'FATCPROD'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Faturamento por cliente / grupo de produtos - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATCPROD( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->cdcli)

			conout('==> WS Faturamento por cliente / grupo de produtos - fim: '+time())

			cHtml := oObj:cFATCPRODRESULT

		endif

	elseif httpGet->tipo == 'FATPCLI'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		aMeses := {'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'}
		xBarra := aScan(aMeses,substr(httpGet->diabarra,1,3))
		if !empty(xBarra)
			xDti   := ctod('01/'+strzero(aScan(aMeses,substr(httpGet->diabarra,1,3)),2)+substr(httpGet->diabarra,4,5))
			xDtf   := LastDay(xDti)
		else
			xDti   := ctod(httpGet->dti)
			xDtf   := ctod(httpGet->dtf)
		endif
		xBarra := iif(!empty(xBarra), ctod(''), ctod(httpGet->diabarra))

		conout('==> WS Faturamento periodo por cliente - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		//If oObj:FATPCLI( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), ctod(httpGet->diabarra))
		If oObj:FATPCLI( httpGet->codemp, xDti, xDtf, xBarra)

			conout('==> WS Faturamento periodo por cliente - fim: '+time())

			cHtml := oObj:cFATPCLIRESULT

		endif

	elseif httpGet->tipo == 'FATHIS'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Evolucao Historica - fim: '+time())

			cHtml := oObj:cFATHISRESULT

		endif

	elseif httpGet->tipo == 'FATHIS1'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica por Regional - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS1( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Evolucao Historica por Regional - fim: '+time())

			cHtml := oObj:cFATHIS1RESULT

		endif

	elseif httpGet->tipo == 'FATHIS2'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica por Regiao - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS2( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Evolucao Historica por Regiao - fim: '+time())

			cHtml := oObj:cFATHIS2RESULT

		endif

	elseif httpGet->tipo == 'FATHIS3'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica por UF - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS3( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Evolucao Historica por UF - fim: '+time())

			cHtml := oObj:cFATHIS3RESULT

		endif

	elseif httpGet->tipo == 'FATHIS4'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica por Representante - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS4( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->regiao)

			conout('==> WS Evolucao Historica por Representante - fim: '+time())

			cHtml := oObj:cFATHIS4RESULT

		endif

	elseif httpGet->tipo == 'FATHIS5'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Evolucao Historica por Produto do Representante - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATHIS5( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Evolucao Historica por Produto do Representante - fim: '+time())

			cHtml := oObj:cFATHIS5RESULT

		endif

	elseif httpGet->tipo == 'FATYTD'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Comparativo YTD - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATYTD( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Comparativo YTD - fim: '+time())

			cHtml := oObj:cFATYTDRESULT

		endif

	elseif httpGet->tipo == 'FATGRU'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Grupo de Produtos - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATGRU( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->regiao)

			conout('==> WS Grupo de Produtos - fim: '+time())

			cHtml := oObj:cFATGRURESULT

		endif

	elseif httpGet->tipo == 'FATPTER'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Produtos proprios ou terceiros - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATPTER( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Produtos proprios ou terceiros - fim: '+time())

			cHtml := oObj:cFATPTERRESULT

		endif

	elseif httpGet->tipo == 'FATGRUP'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Produtos do grupo de produto - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATGRUP( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro, httpGet->regiao)

			conout('==> WS Produtos do grupo de produto - fim: '+time())

			cHtml := oObj:cFATGRUPRESULT

		endif

	elseif httpGet->tipo == 'FATCRES'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Crescimento de faturamento via lançamentos - inicio: '+time())

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FATCRES( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Crescimento de faturamento via lançamentos - fim: '+time())

			cHtml := oObj:cFATCRESRESULT

		endif

	elseif httpGet->tipo == 'FININA'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:FININA( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			cHtml := oObj:cFININARESULT

		endif

	elseif httpGet->tipo == 'TAXREP'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Taxa de efetividade por representante - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:TAXREP( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->filtro)

			conout('==> WS Taxa de efetividade por representante - fim: '+time())

			cHtml := oObj:cTAXREPRESULT

		endif

	elseif httpGet->tipo == 'CDIRES'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS CDI Resumo - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:CDIRESUMO( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS CDI Resumo - fim: '+time())

			cHtml := oObj:cCDIRESUMORESULT

		endif

	elseif httpGet->tipo == 'CDICOMP'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		_filtro := httpGet->filtro
		if httpGet->filtro == NIL
			_filtro := ''
		endif

		conout('==> WS CDI Comparativo - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:CDICOMPAR( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), _filtro)

			conout('==> WS CDI Comparativo - fim: '+time())

			cHtml := oObj:cCDICOMPARRESULT

		endif


	elseif httpGet->tipo == 'QTPED'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Quantidade Diaria de Pedidos - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:QTDPED( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf))

			conout('==> WS Quantidade Diaria de Pedidos - fim: '+time())

			cHtml := oObj:cQTDPEDRESULT

		endif

	elseif httpGet->tipo == 'REGIAOMETA'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:REGIAOMETA( httpGet->codemp, httpGet->ano_atual, httpGet->regiao, httpGet->estado, httpGet->vendedor, httpGet->meses )

			cHtml := oObj:cREGIAOMETARESULT

		endif

	elseif httpGet->tipo == 'GRUPOMETA'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		cRegiao := ''
		if Type( 'httpget->regiao' ) <> "U"
			cRegiao := httpGet->regiao
		endif

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:GRUPOMETA( cRegiao, httpGet->codemp, httpGet->ano_atual, httpGet->estado, httpGet->vendedor, httpGet->meses )

			cHtml := oObj:cGRUPOMETARESULT

		endif

	elseif httpGet->tipo == 'MESMETA'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Metas Mensal Nova - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:MESMETA( httpGet->codemp, httpGet->ano_atual, httpGet->estado, httpGet->vendedor, httpGet->meses )

			conout('==> WS Metas Mensal Nova - fim: '+time())

			cHtml := oObj:cMESMETARESULT

		endif

	elseif httpGet->tipo == 'VENDSMETA'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Vendedores das Metas por Regiao Nova - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:VENDSMETA( httpGet->codemp, httpGet->ano_atual )

			conout('==> WS Vendedores das Metas por Regiao Nova - fim: '+time())

			cHtml := oObj:cVENDSMETARESULT

		endif

	elseif httpGet->tipo == 'REGIAO001'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		cGrupo := ''
		if Type( 'httpget->grupo' ) <> "U"
			cGrupo := httpGet->grupo
		endif

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:REGIAO001( httpGet->regiao, httpGet->codemp, httpGet->ano_atual, httpGet->estado, httpGet->vendedor, httpGet->meses, cGrupo )

			cHtml := oObj:cREGIAO001RESULT

		endif

	elseif httpGet->tipo == 'REGIAO002'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:REGIAO002( httpGet->regiao, httpGet->codemp, httpGet->ano_atual, httpGet->estado, httpGet->vendedor, httpGet->meses, httpGet->grupo )

			cHtml := oObj:cREGIAO002RESULT

		endif

	elseif httpGet->tipo == 'DASHPRO'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:DASHPRO( httpGet->regiao, httpGet->codemp, httpGet->ano_atual, httpGet->estado, httpGet->vendedor, httpGet->meses, httpGet->grupo )

			cHtml := oObj:cDASHPRORESULT

		endif

	elseif httpPost->tipo == 'pcart_excel'

		httpSession->cRet_excel := ''+;
			'<table style="border-collapse: collapse; border-top: 2px solid #000000; border-bottom: 2px solid #000000; border-left: 2px solid #000000;border-right: 2px solid #000000; font-size:13px; font-family:arial;"  width="100%" cellspacing="0" cellpadding="4" >'+;
			'<tr style="font-weight:bold;">'+;
			'<td colspan="11" align="center" style="font-family: Helvetica, Arial ,Sans-Serif; font-size:16px;">'+httpPost->titulo+'</td>'+;
			'</tr>'+;
			'<tr style="font-weight:bold;">'+;
			'<td align="center" style="background-color: #3892d3;color: #ffffff;">FILIAL</td>'+;
			'<td align="center" style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">EMISSAO</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">ORIGEM</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">PEDIDO</td>'+;
			'<td align="center" style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">ENTREGA</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">CLIENTE</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">UF</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">VEND.1</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">VEND.2</td>'+;
			'<td align="right" style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">VALOR</td>'+;
			'<td style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">SITUACAO</td></tr>'

		linha := separa(httpPost->corpo, '|', .T.)
		For xIte := 1 To len(linha)
			aPeds := separa(alltrim(linha[xIte]), ';', .T.)
			//conout(len(aPeds))
			if !empty(len(aPeds))
				httpSession->cRet_excel += '<tr>'
				httpSession->cRet_excel += '<td align="center" style="border: 1px dotted black;">'+chr(160)+aPeds[1]+'</td>'
				httpSession->cRet_excel += '<td align="center" style="border: 1px dotted black;">'+chr(160)+aPeds[2]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[11]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[3]+'</td>'
				httpSession->cRet_excel += '<td align="center" style="border: 1px dotted black;">'+chr(160)+aPeds[4]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[5]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[6]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[7]+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[8]+'</td>'
				httpSession->cRet_excel += '<td align="right" style="border: 1px dotted black;">'+transform(val(aPeds[9]), '@E 999,999,999.99')+'</td>'
				httpSession->cRet_excel += '<td style="border: 1px dotted black;">'+chr(160)+aPeds[10]+'</td>'
				httpSession->cRet_excel += '</tr>'
			endif
		Next

		httpSession->cRet_excel += '<tr>'+;
			'<td colspan="11" align="center" style="background-color: #3892d3;color: #ffffff;border-right: 2px solid #000000;"><b>Desenvolvido por Sensus Tecnologia</b></td>'+;
			'</tr>'+;
			'</table>'

		httpSession->cNome_excel := httpPost->nome

		cHtml := '{sucess: true}'

	elseif httpPost->tipo == 'poper_excel'

		httpSession->cRet_excel := ''+;
			'<table style="border-collapse: collapse; border-top: 2px solid #000000; border-bottom: 2px solid #000000; border-left: 2px solid #000000;border-right: 2px solid #000000; font-size:13px; font-family:arial;"  width="100%" cellspacing="0" cellpadding="4" >'+;
			'<tr style="font-weight:bold;">'+;
			'<td colspan="2" align="center" style="font-family: Helvetica, Arial ,Sans-Serif; font-size:16px;">'+httpPost->titulo+'</td>'+;
			'</tr>'+;
			'<tr style="font-weight:bold;">'+;
			'<td align="center" style="background-color: #3892d3;color: #ffffff;">OPERADOR/VENDEDOR</td>'+;
			'<td align="right" style="background-color: #3892d3;color: #ffffff;border-left: 1px dotted #ffffff;">VALOR</td></tr>'

		linha := separa(httpPost->corpo, '|', .T.)
		For xIte := 1 To len(linha)
			aPeds := separa(alltrim(linha[xIte]), ';', .T.)
			//conout(len(aPeds))
			if !empty(len(aPeds))
				httpSession->cRet_excel += '<tr>'
				httpSession->cRet_excel += '<td align="center" style="border: 1px dotted black;">'+chr(160)+aPeds[1]+'</td>'
				httpSession->cRet_excel += '<td align="right" style="border: 1px dotted black;">'+transform(val(aPeds[2]), '@E 999,999,999.99')+'</td>'
				httpSession->cRet_excel += '</tr>'
			endif
		Next

		httpSession->cRet_excel += '<tr>'+;
			'<td colspan="2" align="center" style="background-color: #3892d3;color: #ffffff;border-right: 2px solid #000000;"><b>Desenvolvido por Sensus Tecnologia</b></td>'+;
			'</tr>'+;
			'</table>'

		httpSession->cNome_excel := httpPost->nome

		cHtml := '{sucess: true}'

	elseif httpGet->tipo == 'show_excel'

		HttpCTType("application/x-msexcel")
		HttpCTDisp('attachment; filename="'+httpSession->cNome_excel+'.xls"')
		HttpSend(httpSession->cRet_excel)

		cHtml := ''


	elseif httpGet->tipo == 'METAFATRELPED'

		oObj  := WSC2SRVGESTAO():NEW()
		If oObj:_HEADOUT == nil
			oObj:_HEADOUT := {}
		Endif

		aAdd(oObj:_HEADOUT, "Authorization: Basic " + Encode64( xUsrAdm + ":" + xPssAdm ))

		conout('==> WS Meta de Faturamento - Relacao de Pedidos - inicio: '+time())
		WsChgUrl(@oObj,"C2SRVGESTAO.apw")
		If oObj:METAFATRELPED( httpGet->codemp, ctod(httpGet->dti), ctod(httpGet->dtf), httpGet->_filtrorel, httpCookies->sessionid)

			conout('==> WS Meta de Faturamento - Relacao de Pedidos - fim: '+time())

			cHtml := oObj:cMETAFATRELPEDRESULT

		endif

	endif

	WEB EXTENDED END
//conout(chtml)
Return cHtml


//Verifica se esta logado ou nao
User Function checklog()

	Local cHtml  := ""

	WEB EXTENDED INIT cHtml

	conout('========> ',httpSession->userId)

	if httpSession->userId == NIL .or. empty(httpSession->userId)
		cHtml := '{logado: "NAO"}'
	else
		cHtml := '{logado: "SIM"}'
	endif

	WEB EXTENDED END

Return cHtml

User Function weblogin()

	Local cHtml  := "", oObj

	WEB EXTENDED INIT cHtml


	oObj  := WSC2SRVGESTAO():NEW()

	WsChgUrl(@oObj,"C2SRVGESTAO.apw")
	If oObj:CHECKLOG( httpPost->login_user, httpPost->login_pass )
		cRet := oObj:cCHECKLOGRESULT

		if alltrim(cRet) == '.T.'
			cHtml :=  '{success: true, msg: ""}'
			httpSession->userId := 'logado'
		else
			cHtml :=  '{success: false, msg: "Usuario ou senha invalidos!"}'
			httpSession->userId := NIL
		endif

	endif


	WEB EXTENDED END

Return cHtml
