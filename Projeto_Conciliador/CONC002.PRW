#Include 'Protheus.CH'

/*/{Protheus.doc} CONCI001
Monta tela com os registros importados Anfe
@type function
@version  
@author Daiane Leandro
@since 12/17/2024
@return variant, return_description
/*/
User Function CONCI002()

    Local cTabela     := 'ZZB' //Alias da tabela de monitoramento
    Local cCampo      := ""
    Local aArea       := (cTabela)->(GetArea())

    //Private oStruct
    Private aCores    := {}
    Private cCadastro := "Importações Anfe"
    Private aRotina   := {}
     
    //Obtendo a estrutura da tabela contida na variável cAlias
    //oStruct  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ ) 

    //Montando o Array aRotina, com funções que serão mostradas no menu
    aAdd(aRotina,{"Pesquisar"               ,   "AxPesqui"              , 0, 1})
    aAdd(aRotina,{"Visualizar"              ,   "AxVisual"              , 0, 2})
    aAdd(aRotina,{"Incluir"                 ,   "AxInclui"              , 0, 3})
    aAdd(aRotina,{"Alterar"                 ,   "AxAltera"              , 0, 4})
    //aAdd(aRotina,{"Excluir"               ,   "AxDeleta"              , 0, 5})
    aAdd(aRotina,{"Importar Planilha Anfe"  ,   "U_CONC002A()"          , 0, 8})
    //aadd(aRotina,{"Legenda"               ,   "U_SZ0016L()  "         , 0, 9})
    
 
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

/*/{Protheus.doc} CONC001A
Tela para importar o arquivo
@type function
@version  
@author Daiane Leandro
@since 12/17/2024
@return variant, return_description
/*/
User Function CONC002A()

    Local cDir
    Local oSay
    Private oEdit1
    Private oDlg1
    Private oGet
    Private Say
    Private oButConfirm
    Private oButClose

	DEFINE MSDIALOG oDlg1 Title "Importa registros do Anfe" From 100,55 to 300,500 Pixel

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

    Local aArea     := ZZB->(GetArea())
    Local x         := 0
    Local lRet      := .T.
    Local xValNota  := ''
    Local xValIcm   := ''
    Local xValIpi   := ''
    Local aErro     := {}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Buscando a sequencia para gravaçaõ                                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    cSeq := U_CONCSEQ('ZZB')
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valido a existencia de registro na data base                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    lRet := u_CONCGRA('ZZB')

    If !lRet
        MsgInfo("Processo interrompido")
        Return
    EndIf 

    For x := 1 to Len(aDados)

       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Caso algum dado em branco, passo o registro                          ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
        If Empty(aDados[x][6]) .Or. Empty(aDados[x][25]) .Or. Empty(aDados[x][36])
            aadd(aErro,{"A linha " + cValToChar(x+1) + "não foi gravada, campos obrigatórios em branco"})
            Loop
        Else
            Begin Transaction
                RecLock("ZZB", .T.)
                    ZZB->ZZB_FILIAL := FwxFilial("ZZB")
                    ZZB->ZZB_SEQ    := cSeq
                    ZZB->ZZB_CHAVE  := AllTrim(aDados[x][6])
                    ZZB->ZZB_NATURE := FwNoAccent(AllTrim(aDados[x][25]))
                    ZZB->ZZB_SITMAN := FwNoAccent(AllTrim(aDados[x][36]))
                    ZZB->ZZB_DTIMP  := dDataBase 
                ZZB->(MsUnlock())
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

