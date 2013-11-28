/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: INFORMES
SUBMENU...: DIAN
SISTEMA...: CARTERA ACADEMICA

**************************************************************************
* TITULO..: INFORMES DE LA DIAN DESCRIMINADO                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 08/2013 LUN A
       Colombia, Bucaramanga        INICIO: 07:30 AM   ABR 08/2013 LUN

OBJETIVOS:

1- Descrimina por conceptos el informe de la Dian

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool4_402(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
*>>>>DESCRIPCION DE PARAMETROS

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

       LOCAL cCodAct := ''                  // C¢digo Actual
       LOCAL cCodAnt := ''                  // C¢digo Anterior
       LOCAL lGrabar := .F.                 // Grabar el registro

       LOCAL cCampo1  := ''                 // STR(nNroAlu,6))
       LOCAL cCampo2  := ''                 // CLI->cCodigoEst
       LOCAL cCampo3  := ''                 // GRU->cCodigoGru

       LOCAL cCampo4  := ''                 // cDocNit
       LOCAL cCampo5  := ''                 // cApeUno
       LOCAL cCampo6  := ''                 // cApeDos
       LOCAL cCampo7  := ''                 // cNomUno
       LOCAL cCampo8  := ''                 // cNomDos
       LOCAL cCampo9  := ''                 // cDirecc
       LOCAL cCampo10 := ''                 // cCiudad
       LOCAL cCampo11 := ''                 // cDepart
       LOCAL cCampo12 := ''                 // SPACE(01) Pais
       LOCAL nCampo13 := 0                  // TRANS(nTotPag,"##########")
       LOCAL nCampo14 := 0                  // TRANS(nSdoAct,"##########")
       LOCAL nCampo15 := 0                  // TRANS(nTotFac,"##########")
       LOCAL nCampo16 := 0                  // TRANS(nTotPag,"##########")


       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
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
       AADD(aUseDbf,{.T.,PathSis+'\DIAN'+ExtFile,'DN1',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO


*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE DN1->(RECCOUNT()) == 0
	    cError('EL ARCHIVO DIAN1 NO CONTIENE REGISTROS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT DN1
       DN1->(DBGOTOP())
       DO WHILE .NOT. DN1->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+DN1->(STR(RECNO(),4))+'/'+;
				     DN1->(STR(RECCOUNT(),4))+;
			'ºDoc No.:'+DN1->cCampo4,cNomSis)
**********FIN LINEA DE ESTADO


	  DN1->(DBSKIP())
	*ÀAvance del registro


       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS



