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
    //Local xFacAuto      := GetMV("MV_FACAUTO")

    
    If aParam <> NIL
        oObj        := aParam[1]
        cIDPonto    := aParam[2]
        cIDModel    := aParam[3]
        lIsGrid     := (Len(aParam) > 3)
        nOperation := oObj:GetOperation()

        If cIDPonto == 'MODELCOMMITTTS'
            // Mostra o tipo de Operacao
            
            // Inclusao
            If nOperation == 3
                U_CTRIB01("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB)
            EndIf

            // Alteracao
            If nOperation == 4
                U_CTRIB01("","",SA1->A1_COD, SA1->A1_LOJA, SA1->A1_GRPTRIB,'4')
            EndIf

            // Exclusao
            If nOperation == 5
            EndIf

        EndIf

    EndIf

Return xRet





