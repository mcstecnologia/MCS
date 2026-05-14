#Include 'Protheus.CH'

/*/{Protheus.doc} MCSLOGDC
Tela de log dos registros gerados pela rotina MCSGERA
@type function
@version  
@author MCS Tecnologia
@since 5/7/2026
@return variant, return_description
/*/
User Function MCSLOGDC()

    Local xTabela     := SuperGetMV("XX_ALIAS",.F.,"WW3")
    Local xCampo      := ""
    Local aArea       := (xTabela)->(GetArea())

    Private aCores    := {}
    Private cCadastro := "Logs Monitor Notas de Débito e Crédito"
    Private aRotina   := {}
     
    xCampo := xTabela+"_STATUS" 

    aAdd(aRotina,{"Pesquisar"           ,   "AxPesqui"          , 0, 1})
    aAdd(aRotina,{"Visualizar"          ,   "AxVisual"          , 0, 2})
    aadd(aRotina,{"Legenda"             ,   "U_MCSLOLEG()"        , 0, 9})

    aAdd(aCores,{xCampo+" == '0' ", "BR_VERDE"   })
    aAdd(aCores,{xCampo+" == '1' ", "BR_VERMELHO"    })

    DbSelectArea(xTabela)
    (xTabela)->(DbSetOrder(1))
     
    mBrowse(6, 1, 22, 75, xTabela , , , , , , aCores )
     
    (xTabela)->(DbCloseArea())
    
    RestArea(aArea)

Return

/*/{Protheus.doc} MCSLEG
Legenda
@type function
@version  
@author MCS Tecnologia
@since 5/7/2026
@return variant, return_description
/*/
User Function MCSLOLEG()

    Local aLegenda := {}

    aLegenda := { { "BR_VERDE"      ,    "Sucesso na geração" },;
                  { "BR_VERMELHO"   ,    "Erro na geração"     }}
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .T.
