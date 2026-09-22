#pragma once

#include <cuda_runtime.h>
#include "cuda_check.cuh"

// Vector add is a Element-wise operation, so we can use a 1D grid and 1D blocks

// Kernel function to perform vector addition on the GPU
__global__ void vector_add(const float* a, const float* b, float* c, std::size_t n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        c[idx] = a[idx] + b[idx];
    }
}

// Wrapper function to launch the kernel and manage memory
void vector_add_gpu(const float* a, const float* b, float* c, std::size_t n) {
    //Allocate device memory by calling cudaMalloc for each vector
    float *d_a, *d_b, *d_c;
    // Allocate device memory for vectors a, b, and c
    CUDA_CHECK(cudaMalloc(&d_a, n * sizeOf(float)));
    CUDA_CHECK(cudaMalloc(&d_b, n * sizeOf(float)));
    CUDA_CHECK(cudaMalloc(&d_c, n * sizeOf(float)));

    // Copy input vectors from host to device memory
    CUDA_CHECK(cudaMemcpy(d_a, a, n * sizeOf(float), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, b, n * sizeOf(float), cudaMemcpyHostToDevice));

    // Launch the kernel with a 1D grid and 1D blocks
    const int threads_per_block = 256;
    const int numBlocks = (n + threads_per_block - 1) / threads_per_block;
    
    // Launch the kernel
    vector_add_kernel<<<numBlocks, threads_per_block>>>(d_a, d_b, d_c, n);

    // Check for any errors during kernel launch
    CUDA_CHECK(cudaGetLastError());
    // Copy the result vector from device to host memory
    CUDA_CHECK(cudaMemcpy(c, d_c, n * sizeOf(float), cudaMemcpyDeviceToHost));

    //Freeing device memory after computation
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));


}