/*                      SIMA - SISTEMA UTILITARIO
			    MODULO No. 121

MODULO      : SIMACONT - ACTUALIZAR
SUBMODULO...: NOTAS

**************************************************************************
* TITULO..: ACTUALIZACION ESTRUCTURA DE NOTAS                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 11:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Actualiza la Estructura de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tools_121(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nRegIni := 0                   // Registro inicial del grupo
       LOCAL nRegFin := 0                   // Registro Final del grupo
       LOCAL cGruFin := ''                  // C¢digo del grupo final
       LOCAL lValida := .F.                 // Validar el Proceso
       LOCAL fArchvo := ''                  // Archivo

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\'+;
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

**********VALIDACION DEL PROCESO
	    IF lValida
	       cError('GRUPO: '+GRU->cCodigoGru+;
		      ' REGISTROS: '+STR(NOT->(RECCOUNT()),4))
	    ENDIF
**********FIN VALIDACION DEL PROCESO

	  CloseDbf('NOT')
	  GRU->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ACTUALIZACION DE LOS ARCHIVOS DE NOTAS