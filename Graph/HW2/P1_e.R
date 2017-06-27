g <- random.graph.game(1000,0.01,directed=F)

plot(degree.distribution(g))


num_walker <- 1

nei_deg <- c(0)

for (i in 1:100) {
  rw <- netrw(g, num_walker, start.node = sample(0:(vcount(g) - 1) + as.integer((sessionInfo())$otherPkgs$igraph$Version >= "0.6"), num_walker, replace = TRUE), damping = 1, weights = NULL, T = i, seed = NULL, output.walk.path = TRUE, output.walkers = 0:( num_walker - 1), output.visit.prob = TRUE, output.nodes = 0:(vcount(g) - 1), output.device = "memory", walk.path.file = "walk_path.txt", visit.prob.file = "visit_prob.txt", local.pagerank = FALSE, teleport.prob = NULL) 
  
  nei_deg[i] <- degree(g, rw[[2]][i,1])
}


# Make Plot the Degree Distribution
h <- hist(nei_deg, breaks = 10, plot=FALSE)
h$counts = h$counts/sum(h$counts)
plot(h, ylab="degree.distribution")