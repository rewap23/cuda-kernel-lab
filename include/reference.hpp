#pragma once

#include <cmath>

inline void vector_add_cpu(
    const float* a,
    const float* b,
    float* output,
    int n
) {
    for (int i = 0; i < n; ++i) {
        output[i] = a[i] + b[i];
    }
}

inline bool nearly_equal(
    float actual,
    float expected,
    float absolute_tolerance = 1e-5f
) {
    return std::fabs(actual - expected) <= absolute_tolerance;
}