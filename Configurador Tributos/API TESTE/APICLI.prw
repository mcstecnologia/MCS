#Include "protheus.ch"
#Include "restful.ch"
#Include "topconn.ch"

WSRESTFUL ClienteRest DESCRIPTION "Serviço REST para cadastro de clientes"

// POST -> Grava um novo cliente
WSMETHOD POST DESCRIPTION "Grava novo cliente" WSSYNTAX "/clientes"
WSRECEIVE JSON ClienteBody
WSRETURN JSON Retorno

// ------------------------------------------------------------
// Método POST - Gravar cliente
// ------------------------------------------------------------
WSMETHOD POST ClienteRest:POST(cUrl, cQuery, oBody, oResponse) CLASS ClienteRest

    Local cCodCli  := ""
    Local cNomeCli := ""
    Local cCgcCli  := ""
    Local lOk      := .F.
    Local cMsg     := ""
    Local aArea    := SA1->(GerArea)

    // Recebe o corpo JSON
    If oBody:HasKey("codigo")
        cCodCli := AllTrim(oBody["codigo"])
    EndIf

    If oBody:HasKey("nome")
        cNomeCli := AllTrim(oBody["nome"])
    EndIf

    If oBody:HasKey("cnpj")
        cCgcCli := AllTrim(oBody["cnpj"])
    EndIf

    If oBody:HasKey("codigo")
        cLoja := AllTrim(oBody["loja"])
    EndIf

    If oBody:HasKey("nome")
        cEnd := AllTrim(oBody["end"])
    EndIf

    If oBody:HasKey("cnpj")
        cTipo := AllTrim(oBody["tipo"])
    EndIf

    If oBody:HasKey("nome")
        cEst := AllTrim(oBody["est"])
    EndIf

    If oBody:HasKey("cnpj")
        cMun := AllTrim(oBody["mun"])
    EndIf

    // Validação simples
    If Empty(cCodCli) .Or. Empty(cNomeCli)
        cMsg := "Código e nome do cliente são obrigatórios."
    Else
        // Grava cliente na tabela SA1
        SA1->(DbSelectArea("SA1"))
        SA1->(DbSetOrder(1))

        If SA1->(DbSeek(xFilial("SA1") + cCodCli))
            cMsg := "Cliente já cadastrado!"
        Else
           IF nOpcAuto = 3  //Inclusão
                ConOut("Teste de Inclusao")
                ConOut("Inicio: " + Time())

                //----------------------------------
                // DADOS DO CLIENTE
                //----------------------------------
                aAdd(aSA1Auto,{"A1_COD"    ,"XBX141"            ,Nil}) // Codigo
                aAdd(aSA1Auto,{"A1_LOJA"   ,"01"                ,Nil}) // Loja
                aAdd(aSA1Auto,{"A1_NOME"   ,"ROTINA AUTOMATICA",Nil}) // Nome
                aAdd(aSA1Auto,{"A1_END"    ,"BRAZ LEME"         ,Nil}) // Endereco
                aAdd(aSA1Auto,{"A1_NREDUZ","ROTAUTO"           ,Nil}) // Nome Fantasia
                aAdd(aSA1Auto,{"A1_TIPO"   ,"F"                 ,Nil}) // Tipo
                aAdd(aSA1Auto,{"A1_EST"    ,"SP"                ,Nil}) // Estado
                aAdd(aSA1Auto,{"A1_MUN"    ,"SAO PAULO"         ,Nil}) // Municipio
                CONOUT("Passou pelo Array da SA1")        

                //---------------------------------------
                // DADOS DO COMPLEMENTO DO CLIENTE
                //---------------------------------------
                //aAdd(aAI0Auto,{"AI0_SALDO" ,30 ,Nil})
                //CONOUT("Passou pelo Array da AI0")        

                //------------------------------------
                // Chamada para cadastrar o cliente
                //------------------------------------
                CONOUT("Iniciando a gravacao")
                MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

                If lMsErroAuto
                    lRet := lMsErroAuto
                    MostraErro()  // Nao funciona na execucao via JOB
                Else
                    Conout("Cliente incluido com sucesso!")
                EndIf

                ConOut("Fim: " + Time())
            //----------------------------------
            // ALTERAÇÃO
            //----------------------------------
            ElseIf nOpcAuto = 4  //Alteração

                ConOut("Teste de Alteracao")
                ConOut("Inicio: " + Time())

                //----------------------------------
                // DADOS DO CLIENTE
                //----------------------------------
                aAdd(aSA1Auto,{"A1_COD"    ,"XBX141"            ,Nil}) // Codigo
                aAdd(aSA1Auto,{"A1_LOJA"   ,"01"                ,Nil}) // Loja
                aAdd(aSA1Auto,{"A1_NOME"   ,"ROTINA AUTO ALT"   ,Nil}) // Nome
                aAdd(aSA1Auto,{"A1_END"    ,"BRAZ LEME"         ,Nil}) // Endereco
                aAdd(aSA1Auto,{"A1_NREDUZ","ROTAUTO"           ,Nil}) // Nome Fantasia
                aAdd(aSA1Auto,{"A1_TIPO"   ,"F"                 ,Nil}) // Tipo
                aAdd(aSA1Auto,{"A1_EST"    ,"SP"                ,Nil}) // Estado
                aAdd(aSA1Auto,{"A1_MUN"    ,"SAO PAULO"         ,Nil}) // Municipio
                CONOUT("Passou pelo Array da SA1")        

                //---------------------------------------
                // DADOS DO COMPLEMENTO DO CLIENTE
                //---------------------------------------
                //aAdd(aAI0Auto,{"AI0_SALDO" ,30 ,Nil})
                //CONOUT("Passou pelo Array da AI0")        

                //------------------------------------
                // Chamada para alterar o cliente
                //------------------------------------
                CONOUT("Iniciando a alteracao")
                MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

                If lMsErroAuto
                    lRet := lMsErroAuto
                    MostraErro()  // Nao funciona na execucao via JOB
                Else
                    Conout("Cliente alterado com sucesso!")
                EndIf

                ConOut("Fim: " + Time())

            //----------------------------------
            // EXCLUSÃO
            //----------------------------------
            ElseIf nOpcAuto = 5  //Exclusão

                ConOut("Teste de Exclusao")
                ConOut("Inicio: " + Time())

                //----------------------------------
                // DADOS DO CLIENTE
                //----------------------------------
                aAdd(aSA1Auto,{"A1_COD"    ,"XBX141"            ,Nil}) // Codigo
                aAdd(aSA1Auto,{"A1_LOJA"   ,"01"                ,Nil}) // Loja
                CONOUT("Passou pelo Array da SA1")

                //------------------------------------
                // Chamada para excluir o cliente
                //------------------------------------
                CONOUT("Iniciando a exclusao")
                MSExecAuto({|a,b,c| CRMA980(a,b,c)},aSA1Auto,nOpcAuto,aAI0Auto)        

                If lMsErroAuto
                    lRet := lMsErroAuto
                    MostraErro()  // Nao funciona na execucao via JOB
                Else
                    Conout("Cliente excluido com sucesso!")
                EndIf

                ConOut("Fim: " + Time())

            EndIf
        EndIf
    EndIf

    // Retorno JSON
    oResponse["sucesso"] := lOk
    oResponse["mensagem"] := cMsg
    Return oResponse

End WSMETHOD
