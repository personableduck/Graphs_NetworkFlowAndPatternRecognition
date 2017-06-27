# Problem 1
g <- read.graph("c:/down/sorted_directed_net.txt", directed=TRUE, format="ncol")
is.connected(g)

# Clustering
clusterlist <- clusters(g)
size <- clusterlist$csize
numcluster <- clusterlist$no

# Find the GCC
GCCindex <- which.max(size)
nonGCCnodes<-(1:vcount(g))[clusterlist$membership!=GCCindex] #compares the membership vector with the index , then multiply TRUE with node list
GCCfinal <- delete.vertices(g,nonGCCnodes)

cat(sprintf("Original Network            Vertex:%d  Edge:%d\nGiant Connected Component   Vertex:%d  Edge:%d",vcount(g),ecount(g),vcount(GCCfinal),ecount(GCCfinal)))





# Problem 2
plot(degree.distribution(GCCfinal,mode = "in"), main="In Degree Distribution")
plot(degree.distribution(GCCfinal,mode = "out"), main="Out Degree Distribution")

identical(indegree,outdegree)




# Problem 3
undirected_g_option1 <- as.undirected(GCCfinal, mode = "each")
undirected_g_option2 <- simplify(undirected_g_option1, remove.multiple = TRUE, edge.attr.comb=list(weight="prod"))
E(undirected_g_option2)$weight <- sqrt(E(undirected_g_option2)$weight)
is.directed(undirected_g_option1)
is.directed(undirected_g_option2)

cat(sprintf("Undirected Network Option1 Edge : %d\nUndirected Network Option2 Edge : %d",ecount(undirected_g_option1),ecount(undirected_g_option2)))


# For Option 1 - Label Propagation
# Label Propagation Community
lp_op1 <- label.propagation.community(undirected_g_option1)

# For Option 2 - Fast greedy & Label Propagation
# Fast greedy Community
fg_op2 <- fastgreedy.community(undirected_g_option2)
# Label Propagation Community
lp_op2 <- label.propagation.community(undirected_g_option2)

sizes(lp_op1)
sizes(fg_op2)
sizes(lp_op2)





# Problem 4
largest_community <- which.max(sizes(fg_op2))
sub_community_network <- induced.subgraph(undirected_g_option2, which(membership(fg_op2) == largest_community))
fg_sub_community <- fastgreedy.community(sub_community_network)
sizes(fg_sub_community)
dendPlot(fg_sub_community)
plot(fg_sub_community,sub_community_network,
     layout=layout.fruchterman.reingold, 
     vertex.size=3, 
     vertex.label=NA,
     edge.arrow.size=.1
)


# Problem 5
index_large_sub <- which(sizes(fg_op2)>100)
for (i in index_large_sub) {
  sub_community_network <- induced.subgraph(undirected_g_option2, which(membership(fg_op2) == i))
  fg_sub_community <- fastgreedy.community(sub_community_network)
  title <- paste("Community ",i)
  cat("Community ",i,"\n",sizes(fg_sub_community),"\n\n")
  dendPlot(fg_sub_community)
  plot(fg_sub_community,sub_community_network,
       layout=layout.fruchterman.reingold, 
       vertex.size=3, 
       vertex.label=NA,
       edge.arrow.size=.1,
       main=title
  )
}



# Problem 6
M_prob <- matrix(ncol=2,nrow=vcount(GCCfinal))
for (v_iter in 1:vcount(GCCfinal)) {
  tele_prob <- rep(0,vcount(GCCfinal))
  tele_prob[[v_iter]] <- 1
  ppr <- page.rank (GCCfinal, algo = "prpack", vids = V(GCCfinal), directed = TRUE, damping = 0.85, personalized = tele_prob, weights = NULL, options = NULL)
  sorted_prob <- sort(ppr$vector,decreasing = TRUE)
  
  
  M_vector <- rep(0,max(fg_op2$membership))
  
  for (i in 1:30) {
    m_vector <- rep(0,max(fg_op2$membership))
    member <- fg_op2$membership [[which(V(GCCfinal)$name == attributes(sorted_prob)[[1]][i])]]
    m_vector[[member]] <- 1
    v_prob <- sorted_prob[[i]]
    M_vector <- M_vector + v_prob*m_vector
  }

  M_prob[v_iter,1] <- sort(M_vector, TRUE)[1]
  M_prob[v_iter,2] <- sort(M_vector, TRUE)[2]
  
  print(v_iter)
}

difference_prob <- M_prob[,1]-M_prob[,2]
plot(difference_prob)


for (low_diff in 1:5) {
  node_id <- which(difference_prob == sort(difference_prob, FALSE)[low_diff])
  
  tele_prob <- rep(0,vcount(GCCfinal))
  tele_prob[[node_id]] <- 1
  ppr <- page.rank (GCCfinal, algo = "prpack", vids = V(GCCfinal), directed = TRUE, damping = 0.85, personalized = tele_prob, weights = NULL, options = NULL)
  sorted_prob <- sort(ppr$vector,decreasing = TRUE)
  
  
  M_vector <- rep(0,max(fg_op2$membership))
  
  for (i in 1:30) {
    m_vector <- rep(0,max(fg_op2$membership))
    member <- fg_op2$membership [[which(V(GCCfinal)$name == attributes(sorted_prob)[[1]][i])]]
    m_vector[[member]] <- 1
    v_prob <- sorted_prob[[i]]
    M_vector <- M_vector + v_prob*m_vector
  }
  
  title <- paste("Node : ",node_id,"  M-vector")
  plot(M_vector, main=title)
  
}
