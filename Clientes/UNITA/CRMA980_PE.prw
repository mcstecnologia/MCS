#include "TOTVS.ch"
#include "FWMVCDEF.ch"

// *********************************************************************** //
// CRMA980 - Ponto de entrada para rotina em MVC de clientes               //
// @copyright (c) 2021-06-30 > Marcelo da Cunha > GDVIEW                   //
// *********************************************************************** //

User Function CRMA980()
    *******************
	Local xRetu 	:= .T.
	Local aParam 	:= PARAMIXB //Parametros
	Local lIsGrid       := .F.
    Local cIDPonto      := ''
    Local cIDModel      := ''
    Local oObj          := NIL
	///////////////////////////////
	If (aParam != Nil).and.(Len(aParam) >= 3).and.(Alltrim(aParam[2]) == "BUTTONBAR")
		xRetu := {{"Historico","OPEN",{|| openHistoric(aParam) }}}
	Elseif (aParam != Nil).and.(Len(aParam) >= 3).and.(Alltrim(aParam[2]) == "FORMCOMMITTTSPRE")
		If ExistBlock("GDVHCOMPARA")
			u_GDVHCompara("SA1")
		Endif
	///////////////////////////////
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё MCS - Chamada para o configurador de perfils                        Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ElseIf aParam <> NIL
		oObj        := aParam[1]
        cIDPonto    := aParam[2]
        cIDModel    := aParam[3]
        lIsGrid     := (Len(aParam) > 3)
        nOperation := oObj:GetOperation()

		If cIDPonto == "MODELCOMMITNTTS"
            xRetu := U_MCSTRIB()
        EndIf
		
	EndIf

Return xRetu

Static Function openHistoric(xParam)
	********************************
	If ExistBlock("GDVHISTMAN") //Verifico rotina GDVHISTMAN
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+xParam[1]:GetValue("SA1MASTER","A1_COD")+xParam[1]:GetValue("SA1MASTER","A1_LOJA"),.T.))
		u_GDVHistMan("SA1")
	Endif
Return
