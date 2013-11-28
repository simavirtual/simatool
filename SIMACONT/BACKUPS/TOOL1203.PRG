/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...:
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: ACTUALIZAR MAEIMPORT.DAT CONTRATANTES                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2011 SAB A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2011 SAB

OBJETIVOS:

1- Actualiza la informaci¢n de los estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_203(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL       k := 0                   // Contador

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

*>>>>ANALISIS DE DECISION
       cError(PathMtr,'PATH SIMAMATR')
       cError(PathCon,'PATH SIMACONT')
       cError(PathPro,'PATH SIMAPROF')
       cError(PathCar,'PATH SIMACART')
       cError(PathCaF,'PATH SIMACAFE')


       IF !lPregunta('DESEA CONTINUAR? Si No')
	  CloseAll()
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathCon+'\'+'\'+;
			 FileAlu+'IMPOR'+ExtFile,'IMP',NIL,.F.,nModCry})
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

*>>>>RECORRIDO DE REGISTROS
       SELECT IMP
       IMP->(DBGOTOP())

       DO WHILE .NOT. IMP->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('CONTRATANTES:'+IMP->(STR(RECNO(),4))+'/'+;
					IMP->(STR(RECCOUNT(),4)),cNomSis)
**********FIN LINEA DE ESTADO

**********GRABACION DEL REGISTRO
	    IF IMP->(lRegLock(lShared,.F.))

	       DO CASE
	       CASE VAL(IMP->cNitCo1Est) == 0 .AND. EMPTY(IMP->cNitCo2Est) .AND.;
		    EMPTY(IMP->cNitCo3Est) .AND. EMPTY(IMP->cNitCo4Est)

		     DO CASE
		     CASE VAL(IMP->cPadNitEst) # 0

			  REPL IMP->cNitCo1Est WITH IMP->cPadNitEst
			  REPL IMP->cTxtTemEst WITH 'NOP='+ALLTRIM(STR(++k,4))

		     CASE .NOT. EMPTY(IMP->cMadNitEst)

			  REPL IMP->cNitCo1Est WITH IMP->cMadNitEst
			  REPL IMP->cTxtTemEst WITH 'NOM='+ALLTRIM(STR(++k,4))


		     ENDCASE

	       CASE VAL(IMP->cNitCo1Est) == 0

		    DO CASE
		    CASE !EMPTY(IMP->cNitCo2Est)

			 REPL IMP->cNitCo1Est WITH IMP->cNitCo2Est
			 REPL IMP->cTipCo1Est WITH IMP->cTipCo2Est
			 REPL IMP->lNoRCo1Est WITH IMP->lNoRCo2Est

			 REPL IMP->cNitCo2Est WITH ''
			 REPL IMP->cTipCo2Est WITH ''
			 REPL IMP->lNoRCo2Est WITH .F.

			 REPL IMP->cTxtTemEst WITH 'cNitCo1=cNitCo12'

		    CASE EMPTY(IMP->cNitCo2Est)

			 DO CASE
			 CASE VAL(IMP->cPadNitEst) # 0
			      REPL IMP->cNitCo1Est WITH IMP->cPadNitEst
			      REPL IMP->cTipCo1Est WITH '1'
			      REPL IMP->lNoRCo1Est WITH .F.
			      REPL IMP->cTxtTemEst WITH 'cNitCo1=cPadNit'

			 CASE VAL(IMP->cMadNitEst) # 0
			      REPL IMP->cNitCo1Est WITH IMP->cMadNitEst
			      REPL IMP->cTipCo1Est WITH '1'
			      REPL IMP->lNoRCo1Est WITH .F.
			      REPL IMP->cTxtTemEst WITH 'cNitCo1=cMadNit'

			 OTHERWISE
			    REPL IMP->cTxtTemEst WITH 'REVISAR'
			 ENDCASE


		    ENDCASE


	       ENDCASE

	       IMP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       IMP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  IMP->(DBSKIP())
	*ÀAvance del registro


       ENDDO
       oBrwMae(lShared,cAnoUsr,'IMP')
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS