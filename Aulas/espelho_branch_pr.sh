# =============================================================================
#  ESPELHO — Branches, Pull Requests e Conflitos (digitar junto em aula)
#  CHS0007 · Bioinformática · PPGSIS/UFC · Aula 2
#
#  Como usar: digite UMA linha por vez no terminal do Codespace (no seu fork).
#  A PARTE A é o fluxo normal de contribuição. A PARTE B cria um conflito
#  de propósito para você praticar a resolução.
# =============================================================================


# #############################################################################
#  PARTE A · Fluxo de uma contribuição (branch → commit → push → Pull Request)
# #############################################################################

# --- 1. Criar uma branch para a sua tarefa -----------------------------------
git switch -c minha-primeira-feature   # cria a branch e já entra nela
git branch                              # confirme: o * está na branch nova

# --- 2. Fazer uma mudança e versionar ----------------------------------------
echo "Anotação feita na minha branch" >> notas_aula2.md
git add notas_aula2.md
git commit -m "Adiciona anotação na minha branch"

# --- 3. Publicar a branch no GitHub ------------------------------------------
git push -u origin minha-primeira-feature   # -u liga a branch local à remota

# --- 4. Abrir o Pull Request (na interface do GitHub) ------------------------
#   a) Abra seu repositório no navegador
#   b) Clique em "Compare & pull request"
#   c) Escreva um título claro e uma descrição (o quê e por quê)
#   d) "Create pull request"  →  após revisão, "Merge pull request"


# #############################################################################
#  PARTE B · Praticar a resolução de um conflito (tudo local, sem push)
# #############################################################################

# --- 1. Na main, criar um arquivo com um parâmetro ---------------------------
git switch main
echo "parametro_qualidade = 20" > parametros.txt
git add parametros.txt
git commit -m "Adiciona parametros iniciais"

# --- 2. Numa branch, mudar o parâmetro para 30 -------------------------------
git switch -c ajusta-parametro
# (em aula, edite parametros.txt no VS Code; aqui usamos sed para ir rápido)
sed -i 's/= 20/= 30/' parametros.txt
git add parametros.txt
git commit -m "Ajusta parametro para 30"

# --- 3. De volta na main, mudar a MESMA linha para 25 ------------------------
git switch main
sed -i 's/= 20/= 25/' parametros.txt
git add parametros.txt
git commit -m "Ajusta parametro para 25"

# --- 4. Tentar juntar a branch → CONFLITO ------------------------------------
git merge ajusta-parametro    # o Git avisa que há conflito e pausa o merge

# --- 5. Ver o conflito (marcadores <<<<<<< ======= >>>>>>>) -------------------
cat parametros.txt

# --- 6. RESOLVER -------------------------------------------------------------
#   Abra parametros.txt no editor e deixe APENAS a linha que você quer manter.
#   Apague as três linhas de marcação: <<<<<<< HEAD, ======= e >>>>>>> ...
#   Depois finalize o merge:
git add parametros.txt
git commit -m "Resolve conflito do parametro_qualidade"

# --- 7. Conferir o histórico em forma de grafo -------------------------------
git log --oneline --graph -8


# =============================================================================
#  Lembre: conflito não é erro — é o Git pedindo que VOCÊ decida.
#  Fluxo de equipe:  branch → commit → push → Pull Request → revisão → merge.
# =============================================================================
