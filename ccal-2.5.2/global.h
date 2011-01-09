/*
 * global.h 
 * This is a hack to allow the output of the ccal stdout to be saved to a file
 */
#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h> 

#define FILE_OUTPUT

#if defined(FILE_OUTPUT)
	extern FILE *g_ccal_ofp; // This allows the caller to specify the file pointer for output
	#define CCAL_PRINTF(format, args...) fprintf(g_ccal_ofp, format, ## args)
#else
	#define CCAL_PRINTF(format, args...) printf(format, ## args)
#endif

#ifndef NO_NAMESPACE
	#include <vector>
	typedef std::vector<double> vdouble;
#else
	#include <vector.h>
	typedef vector<double> vdouble;
#endif

#endif