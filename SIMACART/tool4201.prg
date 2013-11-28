/*                      SIMA - SISTEMA UTILITARIO
		      SISTEMA CONTABILIDAD ACADEMICA

MENU......: ACTUALIZAR
SUBMENU...: CREAR LOS PAGOS
SISTEMA...: CARTERA ACADEMICA

**************************************************************************
* TITULO..: CREAR LOS PAGOS                                              *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 06/2013 MIE A
       Colombia, Bucaramanga        INICIO: 04:15 PM   FEB 06/2013 MIE

OBJETIVOS:

1- Pendiente

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool4_201(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		   cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
		   cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)

*>>>>DECLARACION DE PARAMETROS
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
*>>>>FIN DECLARACION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del Sistema
       LOCAL lHayReg := .F.                 // .T. Existe el registro
       LOCAL lHayCon := .T.                 // .T. Existe el registro

       LOCAL cCodRefTra := ''               // C¢digo de la Referencia


       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS
       DbfPagoAlu(PathSis,'MODEMMAE'+ExtFile)
*>>>>FIN CREACION DE ESTRUCTURAS

*>>>>AREAS DE TRABAJO
       AADD(aUseDbf,{.T.,PathSis+'\MODEMPAG'+ExtFile,'TRA',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\MAEANTER'+ExtFile,'ANT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\MODEMMAE'+ExtFile,'MAE',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\MAEACTUA'+ExtFile,'ACT',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\CONCEPTO'+ExtFile,'CON',NIL,lShared,nModCry})
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
       CASE TRA->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MODEMPAG NO CONTIENE REGISTROS')

       CASE ANT->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MAEANTER NO CONTIENE REGISTROS')

       CASE MAE->(RECCOUNT()) # 0
	    cError('EL ARCHIVO MODEMMAE DEBE ESTAR VACIO')

       CASE CON->(RECCOUNT()) == 0
	    cError('EL ARCHIVO CONCEPTO NO CONTIENE REGISTROS')

       CASE CON->nValorCon == 0
	    cError('NO ESTAN DEFINIDOS LOS VALORES DE LOS CONCEPTOS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT TRA
       TRA->(DBGOTOP())
       DO WHILE .NOT. TRA->(EOF())

**********VALIDACION DE LA REFERENCIA
	    cCodRefTra := ALLTRIM(TRA->cCodRefTra)

	    lHayErr := .T.
	    DO CASE
	    CASE LEN(cCodRefTra) # 10

	    CASE (SUBS(cCodRefTra,7,4) # '1313')

		 IF SUBS(cCodRefTra,7,4) == '02'
		    lHayErr := .F.
		 ENDIF

	    OTHERWISE
		 lHayErr := .F.
	    ENDCASE
	    IF lHayErr
	       TRA->(DBSKIP())
	       LOOP
	    ENDIF
**********FIN VALIDACION DE LA REFERENCIA

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+TRA->(STR(RECNO(),4))+'/'+;
				     TRA->(STR(RECCOUNT(),4))+;
			'ºRef.:'+TRA->cCodRefTra,cNomSis)
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','ANT',ALLTRIM(TRA->cCodigoEst))
**********FIN LOCALIZACION DEL CODIGO

**********LOCALIZACION DEL CONCEPTO
	    lHayCon := .F.
	    SELECT CON
	    LOCATE FOR CON->nValorCon == TRA->nValorTra

	    IF CON->(FOUND())
	       lHayCon := .T.
	    ENDIF
**********FIN LOCALIZACION DEL CONCEPTO

**********GRABACION DEL REGISTRO
	    SELECT MAE
	    IF MAE->(lRegLock(lShared,.T.))

	       REPL MAE->cCodRefTra WITH TRA->cCodRefTra
	       REPL MAE->nValorTra  WITH TRA->nValorTra
	       REPL MAE->dFechaTra  WITH TRA->dFechaTra

	       IF lHayReg

		  IF SUBS(cCodRefTra,1,6) == TRA->cCodigoEst .AND.;
		     SUBS(cCodRefTra,1,6) == ANT->cCodigoEst

		     REPL MAE->cCodigoEst WITH ANT->cCodigoEst
		     REPL MAE->cCodAntGru WITH ANT->cCodigoGru

		  ENDIF

		  REPL MAE->cApelliEst WITH ANT->cApelliEst
		  REPL MAE->cNombreEst WITH ANT->cNombreEst

		  IF lHayCon
		     REPL MAE->cConcepEst WITH CON->cCodigoCon
		  ENDIF

	       ENDIF

	       MAE->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       MAE->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  TRA->(DBSKIP())
	*ÀAvance del registro

       ENDDO

       FijarGru(lShared,cNomSis)

       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS

/*************************************************************************
* TITULO..: CREACION DE LA ESTRUCTURA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 06/2013 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   FEB 06/2013 MIE

OBJETIVOS:

1)- Crea la estructura del archivo

2)- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION DbfPagoAlu(PathArc,fArchvo,aStrDbf)

*>>>>DESCRIPCION DE PARAMETROS
/*     PathArc                              // Path del Archivo
       fArchvo                              // Nombre del Archivo
       aStrDbf                              // Estructura del Archivo */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       LOCAL PathAct := ''                  // Path Actual

       LOCAL aDbfStr := {}                  // Estructura del Archivo
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DE LA ESTRUCTURA
       AADD(aDbfStr,{"cCodRefTra","Character",012,0}) // C¢digo de la Referencia
       AADD(aDbfStr,{"nValorTra" ,"Numeric"  ,014,2}) // Valor de la Transaci¢n
       AADD(aDbfStr,{"dFechaTra" ,"Date"     ,008,0}) // Fecha de la Transaci¢n.

       AADD(aDbfStr,{"cCodigoEst","Character",006,0}) // C¢digo del Estudiante
       AADD(aDbfStr,{"cApelliEst","Character",030,0}) // Apellido del Estudiante
       AADD(aDbfStr,{"cNombreEst","Character",030,0}) // Nombre del Estudiante
       AADD(aDbfStr,{"cCodAntGru","Character",004,0}) // Codigo del grupo Anterior
       AADD(aDbfStr,{"cCodigoGru","Character",004,0}) // Codigo del grupo
       AADD(aDbfStr,{"cConcepEst","Character",016,0}) // Conceptos del Estudiante
*>>>>FIN DECLARACION DE LA ESTRUCTURA

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
* TITULO..: VALIDAR MATRICULADOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: FEB 11/2013 MIE A
       Colombia, Bucaramanga        INICIO: 03:30 PM   FEB 11/2013 MIE

OBJETIVOS:

1- Asigna el grupo a los estudiantes que ya estan matriculados.

2- Retorna NIL

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION FijarGru(lShared,cNomSis)

*>>>>DECLARACION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       cNomSis                              // Nombre del Sistema */
*>>>>FIN DECLARACION DE PARAMETROS


*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lHayErr := .F.                 // .T. Hay Error
       LOCAL lHayReg := .F.                 // .T. Existe el registro

       LOCAL Getlist := {}                  // Variable del sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE ACT->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MAEACTUA NO CONTIENE REGISTROS')

       CASE MAE->(RECCOUNT()) == 0
	    cError('EL ARCHIVO MODEMMAE NO CONTIENE REGISTROS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE

       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>RECORRIDO DE REGISTROS
       SELECT MAE
       MAE->(DBGOTOP())
       DO WHILE .NOT. MAE->(EOF())

**********LINEA DE ESTADO
	    LineaEstado('REGISTROS:'+MAE->(STR(RECNO(),4))+'/'+;
				     MAE->(STR(RECCOUNT(),4))+;
			'ºCONCEPTO:'+MAE->cConcepEst,'ASIGNANDO GRUPOS')
**********FIN LINEA DE ESTADO

**********LOCALIZACION DEL CODIGO
	    lHayReg := lLocCodigo('cCodigoEst','ACT',MAE->cCodigoEst)
**********FIN LOCALIZACION DEL CODIGO

**********GRABACION DEL REGISTRO
	    SELECT MAE
	    IF MAE->(lRegLock(lShared,.F.))

	       IF lHayReg
		  REPL MAE->cCodigoGru WITH ACT->cCodigoGru
	       ENDIF

	       MAE->(DBCOMMIT())

	    ELSE
	       cError('NO SE GRABA EL REGISTRO')
	    ENDIF

	    IF lShared
	       MAE->(DBUNLOCK())
	    ENDIF
**********FIN GRABACION DEL REGISTRO


	  MAE->(DBSKIP())
	*ÀAvance del registro

       ENDDO
       CloseAll(aUseDbf)
       RETURN NIL
*>>>>FIN RECORRIDO DE REGISTROS
