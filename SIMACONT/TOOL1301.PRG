/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...:
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: ACTUALIZAR MAEIMPORT.DAT                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 20/2002 MIE A
       Colombia, Bucaramanga        INICIO: 02:30 PM   AGO 20/2002 MIE

OBJETIVOS:

1- Actualiza la ubicaci¢n de los c¢digos de los indicadores para permitir
   el control de las recuperaciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_301(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       oBrwMae(lShared,cAnoUsr,'IMP')

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS


********************

FUNCTION oBrwMae(lShared,cAnoUsr,cNalias)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cAnoUsr                              // A¤o del Usuario
       cNalias                              // Alias del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := NIL                 // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse

       LOCAL nCampos := 50                  // Campos a Consultar
       LOCAL nNroPar := 0                   // Parte del archivo a Consultar
       LOCAL nTotPar := 0                   // Total de Partes a Consultar

       LOCAL nPosIni := 0                   // Posici¢n Inicial
       LOCAL nPosFin := 0                   // Posici¢n Final

       LOCAL aStrDbf := {'1'}               // Estructura del Archivo
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL oBrowse := NIL                 // Browse de Alumnos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE DECISION
       SELECT &cNalias
       aDbfStr := DBSTRUCT()

       CreaDbfAlu(,,,,@aStrDbf)

       IF LEN(aDbfStr) # LEN(aStrDbf)
	  cError( STR(LEN(aDbfStr),4)+':'+STR(LEN(aStrDbf),4) )
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>LECTURA DE LA PARTE
       nTotPar := 1
       IF LEN(aDbfStr) > nCampos
	  nTotPar := INT(LEN(aDbfStr)/nCampos)
	  IF LEN(aDbfStr)/nCampos > nTotPar
	     nTotPar++
	  ENDIF
       ENDIF

       IF nTotPar > 1

	 nNroPar := 1
	 @ 21,20 SAY 'PARTE A VISUALIZAR: <DE 1 A '+STR(nTotPar,2)+'?';
		GET nNroPar PICT '99';
		VALID nNroPar > 0 .AND. nNroPar <= nTotPar
	 READ

       ENDIF
*>>>>FIN LECTURA DE LA PARTE

*>>>>CAMPOS A VISUALIZAR
       IF nTotPar > 1

	  DO CASE
	  CASE nNroPar == 1
	       nPosIni := 1
	       nPosFin := nCampos
	  CASE nNroPar == nTotPar
	       nPosIni := ((nNroPar-1)*nCampos)+1
	       nPosFin := LEN(aDbfStr)
	  OTHERWISE
	       nPosIni := ((nNroPar-1)*nCampos)+1
	       nPosFin := nNroPar*nCampos
	  ENDCASE

       ELSE
	  nPosIni := 1
	  nPosFin := LEN(aDbfStr)
       ENDIF
*>>>>FIN CAMPOS A VISUALIZAR

*>>>>DEFINICION DEL BROWSE
       cTitSup := '<< CONSULTAS DE ESTUDIANTES.'+cNalias+;
		  ' .TOTAL ='+STR(RECCOUNT(),4)+' A¥O: '+cAnoUsr+' >>'
      *ÀT¡tulo Superior del Browse


	aCampos := {}
	FOR i := nPosIni TO nPosFin
	    AADD(aCampos,{{STR(i,4)+':'+aDbfStr[i,1],aDbfStr[i,1]},{NIL}})
	ENDFOR


*	AADD(aCampos,{{"cCodigoGru","cCodigoGru"},{NIL}})


/*
       aCampos := {{{"cCodigoEst","cCodigoEst"},{NIL}},;
		   {{"cTxtTemEst","cTxtTemEst"},{NIL}}}
*/


/*
       aCampos := {{{"cCodigoEst","cCodigoEst"},{NIL}},;
		   {{"cCodigoGru","cCodigoGru"},{NIL}},;
		   {{"cApelliEst","cApelliEst"},{NIL}},;
		   {{"cNombreEst","cNombreEst"},{NIL}},;
		   {{"dFecMatEst","dFecMatEst"},{NIL}},;
		   {{"cHorMatEst","cHorMatEst"},{NIL}},;
		   {{"lRetiroEst","lRetiroEst"},{NIL}},;
		   {{"dFecRetEst","dFecRetEst"},{NIL}},;
		   {{"dFecNacEst","dFecNacEst"},{NIL}},;
		   {{"cApePadEst","cApePadEst"},{NIL}},;
		   {{"cNomPadEst","cNomPadEst"},{NIL}},;
		   {{"cApeMadEst","cApeMadEst"},{NIL}},;
		   {{"cNomMadEst","cNomMadEst"},{NIL}},;
		   {{"cPadTntEst","cPadTntEst"},{NIL}},;
		   {{"cPadNitEst","cPadNitEst"},{NIL}},;
		   {{"cMadTntEst","cMadTntEst"},{NIL}},;
		   {{"cMadNitEst","cMadNitEst"},{NIL}},;
		   {{"cTipCo1Est","cTipCo1Est"},{NIL}},;
		   {{"cNitCo1Est","cNitCo1Est"},{NIL}},;
		   {{"cTipCo2Est","cTipCo2Est"},{NIL}},;
		   {{"cNitCo2Est","cNitCo2Est"},{NIL}},;
		   {{"cTipCo3Est","cTipCo3Est"},{NIL}},;
		   {{"cNitCo3Est","cNitCo3Est"},{NIL}},;
		   {{"cTipCo4Est","cTipCo4Est"},{NIL}},;
		   {{"cNitCo4Est","cNitCo4Est"},{NIL}},;
		   {{"cTxtTemEst","cTxtTemEst"},{NIL}}}
*/
     *ÀDefinici¢n de Campos

       cTitInf := '<ESC>Abandona'
      *ÀT¡tulo Inferior del Browse

       oBrowse := oBrowse(03+1,00,22,79,cTitSup,cTitInf,aCampos)
     *Creaci¢n del Browse

       CtrlBrw(lShared,oBrowse)

       RETURN NIL
*>>>>FIN DEFINCION DEL BROWSE