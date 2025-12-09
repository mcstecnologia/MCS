#Include 'Protheus.CH' 

/*/{Protheus.doc} MCS0001
Replicado de regras fiscais
@type function
@version  
@author MCS Consultoria
@since 11/13/2025
@return variant, return_description
/*/
User Function MCS0001()

    Local oButton1
    Local oButton2
    Local oComboBo1
    Local nComboBo1 := 1
    Local oGroup1
    Local oSay1
    Local oSay2
    Static oDlg

    DEFINE MSDIALOG oDlg TITLE "Replicador Regras Fiscais - FISA170" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL

        @ 010, 012 GROUP oGroup1 TO 182, 389 PROMPT "Replicador Regras Fiscais - FISA170" OF oDlg COLOR 0, 16777215 PIXEL
        @ 070, 047 SAY oSay1 PROMPT "Selecione o registros a ser copiado:" SIZE 088, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 028, 047 SAY oSay2 PROMPT "Este programa, tem como objetivo executar a copia de regras fiscais do FISA170 para outras filiais da empresa" SIZE 300, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 123, 049 BUTTON oButton1 PROMPT "Continuar" SIZE 037, 012 ACTION FwMsgRun(,{ |oSay| fTabTemp(oSay,nComboBo1) }, "Aguarde...", "Gerando tabela temporária.")  OF oDlg PIXEL
        @ 123, 104 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 ACTION oDlg:End() OF oDlg PIXEL
        @ 070, 144 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1-Regras Base","2-Regras Alíquotas","3-Regras Fiscais","4-Fórmulas"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/{Protheus.doc} fTabTemp
Cria a tabela temporária
@type function
@version  
@author MCS Tecnologia
@since 11/14/2025
@param nCombo, numeric, param_description
@return variant, return_description
/*/
Static Function fTabTemp(oSay, nCombo)

    Local oTempTable := Nil
    Local aArea      := GetArea()
    Local xAliasTemp := GetNextAlias()
    Local aFields    := {}
    Local aSelect    := {}
    Local x          := 0
    Local xQuery     := ""

    MsgInfo("Marque ná proxima tela, qual a filial que deseja realizar a cópia")

    aSelect := AdmGetFil()

    If Len(aSelect) == 0 
        MsgAlert("Não foram marcadas filiais")
        Return
    EndIf

    	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(xAliasTemp)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos da Tabela Temporária                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nCombo == 1
        aadd(aFields,{"F27_FILIAL"  ,"C",TamSx3("F27_FILIAL")[1],0})
        aadd(aFields,{"F27_CODIGO"  ,"C",TamSx3("F27_CODIGO")[1],0})
        aadd(aFields,{"F27_DESC"    ,"C",TamSx3("F27_DESC")[1]  ,0})
        aadd(aFields,{"F27_VALORI"  ,"C",TamSx3("F27_VALORI")[1],0})
        aadd(aFields,{"F27_DESCON"  ,"C",TamSx3("F27_DESCON")[1],0})
        aadd(aFields,{"F27_FRETE"   ,"C",TamSx3("F27_FRETE")[1] ,0})
        aadd(aFields,{"F27_SEGURO"  ,"C",TamSx3("F27_SEGURO")[1],0})
        aadd(aFields,{"F27_DESPE"   ,"C",TamSx3("F27_DESPE")[1] ,0})
        aadd(aFields,{"F27_ICMDES"  ,"C",TamSx3("F27_ICMDES")[1],0})
        aadd(aFields,{"F27_ICMRET"  ,"C",TamSx3("F27_ICMRET")[1],0})
        aadd(aFields,{"F27_REDBAS"  ,"C",TamSx3("F27_REDBAS")[1],0})
        aadd(aFields,{"F27_TPRED"   ,"C",TamSx3("F27_TPRED")[1] ,0})
        aadd(aFields,{"F27_UM"      ,"C",TamSx3("F27_UM")[1]    ,0})
        aadd(aFields,{"F27_ALTERA"  ,"C",TamSx3("F27_ALTERA")[1],0})
        aadd(aFields,{"F27_CHVMD5"  ,"C",TamSx3("F27_CHVMD5")[1],0})
    EndIf

	oTempTable:SetFields( aFields )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criação da Tabela Temporária                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTempTable:Create()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama rotina para buscar os registros                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xAlias := fMCS0001(nCombo,aSelect)

    For x := 1 to Len(aSelect)
  
        While !(xAlias)->(Eof()) 

            xQuery := "	INSERT INTO "+oTempTable:GetRealName()+" (F27_FILIAL,F27_CODIGO,F27_DESC ,F27_VALORI,F27_DESCON,F27_FRETE,F27_SEGURO,F27_DESPE,F27_ICMDES,F27_ICMRET,F27_REDBAS,F27_TPRED,F27_UM,F27_ALTERA,F27_CHVMD5) VALUES "
            xQuery += "('"+AllTrim(aSelect[x])+"', '"+(xAlias)->F27_CODIGO+"', '"+AllTrim((xAlias)->F27_DESC)+"', '"+(xAlias)->F27_VALORI+"','"+(xAlias)->F27_DESCON+"','"+(xAlias)->F27_FRETE+"','"+(xAlias)->F27_SEGURO+"','"+(xAlias)->F27_DESPE+"','"+(xAlias)->F27_ICMDES+"','"+(xAlias)->F27_ICMRET+"','"+AllTrim(Str((xAlias)->F27_REDBAS))+"','"+(xAlias)->F27_TPRED+"','"+(xAlias)->F27_UM+"','"+(xAlias)->F27_ALTERA+"','"+(xAlias)->F27_CHVMD5+"')"
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Executa a Query                                                  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If TCSqlExec(xQuery) < 0
			    MsgStop("Problemas na Execução da Query","Erro")
			Return(.F.)
		Endif
        
        (xAlias)->(dbSkip())
        EndDo

    Next x

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena o nome da tabela Temporária e o Alias                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xTbl := oTempTable:GetRealName()
	xTmp := oTempTable:GetAlias()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama função para gravar os registros selecionados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    lRet := fGravaF(aSelect,xTmp)

    If lRet 
        MsgInfo("Processo finalizado sem erros!")
    Else 
        MsgAlert("Erro no processo de repricação, verifique!")
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deletando tabela                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oTempTable:Delete()

    RestArea(aArea)
    (xAlias)->(dbCloseArea())

Return

/*/{Protheus.doc} fMCS0001
Query que busca os registros a serem inseridos na tabela temporária
@type function
@version  
@author MCS Tecnologia
@since 11/14/2025
@param nCombo, numeric, param_description
@return variant, return_description
/*/
Static Function fMCS0001(nCombo,aSelect)

    Local xAlias    := GetNextAlias()
    Local xQuery    := ""

    If nCombo == 1 

        xQuery := "SELECT F27_FILIAL,F27_CODIGO,F27_DESC ,F27_VALORI,F27_DESCON,F27_FRETE,F27_SEGURO,F27_DESPE,F27_ICMDES,F27_ICMRET,F27_REDBAS,F27_TPRED,F27_UM,F27_ALTERA,F27_CHVMD5 FROM "+ RetSqlName("F27")+ " " + chr(13)
        xQuery += "WHERE F27_FILIAL = '" + aSelect[1] + "' "+ chr(13)
        xQuery += "AND D_E_L_E_T_ = ' ' "

        MpSysOpenQuery(xQuery,xAlias)
    
    /*ElseIf == 2

    ElseIf == 3

    Else */
    EndIf

Return xAlias

/*/{Protheus.doc} fGravaF
Grava os registros na F27
@type function
@version  
@author MCS Tecnologia
@since 11/14/2025
@param aSelect, array, param_description
@param xAliasTemp, variant, param_description
@return variant, return_description
/*/
Static Function fGravaF(aSelect,xAliasTemp)

    Local oModel as object
    Local aArea     := F27->(GetArea())
    Local cChvMD5   := ""
    Local lRet      := .F.
    Local xId       := ""

    (xAliasTemp)->(dbGoTop())

    While !(xAliasTemp)->(Eof())

        oModel := FwLoadModel("FISA161") 

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Apenas na alteração                                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oModel:SetOperation(3)
        oModel:Activate() // ativo o modelo

        xId := FWUUID("F27")

        //oModel:GetModel("FISA161"):AddLine()
        oModel:SetValue("FISA161", "F27_FILIAL", FwxFilial("F27"))
        //oModel:SetValue("FISA161", "F27_ID"    , xId)
        oModel:SetValue("FISA161", "F27_CODIGO", (xAliasTemp)->F27_CODIGO)
        oModel:SetValue("FISA161", "F27_DESC"  , (xAliasTemp)->F27_DESC)
        oModel:SetValue("FISA161", "F27_VALORI", (xAliasTemp)->F27_VALORI)
        oModel:SetValue("FISA161", "F27_DESCON", (xAliasTemp)->F27_DESCON)
        oModel:SetValue("FISA161", "F27_FRETE", (xAliasTemp)->F27_FRETE)
        oModel:SetValue("FISA161", "F27_SEGURO", (xAliasTemp)->F27_SEGURO)
        oModel:SetValue("FISA161", "F27_DESPE"  , (xAliasTemp)->F27_DESPE)
        oModel:SetValue("FISA161", "F27_ICMDES", (xAliasTemp)->F27_ICMDES)
        oModel:SetValue("FISA161", "F27_ICMRET", (xAliasTemp)->F27_ICMRET)
        oModel:SetValue("FISA161", "F27_REDBAS", Val((xAliasTemp)->F27_REDBAS))
        oModel:SetValue("FISA161", "F27_TPRED", (xAliasTemp)->F27_TPRED)
        //oModel:SetValue("FISA161", "F27_UM", (xAliasTemp)->F27_UM)
        //oModel:SetValue("FISA161", "F27_ALTERA", '2')

        /*RecLock("F27",.T.)
            F27->F27_FILIAL	    := (xAliasTemp)->F27_FILIAL
            F27->F27_ID		    := xId
            F27->F27_CODIGO	    := (xAliasTemp)->F27_CODIGO
            F27->F27_DESC  	    := (xAliasTemp)->F27_DESC
            F27->F27_VALORI	    := (xAliasTemp)->F27_VALORI
            F27->F27_DESCON 	:= (xAliasTemp)->F27_DESCON
            F27->F27_FRETE  	:= (xAliasTemp)->F27_FRETE
            F27->F27_SEGURO	    := (xAliasTemp)->F27_SEGURO
            F27->F27_DESPE 	    := (xAliasTemp)->F27_DESPE
            F27->F27_ICMDES	    := (xAliasTemp)->F27_ICMDES
            F27->F27_ICMRET	    := (xAliasTemp)->F27_ICMRET
            F27->F27_REDBAS	    := Val((xAliasTemp)->F27_REDBAS)
            F27->F27_TPRED 	    := (xAliasTemp)->F27_TPRED
            F27->F27_UM    	    := (xAliasTemp)->F27_UM
            F27->F27_CHVMD5     := GetChvMd5()
            F27->F27_ALTERA		:= "2" //Indica que não foi alterado  */  

        /*If ( !Empty(cChvMD5) )
            F27->F27_CHVMD5 := cChvMD5
        EndIf*/
        If oModel:VldData()
            oModel:CommitData()
            lRet := .T.
        Else 
            VarInfo("",oModel:GetErrorMessage())
            lRet := .F.
        EndIf 
        oModel:DeActivate()

        //MsUnLock()

        (xAliasTemp)->(dbSkip())

        

        //GravaCIN('1', '1', (xAliasTemp)->F27_CODIGO, xId, (xAliasTemp)->F27_DESC, cFormula, '0', cFormUsuar, cOldIdReg, lVersiona)

    EndDo

    RestArea(aArea)



Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GetChvMd5
Função para atualização do campo MD5.

@author Juliano Fernandes
@since 15/04/2024
@version P12.1.2310
/*/
//-------------------------------------------------------------------
static function GetChvMd5()

    local oModel := Nil
    local cChave := ''
    local cPrefixo := 'CONFITRIB-' 
    local cChvMd5 := ''
    local lIsClassification := FWIsInCallStack('IntegraRegras')

    oModel := FwLoadModel("FISA161") 

    if ( lIsClassification )
        cPrefixo := 'CLASSTRIB-'
    endif

    cChave := xFisSYard(oModel:GetValue('FORMULBAS', 'CIN_FORMUL'))

    cChvMd5 := cPrefixo + Md5(cChave)

return cChvMd5
