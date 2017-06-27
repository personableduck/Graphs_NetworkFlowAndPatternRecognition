# Problem 4 (a)
g_fire <- forest.fire.game(10000, fw.prob=0.37, bw.factor=0.32/0.37, directed=TRUE)
plot(degree.distribution(g_fire,mode="in"))
plot(degree.distribution(g_fire,mode="out"))


# Problem 4 (b)
# Calculate Diameter
diam_unconnected_true = diameter(g, unconnected=TRUE)
diam_unconnected_false = diameter(g, unconnected=FALSE)
print(diam_unconnected_true)
print(diam_unconnected_false)


# Problem 4 (c)
# Clustering Graph
clusterlist <- clusters(g_fire)
size <- clusterlist$csize
numcluster <- clusterlist$no

# Find Community structure of Overall Graph
communityobj <- walktrap.community(g_fire, merges=TRUE, modularity=TRUE, membership=TRUE, weights=NULL)
# Modularity & Sizes of Communities
modularityval <- modularity(communityobj)
sizeofmembers <- sizes(communityobj)


# Find the GCC
GCCindex <- which.max(size)
nonGCCnodes<-(1:vcount(g_fire))[clusterlist$membership!=GCCindex] #compares the membership vector with the index , then multiply TRUE with node list
GCCfinal <- delete.vertices(g_fire,nonGCCnodes)

# Find Community structure of GCC
communityobjGCC = walktrap.community(GCCfinal, merges=TRUE, modularity=TRUE, membership=TRUE, weights=NULL)
# Modularity & Sizes of Communities
modularityvalGCC = modularity(communityobjGCC)
sizeofmembersGCC= sizes(communityobjGCC)

print(modularityval)
print(modularityvalGCC)
print(sizeofmembers)
print(sizeofmembersGCC)
