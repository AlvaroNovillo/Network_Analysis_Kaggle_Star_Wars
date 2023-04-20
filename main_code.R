library(jsonlite)
########################LOAD DATA################################
# Set the directory path where the JSON files are located
directory_path <- "C:/Users/theib/OneDrive/Documentos/Network_Analysis_Kaggle_Star_Wars/data" #CHANGE IT WITH YOUR DATA PATH

# Get the list of all JSON files in the directory
json_files <- list.files(path = directory_path, pattern = "*.json", full.names = TRUE)

# Display the list of JSON files
print(json_files)

# Choose the desired JSON file
desired_file <- json_files[22]

# Load the JSON file into R
json_data <- fromJSON(desired_file)

# Access the nodes and edges
nodes <- json_data$nodes
edges <- json_data$links
nodes$name.real = nodes$name
nodes$name = c(0:(length(nodes$name)-1))




#####################DATA ANALYSIS##########################333
library(igraph)

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

plot(network,edge.color = 'black',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

######################## NETWORK PROPERTIES ##########################
# Order and size of the network 
cat("Order of the network:", gorder(network), "\n")
cat("Size of the network:", gsize(network), "\n")
#Fardest vertices
farthest.nodes(network, weights = E(network)$weight)
geodesic_distance <- shortest.paths(network, uncon)

get.diameter(network)


################### Subgraphs of different movies ################
subnetwork1 <- subgraph.edges(network, E(network)[E(network)$weight>max(E(network)$weight)*0.2]) #0.5 2 subgraphs, 0.3 ep 7 and ep 1-6, 0.2 main characters
m2 <- layout_nicely(subnetwork1)
plot(subnetwork1,edge.color = 'black',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

################### Siths network ################
Siths_network <- delete.vertices(network, V(network)[V(network)$color != '#000000'])
m2 <- layout_nicely(Siths_network)
plot(Siths_network)
################### Siths network ################
Heroes_network <- delete.vertices(network, V(network)[V(network)$color == '#000000'])
m2 <- layout_nicely(Heroes_network)
plot(Heroes_network,edge.color = 'black',layout = m2,edge.width = (edges$value - min(edges$value))/(max(edges$value) - min(edges$value))*(7-2) + 2 , vertex.size=(nodes$value - min(nodes$value))/(max(nodes$value) - min(nodes$value))*(20-5) + 7)

