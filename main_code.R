library(jsonlite)
########################LOAD DATA################################
# Set the directory path where the JSON files are located
directory_path <- "C:/Users/theib/OneDrive/Documentos/Network_Analysis_Kaggle_Star_Wars/data" #CHANGE IT WITH YOUR DATA PATH

# Get the list of all JSON files in the directory
json_files <- list.files(path = directory_path, pattern = "*.json", full.names = TRUE)



# Choose the desired JSON file
desired_file <- json_files[22]

# Load the JSON file into R
json_data <- fromJSON(desired_file)

# Access the nodes and edges

library("readxl")

nodes <- read_excel("nodes.xlsx")

edges <- json_data$links


#Hola eloy guapeton



#####################DATA ANALYSIS##########################333
library(igraph)
library(tidyr)
library(ggplot2)
library(dplyr)

# Create a graph from the data
network <- graph_from_data_frame(edges, vertices = nodes, directed = FALSE)
E(network)$weight <- edges$value


# Set the color of each node
V(network)$color <- nodes$colour

# Set the label of each node
V(network)$label <- nodes$name.real

# Plot the graph
#layout 
m2 <- layout_nicely(network)

plot(network,edge.color = 'grey',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

######################## NETWORK PROPERTIES ##########################
# Order and size of the network 
cat("Order of the network:", gorder(network), "\n")
cat("Size of the network:", gsize(network), "\n")
#Fardest vertices
farthest.nodes(network, weights = E(network)$weight)
geodesic_distance <- shortest.paths(network)

get.diameter(network)

degree(network)
plot(table(degree(network)))

cat("Average degree:", mean(degree(network)), "\n")


# Top ten characters with the most screenplay
# Assuming you have a dataframe named 'nodes'
# Subset the dataframe to include only the top characters based on 'value'
top_nodes <- nodes[order(nodes$value, decreasing = TRUE),][1:10,]

print(top_nodes)
# Create a barplot using 'name.real' as labels and 'value' as heights
barplot(top_nodes$value, 
        names.arg = top_nodes$name.real, 
        main = "Top Characters", 
        xlab = "Character Name", 
        ylab = "Nodes Value", 
        col = "steelblue")


#################Adjacency matrix #############################
# Get the adjacency matrix and convert to long format
adj_matrix <- as_adjacency_matrix(network,attr = "weight",sparse = T)

# Set the row and column names of the matrix to the node names
rownames(adj_matrix) <- nodes$name.real
colnames(adj_matrix) <- nodes$name.real

# Plot the matrix
library(corrplot)
corrplot(as.matrix(adj_matrix),  method = 'shade',is.corr = FALSE,col.lim = c(0,max(max(as.matrix(adj_matrix)))), order = 'AOE', diag = FALSE, tl.cex = 0.3,col = COL1('YlOrBr', 10),tl.col = 'black')
################### Chord diagram ############################
library(chorddiag)
chorddiag(as.matrix(adj_matrix), groupColors = nodes$colour,showTicks = FALSE, margin = 170, groupnameFontsize = 12)
################### Subgraphs of different movies ################
subnetwork1 <- subgraph.edges(network, E(network)[E(network)$weight>max(E(network)$weight)*0.95]) #0.5 2 subgraphs, 0.3 ep 7 and ep 1-6, 0.2 main characters
m2 <- layout_nicely(subnetwork1)
#m2 <- layout_as_tree(subnetwork1)
plot(subnetwork1,edge.color = 'grey',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

################### Siths network ################
Siths_network <- delete.vertices(network, V(network)[V(network)$color != '#000000'])
m2 <- layout_nicely(Siths_network)
plot(Siths_network)
################### Heroes network ################
Heroes_network <- delete.vertices(network, V(network)[V(network)$color == '#000000'])
m2 <- layout_nicely(Heroes_network)
plot(Heroes_network,edge.color = 'black',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

