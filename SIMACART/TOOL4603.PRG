/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ESTRUCTURAS
SUBMENU...: ACTUALIZACION DE CLIENTES
SISTEMA...: CARTERA ACADEMICA                       MODULO No. 601

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

FUNCTION Tool4_603(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL       i := 0                   // Contador
       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL PathAct := ''                  // Path Actual
       LOCAL fArchvo := ''                  // Archivo
       LOCAL aStrNew := {'1'}               // Estructura del Archivo Nuevo
       LOCAL cCampos := ''                  // Nombre del Campo

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

cError('NO HABILITADO')
RETURN NIL

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)

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
       IF !lPregunta('SE VA A COPIAR LOS ARCHIVOS DE CLIENTES A¥O: '+;
		    cAnoUsr+' DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA LA ACTUALIZACION')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>UBICACION PATH DE SIMACART
       PathAct := DIRNAME()
       IF !DIRCHANGE (PathCar) == 0
	  cError('NO SE PUDO UBICARSE EN EL DIRECTORIO '+PathCar)
	  CloseAll(aUseDbf)
	  DIRCHANGE (PathAct)
	  RETURN NIL
       ENDIF
       IF UPPER(DIRNAME()) # UPPER(PathCar)
	  cError('NO SE PUDO UBICARSE EN EL DIRECTORIO '+PathCar)
	  CloseAll(aUseDbf)
	  DIRCHANGE (PathAct)
	  RETURN NIL
       ENDIF

       IF !lPregunta('EL PATH DE SIMACART ES: '+DIRNAME()+' '+;
		     'DESEA CONTINUAR? No Si')
	  cError('SE ABANDONA LA ACTUALIZACION')
	  DIRCHANGE (PathAct)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN UBICACION PATH DE SIMACART

*>>>>COMPARACION DE ESTRUCTURAS DE CLIENTES
       IF !IguaStrCli(lShared,nModCry,PathCar,cAnoUsr,ExtFile)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN COMPARACION DE ESTRUCTURAS DE CLIENTES

*>>>>RECORRIDO POR GRUPOS
       SELECT GRU
       GO nRegFin
       cGruFin = GRU->cCodigoGru

       GO nRegIni
       DO WHILE GRU->(RECNO()) <= nRegFin

**********PREPARACION DE LAS VARIABLES DE ARCHIVO
	    FileCli := PathCar+'\CLIENTES\CL'+;
			       GRU->cCodigoGru+cAnoSis+'.DBF'

	    FileBak := PathCar+'\CLIENTES\BACKUPS\CL'+;
			       GRU->cCodigoGru+cAnoSis+ExtFile
**********FIN PREPARACION DE LAS VARIABLES DE ARCHIVO

**********SELECION DE LAS AREAS DE TRABAJO
	    IF !lUseDbf(.T.,FileCli,'CLI',NIL,lShared,nModCry) .OR.;
	       !lUseDbf(.T.,FileBak,'BAK',NIL,lShared,nModCry)

	       cError('ABRIENDO DE CLIENTES')
	       CloseDbf('CLI',FileCli,nModCry)
	       CloseDbf('BAK',FilePag,nModCry)
	       SELECT GRU
	       GRU->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN SELECION DE LAS AREAS DE TRABAJO

**********IMPRESION DE LA LINEA DE ESTADO
	    LineaEstado('ACTUALIZANDO EL GRUPO: '+GRU->cCodigoGru+'/'+;
			cGruFin+'ºFAVOR ESPERAR ...',cNomSis)
**********FIN IMPRESION DE LA LINEA DE ESTADO

**********ANALISIS DE LA PROTECION DE LA BASE DE DATOS
	    lHayErr := .F.
	    IF nModCry # 0

*--------------DESPROTECION DE LA BASE DE DATOS
		 IF nHayProtec(FileBak) == 1  // 1=>Protegida
		    IF !lProtecDbf(FileBak,'#DBFNTX&')
		       IF cError('El archivo '+FileBak+' No Se puede Accesar')
			  lHayErr := .T.
		       ENDIF
		    ENDIF
		 ENDIF
*--------------FIN DESPROTECION DE LA BASE DE DATOS

	    ENDIF
**********FIN ANALISIS DE LA PROTECION DE LA BASE DE DATOS

**********IMPRESION DEL CUERPO DEL INFORME
	    aStrNew := CLI->(DBSTRUCT())
	    SELECT CLI
	    GO TOP
	    DO WHILE .NOT. CLI->(EOF())

*--------------LOCALIZACION DEL CODIGO
		 IF !lLocCodigo('cCodigoEst','BAK',CLI->cCodigoEst)
		    cError('NO EXISTE EL CODIGO '+CLI->cCodigoEst)
		    CLI->(DBSKIP())
		    LOOP
		 ENDIF
*--------------FIN LOCALIZACION DEL CODIGO

*--------------ACTUALIZACION DEL REGISTRO
		 IF CLI->(lRegLock(lShared,.F.))

		    FOR i := 1 TO LEN(aStrNew)
			cCampos := ALLTRIM(aStrNew[i,1])
			REPL &('CLI->'+cCampos) WITH &('BAK->'+cCampos)
		    ENDFOR
		    CLI->(DBCOMMIT())
		 ELSE
		    cError('NO SE GRABAN LOS DETALLES DEL PAGO EN CLIENTES')
		 ENDIF
		 IF lShared
		    CLI->(DBUNLOCK())
		 ENDIF
*--------------FIN ACTUALIZACION DEL REGISTRO

	       SELECT CLI
	       CLI->(DBSKIP())

	    ENDDO
**********FIN IMPRESION DEL CUERPO DEL INFORME

	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       DIRCHANGE (PathAct)
       RETURN NIL
*>>>>FIN RECORRIDO POR GRUPOS
