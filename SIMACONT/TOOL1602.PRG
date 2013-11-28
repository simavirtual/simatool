/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ESTRUCTURAS
SUBMENU...: ESTRUCTURA NOTAS
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 602

**************************************************************************
* TITULO..: ESTRUCTURA DE NOTAS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:15 PM   MAY 29/2002 MAR

OBJETIVOS:

1- Visualiza la Estructura del Archivo de Notas

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_602(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL FileNot := ''                  // Archivo de Notas

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
       IF lPregunta('DESEA CONSULTAR LOS ARCHIVOS DEL DIRECTORIO DE NOTAS? Si No')
	  FileNot := PathCon+'\'+cMaeAct+'\NOTAS\'+;
		     'NT'+cCodigoTgr+cAnoSis+ExtFile
       ELSE
	  FileNot := PathCon+'\'+cMaeAct+'\NOTAS\BACKUPS\'+;
		     'NT'+cCodigoTgr+cAnoSis+ExtFile
       ENDIF

       aUseDbf := {}
       AADD(aUseDbf,{.T.,FileNot,'NOT',NIL,lShared,nModCry})
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

*>>>>BROWSE DE LA ESTRUCTURA
       oStrBrwNot(lShared,nFilPal+1,00,22,79,FileNot)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN BROWSE DE LA ESTRUCTURA


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

FUNCTION oStrBrwNot(lShared,nFilSup,nColSup,nFilInf,nColInf,FileNot)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       FileNot                              // Archivo de Notas */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 1                   // Contador
       LOCAL nTotEle := 0                   // Total de Elementos
       LOCAL aStrDbf := {}                  // Estructura del Archivo
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL		    // Browse del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBrowseNew(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       aStrDbf := NOT->(DBSTRUCT())
       nTotEle := LEN(aStrDbf)

       oBrowse:SkipBlock     := {|n|nSkipArray(n,@i,nTotEle,oBrowse)}
       oBrowse:GoTopBlock    := {||i:= 1}
       oBrowse:GoBottomBlock := {||i:=nTotEle}
       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<ESTRUCTURA DEL ARCHIVO: '+FileNot+'>>'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       oColumn         := TBColumnNew()
       oColumn:Heading := FileNot
       oColumn:Block   := {||aStrDbf[i,1]}
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'TIPO'
       oColumn:Block   := {||aStrDbf[i,2]}
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'TAMANO'
       oColumn:Block   := {||aStrDbf[i,3]}
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       oColumn         := TBColumnNew()
       oColumn:Heading := 'DECIMAL'
       oColumn:Block   := {||aStrDbf[i,4]}
       oBrowse:addColumn(oColumn)
     *ÀDefinici¢n Columna

       BrwArray(oBrowse,aStrDbf,@i)
       RETURN NIL
*>>>>FIN DEFINICION DEL OBJETO BROWSE