#Include 'Protheus.CH'


/*/{Protheus.doc} MCCTB020
Replica os dados para outras filiais
@type function
@version  
@author MCS Tecnologia
@since 5/27/2026
@return variant, return_description
/*/
User Function MCCTB020(cConta)

    Local cAliasOri	:= ''
    Local aEstrut   := {}
    Local aFil      := {}
    //Local xFil      := SuperGetMV("MV_XFORICP",.F.,'') //Indica a filial de origem dos registros
    Local nFil      := 0
    Local nTabs     := 0
    Local aTabs     := {}

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё tabelas que serЦo replicadas entre filiais                       
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    aadd(aTabs,{'CT1','CTS','CVD'})

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Regra para as filiais de destino conforme a origem                         
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    If FwCodFil() == '010101'
        aadd(aFil,{'010102'})
    ElseIf FwCodFil() == '020101'
        aadd(aFil,{'020102'})
    EndIf

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Query para busca dos dados                          
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    
        For nFil := 1 to Len(aFil)

            For nTabs := 1 to Len(aTabs[1])

                If Qry(aTabs[1][nTabs], @cAliasOri, cConta)
                    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                    //Ё NЦo permitirА a cСpia para a filial logada, caso ela seja uma das filiais de destino.                        
                    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                    If FwCodFil() <> aFil[nFil][1]                  
                        //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                        //Ё Veririca se a conta jА existe na  filial de destino                            
                        //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                        If aTabs[1][nTabs] == 'CT1' .Or. aTabs[1][nTabs] == 'CVD'
                            (aTabs[1][nTabs])->(dbSetOrder(1))
                        Else 
                            (aTabs[1][nTabs])->(dbSetOrder(4))
                        EndIf
                        If !(aTabs[1][nTabs])->(dbSeek(xFilial(aFil[nFil][1]) + cConta))
                            aEstrut	:= (aTabs[1][nTabs])->(dbStruct())
                            (cAliasOri)->(DbGoTop ())
                            Do While !(cAliasOri)->(Eof ())		
                                //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                                //Ё FunГЦo qeu efetiva a gravaГЦo na tabela de destino                            
                                //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                                GrvTab(aEstrut, cAliasOri, aTabs[1][nTabs],aFil[nFil][1])						
                                (cAliasOri)->(dbSkip())
                                //Loop
                            EndDo							
                        EndIf
                    EndIf
                EndIf
                (cAliasOri)->(DbCloseArea ())
            Next nTabs

        Next nFil
   
Return

/*/{Protheus.doc} Qry
Query para busca dos dados a serem copiados
@type function
@version  
@author MCS Tecnologia
@since 5/27/2026
@param cTab, character, param_description
@return variant, return_description
/*/
Static Function Qry(cTab, cAliasRet, cConta)

    Local	cSelect		:= ''
    Local 	cFrom		:= ''
    Local   cWhere		:= ''
    Local   cPrefixo	:= Iif( Substring(cTab,1,1) == 'S' ,Substring(cTab,2,2) ,cTab  ) + "_"
    Local 	cAliasTab	:= GetNextAlias()
    Local 	lRet		:= .F.	

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё FaГo query para buscar todos os dados a serem copiados                          
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    cSelect	:=	cTab + ".*"
    cFrom	:=	RetSqlName(cTab)+" "+ cTab + " "
    cWhere	:=	cTab + "." + cPrefixo + "FILIAL ='"+xFilial(cTab)+"' AND "
    If cTab == 'CT1' .Or. cTab == 'CVD'
        cWhere	+=  cTab + "." + cPrefixo + "CONTA = '"+cConta+"' AND "
    Else
        cWhere	+=  cTab + "." + cPrefixo + "CT1INI = '"+cConta+"' AND "
    EndIf
    //cWhere	+=  cTab + "." + cPrefixo + "CONTA = '"+cConta+"' AND "
    cWhere	+=  cTab + ".D_E_L_E_T_=' '"

    cSelect:= '%'+cSelect+'%'
    cFrom:= '%'+cFrom+'%'
    cWhere:= '%'+cWhere+'%'

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Monto a query para gravaГЦo                        
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    cAliasTab	:=	GetNextAlias()
    BeginSql Alias cAliasTab
        
        SELECT
        %Exp:cSelect%

        FROM
        %Exp:cFrom%	

        WHERE
        %Exp:cWhere%
        
    EndSql

    (cAliasTab)->(DbGoTop ())
    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Se Houver um registro, efetivo a copia                          
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    Do While !(cAliasTab)->(Eof ())
        lRet	:= .T.
        Exit	
                
        (cAliasTab)->(dbSkip())
        Loop
    EndDo

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Se .T., retorno o alias para funГЦo de replica                 
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    If lRet
        cAliasRet	:= cAliasTab
    Else
        (cAliasTab)->(DbCloseArea ())
    EndIF

Return lRet

/*/{Protheus.doc} GrvTab
Efetiva a gravaГЦo na tabela
@type function
@version  
@author MCS Tecnologia
@since 5/27/2026
@param aEstrut, array, param_description
@param cAliasQry, character, param_description
@param cTabela, character, param_description
@return variant, return_description
/*/
Static Function GrvTab(aEstrut, cAliasQry, cTabela,cFil)

    Local nCont		:= 0

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Inclui nova linha                         
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    RecLock(cTabela,.T.)

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё GravaГЦo da filial com a filial repassada                     
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    &(cTabela + "->" + Iif(Substr(cTabela,1,1) == 'S', Substr(cTabela,2,2) ,cTabela )   + "_FILIAL" ) := cFil//:= xFilial(cTabela)

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё laГo com a estrutura da SX3                        
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    For nCont := 1 to Len(aEstrut)
        
        If aEstrut[nCont][2] <> 'M'
        
            //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            //Ё Tratamento com TcSetField por conta de campo DATA, error.log                         
            //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
            If aEstrut[nCont][2] == 'D'		
                TcSetField(cAliasQry,aEstrut[nCont][1],"D",8,0)
            EndiF
            
            //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            //Ё Pula a filial pois foi gravado antetiormente                        
            //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
            If ! "FILIAL"  $ aEstrut[nCont][1]
                &(cTabela + "->" +aEstrut[nCont][1] )	:= 	(cAliasQry)->&(aEstrut[nCont][1])	
            EndIF
            
        EndIf
        
    Next nCont

    MsUnLock()

Return
