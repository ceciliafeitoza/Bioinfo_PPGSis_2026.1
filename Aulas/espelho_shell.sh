# =============================================================================
#  ESPELHO — Shell para Bioinformática (digitar junto em aula)
#  CHS0007 · Bioinformática · PPGSIS/UFC · Aula 2
#
#  Como usar: rode UMA VEZ o bloco de preparação abaixo; depois digite os
#  demais comandos UM POR VEZ, observando a saída antes de seguir.
# =============================================================================


# --- PREPARAÇÃO: criar os dados de exemplo (rode este bloco de uma vez) -------
cat > especies.fasta <<'FASTA'
>Panthera_onca
ATGCGTACGTAGCTAGCTAGCATCGATCGATCG
>Leontopithecus_rosalia
ATGCTAGCTAGCTAGCATCGATCGTAGCTAGCT
>Chrysocyon_brachyurus
ATGCCCGGGTTTAAACCCGGGTATCGATCGATC
>Bradyrhizobium_sp
ATGAAACCCGGGTTTATGCGTACGTAGCTAGCA
FASTA

printf 'id\tespecie\tlocal\treads\n'              > amostras.tsv
printf 'AM01\tonca\tfloresta\t1500000\n'         >> amostras.tsv
printf 'AM02\tmico\tfloresta\t800000\n'          >> amostras.tsv
printf 'AM03\tlobo\tcerrado\t2100000\n'          >> amostras.tsv
printf 'AM04\tbradyrhizobium\tsolo\t3400000\n'   >> amostras.tsv
printf 'AM05\tonca\tcerrado\t950000\n'           >> amostras.tsv
printf 'AM06\tmico\tsolo\t1200000\n'             >> amostras.tsv
# -----------------------------------------------------------------------------


# --- 1. Espiar os arquivos sem abri-los --------------------------------------
head especies.fasta            # primeiras 10 linhas
head -n 4 especies.fasta       # só as 4 primeiras
wc -l especies.fasta           # quantas linhas?
cat amostras.tsv               # ver a tabela inteira (é pequena)


# --- 2. grep: encontrar padrões ----------------------------------------------
grep ">" especies.fasta        # só os cabeçalhos
grep -c ">" especies.fasta     # CONTAR sequências (= número de cabeçalhos)
grep -v ">" especies.fasta     # o inverso: só as linhas de sequência
grep -i "onca" especies.fasta  # ignorando maiúsculas/minúsculas


# --- 3. Pipes |: encadear comandos -------------------------------------------
grep ">" especies.fasta | head      # cabeçalhos, e então os primeiros
grep ">" especies.fasta | wc -l     # contar cabeçalhos (mesmo que grep -c)


# --- 4. cut + sort + uniq: resumir colunas -----------------------------------
cut -f 2 amostras.tsv                    # a 2ª coluna (espécie)
cut -f 2 amostras.tsv | sort             # ordenada
cut -f 2 amostras.tsv | sort | uniq      # valores únicos
cut -f 2 amostras.tsv | sort | uniq -c   # quantas amostras por espécie


# --- 5. sed: substituir em fluxo ---------------------------------------------
sed 's/onca/onça/' especies.fasta        # substitui (não altera o arquivo)
sed '1d' amostras.tsv                     # imprime sem a 1ª linha (cabeçalho)


# --- 6. awk: trabalhar por colunas -------------------------------------------
awk -F'\t' '{print $1}' amostras.tsv             # 1ª coluna (id)
awk -F'\t' '{print $2, $4}' amostras.tsv         # espécie e nº de reads
awk -F'\t' 'NR>1 && $4 > 1000000' amostras.tsv   # reads > 1 milhão (NR>1 pula o cabeçalho)
awk -F'\t' '$3 == "solo"' amostras.tsv           # filtrar por local = solo


# --- 7. Redirecionamento: salvar resultados ----------------------------------
grep ">" especies.fasta > cabecalhos.txt   # >  cria/sobrescreve
cat cabecalhos.txt                          # conferir o que foi salvo


# --- 8. Loop for: repetir em vários arquivos ---------------------------------
for arquivo in *.fasta
do
  echo "Sequências em $arquivo:"
  grep -c ">" "$arquivo"
done


# --- 9. Juntando tudo: uma análise numa linha --------------------------------
# Quantas amostras de cada local têm mais de 1 milhão de reads?
awk -F'\t' 'NR>1 && $4 > 1000000 {print $3}' amostras.tsv | sort | uniq -c


# =============================================================================
#  Pense: cada peça é simples; o poder vem de combiná-las com pipes.
#  grep · cut · sort · uniq · sed · awk · for  →  qualquer manipulação de dados.
# =============================================================================
