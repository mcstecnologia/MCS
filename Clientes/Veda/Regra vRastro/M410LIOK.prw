#Include 'Protheus.CH'


/*/{Protheus.doc} M410LIOK
Valida linha no pedido de venda
@type function
@version  
@author MCS Tecnologia
@since 01/2/2026
@return variant, return_description
/*/
User Function M410LIOK()

    Local lRet      := .T.
    Local nPosxOp   := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_XOP" })
    Local lAtv      := SuperGetMV("VD_ATVRAST",.F.,.T.)
    Local xParCli   := SuperGetMV("VD_CLIRAST",.F.,"000001")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Caso ativado e exista o campo, executa processo de gravação do complemento³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lAtv .And. FieldPos("C6_XOP") > 0
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Segue apenas se for o cliente informado ou ser o parâmetro estiver em branco ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If M->C5_CLIENTE $ xParCli .Or. Empty(xParCli)
            If Empty(aCols[n][nPosxOp])
                //Alert("Para o cliente informado, é necessário informar o campo C6_XOP para geração do vRastro")
                Help('',1,"M410LIOK",,"Para o cliente informado, é necessário informar o campo C6_XOP para geração da tag vRastro na nota fiscal",1,0) 
                lRet := .F.
            EndIf
        EndIf
    EndIf

Return lRet
