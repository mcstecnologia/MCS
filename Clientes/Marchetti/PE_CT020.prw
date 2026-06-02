#Include 'Protheus.CH'

/*/{Protheus.doc} CTBA020
Ponto de entrada MVC para CTBA020 - Plano de contas
@type function
@version  
@author MCS Tecnologia
@since 5/26/2026
@return variant, return_description
/*/
User Function CTBA020()

    Local aParam    := PARAMIXB
    Local oObj
    Local cIDPonto  := ''
    Local cIDModel  := ''
    Local lIsGrid   := .F.
    Local lAtvPE    := SuperGetMV("MC_XCTB020",.F.,.T.) 
    Local nOpc      := 0
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Ativação da regra           
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lAtvPE 
        If aParam <> NIL
            oObj        := aParam[1]
            cIdPonto    := aParam[2]
            cIdModel    := aParam[3]
            lIsGrid     := (Len(aParam) > 3)
            nOpc        := oObj:GetOperation() 

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Após a gravação na tabela                        
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (cIdPonto == "MODELCOMMITNTTS") .And. nOpc == 3
                U_MCCTB020(CT1->CT1_CONTA)
            EndIf

        EndIf
    EndIf
    
Return .T.

