library(jsonlite)
########################LOAD DATA################################
# Set the directory path where the JSON files are located
directory_path <- "C:/Users/theib/OneDrive/Documentos/Network_Analysis_Kaggle_Star_Wars/data" #CHANGE IT WITH YOUR DATA PATH

# Get the list of all JSON files in the directory
json_files <- list.files(path = directory_path, pattern = "*.json", full.names = TRUE)

# Display the list of JSON files
print(json_files)

# Choose the desired JSON file
desired_file <- json_files[1]

# Load the JSON file into R
json_data <- fromJSON(desired_file)

# Access the nodes and edges
nodes <- json_data$nodes
edges <- json_data$links




#####################DATA ANALYSIS##########################333
library(igraph)
# Create a graph from the data
network <- graph_from_data_frame(edges, directed = F) %>%
  set_vertex_attr("name", value = nodes$name) %>%
  set_vertex_attr("color", value = nodes$colour)
E(network)$weight <- edges$value


# Set the color of each node
V(network)$color <- nodes$colour

# Set the label of each node
V(network)$label <- 
V(network)
# Plot the graph
#A = as_adjacency_matrix(network, attr="weight")
plot(network)
