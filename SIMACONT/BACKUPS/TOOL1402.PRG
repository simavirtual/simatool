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

FUNCTION Tool1_402(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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

       LOCAL     i,k := 0                   // Contador
       LOCAL nNroPos := 0                   // N£mero de posici¢n
       LOCAL  aFecha := {}                  // Fecha

       LOCAL nNroReg := 0                   // N£mero de registro
       LOCAL cApell1 := ''                  // Apellido1
       LOCAL cApell2 := ''                  // Apellido2

       LOCAL cTxtTem := ''                  // Texto Temporal

       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathCaf)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       CreaSchool(lShared,nModCry,PathSis,'school.dat')
       IF !lUseDbf(.T.,PathSis+'\'+'school.dat','XLS',NIL,lShared)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll()
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>RECORRIDO POR NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,PathCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
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
	     k := 0
	     SELECT &cMaeAct
	     DBGOTOP()
	     DO WHILE .NOT. EOF()

*===============IMPRESION DE LA LINEA DE ESTADO
		  SELECT &cMaeAct
		  LineaEstado('MAE: '+cMaeAct+'º'+;
			      'No.'+STR(++k,4)+'/'+;
			      STR(RECCOUNT(),4),cNomSis)
*===============FIN IMPRESION DE LA LINEA DE ESTADO

*===============GRABACION DEL REGISTRO
		  IF XLS->(lRegLock(lShared,.T.))

		     REPL XLS->cNroRegXls WITH STR(++nNroReg,4,0)
		     REPL XLS->cEstadoXls WITH '1'
		     REPL XLS->cCodigoEst WITH &cMaeAct->cCodigoEst
		     REPL XLS->cNombreEst WITH &cMaeAct->cNombreEst

		     nNroPos := AT(' ',&cMaeAct->cApelliEst)
		     IF nNroPos # 0
			cApell1 := SUBS(&cMaeAct->cApelliEst,1,nNroPos)
			cApell2 := SUBS(&cMaeAct->cApelliEst,nNroPos+1,LEN(ALLTRIM(&cMaeAct->cApelliEst)))
		     ELSE
			cApell1 := ALLTRIM(&cMaeAct->cApelliEst)
			cApell2 := ''
		     ENDIF
		     REPL XLS->cApell1Xls WITH cApell1
		     REPL XLS->cApell2Xls WITH cApell2
		   *ÀApellidos del Estudiante

		     REPL XLS->cBlanc1Xls WITH ''
		     REPL XLS->cDocNitEst WITH &cMaeAct->cDocNitEst
		     REPL XLS->cTipNitXls WITH cTipNitXls(&cMaeAct->cTipNitEst)

		     IF &cMaeAct->lSexFemEst
			REPL XLS->cSexFemXls WITH '2' // Femenino
		     ELSE
			REPL XLS->cSexFemXls WITH '1' // Masculino
		     ENDIF

		     aFecha := aFecha(&cMaeAct->dFecMatEst)
		     REPL XLS->cFecIngXls WITH aFecha[2]+'/'+aFecha[1]+'/'+aFecha[3]  // dd/mm/aaaa

		     REPL XLS->cDireccEst WITH cValChrXls(&cMaeAct->cDireccEst,cMaeAct)

		     aFecha := aFecha(&cMaeAct->dFecNacEst)
		     REPL XLS->cFecNacEst WITH aFecha[2]+'/'+aFecha[1]+'/'+SUBS(aFecha[3],3,2)  // dd/mm/aaaa

		     REPL XLS->cTelefnEst WITH cTelefnXls(&cMaeAct->cTelefnEst,cMaeAct)

		     REPL XLS->cLugNacEst WITH &cMaeAct->cLugNacEst
		     REPL XLS->cMaiEstEst WITH ''
		     REPL XLS->cNumMtrXls WITH &cMaeAct->cCodigoEst
		     REPL XLS->cCodFamXls WITH STR(nNroReg,4,0)

		     IF &cMaeAct->lPadQepEst
			REPL XLS->cPadQepXls WITH '2'   // Si
		     ELSE
			REPL XLS->cPadQepXls WITH '3'   // No
		     ENDIF

		     IF &cMaeAct->lMadQepEst
			REPL XLS->cMadQepXls WITH '2'   // Si
		     ELSE
			REPL XLS->cMadQepXls WITH '3'   // No
		     ENDIF

		     REPL XLS->cPaViveXls WITH '1'      // Vive con el Alumno
		     REPL XLS->cMaViveXls WITH '1'      // Vive con el Alumno
		     REPL XLS->cNomPadXls WITH ALLTRIM(&cMaeAct->cNomPadEst)+' '+&cMaeAct->cApePadEst

		     REPL XLS->cPadTntXls WITH cTipNitXls(&cMaeAct->cPadTntEst)

		     REPL XLS->cPadNitEst WITH cNroNitXls(&cMaeAct->cCodigoEst,;
							 &cMaeAct->cPadNitEst,'2')
		     IF SUBS(XLS->cPadNitEst,1,1) == 'p'
			REPL XLS->cPadTntXls WITH '1'
		     ENDIF

		     REPL XLS->cEmpPadEst WITH cValChrXls(&cMaeAct->cEmpPadEst,cMaeAct)
		     REPL XLS->cCarPadEst WITH &cMaeAct->cCarPadEst
		     REPL XLS->cBlanc2Xls WITH ''
		     REPL XLS->cTemPadXls WITH cTelefnXls(&cMaeAct->cCelPadEst,cMaeAct,'c')
		     REPL XLS->cDirPadEst WITH cValChrXls(&cMaeAct->cDirPadEst,cMaeAct)


		     REPL XLS->cTelPadEst WITH cTelefnXls(&cMaeAct->cTelPadEst,cMaeAct)
		     REPL XLS->cMaiPadEst WITH ''
		     REPL XLS->cNomMadXls WITH ALLTRIM(&cMaeAct->cNomMadEst)+' '+&cMaeAct->cApeMadEst
		     REPL XLS->cMadTntXls WITH cTipNitXls(&cMaeAct->cMadTntEst)

		     REPL XLS->cMadNitEst WITH cNroNitXls(&cMaeAct->cCodigoEst,;
							 &cMaeAct->cMadNitEst,'3')
		     IF SUBS(XLS->cMadNitEst,1,1) == 'm'
			REPL XLS->cMadTntXls WITH '1'
		     ENDIF
		   *ÀDocumento de la madre

		     REPL XLS->cEmpMadEst WITH cValChrXls(&cMaeAct->cEmpMadEst,cMaeAct)
		     REPL XLS->cCarMadEst WITH &cMaeAct->cCarMadEst
		     REPL XLS->cBlanc3Xls WITH ''
		     REPL XLS->cTemMadXls WITH cTelefnXls(&cMaeAct->cCelMadEst,cMaeAct,'c')
		     REPL XLS->cDirMadEst WITH cValChrXls(&cMaeAct->cDirMadEst,cMaeAct)
		     REPL XLS->cTelMadEst WITH cTelefnXls(&cMaeAct->cTelMadEst,cMaeAct)
		     REPL XLS->cMaiMadEst WITH ''
		     REPL XLS->cCelPadEst WITH cTelefnXls(&cMaeAct->cCelPadEst,cMaeAct,'c')
		     REPL XLS->cCelMadEst WITH cTelefnXls(&cMaeAct->cCelMadEst,cMaeAct,'c')
		     REPL XLS->cBlanc4Xls WITH ''

		     nNroPos := AT(' ',&cMaeAct->cApeMadEst)
		     IF nNroPos # 0
			cApell1 := SUBS(&cMaeAct->cApeMadEst,1,nNroPos)
			cApell2 := SUBS(&cMaeAct->cApeMadEst,nNroPos+1,LEN(ALLTRIM(&cMaeAct->cApeMadEst)))
		     ELSE
			cApell1 := ALLTRIM(&cMaeAct->cApeMadEst)
			cApell2 := ''
		     ENDIF
		     REPL XLS->cAp1MadXls WITH cApell1
		     REPL XLS->cAp2MadXls WITH cApell2
		   *ÀApellidos de la Madre

		     REPL XLS->cNomMadEst WITH &cMaeAct->cNomMadEst
		   *ÀNombres de la Madre

		     nNroPos := AT(' ',&cMaeAct->cApePadEst)
		     IF nNroPos # 0
			cApell1 := SUBS(&cMaeAct->cApePadEst,1,nNroPos)
			cApell2 := SUBS(&cMaeAct->cApePadEst,nNroPos+1,LEN(ALLTRIM(&cMaeAct->cApePadEst)))
		     ELSE
			cApell1 := ALLTRIM(&cMaeAct->cApePadEst)
			cApell2 := ''
		     ENDIF
		     REPL XLS->cAp1PadXls WITH cApell1
		     REPL XLS->cAp2PadXls WITH cApell2
		   *ÀApellidos del Padre

		     REPL XLS->cNomPadEst WITH &cMaeAct->cNomPadEst
		   *ÀNombres del Padre


		     XLS->(DBCOMMIT())
		  ELSE
		     cError('NO SE GRABA EL REGISTRO')
		  ENDIF
		  IF lShared
		     XLS->(DBUNLOCK())
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

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 20/2010 MIE A
       Colombia, Bucaramanga        INICIO: 10:00 AM   ENE 20/2010 MIE

OBJETIVOS:

1)- Crea la estructura del archivo.

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaSchool(lShared,nModCry,PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL       i := 0                   // Contador
       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{'cNroRegXls','Character',004,0}) // 01.N£mero del registro
       AADD(aDbfStr,{'cEstadoXls','Character',012,0}) // 02.Estado del Alumno
       AADD(aDbfStr,{"cCodigoEst","Character",006,0}) // 03.C¢digo del Estudiante
       AADD(aDbfStr,{"cNombreEst","Character",030,0}) // 04.Nombre del Estudiante
       AADD(aDbfStr,{"cApell1Xls","Character",030,0}) // 05.Apellido1 del Estudiante
       AADD(aDbfStr,{"cApell2Xls","Character",030,0}) // 06.Apellido2 del Estudiante
       AADD(aDbfStr,{"cBlanc1Xls","Character",030,0}) // 07.Dejar en Blanco
       AADD(aDbfStr,{"cDocNitEst","Character",016,0}) // 08.Documento de Identidad
       AADD(aDbfStr,{"cTipNitXls","Character",001,0}) // 09.Tipo de Documento
       AADD(aDbfStr,{"cSexFemXls","Character",001,0}) // 10.Sexo
       AADD(aDbfStr,{"cFecIngXls","Character",010,0}) // 11.Fecha de ingreso
       AADD(aDbfStr,{"cDireccEst","Character",040,0}) // 12.Direccion de la casa
       AADD(aDbfStr,{"cFecNacEst","Character",010,0}) // 13.Fecha de nacimiento
       AADD(aDbfStr,{"cTelefnEst","Character",014,0}) // 14.Telefono de la casa
       AADD(aDbfStr,{"cLugNacEst","Character",020,0}) // 15.Lugar de nacimiento
       AADD(aDbfStr,{"cMaiEstEst","Character",040,0}) // 16.E-MAIL de la Casa o del Estudiante
       AADD(aDbfStr,{'cNumMtrXls','Character',006,0}) // 17.N£mero de la matricula
       AADD(aDbfStr,{'cCodFamXls','Character',006,0}) // 18.C¢digo de la familia
       AADD(aDbfStr,{"cPadQepXls","Character",002,0}) // 19.Padre Fallecido
       AADD(aDbfStr,{"cMadQepXls","Character",002,0}) // 20.Madre Fallecida

       AADD(aDbfStr,{"cPaViveXls","Character",002,0}) // 21.Padre Vive con Alumno
       AADD(aDbfStr,{"cMaViveXls","Character",002,0}) // 22.Madre Vive con Alumno
       AADD(aDbfStr,{"cNomPadXls","Character",060,0}) // 23.Nombres y Apellidos del padre
       AADD(aDbfStr,{"cPadTntXls","Character",001,0}) // 24.Tipo de Documento
       AADD(aDbfStr,{"cPadNitEst","Character",016,0}) // 25.N£mero de Documento del padre
       AADD(aDbfStr,{"cEmpPadEst","Character",026,0}) // 26.Empresa del padre
       AADD(aDbfStr,{"cCarPadEst","Character",020,0}) // 27.Cargo del padre
       AADD(aDbfStr,{"cBlanc2Xls","Character",030,0}) // 28.Dejar en Blanco
       AADD(aDbfStr,{"cTemPadXls","Character",014,0}) // 29.Telefono de la Empresa del padre
       AADD(aDbfStr,{"cDirPadEst","Character",040,0}) // 30.Direccion del Padre
       AADD(aDbfStr,{"cTelPadEst","Character",014,0}) // 31.Telefono personal del padre
       AADD(aDbfStr,{"cMaiPadEst","Character",040,0}) // 32.E-MAIL del padre
       AADD(aDbfStr,{"cNomMadXls","Character",060,0}) // 33.Nombres y Apellidos de la madre
       AADD(aDbfStr,{"cMadTntXls","Character",001,0}) // 34.Tipo de Documento de la madre
       AADD(aDbfStr,{"cMadNitEst","Character",016,0}) // 35.N£mero de Documento de la madre
       AADD(aDbfStr,{"cEmpMadEst","Character",026,0}) // 36.Empresa de la madre
       AADD(aDbfStr,{"cCarMadEst","Character",020,0}) // 37.Cargo de la madre
       AADD(aDbfStr,{"cBlanc3Xls","Character",030,0}) // 38.Dejar en Blanco
       AADD(aDbfStr,{"cTemMadXls","Character",014,0}) // 39.Telefono de la Empresa de la madre
       AADD(aDbfStr,{"cDirMadEst","Character",040,0}) // 40.Direccion de la Madre
       AADD(aDbfStr,{"cTelMadEst","Character",014,0}) // 41.Telefono personal de la madre
       AADD(aDbfStr,{"cMaiMadEst","Character",040,0}) // 42.E-MAIL de la madre
       AADD(aDbfStr,{"cCelPadEst","Character",014,0}) // 43.Telefono celular del Padre
       AADD(aDbfStr,{"cCelMadEst","Character",014,0}) // 44.Telefono celular de la Madre
       AADD(aDbfStr,{"cBlanc4Xls","Character",030,0}) // 45.Dejar en Blanco
       AADD(aDbfStr,{"cAp1MadXls","Character",030,0}) // 46.Apellido1 de la Madre
       AADD(aDbfStr,{"cAp2MadXls","Character",030,0}) // 47.Apellido2 de la Madre
       AADD(aDbfStr,{"cNomMadEst","Character",030,0}) // 48.Nombres de la Madre
       AADD(aDbfStr,{"cAp1PadXls","Character",030,0}) // 50.Apellido1 del Padre
       AADD(aDbfStr,{"cAp2PadXls","Character",030,0}) // 51.Apellido2 del Padre
       AADD(aDbfStr,{"cNomPadEst","Character",030,0}) // 49.Nombres del Padre
*>>>>FIN CREACION DE LA ESTRUCTURA

*>>>>RETORNO DE LA ESTRUCTURA
       IF !EMPTY(aStrDbf)
          aStrDbf := aDbfStr
          RETURN NIL
       ENDIF
*>>>>FIN RETORNO DE LA ESTRUCTURA

*>>>>CREACION DE LA ESTRUCTURA
       PathAct := cPathAct()
       DO CASE
       CASE nCd(PathArc) == 0
            DBCREATE(fArchvo,aDbfStr,'DBFNTX')

       CASE nCd(PathArc) == -3
            cError('NO EXISTE EL DIRECTORIO: '+PathArc)

       CASE nCd(PathArc) == -5
            cError('NO TIENE DERECHOS EN: '+PathArc)
       ENDCASE
       nCd(PathAct)
       RETURN NIL
*>>>>FIN CREACION DE LA ESTRUCTURA

/*************************************************************************
* TITULO..: VALIDACION DEL TELEFONO                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2010 LUN A
       Colombia, Bucaramanga        INICIO: 11:30 AM   ENE 25/2010 LUN

OBJETIVOS:

1- Valida el n£mero del telefono

2- Retorna el n£mero del telefono validado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTelefnXls(cTelefn,cMaeAct,cTipTel)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTelefn                              // Telefono
       cMaeAct                              // Maestro Actual
       cTipTel                              // Tipo de Telefono */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL cNroTel := ''                        // N£mero del telefono
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ANALISIS DE VALIDACION
       cTelefn := ALLTRIM(cTelefn)
       cTipTel := IF(cTipTel==NIL,'f','c')
       cNroTel := ''

       DO CASE
       CASE '-' $ cTelefn

	    nNroPos := AT('-',cTelefn)
	    IF cTipTel == 'f' .AND. LEN(cTelefn) # 11  //300-5639800=11
	       cNroTel := SUBS(cTelefn,1,nNroPos-1)
	    ELSE
	       cNroTel := STUFF(cTelefn,nNroPos,1,'')
	    ENDIF

       CASE ' ' $ ALLTRIM(cTelefn)

	    nNroPos := AT(' ',ALLTRIM(cTelefn))
	    cNroTel := SUBS(cTelefn,1,nNroPos-1)

       CASE 'E' $ ALLTRIM(cTelefn)

	    nNroPos := AT('E',ALLTRIM(cTelefn))
	    cNroTel := SUBS(cTelefn,1,nNroPos-1)

       CASE '.' $ ALLTRIM(cTelefn)

	    nNroPos := AT('.',ALLTRIM(cTelefn))
	    cNroTel := SUBS(cTelefn,1,nNroPos-1)

       CASE '/' $ ALLTRIM(cTelefn)

	    nNroPos := AT('.',ALLTRIM(cTelefn))
	    cNroTel := SUBS(cTelefn,1,nNroPos-1)

       CASE '*' $ ALLTRIM(cTelefn)

	    nNroPos := AT('*',ALLTRIM(cTelefn))
	    cNroTel := SUBS(cTelefn,1,nNroPos-1)

       OTHERWISE
	    cNroTel := cTelefn
       ENDCASE

       IF LEN(ALLTRIM(cNroTel)) > 10
	  cNroTel := ''
       ENDIF

       RETURN cNroTel
*>>>>FIN ANALISIS DE VALIDACION

/*************************************************************************
* TITULO..: VALIDACION DEL NUMERO DEL DOCUMENTO                          *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2010 LUN A
       Colombia, Bucaramanga        INICIO: 01:00 PM   ENE 25/2010 LUN

OBJETIVOS:

1- Valida el n£mero del telefono

2- Retorna el n£mero del telefono validado

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cNroNitXls(cCodEst,cNroNit,cTipPer)

*>>>>DESCRIPCION DE PARAMETROS
/*     cCodEst                              // C¢digo del Estudiante
       cNroNit                              // N£mero del Nit
       cTipPer                              // Tipo de Persona */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cDocNit := ''                   // Documento de Identificaci¢n

       LOCAL nNroPos := 0                    // N£mero de Posici¢n
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL DOCUMENTO
       DO CASE
       CASE EMPTY(ALLTRIM(cNroNit)) .OR. 'FALLE' $ cNroNit
	    DO CASE
	    CASE cTipPer == '1' // Estudiante
		 cDocNit := cNroNit

	    CASE cTipPer == '2' // Padre
		 cDocNit := 'p'+cCodEst

	    CASE cTipPer == '3' // Madre
		 cDocNit := 'm'+cCodEst

	    ENDCASE

       CASE '.' $ cNroNit

	    cDocNit := cNroNit
	    DO WHILE AT('.',cDocNit) # 0
	       nNroPos := AT('.',cDocNit)
	       cDocNit := STUFF(cDocNit,nNroPos,1,'')
	    ENDDO
	  *ÀElimina los puntos

       OTHERWISE
	    cDocNit := cNroNit
       ENDCASE
       RETURN cDocNit
*>>>>FIN VALIDACION DEL DOCUMENTO

/*************************************************************************
* TITULO..: VALIDACION EL TIPO DE DOCUMENTO                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: ENE 25/2010 LUN A
       Colombia, Bucaramanga        INICIO: 02:00 PM   ENE 25/2010 LUN

OBJETIVOS:

1- Valida el tipo de documento

2- Retorna el tipo de documento

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cTipNitXls(cTipNit)

*>>>>DESCRIPCION DE PARAMENTROS
/*     cTipNit                              // Tipo de documento */
*>>>>FIN DESCRIPCION DE PARAMENTROS

*>>>>DECLARACION DE VARIABLES
       LOCAL cTipDoc := ''                  // Tipo de Documento
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE VARIABLES
       DO CASE
       CASE EMPTY(ALLTRIM(cTipNit))
	    cTipDoc := '0'

       CASE ALLTRIM(cTipNit) == 'CC'
	    cTipDoc := '1'

       CASE ALLTRIM(cTipNit) == 'TI'
	    cTipDoc := '2'

       CASE ALLTRIM(cTipNit) == 'RC'
	    cTipDoc := '7'

       CASE ALLTRIM(cTipNit) == 'NUI'
	    cTipDoc := '9'

       OTHERWISE
	    cTipDoc := '0'
       ENDCASE
       RETURN cTipDoc
*>>>>FIN DECLARACION DE VARIABLES

/*************************************************************************
* TITULO..: VALIDACION DE CARACTERES                                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 01/2010 LUN A
       Colombia, Bucaramanga        INICIO: 09:00 AM   FEB 01/2010 LUN

OBJETIVOS:

1- Valida car cteres no permitidos.

2- Retorna el texto validado.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION cValChrXls(cTextos,cMaeAct)

*>>>>DESCRIPCION DE PARAMETROS
/*     cTextos				    // Textos
       cMaeAct                              // Maestro Actual */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL nNroPos := 0                   // N£mero de la posici¢n
       LOCAL cTxtXls := ''                  // N£mero del telefono
*>>>>FIN DECLARACION DE VARIABLES

*>>>>ELIMINAR LOS PUNTOS
       cTextos := ALLTRIM(cTextos)
       cTxtXls := cTextos
       IF '.' $ cTextos
	  cTxtXls := cTextos
	  DO WHILE AT('.',cTxtXls) # 0
	     nNroPos := AT('.',cTxtXls)
	     cTxtXls := STUFF(cTxtXls,nNroPos,1,' ')
	  ENDDO
       ENDIF
*>>>>FIN ELIMINAR LOS PUNTOS

*>>>>ELIMINAR LAS COMAS
       cTextos := cTxtXls
       IF ',' $ cTextos
	  cTxtXls := cTextos
	  DO WHILE AT(',',cTxtXls) # 0
	     nNroPos := AT(',',cTxtXls)
	     cTxtXls := STUFF(cTxtXls,nNroPos,1,' ')
	  ENDDO
       ENDIF
       RETURN cTxtXls
*>>>>FIN ELIMINAR LAS COMAS
