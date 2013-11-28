/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: MAEA¥O VS MAEIMPOR
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: VALIDAR MAEA;O EXTERNO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2012 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   ENE 25/2012 MIE

OBJETIVOS:

1- Valida los estudiantes del SIMA contra los estudiantes de un sistema
   externo


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_209(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

*>>>>REEMPLAZO DE CAMPOS
*       CamMaeSof()
*>>>>FIN REEMPLAZO DE CAMPOS


*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'SIMA'+ExtFile,'ALU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+'SOFT'+ExtFile,'IMP',NIL,lShared,nModCry})
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
	    cError('NO EXISTEN REGISTROS EN '+FileAlu+'SOFT'+ExtFile)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>VALIDACION DE REGISTROS
       ValidarAlu(lShared,cNomSis)
       ValidarImp(lShared,cNomSis)

       CloseAll()
       RETURN NIL
*>>>>FIN VALIDACION DE REGISTROS


/*************************************************************************
* TITULO..: VALIDAR MAEA¥O EXTERNO                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2012 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   ENE 25/2012 MIE

OBJETIVOS:

1- Valida los estudiantes del SIMA contra los estudiantes de un sistema
   externo


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CamMaeSof()

USE BASES\MAESOFT.DAT
REPL ALL cCodigoEst WITH ALLTRIM(XCODIGO)
BROWSE()
CLOSE DATA
RETURN NIL

/*************************************************************************
* TITULO..: COMPARACION DE REGISTROS ALU                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2012 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   ENE 25/2012 MIE

OBJETIVOS:

1- Compara los registros para validar las inconsistencias.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION ValidarAlu(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL lHayReg := .F.                 // .T. Existe el registro
       LOCAL cTxtTem := ''                  // Texto temporal

       LOCAL cNombre := ''                  // Nombre del Estudiante
       LOCAL grado   := ''                  // Grado del Estudiante
       LOCAL cCurso  := ''                  // Curso
       LOCAL xDocNit := ''                  // Documento del Estudiante
       LOCAL xApelli := ''                  // Apellido del Estudiante
       LOCAL xNombre := ''                  // Nombre del Estudiante
       LOCAL xCodigo := ''                  // C¢digo del Estudiante
       LOCAL nNroLen := 0                   // N£mero de Caracteres
       LOCAL cTipo   := ''                  // TIPO

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR ALUMNOS
       SELECT ALU
       ALU->(DBGOTOP())

       DO WHILE .NOT. ALU->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('ALU:'+STR(RECNO(),6)+'/'+STR(RECCOUNT(),6)+;
			'ºCODIGO:'+ALU->cCodigoEst+;
			'ºCURSO:'+ALU->cCodigoGru,cNomSis)
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','IMP',ALLTRIM(ALU->cCodigoEst))
	    SELECT ALU
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS DE DECISION
	    cTxtTem    := ''

	    cTipo   := 'S'
	    grado   := ''
	    xDocNit := ''
	    xApelli := ''
	    xNombre := ''
	    xCodigo := ''
	    

	    IF lHayReg

*==============CODIGO DEL ESTUDIANTE
		 IF ALU->cCodigoEst # IMP->cCodigoEst
		    cTxtTem += ' C:'+ALU->cCodigoEst+'-'+;
				     IMP->cCodigoEst
		 ENDIF
		 cNombre := RTRIM(ALU->cApelliEst)+' '+;
			    RTRIM(ALU->cNombreEst)
*==============FIN CODIGO DEL ESTUDIANTE

*==============CODIGO DEL GRUPO
		 cCodigoTgr := ALLTRIM(IMP->cCodigoGru)
		    nNroLen := LEN(ALLTRIM(IMP->cCodigoGru))
		 cCodigoTgr := SUBS(cCodigoTgr,nNroLen-3,4)

		 IF ALU->cCodigoGru # cCodigoTgr
		    cTxtTem += ' '+ALLTRIM(ALU->cCodigoGru)+' : '+cCodigoTgr
		    cTipo := 'GRUPO'
		 ENDIF
*==============FIN CODIGO DEL GRUPO

*==============CODIGO DEL GRADO
		 IF cValNomNiv(SUBS(ALU->cCodigoGru,1,2)) # ALLTRIM(IMP->cCodigoNiv)
		    cTxtTem += ' '+ALLTRIM(ALU->cCodigoGru)+' : '+;
			       ALLTRIM(IMP->cCodigoNiv)
		    cTipo := 'GRADO'

		 ENDIF
*==============FIN CODIGO DEL GRADO

*==============DOCUMENTO DE IDENTIDAD
		 IF ALLTRIM(ALU->cDocNitEst) # ALLTRIM(IMP->cDocNitEst)
		    cTxtTem += ' '+ALLTRIM(ALU->cDocNitEst)+' : '+;
			       ALLTRIM(IMP->cDocNitEst)
		    cTipo := 'DOCUMENTO'
		 ENDIF
*==============FIN DOCUMENTO DE IDENTIDAD

*==============APELLIDO DEL ESTUDIANTE
		 IF ALLTRIM(ALU->cApelliEst) # ALLTRIM(IMP->cApelliEst)
		    cTxtTem += ' '+ALLTRIM(ALU->cApelliEst)+' : '+;
			       ALLTRIM(IMP->cApelliEst)
		    cTipo := 'APELLIDOS'
		 ENDIF
*==============FIN APELLIDO DEL ESTUDIANTE

*==============NOMBRE DEL ESTUDIANTE
		 IF ALLTRIM(ALU->cNombreEst) # ALLTRIM(IMP->cNombreEst)
		    cTxtTem += ' '+ALLTRIM(ALU->cNombreEst)+' : '+;
			       ALLTRIM(IMP->cNombreEst)
		    cTipo := 'NOMBRES'
		 ENDIF
*==============FIN NOMBRE DEL ESTUDIANTE

	       IF EMPTY(cTxtTem)
		    cTipo := 'OK'
		  cTxtTem := 'OK'
	       ENDIF

	    ELSE
		 cTipo := 'NO EXISTE'
	       cTxtTem := 'NO EXISTE'
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL REGISTRO
	    SELECT ALU
	    IF ALU->(lRegLock(lShared,.F.))

	       IF cTxtTem == 'OK'
		  REPL ALU->observacio WITH cTxtTem
	       ELSE
		  REPL ALU->observacio WITH ALU->cCodigoEst+':'+;
					    ALLTRIM(ALU->cCodigoGru)+':'+;
					    cTxtTem
/*

		  REPL ALU->observacio WITH ALU->cCodigoEst+':'+;
					    ALLTRIM(ALU->cCodigoGru)+':'+;
					    cNombre+':'+cTxtTem
*/
	       ENDIF
	       REPL ALU->tipo       WITH cTipo

	       ALU->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       ALU->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  ALU->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR ALUMNOS


/*************************************************************************
* TITULO..: COMPARACION DE REGISTROS IMP                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2012 MIE A
       Colombia, Bucaramanga        INICIO: 12:00 AM   ENE 25/2012 MIE

OBJETIVOS:

1- Compara los registros para validar las inconsistencias.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/


FUNCTION ValidarImp(lShared,cNomSis)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL cNombre := ''                  // Nombre del Estudiante
       LOCAL lHayReg := .F.                 // .T. Existe el registro
       LOCAL cTxtTem := ''                  // Texto temporal
       LOCAL nNroLen := 0                   // N£mero de Caracteres
       LOCAL cTipo   := ''                  // TIPO

       LOCAL cCodigoTgr := ''               // Codigo del Grupo
       LOCAL cDocNitTes := ''               // Documento del Estudiante
       LOCAL cApelliTes := ''               // Apellido del Estudiante
       LOCAL cNombreTes := ''               // Nombre del Estudiante
       LOCAL cCodigoTes := ''               // C¢digo del Estudiante

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>RECORRIDO POR ALUMNOS
       SELECT IMP
       IMP->(DBGOTOP())

       DO WHILE .NOT. IMP->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('IMP:'+STR(RECNO(),6)+'/'+STR(RECCOUNT(),6)+;
			'ºCODIGO:'+IMP->cCodigoEst+;
			'ºCURSO:'+IMP->cCodigoGru,cNomSis)
**********FIN LINEA DE ESTADO


**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','ALU',ALLTRIM(IMP->cCodigoEst))
	    SELECT IMP
**********FIN LOCALIZACION DEL CODIGO

**********ANALISIS DE DECISION
	    cTxtTem := ''
	    cTipo   := 'E'

	    cCodigoTgr := ''
	    cDocNitTes := ''
	    cApelliTes := ''
	    cNombreTes := ''
	    cCodigoTes := ''

	    cCodigoTgr := ALLTRIM(IMP->cCodigoGru)
	       nNroLen := LEN(ALLTRIM(IMP->cCodigoGru))
	    cCodigoTgr := SUBS(cCodigoTgr,nNroLen-3,4)

	    IF lHayReg

*==============CODIGO DEL ESTUDIANTE
		 IF ALLTRIM(IMP->cCodigoEst) # ALU->cCodigoEst
		    cTxtTem += ' C:'+ALLTRIM(IMP->cCodigoEst)+'-'+;
				     ALLTRIM(ALU->cCodigoEst)
		    cCodigoTes := ALU->cCodigoEst
		 ENDIF
		 cNombre := RTRIM(IMP->cApelliEst)+' '+;
			    RTRIM(IMP->cNombreEst)
*==============FIN CODIGO DEL ESTUDIANTE

*==============CODIGO DEL GRUPO
		 IF ALU->cCodigoGru # cCodigoTgr
		    cTxtTem += ' '+ALLTRIM(ALU->cCodigoGru)+' : '+cCodigoTgr
		    cTipo   := 'GRUPO'
		 ENDIF
*==============FIN CODIGO DEL GRUPO

*==============CODIGO DEL GRADO
		 IF cValNomNiv(SUBS(ALU->cCodigoGru,1,2)) # ALLTRIM(IMP->cCodigoNiv)
		    cTxtTem += ' '+ALLTRIM(ALU->cCodigoGru)+' : '+;
			       ALLTRIM(IMP->cCodigoNiv)
		    cTipo   := 'GRADO'
		 ENDIF
*==============FIN CODIGO DEL GRADO

*==============DOCUMENTO DE IDENTIFICACION
		 IF ALLTRIM(IMP->cDocNitEst) # ALLTRIM(ALU->cDocNitEst)
		    cTxtTem += ' '+ALLTRIM(IMP->cDocNitEst)+' : '+;
			       ALLTRIM(ALU->cDocNitEst)
		    cTipo   := 'DOCUMENTO'

		    cDocNitTes := ALU->cDocNitEst
		 ENDIF
*==============FIN DOCUMENTO DE IDENTIFICACION

*==============APELLIDO DEL ESTUDIANTE
		 IF ALLTRIM(IMP->cApelliEst) # ALLTRIM(ALU->cApelliEst)
		    cTxtTem += ' '+ALLTRIM(IMP->cApelliEst)+' : '+;
			       ALLTRIM(ALU->cApelliEst)
		    cTipo   := 'APELLIDOS'

		    cApelliTes := ALU->cApelliEst
		 ENDIF
*==============FIN APELLIDO DEL ESTUDIANTE

*==============NOMBRE DEL ESTUDIANTE
		 IF ALLTRIM(IMP->cNombreEst) # ALLTRIM(ALU->cNombreEst)
		    cTxtTem += ' '+ALLTRIM(IMP->cNombreEst)+' : '+;
			       ALLTRIM(ALU->cNombreEst)
		    cTipo   := 'NOMBRES'
		    cNombreTes := ALU->cNombreEst
		 ENDIF
*==============FIN APELLIDO DEL ESTUDIANTE


	       IF EMPTY(cTxtTem)
		    cTipo := 'OK'
		  cTxtTem := 'OK'
	       ENDIF

	    ELSE
	       cTxtTem := IMP->cCodigoEst+' '+cCodigoTgr+' '

	       cTxtTem += ALLTRIM(IMP->cApelliEst)+' '+;
			  ALLTRIM(IMP->cNombreEst)
	       cTipo   := 'NO EXISTE'
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL REGISTRO
	    SELECT IMP
	    IF IMP->(lRegLock(lShared,.F.))

	       IF cTxtTem == 'OK'
		  REPL IMP->observacio WITH cTxtTem
	       ELSE
		  REPL IMP->observacio WITH IMP->cCodigoEst+':'+;
					    ALLTRIM(IMP->cCodigoGru)+':'+;
					    cTxtTem
/*
		  REPL IMP->observacio WITH IMP->cCodigoEst+':'+;
					    ALLTRIM(IMP->cCodigoGru)+':'+;
					    cNombre+':'+cTxtTem
*/

	       ENDIF
	       REPL IMP->tipo       WITH cTipo

	       IF cTipo == 'NO EXISTE'
		  REPL IMP->observacio WITH cTxtTem
	       ENDIF

	       IMP->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       IMP->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO

	  IMP->(DBSKIP())

       ENDDO
       RETURN NIL
*>>>>FIN RECORRIDO POR ALUMNOS

/*************************************************************************
* TITULO..: NOMBRE DEL NIVEL                                             *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 30/2012 LUN A
       Colombia, Bucaramanga        INICIO: 01:30 PM   ENE 30/2012 LUN

OBJETIVOS:

1)- Determina el nombre del nivel

2)- Retorna el nombre del nivel

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cValNomNiv(cCodNiv)

*>>>>PARAMETROS DE LA FUNCION
/*     cCodNiv                              // C¢digo del nivel */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL       i := 0                   // Contador
       LOCAL cNomNiv := ''                  // Nombre del nivel

       LOCAL aNivel  := {'PRIMERO','SEGUNDO','TERCERO','CUARTO','QUINTO',;
			 'SEXTO','SEPTIMO','OCTAVO','NOVENO' ,'DECIMO',;
			 'UNDECIMO','MATERNALES','CAMINADORES','PARVULOS',;
			 'PREJARDIN','JARDIN','TRANSICION'}

       i := IF(VALTYPE(cCodNiv)=='C',VAL(cCodNiv),cCodNiv)
       cNomNiv := IF(i==0,aNivel[17],aNivel[i])
       RETURN cNomNiv
*>>>>FIN DECLARACION DE VARIABLES