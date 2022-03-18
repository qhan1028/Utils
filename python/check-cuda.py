#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Outputs some information on CUDA-enabled devices on your computer,
including current memory usage.

It's a port of https://gist.github.com/f0k/0d6431e3faa60bffc788f8b4daa029b1
from C to Python with ctypes, so it can run without compiling anything. Note
that this is a direct translation with no attempt to make the code Pythonic.
It's meant as a general demonstration on how to obtain CUDA device information
from Python without resorting to nvidia-smi or a compiled Python extension.

Author: Jan Schlüter
"""

import sys
import ctypes


# Some constants taken from cuda.h
CUDA_SUCCESS = 0
CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT = 16
CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR = 39
CU_DEVICE_ATTRIBUTE_CLOCK_RATE = 13
CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE = 36


def ConvertSMVer2Cores(major, minor):
    # Returns the number of CUDA cores per multiprocessor for a given
    # Compute Capability version. There is no way to retrieve that via
    # the API, so it needs to be hard-coded.
    return {
    # Tesla
      (1, 0):   8,      # SM 1.0
      (1, 1):   8,      # SM 1.1
      (1, 2):   8,      # SM 1.2
      (1, 3):   8,      # SM 1.3
    # Fermi
      (2, 0):  32,      # SM 2.0: GF100 class
      (2, 1):  48,      # SM 2.1: GF10x class
    # Kepler
      (3, 0): 192,      # SM 3.0: GK10x class
      (3, 2): 192,      # SM 3.2: GK10x class
      (3, 5): 192,      # SM 3.5: GK11x class
      (3, 7): 192,      # SM 3.7: GK21x class
    # Maxwell
      (5, 0): 128,      # SM 5.0: GM10x class
      (5, 2): 128,      # SM 5.2: GM20x class
      (5, 3): 128,      # SM 5.3: GM20x class
    # Pascal
      (6, 0):  64,      # SM 6.0: GP100 class
      (6, 1): 128,      # SM 6.1: GP10x class
      (6, 2): 128,      # SM 6.2: GP10x class
    # Volta
      (7, 0):  64,      # SM 7.0: GV100 class
      (7, 2):  64,      # SM 7.2: GV11b class
    # Turing
      (7, 5):  64,      # SM 7.5: TU10x class
    }.get((major, minor), 64)   # unknown architecture, return a default value


def main():
    libnames = ('libcuda.so', 'libcuda.dylib', 'cuda.dll')
    for libname in libnames:
        try:
            cuda = ctypes.CDLL(libname)
        except OSError:
            continue
        else:
            break
    else:
        raise OSError("could not load any of: " + ' '.join(libnames))

    nGpus = ctypes.c_int()
    name = b' ' * 100
    cc_major = ctypes.c_int()
    cc_minor = ctypes.c_int()
    cores = ctypes.c_int()
    threads_per_core = ctypes.c_int()
    clockrate = ctypes.c_int()
    freeMem = ctypes.c_size_t()
    totalMem = ctypes.c_size_t()

    result = ctypes.c_int()
    device = ctypes.c_int()
    context = ctypes.c_void_p()
    error_str = ctypes.c_char_p()

    result = cuda.cuInit(0)
    if result != CUDA_SUCCESS:
        cuda.cuGetErrorString(result, ctypes.byref(error_str))
        print("cuInit failed with error code %d: %s" % (result, error_str.value.decode()))
        return 1
    result = cuda.cuDeviceGetCount(ctypes.byref(nGpus))
    if result != CUDA_SUCCESS:
        cuda.cuGetErrorString(result, ctypes.byref(error_str))
        print("cuDeviceGetCount failed with error code %d: %s" % (result, error_str.value.decode()))
        return 1
    print("Found %d device(s)." % nGpus.value)
    for i in range(nGpus.value):
        result = cuda.cuDeviceGet(ctypes.byref(device), i)
        if result != CUDA_SUCCESS:
            cuda.cuGetErrorString(result, ctypes.byref(error_str))
            print("cuDeviceGet failed with error code %d: %s" % (result, error_str.value.decode()))
            return 1
        print("Device: %d" % i)
        if cuda.cuDeviceGetName(ctypes.c_char_p(name), len(name), device) == CUDA_SUCCESS:
            print("  Name: %s" % (name.split(b'\0', 1)[0].decode()))
        if cuda.cuDeviceComputeCapability(ctypes.byref(cc_major), ctypes.byref(cc_minor), device) == CUDA_SUCCESS:
            print("  Compute Capability: %d.%d" % (cc_major.value, cc_minor.value))
        if cuda.cuDeviceGetAttribute(ctypes.byref(cores), CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT, device) == CUDA_SUCCESS:
            print("  Multiprocessors: %d" % cores.value)
            print("  CUDA Cores: %s" % (cores.value * ConvertSMVer2Cores(cc_major.value, cc_minor.value) or "unknown"))
            if cuda.cuDeviceGetAttribute(ctypes.byref(threads_per_core), CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR, device) == CUDA_SUCCESS:
                print("  Concurrent threads: %d" % (cores.value * threads_per_core.value))
        if cuda.cuDeviceGetAttribute(ctypes.byref(clockrate), CU_DEVICE_ATTRIBUTE_CLOCK_RATE, device) == CUDA_SUCCESS:
            print("  GPU clock: %g MHz" % (clockrate.value / 1000.))
        if cuda.cuDeviceGetAttribute(ctypes.byref(clockrate), CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE, device) == CUDA_SUCCESS:
            print("  Memory clock: %g MHz" % (clockrate.value / 1000.))
        result = cuda.cuCtxCreate(ctypes.byref(context), 0, device)
        if result != CUDA_SUCCESS:
            cuda.cuGetErrorString(result, ctypes.byref(error_str))
            print("cuCtxCreate failed with error code %d: %s" % (result, error_str.value.decode()))
        else:
            result = cuda.cuMemGetInfo(ctypes.byref(freeMem), ctypes.byref(totalMem))
            if result == CUDA_SUCCESS:
                print("  Total Memory: %d MiB" % (totalMem.value / 1024**2))
                print("  Free Memory: %d MiB" % (freeMem.value / 1024**2))
            else:
                cuda.cuGetErrorString(result, ctypes.byref(error_str))
                print("cuMemGetInfo failed with error code %d: %s" % (result, error_str.value.decode()))
            cuda.cuCtxDetach(context)
    return 0


if __name__=="__main__":
    sys.exit(main())