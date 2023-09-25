
aws.s3::s3sync(
  path = "./tmp/",
  bucket=Sys.getenv('bucket'),
  prefix = "jaime/rhm/tmp/",
  direction = c("upload"),
  verbose = TRUE,
  create = FALSE
)

aws.s3::s3sync(
  path = "./output/",
  bucket=Sys.getenv('bucket'),
  prefix = "jaime/rhm/output/",
  direction = c("upload"),
  verbose = TRUE,
  create = FALSE
)

