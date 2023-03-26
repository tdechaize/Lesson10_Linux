 /*************************************************************************
 *  Project : $logger
 *  Function : Utility program : add trace in text file, only in mode Debug
 **************************************************************************
 *  $Author: Thierry DECHAIZE
 *  $Name:  thierry.dechaize@gmail.com
 ***************************************************************
 *  Find this extract after navigate on Internet
 *  No Copyright : public domain
 *  Adapted because my needs are specifics.
 ***************************************************************/

//logger.c

/**         Comments manageable by Doxygen
*
*  Modified by Thierry DECHAIZE
*
*  Date : 2023/03/05
*
* \file            logger.c
* \author          Thierry Dechaize
* \version         2.0.1.0
* \date            5 mars 2023
* \brief           Ajout de fonction de "logging" (traces dans un fichier texte log.txt) uniquement en mode Debug et avec des niveaux de tracing définis dans une variable d'environnement (LEVEL)
* \details         L'utilisation est très simple : #if define(DEBUG) then if LEVEL=FULL or LEVEl= BASE ... or LEVEL=OPENGL log_print(nom_du_source, ligne dans ce source, texte approprié)
*
*
*/

#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#if defined (WINDOWS) || defined (WIN32) || defined (_WIN32) || defined (WIN64) || defined (_WIN64)
#include <windows.h>
#endif
#include "logger.h"

FILE *ft ;
static int SESSION_TRACKER; //Keeps track of session

char* print_time()
{
    int size = 0;
    time_t now;
    char *buf,timestr[37];
    struct tm * tm;
          /* Utilise tm_year, tm_mday, tm_month, tm_hour, tm_min, tm_sec ou strftime: */

    now = time(NULL); /* get current calendar time */
    tm = localtime(&now);
    strftime(timestr, sizeof timestr, "%A, %d %B %Y, %H:%M:%S", tm);
    timestr[strlen(timestr) - 1] = 0;  //Getting rid of \n

    size = strlen(timestr)+ 1 + 2; //Additional +2 for square braces
    buf = (char*)malloc(size);

    memset(buf, 0x0, size);
#if defined(__SC__) || defined(__DMC__)
    _snprintf(buf,size,"[%s]", timestr);
#else
    snprintf(buf,size,"[%s]", timestr);
#endif
    return buf;
}

void log_print(char* filename, int line, char *fmt,...)
{
    va_list         list;
    char            *p, *r;
    int             e;

    if(SESSION_TRACKER > 0)
      ft = fopen ("log.txt","a+");
    else
      ft = fopen ("log.txt","w");

    fprintf(ft,"%s ",print_time());
    fprintf(ft,"[%s ,line: %d] ",filename,line);
    va_start( list, fmt );

    for ( p = fmt ; *p ; ++p )
    {
        if ( *p != '%' )//If simple string
        {
            fputc( *p,ft );
        }
        else
        {
            switch ( *++p )
            {
                /* string */
            case 's':
            {
                r = va_arg( list, char * );

                fprintf(ft,"%s", r);
                continue;
            }

            /* integer */
            case 'd':
            {
                e = va_arg( list, int );

                fprintf(ft,"%d", e);
                continue;
            }

            default:
                fputc( *p, ft );
            }
        }
    }
    va_end( list );
    fputc( '\n', ft );
    SESSION_TRACKER++;
    fclose(ft);
}

