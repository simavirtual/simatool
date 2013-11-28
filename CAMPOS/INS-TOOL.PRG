/*                       SIMA - SISTEMA UTILITARIO
		     DETALLES DE INSTALACION DE EMPRESAS

**************************************************************************
* TITULO..: DETALLES DE INSTALACION                                      *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:05 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Declara todas las variables que contiene los detalles de instalaci¢n
   de cada una de las empresas a las cuales se le ha instalado el sistema.

2- El objetivo principal es controlar los detalles de instalaci¢n de
   cada empresa.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE EMPRESAS INSTALADAS
       LOCAL cEmpPal := 'SIMASOFT. BUCARAMANGA'
       LOCAL cNitEmp := '91229913'
       LOCAL cNomEmp := 'SIMASOFT. BUCARAMANGA'
       LOCAL cMaeAlu := 'JARPRIBTO'         // Maestros habilitados
       LOCAL cJornad := 'DNMT'              // Jornadas habilitadas
       LOCAL lShared := .F.                 // .T. Sistema Compartido
       LOCAL nModCry := 0                   // 0=>No Protecci¢n 1=>Sin Proteci¢n Inicial 2=>Con Proteci¢n Inicial
       LOCAL cPasSis := 'ELLAS'             // PassWord Creaci¢n usuarios
       LOCAL lPrueba := .F.                 // Prueba de Paramentros
       LOCAL aKeySis := {{83951702,23},;    // 151146918
			 {cNomEmp,487023780},;
			 {cMaeAlu,151152049},;
			 {'System',419845542}}
*>>>>FIN DECLARACION DE EMPRESAS INSTALADAS
