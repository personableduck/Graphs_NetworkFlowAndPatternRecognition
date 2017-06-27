# Problem 1
g <- read.graph("c:/sorted_directed_net.txt", directed=TRUE, format="ncol")
is.connected(g)

clusterlist <- clusters(g)
size <- clusterlist$csize
numcluster <- clusterlist$no

# Find the GCC
GCCindex <- which.max(size)
nonGCCnodes<-(1:vcount(g))[clusterlist$membership!=GCCindex] #compares the membership vector with the index , then multiply TRUE with node list
GCCfinal <- delete.vertices(g,nonGCCnodes)


# Problem 2
indegree <- degree.distribution(GCCfinal,mode = "in")
outdegree <- degree.distribution(GCCfinal,mode = "out")
#totaldegree <- degree.distribution(GCCfinal,mode = "total")

# Make Plot the Degree Distribution
h_in <- hist(indegree, breaks = 10, plot=FALSE)
h_in$counts = h_in$counts/sum(h_in$counts)
plot(h_in, ylab="degree.distribution")

h_out <- hist(outdegree, breaks = 10, plot=FALSE)
h_out$counts = h_out$counts/sum(h_out$counts)
plot(h_out, ylab="degree.distribution")


#plot(g)

# Problem 3
undirected_g_option1 <- as.undirected(g, mode = "each")
undirected_g_option2 <- as.undirected(g)
edgelist <- get.edgelist(undirected_g_option2)

apply(E(undirected_g_option2)$weight, 1, function(x) x/2)

E(undirected_g_option2)$weight

for (i in 1:nrow(edgelist)) {
  tmp_weight <- 0
  w1 <- 0
  w2 <- 0
  
  w1 <- E(g) [(which(V(g)$name == edgelist[i,1]))%->%(which(V(g)$name == edgelist[i,2]))] $weight
  w2 <- E(g) [(which(V(g)$name == edgelist[i,2]))%->%(which(V(g)$name == edgelist[i,1]))] $weight
  if (w1 > 0 && w2 > 0) {
    tmp_weight <- sqrt(w1*w2)
  } else {
    tmp_weight <- w1 + w2
  }
  
  
  E(undirected_g_option2) [(which(V(g)$name == edgelist[i,1]))%--%(which(V(g)$name == edgelist[i,2]))] $weight <- tmp_weight
  
  print(i)
  
}

is.directed(undirected_g_option1)
is.directed(undirected_g_option2)

ecount(undirected_g_option1)
ecount(undirected_g_option2)


# For Option 1 - Label Propagation
# Label Propagation Community
lp_op1 <- label.propagation.community(undirected_g_option1)
png(file="P3_op1_labelpropagation.png",width=1000,height=1000)
plot(lp_op1,undirected_g_option1,layout=layout.fruchterman.reingold, vertex.size=5, vertex.label.cex=0.6, edge.arrow.size=.2)
dev.off()

# For Option 2 - Fast greedy & Label Propagation
# Fast greedy Community
fg_op2 <- fastgreedy.community(undirected_g_option2)
png(file="P3_op2_fastgreedy.png",width=1000,height=1000)
plot(fg_op2,undirected_g_option2,layout=layout.fruchterman.reingold, vertex.size=5, vertex.label.cex=0.6, edge.arrow.size=.2)
dev.off()


# Label Propagation Community
lp_op2 <- label.propagation.community(undirected_g_option2)
png(file="P3_op2_labelpropagation.png",width=1000,height=1000)
plot(lp_op2,undirected_g_option2,layout=layout.fruchterman.reingold, vertex.size=5, vertex.label.cex=0.6, edge.arrow.size=.2)
dev.off()


# Problem 4
largest_community <- which.max(sizes(fg_op2))
sub_community_network <- induced.subgraph(undirected_g_option2, which(membership(fg_op2) == largest_community))
fg_sub_community <- fastgreedy.community(sub_community_network)
dendPlot(fg_sub_community)


# Problem 5
index_large_sub <- which(sizes(fg_sub_community)>100)


# Problem 6
pr <- page.rank (g, algo = "prpack", vids = V(g), directed = TRUE, damping = 0.85, personalized = NULL, weights = NULL, options = NULL)
ppr <- page.rank (g, algo = "prpack", vids = V(g), directed = TRUE, damping = 0.85, personalized = pr$vector, weights = NULL, options = NULL)
sorted_prob <- sort(ppr$vector,decreasing = TRUE)



M_vector <- rep(0,max(fg_op2$membership))

for (i in 1:30) {
  m_vector <- rep(0,max(fg_op2$membership))
  member <- fg_op2$membership [[as.numeric(attributes(sorted_prob)[[1]][i])]]
  m_vector[[member]] <- 1
  v_prob <- sorted_prob[[i]]
  M_vector <- M_vector + v_prob*m_vector
}

plot(M_vector)

