/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: INFORMES
SUBMENU...: DIAN
SISTEMA...: CARTERA ACADEMICA

**************************************************************************
* TITULO..: INFORMES DE LA DIAN                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 25/2011 VIE A
       Colombia, Bucaramanga        INICIO: 07:30 AM   MAR 25/2011 VIE

OBJETIVOS:

1- Genera el informe de la Dian consolidando por c¢digo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool4_403(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       AADD(aUseDbf,{.T.,PathSis+'\DIAN1'+ExtFile,'DN1',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\DIAN2'+ExtFile,'DN2',NIL,lShared,nModCry})
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

       CASE DN2->(RECCOUNT()) # 0
	    cError('EL ARCHIVO DIAN2 DEBE ESTAR VACIO')

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
       cCodAnt := DN1->cCampo2
     *ÀC¢digo del Estudiante

       nCampo12 := 0
       nCampo13 := 0
       nCampo14 := 0
       nCampo15 := 0
       nCampo16 := 0
       DO WHILE .NOT. DN1->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+DN1->(STR(RECNO(),4))+'/'+;
				     DN1->(STR(RECCOUNT(),4))+;
			'ºCODIGO.:'+DN1->cCampo2,cNomSis)
**********FIN LINEA DE ESTADO

**********SUMATORIA POR CONTRATANTE
	    cCodAct := DN1->cCampo2
	    IF cCodAct == cCodAnt

	       IF !EMPTY(DN1->cCampo4)
		  cCampo1  := DN1->cCampo1
		  cCampo2  := DN1->cCampo2   // C¢digo del Estudiante
		  cCampo3  := DN1->cCampo3   // Curso
		  cCampo4  := DN1->cCampo4   // Documento *
		  cCampo5  := DN1->cCampo5   // Apellido1
		  cCampo6  := DN1->cCampo6   // Apellido2
		  cCampo7  := DN1->cCampo7   // Nombre1
		  cCampo8  := DN1->cCampo8   // Nombre2
		  cCampo9  := DN1->cCampo9   // Direcci¢n *
		  cCampo10 := DN1->cCampo10  // Ciudad *
		  cCampo11 := DN1->cCampo11  // Departamento *
		  cCampo12 := 'COLOMBIA'     // Pais
	       ENDIF

	       nCampo13 += VAL(DN1->cCampo13)
	       nCampo14 += VAL(DN1->cCampo14)
	       nCampo15 += VAL(DN1->cCampo15)
	       nCampo16 += VAL(DN1->cCampo16)

	    ENDIF
**********FIN SUMATORIA POR CONTRATANTE

	  DN1->(DBSKIP())
	*ÀAvance del registro

**********ANALISIS DEL CODIGO ANTERIOR
	    IF cCodAnt # DN1->cCampo2
	       cCodAnt := DN1->cCampo2
	       lGrabar := .T.
	    ELSE
	       lGrabar := .F.
	    ENDIF
**********FIN ANALISIS DEL CODIGO ANTERIOR


**********GRABACION DEL REGISTRO
	    IF lGrabar

	       IF DN2->(lRegLock(lShared,.T.))

		  REPL DN2->cCampo1  WITH STR(dn2->(recno()),3)
		  REPL DN2->cCampo2  WITH cCampo2
		  REPL DN2->cCampo3  WITH cCampo3
		  REPL DN2->cCampo4  WITH cCampo4
		  REPL DN2->cCampo5  WITH cCampo5
		  REPL DN2->cCampo6  WITH cCampo6
		  REPL DN2->cCampo7  WITH cCampo7
		  REPL DN2->cCampo8  WITH cCampo8
		  REPL DN2->cCampo9  WITH cCampo9
		  REPL DN2->cCampo10 WITH cCampo10
		  REPL DN2->cCampo11 WITH cCampo11
		  REPL DN2->cCampo12 WITH cCampo12

		  REPL DN2->cCampo13 WITH TRANS(nCampo13,"##########")
		  REPL DN2->cCampo14 WITH TRANS(nCampo14,"##########")
		  REPL DN2->cCampo15 WITH TRANS(nCampo15,"##########")
		  REPL DN2->cCampo16 WITH TRANS(nCampo16,"##########")

		  DN2->(DBCOMMIT())

		  cCampo1  := DN1->cCampo1
		  cCampo2  := DN1->cCampo2
		  cCampo3  := DN1->cCampo3
		  cCampo4  := DN1->cCampo4
		  cCampo5  := DN1->cCampo5
		  cCampo6  := DN1->cCampo6
		  cCampo7  := DN1->cCampo7
		  cCampo8  := DN1->cCampo8
		  cCampo9  := DN1->cCampo9
		  cCampo10 := DN1->cCampo10
		  cCampo11 := DN1->cCampo11
		  cCampo12 := 'COLOMBIA'

		  nCampo13 := 0
		  nCampo14 := 0
		  nCampo15 := 0
		  nCampo16 := 0

	       ELSE
		  cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	       ENDIF
	       IF lShared
		  DN2->(DBUNLOCK())
	       ENDIF

	    ENDIF
**********FIN GRABACION DEL REGISTRO

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS
