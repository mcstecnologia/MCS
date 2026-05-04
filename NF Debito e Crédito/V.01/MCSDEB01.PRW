#Include "Protheus.ch"
#Include "TOTVS.CH"
#Include "FWMVCDef.CH"
/*/{Protheus.doc} MCSDEB01
Tela para exibição da dos registros da tabela customizada
@type function
@version  
@author MCS Tecnologia
@since 4/29/2026
@return variant, return_description
/*/
User Function MCSDEB01()


    Local xTabela     := SuperGetMV("XX_ALIAS",.F.,"WW1")
    Local xCampo      := ""
    Local aArea       := (xTabela)->(GetArea())

    Private aCores    := {}
    Private cCadastro := "Monitor Notas de Débito e Crédito"
    Private aRotina   := {}
     
    xCampo := xTabela+"_NFEOK" 

    //Montando o Array aRotina, com funções que serão mostradas no menu
    aAdd(aRotina,{"Pesquisar"           ,   "AxPesqui"          , 0, 1})
    aAdd(aRotina,{"Visualizar"          ,   "AxVisual"          , 0, 2})
    aAdd(aRotina,{"Gerar Nota "         ,   "U_MCSGERA()"       , 0, 8})
    aadd(aRotina,{"Legenda"             ,   "U_MCSLEG()"        , 0, 9})

    //Montando as cores da legenda
    aAdd(aCores,{xCampo+" == 'N' .And. "+xTabela+"_TPNOTA == '4' ", "BR_VERDE"   })
    aAdd(aCores,{xCampo+" == 'N' .And. "+xTabela+"_TPNOTA == '3' ", "BR_PINK"    })
    aAdd(aCores,{xCampo+" == 'S' ", "BR_VERMELHO"  })

    //Selecionando a tabela e ordenando
    DbSelectArea(xTabela)
    (xTabela)->(DbSetOrder(1))
     
    //Montando o Browse
    mBrowse(6, 1, 22, 75, xTabela , , , , , , aCores )
     
    //Encerrando a rotina
    (xTabela)->(DbCloseArea())
    
    RestArea(aArea)
    
Return

/*/{Protheus.doc} MCSLEG
LEgenda
@type function
@version  
@author MCS Tecnologia
@since 5/1/2026
@return variant, return_description
/*/
User Function MCSLEG()

    Local aLegenda := {}

    aLegenda := { { "BR_VERDE"      ,    "NF Tipo 4 Não Gerada" },;
                  { "BR_VERMELHO"   ,    "Nf Gerada"     },;
                  { "BR_PINK"       ,    "NF Tipo 3 Não Gerada"}}
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .T.

