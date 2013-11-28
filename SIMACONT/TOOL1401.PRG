/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: INFORMES
SUBMENU...: CODIGOS INDICADORES
SISTEMA...: CONTABILIDAD ACADEMICA                  MODULO No. 401

**************************************************************************
* TITULO..: IMPRESION DE CODIGOS DE INDICADORES                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MIE A
       Colombia, Bucaramanga        INICIO: 11:00 PM   MAY 29/2002 MIE

OBJETIVOS:

1- Imprime los c¢digos de los indicadores de cada una de las materias.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool1_401(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "inkey.ch"
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL nNroPer := 0                   // N£mero del Periodo
       LOCAL Getlist := {}                  // Variable del sistema

       LOCAL cCodigoTgr := ''               // C¢digo del Grupo
       LOCAL cCodigoTma := ''               // C¢digo de la Materia
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
       cMaeAct := cNivelEst(nFilInf+1,nColInf,cMaeAlu)
       AADD(aUseDbf,{.T.,PathCon+'\'+cMaeAct+'\'+;
			 FileGru+cMaeAct+cAnoSis+ExtFile,'GRU',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>LECTURA DEL GRUPO
       cCodigoTgr := cSpaces('GRU','cCodigoGru')
       IF !lLeeCodGru(nFilInf+1,nColInf-1,@cCodigoTgr,cMaeAct)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
       CloseAll(aUseDbf)
*>>>>FIN LECTURA DEL GRUPO

*>>>>LECTURA DEL NUMERO DEL PERIODO
       @ nFilInf+2,nColInf+1 SAY 'PERIODO' GET nNroPer PICT '9';
			     VALID nNroPer <= 5
       READ
       IF nNroPer == 0
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL NUMERO DEL PERIODO

*>>>>LECTURA DEL CODIGO DE LA MATERIA
       cCodigoTma := SPACE(04)
       @ nFilInf+3,nColInf+1 SAY 'MATERIA' GET cCodigoTma PICT '9999'
       READ
       IF EMPTY(cCodigoTma)
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN LECTURA DEL CODIGO DE LA MATERIA

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathCon+'\'+cMaeAct+'\NOTAS\'+;
			 'NT'+cCodigoTgr+cAnoSis+ExtFile,'NOT',NIL,lShared,nModCry})
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
       CASE NOT->(RECCOUNT()) == 0
	    cError('NO EXISTEN NOTAS PARA EL GRUPO '+cCodigoTgr)

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>IMPRESION DE LOS CODIGOS DE INDICADORES
       PrnCodNot(lShared,cNomSis,cNomEmp,cAnoUsr,;
		 NOT->(DBSTRUCT()),;
		 cCodigoTgr,cCodigoTma,nNroPer)
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN IMPRESION DE LOS CODIGOS DE INDICADORES

/*************************************************************************
* TITULO..: IMPRESION DE LOS CODIGOS DE INDICADORES                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 29/2002 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 AM   MAY 29/2002 MIE

OBJETIVOS:

1- Actualiza los c¢digos aplicados para permitir el control de las
   recuperaciones.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION PrnCodNot(lShared,cNomSis,cNomEmp,cAnoUsr,;
		   aStrDbf,cCodGru,cCodMat,nNroPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Archivos Compartidos
       cNomSis                              // Nombre del Sistema
       cNomEmp                              // Nombre de la Empresa
       cAnoUsr                              // A¤o del Usuario
       aStrDbf                              // Estructura del Archivo
       cCodGru                              // C¢digo del Grupo
       cCodMat                              // C¢digo de la Materia
       nNroPer                              // N£mero del Periodo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "EPSONFX.PRG"               // Impresora EPSON FX

       LOCAL cSavPan := ''                  // Salvar Pantalla
     *ÀVariables generales

       LOCAL nNroPag := 1                   // N£mero de p gina
       LOCAL lTamAnc := .F.                 // .T. Tama¤o Ancho
       LOCAL nLinTot := 0                   // L¡neas totales de control
       LOCAL nTotReg := 0                   // Total de registros
       LOCAL aCabeza := {}                  // Encabezado del informe
       LOCAL cCodIni := ''                  // C¢digos de impresi¢n iniciales
       LOCAL cCodFin := ''                  // C¢digos de impresi¢n finales
       LOCAL aNroCol := {}                  // Columnas de impresi¢n
       LOCAL aTitulo := {}                  // T¡tulos para impresi¢n
       LOCAL cCabCol := ''                  // Encabezado de Columna
       LOCAL aCabSec := {}                  // Encabezado Secundario
       LOCAL nLenPrn := 0                   // Longitud l¡nea de impresi¢n
       LOCAL lCentra := .F.                 // .T. Centrar el informe
       LOCAL nColCab := 0                   // Columna del encabezado
       LOCAL bPagina := NIL                 // Block de P gina
       LOCAL bCabeza := NIL                 // Block de Encabezado
       LOCAL bDerAut := NIL                 // Block Derechos de Autor
       LOCAL nLinReg := 1                   // L¡neas del registro
       LOCAL cTxtPrn := ''                  // Texto de impresi¢n
       LOCAL Getlist := {}                  // Variable del sistema
     *ÀVariables de informe

       LOCAL       i := 0                   // Contador
       LOCAL  cCampo := ''                  // Campo del Archivo
       LOCAL nAvance := 0                   // Avance de registros

     *ÀVariables espec¡ficas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL CONTENIDO
       IF NOT->(RECCOUNT()) == 0
	  cError('NO EXISTEN REGISTROS GRABADOS')
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DEL CONTENIDO

*>>>>LOCALIZACION DE LA MATERIA
       cCampo := ''
       FOR i := 1 TO LEN(aStrDbf)
	   IF UPPER(SUBS(aStrDbf[i,1],1,7)) == 'CJ'+STR(nNroPer,1)+cCodMat
	      cCampo := aStrDbf[i,1]
	      EXIT
	   ENDIF
       ENDFOR
       IF EMPTY(cCampo)
	  cError('EL CAMPO CORRESPONDIENTE A LA MATERIA NO EXISTE')
	  RETURN NIL
       ENDIF
*>>>>FIN LOCALIZACION DE LA MATERIA

*>>>>DEFINCION DEL ENCABEZADO
       nNroPag := 0
       lTamAnc := .F.

       nTotReg := NOT->(RECCOUNT())+nLinTot
       aCabeza := {cNomEmp,cNomSis,;
		   'CODIGOS DE INDICADORES DEL GRUPO: '+cCodGru+;
		   ' A¥O: '+cAnoUsr,;
		   'MATERIA: '+cCodMat+' Periodo: '+STR(nNroPer,1),;
		   'CAMPO DE LA MATERIA: '+cCampo,;
		   nNroPag++,;
		   cTotPagina(nTotReg),lTamAnc}
       cCodIni := DRAFT_ON+ELITE+CONDEN_ON
       cCodFin := NEGRA_OF+DOBGOL_OF
*>>>>FIN DEFINCION DEL ENCABEZADO

*>>>>ENCABEZADOS DE COLUMNA
       aNroCol := {04,06,126}
       aTitulo := {'No.','CODIGO',;
		   'INDICADORES'}
       cCabCol := cRegPrint(aTitulo,aNroCol)
*>>>>FIN ENCABEZADOS DE COLUMNA

*>>>>ANALISIS PARA CENTRAR EL INFORME
       nLenPrn := n17Stan
       lCentra := .F.
       nColCab := 0
       IF lCentra
	  nColCab := (nLenPrn-LEN(cCabCol))/2
       ENDIF
       aCabSec := NIL
       bPagina := {||lPagina(nLinReg)}
       bCabeza := {||CabezaPrn(cCodIni,aCabeza,cCabCol,;
			       nColCab,cCodFin,aCabSec)}
       bDerAut := {||DerechosPrn(cNomSis,cNomEmp,n17Stan)}
*>>>>FIN ANALISIS PARA CENTRAR EL INFORME

*>>>>ANALISIS DE DECISION
       IF !lPregunta('DESEA CONTINUAR? Si No')
	  RETURN NIL
       ENDIF
*>>>>FIN ANALISIS DE DECISION

*>>>>ACTIVACION DE LA IMPRESORA
       IF !Printer_on()
	   RETURN NIL
       ENDIF
       @ PROW(),00 SAY INICIALIZA
       EVAL(bCabeza)
      *Impresi¢n del Encabezado
*>>>>FIN ACTIVACION DE LA IMPRESORA

*>>>>IMPRESION DEL PLAN ACADEMICO
       cSavPan := SAVESCREEN(0,0,24,79)
       SET DEVICE TO SCREEN
       Termometro(0,'IMPRIMIENDO')
       SET DEVICE TO PRINT

       SELECT NOT
       GO TOP
       DO WHILE .NOT. NOT->(EOF())

**********VISUALIZACION DE AVANCE
	    nAvance := INT(( NOT->(RECNO()) / NOT->(RECCOUNT()) )*100)

	    IF STR(nAvance,3) $ '25 50 75100'
	       SET DEVICE TO SCREEN
	       Termometro(nAvance)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN VISUALIZACION DE AVANCE

**********IMPRESION DEL REGISTRO
	    aTitulo := {STR(NOT->(RECNO()),2),;
			NOT->cCodigoEst,;
			&cCampo}

	    cTxtPrn := cRegPrint(aTitulo,aNroCol)
	    lPrnReg(01,nColCab,cTxtPrn,bPagina,bDerAut,bCabeza)
**********FIN IMPRESION DEL REGISTRO

**********AVANCE DEL SIGUIENTE REGISTRO
	    SELECT NOT
	    NOT->(DBSKIP())
	    IF NOT->(EOF())
	       SET DEVICE TO SCREEN
	       Termometro(100)
	       SET DEVICE TO PRINT
	    ENDIF
**********FIN AVANCE DEL SIGUIENTE REGISTRO

       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN IMPRESION DEL PLAN ACADEMICO

*>>>>IMPRESION DERECHOS
       EVAL(bDerAut)
      *Derechos de Autor

       @ PROW()-PROW(),00 SAY ' '
      *Saca la ultima linea

       SET DEVICE TO SCREEN
       RETURN NIL
*>>>>FIN IMPRESION DERECHOS