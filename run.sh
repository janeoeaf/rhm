mkdir -p tmp
mkdir -p output



#---download file
Rscript 0_download_files.R

#--- convert file
tassel-5-standalone/run_pipeline.pl -h ./tmp/geno.hmp.txt -export ./tmp/geno -exportType VCF
./plink --vcf ./tmp/geno.vcf --freq --make-bed --out tmp/geno
./plink --bfile ./tmp/geno --maf 0.05 --make-bed --out tmp/geno

#----LD
nchr=11
for((i=1;i<=$nchr;i++))
  do
  ./plink --bfile ./tmp/geno  --chr $i --r2 inter-chr --ld-window-r2 0 --out ./tmp/geno\_chr$i --thread-num 3
done

Rscript LDdecay.R
Rscript maf.R
Rscript pca.R


Rscript 1_create_windows.R
Rscript 2_make_grm.R
Rscript 3_rhm.R
Rscript 4_plot_rhm.R
Rscript 6_varcomp.R
Rscript 5_sync.R