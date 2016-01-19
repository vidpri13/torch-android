#include "THAtomic.h"
#include "THStorage.h"

#include "generic/THStorage.c"
#include "THGenerateAllTypes.h"

#include "generic/THStorageCopy.c"
#include "THGenerateAllTypes.h"
#ifdef _WIN32
#include <windows.h>
#endif

#if HAVE_MMAP
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#endif

