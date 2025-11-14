#include "protheus.ch"
#include "parmtype.ch"
 
/*/{Protheus.doc} CUSTOMERVENDOR
Ponto de entrada MVC do MATA020
@type function
@version  
@author rodri
@since 2/26/2024
@return variant, return_description
/*/
User Function CUSTOMERVENDOR()

    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local oObj          := ""
    Local cIdPonto      := ""
    Local cIdModel      := ""
    Local lIsGrid       := .F.
    Local nOperation    := 0
    //Local xFacAuto      := GetMV("MV_FACAUTO")

    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
        nOperation := oObj:GetOperation()
 
        If cIdPonto == "MODELPOS"
            
 
        ElseIf cIdPonto == "FORMPOS"
           
        ElseIf cIdPonto == "FORMLINEPRE"
            
        ElseIf cIdPonto == "FORMLINEPOS"
          
        ElseIf cIdPonto == "MODELCOMMITTTS"      

        ElseIf cIdPonto == "MODELCOMMITNTTS"   
                U_CTRIB01("","",SA2->A2_COD, SA2->A2_LOJA, SA2->A2_GRPTRIB,nOperation)
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
           
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
 
        ElseIf cIdPonto == "MODELCANCEL"
 
        ElseIf cIdPonto == "BUTTONBAR"
          
        EndIf
    EndIf

Return xRet
 
