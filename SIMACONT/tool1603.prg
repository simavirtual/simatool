/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ESTRUCTURAS
SUBMENU...: ACTUALIZAR NOTAS
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 601

**************************************************************************
* TITULO..: ACTUALIZACION ESTRUCTURA DE NOTAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   MAY 29/2002 MIE

OBJETIVOS:

1- Actualiza la Estructura de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_603(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
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
*>>>>FIN PARAMETROS DE LA FUNCION

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

       LOCAL       i := 0
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lValida := .F.                 // Validar el Proceso
*       LOCAL PathTem := ''                  // Path Temporal
       LOCAL PathAct := ''                  // Path Actual
       LOCAL fArchvo := ''                  // Archivo
       LOCAL aCamDif := {}                  // Campos Diferentes

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)

       PathTem := PathCon
       PathMtr := PathMtr+'\'+cPatSis
       PathCon := PathCon+'\'+cPatSis
       PathPro := PathPro+'\'+cPatSis
       PathCar := PathCar+'\'+cPatSis
       PathCaf := PathCaf+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       AADD(aUseDbf,{.T.,PathCon+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
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

*>>>>ANALISIS DE DECISION
       IF !lPregunta('SE VA A ACTUALIZAR LOS ARCHIVOS DE NOTAS DEL A¥O: '+;
		    cAnoUsr+' DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA LA ACTUALIZACION')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       lValida := lPregunta('DESEA VALIDAR LA OPERACION '+;
			    'DE CADA ARCHIVO? No Si')
*>>>>FIN ANALISIS DE DECISION

*>>>>UBICACION PATH DE SIMACONT
       PathAct := DIRNAME()
       IF !DIRCHANGE (PathTem) == 0
	  cError('NO SE PUDO UBICARSE EN EL DIRECTORIO '+PathTem)
	  CloseAll(aUseDbf)
	  DIRCHANGE (PathAct)
	  RETURN NIL
       ENDIF
       IF !lPregunta('EL PATH DE SIMACONT ES: '+DIRNAME()+' '+;
		     'DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA LA ACTUALIZACION')
	  DIRCHANGE (PathAct)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN UBICACION PATH DE SIMACONT

*>>>>ACTUALIZACION DE LOS ARCHIVOS DE NOTAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+'.DBF',;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' FAVOR CONSULTAR')
	      CloseAll(aUseDbf)
	      DIRCHANGE (PathAct)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ACTUALIZANDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTUALIZACION DE LA ESTRUCTURA DE LAS NOTAS
	    SELECT NOT
	    ZAP
	    IF NOT->(EOF())

	       fArchvo := cPatSis+'\'+cMaeAct+'\NOTAS\BACKUPS\'+;
			  'NT'+GRU->cCodigoGru+cAnoSis+ExtFile
	       APPEND FROM &fArchvo

	       IF NOT->(EOF())
		  cError('EL ARCHIVO DEL GRUPO '+GRU->cCodigoGru+;
			 'AL APPENDIZAR SUS REGISTROS APARECE VACIO')
		  CloseAll(aUseDbf)
		  RETURN NIL
	       ENDIF
	    ELSE
	       cError('DEBE EMPEZAR DE NUEVO. VUELA A COPIAR LOS ARCHIVOS',;
		      'NO SE PUDO BORRAR LOS REGISTROS DEL ARCHIVO FUENTE')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
**********FIN ACTUALIZACION DE LA ESTRUCTURA DE LAS NOTAS

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,cPatSis+'\'+cMaeAct+'\NOTAS\BACKUPS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+'.dat',;
			   'BAK',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' FAVOR CONSULTAR')
	      CloseDbf('BAK')
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********VALIDACION DEL PROCESO
	    IF lValida
	       cError('GRUPO: '+GRU->cCodigoGru+;
		      ' REGISTROS: '+STR(NOT->(RECCOUNT()),4))
	    ENDIF
**********FIN VALIDACION DEL PROCESO

**********LECTURA POR MATERIAS
	    aCamDif := aCamNotDif()
	    IF LEN(aCamDif) # 0
	       FOR i := 1 TO LEN(aCamDif)
		   NotBakaDbf(lShared,GRU->cCodigoGru,;
			      'NOT->'+aCamDif[i,1],;
			      'BAK->'+aCamDif[i,2])
	       ENDFOR
	    ENDIF
**********FIN LECTURA POR MATERIAS

	  CloseDbf('NOT')
	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       DIRCHANGE (PathAct)
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS ARCHIVOS DE NOTAS

/*************************************************************************
* TITULO..: DIFERENCIAS EN CAMPOS DE NOTAS       	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 29/2006 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 AM   NOV 29/2006 MAR

OBJETIVOS:

1- Determina que cambios han variado de acuerdo a los porcentajes en
   el plan de estudios.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aCamNotDif()

*>>>>DESCRIPCION DE PARAMETROS
/*     FileNot                              // Archivo de Notas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL     i,j := 0                   // Contador
       LOCAL aStrNot := {}                  // Estructura del Archivo
       LOCAL aCamNot := {}                  // Campos de Notas
       LOCAL aStrBak := {}                  // Estructura del Archivo
       LOCAL aCamBak := {}                  // Campos de Backups
       LOCAL aCamDif := {}                  // Campos Diferentes
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR NOTAS
       aStrNot := NOT->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrNot)

	   IF SUBS(UPPER(aStrNot[i,1]),1,3) # UPPER('cNt')
	      LOOP
	   ENDIF

	   IF SUBS(UPPER(aStrNot[i,1]),8,3) == UPPER('Rec')
	      LOOP
	   ENDIF
	   AADD(aCamNot,aStrNot[i,1])
       ENDFOR
*>>>>FIN RECORRIDO POR NOTAS

*>>>>RECORRIDO POR BACKUPS
       aStrBak := BAK->(DBSTRUCT())
       FOR i := 1 TO LEN(aStrBak)

	   IF SUBS(UPPER(aStrBak[i,1]),1,3) # UPPER('cNt')
	      LOOP
	   ENDIF

	   IF SUBS(UPPER(aStrBak[i,1]),8,3) == UPPER('Rec')
	      LOOP
	   ENDIF
	   AADD(aCamBak,aStrBak[i,1])
       ENDFOR
*>>>>FIN RECORRIDO POR BACKUPS

*>>>>RECORRIDO POR CAMPOS DE NOTAS
       FOR i := 1 TO LEN(aCamNot)
	   FOR j := 1 TO LEN(aCamBak)

	       IF SUBS(UPPER(aCamNot[i]),1,7) == SUBS(UPPER(aCamBak[j]),1,7)

		  IF UPPER(aCamNot[i]) # UPPER(aCamBak[j])
		     AADD(aCamDif,{aCamNot[i],aCamBak[j]})
		  ENDIF

	       ENDIF

	   ENDFOR
       ENDFOR

       RETURN aCamDif
*>>>>FIN RECORRIDO POR CAMPOS DE NOTAS

/*************************************************************************
* TITULO..: LECTURAS POR MATERIAS DE BACKUPS     	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: DIC 01/2006 VIE A
       Colombia, Bucaramanga        INICIO: 03:30 AM   DIC 01/2006 VIE

OBJETIVOS:

1- Graba las materias que ha variado en los porcentajes de BACKUPS a
   NOTAS

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION NotBakaDbf(lShared,cCodGru,cCamNot,cCamBak)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cCamNot                              // Campo de Notas
       cCamBak                              // Campo de Backups
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador

       LOCAL aTitulo := {}                  // Titulos de las Columnas
       LOCAL aTamCol := {}                  // Tama¤o de las Columnas
       LOCAL aNroCol := {}                  // N£meros de Columnas
       LOCAL nNroFil := 0                   // Fila de lectura
       LOCAL nNroCol := 1                   // Columna de lectura
       LOCAL cMsgTxt := ''                  // Mensaje Temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRUPO:'+cCodGru+' '+cCamNot+'='+cCamBak,22,'°')
       aTamCol := {04,06,20,20}
       aTitulo := {'No.','CODIGO','NOTAS ','BACKUPS'}
       cMsgTxt := cRegPrint(aTitulo,aTamCol,@aNroCol)
       @ nNroFil,nNroCol SAY cMsgTxt
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>RECORRIDO POR NOTAS
       SELECT BAK
       BAK->(DBGOTOP())

       SELECT NOT
       NOT->(DBGOTOP())
       DO WHILE .NOT. NOT->(EOF())

**********GRABACION DE LAS NOTAS
	    IF NOT->cCodigoEst == BAK->cCodigoEst

	       @ nNroFil,aNroCol[1] SAY STR(NOT->(RECNO()),2,0)
	       @ nNroFil,aNroCol[2] SAY NOT->cCodigoEst
	       @ nNroFil,aNroCol[3] SAY &cCamNot
	       @ nNroFil,aNroCol[4] SAY &cCamBak

	       SELECT NOT
	       IF NOT->(lRegLock(lShared,.F.))

		  REPL &cCamNot WITH &cCamBak

		  NOT->(DBCOMMIT())

	       ELSE
		  cError('NO SE PUEDE GRABAR LAS NOTAS')
	       ENDIF

	       IF lShared
		  NOT->(DBUNLOCK())
	       ENDIF

	       @ nNroFil,aNroCol[1] SAY STR(NOT->(RECNO()),2,0)
	       @ nNroFil,aNroCol[2] SAY NOT->cCodigoEst
	       @ nNroFil,aNroCol[3] SAY &cCamNot
	       @ nNroFil,aNroCol[4] SAY &cCamBak

	    ELSE
	       cError('DESCUADRE EN ESTUDIANTES',;
		      NOT->cCodigoEst,BAK->cCodigoEst)

	    ENDIF
**********FIN GRABACION DE LAS NOTAS

**********INCREMENTO DE LAS FILAS
	    nNroFil++
	    IF nNroFil > 19

*--------------IMPRESION DEL ULTIMO REGISITRO
		 nNroFil := nMarco(03,'GRUPO:'+cCodGru+' '+cCamNot+'='+cCamBak,22,'°')
		 @ nNroFil,nNroCol SAY cMsgTxt

		 nNroFil++
*--------------FIN IMPRESION DEL ULTIMO REGISITRO

	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOT->(DBSKIP())
	  BAK->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR NOTAS
