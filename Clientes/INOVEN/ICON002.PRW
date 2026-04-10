#Include 'Protheus.CH'

/*/{Protheus.doc} ICON002
Executa o processo para ajuste do arquivo txt
@type function
@version  
@author MCS Tecnologia
@since 2/27/2026
@return variant, return_description
/*/
User Function ICON002()

    Local aSays        := {}
    Local aButtons     := {}
    Local lOk          := .F.
    Local oSay
    Local aRet         := {}
    Local xUser        := SuperGetMV("IN_USRADM",.F.,"Administrador")

    lCheckUser = .F.
    lAllEmp = .T.
    lOnlySelect= .T.
    
    aAdd(aSays, "Esse programa tem como objetivo ajustar o arquivo para realizar a contabilização ")
    aAdd(aSays, "txt da folha de pagamento ")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Apenas administrador tem acesso aos parâmetros                   ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    If UsrRetName(__cUserId) $ xUser
        aAdd(aButtons, { 5, .T., {|| U_MCSPARAM()} } )
    EndIf
    aAdd(aButtons, { 5, .T., {|| aRet := Params()} } )
    aAdd(aButtons, { 1, .T., {|| lOk := .T., FechaBatch() }} )
    aAdd(aButtons, { 2, .T., {|| lOk := .F., FechaBatch() }} )
    
    FormBatch("Ajusta Arquivo", aSays, aButtons)
    
    If lOk
        FWMsgRun(, {|oSay| fLerArquivo(oSay,aRet) }, "Processando", "Lendo arquivo para ajuste",.T.,.T.)
    EndIf

Return

/*/{Protheus.doc} fLerArquivo
description
@type function
@version  
@author MCS Tecnologia
@since 2/27/2026
@param oSay, object, param_description
@param aRet, array, param_description
@return variant, return_description
/*/
Static Function fLerArquivo(oSay,aRet)

    Local aDados    := {}
    Local nhandle   := 0
    Local nLinha    := 0
    Local cLinha    := ""
    Local xMsg      := ""

    If Empty(aRet[4])
        MsgStop("Não foi informado o arquivo para importação!", "Verifique")
    Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        //? Abrindo o arquivo                                        ?
        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        nHandle := FT_FUse(aRet[4])
        If nHandle = -1
            MsgStop("Erro ao abrir o arquivo!", "Verifique")
        Else
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
            //? Posiciona na primeira linha                                      ?
            //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
            FT_FGoTop()
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
            //? Retorna o número de linhas                                       ?
            //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
            nLinha := FT_FlastRec()
            If nLinha == 0
                MsgStop("Não foram encontrados registros/linhas no arquivo", "Verifique")
            Else
                While !FT_FEOF()
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    //lendo e retornando a linha
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    cLinha := FT_FREADLN()
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    //Faz o ajuste no arquivo, colocando os LPS, ajustando a data e as contas
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    If Substr(cLinha,186,186) == 'D'
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        //Faz a busca do de/para
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        xConta := fBuscaConta(SubStr(cLinha,55,6))
                        If Empty(xConta)
                            xCnta := Val(SubStr(cLinha,55,6))
                            xCnta := Str(xCnta)
                            FWAlertError("Não foi localizada a conta " + AllTrim(xCnta) + " no De/Para, verifique os parâmetros: IN_DEPAR01/IN_DEPAR02/IN_DEPAR03/IN_DEPAR04/IN_DEPAR05 - o processo será encerrado ","Atenção")
                            Return 
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        //Verifica se existe conta não localizada na CT1
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        ElseIf SubStr(xConta,1,14) == "NAO LOCALIZADA"
                            xMsg += "Conta não localizada no Protheus: " + xConta + chr(13)
                        EndIf
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        //Adiciona no array os registros corrigidos, juntamente com acerto dos caracteres especiais e formatação da data
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        aadd(aDados,aRet[1]+"00"+StrTran(SubStr(cLinha,7,44), "/", "")+xConta+fLimpaCaract(SubStr(cLInha,61,110)+"00"+StrTran(SubStr(cLinha,172,16),",","")))
                    Else 
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        //Faz a busca do de/para
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        xConta := fBuscaConta(SubStr(cLinha,55,6))
                        If Empty(xConta)
                            xCnta := Val(SubStr(cLinha,55,6))
                            xCnta := Str(xCnta)
                            FWAlertError("Não foi localizada a conta " + AllTrim(xCnta) + " no De/Para, verifique os parâmetros: IN_DEPAR01/IN_DEPAR02/IN_DEPAR03/IN_DEPAR04/IN_DEPAR05 - o processo será encerrado ","Atenção")
                            Return 
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        //Verifica se existe conta não localizada na CT1
                        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                        ElseIf SubStr(xConta,1,14) == "NAO LOCALIZADA"
                            xMsg += "Conta não localizada no Protheus: " + xConta + chr(13)
                        EndIf
                        aadd(aDados,aRet[2]+"00"+StrTran(SubStr(cLinha,7,44), "/", "")+xConta+fLimpaCaract(SubStr(cLInha,61,110)+"00"+StrTran(SubStr(cLinha,172,16),",","")))
                    EndIf
                    FT_FSKIP()
                EndDo                         
            EndIf
        EndIF

        FT_FUse()

    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Caso tenha contas não cadastradas, exibe alerta                  ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    If !Empty(xMsg)
        FWAlertError(xMsg, "Atenção")
        If FWAlertYesNo("Deseja gerar o arquivo com as contas não localizadas?", "Continuar (Sim/Não)?")
            fGeraArq(aDados,aRet[4],aRet)
        Else
            Alert("Processo Finalizado")
        EndIf
    Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        //? Chama rotina para ajuste do arquivo                             ?
        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        fGeraArq(aDados,aRet[4],aRet)
    EndIf

Return

    /*/{Protheus.doc} 
Gera o novo arquivo
@type function
@version  
@author MCS Tecnologia
@since 3/5/2024
@return variant, return_description
/*/
Static Function fGeraArq(aDados,cArq,aRet)

    Local cTime     
    Local cData     
    Local xPasta     
    Local xArquivo   
    Local cMascara  := "Todos os arquivos|."
    Local cTitulo   := "Escolha o local para salvar o arquivo de contabilização"
    Local nPathEr   
    Local cDirini   := "C:\"
    Local nMascpad  := 0
    Local x         := 0
    Local nOpcoes   := GETF_LOCALHARD
    Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
    Local targetDir
    Local lSalvar   := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Janela para salvar o arquivo                                        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    targetDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)

    cTime     := Replace(Time(),":","")
    cData     := dtos(dDataBase)
    xPasta    := "\"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criando arquivo                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    xArquivo := "Contabilizacao"+"_"+cData+"_"+cTime+".txt"
    nPathEr := FCreate(targetDir+Upper(xArquivo))

    If nPathEr < 0
		conout("Erro durante criação do arquivo.")
	Else 
        For x := 1 to Len(aDados)
            FWrite(nPathEr, aDados[x] + CRLF)
        Next x
    EndIf
    FClose(nPathEr) 
    
    _ArqWeb := "\"+xArquivo

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se o agent local não estã ativo                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    If GetRemoteType() = 5 //-- WebAgent não está atuvo
        _nRet   := CpyS2TW(_ArqWeb, .T.)
        FWAlertSuccess("Agente local não habilitado no seu navegador, habilite o agent local", "Contabilização TXT")
    Else 
        _nRet   := CpyS2T(_ArqWeb, targetDir)
        FWAlertSuccess("Arquivo(s) copiado(s) para " + targetDir, "Contabilização TXT")
    EndIf

    If FWAlertYesNo("Deseja realizar a importação do arquivo?", "Continuar (Sim/Não)?")
        CTBA500()
    Else
        Alert("Processo Finalizado")
    EndIf
    
Return

/*/{Protheus.doc} Params
Tela de parâmetros
@type function
@version  
@author MCS Tecnologia
@since 3/2/2026
@return variant, return_description
/*/
Static Function Params()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Declaração de Variáveis
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local aParams  := {}
    Local aRet     := {}
    Local aRetPar  := {}

    aadd(aParams ,{ 1, "LP/Seq Débito"              , Space(6)	    , "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aadd(aParams ,{ 1, "LP/Seq Crédito"             , Space(6)	    , "@!"                , '.T.','   '   , '.T.', 40, .F. })
    aAdd(aParams ,{ 9,"Buscar arquivo para ajuste"  ,200, 40,.T.})      
    aAdd(aParams ,{ 6,"Selecione o arquivo:"        ,Space(100)     ,"","","",70,.F.,"Todos os arquivos (*.txt) |*.txt"})
    If ParamBox(aParams, "Parâmetros", @aRet,,,.T.,,,,"Parâmetros para Ajuste do Arquivo",.T.,.T.)
        aRetPar := AjRetPar(aRet,aParams)
    Endif

Return(aClone(aRetPar))

/*/{Protheus.doc} AjRetPar
Ajusta os Parâmetros                    
@type function
@version  
@author MCS Tecnologia
@since 1/27/2026
@param aRet, array, param_description
@param aParams, array, param_description
@return variant, return_description
/*/
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

/*/{Protheus.doc} fBuscaConta
Busca a conta contábil dentro dos parâmetros
@type function
@version  
@author MCS Tecnologia
@since 3/4/2026
@param xCnta, variant, param_description
@return variant, return_description
/*/
Static Function fBuscaConta(xCnta)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Parâmetros com as contas de DE/PARA para ajuste do arquivo
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local xPar1     := SuperGetMV("IN_DEPAR01", .F., "4328#2107001005;")
    Local xPar2     := SuperGetMV("IN_DEPAR02", .F., "")
    Local xPar3     := SuperGetMV("IN_DEPAR03", .F., "")
    Local xPar4     := SuperGetMV("IN_DEPAR04", .F., "")
    Local xPar5     := SuperGetMV("IN_DEPAR05", .F., "")
    Local xPar6     := SuperGetMV("IN_DEPAR06", .F., "")
    Local nPos      := 0
    Local xConta    := ""
    Local aArea     := CT1->(GetArea())

    CT1->(dbSelectArea("CT1"))
    CT1->(dbSetOrder(1))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Ajustando os zeros a esqueda para a pesquisa
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xCnta := Val(xCnta)
    xCnta := AllTrim(Str(xCnta))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica e busca a conta contábil correta dentro dos parâmetros
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If xCnta $ xPar1
        nPos := At(xCnta, xPar1)
        If nPos > 0
            xConta := SubStr(xPar1,nPos+Len(xCnta)+1,10)
        EndIf
    ElseIf xCnta $ xPar2
        nPos := At(xCnta, xPar2)
        If nPos > 0
            xConta := SubStr(xPar2,nPos+Len(xCnta)+1,10)
        EndIf
    ElseIf xCnta $ xPar3
        nPos := At(xCnta, xPar3)
        If nPos > 0
            xConta := SubStr(xPar3,nPos+Len(xCnta)+1,10)
        EndIf
    ElseIf xCnta $ xPar4
        nPos := At(xCnta, xPar4)
        If nPos > 0
            xConta := SubStr(xPar4,nPos+Len(xCnta)+1,10)
        EndIf
    ElseIf xCnta $ xPar5
        nPos := At(xCnta, xPar5)
        If nPos > 0
            xConta := SubStr(xPar5,nPos+Len(xCnta)+1,10)
        EndIf
    ElseIf xCnta $ xPar6
        nPos := At(xCnta, xPar6)
        If nPos > 0
            xConta := SubStr(xPar6,nPos+Len(xCnta)+1,10)
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se a conta existe no Protheus
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(xConta)
        If !CT1->(dbSeek(xFilial("CT1")+xConta))
            xConta := "NAO LOCALIZADA - " + xConta
        EndIf
    EndIf

    RestArea(aArea)

Return xConta

/*/{Protheus.doc} fLimpaCaract
Remove caracteres especiais da string
@type function
@version  
@author Mcs Tecnologia
@since 3/10/2026
@param cTexto, character, param_description
@param lEndereco, logical, param_description
@return variant, return_description
/*/
Static Function fLimpaCaract(cTexto)
    Local cConteudo   := ""
    Default lEndereco := .F.
	Default cTexto	  := ""

	cConteudo := cTexto
     
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Retirando caracteres especiais para evitar problemas na geração do arquivo txt
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cConteudo := StrTran(cConteudo, 'ê','e')
    cConteudo := StrTran(cConteudo, 'á','a')
    cConteudo := StrTran(cConteudo, 'é','e')
    cConteudo := StrTran(cConteudo, 'ã','a')
    cConteudo := StrTran(cConteudo, 'ç','c')
    cConteudo := StrTran(cConteudo, 'õ','o')
    cConteudo := StrTran(cConteudo, 'ó','o')
    cConteudo := StrTran(cConteudo, 'í','i')

Return cConteudo

/*/{Protheus.doc} MCSPARAM
Tela com os parâmetros
@type function
@version  
@author MCS Tecnologia
@since 3/11/2026
@return variant, return_description
/*/
User Function MCSPARAM()

    Local oDlgPar
    Local oGrp2
    Local oBtnOk
    Local oBtnNo
    Local aBrwPar  := {}
    Local aBrwCop  := {}
    Local nOpc     := 0
    Local x        := 0
    Local nX       := 0
    Local lEdit    := .F.

    Private oBrwPar

    cAlias := U_MCSX6()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Percorro a query executada e armazeno no array ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    While !(cAlias)->(Eof())
        aadd(aBrwPar,{(cAlias)->X6_VAR,;
                     (cAlias)->X6_TIPO,;
                     (cAlias)->X6_DESCRIC+(cAlias)->X6_DESC1,;
                     (cAlias)->X6_CONTEUD})
        (cAlias)->(dbSkip())
    EndDo

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Faço um clone do array principal ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aBrwCop  := aClone(aBrwPar)

    DEFINE MSDIALOG oDlgPar TITLE "Listagem dos parâmetros DE/PARA" FROM 000, 000  TO 500, 900 PIXEL
	@ 220, 005 GROUP oGrp2 TO 247, 445 PROMPT "" OF oDlgPar PIXEL
	oBrwPar := TCBrowse():New(005,005,440,210,,,,oDlgPar,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrwPar:AddColumn(TCColumn():New("Parâmetro"   , {||     aBrwPar[oBrwPar:nAt,01]	}             ,,,,,40,.F.,lEdit,,,,.F.,))
    oBrwPar:AddColumn(TCColumn():New("Tipo"        , {||     aBrwPar[oBrwPar:nAt,02]	}             ,,,,,20,.F.,lEdit,,,,.F.,))
	oBrwPar:AddColumn(TCColumn():New("Descrição"   , {||     aBrwPar[oBrwPar:nAt,03]	}             ,,,,,100,.F.,lEdit,,,,.F.,))
	oBrwPar:AddColumn(TCColumn():New("Conteúdo"    , {||     aBrwPar[oBrwPar:nAt,04]	}             ,,,,,60,.F.,.T.,,,,.F.,))


	oBrwPar:SetArray(aBrwPar)
	oBrwPar:bWhen         := { || Len(aBrwPar) > 0 }
    oBrwPar:blDblClick    := { || editaTRB(aBrwPar)}
	DEFINE SBUTTON oBtnOk FROM 228, 350 TYPE 01 Action(nOpc := 1,oDlgPar:End()) OF oDlgPar ENABLE
	DEFINE SBUTTON oBtnNo FROM 228, 410 TYPE 02 Action(nOpc := 0,oDlgPar:End()) OF oDlgPar ENABLE
	ACTIVATE MSDIALOG oDlgPar CENTERED

    (cAlias)->(dbCloseArea())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se clicado no botão OK, inicia a verificação dos parâmetros alterados ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpc == 1
        For x := 1 to Len(aBrwPar)
            For nX := 1 to Len(aBrwCop)
                If AllTrim(aBrwPar[x][1]) == AllTrim(aBrwCop[x][1])
                    If AllTrim(aBrwPar[x][4]) <> AllTrim(aBrwCop[x][4])
                        PutMV(AllTrim(aBrwPar[x][1]),Upper(AllTrim(aBrwPar[x][4])))
                    EndIf
                EndIf
            Next nX
        Next x
        Alert("Registros Alterados")
    EndIf

Return

/*/{Protheus.doc} editaTRB
Edição da colina no Browse
@type function
@version  
@author MCS Tecnologia
@since 3/11/2026
@param _Dados, variant, param_description
@return variant, return_description
/*/
Static Function editaTRB(_Dados)

    Local nCol  := oBrwPar:Colpos

    If nCol == 4
        lEditCell(@_Dados,oBrwPar,"",oBrwPar:ColPos())
    EndIf

Return

/*/{Protheus.doc} SZSX6
Pesqusa os parâmetros
@type function
@version  
@author MCS Tecnologia
@since 3/11/2026
@return variant, return_description
/*/
User Function MCSX6()

    Local cQuery := ""
    Local cAlias := GetNextAlias()

    cQuery := "SELECT "
    cQuery += "     X6_VAR, "
    cQuery += "     X6_TIPO, "
    cQuery += "     X6_DESCRIC, "
    cQuery += "     X6_DESC1, "
    cQuery += "     X6_DESC2, "
    cQuery += "     X6_CONTEUD"
    cQuery += " FROM "
    cQuery +=       RetSqlName("SX6")
    cQuery += " WHERE"   
    cQuery += "     X6_FIL = '" + FwXFilial("SX6") + "' "
    cQuery += " AND "
    cQuery += "     X6_VAR like 'IN_DEPAR%'"
    cQuery += " AND "
    cQuery += "     D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY 
    cQuery += "         X6_VAR,"
    cQuery += "         X6_TIPO,"
    cQuery += "         X6_DESCRIC,"
    cQuery += "         X6_DESC1,"
    cQuery += "         X6_DESC2,"
    cQuery += "         X6_CONTEUD"

    MpSysOpenQuery(cQuery, cAlias)

    (cAlias)->(dbGoTop())

Return cAlias
