/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ARCHIVOS
SUBMENU...: CONSULTAR NOTAS
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 501

**************************************************************************
* TITULO..: RENOMBRAR LAS FOTOS                                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/2011 MIE A
       Colombia, Bucaramanga        INICIO: 08:00 AM   MAY 18/2011 MIE

OBJETIVOS:

1- Permite renombrar los nombres de los archivos de las fotos de los
   estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_502(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL PathTem := ''                  // Path Temporal
       LOCAL lHayArc := .F.                 // .T. Hay Archivo
       LOCAL cObserv := ''                  // Observaci¢n

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES


*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\'+;
		     'fotos'+ExtFile,'FOT',NIL,lShared,nModCry})
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
       CASE FOT->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN FOTOS'+ExtFile)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LECTURA DEL PATH
       SETCURSOR(1)                         // Activaci¢n del cursor
       PathTem := SPACE(30)
       @ nFilInf+1,1 SAY 'DIRECTORIO DE LAS FOTOS' GET PathTem PICT '@X'
       READ
       IF EMPTY(PathTem)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       PathTem := ALLTRIM(PathTem)
*>>>>FIN LECTURA DEL CODIGO DE LA MATERIA

*>>>>RECORRIDO DEL ARCHIVO
       FOT->(DBGOTOP())

       DO WHILE .NOT. FOT->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTRO:'+STR(FOT->(RECNO()),6)+'/'+;
				    STR(FOT->(RECCOUNT()),6),cNomSis)
**********FIN LINEA DE ESTADO


**********VALIDACION DEL ARCHIVO
	    FileTem := PathTem+'\'+ALLTRIM(FOT->cCodigoFot)+'.jpg'
	    lHayArc := FILE(FileTem)
**********FIN VALIDACION DEL ARCHIVO

**********RENOMBRE DEL ARCHIVO
	    cObserv := ''
	    IF lHayArc

	       IF RENAMEFILE(FileTem,;
			     PathTem+'\'+ALLTRIM(FOT->cCodigoEst)+'.jpg') # 0
		  cObserv := 'NO SE RENOMBRO EL ARCHIVO:'+;
			      ALLTRIM(FOT->cCodigoFot)

	       ELSE
		  cObserv := 'SE RENOMBRO EL ARCHIVO:'+;
			      ALLTRIM(FOT->cCodigoFot)
	       ENDIF

	    ENDIF
**********FIN RENOMBRE DEL ARCHIVO

**********ANALISIS DE DECISION
	    IF !lHayArc
	       FileTem := PathTem+'\'+ALLTRIM(FOT->cCodigoEst)+'.jpg'
	       IF FILE(FileTem)
		  cObserv := 'EL ARCHIVO YA ESTA RENOMBRADO'
	       ELSE
		  cObserv := 'REVISAR'
	       ENDIF
	    ENDIF
**********FIN ANALISIS DE DECISION

**********GRABACION DEL REGISTRO
	    SELECT FOT
	    IF FOT->(lRegLock(lShared,.F.))

	       REPL FOT->cObservFot WITH cObserv

	       FOT->(DBCOMMIT())


	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF
	    IF lShared
	       FOT->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  FOT->(DBSKIP())

       ENDDO
       SELECT FOT
       BROWSE()
       CloseAll()
       RETURN NIL
*>>>>RECORRIDO DEL ARCHIVO

