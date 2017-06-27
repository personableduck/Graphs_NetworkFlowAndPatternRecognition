# Problem 1 (a)
p <- 0.05  # Change p value to 0.05, 0.1
g <- erdos.renyi.game(1000, p, "gnp", directed = FALSE, loops = FALSE)
plot(degree.distribution(g))

# Problem 1 (b)
connectedindicator = is.connected(g) #check connected or not

diam_unconnected_false= diameter(g, unconnected=FALSE)
diam_unconnected_true = diameter(g, unconnected=TRUE)

# Problem 1 (c)
# Run (a) Several Times by changing 'p'

