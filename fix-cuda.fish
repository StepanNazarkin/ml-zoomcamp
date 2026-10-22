
#!/usr/bin/env fish

set -l venv_dir .venv
set -l site_packages (uv run python -c 'import site; print(site.getsitepackages()[0])' 2>/dev/null)

if test $status -ne 0; or not test -d "$site_packages/nvidia"
    echo "ERROR: NVIDIA Python libraries not found. Run 'uv sync' first."
    exit 1
end

set -l nvidia_dir "$site_packages/nvidia"
set -l cusolver "$nvidia_dir/cusolver/lib/libcusolver.so.11"
set -l cublas_dir "$nvidia_dir/cublas/lib"

if not test -f "$cusolver"
    echo "ERROR: $cusolver not found."
    exit 1
end

if not test -d "$cublas_dir"
    echo "ERROR: cuBLAS directory not found: $cublas_dir"
    exit 1
end

ln -sfn ../../cusolver/lib/libcusolver.so.11 \
    "$cublas_dir/libcusolver.so.11"

set -l ptxas_path (find "$nvidia_dir/cuda_nvcc" -type f -name ptxas -print -quit)

if test -n "$ptxas_path"
    ln -sfn (realpath "$ptxas_path") "$venv_dir/bin/ptxas"
    echo "ptxas linked successfully."
else
    echo "WARNING: ptxas not found."
end

echo "Local CUDA fix applied successfully."
echo "Testing TensorFlow GPU detection..."

uv run python -c '
import tensorflow as tf
print("TensorFlow:", tf.__version__)
print("GPUs:", tf.config.list_physical_devices("GPU"))
'
