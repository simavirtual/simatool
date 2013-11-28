/* SIMATOOL - MATRICULA ACADEMICA

MODULO      : ACTUALIZAR
SUBMODULO...: ACTUALIZAR INFORMACION

**************************************************************************
* TITULO..: ACTUALIZAR INFORMACION                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAR 13/2012 MIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   MAR 13/2012 MIE

OBJETIVOS:

1- Permite actualizar el maestro de los estudiantes de los servicios de
   restaurante o transporte con los datos de los estudiantes del maestro
   de estudiantes.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool2_202(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,;
		   cNitEmp,cNomEmp,cNomSec,nFilInf,nColInf,;
		   nFilPal,cNomUsr,cAnoUsr,cPatSis,cMaeAlu,;
		   cMaeAct,cJorTxt)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la empresa
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSec                              // Nombre Secundario de la Empresa
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

       LOCAL     i,k := 0                   // Contador

       LOCAL PathMae := ''                  // Path de los Maestros
       LOCAL fMtrAno := 'MATR'              // Ej: MATR2012.DAT

       LOCAL  cCampo := ''                  // Campo
       LOCAL cCampo1 := ''                  // Campo Desactualizado
       LOCAL cCampo2 := ''                  // Campo Actualizado
       LOCAL aStrDbf := NIL                 // Estructura del Archivo



       LOCAL Getlist := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA PATH DE MATRICULAS
       lShared := .T.
       cSavPan := SAVESCREEN(0,0,24,79)
       PathMtr := SPACE(60)
       @ nFilInf+1,nColInf SAY 'PATH DEL SISTEMA:' GET PathMtr PICT '@!S46'
       READ
       RESTSCREEN(0,0,24,79,cSavPan)

       IF EMPTY(PathMtr)
	  cError('SE ABANDONA EL PROCESO')
	  RETURN NIL
       ENDIF
       PathMtr := ALLTRIM(PathMtr)
*>>>>FIN LECTURA PATH DE MATRICULAS


*>>>>ANALISIS DE DECISION
       cError(cMaeAlu,'MAESTROS HABILITADOS')
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RETURN NIL
       ENDIF

       cError(PathMtr,'PATH DEL SISTEMA')
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RETURN NIL
       ENDIF
       PathMtr := PathMtr+'\SIMAMATR\'+cPatSis
*>>>>ANALISIS DE DECISION

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathMtr+'\'+;
			 fMtrAno+cAnoUsr+ExtFile,'ANO',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECCION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO ARCHIVOS')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECCION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ANO->(RECCOUNT()) == 0
	    cError('NO EXISTEN REGISTROS DE CONFIGURACION DEL A¥O')

       CASE EMPTY(ANO->cIntUnoAno)
	    cError('NO EXISTE EL PATH DE SIMACONT')

       CASE EMPTY(ANO->cIntCuaAno)
	    cError('NO ESTA HABILITADA LAS MATRICULAS DE OTROS SERVICIOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ANALISIS DE DECISION
       PathMae := ALLTRIM(ANO->cIntUnoAno)
       PathCon := ALLTRIM(ANO->cIntCuaAno)

       cError(PathCon,'PATH SIMACONT REAL')
       cError(PathMae,'PATH SIMACONT')

       CloseAll(aUseDbf)
       IF !lPregunta('DESEA CONTINUAR? No Si')
	  RETURN NIL
       ENDIF
*>>>>ANALISIS DE DECISION

*>>>>RECORRIDO POR NIVELES
       FOR i := 1 TO LEN(cMaeAlu)/3

***********SELECION DE LAS AREAS DE TRABAJO
	     cMaeAct := SUBS(cMaeAlu,i*3-2,3)
	     IF !lUseDbf(.T.,PathMae+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileAlu+cMaeAct+cAnoSis+ExtFile,;
			     cMaeAct,NIL,lShared) .OR.;
		!lUseDbf(.T.,PathCon+'\'+cPatSis+'\'+cMaeAct+'\'+;
			     FileAlu+cMaeAct+cAnoSis+ExtFile,;
			     'ALU',NIL,lShared)

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

	     CASE ALU->(RECCOUNT()) == 0
		  cError('NO EXISTE ESTUDIANTES ALU GRABADOS ')

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
	     aStrDbf := DBSTRUCT()

	     DBGOTOP()
	     DO WHILE .NOT. EOF()

		SELECT &cMaeAct

*===============LINEA DE ESTADO
		  LineaEstado(cMaeAct+':'+STR(RECNO(),4)+'/'+;
					  STR(RECCOUNT(),4),cNomSis)
*===============FIN LINEA DE ESTADO

*===============LOCALIZACION DEL CODIGO
		  IF !lLocCodigo('cCodigoEst','ALU',&cMaeAct->cCodigoEst)
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

		     FOR k := 1 TO LEN(aStrDbf)

			 cCampo := ALLTRIM(aStrDbf[k,1])

			 IF UPPER(cCampo) == 'CCODIGOEST' .OR.;
			    UPPER(cCampo) == 'CCODIGOGRU'
			    LOOP
			 ENDIF

			 cCampo1 := cMaeAct+'->'+cCampo
			 cCampo2 := 'ALU->'+cCampo

			 REPL &cCampo1 WITH &cCampo2

		     ENDFOR

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
*>>>>FIN RECORRIDO POR NIVELES







