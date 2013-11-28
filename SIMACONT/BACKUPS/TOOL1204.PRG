/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...:
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: ACTUALIZAR INFORMACION DE LOS MAESTROS                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ABR 02/2011 SAB A
       Colombia, Bucaramanga        INICIO: 02:30 PM   ABR 02/2011 SAB

OBJETIVOS:

1- Actualiza la informaci¢n de los estudiantes


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_204(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL     i,k := 0                   // Contador

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
	    cError('NO EXISTEN REGISTROS EN. '+FileAlu+'IMPOR'+ExtFile)

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
					  STR(RECCOUNT(),4),cNomSis)
*===============FIN LINEA DE ESTADO

*===============LOCALIZACION DEL CODIGO
		  IF !lLocCodigo('cCodigoEst','IMP',&cMaeAct->cCodigoEst)
		     cError('CODIGO:'+&cMaeAct->cCodigoEst+' EN '+;
			    FileAlu+'IMPOR'+ExtFile)

		     SELECT &cMaeAct
		     DBSKIP()

		     LOOP

		  ENDIF
*===============FIN LOCALIZACION DEL CODIGO

*===============GRABACION DEL REGISTRO
		  SELECT &cMaeAct
		  IF lRegLock(lShared,.F.)

		     REPL &cMaeAct->lSiCupoEst WITH IMP->lSiCupoEst
		     REPL &cMaeAct->lEstNewEst WITH IMP->lEstNewEst

		     REPL &cMaeAct->cTipNitEst WITH IMP->cTipNitEst
		     REPL &cMaeAct->cDocNitEst WITH IMP->cDocNitEst

		     REPL &cMaeAct->cLugNitEst WITH IMP->cLugNitEst
		     REPL &cMaeAct->cApelliEst WITH IMP->cApelliEst
		     REPL &cMaeAct->cNombreEst WITH IMP->cNombreEst
		     REPL &cMaeAct->lSexFemEst WITH IMP->lSexFemEst
		     REPL &cMaeAct->dFecNacEst WITH IMP->dFecNacEst
		     REPL &cMaeAct->cLugNacEst WITH IMP->cLugNacEst


		     REPL &cMaeAct->cDireccEst WITH IMP->cDireccEst
		     REPL &cMaeAct->cCiudadEst WITH IMP->cCiudadEst
		     REPL &cMaeAct->cDepartEst WITH IMP->cDepartEst

		     REPL &cMaeAct->cTelefnEst WITH IMP->cTelefnEst
		     REPL &cMaeAct->cTelCelEst WITH IMP->cTelCelEst


		     REPL &cMaeAct->cMaiEstEst WITH IMP->cMaiEstEst


		     REPL &cMaeAct->dFecMatEst WITH IMP->dFecMatEst
		     REPL &cMaeAct->cHorMatEst WITH IMP->cHorMatEst

		     REPL &cMaeAct->cApePadEst WITH IMP->cApePadEst
		     REPL &cMaeAct->cNomPadEst WITH IMP->cNomPadEst
		     REPL &cMaeAct->lPadQepEst WITH IMP->lPadQepEst
		     REPL &cMaeAct->dNacPadEst WITH IMP->dNacPadEst
		     REPL &cMaeAct->cLugPadEst WITH IMP->cLugPadEst
		     REPL &cMaeAct->cPadNitEst WITH IMP->cPadNitEst
		     REPL &cMaeAct->cPadLugEst WITH IMP->cPadLugEst
		     REPL &cMaeAct->cPadTntEst WITH IMP->cPadTntEst
		     REPL &cMaeAct->cProPadEst WITH IMP->cProPadEst
		     REPL &cMaeAct->cEmpPadEst WITH IMP->cEmpPadEst
		     REPL &cMaeAct->cCarPadEst WITH IMP->cCarPadEst
		     REPL &cMaeAct->cDirPadEst WITH IMP->cDirPadEst
		     REPL &cMaeAct->cCiuPadEst WITH IMP->cCiuPadEst
		     REPL &cMaeAct->cDepPadEst WITH IMP->cDepPadEst
		     REPL &cMaeAct->cTelPadEst WITH IMP->cTelPadEst
		     REPL &cMaeAct->cCelPadEst WITH IMP->cCelPadEst
		     REPL &cMaeAct->cMaiPadEst WITH IMP->cMaiPadEst

		     REPL &cMaeAct->cApeMadEst WITH IMP->cApeMadEst
		     REPL &cMaeAct->cNomMadEst WITH IMP->cNomMadEst
		     REPL &cMaeAct->lMadQepEst WITH IMP->lMadQepEst
		     REPL &cMaeAct->dNacMadEst WITH IMP->dNacMadEst
		     REPL &cMaeAct->cLugMadEst WITH IMP->cLugMadEst
		     REPL &cMaeAct->cMadNitEst WITH IMP->cMadNitEst
		     REPL &cMaeAct->cMadLugEst WITH IMP->cMadLugEst
		     REPL &cMaeAct->cMadTntEst WITH IMP->cMadTntEst
		     REPL &cMaeAct->cProMadEst WITH IMP->cProMadEst
		     REPL &cMaeAct->cEmpMadEst WITH IMP->cEmpMadEst
		     REPL &cMaeAct->cCarMadEst WITH IMP->cCarMadEst
		     REPL &cMaeAct->cDirMadEst WITH IMP->cDirMadEst
		     REPL &cMaeAct->cCiuMadEst WITH IMP->cCiuMadEst
		     REPL &cMaeAct->cDepMadEst WITH IMP->cDepMadEst
		     REPL &cMaeAct->cTelMadEst WITH IMP->cTelMadEst
		     REPL &cMaeAct->cCelMadEst WITH IMP->cCelMadEst
		     REPL &cMaeAct->cMaiPadEst WITH IMP->cMaiPadEst

		     REPL &cMaeAct->cNitCo1Est WITH IMP->cNitCo1Est
		     REPL &cMaeAct->cTipCo1Est WITH IMP->cTipCo1Est
		     REPL &cMaeAct->lNoRCo1Est WITH IMP->lNoRCo1Est

		     REPL &cMaeAct->cNitCo2Est WITH IMP->cNitCo2Est
		     REPL &cMaeAct->cTipCo2Est WITH IMP->cTipCo2Est
		     REPL &cMaeAct->lNoRCo2Est WITH IMP->lNoRCo2Est

		     REPL &cMaeAct->cNitCo3Est WITH IMP->cNitCo3Est
		     REPL &cMaeAct->cTipCo3Est WITH IMP->cTipCo3Est
		     REPL &cMaeAct->lNoRCo3Est WITH IMP->lNoRCo3Est

		     REPL &cMaeAct->cNitCo4Est WITH IMP->cNitCo4Est
		     REPL &cMaeAct->cTipCo4Est WITH IMP->cTipCo4Est
		     REPL &cMaeAct->lNoRCo4Est WITH IMP->lNoRCo4Est

		     REPL &cMaeAct->cTxtTemEst WITH IMP->cTxtTemEst

		     DBCOMMIT()

		  ELSE
		     cError('NO SE GRABA EL REGISTRO')
		  ENDIF
		  IF lShared
		     DBUNLOCK()
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