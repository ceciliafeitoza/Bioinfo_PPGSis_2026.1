#!/usr/bin/env bash
# =============================================================================
#  instalar_qiime2.sh — Instala o ambiente QIIME2 separadamente
#  Uso: bash .devcontainer/instalar_qiime2.sh
#  Tempo estimado: 20–30 min (~3 GB de download)
# =============================================================================

source "$HOME/miniforge3/etc/profile.d/conda.sh"
source "$HOME/miniforge3/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"

if conda env list | grep -q "^qiime2-amplicon "; then
    echo "Ambiente 'qiime2-amplicon' já existe."
    exit 0
fi

echo "[QIIME2] Baixando e instalando (~3 GB, 20–30 min)..."
QIIME2_URL="https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml"
wget -q "$QIIME2_URL" -O /tmp/qiime2.yml
mamba env create -n qiime2-amplicon -f /tmp/qiime2.yml -y
rm /tmp/qiime2.yml

echo ""
echo "✅ QIIME2 instalado!"
echo "   Ativar com: conda activate qiime2-amplicon"
