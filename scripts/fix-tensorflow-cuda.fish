#!/usr/bin/env fish

set -l site_packages .venv/lib/python3.11/site-packages
set -l nvidia_dir $site_packages/nvidia

if not test -f $nvidia_dir/cusolver/lib/libcusolver.so.11
    echo "libcusolver.so.11 not found. Run 'uv sync' first."
    exit 1
end

ln -sfn ../../cusolver/lib/libcusolver.so.11 \
    $nvidia_dir/cublas/lib/libcusolver.so.11

set -l ptxas_path (find $nvidia_dir/cuda_nvcc -type f -name ptxas -print -quit)

if test -n "$ptxas_path"
    ln -sfn (realpath $ptxas_path) .venv/bin/ptxas
end

echo "Local CUDA fix applied successfully."
