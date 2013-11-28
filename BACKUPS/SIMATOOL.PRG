/*                      SIMA - SISTEMA UTILITARIO
			    PROGRAMA PRINCIPAL

**************************************************************************
* TITULO..: SISTEMA UTILITARIO DEL SIMA                                  *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Visualiza todos los men£s de la aplicacion

2- Ejecuta cada una de las funciones de la aplicaci¢n

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*      #INCLUDE "CAMPOS\INS-TOOL.PRG"       // Detalles de Instalaci¢n
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema
       #INCLUDE "CAMPOS\VER-TOOL.PRG"       // Detalles del N£mero de Versi¢n

       LOCAL cEmpPal := ''                  // Nombre de la Comunidad
       LOCAL cNitEmp := ''                  // Nit de la Empresa
       LOCAL cNomEmp := ''                  // Nombre de la Empresa
       LOCAL cCodEmp := ''                  // C¢digo de la Empresa
       LOCAL cPaises := ''                  // Nombre del Pais
       LOCAL cNomDpt := ''                  // Nombre del Departamento
       LOCAL cNomMun := ''                  // Nombre del Municipio
       LOCAL cNomSec := ''                  // Nombre Secundario
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL nSysOpe := 0                   // Sistema Operativo 0=>Windows 1=>Novell 2=>Linux
       LOCAL cDerSys := ''                  // Derechos del Sistema
       LOCAL cPwdSis := ''                  // PassWord Creaci¢n usuarios
       LOCAL nPrueba := 0                   // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       LOCAL cAnoHab := ''                  // A¤o Habilitado
       LOCAL cMesHab := ''                  // Mes Habilitado
       LOCAL cPwdHar := ''                  // Serial del HardWare
       LOCAL lPiePag := .T.                 // .T. Impresi¢n Pie de P gina
       LOCAL cMaeAlu := ''                  // Maestros habilitados
       LOCAL cJornad := ''                  // Jornadas habilitadas
       LOCAL nPerHab := 0                   // Periodo Habilitado
       LOCAL cPwdIns := ''                  // Serial de Instalaci¢n
     *ÀDetalles de Instalaci¢n.

       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL cNomSis := ''                  // Nombre del Sistema
       LOCAL cTipSis := ''                  // Tipo de Sistema

       LOCAL cNomUsr := ''                  // Nombre del Usuario
       LOCAL cDerech := ''                  // Derechos del usuario
       LOCAL lHayFec := .T.                 // .T. Hay Fecha del Sistema

       LOCAL cAnoUsr := ''                  // A¤o del usuario
       LOCAL cAnoSis := ''                  // A¤o del sistema
       LOCAL nColAno := NIL                 // Columna del A¤o

       LOCAL cIniJor := ''                  // Iniciales de la jornada
       LOCAL cJorTxt := ''                  // Jornada escogida
       LOCAL cPatSis := ''                  // Path del sistema

       LOCAL cMaeAct := ''                  // Maestro Activo
       LOCAL cNivTxt := ''                  // Maestro escogido
       LOCAL cNomApl := ''                  // Nombre de la Aplicaci¢n

       LOCAL       i := 0                   // Contador
       LOCAL nOpcion := 1                   // Opci¢n del SubMen£
       LOCAL nOpcPal := 0                   // Opci¢n principal
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL cTitSup := ''                  // T¡tulo Superior para el men£
       LOCAL cTitInf := ''                  // T¡tulo Inferior para el men£
       LOCAL nFilSup := 0                   // Fila Superior del men£
       LOCAL xColSup := NIL                 // Columna(s) para el men£

       LOCAL GetList := {}                  // Variable para el sistema
       MEMVA xClrSys			    // Color del Sistema
       CloseAll()                           // Cierre de las Bases de Datos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>SELECCION DEL SISTEMA
       xClrSys := ''
       CLEAR
       @ 00,00,24,80 BOX CHR(176)+CHR(176)+CHR(176)+CHR(176)+CHR(176)+;
			 CHR(176)+CHR(176)+CHR(176)+CHR(176)

       IF !lSistemas(08,26,@cNomApl,@PathSys,@cNomSis,;
		     @cEmpPal,@cNitEmp,@cNomEmp,@cCodEmp,@cPaises,@cNomDpt,;
		     @cNomMun,@cNomSec,@lShared,@nModCry,@nSysOpe,@cDerSys,;
		     @cPwdSis,@nPrueba,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
		     @cMaeAlu,@cJornad,@nPerHab,@cPwdIns)
	  cError('ERROR(L) INTERNO DEL SISTEMA')
	  CloseAll()
	  CLEAR
	  QUIT
       ENDIF
*>>>>FIN SELECCION DEL SISTEMA


*>>>>LECTURAS PARA PRUEBA DE PARAMETROS GENERALES
       CLEAR
       lShared := lPregunta('Sistema esta en Red? No Si')

       IF EMPTY(PathSys)

	  cJornad := 'DNMTA'
	  @ 21,01 SAY 'JORNADAS:' GET cJornad PICT '@!'
	  READ
	  cJornad := ALLTRIM(cJornad)
	*ÀJornadas de Estudio

	  cMaeAlu := 'JARPRIBTO'
	  @ 21,01 SAY 'MAESTROS:' GET cMaeAlu PICT '@!'
	  READ
	  cMaeAlu := ALLTRIM(cMaeAlu)
	*ÀMaestros habilitados

       ENDIF
*>>>>FIN LECTURAS PARA PRUEBA DE PARAMETROS GENERALES

*>>>>NOMBRE DEL SISTEMA
       cNomSis := 'SIMATOOL.'+cNomSis

       cTipSis := cVerSis+;
		  IF(lShared,' RED V'+NNETVER()+;
			     ' MULTI-',' MONO-')+'USUARIO: '
     *ÀVersi¢n del Sistema

*       KeySistema(lShared,cNomSis,aKeySis)
      *Control del sistema

       IniSistema(nModCry,lShared)
      *Inicializaci¢n del sistema
*>>>>FIN NOMBRE DEL SISTEMA

*>>>>DISE¥O PUBLICITARIO
       xClrSys := ''
       @ 00,00,24,80 BOX CHR(176)+CHR(176)+CHR(176)+CHR(176)+CHR(176)+;
			 CHR(176)+CHR(176)+CHR(176)+CHR(176)
       LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
*>>>>FIN DISE¥O PUBLICITARIO

*>>>>LECTURA DEL USUARIO
       cSavPan := SAVESCREEN(0,0,24,79)
       cDerech := cUsuario(lShared,PathSis,FileAaa,@cNomUsr,cPwdSis,lHayFec)
       IF cDerech == NIL .OR. !('1' $ SUBS(cDerech,1,100))
	  CloseAll()
	  QUIT
       ENDIF
*      cDerech := REPL('1',111)
*>>>>FIN LECTURA DEL USUARIO

*>>>>LECTURA DEL A¥O DEL USUARIO
       cAnoUsr := STR(YEAR(DATE()),4)
       @14,34 SAY "A¥O  :" GET cAnoUsr PICT "9999" ;
			   VALID VAL(cAnoUsr) <> 0
       READ
*>>>>FIN LECTURA DEL A¥O DEL USUARIO

*>>>>CREACION DEL PATH DEL SISTEMA
       cIniJor := cJornada(16,30,cJornad,@cJorTxt)
      *Lectura de las jornadas de estudio

       cPatSis := cAnoUsr+'.'+cIniJor
       cAnoSis := SUBS(cAnoUsr,3,2)

       cMaeAct := cNivelEst(16,30,cMaeAlu,@cNivTxt)
      *Lectura de los niveles de Estudio

*       Sistemas(16,30,@cNomApl)
      *Aplicaciones Activadas

       cTipSis := cNomApl+cTipSis
*>>>>FIN CREACION DEL PATH DEL SISTEMA

*>>>>REVISION DE LOS ARCHIVOS DEL SISTEMA
       RevisarDbf(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		  cNomEmp,cNomUsr,cAnoUsr,cPatSis,cSavPan,;
		  cMaeAlu,cMaeAct,cIniJor)

       RESTSCREEN(0,0,24,79,cSavPan)
*>>>>FIN REVISION DE LOS ARCHIVOS DEL SISTEMA

*>>>>ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA
       nOpcion := 1
       DO WHILE nOpcion # 0

**********SELEECION DEL MENU PRINCIPAL
	    aDeMenu := aMenuTools(0,SUBS(cDerech,101,10),@aHelp,cNomApl)
	      aMenu := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELEECION DEL MENU PRINCIPAL

**********CAMBIO DEL A¥O DEL SISTEMA
	    LineaEstado('<F2>CAMBIA A¥O. '+;
			'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)

	    cTitSup := cTipSis+ALLTRIM(cNomUsr)
	    cTitInf := 'A¥O: '+cAnoUsr+' '+cNivTxt+' JORNADA: '+cJorTxt
	  *ÀT¡tulos para el menu

	    nColAno := AT("A¥O: ",cTitInf)

	    SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
				     @cPatSis,cNomEmp,cNomSis)})
**********FIN CAMBIO DEL A¥O DEL SISTEMA

**********EJECUCION DEL MENU PRINCIPAL
	    nFilSup := 00
	    xColSup := aColOpc(aMenu,NIL,.T.)
	  *ÀCalculo coordenadas del men£

	    nOpcion := nMenu(aMenu,aHelp,nFilSup,xColSup,;
			     cTitSup,cTitInf,nOpcion)

	    cSavPan := SAVESCREEN(0,0,24,79)
**********FIN EJECUCION DEL MENU PRINCIPAL

**********ANALISIS PARA LA TERMINACION DEL PROGRAMA
	    IF nOpcion = 0
	       CLEAR
	       EXIT
	    ENDIF
	    nOpcPal := VAL(SUBS(aDeMenu[nOpcion],1,1))
	   *Opci¢n del men£ principal
**********FIN ANALISIS PARA LA TERMINACION DEL PROGRAMA

**********EJECUCION DE LAS OPCIONES
	    MenusTools(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,cNitEmp,;
		       cNomEmp,cNomSec,nOpcion,nOpcPal,nFilSup+2,xColSup,;
		       cNomUsr,cDerech,cAnoUsr,nColAno,cPatSis,;
		       cSavPan,cMaeAlu,cMaeAct,cJorTxt,cNomApl)
	    CloseAll()
**********FIN EJECUCION DE LAS OPCIONES

       ENDDO
       CloseAll()
       CLEAR
       QUIT
*>>>>FIN ESTRUCTURA DE CONTROL PRINCIPAL DEL PROGRAMA