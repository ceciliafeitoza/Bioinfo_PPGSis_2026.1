#!/usr/bin/env bash
# =============================================================================
#  setup.sh — Bioinformática PPGSIS 2026 · Dr. Yan Torres
#  Executado automaticamente após a criação do Codespace (postCreateCommand)
#  Tempo estimado: 20–25 min (primeira vez)
# =============================================================================
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
log()  { echo -e "${CYAN}[BIOINFO]${RESET} $1"; }
ok()   { echo -e "${GREEN}[OK]${RESET} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${RESET} $1"; }

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║   Bioinformática PPGSIS 2026 — Configuração do ambiente  ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""

# ── 1. Miniforge3 ─────────────────────────────────────────────────────────
CONDA_DIR="$HOME/miniforge3"
if [ ! -d "$CONDA_DIR" ]; then
    log "Instalando Miniforge3..."
    wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" \
        -O /tmp/miniforge.sh
    bash /tmp/miniforge.sh -b -p "$CONDA_DIR"
    rm /tmp/miniforge.sh
    ok "Miniforge3 instalado"
else
    ok "Miniforge3 já presente"
fi

# Carrega conda/mamba para este shell
source "$CONDA_DIR/etc/profile.d/conda.sh"
source "$CONDA_DIR/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$CONDA_DIR"
conda config --set auto_activate_base false

# Configura .bashrc para sessões futuras
if ! grep -q "miniforge3" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'BASHRC'

# Conda/Mamba — Bioinformática PPGSIS 2026
source "$HOME/miniforge3/etc/profile.d/conda.sh"
source "$HOME/miniforge3/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
conda activate bioinfo
BASHRC
fi

# ── 2. Ambiente principal: bioinfo ────────────────────────────────────────
log "Criando ambiente 'bioinfo' (pode levar 15–20 min)..."
if conda env list | grep -q "^bioinfo "; then
    warn "Ambiente 'bioinfo' já existe — pulando"
else
    mamba env create -f .devcontainer/environment.yml -y
fi
ok "Ambiente 'bioinfo' pronto"

# ── 3. Pacotes R via Bioconductor ─────────────────────────────────────────
log "Instalando pacotes R (phyloseq, poppr)..."
conda run -n bioinfo Rscript -e "
  options(repos = c(CRAN = 'https://cloud.r-project.org'))
  if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager')
  if (!requireNamespace('phyloseq',    quietly=TRUE)) BiocManager::install('phyloseq', ask=FALSE)
  if (!requireNamespace('poppr',       quietly=TRUE)) install.packages('poppr')
" 2>/dev/null && ok "Pacotes R instalados" || warn "Alguns pacotes R falharam — rode verificar.sh"

# ── 4. InSilicoSeq (simulação de reads) ───────────────────────────────────
log "Instalando InSilicoSeq..."
conda run -n bioinfo pip install InSilicoSeq --quiet && ok "InSilicoSeq instalado"

# ── 5. QIIME2 (Módulo 4 — opcional, ~3 GB) ────────────────────────────────
# Descomentado automaticamente se quiser instalar no setup.
# Para instalar manualmente: bash .devcontainer/instalar_qiime2.sh
#
# QIIME2_URL="https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml"
# log "Instalando QIIME2 (~3 GB — pode levar 20 min adicionais)..."
# wget -q "$QIIME2_URL" -O /tmp/qiime2.yml
# mamba env create -n qiime2-amplicon -f /tmp/qiime2.yml -y
# rm /tmp/qiime2.yml
# ok "QIIME2 instalado"

# ── 6. Mensagem final ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║          ✅  Ambiente configurado com sucesso!           ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Ative o ambiente:   ${CYAN}conda activate bioinfo${RESET}"
echo -e "  Verifique tudo:     ${CYAN}bash .devcontainer/verificar.sh${RESET}"
echo -e "  QIIME2 (Módulo 4):  ${CYAN}bash .devcontainer/instalar_qiime2.sh${RESET}"
echo ""
