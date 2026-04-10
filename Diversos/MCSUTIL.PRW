#Include 'Protheus.CH'

/*/{Protheus.doc} MCSUTIL
Tela para leitura de arquivo para geração do dicionário de dados
@type function
@version  
@author MCS Tecnologia
@since 2/27/2026
@return variant, return_description
/*/
User Function MCSUTIL()

    Local aSays        := {}
    Local aButtons     := {}
    Local lOk          := .F.
    Local oSay
    Local aRet         := {}

    lCheckUser = .F.
    lAllEmp = .T.
    lOnlySelect= .T.
    
    aAdd(aSays, "Esse programa tem como objetivo importar o arquivo com informações para ")
    aAdd(aSays, "criação do dicionário de dados no Protheus, SX2, SX3 e SIX ")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Apenas administrador tem acesso aos parâmetros                   ?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    aAdd(aButtons, { 5, .T., {|| aRet := Params()} } )
    aAdd(aButtons, { 1, .T., {|| lOk := .T., FechaBatch() }} )
    aAdd(aButtons, { 2, .T., {|| lOk := .F., FechaBatch() }} )
    
    FormBatch("Ajusta Arquivo", aSays, aButtons)
    
    If lOk
        FWMsgRun(, {|oSay| fLerArquivo(oSay,aRet) }, "Processando", "Lendo arquivo para realizar geração do dicionário de dados",.T.,.T.)
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
    
    aAdd(aParams ,{ 6,"Selecione o arquivo csv:"        ,Space(100)     ,"","","",70,.F.,"Todos os arquivos (*.csv) |*.csv"})
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

/*/{Protheus.doc} fLerArquivo
Função que lê o arquivo e separa as informações em arrays para geração do dicionário de dados
@type function
@version  
@author MCS Tecnologia
@since 4/2/2026
@param oSay, object, param_description
@param aRet, array, param_description
@return variant, return_description
/*/
Static Function fLerArquivo(oSay,aRet)

    Local aTabela   := {}
    Local aCampos   := {}
    Local aIndices  := {}
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
            FWAlertError("Erro ao abrir o arquivo!", "Verifique")
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
                FWAlertError("Não foram encontrados registros/linhas no arquivo", "Verifique")
            Else
                While !FT_FEOF()
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    //lendo e retornando a linha
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    cLinha := FT_FREADLN()
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    //adicionando as linhas no array
                    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
                    If Substr(cLinha,1,1) == 'T'
                        aadd(aTabela,separa(cLinha,";",.T.))
                    ElseIf Substr(cLinha,1,1) == 'C'
                        aadd(aCampos,separa(cLinha,";",.T.))
                    ElseIf Substr(cLinha,1,1) == 'I'
                        aadd(aIndices,separa(cLinha,";",.T.))
                    EndIf

                    FT_FSKIP()
                EndDo                         
            EndIf
        EndIF

        FT_FUse()

    EndIf

    fGeraDicionario(aTabela,aCampos,aIndices)

Return

/*/{Protheus.doc} fGeraDicionario
Função que valida e efetiva a gravação do dicionário
@type function
@version  
@author rodri
@since 4/2/2026
@param aTabela, array, param_description
@param aCampos, array, param_description
@param aIndices, array, param_description
@return variant, return_description
/*/
Static Function fGeraDicionario(aTabela,aCampos,aIndices)

    Local nNext     := 0
    Local nPrim     := 1
    Local xCampo    := ""
    Local xTabela   := ""

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Validando se todos os campos do array tabela obrigatórios estão preenchidos e são válidos?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    For nNext := 1 To Len(aTabela)

        If aTabela[nNext,2] == xTabela
            FWAlertError("A tabela " + aTabela[nNext,1] + " está repetida, verifique posição 2", "Verifique")
            Return
        EndIf

        If Empty(aTabela[nNext,2]) .or. Empty(aTabela[nNext,4]) .Or. Empty(aTabela[nNext,5]) .Or. Empty(aTabela[nNext,6]) .Or. Empty(aTabela[nNext,7]);
            .Or. Empty(aTabela[nNext,8]) .Or. Empty(aTabela[nNext,19]) .Or. Empty(aTabela[nNext,20]) 
            FWAlertError("A tabela " + aTabela[nNext,1] + " não possui todos os campos obrigatórios preenchidos, verifique posição 2/4/5/6/7/8/19/20", "Verifique")
            Return 
        EndIf
        xTabela := aTabela[nNext,2]
        
    Next nNext

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Validando se todos os campos do array campos obrigatórios estão preenchidos e são válidos?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    For nNext := 1 To Len(aCampos)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        //? O Primeiro campo precisa ser a filial                                        ?
        //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
        If nNext > 1 .And. xCampo <> aCampos[nNext,1]
            nPrim := 1
        EndIf
        If nPrim == 1 .And. Substr(aCampos[nNext,2],4,7) <> "_FILIAL"
            FWAlertError("O primeiro campo da tabela " + aTabela[nNext,1] + " precisa ser o campo de filial com a máscara XXX_FILIAL, verifique posição 2", "Verifique")
            Return
        EndIf

        If Empty(aCampos[nNext,2]) .or. Empty(aCampos[nNext,3]) .Or. Empty(aCampos[nNext,4]) .Or. Empty(aCampos[nNext,5]) .Or. Empty(aCampos[nNext,6]) ;
            .Or. Empty(aCampos[nNext,7]) .Or. Empty(aCampos[nNext,8]) .Or. Empty(aCampos[nNext,9]) .Or. Empty(aCampos[nNext,10]) .Or. Empty(aCampos[nNext,11]) ;
            .Or. Empty(aCampos[nNext,12]) .Or. Empty(aCampos[nNext,13]) .Or. Empty(aCampos[nNext,14]) .Or. Empty(aCampos[nNext,19]) .Or. Empty(aCampos[nNext,23]);
            .Or. Empty(aCampos[nNext,24])
            FWAlertError("O campo " + aCampos[nNext,1] + " não possui todos os campos obrigatórios preenchidos, verifique posição 2/3/4/5/6/7/8/9/10/11/12/13/14/19/23/24", "Verifique")
            Return
        EndIf

        xCampo := aCampos[nNext,1]

    Next nNext

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    //? Validando se todos os campos do array indices obrigatórios estão preenchidos e são válidos?
    //?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
    For nNext := 1 To Len(aIndices)

        If Empty(aIndices[nNext,2]) .or. Empty(aIndices[nNext,3]) .Or. Empty(aIndices[nNext,4]) .Or. Empty(aIndices[nNext,5]) .Or. Empty(aIndices[nNext,6]) ;
            .Or. Empty(aIndices[nNext,7]) .Or. Empty(aIndices[nNext,8]) .Or. Empty(aIndices[nNext,11]) ;
            FWAlertError("O índice " + aIndices[nNext,1] + " não possui todos os campos obrigatórios preenchidos, verifique posição 2/3/4/5/6/7/8/11", "Verifique")
            Return
        EndIf

    Next nNext

    U_UPDTXT(aTabela,aCampos,aIndices)

Return

