#Include 'Protheus.CH'

/*/{Protheus.doc} GRVSFX
Grava os dados na SFX, referente NFCom
@type function
@version  
@author MCS Tecnologia
@since 1/16/2026
@return variant, return_description
/*/
User Function GRVSFX(xDoc, xSerie, xFornece, xLoja)

    Local xQuery	:= ""
	Local xAlias := GetNextAlias()

	xQuery := "SELECT D1_FILIAL, D1_ITEM, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_EMISSAO, D1_DTDIGIT " + chr(13)
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
                SFX->FX_TPCLASS	:= "3"
                SFX->FX_COD		:= (xAlias)->D1_COD
                SFX->FX_TIPOREC	:= "0"
                SFX->FX_CLASCON	:= '99'
                SFX->FX_TIPSERV := '0'
                SFX->FX_GRPCLAS := '99'
			SFX->(MsUnlock())
		EndIf

		(xAlias)->(dbskip())
	EndDo

	(xAlias)->(dbCloseArea())


Return
