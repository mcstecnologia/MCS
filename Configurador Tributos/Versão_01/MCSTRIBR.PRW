#Include 'Protheus.CH'

/*/{Protheus.doc} MCSTRIBR
Emite relatÃƒÂ³rio com participantes ou produtos fora de perfis
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@return variant, return_description
/*/
User Function MCSTRIBR()

    Local aRet := {}

    aRet := Params("MCSTRIBR")

    If Len(aRet)>0
        FwMsgRun(,{ |oSay| fGeraXls(oSay,aRet[1]) }, "Aguarde...", "Gerando planilha com as informações solicitadas.")
    EndIf

Return

/*/{Protheus.doc} fGeraXls
Faz a consulta e gera o xml
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@param oSay, object, param_description
@param nPerfil, variant, param_description
@return variant, return_description
/*/
Static Function fGeraXls(oSay,nPerfil)

    Local oFWMsExcel
	Local oExcel
	Local xArquivo      := "C:\Temp\relacao.xml"
	Local xWorkSheet    := "Não relacionados com perfis - FISA170"
	Local xTitulo       := "Não relacionados com perfis - FISA170"
    Local xAlias        := GetNextAlias()
    Local xQuery        := ""

    Do Case 
        Case nPerfil == 1
            xQuery := "SELECT A1_FILIAL AS FILIAL, A1_COD AS COD, A1_LOJA AS LOJA, A1_NOME AS NOME " + chr(13)
            xQuery += "FROM " +RetSqlName("SA1")+ " A1 " + chr(13)
            xQuery += "WHERE A1.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F22")+ " F22 " + chr(13) 
            xQuery += "WHERE F22.F22_CLIFOR = A1.A1_COD " + chr(13)
            xQuery += "AND F22.F22_LOJA   = A1.A1_LOJA " + chr(13)
            xQuery += "AND F22.F22_TPPART = '2' " + chr(13)
            xQuery += "AND F22.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
        Case nPerfil == 2
            xQuery := "SELECT A2_FILIAL AS FILIAL, A2_COD AS COD, A2_LOJA AS LOJA, A2_NOME AS NOME " + chr(13)
            xQuery += "FROM " +RetSqlName("SA2")+ " A2 " + chr(13)
            xQuery += "WHERE A2.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F22")+ " F22 " + chr(13) 
            xQuery += "WHERE F22.F22_CLIFOR = A2.A2_COD " + chr(13)
            xQuery += "AND F22.F22_TPPART = '1' " + chr(13)
            xQuery += "AND F22.F22_LOJA   = A2.A2_LOJA " + chr(13)
            xQuery += "AND F22.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
        Otherwise
            xQuery := "SELECT B1_FILIAL AS FILIAL, B1_COD AS COD, B1_DESC AS NOME " + chr(13)
            xQuery += "FROM " +RetSqlName("SB1")+ " B1 " + chr(13)
            xQuery += "WHERE B1.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += "AND NOT EXISTS ( " + chr(13)
            xQuery += "SELECT 1 " + chr(13)
            xQuery += "FROM " +RetSqlName("F24")+ " F24 " + chr(13) 
            xQuery += "WHERE F24.F24_CDPROD = B1.B1_COD " + chr(13)
            xQuery += "AND F24.D_E_L_E_T_ = ' ' " + chr(13)
            xQuery += ")"
    EndCase


    MpSysOpenQuery(xQuery,xAlias)

    (xAlias)->(dbGoTop())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Instancia o objeto e cria o xml                                     ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (xAlias)->(!Eof())

        //oFWMsExcel := FWMSExcelXLSX():New()
        oFWMsExcel := FWMSExcel():New()
        
        oFWMsExcel:AddworkSheet(xWorkSheet)
        
        oFWMsExcel:AddTable(xWorkSheet, xTitulo)
        oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Filial", 1, 1, .F.)
        oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Código", 1, 1, .F.)
        If nPerfil <> 3
            oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Loja", 1, 1, .F.)
        EndIf
        oFWMsExcel:AddColumn(xWorkSheet, xTitulo, "Nome", 1, 1, .F.)

    Else 
        MsgAlert("Não foram localizados dados para exportar!")
        Return 
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Percorre os elementos                                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !((xAlias)->(EoF()))
	
        If nPerfil <> 3
            oFWMsExcel:AddRow(xWorkSheet, xTitulo, {;
                    (xAlias)->FILIAL,;
                    (xAlias)->COD,;
                    (xAlias)->LOJA,;
                    (xAlias)->NOME;
            })
        Else 
            oFWMsExcel:AddRow(xWorkSheet, xTitulo, {;
                    (xAlias)->FILIAL,;
                    (xAlias)->COD,;
                    (xAlias)->NOME;
            })
        EndIf
		
		(xAlias)->(DbSkip())

	EndDo

    (xAlias)->(DbCloseArea())
    
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(xArquivo)
        
    oExcel := MsExcel():New()
    oExcel:WorkBooks:Open(xArquivo)
    oExcel:SetVisible(.T.)
    oExcel:Destroy()

    MsgInfo("Processo de geração do arquivo encerrado com sucesso!")

Return

/*/{Protheus.doc} Params
Monta dela de parÃƒÂ¢metros
@type function
@version  
@author MCS Tecnologia
@since 1/15/2026
@param xNomPer, variant, param_description
@return variant, return_description
/*/
Static Function Params(xNomPer)

    Local aParams  := {}
    Local aRet     := {}
    Local aRetPar  := {}

    aadd(aParams, { 2, "Qual perfil?"      , 2 , {"Cliente", "Fornecedor","Produto"}           , 100, ".T.", .T.})

    If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,xNomPer,.T.,.T.)
        aRetPar := AjRetPar(aRet,aParams)
    Endif

Return(aClone(aRetPar))

Static Function AjRetPar(aRet,aParams)

    Local xInc := 0

    If ValType(aRet) == "A" .and. Len(aRet) == Len(aParams)
    For xInc := 1 To Len(aParams)
        If aParams[xInc,1] == 1
            aRet[xInc] := aRet[xInc]
        ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
            aRet[xInc] := aScan(aParams[xInc,4], {|x| Alltrim(x) == aRet[xInc]})
        ElseIf aParams[xInc,1] == 2 .and. ValType(aRet[xInc]) == "C"
            aRet[xInc] := aRet[xInc]
        Endif
    Next xInc
    Endif

Return(aClone(aRet))
