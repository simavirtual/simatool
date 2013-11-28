/*                      SIMA - SISTEMA UTILITARIO
		 FUNCIONES ARCHIVO DE CONFIGURACION GENERAL

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:30 PM   AGO 14/2002 MIE

OBJETIVOS:

1- Creaci¢n de la estructura

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSimTol(lShared,nModCry,PathArc,fArchvo,fNtxArc,aStrDbf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo
       fNtxArc				    // Archivo de Indices
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"PathMatr","Character",70,0})    // Path de la Matricula
       AADD(aDbfStr,{"PathCont","Character",70,0})    // Path de la Contabilidad
       AADD(aDbfStr,{"PathProf","Character",70,0})    // Path de la Contabilidad Profesores
       AADD(aDbfStr,{"PathCart","Character",70,0})    // Path de la Cartera
       AADD(aDbfStr,{"PathVoto","Character",70,0})    // Path de la Votaci¢n
       AADD(aDbfStr,{"PathCafe","Character",70,0})    // Path de la Cafeteria
     *ÀPaths de los sistemas del Sima

       AADD(aDbfStr,{"cNomSupTol","Character",10,0})    // Supervisor del Sistema
       AADD(aDbfStr,{"cPwdSupTol","Character",10,0})    // Clave del Supervisor del Sistema
     *ÀSupervisor del Sistema

       AADD(aDbfStr,{"lPrnArcTol","Logical"  ,01,0})   // .T. Imprimir en la impresora
       AADD(aDbfStr,{"nCodigoClr","Numeric"  ,02,0})   // C¢digo del Color
       AADD(aDbfStr,{"nCodigoPrn","Numeric"  ,04,0})   // C¢digo de la Impresora
       AADD(aDbfStr,{"cOpcPrnTol","Character",04,0})   // Opciones de Impresi¢n
       AADD(aDbfStr,{"lPruebaTol","Logical"  ,01,0})   // .T. Activar Pruebas
     *ÀConfiguracines Generales del Sistema
*>>>>DECLARACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
	  aStrDbf := aDbfStr
	  RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE(PathArc) == 0
	    DBCREATE(fArchvo,aDbfStr,"DBFNTX")

       CASE DIRCHANGE(PathArc) == -3
	    cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE DIRCHANGE(PathArc) == -5
	    cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       DIRCHANGE(PathAct)
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TOL',NIL,lShared,nModCry)
	  WAIT 'ABRIENDO EL ARCHIVO DE CONFIGURACION DEL SISTEMA'
	  CloseDbf('TOL',PathArc+'\'+fArchvo,nModCry)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>GRABACION DE LOS PARAMETROS POR DEFECTO
       IF TOL->(lRegLock(lShared,.T.))
	  REPL TOL->lPrnArcTol WITH .F.
	  REPL TOL->nCodigoClr WITH 1
	  REPL TOL->PathMatr   WITH '\SIMA\SIMAMATR'
	  REPL TOL->PathCont   WITH '\SIMA\SIMACONT'
	  REPL TOL->PathProf   WITH '\SIMA\SIMAPROF'
	  REPL TOL->PathCart   WITH '\SIMA\SIMACART'
	  REPL TOL->PathVoto   WITH '\SIMA\SIMAVOTO'
	  REPL TOL->PathCafe   WITH '\SIMA\SIMACAFE'
	  REPL TOL->cNomSupTol WITH CRYPT('CONTROL   ',"IVANAN")
	  REPL TOL->cPwdSupTol WITH CRYPT('CONTROL   ',"IVANAN")
	  TOL->(DBCOMMIT())
       ELSE
	  WAIT 'NO SE GRABA EL REGISTRO INICIAL DE LA CONFIGURACION'
       ENDIF
       IF lShared
	  TOL->(DBUNLOCK())
       ENDIF
       CloseDbf('TOL',PathArc+'\'+fArchvo,nModCry)
       RETURN NIL
*>>>>FIN GRABACION DE LOS PARAMETROS POR DEFECTO

/*************************************************************************
* TITULO..: RECUPERACION DE LA ESTRUCTURA                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:35 PM   AGO 14/2002 MIE

OBJETIVOS:

1)- Recupera la estructura del archivo

2)- Retorna NIL

SINTAXIS:


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RecuSimTol(lShared,nModCry,PathArc,fArchvo,fNtxArc)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                        // .T. Sistema Compartido
       nModCry                        // Modo de Protecci¢n
       PathArc			      // Path del Archivo
       fArchvo			      // Nombre del Archivo
       fNtxArc			      // Archivo de Indice */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>RECUPERA LA ESTRUCTURA DEL ARCHIVO
       SAVE SCREEN
       cError("SE BORRO EL ARCHIVO "+PathArc+'\'+fArchvo,;
	      "Error Grave. TOME NOTA",;
	      "Al Presionar Cualquier tecla se crea el archivo")
       Termometro(0,"CREANDO LA ESTRUCTURA")
       Termometro(100)
       CreaSimTol(lShared,nModCry,PathArc,fArchvo,fNtxArc)
       RESTORE SCREEN
       RETURN NIL
*>>>>FIN RECUPERA LA ESTRUCTURA DEL ARCHIVO

/*************************************************************************
* TITULO..: ACTUALIZACION DE LA ESTRUCTURA                               *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:35 PM   AGO 14/2002 MIE

OBJETIVOS:

1- Actualiza la Estructura del Archivo

2- Retorna el N£mero de Error:
   0 => No hay Error
	Estructura Actualizada
	Estructura Sin problemas
   1 => Estructura No Actualizada

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION nActStrTol(lShared,nModCry,PathArc,fArchvo)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc				    // Path del Archivo
       fArchvo				    // Nombre del Archivo */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL nNroErr := 0                   // N£mero del Error
       LOCAL       i := 0                   // Contador
       LOCAL aStrNew := {'1'}               // Estructura Nueva
       LOCAL aStrOld := {}                  // Estructura Vieja
       LOCAL lCambio := .F.                 // .T. Cambio la Estructura
       LOCAL FileTem := ''                  // Archivo temporal
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbf(.T.,PathArc+'\'+fArchvo,'TOL',NIL,lShared,nModCry)
	  cError('ABRIENDO EL ARCHIVO DE CORRECIONES')
	  CloseDbf('TOL')
	  RETURN nNroErr := 1
       ENDIF
       aStrOld := TOL->(DBSTRUCT())
       CloseDbf('TOL')
       CreaSimTol(lShared,nModCry,PathArc,fArchvo,,@aStrNew)
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE LA ESTRUCTURA
       lCambio := .T.
       IF LEN(aStrNew) == LEN(aStrOld)
	  lCambio := .F.
	  nNroErr := 1
       ENDIF

       IF !lCambio
	  FOR i := 1 TO LEN(aStrNew)
	      IF UPPER(aStrNew[i,1]) # UPPER(aStrOld[i,1]) .OR.;
		 UPPER(SUBS(aStrNew[i,2],1,1)) # UPPER(SUBS(aStrOld[i,2],1,1)) .OR.;
		 aStrNew[i,3] # aStrOld[i,3] .OR.;
		 aStrNew[i,4] # aStrOld[i,4]
		 lCambio := .T.
		 EXIT
	      ENDIF
	  ENDFOR
       ENDIF
*>>>>FIN VALIDACION DE LAS STRUCTURAS

*>>>>CONFIRMACION DE LA ACTUALIZACION
       IF lCambio .AND. lShared
	  cError('El Archivo SIMATOOL su Estructura Esta DesActualizada.',;
		 'ATENCION',;
		 'Para Actualizarla NO Debe Haber Ning£n Usuario en la Red.')
	  lCambio := lPregunta('DESEA ACTUALIZAR LA ESTRUCTURA? No Si')
	  IF !lCambio
	     nNroErr := 1
	  ENDIF
       ENDIF
*>>>>FIN CONFIRMACION DE LA ACTUALIZACION

*>>>>ACTUALIZACION DE LA STRUCTURA
       IF lCambio
	  FileTem := SUBS(fArchvo,1,AT('.',fArchvo))+'STR'
	  cSavPan := SAVESCREEN(0,0,24,79)
	  IF !lStrucFile(lShared,;
			 PathArc+'\'+fArchvo,;
			 PathArc+'\'+FileTem,;
			 {||CreaSimTol(lShared,nModCry,PathArc,FileTem)})
	     cError('NO SE ACTUALIZO LA ESTRUCTURA DEL ARCHIVO')
	     nNroErr := 1
	  ENDIF
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDIF
       RETURN nNroErr
*>>>>FIN ACTUALIZACION DE LA STRUCTURA

/*************************************************************************
* TITULO..: MANTENIMIENTO DEL ARCHIVO                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 05:40 PM   AGO 14/2002 MIE

OBJETIVOS:

1- Permite el mantenimiento del archivo

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MantenTol(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>PARAMETROS DE LA FUNCION
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
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                   // Declaraci¢n de teclas
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr    := .F.              // .T. Hay Error

       LOCAL cTitSup := ''                  // T¡tulo Superior del Browse
       LOCAL aCampos := {}                  // Definici¢n de Campos
       LOCAL cTitInf := ''                  // T¡tulo Inferior del Browse
       LOCAL oBrowse := NIL                 // Browse de Alumnos

       CloseAll()
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimTol,'TOL',NIL,lSiRed,nModCry})
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
       CASE TOL->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>DEFINICION TITULOS DEL BROWSE
       SELECT TOL
       cTitSup := '<< CONFIGURACION DEL SISTEMA DE SIMATOOL >>'
     *ÀT¡tulo Superior

       cTitInf := '<ESC>Abandona'
      *ÀT¡tulo Inferior
*>>>>FIN DEFINICION TITULOS DEL BROWSE

*>>>>DEFINICION DE CAMPOS DEL BROWSE
       aCampos := {}
       AADD(aCampos,{{"PATH SIMAMATR","PathMatr"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathMatr'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACONT","PathCont"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathCont'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMAPROF","PathProf"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathProf'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACART","PathCart"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathCart'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMAVOTO","PathVoto"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathVoto'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"PATH SIMACAFE","PathCafe"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','PathCafe'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"SUPERVISOR;SISTEMA","cNomSupTol"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','cNomSupTol'},{'PICTURE','@!'}}})

       AADD(aCampos,{{"CLAVE;SUPERVISOR","cPwdSupTol"},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','cPwdSupTol'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'IMPRIMIR;EN ARCHIVO','lPrnArcTol'},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','lPrnArcTol'},{'PICTURE','@!'}}})

       AADD(aCampos,{{'CONFIGURACION;DEL COLOR','nCodigoClr'},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','nCodigoClr'},{'PICTURE','99'}}})

       AADD(aCampos,{{'CODIGO;IMPRESORA','nCodigoPrn'},;
		     {{'MODI',.T.},{'ALIAS','TOL'},;
		      {'FIELD','nCodigoPrn'},{'PICTURE','9999'}}})
*>>>>FIN DEFINICION DE CAMPOS DEL BROWSE

*>>>>BROWSE DEL ARCHIVO
       IF !lFileLock()
	  oBrowse := oBrowse(nFilPal+1,00,22,79,cTitSup,cTitInf,aCampos)
	 *Creaci¢n del Browse

	  TOL->(CtrlBrw(lShared,oBrowse))
	 *Browse del Archivo
       ENDIF
       TOL->(DBUNLOCKALL())
*>>>>FIN BROWSE DEL ARCHIVO

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF TOL->lPrnArcTol
	  SET PRINTER TO SIMATOOL              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: COLOR DEL SISTEMA                                            *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 06:00 PM   AGO 14/2002 MIE

OBJETIVOS:

1- Debe estar en uso el archivo.

2- Permite escoger las definiciones del Color del Sistema

3- Retorna un vector la Configuracion del Color

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION xClrSysTol(lShared,nModCry)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL xClrSys := ''                  // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimTol,'TOL',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileClr,'CLR',NIL,lShared,nModCry})
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
       CASE TOL->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION DEL SISTEMA')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>SELECCION DEL COLOR
       xClrSys := xColorSys(TOL->nCodigoClr)
       CloseAll(aUseDbf)
       RETURN xClrSys
*>>>>FIN SELECCION DEL COLOR

/*************************************************************************
* TITULO..: LECTURAS PATHS DE INTEGRACION                                *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:30 PM   MAY 29/2002 MAR

OBJETIVOS:

1- Lee del archivo los paths de integraci¢n

2- Retorna por referencia los param‚tros de la funci¢n marcados con @

3- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PathTool(lShared,nModCry,PathMtr,PathCon,PathPro,PathCar,PathCaf)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       PathMtr			            // @Path de la Matr¡cula
       PathCon			            // @Path de la Contabilidad
       PathPro			            // @Path de la Contabilidad Profesores
       PathCar			            // @Path de la Cartera
       PathCaf                              // @Path de la Cafeteria */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL cNalias := 'XYZ'
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 fSimTol,cNalias,NIL,lSiRed,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DE LOS PATHS DE INTEGRACION
       SELECT &cNalias
       DBGOTOP()
       PathMtr := ALLTRIM(&cNalias->PathMatr)
       PathCon := ALLTRIM(&cNalias->PathCont)
       PathPro := ALLTRIM(&cNalias->PathProf)
       PathCar := ALLTRIM(&cNalias->PathCart)
       PathCaf := ALLTRIM(&cNalias->PathCafe)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN LECTURA DE LOS PATHS DE INTEGRACION