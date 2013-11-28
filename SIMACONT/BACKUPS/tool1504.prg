/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ARCHIVOS
SUBMENU...: FOTOS POR GRUPOS
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 501

**************************************************************************
* TITULO..: COPIAR FOTOS POR GRUPOS                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 18/2011 MIE A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 18/2011 MIE

OBJETIVOS:

1- Permite copiar los archivos de las fotos por grupos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_504(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL PathAct := ''                  // Path Actual
       LOCAL PathTem := ''                  // Path Temporal
       LOCAL FileUno := ''                  // File uno
       LOCAL FileDos := ''                  // File dos

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileAlu+cAnoUsr+ExtFile,'ALU',NIL,lShared,nModCry})

       AADD(aUseDbf,{.T.,PathSis+'\'+;
			 FileGru+'POS'+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
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
	    cError('NO EXISTEN REGISTROS EN ALUMNOS')

       CASE GRU->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS EN GRUPOS')

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

*>>>>RECORRIDO POR GRUPOS
       PathAct := cPathAct()
       GRU->(DBGOTOP())
       DO WHILE .NOT. GRU->(EOF())

	  Mdir(PathTem+'\GRUPOS\'+GRU->cCodigoGru,PathAct)
	  GRU->(DBSKIP())

       ENDDO
*>>>>FIN RECORRIDO POR GRUPOS

*>>>>RECORRIDO DEL ARCHIVO
       ALU->(DBGOTOP())
       DO WHILE .NOT. ALU->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTRO:'+STR(ALU->(RECNO()),6)+'/'+;
				    STR(ALU->(RECCOUNT()),6),cNomSis)
**********FIN LINEA DE ESTADO

**********COPIA DE ARCHIVOS
	    FileUno := PathTem+'\'+ALLTRIM(ALU->cCodigoEst)+'.jpg'

	    FileDos := PathTem+'\GRUPOS\'+ALU->cCodigoGru+'\'+;
		       ALLTRIM(ALU->cCodigoEst)+'.jpg'

	    FILEMOVE(FileUno,FileDos)
**********FIN COPIA DE ARCHIVOS

	  ALU->(DBSKIP())

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>RECORRIDO DEL ARCHIVO

