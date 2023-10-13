readRenviron('.Renviron')

pheno=aws.s3::s3read_using(FUN=readr::read_table,
                           object = 'jaime/input/pheno2.txt',
                           bucket = Sys.getenv('bucket'))

snp=aws.s3::s3read_using(FUN=readr::read_table,
                         object = 'jaime/input/geno.hmp.txt',
                         bucket = Sys.getenv('bucket'))

# covar=aws.s3::s3read_using(FUN=readr::read_table,
#                            object = 'jaime/input/covar.txt',
#                            bucket = Sys.getenv('bucket'))



readr::write_tsv(pheno,'tmp/pheno.txt')
readr::write_tsv(snp,'tmp/geno.hmp.txt')
# readr::write_tsv(covar,'tmp/covar.txt')