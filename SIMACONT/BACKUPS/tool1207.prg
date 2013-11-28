/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: MAEARCHI.DAT ACTUALIZAR
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: MAEARCHI.DAT ACTUALIZAR                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2011 SAB A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2011 SAB

OBJETIVOS:

1- Actualiza la informaci¢n de los estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_207(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL       k := 0                   // Contador
       LOCAL aDbfStr := {}                  // Estructura del Archivo
       LOCAL cCampo1 := ''                  // Campo1
       LOCAL cCampo2 := ''                  // Campo2

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
       AADD(aUseDbf,{.T.,PathCon+'\'+PathSis+'\'+;
			 FileAlu+'ALU'+ExtFile,'ALU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathCon+'\'+PathSis+'\'+;
			 FileAlu+'ARCHI'+ExtFile,'ARC',;
			 PathCon+'\'+PathSis+'\'+;
			 fNtxAlu+'ARCHI'+cExtNtx,;
			 lShared,nModCry})
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
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+'ALU'+ExtFile)

       CASE ARC->(RECCOUNT()) # 0
	    cError('EXISTEN REGISTROS EN '+FileAlu+'ARCHI'+ExtFile)

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

       aDbfStr := ALU->(DBSTRUCT())
       DO WHILE .NOT. ALU->(EOF())

**********LOCALIZACION DEL CODIGO
	    IF lSekCodigo(ALU->cCodigoEst,'ARC')

	       ALU->(DBSKIP())
	       LOOP

	    ENDIF
**********FIN LOCALIZACION DEL CODIGO

**********GRABACION DEL REGISTRO
	    SELECT ARC
	    IF ARC->(lRegLock(lShared,.T.))

	       FOR k := 1 TO LEN(aDbfStr)

		   SELECT ALU
		   LineaEstado('A¥O:'+ALU->cAnoUsrEst+':'+;
			       'CAMPO:'+UPPER(aDbfStr[k,1])+':'+;
			       cMaeAct+':'+STR(RECNO(),6)+'/'+;
					   STR(RECCOUNT(),6),cNomSis)

		   cCampo1 := 'ARC->'+UPPER(aDbfStr[k,1])
		   cCampo2 := 'ALU->'+UPPER(aDbfStr[k,1])

		   REPL &cCampo1 WITH &cCampo2

	       ENDFOR
	       ARC->(DBCOMMIT())


	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       ARC->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  ALU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR ALUMNOS