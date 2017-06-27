g <- random.graph.game(1000,0.01,directed=F)

avg_dist <- c(0)
var_dist <- c(0)
std_dist <- c(0)
num_walker <- 100
shortest_paths <- shortest.paths(g)
for (i in 1:100) {
  rw <- netrw(g, num_walker, start.node = sample(0:(vcount(g) - 1) + as.integer((sessionInfo())$otherPkgs$igraph$Version >= "0.6"), num_walker, replace = TRUE), damping = 1, weights = NULL, T = i, seed = NULL, output.walk.path = TRUE, output.walkers = 0:( num_walker - 1), output.visit.prob = TRUE, output.nodes = 0:(vcount(g) - 1), output.device = "memory", walk.path.file = "walk_path.txt", visit.prob.file = "visit_prob.txt", local.pagerank = FALSE, teleport.prob = NULL) 
  
  tmp_dist <- c(0)
  for (j in 1:num_walker) {
    tmp_dist[j] <- shortest_paths[rw[[2]][1,j], rw[[2]][i,j]]+1
  }
  
  avg_dist[i] <- mean(tmp_dist)
  var_dist[i] <- mean((tmp_dist-mean(tmp_dist))^2) # Variance
  std_dist[i] <- sqrt(mean((tmp_dist-mean(tmp_dist))^2)) # Standard Deviation
}


plot(avg_dist)
plot(var_dist)
plot(std_dist)