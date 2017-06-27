g <- random.graph.game(1000,0.01,directed=F)

num_walker <- 100

rw <- netrw(g, num_walker, start.node = sample(0:(vcount(g) - 1) + as.integer((sessionInfo())$otherPkgs$igraph$Version >= "0.6"), num_walker, replace = TRUE), damping = 0.85, weights = NULL, T = 100, seed = NULL, output.walk.path = TRUE, output.walkers = 0:( num_walker - 1), output.visit.prob = TRUE, output.nodes = 0:(vcount(g) - 1), output.device = "memory", walk.path.file = "walk_path.txt", visit.prob.file = "visit_prob.txt", local.pagerank = FALSE, teleport.prob = NULL) 

degree_g <- degree(g)

plot(rw[[1]])
plot(degree_g)

cor(degree_g,rw[[1]])
plot(degree_g~rw[[1]])