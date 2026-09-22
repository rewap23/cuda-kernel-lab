#include <iostream>

#include <vector>

#include "reference.hpp"

void vector_add_gpu(const float* a, const float* b, float* c, int n);

int main() {
    constexpr int n = 1 << 20;

    std::vector<float> a(n);
    std::vector<float> b(n);
    std::vector<float> cpu_output(n);
    std::vector<float> gpu_output(n);

    for (int i = 0; i < n; ++i) {
        a[i] = static_cast<float>(i) * 0.25f;
        b[i] = static_cast<float>(i) * 0.75f;
    }

    vector_add_cpu(a.data(), b.data(), cpu_output.data(), n);
    vector_add_gpu(a.data(), b.data(), gpu_output.data(), n);

    for (int i = 0; i < n; ++i) {
        if (!nearly_equal(cpu_output[i], gpu_output[i])) {
            std::cerr
                << "FAIL at index " << i
                << ": expected " << cpu_output[i]
                << ", got " << gpu_output[i]
                << '\n';

            return 1;
        }
    }

    std::cout << "PASS: vector addition output matches CPU reference.\n";
    return 0;
}
}