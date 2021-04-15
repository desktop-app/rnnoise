cmake_minimum_required(VERSION 3.16)
cmake_policy(SET CMP0076 NEW)
cmake_policy(SET CMP0091 NEW)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

project(rnnoise
    LANGUAGES C
    DESCRIPTION "rnnoise for Telegram"
    HOMEPAGE_URL "https://github.com/desktop-app/rnnoise.git"
)
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT rnnoise)

include(cmake/nice_target_sources.cmake)
include(cmake/init_target.cmake)

add_library(rnnoise)
init_target(rnnoise)

get_filename_component(rnnoise_loc "." REALPATH)

nice_target_sources(rnnoise ${rnnoise_loc}/src
PRIVATE
    _kiss_fft_guts.h
    common.h
    kiss_fft.h
    rnn.c
    rnn_reader.c
    arch.h
    compile.sh
    opus_types.h
    rnn.h
    rnn_train.py
    celt_lpc.c
    denoise.c
    pitch.c
    rnn_data.c
    tansig_table.h
    celt_lpc.h
    kiss_fft.c
    pitch.h
    rnn_data.h
)

remove_target_sources(rnnoise ${rnnoise_loc}/src
    compile.sh
    rnn_train.py
)

nice_target_sources(rnnoise ${rnnoise_loc}
PRIVATE
    include/rnnoise.h
)

target_include_directories(rnnoise
PRIVATE
    ${rnnoise_loc}/include
)

set(conflicting_names
    _celt_autocorr
    celt_fir
    celt_iir
    _celt_lpc
    celt_pitch_xcorr
    compute_band_corr
    compute_band_energy
    compute_dense
    compute_gru
    compute_rnn
    interp_band_gain
    opus_fft_alloc
    opus_fft_alloc_arch_c
    opus_fft_alloc_twiddles
    opus_fft_c
    opus_fft_free
    opus_fft_free_arch_c
    opus_fft_impl
    opus_ifft_c
    pitch_downsample
    pitch_filter
    pitch_search
    remove_doubling
)

set(replace_conflicting_names "")
foreach (entry ${conflicting_names})
    list(APPEND replace_conflicting_names ${entry}=rnnoise_${entry})
endforeach()

target_compile_definitions(rnnoise
PRIVATE
    _USE_MATH_DEFINES
    ${replace_conflicting_names}
)
