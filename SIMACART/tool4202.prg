/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: FIJAR GRUPOS
SISTEMA...: CARTERA ACADEMICA

**************************************************************************
* TITULO..: FIJAR GRUPOS                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 07/2013 MIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   FEB 07/2013 MIE

OBJETIVOS:

1- Pendiente

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool4_202(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>DECLARACION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       nFilInf                              // Fila Inferior del SubMen£
       nColInf                              // Columna Inferior del SubMen£
       nFilPal                              // Fila Inferior Men£ principal
       cNomUsr                              // Nombre del Usuario
       cAnoUsr                              // A¤o del usuario
       cPatSis                              // Path del sistema
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activo
       cJorTxt                              // Jornada escogida */
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL lHayReg := .F.                 // .T. Existe el registro

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\MODEMALU'+ExtFile,'ALU',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\MODEMMAE'+ExtFile,'MAE',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ALU->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MODEMALU NO CONTIENE REGISTROS')

       CASE MAE->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MODEMMAE NO CONTIENE REGISTROS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT MAE
       MAE->(DBGOTOP())
       DO WHILE .NOT. MAE->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+MAE->(STR(RECNO(),4))+'/'+;
				     MAE->(STR(RECCOUNT(),4))+;
			'ºCONCEPTO:'+MAE->cConcepEst,cNomSis)
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','ALU',MAE->cCodigoEst)
**********FIN LOCALIZACION DEL CODIGO

**********GRABACION DEL REGISTRO
	    SELECT MAE
	    IF MAE->(lRegLock(lShared,.F.))

	       REPL MAE->cCodigoGru WITH ALU->cCodigoGru

	       MAE->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       MAE->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  MAE->(DBSKIP())
	*ÀAvance del registro

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS
