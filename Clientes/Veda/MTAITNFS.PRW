#Include 'Protheus.CH'


/*/{Protheus.doc} MTAITNFS
POnto de entrada que altera a quantidade máxima de itens na nota
@type function
@version  
@author MCS Tecnologia
@since 4/7/2026
@return variant, return_description
/*/
User Function MTAITNFS()

    Local nQtde := GetMV('MV_NUMITEN')

    FWLogMsg("INFO",,"MTAITNFS - A460NumIt",,,,"Número de itens setados na nota: " + cValToChar(nQtde),,,) 
    
Return nQtde
