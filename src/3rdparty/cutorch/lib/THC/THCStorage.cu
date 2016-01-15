#include "THCStorage.h"

#include <thrust/device_ptr.h>
#include <thrust/fill.h>
#if CUDA_VERSION >= 7000
#include <thrust/system/cuda/execution_policy.h>
#endif

void THCudaStorage_fill(THCState *state, THCudaStorage *self, float value)
{
  thrust::device_ptr<float> self_data(self->data);
  thrust::fill(
#if CUDA_VERSION >= 7000
    thrust::cuda::par.on(THCState_getCurrentStream(state)),
#endif
    self_data, self_data+self->size, value);
}

void THCudaStorage_resize(THCState *state, THCudaStorage *self, long size)
{
  THArgCheck(size >= 0, 2, "invalid size");

  if(!(self->flag & TH_STORAGE_RESIZABLE))
    return;

  if(size == 0)
  {
    if(self->flag & TH_STORAGE_FREEMEM) {
      THCudaCheck(THCudaFree(state, self->data));
      THCHeapUpdate(state, -self->size * sizeof(float));
    }
    self->data = NULL;
    self->size = 0;
  }
  else
  {
    float *data = NULL;
    // update heap *before* attempting malloc, to free space for the malloc
    THCHeapUpdate(state, size * sizeof(float));
    cudaError_t err = THCudaMalloc(state, (void**)(&data), size * sizeof(float));
    if(err != cudaSuccess) {
      THCHeapUpdate(state, -size * sizeof(float));
    }
    THCudaCheck(err);

    if (self->data) {
      THCudaCheck(cudaMemcpyAsync(data,
                                  self->data,
                                  THMin(self->size, size) * sizeof(float),
                                  cudaMemcpyDeviceToDevice,
                                  THCState_getCurrentStream(state)));
      THCudaCheck(THCudaFree(state, self->data));
      THCHeapUpdate(state, -self->size * sizeof(float));
    }

    self->data = data;
    self->size = size;
  }
}
