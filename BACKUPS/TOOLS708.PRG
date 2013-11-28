/*                      SIMA - SISTEMA UTILITARIO

MENU......: ACTUALIZAR
SUBMENU...: CODIGOS RECUPERACIONES
SISTEMA...: HERRAMIENTAS DEL SISTEMA SIMA           MODULO No. 709

**************************************************************************
* TITULO..: CONFIGURACION DEL SISTEMA                                    *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2002 VIE A
       Colombia, Bucaramanga        INICIO: 04:30 PM   AGO 16/2002 VIE

OBJETIVOS:

1- Visualiza un men£ para seleccionar las diferentes Configuraciones
   del Sistema.

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION Tools_708(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
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
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL lHayErr := .F.                 // .T. Hay Error

       LOCAL nLenOpc := 0                   // Longitud de las opciones
       LOCAL nNroOpc := 1                   // Numero de la opcion
       LOCAL aMenus  := {}                  // Vector de declaracion de men£
       LOCAL aAyuda  := {}                  // Vector de ayudas para el men£

       LOCAL GetList := {}                  // Variable del Sistema
       MEMVA xClrSys			    // Color del Sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARCION Y EJECUCION DEL MENU
       cSavPan := SAVESCREEN(0,0,24,79)
       aMenus := {'1<CONFIGURACION GENERAL>',;
		  '2<CONFIGURACION SISTEMA>',;
		  '3<CONFIGURACION A¥O    >',;
		  '4<CONFIGURACION COLOR  >',;
		  '5<CONFIGURACION PRINTER>'}

       aAyuda := {'Consulta la Configuraci¢n General del Sistema',;
		  'Consulta la Configuraci¢n del Sistema',;
		  'Consulta la Configuraci¢n para el A¤o',;
		  'Consulta la Configuraci¢n del Color',;
		  'Consulta la Configuraci¢n de las Impresoras'}
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

	  nNroOpc := nMenu(aMenus,aAyuda,nFilInf-1,nColInf,NIL,NIL,;
			   nNroOpc,.F.,;
			   IF(!EMPTY(xClrSys),xClrSys[4],''))

	  DO CASE
	  CASE nNroOpc == 0
	       EXIT

	  CASE nNroOpc == 1

	  CASE nNroOpc == 2
	       MantenTol(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
			 cNomEmp,nFilInf,nColInf,nFilPal,cNomUsr,;
			 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,cJorTxt)
	      *Configuraci¢n del Sistema

	  CASE nNroOpc == 3

	  CASE nNroOpc == 4
	       MantenClr(lShared,nModCry,PathSis,FileClr)
	      *Configuraci¢n del Color

	  CASE nNroOpc == 5
	       MantenPrn(lShared,nModCry,cNomSis,cNomEmp,;
			 cNomUsr,cAnoUsr,PathSis,FilePrn,2)
	      *Configuraci¢n de la Impresora

	  ENDCASE

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN ANALISIS DE OPCION ESCOGIDA