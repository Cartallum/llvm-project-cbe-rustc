//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP_SUPPORT_MSVCLIB_XLOCALE_H
#define _LIBCPP_SUPPORT_MSVCLIB_XLOCALE_H

#if defined(_MSVCLIB_VERSION)

#include <cstdlib>
#include <clocale>
#include <cwctype>
#include <ctype.h>
#if !defined(__MSVCLIB__) || __MSVCLIB__ < 2 || \
    __MSVCLIB__ == 2 && __MSVCLIB_MINOR__ < 5
#include <__support/xlocale/__nop_locale_mgmt.h>
#include <__support/xlocale/__posix_l_fallback.h>
#include <__support/xlocale/__strtonum_fallback.h>
#endif

#endif // _MSVCLIB_VERSION

#endif
