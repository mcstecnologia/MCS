#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/**
* Função			: C2ABCFOR
* Autor				: Crele Cristina da Costa
* Data				: 26/08/2012
* Descrição			: Relatório Maiores Fornecedores
*
* Parâmetros		: n/a
*
* Retorno			: n/a
*                        
* Observações		: 
*/

User Function C2ABCFOR()
Local  	oReport          
Local 	oSection1                       
Local  	cTitulo     := 	""
Local  	cDescricao 	:=	""  
Local 	nTamData 	:= 	IIF(__SetCentury(),10,8)  
Local	cPerg		:=	'C2ABCFOR'

//oReport := ReportDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := "Relatório Maiores Fornecedores"
cDescricao := "Relatório que ira imprimir os maiores fornecedores conforme os parametros informados."    
oReport := TReport():New(cPerg,cTitulo,cPerg, {|oReport| ReportPrint(oReport,oSection1)},cDescricao)	
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

CriaSx1(cPerg)
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,/*Descricao da Sessão*/,{"cAlias"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRCell():New(oSection1,"cFor"			,"cAlias","Codigo"	   			,/*Picture*/,10,.F.,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cLoja"			,"cAlias","Loja"	   		   	,/*Picture*/,04,.F.,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cNome"			,"cAlias","Razao Social"	   	,/*Picture*/,60,.F.,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"nQuant"			,"cAlias","Quantidade"			,/*Picture*/,18,.F.,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"cUM"				,"cAlias","UM"					,/*Picture*/,08,.F.,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"nValor"			,"cAlias","Valor"				,/*Picture*/,18,.F.,/*{|| code-block de impressao }*/)

oSection1 :SetTotalText("T O T A I S : ")

oReport:PrintDialog()
Return ()
         
Static Function ReportPrint(oReport,oSection1)
Local	cAlias 		:= 	GetNextAlias()
Local	nTotRegs	:=	0             
Local	aTotPisEnt	:= 	{}
Local	aTotCofEnt	:= 	{}
Local	aTotPisSai	:=	{}
Local	aTotCofSai	:=	{}
Local	nPos		:=	0
Local	cCSTAnt		:=	''                                      


oReport:Section(1):BeginQuery()

//if MV_PAR03 == 1

	BeginSql Alias cAlias    
	
	SELECT 
		D1_FORNECE, D1_LOJA, A2_NOME, SUM(D1_TOTAL) D1_TOTAL
	FROM 
		%Table:SD1% SD1

	INNER JOIN %Table:SF4% SF4 ON SF4.%notdel% AND F4_FILIAL = %xFilial:SF4%
	AND F4_CODIGO = D1_TES AND (F4_ESTOQUE = 'S' OR F4_ESTOQUE = 'N') AND F4_DUPLIC = 'S' 
	INNER JOIN %Table:SA2% SA2 ON SA2.%notdel% AND A2_FILIAL = %xFilial:SA2%
	AND D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA

	WHERE 
		D1_FILIAL = %xFilial:SD1%
		AND SD1.%notdel%
		AND D1_TIPO = 'N' 
		AND D1_DTDIGIT BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)%
		AND D1_TP BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	GROUP BY D1_FORNECE, D1_LOJA, A2_NOME
	ORDER BY D1_TOTAL DESC
	EndSql                    

/*else

	BeginSql Alias cAlias    
	
	SELECT 
		D1_FORNECE, D1_LOJA, A2_NOME, SUM(D1_TOTAL) D1_TOTAL
	FROM 
		%Table:SD1% SD1

	INNER JOIN %Table:SF4% SF4 ON SF4.%notdel% AND F4_FILIAL = %xFilial:SF4%
	AND F4_CODIGO = D1_TES AND (F4_ESTOQUE = 'S' OR F4_ESTOQUE = 'N') AND F4_DUPLIC = 'S' 
	INNER JOIN %Table:SA2% SA2 ON SA2.%notdel% AND A2_FILIAL = %xFilial:SA2%
	AND D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA

	WHERE 
		D1_FILIAL = %xFilial:SD1%
		AND SD1.%notdel%
		AND D1_TIPO = 'N' 
		AND D1_DTDIGIT BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)%
		AND D1_TP BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR05%
		GROUP BY D1_FORNECE, D1_LOJA, A2_NOME
	ORDER BY D1_QUANT DESC
	EndSql                    

endif*/

oReport:section(1):EndQuery()  

//TcSetField(cAlias,'D1_QUANT',"N", TamSx3("D1_QUANT")[1], TamSx3("D1_QUANT")[2] )
TcSetField(cAlias,'D1_TOTAL',"N", TamSx3("D1_TOTAL")[1], TamSx3("D1_TOTAL")[2] )

nTotRegs += (cAlias)->(LastRec())

	oReport:SetMeter(nTotRegs)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do fluxo do relatório                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nQuant := 0
	nTotal := 0
	
	oReport:Section(1):Init() 
	(cAlias)->(dbGoTop())
	While !oReport:Cancel() .And. !((cAlias)->(Eof()))        
		oSection1:Cell("cFor"			):SetValue((cAlias)->D1_FORNECE)
		oSection1:Cell("cLoja"			):SetValue((cAlias)->D1_LOJA)
		oSection1:Cell("cNome"			):SetValue((cAlias)->A2_NOME)
		//oSection1:Cell("nQuant"			):SetValue(Transform((cAlias)->D1_QUANT,"@E 999,999.99"))
		//oSection1:Cell("cUM"				):SetValue((cAlias)->D1_UM)
		oSection1:Cell("nValor"			):SetValue(Transform((cAlias)->D1_TOTAL,"@E 999,999,999.99"))
		
		//nQuant+=(cAlias)->D1_QUANT
		nTotal+=(cAlias)->D1_TOTAL
		
		oSection1:PrintLine()
		oReport:IncMeter()
		(cAlias)->(dbSkip())
		If oReport:Cancel()
			Exit
		EndIf   
	EndDo     
                 
	oReport:ThinLine()

	oReport:PrintText("T O T A I S : ",oReport:Row())
	&& Limpar celulas
	oSection1:Cell("cFor"		):SetValue('')
	oSection1:Cell("cLoja"		):SetValue('')
	oSection1:Cell("cNome"		):SetValue('')
	//oSection1:Cell("nQuant"		):SetValue('')   //SetValue(Transform(nQuant,"@E 999,999.99"))
	//oSection1:Cell("cUM"			):SetValue('')
	oSection1:Cell("nValor"		):SetValue(Transform(nTotal,"@E 999,999,999.99"))
	oSection1:PrintLine()

	oReport:Section(1):Finish() 	
	oReport:ThinLine()                               
	oReport:EndPage(.T.) 
(cAlias)->(dbCloseArea())
Return()
                     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSX1   º Autor ³ FABIO SPESSOTTO    º Data ³  08/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Objetivo desta funcao e verificar se existe o grupo de      º±±
±±º          ³perguntas, se nao existir a funcao ira cria-lo.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³cPerg -> Nome com  grupo de perguntas em questão.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function CriaSx1(cPerg)

Local aRegs
Local aHelp			:= Array(2,1)
Local aRegs 		:= {}
Local nI 			:= 0
Local nJ 			:= 0                    
Local nH			:= 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de?"	 		 ,"","","mv_ch1","D",08,0,0,"G","" ,"MV_PAR01","",""			,""		,"","",""           ,"" ,"" ,"","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data até?"  		 ,"","","mv_ch2","D",08,0,0,"G","" ,"MV_PAR02","",""			,""		,"","",""           ,"" ,"" ,"","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"03","Ordem"  	 		 ,"","","mv_ch3","C",01,0,1,"C",""			 ,""		,"Valor","" ,"" ,"","","Quantidade","" ,"" ,"","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Tipo de?"	 		 ,"","","mv_ch4","C",02,0,0,"G","" 			 ,"MV_PAR03","","" ,""		   ,""     ,"","","" ,"" ,"","","","","","","","","","","","","","","","","02","","",""})
Aadd(aRegs,{cPerg,"04","Tipo até?"  		 ,"","","mv_ch5","C",02,0,0,"G","" 			 ,"MV_PAR04","","" ,""		   ,""     ,"","","" ,"" ,"","","","","","","","","","","","","","","","","02","","",""})

For nI:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nI,2])
		RecLock("SX1",.T.)
		For nJ:=1 to FCount()
			If nJ <= Len(aRegs[nI])
				FieldPut(nJ,aRegs[nI,nJ])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return Nil
