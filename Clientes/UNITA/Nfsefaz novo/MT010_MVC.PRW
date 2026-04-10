#include "protheus.ch"
#include "parmtype.ch"

User Function ITEM()
	Local aParam   := PARAMIXB
	Local oModel   := FwModelActive()
	Local oObj     := ""
	Local cIdPonto := ""
	Local cIdModel := ""
	Local lIsGrid  := .F.
	Local xRet     := .T.
	Local nCont    := 0
	Local cB1_TIPO := ""


	//Alert('entrou no ponto de entrada MT010_MVC')

	if cEmpAnt == "01" .or. cEmpant == "02"  .or. cEmpant == "04"

		// VERIFICA SE APARAM NÃO ESTÁ NULO
		If aParam <> NIL
			oObj := aParam[1]
			cIdPonto := aParam[2]
			cIdModel := aParam[3]
			lIsGrid := (Len(aParam) > 3)

			//  VERIFICA SE O PONTO EM QUESTÃO É O FORMPOS
			If cIdPonto == "MODELCOMMITTTS"  //MODELCOMMITNTTS //MODELCOMMITTTS

				nOper := oObj:nOperation

				// VERIFICA SE OMODEL NÃO ESTÁ NULO
				If oModel <> NIL

					cB1_GRUPO := oModel:GetModel("SB1MASTER"):GetValue("B1_GRUPO")

					nCont := 0



					//Busco Descricao grupo
					dbSelectArea("SBM")
					dbSetOrder(1)
					dbGoTop()
					if !dbseek(xFilial("SBM")+cB1_GRUPO)
						alert("Grupo não encontrado!")
						return(.t.)
					endif

					cB1_GRUPO := alltrim(cB1_GRUPO)

					For nCont := 1 to len(cB1_GRUPO)
						if substr(cB1_GRUPO, nCont,1) <> "0"
							cB1_GRUPO := substr(cB1_GRUPO, nCont,4)
							exit
						endif
					next nCont

					cGrupoDesc := SBM->BM_DESC

					cJson := '{'
					cJson +='"codigoFamilia": "' + alltrim(cB1_GRUPO) + '", '
					cJson +='"descricao": "' + alltrim(cGrupoDesc) + '" '
					cJson += '}'

					//Chamo integração API TELECONTROL
					cRetorno := U_ACT020(cJson,"familias")
					//cRetorno := U_ACT020(cJson,"/posvenda-core/familias/", "POST")

					if substr(ALLTRIM(oModel:GetModel("SB1MASTER"):GetValue("B1_COD")),1,1) == "1" .OR.;
							substr(ALLTRIM(oModel:GetModel("SB1MASTER"):GetValue("B1_COD")),1,1) == "4" .OR.;
							substr(ALLTRIM(oModel:GetModel("SB1MASTER"):GetValue("B1_COD")),1,1) == "5"



						cJson := '{'
						cJson +='"descricao": "' + alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_DESC") ) + '", '
						cJson +='"referencia": "' + alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_COD") ) + '", '
						cJson +='"codigoFamilia": "' + alltrim(cB1_GRUPO ) + '", '
						cJson +='"codigoLinha": "' + ALLTRIM(oModel:GetModel("SB1MASTER"):GetValue("B1_ZLINHA"))  + '", '
						cJson +='"garantia": "' + ALLTRIM(STR(oModel:GetModel("SB1MASTER"):GetValue("B1_ZGARANT")))  + '" , '
						cJson +='"maoDeObra": "0" , '
						cJson +='"maoDeObraAdmin": "0" , '
						cJson +='"numeroSerieObrigatorio": true  '
						cJson += '}'


						conout("Parou aqui")





						//Add por Erick - 08/08/23

						If nOper == 3
							cRetorno := U_ACT020(cJson,"/posvenda-core/produtos", "POST")
						else
							cRetorno := U_ACT020(cJson,"/posvenda-core/produtos/referencia/" +  alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_COD") ) , "PUT")
						endif






					elseif substr(ALLTRIM(oModel:GetModel("SB1MASTER"):GetValue("B1_COD")),1,1) == "2"

						cJson := '{'
						cJson +='"descricao": "' + alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_DESC") ) + '", '
						cJson +='"referencia": "' + alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_COD") ) + '", '
						cJson +='"ipi": ' + alltrim(str(round(oModel:GetModel("SB1MASTER"):GetValue("B1_IPI"),0 ))) + ', '
						cJson +='"multiplo": ' + STR(oModel:GetModel("SB1MASTER"):GetValue("B1_ZMULRIP"))  + ', '
						cJson +='"devolucaoObrigatoria": false , '
						cJson +='"garantiaDiferenciada": null , '
						cJson +='"numeroSeriePeca": true , '
						//cJson +='"devolucaoObrigatoria": false , '
						cJson +='"acessorio": null , '
						cJson +='"itemAparencia": false , '
						cJson +='"origem": "IMP" , '
						cJson +='"ativo": true , '
						cJson +='"bloqueadaVenda": false , '
						cJson +='"bloqueadaGarantia": true , '
						cJson +='"estoque": 0  '
						cJson += '}'

						//-If INCLUI
						//cRetorno := U_ACT020(cJson,"/posvenda-core/peca/", "POST")
						//else
						cRetorno := U_ACT020(cJson,"/posvenda-core/peca/referencia/" +  alltrim(oModel:GetModel("SB1MASTER"):GetValue("B1_COD") ) , "PUT")



						conout("fim atualizacao")
						//endif


					endif

				EndIf
    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    		//³ MCS - Chamada para o configurador de perfis                         ³
    		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf cIdPonto == "MODELCOMMITNTTS"
                U_MCSTRIB()
			EndIf

		EndIf

	Endif
Return .T.
