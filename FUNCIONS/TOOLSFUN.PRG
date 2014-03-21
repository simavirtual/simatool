/*               	  SISTEMA DE CAFETERIA
		     BIBLIOTECAS DE FUNCIONES GENERALES

***************************************************************************
*-------------------- DECLARACION DE LAS FUNCIONES -----------------------*
**************************************************************************/

*>>>>DECLARACION DE CONSTANTES
       #INCLUDE "inkey.ch"                  // Declaraci¢n de teclas
*>>>>FIN DECLARACION DE CONSTANTES

/*************************************************************************
* TITULO..: INICIALIZACION PARAMETROS DE LA APLICACION                   *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Define por defecto los parametros de la aplicaci¢n

1- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION IniSistema(nModCry,lShared,nMemMin,nOpeFil)

*>>>>PARAMETROS DE LA FUNCION
/*     nModCry                              // Modo de Protecci¢n
       nMemMin                              // M¡nimo espacio en disco
       nOpeFil                              // M¡nimo archivos abiertos */
*>>>>PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL GetList := {}                  // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DE LOS PARAMETROS
       nMemMin := IF(nMemMin == NIL,1000000,nMemMin)
       nOpeFil := IF(nOpeFil == NIL,12,nOpeFil)
*>>>>VALIDACION DE LOS PARAMETROS

*>>>>DIRECTORIOS POR DEFECTO
       SET DEFAULT TO                       // Directorio por defecto
       SET PATH    TO                       // Path de Busqueda Auxiliar
*>>>>FIN DIRECTORIOS POR DEFECTO

*>>>>SETS PARA ENTRADA POR DEFECTO
       READEXIT(.T.)                        // Activa flechas salida Gest
       READINSERT(.T.)                      // Activa el modo de inserci¢n
       SET TYPEAHEAD  TO 10                 // Tama¤o del buffer de teclado
       SET ESCAPE     ON                    // Activa <ESC> salida GETS
       SET INTENSITY  ON                    // Activa intensidad Gets
       SET CONFIRM    ON                    // Confirmaci¢n salida Gets
       SET BELL       OFF                   // Activa sonido final Gets
       SET SCOREBOARD OFF                   // Desactiva Inf barra superior
       SET DELIMITERS OFF                   // Desactiva los delimitadores
       SET DELIMITERS TO                    // Delimitador campo por defecto
*>>>>FIN SETS PARA ENTRADA POR DEFECTO

*>>>>SETS PARA LOS PROCESOS POR DEFECTO
       SETCANCEL(.T.)                       // Abortar el programa
       SETCURSOR(1)                         // Activaci¢n del cursor
       SET DECIMALS    TO 2                 // Cifras decimales
       SET FIXED       ON                   // Decimales del SET DECIMALS
*>>>>FIN SETS PARA LOS PROCESOS POR DEFECTO

*>>>>SETS PARA SALIDA POR DEFECTO
       SET WRAP       ON                    // Men£s circulares
       SET CONSOLE    ON                    // Activaci¢n de la pantalla
       SET DEVICE     TO SCREEN             // La Pantalla por defecto
       SET MESSAGE    TO 22 CENTER          // Fila para mensajes
       SET MARGIN     TO 0                  // N£mero del margen
*      SET PRINTER TO SIMATOOL              // Archivo salida impresora
*      SET ALTERNATE  TO NELSON             // Archivo salida pantalla
       SET ALTERNATE  OFF                   // Desactiva el ARTERNATE
*>>>>FIN SETS PARA SALIDA POR DEFECTO

*>>>>SETS PARA BASES DE DATOS POR DEFECTO
       SET EXCLUSIVE  ON                    // Archivos no compartidos
       SET DELETED    ON                    // Ignorar registros borrados
       SET EXACT      OFF                   // Busqueda no exacta
       SET SOFTSEEK   OFF                   // Se ubica en el EOF() al buscar
       SET UNIQUE     OFF                   // Llaves de indices no £nicas
*>>>>FIN DESACTIVACION DE PROCEDIMIENTOS SET

*>>>>SETS GENERALES POR DEFECTO
       SETBLINK(.T.)                        // Activado el * como titilante
       SET COLOR       TO                   // Colores por defecto
       SET EPOCH       TO 2000              // A¤o base
       SET DATE        AMERICAN             // Formato de fecha amaricano
       SET DATE FORMAT "MM/DD/YY"           // Formato de fecha
       SET CENTURY     ON                   // OFF = 99 ON = 9999
*>>>>FIN SETS GENERALES POR DEFECTO

*>>>>ANALISIS DEL ESPACIO DISPONIBLE
       IF DISKSPACE() < nMemMin
	  IF cError('Presione "C" para Continuar',;
		    'HAY POCO ESPACIO DISPONIBLE EN EL DISCO',;
		    '<ESC> = Termina el Programa') <> 'C'
	     QUIT
	  ENDIF
       ENDIF
*>>>>FIN ANALISIS DEL ESPACIO DISPONIBLE

*>>>>ANALISIS DE LOS MANEJADORES DE DISCO DISPONIBLES
       IF FILESFREE() < nOpeFil
	  cError("Aumente la l¡nea FILES en su CONFIG.SYS"+;
		 " y rearranque el equipo",;
		 "Hay pocos Manejadores de Archivos disponibles = "+;
		 alltrim(Str(filesfree())),;
		 "Al presionar cualquier tecla se termina el programa")
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN ANALISIS DE LOS MANEJADORES DE DISCO DISPONIBLES

*>>>>ACTIVACION DE LA AYUDA
*       SETKEY(K_F1,{|A,B,C,D|;
*	      Ayuda(nModCry,A,B,C,D,,.T.)})
*>>>>FIN ACTIVACION DE LA AYUDA

*>>>>ASIGNACION DE FUNCIONES A LAS TECLAS
       SETKEY(K_ALT_A, {|| KEYSEND(" ", .T., .T.)})
       SETKEY(K_ALT_E, {|| KEYSEND("‚", .T., .T.)})
       SETKEY(K_ALT_I, {|| KEYSEND("¡", .T., .T.)})
       SETKEY(K_ALT_O, {|| KEYSEND("¢", .T., .T.)})
       SETKEY(K_ALT_U, {|| KEYSEND("£", .T., .T.)})
       SETKEY(K_ALT_N, {|| KEYSEND("¤", .T., .T.)})
       SETKEY(K_ALT_M, {|| KEYSEND("¥", .T., .T.)})
       SETPOS(24, 0)
       CloseAll()
       RETURN NIL
*>>>>FIN ASIGNACION DE FUNCIONES A LAS TECLAS

/*************************************************************************
* TITULO..: CREACION DE LOS ARCHIVOS DEL SISTEMAS                        *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2002 VIE A
       Colombia, Bucaramanga        INICIO: 01:00 PM   AGO 16/2002 VIE

OBJETIVOS:

1- Crea el directorio de la aplicaci¢n para el a¤o especificado si
   no existe.

2- Crea las estructuras de los archivos de la aplicaci¢n en caso de no
   existir.

3- Recupera las estructuras de los archivos de la aplicaci¢n en caso
   de p‚rdida.

4- Indexa los archivos de la aplicaci¢n en caso de no existir

5- Retorna Nil

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION RevisarDbf(lShared,nModCry,cNomSis,cEmpPal,cNitEmp,;
		    cNomEmp,cNomUsr,cAnoUsr,cPatSis,cSavPan,;
		    cMaeAlu,cMaeAct,cIniJor)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Archivos Compartidos
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Empresa principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomUsr                              // Nombre del usuario
       cAnoUsr			            // A¤o del usuario
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro Activado
       cIniJor                              // Iniciales de la jornada */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL cAnoSis := SUBS(cAnoUsr,3,2)   // A¤o del sistema
       LOCAL PathAct := ''                  // Path Actual

       LOCAL lPrnArc := .F.                 // .T. Imprimir en Archivo
       LOCAL lHayErr := .T.                 // .T. Hay Error
       LOCAL lndexar := .F.                 // .T. Indexar Archivos
*>>>>FIN DECLARACION DE VARIABLES

*>>>>VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS
       IF nModCry # 0 .AND. lShared
	  cError('LA APLICACION NO PUEDE SER MULTIUSUARIO')
	  CloseAll()
	  QUIT
       ENDIF
*>>>>FIN VALIDACION DEL MODO DE APERTURA DE LOS ARCHIVOS

*>>>>VERIFICACION O CREACION DEL DIRECTORIO FILEWWW
       PathAct := DIRNAME()
       DO CASE
       CASE DIRCHANGE ('FILEWWW') == 0
	    DIRCHANGE(PathAct)

       CASE DIRCHANGE ('FILEWWW') == -5
	    cError("NO HAY DERECHOS EN EL DIRECTORIO "+cPatSis)
	    QUIT

       CASE DIRCHANGE('FILEWWW') == -3
	    DIRMAKE('FILEWWW')
       ENDCASE
*>>>>FIN VERIFICACION O CREACION DEL DIRECTORIO FILEWWW

*>>>>CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA
       SET CURSOR OFF
       DO CASE
       CASE !FILE(PathSis+'\'+fErrSys) .AND.;
	    !FILE(PathSis+'\'+fSimTol) .AND.;
	    !FILE(PathSis+'\'+FileClr) .AND.;
	    !FILE(PathSis+'\'+FilePrn)

	    RESTSCREEN(0,0,24,79,cSavPan)
	    CreaDbfSys(lShared,nModCry)
       OTHERWISE

************RECUPERACION DE ESTRUCTURAS GENERALES
	      IF !FILE(PathSis+'\'+fSimTol)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuSimTol(lShared,nModCry,PathSis,fSimTol)
	      ENDIF

	      IF !FILE(PathSis+'\'+fErrSys)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuErrSys(lShared,nModCry,PathSis,fErrSys)
	      ENDIF

	      IF !FILE(PathSis+'\'+FilePrn)
		 RESTSCREEN(0,0,24,79,cSavPan)
		 RecuDbfPrn(lShared,nModCry,PathSis,FilePrn)
	      ENDIF
************FIN RECUPERACION DE ESTRUCTURAS GENERALES

       ENDCASE
*>>>>FIN CREACION DE LAS ESTRUCTURAS GENERALES DEL SISTEMA

*>>>>ACTUALIZACION DE ESTRUCTURAS
       SET EXACT      ON                    // Busqueda Exacta
       nActStrErr(lShared,nModCry,PathSis,fErrSys)
     *ÀActualizaci¢n de los Errores del Sistema

       nActStrPrn(lShared,nModCry,PathSis,FilePrn)
     *ÀActualizaci¢n de Archivos de Impresora

       nActStrTol(lShared,nModCry,PathSis,fSimTol)
     *ÀActualizaci¢n de Configuraci¢n General

       SET EXACT      OFF                   // Busqueda no exacta
*>>>>FIN ACTUALIZACION DE ESTRUCTURAS

*>>>>SELECION DE LAS AREAS DE TRABAJO
       lPrnArc := .F.
       IF !lUseDbf(.T.,PathSis+'\'+fSimTol,'TOL',NIL,lShared,nModCry)
	  CloseDbf('TOL',PathSis+'\'+fSimTol,nModCry)
       ENDIF
*>>>>FIN SELECION DE LAS AREAS DE TRABAJO

*>>>>VALIDACION DE CONTENIDOS DE ARCHIVOS
       lHayErr := .T.
       DO CASE
       CASE TOL->(RECCOUNT()) == 0
	    cError('NO EXISTE CONFIGURACION GENERAL PARA EL SISTEMA')
       OTHERWISE
	    lHayErr :=.F.
       ENDCASE
       lPrnArc := TOL->lPrnArcTol
       CloseDbf('TOL',PathSis+'\'+fSimTol,nModCry)
*>>>>FIN VALIDACION DE CONTENIDOS DE ARCHIVOS

*>>>>ACTIVACION DEL DISPOSITIVO DE IMPRESION
       IF lPrnArc
	  SET PRINTER TO SIMATOOL              // Impresion en Archivo.
       ELSE
	  SET PRINTER TO                       // Impresion en la impresora.
       ENDIF
       RETURN NIL
*>>>>FIN ACTIVACION DEL DISPOSITIVO DE IMPRESION

/*************************************************************************
* TITULO..: CREACION ARCHIVOS GENERALES DEL SISTEMA                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 16/2002 VIE A
       Colombia, Bucaramanga        INICIO: 03:00 PM   AGO 16/2002 VIE

OBJETIVOS:

1)- Crea todos los archivos generales del sistema

2)- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION CreaDbfSys(lShared,nModCry)

*>>>>PARAMETROS DE LA FUNCION
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL cSavPan := ''                  // Salvar Pantalla
*>>>>FIN DECLARACION DE VARIABLES

*>>>>CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA
       cSavPan := SAVESCREEN(0,0,24,79)
       Termometro(0,"CREANDO ARCHIVOS GENERALES DEL SISTEMA")

       Termometro(50)
       CreaErrSys(lShared,nModCry,PathSis,fErrSys)

       Termometro(60)
       CreaDbfClr(lShared,nModCry,PathSis,FileClr)

       Termometro(75)
       CreaDbfPrn(lShared,nModCry,PathSis,FilePrn)

       Termometro(100)
       CreaSimTol(lShared,nModCry,PathSis,fSimTol)

       RESTSCREEN(0,0,24,79,cSavPan)
       RETURN NIL
*>>>>FIN CREACION DE ESTRUCTURAS GENERALES DEL SISTEMA

/*************************************************************************
* TITULO..: DEFINICION DE LOS MENUS DE LA APLICACION                     *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 06:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Define todos los men£s de la aplicaci¢n

2- Permite escoger un men£ de acuerdo a la opci¢n elegida.

3- Permite seleccionar cada una de las opciones a las cuales tiene
   derecho el usuario.

4- Retorna por referencia los param‚tros de la funci¢n marcados con @

5- Retorna el vector con el men£ escogida de acuerdo a la opci¢n

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION aMenuTools(nNroOpc,cDerech,aAyudas,cNomApl)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroOpc			            // N£mero de Opci¢n
       cDerech                              // Derechos a los Menus
       aAyudas                              // @Vector de Ayudas escogidas
       cNomApl                              // Nombre de la Aplicaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       LOCAL aMenus  := {}                    // Declaraci¢n de Men£s
       LOCAL aAyuda  := {}                    // Declaraci¢n de Ayudas
       LOCAL aMenuss := {}                    // Men£ escogido
       LOCAL     i,j := 0                     // Contadores
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DECLARACION DEL MENUS
       DO CASE
       CASE nNroOpc == 0

************MENU PRINCIPAL
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SISTEMA DE MATRICULA ACADEMICA
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN SISTEMA DE MATRICULA ACADEMICA

	      CASE cNomApl == 'SIMACONT'

*------------------CONTABILIDAD ACADEMICA
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN CONTABILIDAD ACADEMICA

	      CASE cNomApl == 'SIMAPROF'

*------------------CONTABILIDAD PROFESORES
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN CONTABILIDAD PROFESORES

	      CASE cNomApl == 'SIMACART'

*------------------CARTERA ACADEMICA
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN CARTERA ACADEMICA

	      CASE cNomApl == 'SIMACAFE'

*------------------CAFETERIA ACADEMICA
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN CAFETERIA ACADEMICA

	      CASE cNomApl == 'SIMATOOL'

*------------------SIMATOOL
		     AADD(aMenus,'1PROCESOS')
		     AADD(aMenus,'2ACTUALIZAR')
		     AADD(aMenus,'3CONSULTAS')
		     AADD(aMenus,'4INFORMES')
		     AADD(aMenus,'5ARCHIVOS')
		     AADD(aMenus,'6ESTRUCTURAS')
		     AADD(aMenus,'7UTILIDADES')

		     AADD(aAyuda,'Procesos')
		     AADD(aAyuda,'Actualizar')
		     AADD(aAyuda,'Consultas')
		     AADD(aAyuda,'Informes')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con los Archivos del Sistema')
		     AADD(aAyuda,'Permite Realizar Procesos '+;
				 'con las Estructuras de los Archivos')
		     AADD(aAyuda,'Utilidades')
*------------------FIN SIMATOOL

	      ENDCASE
************FIN MENU PRINCIPAL DE LOS SISTEMAS

       CASE nNroOpc == 1

************SUBMENU No. 1
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU PROCESOS

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN MENU PROCESOS

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU PROCESOS

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN MENU PROCESOS

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU PROCESOS

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU PROCESOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU PROCESOS

	      ENDCASE
************FIN SUBMENU No. 1

       CASE nNroOpc == 2

************SUBMENU No. 2
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<FIJAR GRUPOS         >')
		     AADD(aAyuda,'Fija Grupos a Restaurate,Transporte,Etc')
		     AADD(aMenus,'2<ACTULIZAR INFORMACION>')
		     AADD(aAyuda,'Actualiza la Informaci¢n del Restaurate,Transporte,Etc')
*------------------FIN SUBMENU ACTUALIZAR

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<CODIGOS RECUPERACIONES    >')
		     AADD(aAyuda,'Actualiza los C¢digos para '+;
				 'las Recuperaciones')

		     AADD(aMenus,'2<MAEIMPORT.DAT ACTUALIZAR  >')
		     AADD(aAyuda,'Actualiza los registros para permitir la actualizaci¢n de los estudiantes')

		     AADD(aMenus,'3<MAEIMPORT.DAT CONTRATANTES>')
		     AADD(aAyuda,'Actualiza los contratantes con inconsistencias')

		     AADD(aMenus,'4<ACTUALIZAR INF MAESTROS   >')
		     AADD(aAyuda,'Permite actualizar la informaci¢n de los estudiantes')

		     AADD(aMenus,'5<INCLUIR PER ESTUDIANTES   >')
		     AADD(aAyuda,'Permite incluir las personas relacionadas con las personas')

		     AADD(aMenus,'6<MAEALU.DAT ACTUALIZAR     >')
		     AADD(aAyuda,'Permite incluir los estudiantes de los maetros de todos los a¤os')

		     AADD(aMenus,'7<MAEARCHI.DAT ACTUALIZAR   >')
		     AADD(aAyuda,'Permite incluir los estudiantes de los maetros de todos los a¤os sin duplicar estudiantes')

		     AADD(aMenus,'8<VALIDAR MAEA¥O VS MAEIMPOR>')
		     AADD(aAyuda,'Permite validar los estudiantes del sistema vs Estudiantes otro sistema')

		     AADD(aMenus,'9<VALIDAR MAEA¥O EXTERNO    >')
		     AADD(aAyuda,'Permite validar los estudiantes del sistema vs Estudiantes otro sistema')
*------------------FIN SUBMENU ACTUALIZAR

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ACTUALIZAR

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<CREAR LOS PAGOS>')
		     AADD(aMenus,'2<FIJAR GRUPOS   >')

		     AADD(aAyuda,'Crer los pagos')
		     AADD(aAyuda,'Fijar los grupos')
*------------------SUBMENU ACTUALIZAR

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ACTUALIZAR

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU ACTUALIZAR
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------SUBMENU ACTUALIZAR

	      ENDCASE
************FIN SUBMENU No. 2

       CASE nNroOpc == 3

************SUBMENU No. 3
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<SUBDIVISION OBSERVACIONES>')
		     AADD(aMenus,'2<TIPO DE OBSERVACIONES    >')
		     AADD(aAyuda,'SubDivision de las Observaciones de los Estudiantes')
		     AADD(aAyuda,'Tipos de Observaciones de los Estudiantes')
*------------------FIN SUBMENU CONSULTAS

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<MAEIMPOR>')
		     AADD(aAyuda,'Consulta el archivo de Importaci¢n')
*------------------FIN SUBMENU CONSULTAS

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU CONSULTAS

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU CONSULTAS

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------SUBMENU CONSULTAS

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU CONSULTAS
		     AADD(aMenus,'1<TEMP>')
		     AADD(aAyuda,'Consulta Temp')
*------------------FIN SUBMENU CONSULTAS

	      ENDCASE
************FIN SUBMENU No. 3

       CASE nNroOpc == 4

************SUBMENU No. 4
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU INFORMES

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<CODIGOS INDICADORES>')
		     AADD(aAyuda,'Imprime los C¢digos de los '+;
				 'Indicadores de Cada Materia')

		     AADD(aMenus,'2<EXPORTAR ALUMNOS   >')
		     AADD(aAyuda,'Exporta los estudiantes')
*------------------FIN SUBMENU INFORMES

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU INFORMES

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<DIAN POR DOCUMENTO>')
		     AADD(aMenus,'2<DIAN POR CONCEPTOS>')
		     AADD(aMenus,'3<DIAN POR CODIGO   >')

		     AADD(aAyuda,'Informes de la Dian')
		     AADD(aAyuda,'Informes de la Dian Descriminado por Conceptos')
		     AADD(aAyuda,'Informes de la Dian')
*------------------FIN SUBMENU INFORMES

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU INFORMES

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU INFORMES
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU INFORMES

	      ENDCASE
************FIN SUBMENU No. 4

       CASE nNroOpc == 5

************SUBMENU No. 5
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ARCHIVOS

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<CONSULTAR NOTAS >')
		     AADD(aMenus,'2<RENOMBRAR FOTOS >')
		     AADD(aMenus,'3<REVISAR FOTOS   >')
		     AADD(aMenus,'4<FOTOS POR GRUPOS>')
		     AADD(aMenus,'5<ASIGNAR SALONES >')
		     AADD(aMenus,'6<FORMATO APT     >')

		     AADD(aAyuda,'Permite Consultar los Registros '+;
				 'de los Archivos de Notas')
		     AADD(aAyuda,'Permite renombrar los archivos de las fotos.')
		     AADD(aAyuda,'Permite revisar los archivos de las fotos.')
		     AADD(aAyuda,'Permite copiar las fotos por grupos.')
		     AADD(aAyuda,'Permite asignar salones aleatoriamente.')
		     AADD(aAyuda,'Permite un archivo en formato APT.')
*------------------SUBMENU ARCHIVOS

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ARCHIVOS

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ARCHIVOS

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ARCHIVOS

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU ARCHIVOS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ARCHIVOS

	      ENDCASE
************FIN SUBMENU No. 5

       CASE nNroOpc == 6

************SUBMENU No. 6
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ESTRUCTURAS

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<ACTUALIZAR NOTAS>')
		     AADD(aMenus,'2<ESTRUCTURA NOTAS>')

		     AADD(aAyuda,'Lee las Notas de los directorios BACKUPS a NOTAS')
		     AADD(aAyuda,'Visualiza la Estructura del Archivo Notas')
*------------------FIN SUBMENU ESTRUCTURAS

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ESTRUCTURAS

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<ACTUALIZAR CLIENTES>')
		     AADD(aMenus,'2<ACTUALIZAR PAGOS   >')
		     AADD(aMenus,'3<COPIAR CLIENTES    >')

		     AADD(aAyuda,'Actualiza la Estructura de '+;
				 'los Archivos de Clientes')
		     AADD(aAyuda,'Actualiza la Estructura de '+;
				 'los Archivos de Pagos')
		     AADD(aAyuda,'Permite copiar los Clientes')
*------------------FIN SUBMENU ESTRUCTURAS

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ESTRUCTURAS

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU ESTRUCTURAS
		     AADD(aMenus,'1<PENDIENTE>')
		     AADD(aAyuda,'Pendiente')
*------------------FIN SUBMENU ESTRUCTURAS

	      ENDCASE
************FIN SUBMENU No. 6

       CASE nNroOpc == 7

************SUBMENU No. 7
	      DO CASE
	      CASE cNomApl == 'SIMAMATR'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      CASE cNomApl == 'SIMACONT'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      CASE cNomApl == 'SIMAPROF'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      CASE cNomApl == 'SIMACART'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      CASE cNomApl == 'SIMACAFE'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      CASE cNomApl == 'SIMATOOL'

*------------------SUBMENU UTILIDADES
		     AADD(aMenus,'1<USUARIOS      >')
		     AADD(aMenus,'2<CAMBIAR CLAVE >')
		     AADD(aMenus,'3<REINDEXAR     >')
		     AADD(aMenus,'4<INTEGRIDAD    >')
		     AADD(aMenus,'5<EJECUTAR      >')
		     AADD(aMenus,'6<ACTUALIZAR    >')
		     AADD(aMenus,'7<MANTENIMIENTO >')
		     AADD(aMenus,'8<CONFIGURACION >')
		     AADD(aMenus,'9<VARIOS        >')

		     AADD(aAyuda,'Permite Crear usuarios y Asignar sus derechos.')
		     AADD(aAyuda,'Permite cambiar la clave. ')
		     AADD(aAyuda,'Reindexa los archivos del Sistema.')
		     AADD(aAyuda,'Elimina los registros marcados como borrados.')
		     AADD(aAyuda,'Permite Ejecutar un programa Externo.')
		     AADD(aAyuda,'Permite Actualizar las estructuras de los Archivos del Sistema')
		     AADD(aAyuda,'Permite el Mantenimiento de los Archivos del Sistema')
		     AADD(aAyuda,'Permite definir las diferentes Configuraciones del Sistema')
		     AADD(aAyuda,'Men£ con otros procesos utilitarios del Sistema')
*------------------FIN SUBMENU UTILIDADES

	      ENDCASE
************FIN SUBMENU No. 7

       ENDCASE
*>>>>FIN DECLARACION DEL MENUS

*>>>>SELECCION DEL MENU
       FOR i:= 1 TO LEN(aMenus)
	   IF VAL(SUBS(cDerech,i,1)) == 1
	      j++
	      AADD(aMenuss,j)
	      AADD(aAyudas,j)
	      aMenuss[j] := aMenus[i]
	      aAyudas[j] := aAyuda[i]
	   ENDIF
       NEXT
       RETURN aMenuss
*>>>>FIN SELECCION DEL MENU

/*************************************************************************
* TITULO..: EJECUCION MENUS PRIMER NIVEL                                 *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 06:30 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Ejecuta todas las funciones del primer nivel del sistema

2- Retorna NIL

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION MenusTools(lShared,nModCry,cNomSis,cCodEmp,cEmpPal,;
		    cNitEmp,cNomEmp,cNomSec,nOpcion,nOpcPal,;
		    nFilPal,aColSup,cNomUsr,cDerech,cAnoUsr,;
		    nColAno,cPatSis,cSavPan,cMaeAlu,cMaeAct,;
		    cJorTxt,cNomApl)

*>>>>DESCRIPCION DE PARAMETROS
/*     lShared                              // .T. Sistema Compartido
       nModCry                              // Modo de Protecci¢n
       cNomSis                              // Nombre del Sistema
       cCodEmp                              // C¢digo de la Empresa
       nOpcion                              // Opci¢n del Men£ Principal
       nOpcPal                              // Opci¢n ejecutar Menu Principal
       nFilPal                              // Fila Inferior Men£ principal
       aColSup                              // Columnas para los sub_men£s
       cEmpPal                              // Nombre de la Empresa Principal
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cNomSis                              // Nombre del Sistema
       cNomUsr                              // Nombre del Usuario
       cDerech                              // Derechos en el sistema
       cAnoUsr				    // A¤o del Sistema
       nColAno                              // Columna A¤o del sistema
       cPatSis                              // Path del sistema
       cSavPan                              // Salvar Pantalla
       cMaeAlu                              // Maestros habilitados
       cMaeAct                              // Maestro habilitado
       cJorTxt                              // Jornada escogida
       cNomApl                              // Nombre del Aplicaci¢n */
*>>>>FIN DESCRIPCION DE PARAMETROS

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL lSiMenu := .T.                 //.T.Opci¢n principal con SubMen£
       LOCAL cSavLin := ''                  // Salvar lineas
       LOCAL aDeMenu := {}                  // Declaraci¢n de Men£s
       LOCAL aMenu   := {}                  // Men£ Preparado
       LOCAL aHelp   := {}                  // Ayudas para el men£
       LOCAL nNroOpc := 1                   // Numero de la opci¢n
       LOCAL nLenOpc := 0                   // Longitud mayor de los opciones

       LOCAL nFilSup := 0                   // Fila Superior del Sub_men£
       LOCAL nColSup := 0                   // Columa Superior del Sub_men£
       LOCAL nFilInf := 0                   // Fila Inferior del Sub_men£
       LOCAL nColInf := 0                   // Columna Inferior del Sub_men£
       LOCAL       i := 0                   // Contador

       LOCAL Getlist                        // Variable del sistema
*>>>>FIN DECLARACION DE VARIABLES

*>>>>DESARROLLO DEL PRIMER NIVEL
       DO WHILE .T.

**********SELECCION DE LOS SUBMENUS
	    CLOSE ALL
	    lSiMenu := .T.
	    aDeMenu := aMenuTools(nOpcPal,;
				  SUBS(cDerech,nOpcPal*10-9,10),;
				  @aHelp,cNomApl)
	    aMenu := {}
	    FOR i:= 1 TO LEN(aDeMenu)
		AADD(aMenu,i)
		aMenu[i] := STR(i,1)+SUBS(aDeMenu[i],2,LEN(aDeMenu[i]))
	    NEXT
**********FIN SELECCION DE LOS SUBMENUS

**********ANALISIS DEL LIMITE DE LA ULTIMA COLUMNA
	    IF lSiMenu

	       ASCAN(aMenu, {|str| nLenOpc := MAX(nLenOpc,LEN(str))})
	      *Longitud mayor de las opciones

	       IF aColSup[nOpcion] + nLenOpc + 2 > 78
		  aColSup[nOpcion] := 78-nLenOpc-1
	       ENDIF
	    ENDIF
**********FIN ANALISIS DEL LIMITE DE LA ULTIMA COLUMNA

**********EJECUCION DE LOS SUBMENUS
	    IF lSiMenu

	       nFilSup := nFilPal+1
	       nColSup := aColSup[nOpcion]
	     *ÀCalculo coordenadas del men£

*--------------CAMBIA EL A¥O DEL SISTEMA
		 LineaEstado('<F2>CAMBIA A¥O. '+;
			     'LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
		 SETKEY(K_F2,{||LeeAnoSys(nColAno,@cAnoUsr,;
					  @cPatSis,cNomEmp,cNomSis)})
*--------------FIN CAMBIA EL A¥O DEL SISTEMA

	       nNroOpc := nMenu(aMenu,aHelp,;
				nFilSup,nColSup,NIL,NIL,nNroOpc,NIL)

	       SETKEY(K_F2,NIL)
	       lSiMenu := .T.

	    ENDIF

	    IF nNroOpc == 0
	       EXIT
	    ENDIF
	    nNroOpc := VAL(SUBS(aDeMenu[nNroOpc],1,1))
	    cSavLin := SAVESCREEN(0,0,02,79)
	    LineaEstado('LICENCIA DE USO A FAVOR DE: '+cNomEmp,cNomSis)
**********FIN EJECUCION DE LOS SUBMENUS

**********ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL
	    nFilInf := nFilSup + LEN(aMenu) + 1
	    nColInf := aColSup[nOpcion]
	    DO CASE
	    CASE nOpcPal == 1

*----------------OPCION SUBMENU No. 1
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION PROCESOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2

			  ENDCASE
*.......................FIN OPCION PROCESOS

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 1

	    CASE nOpcPal == 2

*----------------OPCION SUBMENU No. 2
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1

			       Tool2_201(lShared,nModCry,cNomSis,cCodEmp,;
					 cEmpPal,cNitEmp,cNomEmp,cNomSec,;
					 nFilInf,nColInf,nFilPal,cNomUsr,;
					 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
					 cJorTxt)
			      *Fijar Grupos a Otros Servicios.

			  CASE nNroOpc == 2

			       Tool2_202(lShared,nModCry,cNomSis,cCodEmp,;
					 cEmpPal,cNitEmp,cNomEmp,cNomSec,;
					 nFilInf,nColInf,nFilPal,cNomUsr,;
					 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
					 cJorTxt)
			      *Actualizar Informaci¢n a Otros Servicios.

			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1
			       Tool1_201(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Actualizar Estructuras

			  CASE nNroOpc == 2
			       Tool1_202(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *MaeImpor

			  CASE nNroOpc == 3
			       Tool1_203(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *MaeImpor Contratantes

			  CASE nNroOpc == 4

			       Tool1_204(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Actualizar Inf Mae

			  CASE nNroOpc == 5
			       Tool1_205(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Incluir Personas Estudiantes

			  CASE nNroOpc == 6
			       Tool1_206(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Incluir Alumnos de todos los a¤os.

			  CASE nNroOpc == 7
			       Tool1_207(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Incluir Alumnos de todos los a¤os sin repetir estudiantes.

			  CASE nNroOpc == 8
			       Tool1_208(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *MAEA¥O VS MAEIMPOR.

			  CASE nNroOpc == 9
			       Tool1_209(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *MAEA¥O VS SISTEMA EXTERNO.

			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   CASE cNomApl == 'SIMACART'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1
			       Tool4_201(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Crear pagos

			  CASE nNroOpc == 2
			       Tool4_202(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Fijar Grupos

			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION ACTUALIZAR
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ACTUALIZAR

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 2

	    CASE nOpcPal == 3

*----------------OPCION SUBMENU No. 3
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool2_301(lShared,nModCry,cNomSis,cCodEmp,;
					 cEmpPal,cNitEmp,cNomEmp,cNomSec,;
					 nFilInf,nColInf,nFilPal,cNomUsr,;
					 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
					 cJorTxt)
			      *SubDivisi¢n de Observaciones

			  CASE nNroOpc == 2

			       Tool2_302(lShared,nModCry,cNomSis,cCodEmp,;
					 cEmpPal,cNitEmp,cNomEmp,cNomSec,;
					 nFilInf,nColInf,nFilPal,cNomUsr,;
					 cAnoUsr,cPatSis,cMaeAlu,cMaeAct,;
					 cJorTxt)
			      *Tipo de Observaciones

			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool1_301(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Consulta del MaeImpor


			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   CASE cNomApl == 'SIMACART'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION CONSULTAS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool6_301(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Consulta Temp
			  CASE nNroOpc == 2
			  CASE nNroOpc == 3
			  ENDCASE
*.......................FIN OPCION CONSULTAS

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 3

	    CASE nOpcPal == 4

*----------------OPCION SUBMENU No. 4
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION INFORMES

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			       Tool1_401(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Codigos Indicadores

			  CASE nNroOpc == 2
			       Tool1_402(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Exportar al School Pack
			  ENDCASE
*.......................FIN OPCION INFORMES

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION INFORMES

		   CASE cNomApl == 'SIMACART'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			       Tool4_401(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Dian por documento

			  CASE nNroOpc == 2
			       Tool4_402(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Dian por Conceptos

			  CASE nNroOpc == 3
			       Tool4_403(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Dian por codigo

			  ENDCASE
*.......................FIN OPCION INFORMES

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION INFORMES

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION INFORMES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION INFORMES

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 4

	    CASE nOpcPal == 5

*----------------OPCION SUBMENU No. 5
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool1_501(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Consultar Notas

			  CASE nNroOpc == 2

			       Tool1_502(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Renombrar Fotos

			  CASE nNroOpc == 3

			       Tool1_503(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Revisar Fotos

			  CASE nNroOpc == 4

			       Tool1_504(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Fotos por Grupos

			  CASE nNroOpc == 5

			       Tool1_505(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Asignar salones

			  CASE nNroOpc == 6

			       Tool1_506(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Generar formato APT


			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   CASE cNomApl == 'SIMACART'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION ARCHIVOS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ARCHIVOS

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 5

	    CASE nOpcPal == 6

*----------------OPCION SUBMENU No. 6
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool1_601(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Lectura Backups No. 1

			  CASE nNroOpc == 2
			       Tool1_602(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Estructura Notas

			  CASE nNroOpc == 3
			       Tool1_603(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Lectura Backups No. 2

			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   CASE cNomApl == 'SIMACART'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			       Tool4_601(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Actualizar Clientes

			  CASE nNroOpc == 2
			       Tool4_602(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Actualizar Pagos

			  CASE nNroOpc == 3
			       Tool4_603(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			      *Copiar Clientes

			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION ESTRUCTURAS
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION ESTRUCTURAS

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 6

	    CASE nOpcPal == 7

*----------------OPCION SUBMENU No. 7
		   DO CASE
		   CASE cNomApl == 'SIMAMATR'

*.......................OPCION UTILIDEDES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   CASE cNomApl == 'SIMACONT'

*.......................OPCION UTILIDADES
			  DO CASE
			  CASE nNroOpc == 1
			       MantenUsr(lShared,PathSis,FileAaa,;
					 {|nOpcion,aAyudas|;
					   aMenuTools(nOpcion,;
					   '1111111111',aAyudas,cNomApl)},;
					 cNomSis)
			      *Usuarios

			  CASE nNroOpc == 2
			       CamPasWor(lShared,nFilInf+1,aColSup[nOpcion],;
					 PathSis,FileAaa,cNomUsr)
			      *Cambiar Clave

			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   CASE cNomApl == 'SIMAPROF'

*.......................OPCION UTILIDEDES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   CASE cNomApl == 'SIMACART'

*.......................OPCION UTILIDEDES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   CASE cNomApl == 'SIMACAFE'

*.......................OPCION UTILIDEDES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 2
			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   CASE cNomApl == 'SIMATOOL'

*.......................OPCION UTILIDEDES
			  DO CASE
			  CASE nNroOpc == 1
			  CASE nNroOpc == 8
			       Tools_708(lShared,nModCry,cNomSis,cEmpPal,;
					 cNitEmp,cNomEmp,nFilInf,nColInf,;
					 nFilPal,cNomUsr,cAnoUsr,cPatSis,;
					 cMaeAlu,cMaeAct,cJorTxt)
			     *Configuraciones
			  ENDCASE
*.......................FIN OPCION UTILIDADES

		   ENDCASE
*----------------FIN OPCION SUBMENU No. 7

	    ENDCASE
	    RESTSCREEN(0,0,24,79,cSavPan)
	    RESTSCREEN(0,0,02,79,cSavLin)
	    CloseAll()
**********FIN ANALISIS DE LA OPCION ESGODIDA DEL PRIMER NIVEL

       ENDDO
       CloseAll()
       RETURN NIL
*>>>>FIN DESARROLLO DEL PRIMER NIVEL

/*************************************************************************
* TITULO..: SISTEMAS HABILITADOS                                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: AGO 14/2002 MIE A
       Colombia, Bucaramanga        INICIO: 07:00 PM   AGO 14/2002 MIE

OBJETIVOS:

1)- Retorna por referencia los param‚tros de la funci¢n marcados con @

2)- Permite escoger la jornada de estudio

3)- Retorna las tres iniciales de la jornada

SINTAXIS:

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

FUNCTION lSistemas(nNroFil,nNroCol,cNomApl,cPatSys,cNomSis,;
		   cEmpPal,cNitEmp,cNomEmp,cCodEmp,cPaises,cNomDpt,cNomMun,;
		   cNomSec,lShared,nModCry,nSysOpe,cDerSys,cPwdSis,nPrueba,;
		   cAnoHab,cMesHab,cPwdHar,lPiePag,cMaeAlu,cJornad,nPerHab,;
		   cPwdIns)

*>>>>PARAMETROS DE LA FUNCION
/*     nNroFil                              // N£mero de la fila
       nNroCol                              // N£mero de la columna
       cNomApl				    // @Nombre de la Aplicaci¢n o Sistema
       cPatSys			            // Path del Sistema
       cNomSis                              // Nombre del Sistema
       cEmpPal                              // Nombre de la Comunidad
       cNitEmp                              // Nit de la Empresa
       cNomEmp                              // Nombre de la Empresa
       cCodEmp                              // C¢digo de la Empresa
       cPaises                              // Nombre del Pais
       cNomDpt                              // Nombre del Departamento
       cNomMun                              // Nombre del Municipio
       cNomSec                              // Nombre Secundario
       lShared                              // .T. Sistema Compartido
       nModCry                              // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       nSysOpe                              // Sistema Operativo 0=>Windows 1=>Novell 2=>Linux
       cDerSys                              // Derechos del Sistema
       cPwdSis			            // PassWord Creaci¢n usuarios
       nPrueba                              // 0=>Licencia Activa 1=>Licencia de Prueba 3=>Licencia de Prueba Abierta 4=>Demo
       cAnoHab                              // A¤o Habilitado
       cMesHab                              // Mes Habilitado
       cPwdHar			            // Serial del HardWare
       cMaeAlu                              // Maestros habilitados
       cJornad                              // Jornadas habilitadas
       nPerHab                              // Periodo Habilitado
       cPwdIns			            // Serial de Instalaci¢n */
*>>>>FIN PARAMETROS DE LA FUNCION

*>>>>DECLARACION DE VARIABLES
       #INCLUDE "CAMPOS\ARC-TOOL.PRG"       // Archivos del Sistema

       LOCAL PathMtr := ''                  // Path de la Matr¡cula
       LOCAL PathCon := ''                  // Path de la Contabilidad
       LOCAL PathPro := ''                  // Path de la Contabilidad Profesores
       LOCAL PathCar := ''                  // Path de la Cartera
       LOCAL PathVot := ''                  // Path de la Votaci¢n
       LOCAL PathCaf := ''                  // Path de la Cafeteria

       LOCAL FileDat := ''                  // Archivo de Datos del Sistema
       LOCAL cSavPan := ''                  // Salvar Pantalla
       LOCAL aMenus  := {}                  // Declaracion de Menus
       LOCAL aPatSis := {}                  // Path del Sistema
       LOCAL aNomApl := {}                  // Nombre Sistema
       LOCAL aFilDat := {}                  // Archivo de Datos
       LOCAL nNroOpc := 1                   // N£mero de Opci¢n
       LOCAL       i := 1                   // Contador
*>>>>FIN DECLARACION DE VARIABLES

*>>>>LECTURA DE PATHS
       PathTool(lShared,nModCry,;
		@PathMtr,@PathCon,@PathPro,@PathCar,@PathVot,@PathCaf)
*>>>>FIN LECTURA DE PATHS

*>>>>SELECCION DE LA JORNADA
       IF FILE(PathMtr+'\'+PathSis+'\'+'DATO0101'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE MATRICULAS'
	  AADD(aNomApl,'SIMAMATR')
	  AADD(aPatSis,PathMtr)
	  AADD(aFilDat,PathMtr+'\'+PathSis+'\'+'DATO0101'+ExtFile)
       ENDIF

       IF FILE(PathCon+'\'+PathSis+'\'+'DATO0102'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE CONTABILIDAD'
	  AADD(aNomApl,'SIMACONT')
	  AADD(aPatSis,PathCon)
	  AADD(aFilDat,PathCon+'\'+PathSis+'\'+'DATO0102'+ExtFile)
       ENDIF

       IF FILE(PathPro+'\'+PathSis+'\'+'DATO0103'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE PROFESORES'
	  AADD(aNomApl,'SIMAPROF')
	  AADD(aPatSis,PathPro)
	  AADD(aFilDat,PathPro+'\'+PathSis+'\'+'DATO0103'+ExtFile)
       ENDIF

       IF FILE(PathCar+'\'+PathSis+'\'+'DATO0104'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE CARTERA'
	  AADD(aNomApl,'SIMACART')
	  AADD(aPatSis,PathCar)
	  AADD(aFilDat,PathCar+'\'+PathSis+'\'+'DATO0104'+ExtFile)
       ENDIF

       IF FILE(PathVot+'\'+PathSis+'\'+'DATO0105'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE VOTACION'
	  AADD(aNomApl,'SIMAVOTO')
	  AADD(aPatSis,PathVot)
	  AADD(aFilDat,PathVot+'\'+PathSis+'\'+'DATO0105'+ExtFile)
       ENDIF

       IF FILE(PathCaf+'\'+PathSis+'\'+'DATO0106'+ExtFile)
	  AADD(aMenus,i)
	  aMenus[i++] := 'SISTEMA DE CAFETERIA'
	  AADD(aNomApl,'SIMACAFE')
	  AADD(aPatSis,PathCaf)
	  AADD(aFilDat,PathCaf+'\'+PathSis+'\'+'DATO0106'+ExtFile)
       ENDIF

       AADD(aMenus,i)
       aMenus[i++] := 'SIMATOOL'
       AADD(aNomApl,'SIMATOOL')
       AADD(aPatSis,'')
       AADD(aFilDat,'')

       cSavPan := SAVESCREEN(0,0,24,79)
       DO WHILE .T.
	  nNroOpc := nMenu(aMenus,NIL,nNroFil,nNroCol,'SISTEMAS',NIL,1)
	  IF nNroOpc <> 0
	     EXIT
	  ENDIF
       ENDDO
       RESTSCREEN(0,0,24,79,cSavPan)

       cNomApl := aNomApl[nNroOpc]
       cPatSys := aPatSis[nNroOpc]
       FileDat := aFilDat[nNroOpc]
       cNomSis := aMenus[nNroOpc]
*>>>>FIN SELECCION DE LA JORNADA

*>>>>LECTURA DE LA LICENCIA
       IF !(EMPTY(cPatSys) .AND. EMPTY(FileDat))
	  IF !lLicencia(FileDat,;
			@cEmpPal,@cNitEmp,@cNomEmp,@cCodEmp,@cPaises,@cNomDpt,;
			@cNomMun,@cNomSec,@lShared,@nModCry,@nSysOpe,@cDerSys,;
			@cPwdSis,@nPrueba,@cAnoHab,@cMesHab,@cPwdHar,@lPiePag,;
			@cMaeAlu,@cJornad,@nPerHab,@cPwdIns)
	     cError('ERROR(L) INTERNO DEL SISTEMA')
	     CloseAll()
	     CLEAR
	     QUIT
	  ENDIF
       ELSE
	  cEmpPal := 'SIMASOFT. BUCARAMANGA'
	  cNitEmp := '91229913'
	  cNomEmp := 'SIMASOFT. BUCARAMANGA'
	  cMaeAlu := 'JARPRIBTO'            // Maestros habilitados
	  cJornad := 'DNMT'                 // Jornadas habilitadas
	  lShared := .F.                    // .T. Sistema Compartido
	  nModCry := 0                      // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
	  cPwdSis := 'ELLAS'                // PassWord Creaci¢n usuarios
	  lPrueba := .F.                    // Prueba de Paramentros
       ENDIF
       RETURN .T.
*>>>>FIN LECTURA DE LA LICENCIA