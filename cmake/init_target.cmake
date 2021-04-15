# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

function(init_target target_name) # init_target(my_target folder_name)
    if (CMAKE_C_COMPILER_ID STREQUAL "MSVC")
        set_target_properties(${target_name} PROPERTIES
            MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
    set_target_properties(${target_name} PROPERTIES
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_WEAK YES
        XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN YES
        XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN YES
    )
    if (NOT TG_OWT_SPECIAL_TARGET STREQUAL "")
        set_target_properties(${target_name} PROPERTIES
            XCODE_ATTRIBUTE_GCC_OPTIMIZATION_LEVEL $<IF:$<CONFIG:Debug>,0,fast>
            XCODE_ATTRIBUTE_LLVM_LTO $<IF:$<CONFIG:Debug>,NO,YES>
        )
    endif()
    if (WIN32)
        target_compile_options(${target_name}
        PRIVATE
            /MP     # Enable multi process build.
            /EHsc   # Catch C++ exceptions only, extern C functions never throw a C++ exception.
        )
    else()
        if (APPLE)
            target_compile_options(${target_name}
            PRIVATE
                -Wno-deprecated-declarations
                -fobjc-arc
                -fvisibility=hidden
                -fvisibility-inlines-hidden
            )
        else()
            target_compile_options(${target_name}
            PRIVATE
                -Wno-deprecated-declarations
                -Wno-attributes
                -Wno-narrowing
                -Wno-return-type
            )
            if (NOT TG_OWT_SPECIAL_TARGET STREQUAL "" AND CMAKE_SIZEOF_VOID_P EQUAL 4)
                target_compile_options(${target_name}
                PRIVATE
                    -g0
                )
            endif()
        endif()

        if (is_x86)
            target_compile_options(${target_name}
            PRIVATE
                -msse2
            )
        endif()
    endif()
endfunction()
