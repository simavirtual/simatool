/*                      SIMA - SISTEMA UTILITARIO
			    MODULO No. 101

MODULO      : SIMACONT
SUBMODULO...: MANTENIMIENTOS

**************************************************************************
* TITULO..: MENU DE MANTENIMIENTOS                                       *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 11:45 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Menu de Mantenimientos de Archivos de la Contabilidad Acad‚mica

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tools_101(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       LOCAL cSavPan := ''                  // Salvar Pantalla

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)

       AADD(aMenus,"1<NOTAS      >")
       AADD(aMenus,"2<ESTRUCTURA >")
       AADD(aMenus,"3<PRN CODIGOS>")

       AADD(aAyuda,'Permite el Mantenimiento del Archivo de Notas')
       AADD(aAyuda,'Visualiza la Estructura del Archivo')
       AADD(aAyuda,'Imprime los C¢digos de los Indicadores de Cada Materia')
*>>>>FIN DECLARCION Y EJECUCION DEL MENU

*>>>>VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA
       nLenOpc := LEN(aMenus[1])
      *Calculo de la Longitud mayor

       IF nColInf + nLenOpc + 2 > 78
	  nColInf := 78-nLenOpc-3
       ENDIF
*>>>>FIN VALIDACION DEL LIMITE DE LA ULTIMA COLUMNA

*>>>>ANALISIS DE OPCION ESCOGIDA
       nNroOpc := 1
       DO WHILE nNroOpc # 0

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf+1,nColInf,NIL,NIL,nNroOpc,.F.)

	  RESTSCREEN(0,0,24,79,cSavPan)
	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1
	       Tools_111(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)
	      *Mantenimientos de Notas

	  CASE nNroOpc == 2
	       Tools_112(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)
	      *Estructura del Archivo de Notas

	  CASE nNroOpc == 3
	       Tools_113(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)
	      *Impresi¢n de C¢digos

	  ENDCASE
	  RESTSCREEN(0,0,24,79,cSavPan)
       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA

