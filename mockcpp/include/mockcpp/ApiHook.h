
#ifndef __MOCKCPP_API_HOOK_H__
#define __MOCKCPP_API_HOOK_H__

#include <mockcpp/mockcpp.h>

MOCKCPP_NS_START

struct ApiHookImpl;

struct ApiHook
{
    ApiHook(void* pfnOld, void* pfnNew);
    ~ApiHook();

private:
    ApiHookImpl* This;;
};

MOCKCPP_NS_END

#endif
