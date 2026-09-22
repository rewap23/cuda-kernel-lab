cmake_minimum_required(VERSION 3.24)

project(
    cuda_kernel_lab
    VERSION 0.1.0
    LANGUAGES CXX CUDA
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

add_executable(
    kernel_lab
    src/main.cu
    src/vector_add.cu
)

target_include_directories(
    kernel_lab
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

set_target_properties(
    kernel_lab
    PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)