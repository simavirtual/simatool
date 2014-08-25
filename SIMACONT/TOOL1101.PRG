/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: CODIGOS RECUPERACIONES
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 101

**************************************************************************
* TITULO..: COLEGIOS DE PROCEDENCIA                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 03/2014 MAR A
       Colombia, Bucaramanga        INICIO: 10:30 PM   JUN 03/2014 MAR

OBJETIVOS:

1- Crea una archivo con los Colegios de Procedencia de los Estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL     i,j := 0                   // Contador
       LOCAL cNroTem := ''                  // N£mero temporal

       LOCAL aProced := {}		    // Procendencia del Estudiante
       LOCAL cAnoCol := ''                  // A¤o de Procedencia
       LOCAL cCodNiv := ''                  // C¢digo del Grado
       LOCAL cNomNiv := ''                  // Nombre del Grado
       LOCAL cNomCol := ''                  // Nombre del Colegio
       LOCAL cCiuCol := ''                  // Ciudad del Colegio

       LOCAL Getlist := {}                  // Variable del sistema
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
       AADD(aUseDbf,{.T.,PathCon+'\'+fColPrc,'COL',NIL,lShared,nModCry})
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
       CASE !COL->(RECCOUNT()) == 0
	    cError('YA ESTAN GRABADOS LOS COLEGIOS DE PROCEDENCIA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO POR NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)

	     IF !lUseDbf(.T.,PathCon+'\'+cMaeAct+'\'+;
			     FileAlu+cMaeAct+cAnoSis+ExtFile,;
			     cMaeAct,NIL,lShared)
		cError('ABRIENDO ARCHIVOS')
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN SELECION DE LAS AREAS DE TRABAJO

***********VALIDACION DE CONTENIDOS DE ARCHIVOS
	     lHayErr := .T.
	     SELECT &cMaeAct
	     DO CASE
	     CASE RECCOUNT() == 0
		  cError('NO EXISTE ESTUDIANTES GRABADOS')

	     OTHERWISE
		  lHayErr :=.F.
	     ENDCASE
	     IF lHayErr
		CloseAll(aUseDbf)
		RETURN NIL
	     ENDIF
***********FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

***********RECORRIDO POR ALUMNOS
	     SELECT &cMaeAct
	     DBGOTOP()
	     DO WHILE .NOT. EOF()

		SELECT &cMaeAct

*===============LINEA DE ESTADO
		  LineaEstado(cMaeAct+':'+STR(RECNO(),4)+'/'+;
					  STR(RECCOUNT(),4)+;
			      'ºCODIGO:'+&cMaeAct->cCodigoEst,cNomSis)
*===============FIN LINEA DE ESTADO

*===============TRANSICION
		  aProced := {}
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole00Est))

		     cAnoCol := SUBS(&cMaeAct->cCole00Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole00Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole00Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole00Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN TRANSICION

*===============PRIMERO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole01Est))

		     cAnoCol := SUBS(&cMaeAct->cCole01Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole01Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole01Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole01Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN PRIMERO

*===============SEGUNDO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole02Est))

		     cAnoCol := SUBS(&cMaeAct->cCole02Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole02Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole02Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole02Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN SEGUNDO

*===============TERCERO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole03Est))

		     cAnoCol := SUBS(&cMaeAct->cCole03Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole03Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole03Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole03Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN TERCERO

*===============CUARTO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole04Est))

		     cAnoCol := SUBS(&cMaeAct->cCole04Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole04Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole04Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole04Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN CUARTO

*===============QUINTO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole05Est))

		     cAnoCol := SUBS(&cMaeAct->cCole05Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole05Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole05Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole05Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN QUINTO

*===============SEXTO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole06Est))

		     cAnoCol := SUBS(&cMaeAct->cCole06Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole06Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole06Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole06Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN SEXTO

*===============SEPTIMO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole07Est))

		     cAnoCol := SUBS(&cMaeAct->cCole07Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole07Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole07Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole07Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN SEPTIMO

*===============OCTAVO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole08Est))

		     cAnoCol := SUBS(&cMaeAct->cCole08Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole08Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole08Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole08Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN OCTAVO

*===============NOVENO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole09Est))

		     cAnoCol := SUBS(&cMaeAct->cCole09Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole09Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole09Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole09Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN NOVENO

*===============DECIMO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole10Est))

		     cAnoCol := SUBS(&cMaeAct->cCole10Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole10Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole10Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole10Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})

		  ENDIF
*===============FIN DECIMO

*===============UNDECIMO
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole11Est))

		     cAnoCol := SUBS(&cMaeAct->cCole11Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole11Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole11Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole11Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN UNDECIMO

*===============MATERNALES
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole12Est))

		     cAnoCol := SUBS(&cMaeAct->cCole12Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole12Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole12Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole12Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN MATERNALES

*===============CAMINADORES
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole13Est))

		     cAnoCol := SUBS(&cMaeAct->cCole13Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole13Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole13Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole13Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN CAMINADORES

*===============PARVULOS
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole14Est))

		     cAnoCol := SUBS(&cMaeAct->cCole14Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole14Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole14Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole14Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN PARVULOS

*===============PREJARDIN
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole15Est))

		     cAnoCol := SUBS(&cMaeAct->cCole15Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole15Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole15Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole15Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN PREJARDIN

*===============JARDIN
		  IF !EMPTY(ALLTRIM(&cMaeAct->cCole16Est))

		     cAnoCol := SUBS(&cMaeAct->cCole16Est,01,04)  // A¤o
		     cNomNiv := SUBS(&cMaeAct->cCole16Est,05,10)  // Nivel
		     cNomCol := SUBS(&cMaeAct->cCole16Est,15,40)  // Colegio
		     cCiuCol := SUBS(&cMaeAct->cCole16Est,55,20)  // Ciudad

		     AADD(aProced,{cAnoCol,cNomNiv,cNomCol,cCiuCol})
		  ENDIF
*===============FIN JARDIN

*===============GRABACION DEL REGISTRO
		  SELECT COL
		  IF COL->(lRegLock(lShared,.T.))

		     REPL COL->nIdeCodCol WITH COL->(RECNO())
		     REPL COL->cCodigoEst WITH &cMaeAct->cCodigoEst
		     REPL COL->cNombreEst WITH &cMaeAct->cNombreEst
		     REPL COL->cApelliEst WITH &cMaeAct->cApelliEst
		     REPL COL->cCodigoGru WITH &cMaeAct->cCodigoGru

		     FOR j := 1 TO LEN(aProced)

			 cNroTem := STR(j,2)
			 lCorrecion(@cNroTem)

			 cAnoCol := 'COL->cYear'+cNroTem+'Col'
			 cNomNiv := 'COL->cGrad'+cNroTem+'Col'
			 cNomCol := 'COL->cCole'+cNroTem+'Col'
			 cCiuCol := 'COL->cCiud'+cNroTem+'Col'

			 REPL &cAnoCol WITH aProced[j,1]
			 REPL &cNomNiv WITH aProced[j,2]
			 REPL &cNomCol WITH aProced[j,3]
			 REPL &cCiuCol WITH aProced[j,4]

		     ENDFOR

		     REPL COL->cNomUsrCol WITH cNomUsr
		     REPL COL->dFecUsrCol WITH DATE()
		     REPL COL->cHorUsrCol WITH TIME()


		     COL->(DBCOMMIT())

		  ELSE
		     cError('NO SE GRABA LOS LOGROS DEL ESTUDIANTE')
		  ENDIF
		  IF lShared
		     COL->(DBUNLOCK())
		  ENDIF


*===============FIN GRABACION DEL REGISTRO

		SELECT &cMaeAct
		DBSKIP()

	     ENDDO
***********FIN RECORRIDO POR ALUMNOS

       ENDFOR
       CloseAll()
       RETURN NIL
*>>>>FIN RECORRIDO POR NIVELES
