/*                       SIMA - SISTEMA UTILITARIO
		     DECLARACION DE ARCHIVOS DEL SISTEMA

**************************************************************************
* TITULO..: DECLARACION DE ARCHIVOS DEL SISTEMAS                         *
**************************************************************************

AUTOR: Nelson Fern ndez G¢mez       FECHA DE CREACION: MAY 28/2002 MAR A
       Colombia, Bucaramanga        INICIO: 04:00 PM   MAY 28/2002 MAR

OBJETIVOS:

1- Declara todas las variables que contiene la declaraci¢n de todos los
   archivos que conforma el sistema.

2- El objetivo principal de esta declaraci¢n es estandarizar el modo
   de acceso a los archivos.

*------------------------------------------------------------------------*
*                              PROGRAMA                                  *
*------------------------------------------------------------------------*/

*>>>>DECLARACION DE ARCHIVOS GENERALES
       LOCAL PathSys := 'SIMATOOL'          // Path del Sistema
       LOCAL PathSis := 'BASES'             // Path General del sistema
       LOCAL ExtFile := '.DAT'              // Extension para las bases
       LOCAL cExtNtx := '.NEL'              // Extension para indices
       LOCAL aUseDbf := {}                  // Vector para Apertura de Varias Dbfs
       LOCAL lSiRed  := .T.                 // .T. Apertura de Archivos MultiUsuario
       LOCAL lNoRed  := .F.                 // .F. Apertura de Archivo MonoUsuario

       LOCAL PathTem := 'TEMP'              // Path Temporal
       LOCAL PathPrn := 'PRINTER'           // Path para impresiones
       LOCAL PathXls := 'c:\misdoc'         // Path de Documentos del sima
       LOCAL PathDoc := 'c:\misdoc'         // Path de Documentos del sima

       LOCAL FileBak := ''                  // Archivo Temporal
       LOCAL FileTem := 'TEMPO'             // Archivo datos temporal
       LOCAL fNtxTem := 'TEMPO'             // Archivo Indice temporal
       LOCAL cExtTem := '.TEM'              // Extension indice temporal
     *ÀArchivo Temporal

       LOCAL PathAaa := ''
       LOCAL FileAaa := PathAaa+'TEMP'+ExtFile
       LOCAL fNtxAaa := ''
     *ÀArchivo de Usuarios

       LOCAL PathErr := ''
       LOCAL fErrSys := PathErr+'ERRORSYS'+ExtFile
       LOCAL fNtxErr := ''
     *ÀArchivo de Errores

       LOCAL FileClr := 'CFGCOLOR'+ExtFile
     *ÀArchivo de Configuraci¢n del Color

       LOCAL FilePrn := 'DRIVERS'+ExtFile
     *ÀArchivo de Configuraci¢n de Impresoras
*>>>>FIN DECLARACION DE ARCHIVOS GENERALES

*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA
       LOCAL fSimTol := 'SIMATOOL'+ExtFile
       LOCAL FileApt := 'FILEAPT.DBF'
*>>>>DECLARACION DE ARCHIVOS DEL SISTEMA

*>>>>DECLARACION DE ARCHIVOS COMPARTIDOS
       LOCAL FileAlu := 'MAE'
       LOCAL fNtxAlu := 'MAE'
     *ÀArchivo de Alumnos

       LOCAL FileGru := 'GRU'
     *ÀArchivo de Grupos

       LOCAL FileToG := 'TIPOBSGE'+ExtFile
     *ÀArchivo de Tipo Observaciones Generales

       LOCAL FileSoG := 'SUBOBSGE'+ExtFile
     *ÀArchivo de Subdivisi¢n Observaciones Generales


       LOCAL FilePer := 'PERSONAS'+ExtFile
       LOCAL fNtxPer := 'PERSONAS'+cExtNtx
       LOCAL Ntx1Per := 'PERSONIT'+cExtNtx
     *ÀArchivo de Personas

       LOCAL fPerImp := 'PER'
     *ÀArchivo de Personas Importar
*>>>>FIN DECLARACION DE ARCHIVOS COMPARTIDOS

*>>>>DECLARACION DE ARCHIVOS DE LA CONTABILIDAD
       LOCAL fConAno := 'CONT'                        // Ej: CONT1996.DAT
*>>>>FIN DECLARACION DE ARCHIVOS DE LA CONTABILIDAD

*>>>>DECLARACION DE ARCHIVOS DE LA CARTERA
       LOCAL FileCli := ''                            // Ej: CLI1101.094
     *ÀArchivo de Clientes

       LOCAL FilePag := ''                           // Ej: PAG1101.094
     *ÀArchivo de Pagos
*>>>>FIN DECLARACION DE ARCHIVOS DE LA CARTERA