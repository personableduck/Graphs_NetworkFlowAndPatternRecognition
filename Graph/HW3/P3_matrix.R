file <- read.table("c:/sorted_directed_net.txt",sep="\t")

max(file[3])

mat <- matrix(0,nrow=10500,ncol=10500)

li <- as.list(file)

for (i in 1:length(li$V1)) {
  mat[li$V1[i],li$V2[i]] <- li$V3[i]
}

isSymmetric(mat)
mat_tr <- t(mat)
new_weight <- sqrt(mat * mat_tr)

lower_tri <- lower.tri(new_weight, diag=FALSE) * new_weight

