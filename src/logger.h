#ifndef LOGGER_H
#define LOGGER_H

 /*************************************************************************
 *  Project : $logger.h
 *  Function : Utility program : add trace in text file, only in mode Debug
 **************************************************************************
 *  $Author: Thierry DECHAIZE
 *  $Name:  thierry.dechaize@gmail.com
 ***************************************************************
 *  Find this extract after navigate on Internet
 *  No Copyright : public domain
 *  Adapted because my needs are specifics.
 ***************************************************************/

//logger.h

/**         Comments manageable by Doxygen
*
*  Modified by Thierry DECHAIZE
*
*  Date : 2023/03/05
*
* \file            logger.h
* \author          Thierry Dechaize
* \version         2.0.1.0
* \date            5 mars 2023
* \brief           Header de l'ajout de fonction de "logging" (traces dans un fichier texte log.txt) uniquement en mode Debug et avec des niveaux de tracing définis dans une variable d'environnement (LEVEL)
* \details         Il s'agit de pouvoir partager les deux fonctions utiles de cet utilitaire.
*
*
*/

//logger.h

#if defined __TURBOC__ || defined __BORLANDC__
#include <stdarg.h>
#endif // defined

void log_print(char* filename, int line, char *fmt,...);
// Borland C/C++ don't compile with this define !!!
// #define LOG_PRINT(...) log_print(__FILE__, __LINE__, __VA_ARGS__ )

#endif // header guard


