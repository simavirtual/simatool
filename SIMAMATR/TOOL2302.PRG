/* SIMATOOL - MATRICULA ACADEMICA

MODULO      : CONSULTAS
SUBMODULO...: TIPOS DE OBSERVACIONES

**************************************************************************
* TITULO..: SUBDIVISION DE OBSERVACIONES                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: NOV 28/2006 MAR A
       Colombia, Bucaramanga        INICIO: 05:00 PM   NOV 28/2006 MAR

OBJETIVOS:

1- Permite el Mantenimiento de los tipos de observaciones.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tool2_302(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,;
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

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL PathCon := ''                 // Path de la Contabilidad

       LOCAL aArchvo := {}                  // Archivos para Uso
       LOCAL cNalias := ''                  // Alias del Archivo
       LOCAL lPrnArc := .F.                 // .T. Imprimir a Archivo
       LOCAL cOpcPrn := ''                  // Opciones de Impresi¢n.
       LOCAL nCodPrn := 0                   // C¢digo de Impresi¢n
       LOCAL lModReg := .F.                 // .T. Modificar el Registro
       LOCAL lDelReg := .F.                 // .T. Borrar Registros
       LOCAL lInsReg := .F.                 // .T. Insertar Registro
       LOCAL lHaySql := .F.                 // .T. Exportar a Sql
       LOCAL lPrueba := .F.                 // .T. Pruebas
*>>>>FIN DECLARACION DE VARIABLES

*>>>>AREAS DE TRABAJO
       aUseDbf := {}
       AADD(aUseDbf,{.T.,PathSis+'\'+fSimTol,'TOL',NIL,lShared,nModCry})
       AADD(aUseDbf,{.T.,PathSis+'\'+FilePrn,'PRN',NIL,lShared,nModCry})
*>>>>FIN AREAS DE TRABAJO

*>>>>SELECION DE LAS AREAS DE TRABAJO
       IF !lUseDbfs(aUseDbf)
	  cError('ABRIENDO EL ARCHIVO FIADORES')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TOL->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL')

       CASE PRN->(RECCOUNT()) == 0
	    cError('NO EXISTEN IMPRESIORAS GRABADAS')

       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       IF lHayErr
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>LOCALIZACION DE LA IMPRESORA
       IF !lLocCodigo('nCodigoPrn','PRN',TOL->nCodigoPrn)
	  cError('NO EXISTE LA IMPRESORA QUE ESTA HABILITADA')
	  CloseAll(aUseDbf)
	  RETURN NIL
       ENDIF

       PathCon := ALLTRIM(TOL->PathCont)

       lPrnArc := TOL->lPrnArcTol
       nCodPrn := TOL->nCodigoPrn
       cOpcPrn := TOL->cOpcPrnTol
       lPrueba := TOL->lPruebaTol
       CloseAll()
*>>>>FIN LOCALIZACION DE LA IMPRESORA

*>>>>AREAS DE TRABAJO
       aArchvo := {}
       AADD(aArchvo,{PathSis+'\'+FilePrn,NIL,'PRN'})
       AADD(aArchvo,{PathCon+'\'+PathSis+'\'+FileToG,NIL,'TOG'})
*>>>>FIN AREAS DE TRABAJO

*>>>>MANTENIMIENTO DEL ARCHIVO
       lModReg := .T.
       lDelReg := lPrueba
       lInsReg := .T.
       lHaySql := lPrueba

       MantenToG(lShared,nModCry,cNomSis,cCodEmp,cNitEmp,;
		 cEmpPal,cNomEmp,cNomSec,cNomUsr,cAnoUsr,;
		 aArchvo,lPrnArc,cOpcPrn,nCodPrn,;
		 lModReg,lDelReg,lInsReg,lHaySql)

       RETURN NIL
*>>>>FIN MANTENIMIENTO DEL ARCHIVO
