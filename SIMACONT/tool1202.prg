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

FUNCTION Tool1_202(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL nPosUno := 0                   // N£mero de la posici¢n
       LOCAL nPosDos := 0                   // N£mero de la posici¢n
       LOCAL nNroLen := 0                   // Longitud
       LOCAL cAnoCod := 0                   // A¤o del c¢digo del estudiante

       LOCAL aFecha  := {}                  // Fecha
       LOCAL cNroDia := ''                  // N£mero del d¡a
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cNroAno := ''                  // N£mdro del A¤o

       LOCAL lEstNew := .F.                 // .T. Estudiante nuevo
       LOCAL cCodGru := ''                  // C¢digo del Grupo
       LOCAL cFecRet := ''                  // Fecha de Retiro
       LOCAL dFecRet := ''                  // Fecha de retiro
       LOCAL cTelefn := ''                  // Telefono

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

       AADD(aUseDbf,{.T.,PathCon+'\'+'\'+;
			 fPerImp+'ESTIM'+ExtFile,'PEI',NIL,.F.,nModCry})


       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'ALU'+ExtFile,'ALU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'ACU'+ExtFile,'ACU',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO


/*
SELECT IMP
ZAP

SELECT PEI
ZAP
*/

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ALU->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+'ALU'+ExtFile)

/*
       CASE ACU->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+'ACU'+ExtFile)
*/

       CASE IMP->(RECCOUNT()) # 0
	    cError(FileAlu+'IMPOR'+ExtFile+'DEBE ESTAR VACIO')

       CASE PEI->(RECCOUNT()) # 0
	    cError(fPerImp+'ESTIM'+ExtFile+'DEBE ESTAR VACIO')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT ALU
       ALU->(DBGOTOP())

       DO WHILE .NOT. ALU->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('ACTUALIZAR:'+ALU->(STR(RECNO(),4))+'/'+;
				      ALU->(STR(RECCOUNT(),4)),cNomSis)
**********FIN LINEA DE ESTADO

**********VALIDACION DEL A¥O
	    IF VAL(cAnoUsr) # ALU->ANO

	       ALU->(DBSKIP())
	     *ÀAvance del registro

	       LOOP
	    ENDIF
**********FIN VALIDACION DEL A¥O

**********GRABACION DEL REGISTRO
	    IF IMP->(lRegLock(lShared,.T.))

	       REPL IMP->cCodigoEst WITH STR(ALU->cCodigoEst,6)
	       REPL IMP->cAnoUsrEst WITH cAnoUsr
	       REPL IMP->lSiCupoEst WITH .T.

	       lEstNew := .F.
	       IF VAL(cAnoUsr) < 2000
		  IF cCodAno(cAnoUsr) == SUBS(STR(ALU->cCodigoEst,6),1,2)
		     lEstNew := .T.
		  ENDIF
	       ELSE
		  IF cCodAno(cAnoUsr) == SUBS(STR(ALU->cCodigoEst,6),1,3)
		     lEstNew := .T.
		  ENDIF
	       ENDIF
	       REPL IMP->lEstNewEst WITH lEstNew

	       cCodGru := SUBS(ALU->cCodigoGru,AT('-',ALU->cCodigoGru)+1,4)
	       IF UPPER(SUBS(ALLTRIM(cCodGru),1,3)) == 'SIN'
		  DO CASE
		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'PRE'
		       cCodGru := '1500'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'JAR'
		       cCodGru := '1600'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'TRA'
		       cCodGru := '0000'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'PRI'
		       cCodGru := '0100'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'SEG'
		       cCodGru := '0200'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'TER'
		       cCodGru := '0300'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'CUA'
		       cCodGru := '0400'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'QUI'
		       cCodGru := '0500'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'SEX'
		       cCodGru := '0600'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'SEP'
		       cCodGru := '0700'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'OCT'
		       cCodGru := '0800'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'NOV'
		       cCodGru := '0900'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'DEC'
		       cCodGru := '1000'

		  CASE UPPER(SUBS(ALU->GRADO,1,3)) == 'UND'
		       cCodGru := '1100'

		  ENDCASE
	       ENDIF
	       REPL IMP->cCodigoGru WITH cCodGru

	       REPL IMP->cTipNitEst WITH ALU->cTipNitEst  // Revisar
	       REPL IMP->cDocNitEst WITH STR(ALU->cDocNitEst,16)
	       REPL IMP->cLugNitEst WITH ALU->cLugNitEst
//	       REPL IMP->cDepNitEst WITH ALU->cDepNitEst
	       REPL IMP->cApelliEst WITH ALU->cApelliEst
	       REPL IMP->cNombreEst WITH ALU->cNombreEst
	       REPL IMP->lSexFemEst WITH IF(ALLTRIM(ALU->cSexFemEst)=='MASCULINO',.F.,.T.)
	       REPL IMP->dFecNacEst WITH ALU->cFecNacEst  // Formato fecha
	       REPL IMP->cLugNacEst WITH ALU->cCiuNacEst
//	       REPL IMP->cDepNacEst WITH ALU->cDepNacEst


	       REPL IMP->cDireccEst WITH ALU->cDireccEst
	       REPL IMP->cCiudadEst WITH ALU->cCiudadEst
	       REPL IMP->cDepartEst WITH ALU->cDepartEst

	       nNroPos := AT('-',ALU->cTelefnEst)
	       IF nNroPos # 0
		  REPL IMP->cTelefnEst WITH ALLTRIM(SUBS(ALU->cTelefnEst,1,nNroPos-1))
		  REPL IMP->cTelCelEst WITH ALLTRIM(SUBS(ALU->cTelefnEst,nNroPos+1,LEN(ALU->cTelefnEst)))
	       ELSE
		  REPL IMP->cTelefnEst WITH ALLTRIM(ALU->cTelefnEst)
	       ENDIF


	       REPL IMP->cMaiEstEst WITH ALU->cMaiEstEst


	       REPL IMP->dFecMatEst WITH ALU->cFecMatEst // Formato fecha
	       REPL IMP->cHorMatEst WITH '08:00:00'

	       IF ALLTRIM(ALU->estado) == 'ACTIVO'
		  REPL IMP->lRetiroEst WITH .F.
		  REPL IMP->dFecRetEst WITH CTOD('00/00/00')
	       ELSE

		  cFecRet := ALLTRIM(ALU->cFecRetEst)
		  IF !EMPTY(cFecRet)
		     nPosUno := AT('/',cFecRet)
		     cNroDia := SUBS(cFecRet,1,nPosUno-1)
		     cFecRet := STUFF(cFecRet,nPosUno,1,'*')

		     nPosDos := AT('/',cFecRet)
		     nNroLen := nPosDos-nPosUno-1
		     cNroMes := SUBS(cFecRet,nPosUno+1,nNroLen)

		     cNroAno := SUBS(cFecRet,nPosDos+1,LEN(cFecRet))

		     dFecRet := CTOD(cNroMes+'/'+cNroDia+'/'+cNroAno)

		  ELSE
		     dFecRet := CTOD(cFecRet)
		  ENDIF


		  REPL IMP->lRetiroEst WITH .T.
		  REPL IMP->dFecRetEst WITH dFecRet
	       ENDIF

	       REPL IMP->nEstratEst WITH ALU->cEstratEst
	       REPL IMP->cNomEpsEst WITH ALU->cNomEpsEst
	       REPL IMP->cGrupRhEst WITH ALU->cGrupRhEst

	       cActAcuCnt(lShared,STR(ALU->cCodigoEst,6))

	       IMP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION')
	    ENDIF
	    IF lShared
	       IMP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  ALU->(DBSKIP())
	*ÀAvance del registro


       ENDDO
       oBrwMae(lShared,cAnoUsr,'IMP')
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS

****

FUNCTION cCodAno(cAnoUsr)

*>>>>DESCRIPCION DE PARAMETROS
/*     cAnoUsr                              // A¤o del Usuario */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL cCodAno := ''
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CODIGO DEL A¥O
      IF VAL(cAnoUsr) < 2000
	 cCodAno := cAnoSis
      ELSE
	 cCodAno := SUBS(cAnoUsr,1,1)+cAnoSis
      ENDIF
      RETURN cCodAno
*>>>>FIN CODIGO DEL A¥O


FUNCTION cActAcuCnt(lShared,cCodEst)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cCodEst                              // C¢digo del Estudiante */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cObserv := ''                  // Observacion

       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL cNroDia := ''                  // N£mero del d¡a
       LOCAL cNroMes := ''                  // N£mero del Mes
       LOCAL cNroAno := ''                  // N£mdro del A¤o

       LOCAL nPosUno := 0                   // N£mero de la posici¢n
       LOCAL nPosDos := 0                   // N£mero de la posici¢n
       LOCAL nNroLen := 0                   // Longitud
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LOCALIZACION DEL CODIGO
       IF !lLocCodigo('cCodigoEst','ACU',cCodEst)
	  cObserv := 'NO TIENE ACUDIENTES'
	  RETURN cObserv
       ENDIF
*>>>>FIN LOCALIZACION DEL CODIGO

*>>>>RECORRIDO DE LOS ACUDIENTES
       DO WHILE ACU->cCodigoEst == cCodEst

**********ACTUALIZACION DE LOS PADRES Y ACUDIENTES
	    DO CASE
	    CASE UPPER(ALLTRIM(ACU->PARENTESCO)) == 'PADRE'

		 REPL IMP->cApePadEst WITH ALLTRIM(ACU->cApeUnoPer)+' '+ALLTRIM(ACU->cApeDosPer)
		 REPL IMP->cNomPadEst WITH ALLTRIM(ACU->cNomUnoPer)+' '+ALLTRIM(ACU->cNomDosPer)
		 REPL IMP->lPadQepEst WITH .F.
		 REPL IMP->dNacPadEst WITH ACU->cFecNacPer
		 REPL IMP->cLugPadEst WITH ACU->cLugNacPer
		 REPL IMP->cPadNitEst WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		 REPL IMP->cPadLugEst WITH ALLTRIM(ACU->cLugNitPer)
		 REPL IMP->cPadTntEst WITH ALLTRIM(ACU->cTipNitPer)
		 REPL IMP->lPadFotEst WITH .F.
		 REPL IMP->cProPadEst WITH ALLTRIM(ACU->cProfesPer)
		 REPL IMP->cEmpPadEst WITH ALLTRIM(ACU->cEmpTraPer)
		 REPL IMP->cCarPadEst WITH ALLTRIM(ACU->cCarTraPer)
		 REPL IMP->cDirPadEst WITH ALLTRIM(ACU->cDirTraPer)
*	         REPL IMP->cBarPadEst WITH
		 REPL IMP->cCiuPadEst WITH ALLTRIM(ACU->cCiudadPer)
		 REPL IMP->cDepPadEst WITH ALLTRIM(ACU->cDepartPer)

		 nNroPos := AT('-',ACU->cTelefnPer)
		 IF nNroPos # 0
		    REPL IMP->cTelPadEst WITH ALLTRIM(SUBS(ACU->cTelefnPer,1,nNroPos-1))
		    REPL IMP->cCelPadEst WITH ALLTRIM(SUBS(ACU->cTelefnPer,nNroPos+1,LEN(ACU->cTelefnPer)))
		 ELSE
		    REPL IMP->cTelPadEst WITH ALLTRIM(ALU->cTelefnEst)
		 ENDIF

		 REPL IMP->cMaiPadEst WITH ALLTRIM(ACU->cMailPer)


	    CASE UPPER(ALLTRIM(ACU->PARENTESCO)) == 'MADRE'

		 REPL IMP->cApeMadEst WITH ALLTRIM(ACU->cApeUnoPer)+' '+ALLTRIM(ACU->cApeDosPer)
		 REPL IMP->cNomMadEst WITH ALLTRIM(ACU->cNomUnoPer)+' '+ALLTRIM(ACU->cNomDosPer)
		 REPL IMP->lMadQepEst WITH .F.
		 REPL IMP->dNacMadEst WITH ACU->cFecNacPer
		 REPL IMP->cLugMadEst WITH ACU->cLugNacPer
		 REPL IMP->cMadNitEst WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		 REPL IMP->cMadLugEst WITH ALLTRIM(ACU->cLugNitPer)
		 REPL IMP->cMadTntEst WITH ALLTRIM(ACU->cTipNitPer)
		 REPL IMP->lMadFotEst WITH .F.
		 REPL IMP->cProMadEst WITH ALLTRIM(ACU->cProfesPer)
		 REPL IMP->cEmpMadEst WITH ALLTRIM(ACU->cEmpTraPer)
		 REPL IMP->cCarMadEst WITH ALLTRIM(ACU->cCarTraPer)
		 REPL IMP->cDirMadEst WITH ALLTRIM(ACU->cDirTraPer)
*	         REPL IMP->cBarMadEst WITH
		 REPL IMP->cCiuMadEst WITH ALLTRIM(ACU->cCiudadPer)
		 REPL IMP->cDepMadEst WITH ALLTRIM(ACU->cDepartPer)

		 nNroPos := AT('-',ACU->cTelefnPer)
		 IF nNroPos # 0
		    REPL IMP->cTelMadEst WITH ALLTRIM(SUBS(ACU->cTelefnPer,1,nNroPos-1))
		    REPL IMP->cCelMadEst WITH ALLTRIM(SUBS(ACU->cTelefnPer,nNroPos+1,LEN(ACU->cTelefnPer)))
		 ELSE
		    REPL IMP->cTelMadEst WITH ALLTRIM(ALU->cTelefnEst)
		 ENDIF

		 REPL IMP->cMaiPadEst WITH ALLTRIM(ACU->cMailPer)

	    ENDCASE
**********FIN ACTUALIZACION DE LOS PADRES Y ACUDIENTES

**********ACTUALIZACION DE LOS CONTRATANTES
	    IF ALLTRIM(UPPER(ACU->CONTRATANT)) == 'SI'

	       DO CASE
	       CASE ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'PADRE' .OR.;
		    ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CONTRATANTE1'

		    REPL IMP->cNitCo1Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		    REPL IMP->cTipCo1Est WITH '1'
		    REPL IMP->lNoRCo1Est WITH .F.

		    IF ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CONTRATANTE1'
		       InsPEIACU(lShared)
		    ENDIF

	       CASE ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'MADRE' .OR.;
		    ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CONTRATANTE2'

		    REPL IMP->cNitCo2Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		    REPL IMP->cTipCo2Est WITH '1'
		    REPL IMP->lNoRCo2Est WITH .F.

		    IF ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CONTRATANTE2'
		       InsPEIACU(lShared)
		    ENDIF

	       OTHERWISE

		    IF EMPTY(IMP->cNitCo1Est)
		       REPL IMP->cNitCo1Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		       REPL IMP->cTipCo1Est WITH '1'
		       REPL IMP->lNoRCo1Est WITH .F.
		       REPL IMP->cTxtTemEst WITH 'C1:'+ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO)))
		    ELSE
		       REPL IMP->cNitCo2Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		       REPL IMP->cTipCo2Est WITH '1'
		       REPL IMP->lNoRCo2Est WITH .F.
		       REPL IMP->cTxtTemEst WITH 'C2:'+ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO)))
		    ENDIF

		    InsPEIACU(lShared)

	       ENDCASE

	    ENDIF
**********FIN ACTUALIZACION DE CONTRATANTES Y COODEUDORES

**********ACTUALIZACION DE LOS CODEUDORES
	    IF ALLTRIM(UPPER(ACU->COODEUDOR)) == 'SI'

	       DO CASE
	       CASE ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CODEUDOR1'
		    REPL IMP->cNitCo3Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		    REPL IMP->cTipCo3Est WITH '1'
		    REPL IMP->lNoRCo3Est WITH .F.

	       CASE ALLTRIM(UPPER(ALLTRIM(ACU->PARENTESCO))) == 'CODEUDOR2'
		    REPL IMP->cNitCo4Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		    REPL IMP->cTipCo4Est WITH '1'
		    REPL IMP->lNoRCo4Est WITH .F.

	       OTHERWISE
		    IF EMPTY(IMP->cNitCo3Est)
		       REPL IMP->cNitCo3Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		       REPL IMP->cTipCo3Est WITH '1'
		       REPL IMP->lNoRCo3Est WITH .F.
		    ELSE
		       REPL IMP->cNitCo4Est WITH ALLTRIM(STR(ACU->cDocNitPer,16))
		       REPL IMP->cTipCo4Est WITH '1'
		       REPL IMP->lNoRCo4Est WITH .F.
		    ENDIF
	       ENDCASE

	       InsPEIACU(lShared)

	    ENDIF
**********FIN ACTUALIZACION DE LOS CODEUDORES

	  ACU->(DBSKIP())

       ENDDO
       RETURN cObserv
*>>>>FIN RECORRIDO DE LOS ACUDIENTES


FUNCTION InsPEIACU(lShared)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL DOCUMENTO
       IF VAL(ALLTRIM(STR(ACU->cDocNitPer,16))) == 0
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL DOCUMENTO

*>>>>GRABACION DEL REGISTRO
       IF PEI->(lRegLock(lShared,.T.))

	  REPL PEI->cApeUnoPer WITH ACU->cApeUnoPer
	  REPL PEI->cApeDosPer WITH ACU->cApeDosPer
	  REPL PEI->cNomUnoPer WITH ACU->cNomUnoPer
	  REPL PEI->cNomDosPer WITH ACU->cNomDosPer

	  REPL PEI->cDocNitPer WITH ALLTRIM(STR(ACU->cDocNitPer,16))
	  REPL PEI->cTipNitPer WITH '1'
	  REPL PEI->cLugNitPer WITH ACU->cLugNitPer

	  REPL PEI->dFecNacPer WITH ACU->cFecNacPer
	  REPL PEI->cLugNacPer WITH ACU->cLugNacPer

	  IF UPPER(ALLTRIM(ACU->cSexFemPer)) == 'FEMENINO'
	     REPL PEI->lSexFemPer WITH .T.
	  ELSE
	     REPL PEI->lSexFemPer WITH .F.
	  ENDIF

	  REPL PEI->cTipoRhPer WITH ACU->cTipoRhPer
	  REPL PEI->cEstratPer WITH ACU->cEstratPer
	  REPL PEI->cDireccPer WITH ACU->cDireccPer
	  REPL PEI->cCiudadPer WITH ACU->cCiudadPer

	  nNroPos := AT('-',ACU->cTelefnPer)
	  IF nNroPos # 0
	     REPL PEI->cTelefnPer WITH ALLTRIM(SUBS(ACU->cTelefnPer,1,nNroPos-1))
	     REPL PEI->cTelCelPer WITH ALLTRIM(SUBS(ACU->cTelefnPer,nNroPos+1,LEN(ACU->cTelefnPer)))
	  ELSE
	     REPL PEI->cTelefnPer WITH ALLTRIM(ALU->cTelefnEst)
	  ENDIF


	  REPL PEI->cMaiUnoPer WITH ALLTRIM(ACU->cMailPer)
	  REPL PEI->cCarTraPer WITH ALLTRIM(ACU->cCarTraPer)
	  REPL PEI->cDirTraPer WITH ALLTRIM(ACU->cDirTraPer)
	  REPL PEI->cTelTraPer WITH ACU->cTelTraPer
	  REPL PEI->cProfesPer WITH ALLTRIM(ACU->cProfesPer)


	  PEI->(DBCOMMIT())

       ELSE
	  cError('NO SE GRABA EL REGISTRO')
       ENDIF
       IF lShared
	  PEI->(DBUNLOCK())
       ENDIF
       RETURN NIL
*>>>>FIN GRABACION DEL REGISTRO
