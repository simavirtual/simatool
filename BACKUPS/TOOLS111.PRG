/*                      SIMA - SISTEMA UTILITARIO
			    MODULO No. 111

MODULO      : SIMACONT - MANTENIMIENTOS
SUBMODULO...: NOTAS

**************************************************************************
* TITULO..: MANTENIMIENTO DE NOTAS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 12:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Permite el Mantenimientos de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tools_111(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL nNroPar := 0                   // Parte del Archivo a Mostrar
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
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

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaces('GRU','cCodigoGru')
       IF !lLeeCodGru(nFilInf+1,nColInf-1,@cCodigoTgr,cMaeAct)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       CloseAll(aUseDbf)
*>>>>FIN LECTURA DEL GRUPO

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,cPatSis+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodigoTgr+cAnoSis+ExtFile,'NOT',NIL,lShared,nModCry})
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
       CASE NOT->(RECCOUNT()) == 0
	    cError('NO EXISTEN NOTAS PARA EL GRUPO '+cCodigoTgr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DE LA PARTE DEL ARCHIVO A VISUALIZAR
       nNroPar := nLeeOpcion('PARTE A VISUALIZAR: <DE 1 A 9>?',9,'0')
*>>>>FIN LECTURA DE LA PARTE DEL ARCHIVO A VISUALIZAR

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oDefBrwNot(lShared,nFilPal+1,00,22,79,nNroPar,cCodigoTgr)
	  NOT->(CtrlBrw(lShared,oBrowse))
       ENDIF
       DBUNLOCKALL()
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO


***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/


