#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#include "TOPCONN.CH"

/*/{Protheus.doc} MCS001
Geração relatorio de conferencia Fiscal em Excel
@type function
@author Wemerson Randolfo Bastos    
@since 25/03/2025
@version 1.0
*/
User Function MCS001
    
    Local oDlg1
    Local oBtn1
    Local oBtn2   
    Local oFont      := TFont():New("ARIAL",08,16)

	Private cMensagem := ""	
	Private  cTitulo	:= 'MCS001'

    oDlg1      := MSDialog():New( 274,449,449,980,"Relatorio de Apuração",,,.F.,,,,,,.T.,,,.T. )
    oBtn1      := TButton():New( 028,012,"Gerar Planilha",oDlg1,{|| F001()},076,028,,,,.T.,,"",,,,.F. )
    //oBtn2      := TButton():New( 028,096,"OUTRO BOTAO",oDlg1,{|| F002()},076,028,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 028,180,"Cancelar",oDlg1,{|| oDlg1:End() },076,028,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} F001
Chama Função principal
@type function
@author Wemerson Randolfo Bastos    
@since 26/03/2025
@version 1.0
*/
Static Function F001()	
    

    If Perg1()

		FWMsgRun(, {|| F003() }, "Aguarde, gerando planilha...")

	EndIf		

Return


/*/{Protheus.doc} Perg1
Monta as perguntas da tela
@type function
@author Wemerson Randolfo Bastos    
@since 26/03/2025
@version 1.0
*/
Static Function Perg1()

	Local aPergs 	:= {}	
	Local dData1 	:= CtoD("//")
  	Local dData2 	:= CtoD("//")
	Local cFil1		:= Space(TamSX3("FT_FILIAL")[1])
	Local cFil2		:= Space(TamSX3("FT_FILIAL")[1])
	Local lRet    
	Local aRet := {}
	
	
  	aAdd( aPergs ,{1,"Data de ",dData1,"@!",'.T.',"",'.T.',50,.F.})   
	aAdd( aPergs ,{1,"Data até	: "	,dData2,"@!",'.T.',"",'.T.',50,.F.})  

	aAdd( aPergs ,{1,"Filial de	: "	,cFil1,"@!",'.T.',"",'.T.',50,.F.})  
	aAdd( aPergs ,{1,"Filial de	: "	,cFil2,"@!",'.T.',"",'.T.',50,.F.})  

	If ParamBox(aPergs ,"[MCS001] Parametros",aRet)
		lRet := .T.   
	Else      
		lRet := .F.   
	EndIf

Return lRet	




/*/{Protheus.doc} F002
Montagem da query
@type function
@author Wemerson Randolfo Bastos    
@since 26/03/2025
@version 1.0
*/
Static Function F002

	Local cQuery1 := ""
	Local cQuery1 := ""
	Local cQuery2 := ""
	Local aAliasQry := GetNextAlias()
	Local xQuery  := ""
	
	Local dData1 := MV_PAR01
	Local dData2 := MV_PAR02
	Local cFil1 := MV_PAR03
	Local cFil2 := MV_PAR04

	xQuery := "SELECT "+ chr(13)
	xQuery += "    CASE WHEN FT.FT_TIPOMOV = 'S' THEN 'SAIDA' ELSE 'ENTRADA' END AS MOVIMENTO, "+ chr(13)
	xQuery += "    FT.FT_FILIAL AS FILIAL, "+ chr(13)
	xQuery += "    TO_DATE(FT.FT_ENTRADA, 'YYYYMMDD') AS DT_ENTRADA, "+ chr(13)
	xQuery += "    TO_DATE(FT.FT_EMISSAO, 'YYYYMMDD') AS DT_EMISSAO, "+ chr(13)
	xQuery += "    FT.FT_DTCANC AS DT_CANCELAMENTO, "+ chr(13)
	xQuery += "    FT.FT_NFISCAL AS NOTA_FISCAL, "+ chr(13)
	xQuery += "    FT.FT_SERIE AS SERIE, "+ chr(13)
	xQuery += "    FT.FT_CHVNFE AS CHAVE_ELETRONICA, "+ chr(13)
	xQuery += "    (SELECT MAX(F3_CODRSEF) FROM " + RetSqlName("SF3") + " SF3 "+ chr(13) 
	xQuery += "     WHERE SF3.F3_FILIAL = FT.FT_FILIAL "+ chr(13) 
	xQuery += "       AND SF3.F3_NFISCAL = FT.FT_NFISCAL "+ chr(13)
	xQuery += "       AND SF3.F3_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "       AND SF3.F3_CLIEFOR = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "       AND SF3.F3_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "       AND SF3.F3_CFO = CASE WHEN FT.FT_TIPOMOV = 'S' THEN '5000' ELSE '4999' END "+ chr(13)
	xQuery += "       AND SF3.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "       AND ROWNUM = 1) AS RETORNO_SEFAZ, "+ chr(13) 
	xQuery += "    FT.FT_CLIEFOR AS CLI_FOR, "+ chr(13)
	xQuery += "    FT.FT_LOJA AS LOJA, "+ chr(13)
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13)
	xQuery += "            THEN CLIENTE.A1_NOME "+ chr(13)
	xQuery += "        ELSE FORNECEDOR.A2_NOME "+ chr(13)
	xQuery += "    END AS RAZAO_SOCIAL, "+ chr(13)
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13)
	xQuery += "            THEN CLIENTE.A1_CGC "+ chr(13)
	xQuery += "        ELSE FORNECEDOR.A2_CGC "+ chr(13)
	xQuery += "    END AS CNPJ, "+ chr(13)   
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13) 
	xQuery += "            THEN CLIENTE.A1_INSCR "+ chr(13)
	xQuery += "        ELSE FORNECEDOR.A2_INSCR "+ chr(13)
	xQuery += "    END AS INSCR_ESTADUAL, "+ chr(13)
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13)
	xQuery += "            THEN CASE WHEN CLIENTE.A1_CONTRIB = '1' THEN 'Sim' WHEN CLIENTE.A1_CONTRIB = '2' THEN 'Não' ELSE ' ' END "+ chr(13)
	xQuery += "        ELSE CASE WHEN FORNECEDOR.A2_CONTRIB = '1' THEN 'Sim' WHEN FORNECEDOR.A2_CONTRIB = '2' THEN 'Não' ELSE ' ' END "+ chr(13)
	xQuery += "    END AS CONTRIBUINTE, "+ chr(13)
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13)
	xQuery += "            THEN CLIENTE.A1_GRPTRIB "+ chr(13)
	xQuery += "        ELSE FORNECEDOR.A2_GRPTRIB "+ chr(13)
	xQuery += "    END AS GR_TRIB_CLI_FOR, "+ chr(13) 
	xQuery += "    CASE "+ chr(13)
	xQuery += "        WHEN (FT.FT_TIPOMOV = 'S' AND FT.FT_TIPO NOT IN ('D','B')) OR (FT.FT_TIPOMOV = 'E' AND FT.FT_TIPO IN ('D','B')) "+ chr(13)
	xQuery += "            THEN CLIENTE.A1_MUN "+ chr(13)
	xQuery += "        ELSE FORNECEDOR.A2_MUN "+ chr(13)
	xQuery += "    END AS MUNICIPIO, "+ chr(13)  
	xQuery += "    FT.FT_ESTADO AS ESTADO, "+ chr(13)
	xQuery += "    FT.FT_ESPECIE AS ESPECIE, "+ chr(13)
	xQuery += "    CASE FT.FT_TIPO "+ chr(13)
	xQuery += "        WHEN 'N' THEN 'Normal' "+ chr(13)
	xQuery += "        WHEN 'D' THEN 'Devolução' "+ chr(13)
	xQuery += "        WHEN 'B' THEN 'Beneficiamento' "+ chr(13)
	xQuery += "        WHEN 'I' THEN 'Complemento de Icms' "+ chr(13)
	xQuery += "        WHEN 'P' THEN 'Complemento de Ipi' "+ chr(13)
	xQuery += "        WHEN 'C' THEN 'Complemento de preço' "+ chr(13)
	xQuery += "        WHEN 'S' THEN 'Serviço' "+ chr(13)
	xQuery += "        ELSE 'Normal' "+ chr(13)
	xQuery += "    END AS TIPO_NF, "+ chr(13)
	xQuery += "    CASE WHEN F4.F4_DUPLIC = 'S' THEN 'SIM' ELSE 'NÃO' END AS DUPLICATA, "+ chr(13)
	xQuery += "    FT.FT_NRLIVRO AS LIVRO, "+ chr(13)
	xQuery += "    FT.FT_TES AS T_E_S, "+ chr(13)
	xQuery += "    FT.FT_CFOP AS CFOP, "+ chr(13)
	xQuery += "    FT.FT_NFORI AS NF_ORIGINAL, "+ chr(13)
	xQuery += "    FT.FT_ITEM AS ITEM, "+ chr(13)
	xQuery += "    FT.FT_PRODUTO AS PRODUTO, "+ chr(13)
	xQuery += "    B1.B1_DESC AS DESCRICAO, "+ chr(13)
	xQuery += "    B1.B1_GRTRIB AS GR_TRIB_PROD, "+ chr(13)
	xQuery += "    B1.B1_UM AS UNID, "+ chr(13)
	xQuery += "    CASE WHEN FT.FT_TIPOMOV = 'S' THEN "+ chr(13)
	xQuery += "        (SELECT MAX(D2_LOCAL) FROM " + RetSqlName("SD2") + " SD2 "+ chr(13)
	xQuery += "         WHERE SD2.D2_FILIAL = FT.FT_FILIAL "+ chr(13) 
	xQuery += "           AND SD2.D2_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "           AND SD2.D2_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "           AND SD2.D2_CLIENTE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "           AND SD2.D2_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "           AND SD2.D2_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "           AND SD2.D2_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "           AND SD2.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "           AND ROWNUM = 1) "+ chr(13)
	xQuery += "    ELSE "+ chr(13)
	xQuery += "        (SELECT MAX(D1_LOCAL) FROM " + RetSqlName("SD1") + " SD1 "+ chr(13)
	xQuery += "         WHERE SD1.D1_FILIAL = FT.FT_FILIAL "+ chr(13)
	xQuery += "           AND SD1.D1_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "           AND SD1.D1_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "           AND SD1.D1_FORNECE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "           AND SD1.D1_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "           AND SD1.D1_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "           AND SD1.D1_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "           AND SD1.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "           AND ROWNUM = 1) "+ chr(13)
	xQuery += "    END AS ARMAZEM, "+ chr(13)  
	xQuery += "    FT.FT_POSIPI AS N_C_M, "+ chr(13)
	xQuery += "    FT.FT_CLASFIS AS SIT_TRIB_ICMS, "+ chr(13)
	xQuery += "    FT.FT_CSTPIS AS CST_PIS, "+ chr(13)
	xQuery += "    FT.FT_CSTCOF AS CST_COFINS, "+ chr(13)
	xQuery += "    FT.FT_VALCONT AS VL_CONTABIL, "+ chr(13)
	xQuery += "    FT.FT_BASEICM AS BASE_ICMS, "+ chr(13)
	xQuery += "    FT.FT_ALIQICM AS ALIQ_ICMS, "+ chr(13)
	xQuery += "    FT.FT_VALICM AS VL_ICMS, "+ chr(13)
	xQuery += "    FT.FT_CRDPRES AS VL_PRESUMIDO, "+ chr(13)
	xQuery += "    FT.FT_BASEIPI AS BASE_IPI, "+ chr(13)
	xQuery += "    FT.FT_ALIQIPI AS ALIQ_IPI, "+ chr(13)
	xQuery += "    FT.FT_VALIPI AS VL_IPI, "+ chr(13)
	xQuery += "    FT.FT_BASERET AS BASE_ICMS_ST, "+ chr(13)
	xQuery += "    FT.FT_MARGEM AS MVA, "+ chr(13)
	xQuery += "    FT.FT_ICMSRET AS VL_ICMS_ST_DIFAL, "+ chr(13)
	xQuery += "    FT.FT_ICMSCOM AS DIFAL_ENTRADA, "+ chr(13)
	xQuery += "    FT.FT_DIFAL AS DIFAL_SAIDAS, "+ chr(13)
	xQuery += "    FT.FT_VFCPDIF AS FECP, "+ chr(13)
	xQuery += "    FT.FT_FRETE AS FRETE, "+ chr(13)
	xQuery += "    FT.FT_DESPESA AS DESPESAS, "+ chr(13)
	xQuery += "    FT.FT_BASEPIS AS BASE_PIS, "+ chr(13)
	xQuery += "    FT.FT_ALIQPIS AS ALIQ_PIS, "+ chr(13)
	xQuery += "    FT.FT_VALPIS AS VL_PIS, "+ chr(13)
	xQuery += "    FT.FT_BASECOF AS BASE_COFINS, "+ chr(13)
	xQuery += "    FT.FT_ALIQCOF AS ALIQ_COFINS, "+ chr(13)
	xQuery += "    FT.FT_VALCOF AS VL_COFINS, "+ chr(13) 
	xQuery += "    FT.FT_MVALCOF AS VL_COFINS_MAJORADO, "+ chr(13)
	xQuery += "    FT.FT_VALINS AS VAL_INSS_RET, "+ chr(13)
	xQuery += "    FT.FT_VRETPIS AS VL_PISRET, "+ chr(13)
	xQuery += "    FT.FT_VRETCOF AS VL_COFRET, "+ chr(13) 
	xQuery += "    FT.FT_VRETCSL AS VL_CSLRET, "+ chr(13)
	xQuery += "    FT.FT_VALIRR AS VL_IRRF, "+ chr(13)
	xQuery += "    FT.FT_RECISS AS ISS_RETIDO, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.CST_CBS AS SIT_TRIB_CST_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.BASE_CBS AS BASE_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.ALIQ_CBS AS ALIQUOTA_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.VAL_CBS AS VALOR_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_CBS AS TRIBUTO_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_ESCRITURACAO_CBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.CST_IBS AS SIT_TRIB_CST_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.BASE_IBS AS BASE_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.ALIQ_IBS AS ALIQUOTA_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.VAL_IBS AS VALOR_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_IBS AS TRIBUTO_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_ESCRITURACAO_IBS, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.CST_IM AS SIT_TRIB_CST_IM, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.BASE_IM AS BASE_IM, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.ALIQ_IM AS ALIQUOTA_IM, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.VAL_IM AS VALOR_IM, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_IM AS TRIBUTO_IM, "+ chr(13)
	xQuery += "    IMPOSTO_SAI.COD_ESCRITURACAO_IM, "+ chr(13)
	xQuery += "    CASE WHEN FT.FT_TIPOMOV = 'E' THEN "+ chr(13)
	xQuery += "        (SELECT MAX(D1_VALISS) FROM " + RetSqlName("SD1") + " SD1 "+ chr(13)
	xQuery += "         WHERE SD1.D1_FILIAL = FT.FT_FILIAL "+ chr(13)
	xQuery += "           AND SD1.D1_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "           AND SD1.D1_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "           AND SD1.D1_FORNECE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "           AND SD1.D1_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "           AND SD1.D1_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "           AND SD1.D1_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "           AND SD1.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "           AND ROWNUM = 1) "+ chr(13)
	xQuery += "    ELSE "+ chr(13)
	xQuery += "        (SELECT MAX(D2_VALISS) FROM " + RetSqlName("SD2") + " SD2 "+ chr(13)
	xQuery += "         WHERE SD2.D2_FILIAL = FT.FT_FILIAL "+ chr(13)
	xQuery += "           AND SD2.D2_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "           AND SD2.D2_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "           AND SD2.D2_CLIENTE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "           AND SD2.D2_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "           AND SD2.D2_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "           AND SD2.D2_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "           AND SD2.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "           AND ROWNUM = 1) "+ chr(13)
	xQuery += "    END AS VL_ISS "+ chr(13)
	xQuery += "FROM " + RetSqlName("SFT") + " FT "+ chr(13)
	xQuery += "INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_COD = FT.FT_PRODUTO AND B1.B1_FILIAL = ' ' AND B1.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "INNER JOIN " + RetSqlName("SF4") + " F4 ON F4.F4_CODIGO = FT.FT_TES AND F4.F4_FILIAL = FT.FT_FILIAL AND F4.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "LEFT JOIN " + RetSqlName("SA1") + " CLIENTE ON CLIENTE.A1_COD = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "                              AND CLIENTE.A1_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "                              AND CLIENTE.A1_FILIAL = ' ' "+ chr(13)
	xQuery += "                              AND CLIENTE.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "LEFT JOIN " + RetSqlName("SA2") + " FORNECEDOR ON FORNECEDOR.A2_COD = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "                                  AND FORNECEDOR.A2_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "                                  AND FORNECEDOR.A2_FILIAL = ' ' "+ chr(13)
	xQuery += "                                  AND FORNECEDOR.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "LEFT JOIN " + RetSqlName("SD2") + " SD_SAI ON SD_SAI.D2_FILIAL = FT.FT_FILIAL "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_CLIENTE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "                              AND SD_SAI.D2_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "                              AND SD_SAI.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "                              AND FT.FT_TIPOMOV = 'S' "+ chr(13)
	xQuery += "LEFT JOIN " + RetSqlName("SD1") + " SD_ENT ON SD_ENT.D1_FILIAL = FT.FT_FILIAL "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_DOC = FT.FT_NFISCAL "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_SERIE = FT.FT_SERIE "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_FORNECE = FT.FT_CLIEFOR "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_LOJA = FT.FT_LOJA "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_COD = FT.FT_PRODUTO "+ chr(13)
	xQuery += "                              AND SD_ENT.D1_ITEM = FT.FT_ITEM "+ chr(13)
	xQuery += "                              AND SD_ENT.D_E_L_E_T_ <> '*' "+ chr(13)
	xQuery += "                              AND FT.FT_TIPOMOV = 'E' "+ chr(13)
	xQuery += "LEFT JOIN ( "+ chr(13)
	xQuery += "    SELECT "+ chr(13)
	xQuery += "        F2D.F2D_FILIAL, "+ chr(13)
	xQuery += "        F2D.F2D_IDREL, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN CJ3.CJ3_CST END) AS CST_CBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_CBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN CJ3.CJ3_TRIB END) AS COD_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN CJ3.CJ3_CST END) AS CST_IBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_IBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN CJ3.CJ3_TRIB END) AS COD_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN CJ3.CJ3_CST END) AS CST_IM, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_IM, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN CJ3.CJ3_TRIB END) AS COD_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_IM "+ chr(13)
	xQuery += "    FROM " + RetSqlName("F2D") + " F2D "+ chr(13)
	xQuery += "    JOIN " + RetSqlName("CJ3") + " CJ3 ON CJ3.CJ3_FILIAL = F2D.F2D_FILIAL "+ chr(13)
	xQuery += "                          AND CJ3.CJ3_IDF2D = F2D.F2D_ID "+ chr(13)
	xQuery += "                          AND CJ3.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "    JOIN " + RetSqlName("F2B") + " F2B ON F2B.F2B_FILIAL = CJ3.CJ3_FILIAL "+ chr(13)
	xQuery += "                          AND F2B.F2B_REGRA = CJ3.CJ3_TRIB "+ chr(13)
	xQuery += "    WHERE F2D.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "    GROUP BY F2D.F2D_FILIAL, F2D.F2D_IDREL "+ chr(13)
	xQuery += ") IMPOSTO_SAI ON IMPOSTO_SAI.F2D_FILIAL = SD_SAI.D2_FILIAL "+ chr(13) 
	xQuery += "             AND IMPOSTO_SAI.F2D_IDREL = SD_SAI.D2_IDTRIB "+ chr(13)
	xQuery += "LEFT JOIN ( "+ chr(13)
	xQuery += "    SELECT "+ chr(13) 
	xQuery += "        F2D.F2D_FILIAL, "+ chr(13)
	xQuery += "        F2D.F2D_IDREL, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN CJ3.CJ3_CST END) AS CST_CBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_CBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN CJ3.CJ3_TRIB END) AS COD_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%CB%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_CBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN CJ3.CJ3_CST END) AS CST_IBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_IBS, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN CJ3.CJ3_TRIB END) AS COD_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IB%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_IBS, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN CJ3.CJ3_CST END) AS CST_IM, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_BASE ELSE 0 END) AS BASE_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_ALIQ ELSE 0 END) AS ALIQ_IM, "+ chr(13)
	xQuery += "        SUM(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2D.F2D_VALOR ELSE 0 END) AS VAL_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN CJ3.CJ3_TRIB END) AS COD_IM, "+ chr(13)
	xQuery += "        MAX(CASE WHEN CJ3.CJ3_TRIB LIKE '%IM%' THEN F2B.F2B_CODESC END) AS COD_ESCRITURACAO_IM "+ chr(13)
	xQuery += "    FROM " + RetSqlName("F2D") + " F2D "+ chr(13)
	xQuery += "    JOIN " + RetSqlName("CJ3") + " CJ3 ON CJ3.CJ3_FILIAL = F2D.F2D_FILIAL "+ chr(13)
	xQuery += "                          AND CJ3.CJ3_IDF2D = F2D.F2D_ID "+ chr(13)
	xQuery += "                          AND CJ3.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "    JOIN " + RetSqlName("F2B") + " F2B ON F2B.F2B_FILIAL = CJ3.CJ3_FILIAL "+ chr(13)
	xQuery += "                          AND F2B.F2B_REGRA = CJ3.CJ3_TRIB "+ chr(13)
	xQuery += "    WHERE F2D.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "    GROUP BY F2D.F2D_FILIAL, F2D.F2D_IDREL "+ chr(13)
	xQuery += ") IMPOSTO_ENT ON IMPOSTO_ENT.F2D_FILIAL = SD_ENT.D1_FILIAL "+ chr(13) 
	xQuery += "             AND IMPOSTO_ENT.F2D_IDREL = SD_ENT.D1_IDTRIB "+ chr(13)
	xQuery += "WHERE FT_FILIAL  BETWEEN '" + cFil1 + "' AND '" + cFil2 + "'  "+ chr(13)
	xQuery += "  AND FT.D_E_L_E_T_ = ' ' "+ chr(13)
	xQuery += "  AND FT.FT_TIPOMOV IN ('E','S') "+ chr(13)
	xQuery += "  AND FT_ENTRADA BETWEEN '" + DtoS(dData1) + "' AND '" +  DtoS(dData2)  + "'  "+ chr(13)
	xQuery += "ORDER BY FT.FT_TIPOMOV, FT.FT_FILIAL, FT.FT_ENTRADA, FT.FT_NFISCAL, FT.FT_SERIE, FT.FT_ITEM"

	//cQuery := cQuery1 + cQuery2

	MpSysOpenQuery(xQuery, aAliasQry)

	//DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aAliasQry,.F.,.T.)
	//TcSetField(aAliasQry,'D1_EMISSAO','D')	
	(aAliasQry)->(DbGoTop())


Return aAliasQry



/*/{Protheus.doc} F003
ALimenta a planilha
@type function
@author Wemerson Randolfo Bastos    
@since 26/03/2025
@version 1.0
*/

Static Function F003


    Local oFWMsExcel
    Local oExcel
    Local cArquivo    	:= GetTempPath()+'teste.xml'
	Local cTituloTab	:= "Apuração Fiscal"
	Local cNomeTab 		:= "Apuração"
	Local _ArqWeb
    Local xTime         := ""
    Local xData         := ""
	Local xArquivo      := ""

	xTime     := Replace(Time(),":","")
    xData     := dtos(dDataBase)

    xArquivo := "fechamento"+"_"+xData+"_"+xTime+".xls"

	cAlias := F002()

	//Começo a criação da planilha
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 -
	oFWMsExcel:AddworkSheet(cNomeTab) //Não utilizar número junto com sinal de menos. Ex.: 1-
	//Criando a Tabela
	oFWMsExcel:AddTable(cNomeTab,cTituloTab)
	//Criando Colunas
	
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"MOVIMENTO",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"FILIAL",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DT ENTRADA",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DT EMISSAO",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DT CANC",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"NF",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"SERIE NF",1,1) 

	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CHAVE",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"RETORNO_SEFAZ",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CLI_FOR",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"LOJA",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"RAZAO_SOCIAL",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CNPJ",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"INSC_ESTADUAL",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CONTRIBUINTEF",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"GRP_TRIB_CLI_FOR",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"MUNICIPIO",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ESTADO",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ESPECIE",1,1)   
	
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"TIPO_NF",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DUPLICATA",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"LIVRO",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"TES",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CFOP",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"NF_ORIGINAL",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ITEM",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"PRODUTO",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DESCRICAO",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"GR_TRIB_PROD",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"UNID",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ARMAZEM",1,1)  

	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"NCM",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"SIT_TRIB_ICMS",1,1) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CST_PIS",1,1)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"CST_COFINS",1,1)
	
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_CONTABIL",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"BASE_ICMS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ALIQ_ICMS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_ICMS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_PRESUMIDO",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"BASE_IPI",2,2) 
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ALIQ_IPI",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_IPI",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"BASE_ICMS_ST",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"MVA",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_ICMS_ST_DIFAL",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DIFAL_ENTRADA",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DIFAL_SAIDAS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"FECP",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"FRETE",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"DESPESAS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"BASE_PIS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ALIQ_PIS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_PIS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"BASE_COFINS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ALIQ_COFINS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_COFINS",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_COFINS_MAJORADO",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VAL_INSS_RET",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_PISRET",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_COFRET",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_CSLRET",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_IRRF",2,2)
	oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"VL_ISS",2,2)
	oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cst CBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Base CBS", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Aliq CBS", 2, 2, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Vlr CBS", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod CBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod Escri CBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cst IBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Base IBS", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Aliq IBS", 2, 2, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Vlr IBS", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod IBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod Escri IBS", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "CST IM", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Base IM", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Aliq IM", 2, 2, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Vlr IM", 3, 3, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod IM", 1, 1, .F.)
    oFWMsExcel:AddColumn(cNomeTab, cTituloTab, "Cod Escri IM", 1, 1, .F.)
	//oFWMsExcel:AddColumn(cNomeTab,cTituloTab,"ISS_RETIDO",2,2)

	While !(cAlias)->(Eof())

		//Criando as Linhas
		oFWMsExcel:AddRow(cNomeTab,cTituloTab,{;
							(cAlias)->MOVIMENTO,;
							(cAlias)->FILIAL,;
							(cAlias)->DT_ENTRADA,;
							(cAlias)->DT_EMISSAO,;
							(cAlias)->Dt_CANCELAMENTO,;
							(cAlias)->NOTA_FISCAL,;
							(cAlias)->SERIE,;
							(cAlias)->CHAVE_ELETRONICA,;
							(cAlias)->RETORNO_SEFAZ,;
							(cAlias)->CLI_FOR,;
							(cAlias)->LOJA,;
							(cAlias)->RAZAO_SOCIAL,;
							(cAlias)->CNPJ,;
							(cAlias)->INSCR_ESTADUAL,;
							(cAlias)->CONTRIBUINTE,;
							(cAlias)->GR_TRIB_CLI_FOR,;
							(cAlias)->MUNICIPIO,;
							(cAlias)->ESTADO,;
							(cAlias)->ESPECIE,;
							(cAlias)->TIPO_NF,;
							(cAlias)->DUPLICATA,;
							(cAlias)->LIVRO,;
							(cAlias)->T_E_S,;
							(cAlias)->CFOP,;
							(cAlias)->NF_ORIGINAL,;
							(cAlias)->ITEM,;
							(cAlias)->PRODUTO,;
							(cAlias)->DESCRICAO,;
							(cAlias)->GR_TRIB_PROD,;
							(cAlias)->UNID,;
							(cAlias)->ARMAZEM,;
							(cAlias)->N_C_M,;
							(cAlias)->SIT_TRIB_ICMS,;
							(cAlias)->CST_PIS,;
							(cAlias)->CST_COFINS,;
							(cAlias)->VL_CONTABIL,;
							(cAlias)->BASE_ICMS,;
							(cAlias)->ALIQ_ICMS,;
							(cAlias)->VL_ICMS,;
							(cAlias)->VL_PRESUMIDO,;
							(cAlias)->BASE_IPI,;
							(cAlias)->ALIQ_IPI,;
							(cAlias)->VL_IPI,;
							(cAlias)->BASE_ICMS_ST,;
							(cAlias)->MVA,;
							(cAlias)->VL_ICMS_ST_DIFAL,;
							(cAlias)->DIFAL_ENTRADA,;
							(cAlias)->DIFAL_SAIDAS,;
							(cAlias)->FECP,;
							(cAlias)->FRETE,;
							(cAlias)->DESPESAS,;
							(cAlias)->BASE_PIS,;
							(cAlias)->ALIQ_PIS,;
							(cAlias)->VL_PIS,;
							(cAlias)->BASE_COFINS,;
							(cAlias)->ALIQ_COFINS,;
							(cAlias)->VL_COFINS,;
							(cAlias)->VL_COFINS_MAJORADO,;
							(cAlias)->VAL_INSS_RET,;
							(cAlias)->VL_PISRET,;
							(cAlias)->VL_COFRET,;
							(cAlias)->VL_CSLRET,;
							(cAlias)->VL_IRRF,;
							(cAlias)->VL_ISS,;
							(cAlias)->SIT_TRIB_CST_CBS,;
							(cAlias)->BASE_CBS,;
							(cAlias)->ALIQUOTA_CBS,;
							(cAlias)->VALOR_CBS,;
							(cAlias)->TRIBUTO_CBS,;
							(cAlias)->COD_ESCRITURACAO_CBS,;
							(cAlias)->SIT_TRIB_CST_IBS,;
							(cAlias)->BASE_IBS,;
							(cAlias)->ALIQUOTA_IBS,;
							(cAlias)->VALOR_IBS,;
							(cAlias)->TRIBUTO_IBS,;
							(cAlias)->COD_ESCRITURACAO_IBS,;
							(cAlias)->SIT_TRIB_CST_IM,;
							(cAlias)->BASE_IM,;
							(cAlias)->ALIQUOTA_IM,;
							(cAlias)->VALOR_IM,;
							(cAlias)->TRIBUTO_IM,;
							(cAlias)->COD_ESCRITURACAO_IM})
		

		
		(cAlias)->(DbSkip())				
	End


	//Ativando o arquivo e gerando o xml
	/*oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             	//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas*/

	oFWMsExcel:Activate()
    //oFWMsExcel:GetXMLFile(xArquivo)
    oFWMsExcel:GetXMLFile("\"+xArquivo)
    _ArqWeb := "\"+xArquivo
    If GetRemoteType() = 5 //-- WebAgent não está atuvo
        _nRet   := CpyS2TW(_ArqWeb, .T.)
        FWAlertSuccess("Agente local não habilitado no seu navegador, com isso não será possível abrir automaticamente o arquivo, arquivo disponível para download no navegador", "PIS/COFINS")
    Else  //getremotetype() = 1 -- webagent ativo
         _nRet   := CpyS2T(_ArqWeb, "C:\TEMP")
        oExcel := MsExcel():New()
        oExcel:WorkBooks:Open("C:\Temp\"+xArquivo)
        oExcel:SetVisible(.T.)
        oExcel:Destroy()
        FWAlertSuccess("Arquivo(s) copiado(s) para C:\TEMP\", "PIS/COFINS")
    EndIf

	(cAlias)->(DbCloseArea())
	
Return 
