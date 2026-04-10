
#Include 'Protheus.CH'

/*/{Protheus.doc} M460QUEB
description
@type function
@version  
@author MCS Tecnologia
@since 4/8/2026
@return variant, return_description
/*/
User Function M460QUEB()

    Local lQuebra    := .F.
    Local cAlias     := ""
    Local aPvlNfs    := {}
    Local nX         := 1
    Local nCoun      := 
    
    cAlias  := ParamIxb[01]
    aPvlNfs := If(Len(ParamIxb[02]) <> 0 , aClone(ParamIxb[02]),{})

    For nX := 1 To Len(aPvlNfs)
        If lQuebra
            Exit
        EndIf
        nCount
    Next nX
 
Return(lQuebra)
