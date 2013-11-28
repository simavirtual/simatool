/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: CODIGOS RECUPERACIONES
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 101

**************************************************************************
* TITULO..: ACTUALIZACION CODIGOS RECUPERACIONES                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   AGO 20/2002 MIE

OBJETIVOS:

1- Actualiza la ubicaci¢n de los c¢digos de los indicadores para permitir
   el control de las recuperaciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_201(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)

       PathMtr := PathMtr+'\'+cPatSis
       PathCon := PathCon+'\'+cPatSis
       PathPro := PathPro+'\'+cPatSis
       PathCar := PathCar+'\'+cPatSis
       PathCaf := PathCaf+'\'+cPatSis
*>>>>FIN LECTURA DE PATHS

*>>>>ANALISIS DE DECISION
       cError(PathMtr,'PATH SIMAMATR')
       cError(PathCon,'PATH SIMACONT')
       cError(PathPro,'PATH SIMAPROF')
       cError(PathCar,'PATH SIMACART')
       cError(PathCaF,'PATH SIMACAFE')

       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

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
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTUALIZACION DE LOS ARCHIVOS DE NOTAS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,PathCon+'\'+cMaeAct+'\NOTAS\'+;
			   'NT'+GRU->cCodigoGru+cAnoSis+ExtFile,;
			   'NOT',NIL,lShared)

	       cError('ABRIENDO EL ARCHIVO DE NOTAS DEL GRUPO '+;
		      GRU->cCodigoGru+' FAVOR CONSULTAR')
	      CloseAll(aUseDbf)
	      RETURN NIL
	   ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ACTUALIZANDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ACTUALIZACION DE LOS CODIGOS
	    ActCodApl(lShared,NOT->(DBSTRUCT()),GRU->cCodigoGru)
**********FIN ACTUALIZACION DE LOS CODIGOS

	  CloseDbf('NOT')
	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS ARCHIVOS DE NOTAS


/*************************************************************************
* TITULO..: ACTUALIZACION DE CODIGOS APLICADOS                           *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 AM   MAY 29/2002 MIE

OBJETIVOS:

1- Actualiza los c¢digos aplicados para permitir el control de las
   recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION ActCodApl(lShared,aStrDbf,cCodGru)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       aStrDbf                              // Estructura del Archivo
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL nNroFil := 0                   // N£mero de la Fila
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cLogros := ''                  // Indicadores Anteriores
       LOCAL cIndAct := ''                  // Indicadores Actualizados
       LOCAL cCamInd := ''                  // Campo de Indicadores
       LOCAL lRegAct := ''                  // .T. Registro Actualizado
*>>>>FIN DECLARACION DE VARIABLES

*>>>>IMPRESION DE LOS ENCABEZADOS
       nNroFil := nMarco(03,'GRUPO:'+cCodGru,22)
       @ nNroFil,01 SAY 'No.'
       @ nNroFil,04 SAY 'CODIGO'
       @ nNroFil,11 SAY 'ESTADO'
       nNroFil++
*>>>>FIN IMPRESION DE LOS ENCABEZADOS

*>>>>ACTUALIZACION DE LOS CODIGOS
       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********VISUALIZACION DEL CODIGO DEL ESTUDIANTE
	    @ nNroFil,01 SAY STR(NOT->(RECNO()),2,0)
	    @ nNroFil,04 SAY NOT->cCodigoEst
**********FIN VISUALIZACION DEL CODIGO DEL ESTUDIANTE

**********ACTUALIZACION POR PERIODOS
	    lRegAct := IF(NOT->nCamTemNot == 0,.F.,.T.)
	    IF !lRegAct
	       FOR i := 1 TO LEN(aStrDbf)

*---------------VALIDACION DE LOS CAMPOS
		  IF UPPER(SUBS(aStrDbf[i,1],1,2)) # 'CJ'
		     LOOP
		  ENDIF
*---------------FIN VALIDACION DE LOS CAMPOS

*---------------ACTUALIZACION DE LOS INDICADORES
		  cCamInd := 'NOT->'+aStrDbf[i,1]
		  cLogros := &cCamInd
		  IF EMPTY(cLogros)
		     LOOP
		  ENDIF
		  cIndAct := cLogrosAct(cLogros)
		  @ nNroFil,11 SAY cIndAct
*---------------FIN ACTUALIZACION DE LOS INDICADORES

*---------------GRABACION DE LA ACTUALIZACION
		  SELECT NOT
		  IF NOT->(lRegLock(lShared,.F.))
		     REPLACE &cCamInd WITH cIndAct
		     REPLACE NOT->nCamTemNot WITH 1
		     NOT->(DBCOMMIT())
		  ELSE
		     cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		  ENDIF
		  IF lShared
		     NOT->(DBUNLOCK())
		  ENDIF
*---------------FIN GRABACION DE LA ACTUALIZACION

	       ENDFOR
	    ENDIF
**********FIN ACTUALIZACION POR PERIODOS

**********INCREMENTO DE LAS FILAS
	    @ nNroFil,11 SAY IF(lRegAct ,'YA ACTUALIZADO','')
	    nNroFil++
	    IF nNroFil > 21
	       nNroFil := nMarco(03,'GRUPO:'+cCodGru,22)
	       @ nNroFil,01 SAY 'No.'
	       @ nNroFil,04 SAY 'CODIGO'
	       @ nNroFil,11 SAY 'ESTADO'
	    ENDIF
**********FIN INCREMENTO DE LAS FILAS

	  NOT->(DBSKIP())

       ENDDO
       CloseDbf('NOT')
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS CODIGOS


/*************************************************************************
* TITULO..: ACTUALIZACION DE LOS LOGROS                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 AM   MAY 28/2002 MAR

OBJETIVOS:

1- Actuliza los c¢digos de los indicadores agregando el espacio para
   el control de las Recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cLogrosAct(cLogros)

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cIndAct := ''                  // Indicadores Actualizados
       LOCAL nNroInd := 0                   // N£mero de Indicadores
       LOCAL cCodLog := ''                  // C¢digo del Logro
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ACTUALIZACION DE LOS INDICADORES
       nNroInd := ROUND(LEN(ALLTRIM(cLogros))/5,0)
       FOR i := 1 TO nNroInd

	   cCodLog := SUBS(cLogros,i*5-4,5)
	   IF !LEN(cCodLog) == 5
	      cError('LA LONGITUD DEL CODIGO NO ES IGUAL A 5')
	   ENDIF
	   cIndAct += cCodLog+SPACE(01)

       ENDFOR
       RETURN cIndAct
*>>>>FIN ACTUALIZACION DE LOS INDICADORES