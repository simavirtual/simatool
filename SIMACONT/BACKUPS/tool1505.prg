/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...:
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: ASIGNACION DE SALONES                                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2011 SAB A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2011 SAB

OBJETIVOS:

1- Actualiza la informaci¢n de los estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_505(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       cError(PathMtr+'\'+cPatSis,'PATH SIMAMATR')
       cError(PathCon+'\'+cPatSis,'PATH SIMACONT')
       cError(PathPro+'\'+cPatSis,'PATH SIMAPROF')
       cError(PathCar+'\'+cPatSis,'PATH SIMACART')
       cError(PathCaf+'\'+cPatSis,'PATH SIMACAFE')

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       NroEstGru(lShared,PathCon,cPatSis,cAnoUsr,cMaeAlu)
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       lShared := .T.
       AADD(aUseDbf,{.T.,PathCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileAlu+cMaeAct+cAnoSis+ExtFile,cMaeAct,NIL,.F.,nModCry})
       AADD(aUseDbf,{.T.,PathCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'SAL',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       SELECT &cMaeAct
       lHayErr := .T.
       DO CASE
       CASE RECCOUNT() == 0
	    cError('NO EXISTEN ESTUDIANTES DE '+cMaeAct)

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN GRUPOS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>CAPTURA DE LOS GRUPOS POR INTERVALO
       IF !lIntervGru(nFilInf+1,nColInf,@nRegIni,@nRegFin)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO

*>>>>ASIGNACION DEL SALON
       FOR i := 1 TO 8

	  IF lgualGrupo(nRegIni,nRegFin)
	     wait cSalon1(lShared,nRegIni,nRegFin)
	  ELSE
	     wait cSalon2(lShared,nRegIni,nRegFin)
	  ENDIF

       ENDFOR
       SELECT GRU
       BROWSE()
*>>>>FIN ASIGNACION DEL SALON


       CloseAll()
       RETURN NIL

/*************************************************************************
* TITULO..: SI NUMERO DE ALUMNOS ASIGNADOS ES IGUAL                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/2011 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 15/2011 MIE

OBJETIVOS:

1- Determina si el n£mero de alumnos asignados son iguales

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lgualGrupo(nRegIni,nRegFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     nRegIni := 0                   // Registro inicial del grupo
       nRegFin := 0                   // Registro Final del grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .T.           // Variable de decisi¢n
       LOCAL nNroTem := 0             // N£mero de alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin

       GO nRegIni
       nNroTem := GRU->nNroTemGru
       DO WHILE GRU->(RECNO()) <= nRegFin

	  IF nNroTem # GRU->nNroTemGru
	     lSiorNo := .F.
	     EXIT
	  ENDIF
	  GRU->(DBSKIP())

       ENDDO
       RETURN lSiorNo
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: SALON1                                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/2011 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 15/2011 MIE

OBJETIVOS:

1- Asigna el n£mero del salon

2- Retorna el n£mero del salon

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSalon1(lShared,nRegIni,nRegFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nRegIni := 0                   // Registro inicial del grupo
       nRegFin := 0                   // Registro Final del grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .T.           // Variable de decisi¢n
       LOCAL nNroTem := 0             // N£mero de alumnos
       LOCAL cCodGru := ''            // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegIni

       GO nRegFin
       DO WHILE GRU->(RECNO()) >= nRegIni .AND. !GRU->(BOF())


	  IF GRU->nNroTemGru < GRU->nNroAluGru

	     cCodGru := GRU->cCodigoGru
	     IF !EMPTY(cCodGru)

		SELECT GRU
		IF GRU->(lRegLock(lShared,.F.))
		   REPL GRU->nNroTemGru WITH GRU->nNroTemGru+1
		   GRU->(DBCOMMIT())
		ELSE
		   cError('NO SE GRABA EL REGISTRO')
		ENDIF
		IF lShared
		   GRU->(DBUNLOCK())
		ENDIF

	     ENDIF

	     EXIT
	  ENDIF

	  GRU->(DBSKIP(-1))


       ENDDO
       RETURN cCodGru
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: NUMERO MENOR ENTRE GRUPOS                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/2011 MIE A
       Colombia, Bucaramanga        INICIO: 02:20 PM   JUN 15/2011 MIE

OBJETIVOS:

1- Determina si el n£mero de alumnos asignados son iguales

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSalon2(lShared,nRegIni,nRegFin)


*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nRegIni                              // Registro inicial del grupo
       nRegFin                              // Registro Final del grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lSiorNo := .T.           // Variable de decisi¢n
       LOCAL nNroTem := 0             // N£mero de alumnos
       LOCAL cCodGru := ''            // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegIni

       GO nRegFin
       nNroTem := GRU->nNroTemGru
       DO WHILE GRU->(RECNO()) >= nRegIni .AND. !GRU->(BOF())

	  GRU->(DBSKIP(-1))


	  IF GRU->nNroTemGru < nNroTem

	     cCodGru := GRU->cCodigoGru
	     IF !EMPTY(cCodGru)

		SELECT GRU
		IF GRU->(lRegLock(lShared,.F.))
		   REPL GRU->nNroTemGru WITH GRU->nNroTemGru+1
		   GRU->(DBCOMMIT())
		ELSE
		   cError('NO SE GRABA EL REGISTRO')
		ENDIF
		IF lShared
		   GRU->(DBUNLOCK())
		ENDIF

	     ENDIF

	     EXIT

	  ENDIF


       ENDDO
       RETURN cCodGru
*>>>>FIN RECORRIDO POR GRUPOS

/*************************************************************************
* TITULO..: ASIGNACION DEL SALON                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 15/2011 MIE A
       Colombia, Bucaramanga        INICIO: 01:30 PM   JUN 15/2011 MIE

OBJETIVOS:

1- Asigna el n£mero del salon

2- Retorna el n£mero del salon

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cSalon(lShared,lSiorNo,RegIni,nRegFin)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                               // .T. Sistema Compartido
       lSiorNo                               // .T. N£mero de estudiante iguales entre grupos
       nRegIni                               // Registro inicial del grupo
       nRegFin                               // Registro Final del grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroTem := 0             // N£mero de alumnos
       LOCAL cCodGru := ''            // C¢digo del grupo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ASIGNACION DEL SALON
       SELECT GRU
       GO nRegIni

       GO nRegFin
       DO WHILE GRU->(RECNO()) >= nRegIni .AND. !GRU->(BOF())


	  IF GRU->nNroTemGru < GRU->nNroAluGru

	     cCodGru := GRU->cCodigoGru
	     IF !EMPTY(cCodGru)

		SELECT GRU
		IF GRU->(lRegLock(lShared,.F.))
		   REPL GRU->nNroTemGru WITH GRU->nNroTemGru+1
		   GRU->(DBCOMMIT())
		ELSE
		   cError('NO SE GRABA EL REGISTRO')
		ENDIF
		IF lShared
		   GRU->(DBUNLOCK())
		ENDIF

	     ENDIF

	     EXIT
	  ENDIF

	  GRU->(DBSKIP(-1))


       ENDDO
       RETURN cCodGru
*>>>>FIN ASIGNACION DEL SALON

*>>>>