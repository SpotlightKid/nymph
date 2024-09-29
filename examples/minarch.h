/******************* BEGIN minarch.h ****************/

/************************************************************************
 FAUST Architecture File for generating a very minimal C interface
 ************************************************************************/

#include <math.h>
#include <stdio.h>

#include "faust/gui/CInterface.h"

#define max(a,b) ((a < b) ? b : a)
#define min(a,b) ((a < b) ? a : b)

/******************************************************************************
 VECTOR INTRINSICS
*******************************************************************************/

<<includeIntrinsic>>

/**************************BEGIN USER SECTION **************************/

<<includeclass>>

/***************************END USER SECTION ***************************/
