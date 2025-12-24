#Include "Protheus.ch"
 
/*/{Protheus.doc} LIMPAESP
description
@type function
@version  
@since 12/12/2025
@return variant, return_description
/*/ 
User Function LIMPAESP()

    Local aArea       := GetArea()
    Local xCmp        := ReadVar()
    Local xValor      := &(xCmp)
    
    xValor := Rtrim(xValor)
     
    &(xCmp+" := '"+xValor+"' ")
     
    RestArea(aArea)

Return .T.
 


