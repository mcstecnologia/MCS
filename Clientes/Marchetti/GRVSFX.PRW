#Include 'Protheus.CH'

/*/{Protheus.doc} GRVSFX
Grava os dados na SFX, referente NFCom
@type function
@version  
@author MCS Tecnologia
@since 30/04/2026
@return variant, return_description
/*/
User Function GRVSFX(xDoc, xSerie, xFornece, xLoja, nValBrut)

    Local xQuery	:= ""
	Local xAlias 	:= GetNextAlias()
	Local aAreaFX   := SFX->(GetArea())
	Local xClasCon	:= ""

	xClasCon := fBuscaCC5(nValBrut)

	xQuery := "SELECT D1_FILIAL, D1_ITEM, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_EMISSAO, D1_DTDIGIT, D1_TOTAL " + chr(13)
	xQuery += "FROM "+ RetSqlName("SD1") +" SD1 " + chr(13)
	xQuery += "WHERE D1_FILIAL = '"+ xFilial("SD1") +"' " + chr(13)
	xQuery += "AND D1_DOC = '"+ xDoc +"' " + chr(13)
	xQuery += "AND D1_SERIE = '"+ xSerie +"' " + chr(13)
    xQuery += "AND D1_FORNECE = '"+ xFornece +"' " + chr(13)
	xQuery += "AND D1_LOJA = '"+ xLoja +"' " + chr(13)
	xQuery += "AND SD1.D_E_L_E_T_ = ' ' "

    MpSysOpenQuery(xQuery, xAlias)

    (xAlias)->(dbGoTop())

	While (xAlias)->(!EOF())

		SFX->(dbSetOrder(1))

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Faz o seek para gravação do registro, caso não encontre                            
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !SFX->(msSeek(xFilial("SFX")+'E'+(xAlias)->D1_SERIE+(xAlias)->D1_DOC+(xAlias)->D1_FORNECE+(xAlias)->D1_LOJA))
			lInc := .T.
			RecLock("SFX", .T.)
                SFX->FX_FILIAL	:= (xAlias)->D1_FILIAL
                SFX->FX_ITEM	:= (xAlias)->D1_ITEM
                SFX->FX_TIPOMOV	:= 'E'
                SFX->FX_DOC		:= (xAlias)->D1_DOC
                SFX->FX_SERIE	:= (xAlias)->D1_SERIE
                SFX->FX_ESPECIE	:= "NFCOM"
                SFX->FX_CLIFOR	:= (xAlias)->D1_FORNECE
                SFX->FX_LOJA	:= (xAlias)->D1_LOJA	
                SFX->FX_COD		:= (xAlias)->D1_COD
                SFX->FX_TIPOREC	:= "0"
                SFX->FX_TIPSERV := '1'
                SFX->FX_GRPCLAS := '02'
				SFX->FX_VALTERC := SD1->D1_TOTAL
				SFX->FX_CLASSIF := '02'
				SFX->FX_CLASCON := xClasCon
			SFX->(MsUnlock())
		EndIf

		(xAlias)->(dbskip())
	EndDo

	(xAlias)->(dbCloseArea())

	FwRestArea(aAreaFX)

Return

/*/{Protheus.doc} fBuscaCC5
Retorna o  FX_CLASCON 
@type function
@version  
@author rodri
@since 4/30/2026
@param nVal, numeric, param_description
@return variant, return_description
/*/
Static Function fBuscaCC5(nVal)

	Local xCod      := ""
	Local aRegs     := {}
	Local nNext     := 0

	aAdd(aRegs,{'10',0,50})                 
	aAdd(aRegs,{'11',50.01,100})      
	aAdd(aRegs,{'12',100.01,200})     
	aAdd(aRegs,{'13',200.01,300})     
	aAdd(aRegs,{'14',300.01,400})     
	aAdd(aRegs,{'15',400.01,500})     
	aAdd(aRegs,{'16',500.01,1000})   
	aAdd(aRegs,{'17',1000.01,99999999}) 

	For nNext := 1 To Len(aRegs)
		If nVal >= aRegs[nNext][2] .And. nVal <= aRegs[nNext][3]
			xCod := aRegs[nNext][1]
			Exit
		EndIf
	Next x

Return xCod
