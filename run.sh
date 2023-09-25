mkdir -p tmp
mkdir -p src
mkdir -p output

cd src
git clone https://bitbucket.org/tasseladmin/tassel-5-standalone.git

wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip && \
unzip -o plink_linux_x86_64_20230116.zip
cd ..

#---download file
Rscript 0_download_files.R

#--- convert file
./src/tassel-5-standalone/run_pipeline.pl -h ./tmp/geno.hmp.txt -export ./tmp/geno -exportType VCF
./src/plink --vcf ./tmp/geno.vcf --maf 0.05 --make-bed --out tmp/geno

Rscript 1_create_windows.R
Rscript 2_make_grm.R
Rscript 3_rhm.R
Rscript 4_plot_rhm.R

