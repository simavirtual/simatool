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
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL nRegIni := 0                   // Registro inicial
       LOCAL nRegFin := 0                   // Registro Final
       LOCAL cRegIni := ''                  // Regisgro Inicial
       LOCAL cRegFin := ''                  // Registro final

       LOCAL cCodGru := ''                  // C¢digo del Grupo

       LOCAL lSiorNo := .T.                 // Variable de decisi¢n

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
       SAL->(DBGOTO(nRegFin))
       cRegFin := SAL->cCodigoGru

       SAL->(DBGOTO(nRegIni))
       cRegIni := SAL->cCodigoGru
*>>>>FIN CAPTURA DE LOS GRUPOS POR INTERVALO


*>>>>ESTRUCTURA DEL INFORME
       aDbfStr := {}
       AADD(aDbfStr,{'codigo'  ,'Character',008,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{"apellido","Character",030,0}) // Apellido del Estudiante
       AADD(aDbfStr,{"nombre"  ,"Character",030,0}) // Nombre del Estudiante
       AADD(aDbfStr,{"grupo"   ,"Character",008,0}) // Codigo del grupo
       AADD(aDbfStr,{"salon"   ,"Character",008,0}) // N£mero del Salon
       AADD(aDbfStr,{"retirado","Character",008,0}) // N£mero del Salon
     *ÀEstructura del informe

       FilePrn := cRegIni+cRegFin+'.xls'
*FilePrn := 'AA.dat'
       CreaDbf(lShared,nModCry,PathPrn,FilePrn,aDbfStr)

       IF !lUseDbf(.T.,PathPrn+'\'+FilePrn,'PRN',NIL,lShared)
	  cError('ABRIENDO EL ARCHIVO DE IMPRESION')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN ESTRUCTURA DEL INFORME

*>>>>RECORRIDO POR GRUPOS
       SELECT SAL
       GO nRegFin

       GO nRegIni
       DO WHILE SAL->(RECNO()) <= nRegFin

**********FILTRACION DEL ARCHIVO
	    SELECT &cMaeAct
	    SET FILTER TO cCodigoGru == SAL->cCodigoGru

	    DBGOTOP()
	    IF EOF()
	       SET FILTER TO
	       cError('NO EXISTEN ESTUDIANTES PARA EL GRUPO'+SAL->cCodigoGru)
	       SAL->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN FILTRACION DEL ARCHIVO

**********RECORRIDO DE LOS ESTUDIANTES
	    SELECT &cMaeAct
	    DBGOTOP()
	    DO WHILE .NOT. EOF()

*==============ASIGNACION DEL SALON
		 cCodGru := ''
		 IF !&cMaeAct->lRetiroEst
		    lSiorNo := lgualGrupo(nRegIni,nRegFin)
		    cCodGru := cSalon(lShared,lSiorNo,nRegIni,nRegFin)
		 ENDIF
*==============FIN ASIGNACION DEL SALON

*==============IMPRESION DE LA LINEA DE ESTADO
		 LineaEstado('GRUPO: '+&cMaeAct->cCodigoGru+'º'+;
			     'CODIGO:'+&cMaeAct->cCodigoGru+'º'+;
			     'SALON:'+cCodGru,cNomSis)
*==============FIN IMPRESION DE LA LINEA DE ESTADO

*==============GRABACION DEL REGISTRO
		 SELECT PRN
		 IF PRN->(lRegLock(lShared,.T.))
		    REPL PRN->codigo    WITH &cMaeAct->cCodigoEst
		    REPL PRN->apellido  WITH &cMaeAct->cApelliEst
		    REPL PRN->nombre    WITH &cMaeAct->cNombreEst
		    REPL PRN->grupo     WITH &cMaeAct->cCodigoGru
		    REPL PRN->salon     WITH cCodGru
		    REPL PRN->retirado  WITH IF(&cMaeAct->lRetiroEst,'SI','')
		    PRN->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABA EL REGISTRO')
		 ENDIF
		 IF lShared
		    PRN->(DBUNLOCK())
		 ENDIF
*==============FIN GRABACION DEL REGISTRO

	       SELECT &cMaeAct
	       DBSKIP()

	    ENDDO
**********FIN RECORRIDO DE LOS ESTUDIANTES

	  SAL->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS


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

FUNCTION cSalon(lShared,lSiorNo,nRegIni,nRegFin)

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
       nNroTem := GRU->nNroTemGru
       DO WHILE GRU->(RECNO()) >= nRegIni .AND. !GRU->(BOF())

**********NUMEROS IGUALES
	    IF lSiorNo
	       IF GRU->nNroTemGru < GRU->nNroAluGru
		  cCodGru := GRU->cCodigoGru
		  EXIT
	       ENDIF
	    ENDIF
**********FIN NUMEROS IGUALES

	  GRU->(DBSKIP(-1))

**********NUMEROS DIFERENTES
	    IF .NOT. lSiorNo
	       IF GRU->nNroTemGru < nNroTem
		  cCodGru := GRU->cCodigoGru
		  EXIT
	       ENDIF
	    ENDIF
**********FIN NUMEROS DIFERENTES

       ENDDO
*>>>>FIN ASIGNACION DEL SALON

*>>>>GRABACION DEL REGISTRO
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
       RETURN cCodGru
*>>>>FIN GRABACION DEL REGISTRO


/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 16/2011 JUE A
       Colombia, Bucaramanga        INICIO: 07:AM PM   JUN 16/2011 JUE

OBJETIVOS:

1- Crea cualquier la estructura del archivo

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbf(lShared,nModCry,PathArc,fArchvo,aDbfStr,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       aDbfStr                              // Estructura a Crear
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0

	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA