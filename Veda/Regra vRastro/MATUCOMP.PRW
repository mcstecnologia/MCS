#include "protheus.ch"
#include 'totvs.ch'

/*/{Protheus.doc} MATUCOMP
Gera registros nas tabelas complementares
@type function
@version  
@author MCS Tecnologia
@since 12/9/2025
@return variant, return_description
/*/
User Function MATUCOMP()

	Local cEntSai   := ParamIXB[1] // E=Entrada ou S=Saida
	Local cSerie    := ParamIXB[2] // Serie do documento fiscal
	Local cDoc      := ParamIXB[3] // Numero do documento
    Local aArea     := SF2->(GetArea())
    Local lAtv      := SuperGetMV("VD_ATVRAST",.F.,.T.)
    Local xParCli   := SuperGetMV("VD_CLIRAST",.F.,"000001")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Caso ativado, executa processo de gravação do complemento           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lAtv
        SF2->(dbSetOrder(1))
        SF2->(msSeek(xFilial("SF2")+cDoc+cSerie))
        If Alltrim(SF2->F2_CLIENTE) $ xParCli .Or. Empty(xParCli)
            U_GRVCMP(cFilAnt, cDoc, cSerie, cEntSai, SF2->F2_ESPECIE)
        EndIf
    EndIf

    RestArea(aArea)

Return
