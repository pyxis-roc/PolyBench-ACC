# Author: 		Benjamin Valpey

SRCPATH := $(CURDIR)/bin
export SRCPATH

.PHONY: all datamining_bins stencil_bins linalg_bins

all: datamining_bins linalg_bins stencil_bins | bin

bin:
	mkdir -p bin

datamining_bins := correlation covariance
datamining_targets := $(addprefix bin/,$(datamining_bins))

datamining_bins: $(datamining_targets)

$(datamining_targets):
	$(MAKE) -C CUDA/datamining/$(notdir $@)


## linalg has a different directory structure...

linalg_kernels := 2mm 3mm atax bicg doitgen gemm gemver gesummv mvt syr2k syrk
linalg_kernel_targets := $(addprefix bin/,$(linalg_kernels))

$(linalg_kernel_targets):
	$(MAKE) -C CUDA/linear-algebra/kernels/$(notdir $@)

linalg_solvers := gramschmidt lu
linalg_solver_targets := $(addprefix bin/,$(linalg_solvers))

$(linalg_solver_targets):
	$(MAKE) -C CUDA/linear-algebra/solvers/$(notdir $@)

linalg_bins := $(linalg_solvers) $(linalg_kernels)
linalg_bins: $(linalg_solver_targets) $(linalg_kernel_targets)



## stencils have a directory structure not suited for wildcard. Here I write a rule for each.

STENCIL_PATH := CUDA/stencils
stencil_bins := adi 2DConvolution 3DConvolution fdtd2d jacobi1D jacobi2D

stencil_bins: stencil_targets
stencil_targets: $(addprefix bin/, $(stencil_bins))

bin/adi:
	$(MAKE) -C $(STENCIL_PATH)/adi
bin/2DConvolution:
	$(MAKE) -C $(STENCIL_PATH)/convolution-2d
bin/3DConvolution:
	$(MAKE) -C $(STENCIL_PATH)/convolution-3d
bin/fdtd2d:
	$(MAKE) -C $(STENCIL_PATH)/fdtd-2d
bin/jacobi1D:
	$(MAKE) -C $(STENCIL_PATH)/jacobi-1d-imper
bin/jacobi2D:
	$(MAKE) -C $(STENCIL_PATH)/jacobi-2d-imper

clean:
	rm -f bin/*
