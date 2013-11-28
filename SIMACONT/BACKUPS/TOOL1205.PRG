/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: PERESTIM
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: INSERTAR PERSONAS DE PERESTIM                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2011 SAB A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2011 SAB

OBJETIVOS:

1- Actualiza la informaci¢n de los estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_205(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
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
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria


       LOCAL cDocNitTpe := ''               // Documento de la Persona


       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)

       PathMtr := PathMtr
       PathCon := PathCon
       PathPro := PathPro
       PathCar := PathCar
       PathCaf := PathCaf
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       cError(PathMtr+'\'+cPatSis,'PATH SIMAMATR')
       cError(PathCon+'\'+cPatSis,'PATH SIMACONT')
       cError(PathPro+'\'+cPatSis,'PATH SIMAPROF')
       cError(PathCar+'\'+cPatSis,'PATH SIMACART')
       cError(PathCaF+'\'+cPatSis,'PATH SIMACAFE')


       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathCon+'\'+cPatSis+'\'+;
			 fPerImp+'ESTIM'+ExtFile,'PEI',NIL,.F.,nModCry})

       AADD(aUseDbf,{.T.,PathCon+'\'+PathSis+'\'+;
			 FilePer,'PER',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO


*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE PEI->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN '+fPerImp+'ESTIM'+ExtFile)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT PEI
       PEI->(DBGOTOP())

       DO WHILE .NOT. PEI->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('PERESTIM:'+PEI->(STR(RECNO(),4))+'/'+;
				    PEI->(STR(RECCOUNT(),4)),cNomSis)
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    cDocNitTpe := PEI->cDocNitPer

	    IF lLocCodigo('cDocNitPer','PER',cDocNitTpe)

	       PEI->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********LINEA DE ESTADO
	    LineaEstado('GRABANDO:'+PEI->(STR(RECNO(),4))+'/'+;
				    PEI->(STR(RECCOUNT(),4)),cNomSis)
**********FIN LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF PER->(lRegLock(lShared,.T.))

	       REPL PER->nIdeCodPer WITH PER->(RECNO())

	       REPL PER->cApeUnoPer WITH PEI->cApeUnoPer
	       REPL PER->cApeDosPer WITH PEI->cApeDosPer
	       REPL PER->cNomUnoPer WITH PEI->cNomUnoPer
	       REPL PER->cNomDosPer WITH PEI->cNomDosPer
	       REPL PER->cDocNitPer WITH PEI->cDocNitPer
	       REPL PER->cTipNitPer WITH PEI->cTipNitPer
	       REPL PER->cLugNitPer WITH PEI->cLugNitPer
	       REPL PER->dFecNacPer WITH PEI->dFecNacPer
	       REPL PER->cLugNacPer WITH PEI->cLugNacPer
	       REPL PER->lSexFemPer WITH PEI->lSexFemPer
	       REPL PER->cTipoRhPer WITH PEI->cTipoRhPer
	       REPL PER->cEstratPer WITH PEI->cEstratPer
	       REPL PER->cDireccPer WITH PEI->cDireccPer
	       REPL PER->cCiudadPer WITH PEI->cCiudadPer
	       REPL PER->cTelefnPer WITH PEI->cTelefnPer
	       REPL PER->cTelCelPer WITH PEI->cTelCelPer
	       REPL PER->cMaiUnoPer WITH PEI->cMaiUnoPer
	       REPL PER->cCarTraPer WITH PEI->cCarTraPer
	       REPL PER->cDirTraPer WITH PEI->cDirTraPer
	       REPL PER->cTelTraPer WITH PEI->cTelTraPer
	       REPL PER->cProfesPer WITH PEI->cProfesPer

	       REPL PER->cNomUsrPer WITH 'PERESTIM'
	       REPL PER->dFecUsrPer WITH DATE()
	       REPL PER->cHorUsrPer WITH TIME()

	       PER->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       PER->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  PEI->(DBSKIP())
	*ÀAvance del registro


       ENDDO
*>>>>RECORRIDO DE REGISTROS

