/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: MAEA¥O VS MAEIMPOR
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: MAEA¥O VS MAEIMPORT                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 03/2011 MAR A
       Colombia, Bucaramanga        INICIO: 02:30 PM   MAY 03/2011 MAR

OBJETIVOS:

1- Verifica la informaci¢n de los estudiantes.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_208(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema

       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL lHayReg := .F.                 // .T. Existe el registro
       LOCAL cTxtAlu := ''                  // Texto temporal
       LOCAL cTxtImp := ''                  // Texto temporal

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)

       PathMtr := PathMtr
       PathCon := PathCon
       PathPro := PathPro
       PathCar := PathCar
       PathCaf := PathCaf
*>>>>FIN LECTURA DE PATHS


*>>>>ANALISIS DE DECISION
       cError(PathMtr+'\'+cPatSis,'PATH SIMAMATR')
       cError(PathCon+'\'+cPatSis,'PATH SIMACONT')
       cError(PathPro+'\'+cPatSis,'PATH SIMAPROF')
       cError(PathCar+'\'+cPatSis,'PATH SIMACART')
       cError(PathCaF+'\'+cPatSis,'PATH SIMACAFE')


       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
       SETCURSOR(1)                         // Activaci¢n del cursor
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+cAnoUsr+ExtFile,'ALU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'IMPOR'+ExtFile,'IMP',NIL,lShared,nModCry})
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
       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+cAnoUsr+ExtFile)

       CASE IMP->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+'IMPOR'+ExtFile)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO POR ALUMNOS
       SELECT ALU
       ALU->(DBGOTOP())

       DO WHILE .NOT. ALU->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTRO:'+STR(RECNO(),6)+'/'+;
				    STR(RECCOUNT(),6),cNomSis)
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','IMP',ALU->cCodigoEst)
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS DE DECISION
	    cTxtAlu := ''
	    cTxtImp := ''
	    IF lHayReg

	       IF ALU->cCodigoEst # IMP->cCodigoEst
		  cTxtAlu += IMP->cCodigoEst+'# '
		  cTxtImp += ALU->cCodigoEst+'# '
	       ENDIF

	       IF ALU->lRetiroEst # IMP->lRetiroEst
		  cTxtAlu := 'RETIRO# '
		  cTxtImp := 'RETIRO# '
	       ENDIF

	       IF ALU->cCodigoGru # IMP->cCodigoGru
		  cTxtAlu += IMP->cCodigoGru+'# '
		  cTxtImp += ALU->cCodigoGru+'# '
	       ENDIF

	       IF ALU->cApelliEst # IMP->cApelliEst
		  cTxtAlu += IMP->cApelliEst+'# '
		  cTxtImp += ALU->cApelliEst+'# '
	       ENDIF

	       IF ALU->cNombreEst # IMP->cNombreEst
		    cTxtAlu := IMP->cNombreEst+'# '
		    cTxtImp := ALU->cNombreEst+'# '
	       ENDIF

	       IF EMPTY(cTxtAlu)
		  cTxtAlu := 'OK'
	       ENDIF

	       IF EMPTY(cTxtImp)
		  cTxtImp := 'OK'
	       ENDIF
	    ELSE
	       cTxtAlu := 'NO EXISTE EN MAEIMPOR'
	       cTxtImp := ''
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL REGISTRO
	    SELECT ALU
	    IF ALU->(lRegLock(lShared,.F.))

	       REPL ALU->cTxtTemEst WITH cTxtAlu

	       ALU->(DBCOMMIT())


	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       ALU->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

**********GRABACION DEL REGISTRO
	    IF lHayReg

	       SELECT IMP
	       IF IMP->(lRegLock(lShared,.F.))

		  REPL IMP->cTxtTemEst WITH cTxtImp

		  IMP->(DBCOMMIT())


	       ELSE
		  cError('NO SE GRABA EL REGISTRO')
	       ENDIF
	       IF lShared
		  IMP->(DBUNLOCK())
	       ENDIF

	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  ALU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR ALUMNOS