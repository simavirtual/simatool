/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ARCHIVOS
SUBMENU...: CONSULTAR NOTAS
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 501

**************************************************************************
* TITULO..: CONSULTAR REGISTROS DE NOTAS                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 20/2002 MIE

OBJETIVOS:

1- Permite consultar los registros de los archivos de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_501(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nNroPar := 0                   // Parte del Archivo a Mostrar
       LOCAL oBrowse := NIL                 // Browse del Archivo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
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
       AADD(aUseDbf,{.T.,PathCon+'\'+cMaeAct+'\NOTAS\'+;
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

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE DE NOTAS	                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MAR A
       Colombia, Bucaramanga        INICIO: 01:00 AM   MAY 29/2002 MAR

OBJETIVOS:

1- Define el objeto Browse del archivo de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwNot(lShared,nFilSup,nColSup,nFilInf,nColInf,nNroPar,cCodGru)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       nNroPar                              // N£mero de la Parte a Mostrar
       cCodGru                              // C¢digo del Grupo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL cCampo  := ''                  // Campo
       LOCAL nDiviso := 0                   // Division por 9
       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL nPosFin := 0                   // Posici¢n Final

       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<MANTENIMIENTO DE NOTAS GRUPO:'+cCodGru+'>>',;
			     '<ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT NOT
       oColumn := TBCOLUMNNEW('No.',{||NOT->(RECNO())})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       aStrDbf := NOT->(DBSTRUCT())
       nDiviso := ROUND(LEN(aStrDbf)/9,0)
       DO CASE
       CASE nNroPar == 1
	    nPosIni := nNroPar
	    nPosFin := nDiviso
       CASE nNroPar == 2
	    nPosIni := nDiviso+1
	    nPosFin := 2*nDiviso
       CASE nNroPar == 9
	    nPosIni := ((nNroPar-1)*nDiviso)+1
	    nPosFin := LEN(aStrDbf)
       OTHERWISE
	    nPosIni := ((nNroPar-1)*nDiviso)+1
	    nPosFin := nNroPar*nDiviso
       ENDCASE

       FOR i := nPosIni TO nPosFin
	   cCampo  := aStrDbf[i,1]
	   oColumn := TBCOLUMNNEW(ALLTRIM(STR(i,3))+':'+cCampo,{||&cCampo})
	   oColumn:Cargo := {{'MODI',.F.}}
	   oBrowse:ADDCOLUMN(oColumn)
	 *ÀDefinici¢n Columna
       ENDFOR

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE