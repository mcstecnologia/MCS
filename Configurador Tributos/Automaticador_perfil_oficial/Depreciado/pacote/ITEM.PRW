#include "protheus.ch"
#include "parmtype.ch"

/*/{Protheus.doc} ITEM
Ponto de entrada MATA010
@type function
@version  
@author rodri
@since 2/23/2024
@return variant, return_description
/*/
User Function ITEM()

    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local oObj          := Nil
    Local cIdPonto      := ""
    Local cIdModel      := ""
    Local lIsGrid       := .F.
    Local nOperation    := 0
    Local xOrig         := ""
    
    
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
            //ApMsgInfo("1")
        ElseIf cIdPonto == "MODELCOMMITTTS"
            xOrig := SB1->B1_POSIPI
            //ApMsgInfo("2") //primeira chamada
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            //If xFacAuto
                U_MCSTRIB()
            //EndIf
            //ApMsgInfo("3") //SEGUNDA CHAMADA
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
            //ApMsgInfo("4")
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
            //ApMsgInfo("5")
        ElseIf cIdPonto == "MODELCANCEL"
            //ApMsgInfo("6")
        ElseIf cIdPonto == "BUTTONBAR"
           
        EndIf

    EndIf
    
Return xRet
