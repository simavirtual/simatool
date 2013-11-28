/*                      SIMASOFT - SISTEMA UTILITARIO
		 FUNCIONES ARCHIVO DE CONFIGURACION GENERAL

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 26/2002 LUN A
       Colombia, Bucaramanga        INICIO: 05:00 PM   AGO 26/2002 LUN

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfCol(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"PathMatr","Character",70,0})    // Path de la Matricula
       AADD(aDbfStr,{"PathCont","Character",70,0})    // Path de la Contabilidad
       AADD(aDbfStr,{"PathProf","Character",70,0})    // Path de la Contabilidad Profesores
       AADD(aDbfStr,{"PathCart","Character",70,0})    // Path de la Cartera
       AADD(aDbfStr,{"PathCafe","Character",70,0})    // Path de la Cafeteria
     *ÀPaths de los sistemas del Sima

       AADD(aDbfStr,{"cNomSupTol","Character",10,0})    // Supervisor del Sistema
       AADD(aDbfStr,{"cPwdSupTol","Character",10,0})    // Clave del Supervisor del Sistema
     *ÀSupervisor del Sistema

       AADD(aDbfStr,{"lPrnArcTol","Logical"  ,01,0})   // .T. Imprimir en la impresora
       AADD(aDbfStr,{"nCodigoClr","Numeric"  ,02,0})   // C¢digo del Color
       AADD(aDbfStr,{"nCodigoPrn","Numeric"  ,04,0})   // C¢digo de la Impresora
     *ÀConfiguracines Generales del Sistema
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TOL',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA'
	  CloseDbf('TOL',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF TOL->(lRegLock(lShared,.T.))
	  REPL TOL->lPrnArcTol WITH .F.
	  REPL TOL->nCodigoClr WITH 1
	  REPL TOL->PathMatr   WITH '\SIMA\SIMAMATR'
	  REPL TOL->PathCont   WITH '\SIMA\SIMACONT'
	  REPL TOL->PathProf   WITH '\SIMA\SIMAPROF'
	  REPL TOL->PathCart   WITH '\SIMA\SIMACART'
	  REPL TOL->PathCafe   WITH '\SIMA\SIMACAFE'
	  REPL TOL->cNomSupTol WITH CRYPT('CONTROL   ',"IVANAN")
	  REPL TOL->cPwdSupTol WITH CRYPT('CONTROL   ',"IVANAN")
	  TOL->(DBCOMMIT())
       ELSE
	  WAIT 'NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION'
       ENDIF
       IF lShared
	  TOL->(DBUNLOCK())
       ENDIF
       CloseDbf('TOL',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO