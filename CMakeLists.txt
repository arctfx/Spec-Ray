cmake_minimum_required(VERSION 3.28)
project(Spec_Ray CUDA)

set(CMAKE_CUDA_STANDARD 17)

add_executable(Spec_Ray src/main.cu
        src/interface/pipes.cu
        src/interface/pipes.cuh
)

set_target_properties(Spec_Ray PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
