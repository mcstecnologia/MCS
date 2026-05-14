#include "TOTVS.ch"        // incluido pelo assistente de conversao do AP6 IDE em 24/04/02


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103CLAS    บ Autor ณ JONAS KOSLOWSKI  บ Data ณ  09-06-20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ MANIPULA OS ITENS DA ACOLS                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EXCLUSIVO PARA NOTA FISCAL DE IMPORTAวรO GERADA PELA        ฑฑ
ฑฑ             ROTNA DA AFILL, IRม ALTERAR A TES,CFOP E SIT. TRIB          ฑฑ
ฑฑ             CONFORME ESTA NO PEDIDO DE COMPRAS.                         ฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function A103CLAS() 

Local cAliasSD1 := ParamIxb[1]
Local aArea := GetArea()
Local cICMPAD:= GetMv('MV_ICMPAD')
Local cTSTRANSP:= GetMv('MV_TSTRANS') // TES que sera utilizado para nota filha(transporte) de importacao

Local cD1TES      := aSCAN(aHEADER,{|x| ALLTRIM(x[2]) == "D1_TES"})
Local cD1ITEM     := aSCAN(aHEADER,{|x| ALLTRIM(x[2]) == "D1_ITEM"})
Local cD1LOCAL    := aSCAN(aHEADER,{|x| ALLTRIM(x[2]) == "D1_LOCAL"})

//27/03/2025 - Personalitec
Local nDESPESA    := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_DESPESA"}) 
Local nXDICM      := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_XDICM"}) 
Local nBASEICM    := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_BASEICM"}) 
Local nVALICM     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_VALICM"}) 
Local nICMCOMP    := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ICMSCOM"})  
Local nXVALI      := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_XVALII"}) 
Local nAliqCOMP   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ALIQCMP"}) 
Local nConhec     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CONHEC"}) //processo AFILL
Local lNovaTrat   := SuperGetMv("BD_AFIL103",.F.,.F.) //parametro que ativa a nova tratativa de processos vindos da Afill

Local dDATA       := DTOS(DDEMISSAO)
Local cCliDifalSC := GetNewPar("MV_XCLIDIF", "00391701#00504301")
Local cMVFORNEAF  := GetMv("MV_FORNEAF") //27/03/2025  - Personalitec - Marcelo definiu para usar este parโmetro
Local aRet        := {}

Private cItem:=''

/*
Caso o parโmetro BD_AFIL103 estiver habilitado serแ efetuado as novas tratativas.
Caso esteja desabilitado mant้m a tratativa jแ existente.
*/
If lNovaTrat //.and. FunName() != 'UZXIMP'  
     If   cEmpant == '01'

          /*Foi necessแrio retirar esta valida็ใo pois quando o processo de classifica็ใo ้ feito pelo Afill, 
          nใo assume os valores gerados neste ponto de entrada*/
          //If  FunName()=='UZXIMP' 
          
          /*Aqui foi efetuado esta valida็ใo para considerar somente processos provenientes da Afiil, 
          para evitar que seja efetuado estes ajustes nas demais classifica็๕es que nใo seja referente a Afill*/
          If !Empty(aCols[Len(aCols),nConhec])
                         
               If (Select("TTA103A") <> 0)
                    TTA103A->(dbCloseArea())
               EndIf
               
               BeginSQL ALIAS "TTA103A"
                    SELECT F1_TIPO_NF,Z13_PEDIDO,C7_PRODUTO,C7_ITEM,C7_TES,F4_CF,(B1_ORIGEM+F4_SITTRIB) AS D1_CLASFIS,D1_CONHEC,D1_FORNECE,D1_DOC,D1_SERIE,D1_LOJA,D1_COD,D1_ITEM,F4_SITTRIB,
                         SUM((D1_QUANT*D1_VUNIT)/((100-D1_IPI)/100)) AS BASEICMS,Z12_NFILHA
                    FROM %TABLE:SD1% D1
                    INNER JOIN %TABLE:SF1%  F1  ON F1_FILIAL =  %xFilial:SF1% AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1.%NOTDEL%
                    INNER JOIN %TABLE:SB1%  B1  ON B1_FILIAL =  %xFilial:SB1% AND B1_COD=D1_COD       AND  B1.%NOTDEL%
                    INNER JOIN %TABLE:Z13%  Z13 ON Z13_FILIAL= %xFilial:Z13%  AND Z13_PROC=D1_CONHEC  AND  Z13_CODIT=D1_COD     /*AND Z13_ITEMSC=D1_ITEM*/ AND Z13.%NOTDEL%
                    INNER JOIN %TABLE:Z12%  Z12 ON Z12_FILIAL= %xFilial:Z12%  AND Z12_PROC=Z13_PROC   AND  Z12.%NOTDEL%
                    INNER JOIN %TABLE:SC7%  C7  ON C7_FILIAL =  %xFilial:SC7% AND C7_NUM=Z13_PEDIDO   AND  C7_PRODUTO=Z13_CODIT AND C7_ITEM=Z13_ITEMPC AND C7.%NOTDEL%
                    INNER JOIN %TABLE:SF4%  F4  ON F4_FILIAL =  %xFilial:SF4% AND F4_CODIGO=C7_TES    AND  F4.%NOTDEL%
                    WHERE D1.%NOTDEL%
                    AND D1_FILIAL = %xFilial:SD1%
                    AND D1_DOC = %EXP:cNFiscal%
                    AND D1_SERIE = %EXP:cSerie%
                    AND D1_EMISSAO = %EXP:dDATA%
                    AND D1_FORNECE = %EXP:CA100FOR%
                    AND D1_LOJA = %EXP:cLOJA%
                    AND D1_ITEM = %EXP:aCols[Len(aCols)][cD1ITEM]%
                    GROUP BY Z13_PEDIDO,C7_PRODUTO,C7_ITEM,C7_TES,F4_CF,B1_ORIGEM,F4_SITTRIB,D1_CONHEC,D1_FORNECE,D1_DOC,D1_SERIE,D1_LOJA,D1_COD,D1_ITEM,F4_SITTRIB,D1_IPI,Z12_NFILHA,F1_TIPO_NF
               EndSql
                    
               IF TTA103A->F1_TIPO_NF =='6' 
                    ACOLS[Len(aCols)][cD1TES] := cTSTRANSP
               else
                    ACOLS[Len(aCols)][cD1TES] := TTA103A->C7_TES           
               EndIf 
               
               DbSelectArea(cAliasSD1)
               If l103Class .And. cD1TES > 0 .And. !Empty(aCols[Len(aCols),cD1TES]) .And. !(SF1->F1_STATUS $ "B|C")
                    MaFisLoad("IT_TES","",Len(aCols))
                    MaFisAlt("IT_TES",aCols[Len(aCols)][cD1TES],Len(aCols))
                    MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
                    If ExistTrigger("D1_TES")
                         RunTrigger(2,Len(aCols),,"D1_TES")
                    EndIf                   
               EndIf
               cItem+=  SD1->D1_ITEM     
                                                 
               If (Select("TTA103A") <> 0)
               TTA103A->(dbCloseArea())
               EndIf

               //27/03/2025  - PERSONALITEC - 3. Ajuste nas despesas de processo conta e ordem (DIFAL)
               If l103Class .And. cD1TES > 0 .And. !(SF1->F1_STATUS $ "B|C") .And. AllTrim(SF1->F1_FORNECE) $ cMVFORNEAF
                   
                    If (Select("_BD01") <> 0)
                         _BD01->(dbCloseArea())
                    EndIf

                    BeginSQL ALIAS "_BD01"
                         SELECT D1_FILIAL, D1_DTDIGIT, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NOME, A2_SIMPNAC, D1_TES, D1_CF, D1_COD,
                         D1_ITEM, D1_TOTAL, D1_BASEICM, D1_PICM, D1_VALICM, D1_VALIPI, D1_CUSTO, D1_ICMSCOM,D1_XVALII, Z15_VALII,
                         ROUND(((((D1_BASEICM-D1_VALICM)/0.83)*17/100)-D1_VALICM),2) as DIFAL_DENTRO 
                         FROM %TABLE:SD1% D1
                         INNER JOIN %TABLE:SA2%  A2 ON A2_FILIAL = %xFilial:SA2% AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND A2.%NOTDEL%
                         INNER JOIN %TABLE:Z15%  Z15 ON Z15_FILIAL=  %xFilial:Z15%  AND Z15_PROC=D1_CONHEC  AND  Z15_CODIT=D1_COD AND Z15.%NOTDEL%
                         WHERE D1.%NOTDEL%
                         AND D1_FILIAL IN ('01','09','10')
                         AND D1_DTDIGIT >= '20250213'
                         AND D1_DOC = %exp:cNFiscal%
                         AND D1_SERIE = %exp:cSerie%
                         AND D1_FORNECE = %exp:CA100FOR%
                         AND D1_LOJA = %exp:cLOJA%     
                         AND D1_ITEM = %exp:aCols[Len(aCols)][cD1ITEM]%
                         ORDER BY 10                    
                    EndSql

                    While !_BD01->(Eof()) 
                         DbSelectArea("SD1")
                         DbSetOrder(1)
                         
                         If dbSeek(xFilial("SD1")+ AvKey(_BD01->D1_DOC, "D1_DOC") + AvKey(_BD01->D1_SERIE, "D1_SERIE") + AvKey(_BD01->D1_FORNECE, "D1_FORNECE")  + AvKey(_BD01->D1_LOJA, "D1_LOJA") + AvKey(_BD01->D1_COD , "D1_COD")+  AvKey(_BD01->D1_ITEM , "D1_ITEM")) 
                              aCols[Len(aCols),nICMCOMP]  := _BD01->DIFAL_DENTRO     //D1_ICMSCOM
                              aCols[Len(aCols),nXVALI]    := _BD01->Z15_VALII        //D1_XVALII
                              aCols[Len(aCols),nAliqCOMP] := 17                      //D1_ALIQCMP //aliquota interna icms complementar //MaFisRef("IT_ALIQCMP","MT100",M->D1_ALIQCMP)
                         Endif

                         _BD01->(DBSKIP())
                    EndDo

                    If (Select("_BD01") <> 0)
                         _BD01->(dbCloseArea())
                    EndIf
                   
                    AADD(aRet, .F.)  // IPI - Nใo alterado
                    AADD(aRet, .T.)  // ICMS - Alterado
                    AADD(aRet, .F.)  // PIS - nao Alterado 
                    AADD(aRet, .F.)  // COFINS - Nใo alterado
               EndIf
          EndIf
     EndIf 
Else
     /*
     Mant้m a tratativa jแ existente
     */
     If   cEmpant == '01'

          If  FunName()=='UZXIMP'  
                         
                    If (Select("TTA103A") <> 0)
                         TTA103A->(dbCloseArea())
                    EndIf
               
                    BeginSQL ALIAS "TTA103A"
                         SELECT F1_TIPO_NF,Z13_PEDIDO,C7_PRODUTO,C7_ITEM,C7_TES,F4_CF,(B1_ORIGEM+F4_SITTRIB) AS D1_CLASFIS,D1_CONHEC,D1_FORNECE,D1_DOC,D1_SERIE,D1_LOJA,D1_COD,D1_ITEM,F4_SITTRIB,
                              SUM((D1_QUANT*D1_VUNIT)/((100-D1_IPI)/100)) AS BASEICMS,Z12_NFILHA
                         FROM %TABLE:SD1% D1
                         INNER JOIN %TABLE:SF1%  F1  ON F1_FILIAL =  %xFilial:SF1% AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1.%NOTDEL%
                         INNER JOIN %TABLE:SB1%  B1  ON B1_FILIAL =  %xFilial:SB1% AND B1_COD=D1_COD       AND  B1.%NOTDEL%
                         INNER JOIN %TABLE:Z13%  Z13 ON Z13_FILIAL= %xFilial:Z13%  AND Z13_PROC=D1_CONHEC  AND  Z13_CODIT=D1_COD     /*AND Z13_ITEMSC=D1_ITEM*/ AND Z13.%NOTDEL%
                         INNER JOIN %TABLE:Z12%  Z12 ON Z12_FILIAL= %xFilial:Z12%  AND Z12_PROC=Z13_PROC   AND  Z12.%NOTDEL%
                         INNER JOIN %TABLE:SC7%  C7  ON C7_FILIAL =  %xFilial:SC7% AND C7_NUM=Z13_PEDIDO   AND  C7_PRODUTO=Z13_CODIT AND C7_ITEM=Z13_ITEMPC AND C7.%NOTDEL%
                         INNER JOIN %TABLE:SF4%  F4  ON F4_FILIAL =  %xFilial:SF4% AND F4_CODIGO=C7_TES    AND  F4.%NOTDEL%
                         WHERE D1.%NOTDEL%
                         AND D1_FILIAL = %xFilial:SD1%
                         AND D1_DOC = %EXP:cNFiscal%
                         AND D1_SERIE = %EXP:cSerie%
                         AND D1_EMISSAO = %EXP:dDATA%
                         AND D1_FORNECE = %EXP:CA100FOR%
                         AND D1_LOJA = %EXP:cLOJA%
                         AND D1_ITEM = %EXP:aCols[Len(aCols)][cD1ITEM]%
                         GROUP BY Z13_PEDIDO,C7_PRODUTO,C7_ITEM,C7_TES,F4_CF,B1_ORIGEM,F4_SITTRIB,D1_CONHEC,D1_FORNECE,D1_DOC,D1_SERIE,D1_LOJA,D1_COD,D1_ITEM,F4_SITTRIB,D1_IPI,Z12_NFILHA,F1_TIPO_NF
                    EndSql
               
                    /*If (Select("TTA103B") <> 0)
                         TTA103B->(dbCloseArea())
                    EndIf
                    
                    BeginSQL ALIAS "TTA103B"
                    SELECT DISTINCT Z1C_NUMCON 
                    FROM  %TABLE:Z1C% Z1C
                    WHERE Z1C.%NOTDEL%
                    AND Z1C_FILIAL= %xFilial:Z1C%
                    AND Z1C_PROC= %EXP:TTA103A->D1_CONHEC%
                    EndSql

                    nNrCont:=0
                    While !TTA103B->(Eof())

                    nNrCont:= nNrCont +1
                    
                    TTA103B->(DbSkip())
                    EndDo*/                       
          
                    IF TTA103A->F1_TIPO_NF =='6' 
                         ACOLS[Len(aCols)][cD1TES] := cTSTRANSP
                    else
                         ACOLS[Len(aCols)][cD1TES] := TTA103A->C7_TES           
                    EndIf 
                    
                    DbSelectArea(cAliasSD1)
                    If l103Class .And. cD1TES > 0 .And. !Empty(aCols[Len(aCols),cD1TES]) .And. !(SF1->F1_STATUS $ "B|C")
                         MaFisLoad("IT_TES","",Len(aCols))
                         MaFisAlt("IT_TES",aCols[Len(aCols)][cD1TES],Len(aCols))
                         MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
                         If ExistTrigger("D1_TES")
                              RunTrigger(2,Len(aCols),,"D1_TES")
                         EndIf                   
                    EndIf
                    cItem+=  SD1->D1_ITEM     
                                                 
               If (Select("TTA103A") <> 0)
               TTA103A->(dbCloseArea())
               EndIf

          EndIf    
     EndIf 
EndIf

RestArea(aArea)

GetDRefresh()
Return aRet

