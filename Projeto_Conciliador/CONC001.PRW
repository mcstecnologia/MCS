#Include 'Protheus.CH'

/*/{Protheus.doc} CONCI001
Monta tela com os registros importados SAT
@type function
@version  
@author Daiane Leandro
@since 12/17/2024
@return variant, return_description
/*/
User Function CONCI001()

    Local cTabela     := 'ZZA' //Alias da tabela de monitoramento
    Local cCampo      := ""
    Local aArea       := (cTabela)->(GetArea())

    //Private oStruct
    Private aCores    := {}
    Private cCadastro := "Importações SAT"
    Private aRotina   := {}
     
    //Obtendo a estrutura da tabela contida na variável cAlias
    //oStruct  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ ) 

    //Montando o Array aRotina, com funções que serão mostradas no menu
    aAdd(aRotina,{"Pesquisar"               ,   "AxPesqui"          , 0, 1})
    aAdd(aRotina,{"Visualizar"              ,   "AxVisual"          , 0, 2})
    aAdd(aRotina,{"Incluir"                 ,   "AxInclui"          , 0, 3})
    aAdd(aRotina,{"Alterar"                 ,   "AxAltera"          , 0, 4})
    //aAdd(aRotina,{"Excluir"               ,   "AxDeleta"          , 0, 5})
    aAdd(aRotina,{"Importar Planilha SAT"   ,   "U_CONC001A()"      , 0, 2})
    aAdd(aRotina,{"Importar Planilha Anfe"  ,   "U_CONC002A()"      , 0, 2})
    aAdd(aRotina,{"Processar Conciliação "  ,   "U_CONCI003()"      , 0, 2})
    //aadd(aRotina,{"Legenda"               ,   "U_SZ0016L()"       , 0, 9})
    
 
    //Montando as cores da legenda
    /*aAdd(aCores,{cCampo+" == '1' ", "BR_VERDE"    })
    aAdd(aCores,{cCampo+" == '2' ", "BR_AMARELO"  })
    aAdd(aCores,{cCampo+" == '3' ", "BR_VERMELHO" })
    aAdd(aCores,{cCampo+" == '4' ", "BR_AZUL"     })*/
     
    //Selecionando a tabela e ordenando
    DbSelectArea(cTabela)
    (cTabela)->(DbSetOrder(1))
     
    //Montando o Browse
    mBrowse(6, 1, 22, 75, cTabela , , , , , , aCores )
     
    //Encerrando a rotina
    (cTabela)->(DbCloseArea())
    RestArea(aArea)

Return

User Function CONC001A()

    Local cDir
    Local oSay
    Private oEdit1
    Private oDlg1
    Private oGet
    Private Say
    Private oButConfirm
    Private oButClose

	DEFINE MSDIALOG oDlg1 Title "Importa registros do SAT" From 100,55 to 300,500 Pixel

	@020,010 SAY    "Pesquise abaixo o arquivo para importacao" SIZE 200, 10 OF oDlg1 PIXEL
	@030,010 MSGET  cDir            SIZE 160,010 When .F. Of oDlg1 Pixel
	@030,175 BUTTON "Localizar"     SIZE 032,012 ACTION cDir:= Alltrim(cGetFile('Arquivos de Texto (*.CSV)|*.csv|',OemToAnsi("Selecione o Arquivo"),0,"",.T.,GETF_LOCALHARD))  Of oDlg1 Pixel
    @055,010 BUTTON "Importar"      SIZE 032,012 ACTION FwMsgRun(,{ |oSay| fCarregaArq(oSay,cDir) }, "Aguarde...", "Carregando arquivo para importacao.")  Of oDlg1 Pixel
    @055,055 BUTTON "Fechar"	    SIZE 032,012 ACTION oDlg1:End() of oDlg1 Pixel

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

/*/{Protheus.doc} fCarregaArq
Função que carrega o arquivo para importação.
@type function
@version  
@author Rodrigo
@since 10/3/2024
@param cDir, character, param_description
@return variant, return_description
/*/
Static Function fCarregaArq(oSay,cDir,nQtde)

    Local aDados  := {}
    Local nhandle := 0
    Local nLinha  := 0
    Local cLinha  := ""
    Local lPrimLin  := .T.
    Local oSay

    If Empty(cDir)
        MsgStop("Não foi informado o arquivo para importação!", "Verifique")
    Else
        //abre o arquivo
        nHandle := FT_FUse(cDir)
            If nHandle = -1
                MsgStop("Erro ao abrir o arquivo!", "Verifique")
            Else
                //posiciona na primeira linha do arquivo
                FT_FGoTop()
                //retorna o numero de linhas
                nLinha := FT_FlastRec()
                    If nLinha == 0
                        MsgStop("Não foram encontrados registros/linhas no arquivo", "Verifique")
                    Else
                        while !FT_FEOF()
                            //lendo e retornando a linha
                            cLinha := FT_FREADLN()
                            If lPrimlin
                                lPrimlin := .F.
                               //adicionando as linhas no array
                            Else
                               aadd(aDados,separa(cLinha,";",.T.))
                            EndIf
                            FT_FSKIP()
                        EndDo
                    EndIF
            EndIF
    EndIF
    //Fechando o arquivo
    FT_FUse()
    If MsgYesNo("Foram carregados " + cValToChar(nLinha) + " registros, deseja realizar a importação?", "Confirma?")
        FwMsgRun(,{ |oSay| fConc001(oSay,aDados)}, "Aguarde, importando registros")
    Else
        Alert("Cancelado pelo usuário")
    EndIf
Return

/*/{Protheus.doc} fConc001
Valida e grava os registros na tabela do SAT
@type function
@version  
@author Daiane Leandro
@since 12/17/2024
@return variant, return_description
/*/
Static Function fConc001(oSay,aDados)

    Local aArea     := ZZA->(GetArea())
    Local x         := 0
    Local lRet      := .T.
    Local xValNota  := ''
    Local xValIcm   := ''
    Local xValIpi   := ''
    Local aErro     := {}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Buscando a sequencia para gravaçaõ                                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    cSeq := U_CONCSEQ('ZZA')
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valido a existencia de registro na data base                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    lRet := u_CONCGRA('ZZA')

    If !lRet
        MsgInfo("Processo interrompido")
        Return
    EndIf 

    For x := 1 to Len(aDados)

       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Caso algum dado em branco, passo o registro                          ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
        If Empty(aDados[x][5]) .Or. Empty(aDados[x][6]) .Or. Empty(aDados[x][19]) .Or. Empty(aDados[x][20]);
            .Or. Empty(aDados[x][21]) .Or. Empty(aDados[x][23]) .Or. Empty(aDados[x][43])
            aadd(aErro,{"A linha " + cValToChar(x+1) + "não foi gravada, campos obrigatórios em branco"})
            Loop
        Else

        xValNota := Strtran(aDados[x][21],'.','')
        xValNota := Strtran(xValNota,',','.')
        xValIcm := Strtran(aDados[x][23],'.','')
        xValIcm := Strtran(xValIcm,',','.')
        xValIpi := Strtran(aDados[x][43],'.','')
        xValIpi := Strtran(xValIpi,',','.')

            Begin Transaction
                RecLock("ZZA", .T.)
                    ZZA->ZZA_FILIAL := FwxFilial("ZZA")
                    ZZA->ZZA_SEQ    := cSeq
                    ZZA->ZZA_CHAVE  := AllTrim(aDados[x][5])
                    ZZA->ZZA_EMISSA := stod(aDados[x][6])
                    ZZA->ZZA_DOC    := AllTrim(aDados[x][20])
                    ZZA->ZZA_SERIE  := AllTrim(aDados[x][19])
                    ZZA->ZZA_VLTOT  := Val(xValNota)
                    ZZA->ZZA_VLICMS := Val(xValIcm)
                    ZZA->ZZA_VLIPI  := Val(xValIpi) 
                    ZZA->ZZA_DTIMP  := dDataBase 
                ZZA->(MsUnlock())
            End Transaction
        EndIf
    Next x

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Chamando função para gravar log de erro                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ    
    If Len(aErro) > 0
        FwMsgRun(,{ |oSay| U_CONCLOG(oSay,aErro) }, "Aguarde...", "Gerando log de erros")
    EndIf

    RestArea(aArea)

    MsgInfo("Processo finalizado!!")

Return

/*/{Protheus.doc} fValGrav
Valida a gravação na tabela ZZA
@type function
@version  
@author Rodrigo
@since 12/17/2024
@return variant, return_description
/*/
User Function CONCGRA(cTabela)

    Local aArea := (cTabela)->(GetArea())
    Local lRet  := .T.

    If (cTabela)->(MsSeek(xFilial("ZZA") + dDataBase))
        If MsgYesNo("Já existem registros importados com essa data base, deseja prosseguir?")
            lRet := .F.
        EndIf
    EndIf

    RestArea(aArea)

Return lRet

/*/{Protheus.doc} fValSeq
Valida sequencia de importação
@type function
@version  
@author Daiane Leandro
@since 12/17/2024
@return variant, return_description
/*/
User Function CONCSEQ(cTabela)

    Local cQuery := ""
    Local xAlias := GetNextAlias()
    Local cSeq   := ""

    cQuery := "SELECT "+cTabela+"_SEQ "
    cQuery += "FROM "
    cQuery += RetSqlName(cTabela)
    cQuery += " WHERE "+cTabela+"_DTIMP = '" + dTos(dDataBase) + "' "
    cQuery += " AND D_E_L_E_T_ = ' '"

    MpSysOpenQuery(cQuery, xAlias)

    (xAlias)->(dbGoTop())

    If !(xAlias)->(Eof())
        cSeq := Soma1((xAlias)->ZZA_SEQ)
    Else 
        cSeq := '01'
    EndIf

    (xAlias)->(dbCloseArea())

Return cSeq

/*/{Protheus.doc} fLogErro
Gera log de erro
@type function
@version  
@author Rodrigo
@since 10/11/2024
@param aErro, array, param_description
@return variant, return_description
/*/
User Function CONCLOG(oSay,aErro)

    Local cTime     := Replace(Time(),":","")
    Local cData     := dtos(dDataBase)
    Local cPasta    := "C:\IMPORTA_SAT\
    Local nHdl      := 0
    Local cArquivo  := "ERROR_"+cData+"_"+cTime+".txt"
    Local x         := 0

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criando pasta no disco c ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    If !ExistDir(cPasta)
        MakeDir(cPasta)
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criando o arquvio                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    nHdl := FCreate(cPasta+cArquivo)

    If nHdl < 0
        MsgInfo("Erro na criação do arquivo de log, verifique")
    Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gravando o cabeçalho e os dados no aRegs                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        For x := 1 to Len(aErro)
            FWrite(nHdl,aErro[x][1] + ";" + aErro[x][2] + CRLF)
        Next x
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fechando arquivo                                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    FClose(nHdl)

Return
