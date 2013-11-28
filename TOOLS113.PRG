/*                      SIMA - SISTEMA UTILITARIO
			    MODULO No. 113

MODULO      : SIMACONT - MANTENIMIENTO
SUBMODULO...: PRN CODIGOS

**************************************************************************
* TITULO..: IMPRESION DE CODIGOS DE INDICADORES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   MAY 29/2002 MIE

OBJETIVOS:

1- Imprime los c¢digos de los indicadores de cada una de las materias.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tools_113(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
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

*>>>>LECTURA DEL NUMERO DEL PERIODO
       @ nFilInf+2,nColInf+1 SAY 'PERIODO' GET nNroPer PICT '9';
			     VALID nNroPer <= 5
       READ
       IF nNroPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL PERIODO

*>>>>LECTURA DEL CODIGO DE LA MATERIA
       cCodigoTma := SPACE(04)
       @ nFilInf+3,nColInf+1 SAY 'MATERIA' GET cCodigoTma PICT '9999'
       READ
       IF EMPTY(cCodigoTma)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DE LA MATERIA

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

*>>>>IMPRESION DE LOS CODIGOS DE INDICADORES
       PrnCodNot(lShared,cNomSis,cNomEmp,cAnoUsr,;
		 NOT->(DBSTRUCT()),;
		 cCodigoTgr,cCodigoTma,nNroPer)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CODIGOS DE INDICADORES