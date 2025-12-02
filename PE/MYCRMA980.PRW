#include "Protheus.ch"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MYCRMA980
Ponto de entrada CRMA980 - NOVO PONTO DE ENTRADA
@type function
@version  
@author rodri
@since 2/22/2024
@return variant, return_description
/*/
User Function CRMA980() ///cXXX1,cXXX2,cXXX3,cXXX4,cXXX5,cXXX6

    Local aParam        := PARAMIXB
    Local xRet          := .T.
    Local lIsGrid       := .F.
    Local cIDPonto      := ''
    Local cIDModel      := ''
    Local oObj          := NIL
    Local xOrig         := ""
    //Local xFacAuto      := GetMV("MV_FACAUTO")

    
    If aParam <> NIL
        oObj        := aParam[1]
        cIDPonto    := aParam[2]
        cIDModel    := aParam[3]
        lIsGrid     := (Len(aParam) > 3)
        nOperation := oObj:GetOperation()

        If cIDPonto == 'MODELCOMMITTTS'
            // Mostra o tipo de Operacao
            xOrig := SA1->A1_GRPTRIB
        ElseIf cIDPonto == 'FORMCOMMITTTSPRE'

        ElseIf cIDPonto == "MODELCOMMITNTTS"
            xRet := U_UNICTCLI("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,nOperation,xOrig,SA1->A1_TIPO,SA1->A1_CONTRIB,SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_SUFRAMA,SA1->A1_SIMPNAC,SA1->A1_PAIS,.T.)
        EndIf


    EndIf

Return xRet





