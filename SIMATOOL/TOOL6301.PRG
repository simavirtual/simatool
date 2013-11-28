/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: CONSULTAS
SUBMENU...:
SISTEMA...: SIMATOOL

**************************************************************************
* TITULO..: CONSULTAR TEMP                                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 03/2012 MAR A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ABR 03/2012 MAR

OBJETIVOS:

1- Consulta el archivo TEMP.DAT


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool6_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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


       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES


*>>>>CONSULTA DEL ARCHIVO TEM
       MantenTem(cNomSis)
*>>>>FIN CONSULTA DEL ARCHIVO TEM


/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO TEMP                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 03/2012 MAR A
       Bucaramanga, Colombia	    INICIO: 10:00 AM   ABR 03/2012 MAR

1- Permite la consulta del archivo temp.

2- Retorna Nil


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTem(cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas

       LOCAL oBrwUsr := NIL		    // Objeto Browse de Usuarios
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECION DE LAS AREAS DE TRABAJO
       DBUSEAREA(.T.,NIL,'BASES\TEMP.DBF',"AAA",.F.,.F.)
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       IF AAA->(RECCOUNT()) # 0
	  SELECT AAA
	  oBrwUsr := oDefBrwTem(03,00,22,79,cNomSis)
	  AAA->(CtrlBrw(.T.,oBrwUsr))
       ELSE
	  cError('NO EXISTEN USUARIOS')
       ENDIF
       CloseAll()
       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO

/*************************************************************************
* TITULO..: DEFINICION DEL OBJETO BROWSE DE USUARIOS                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 03/2012 MAR A
       Bucaramanga, Colombia	    INICIO: 10:30 AM   ABR 03/2012 MAR

1- Define el objeto Browse del archivo Temp.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION oDefBrwTem(nFilSup,nColSup,nFilInf,nColInf,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     nFilSup	                            // Fila Superior
       nColSup	                            // Columna Superior
       nFilInf	                            // Fila Inferior
       nColInf	                            // Columna Inferior
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL oColumn := NIL                 // Columna del objeto
       LOCAL oBrowse := NIL                 // Browse de Tarifas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DEFINICION DEL OBJETO BROWSE
       oBrowse := TBROWSEDB(nFilSup+1,nColSup+1,nFilInf-1,nColInf-1)
      *Definici¢n de Objeto y asignaci¢n de las coordenadas

       oBrowse:ColSep    := '³'
       oBrowse:HeadSep   := 'Ä'
       oBrowse:Cargo     := {'<<SISTEMA>>',;
			    '<ESC>Abandonar'}
     *ÀDefinici¢n de cabeceras y l¡neas de cabeceras

       SELECT AAA
       oColumn	     := TBCOLUMNNEW('A',;
				   {||CRYPT(SUBS(AAA->A,121,10),"IVANAN")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       oColumn := TBCOLUMNNEW('B',;
			      {||CRYPT(SUBS(AAA->A,1,10),"IVANAN")})
       oColumn:Cargo := {{'MODI',.F.}}
       oBrowse:ADDCOLUMN(oColumn)
     *ÀDefinici¢n Columna

       RETURN oBrowse
*>>>>FIN DEFINICION DEL OBJETO BROWSE