/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...:
SISTEMA...: CONTABILIDAD ACADEMICA

**************************************************************************
* TITULO..: GENERAR FORMATO APT                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: JUN 30/2011 JUE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   JUN 30/2011 JUE

OBJETIVOS:

1- Permite generar un archivo plano en formato APT

2- Los campos del archivo deben venir todos de tipo caracter.


*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_506(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL aDbfStr := {}                  // Estructura del Archivo

       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL       k := 0                   // Contador

       LOCAL nNroArc := 0                   // N£mero del Archivo
       LOCAL cRegTxt := ''                  // Texto del registro
       LOCAL nByeWri := 0                   // Bytes Escritos
       LOCAL lGraReg := .F.                 // Grabar el Registro

       LOCAL cLinea  := ''                  // L¡nea separadora

       LOCAL cCampo  := ''                  // Campo

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)
*>>>>FIN LECTURA DE PATHS

*>>>>AREAS DE TRABAJO
       lShared := .T.
       AADD(aUseDbf,{.T.,PathSis+'\'+FileApt,'APT',NIL,.F.,nModCry})
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
       CASE APT->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS GRABADOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ESTRUCTURA DEL ARCHIVO
       aDbfStr := APT->(DBSTRUCT())
       BROWSE()
*>>>>FIN ESTRUCTURA DEL ARCHIVO

*>>>>CREACION DEL ARCHIVO
       FileTem := PathPrn+'\file.apt'
       nNroArc := FCREATE(FileTem,0)
       IF nNroArc == -1
	  cError('NO SE PUEDE CREAR EL ARCHIVO '+FileTem)
	  RETURN NIL
       ENDIF
*>>>>FIN CREACION DEL ARCHIVO

*>>>>GRABACION DE LA CABECERA
       cLinea := '*'
       FOR k := 1 TO LEN(aDbfStr)
	   cLinea += REPL('-',3)+'+'
       ENDFOR

       cRegTxt := cLinea+CHR(13)+CHR(10)
       nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
       IF nByeWri # LEN(cRegTxt)
	  cError('GRABACION DE LA CABECERA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
     *ÀL¡nea separadora

       cRegTxt := ''
       FOR k := 1 TO LEN(aDbfStr)
	   cRegTxt += '||'+UPPER(aDbfStr[k,1])
       ENDFOR
       cRegTxt += '||'

       cRegTxt := cRegTxt+CHR(13)+CHR(10)
       nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
       IF nByeWri # LEN(cRegTxt)
	  cError('GRABACION DE LA CABECERA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       cRegTxt := cLinea+CHR(13)+CHR(10)
       nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
       IF nByeWri # LEN(cRegTxt)
	  cError('GRABACION DE LA CABECERA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
     *ÀL¡nea separadora
*>>>>FIN GRABACION DE LA CABECERA

*>>>>RECORRIDO DEL ARCHIVO
       APT->(DBGOTOP())
       DO WHILE .NOT. APT->(EOF())

**********LINEA DE ESTADO
	    LineaEstado(cMaeAct+':'+STR(APT->(RECNO()),4)+'/'+;
				    STR(APT->(RECCOUNT()),4),cNomSis)
**********FIN LINEA DE ESTADO

**********GRABACION DE LA CABECERA
	    cRegTxt := ''
	    FOR k := 1 TO LEN(aDbfStr)

		cCampo := 'APT->'+UPPER(aDbfStr[k,1])

		DO CASE
		CASE VALTYPE(&cCampo) == 'C' // Tipo Caracter
		     cCampo := ALLTRIM(&cCampo)

		CASE VALTYPE(&cCampo) == 'N' // Tipo N£merico
		     cCampo := &cCampo
		     cCampo := STR(cCampo,aDbfStr[k,3],aDbfStr[k,4])
		     cCampo := ALLTRIM(cCampo)

		CASE VALTYPE(&cCampo) == 'D' // Tipo Fecha
		     cCampo := IF(EMPTY(&cCampo),' ',cFecha(&cCampo,3))

		CASE VALTYPE(&cCampo) == 'L' // Tipo L¢gico
		     cCampo := IF(&cCampo,'SI','NO')

		OTHERWISE
		     cCampo := &cCampo

		ENDCASE
		cRegTxt += '|'+cCampo


	    ENDFOR
	    cRegTxt += '|'

	    cRegTxt := cRegTxt+CHR(13)+CHR(10)
	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
	       cError('GRABACION DEL REGISTRO')
	       EXIT
	    ENDIF

	    cRegTxt := cLinea+CHR(13)+CHR(10)
	    nByeWri := FWRITE(nNroArc,cRegTxt,LEN(cRegTxt))
	    IF nByeWri # LEN(cRegTxt)
	       cError('GRABACION DE LA CABECERA')
	       CloseAll(aUseDbf)
	       RETURN NIL
	    ENDIF
	  *ÀL¡nea separadora
**********FIN GRABACION DE LA CABECERA


	  APT->(DBSKIP())

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DEL ARCHIVO




