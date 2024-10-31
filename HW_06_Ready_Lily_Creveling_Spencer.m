% Runs all parts of the assignment on a given file
function HW_06_Ready_Lily_Creveling_Spencer(file_in)
    % Turn the csv into a table
    data = readtable(file_in);
    % remove the Record IDs
    data = removevars(data,"ID");
    % Run Part A
    ccc_pack_mat = Part_A(data);
    % Add nice labels to the columns and rows for easy comparison
    absolute = abs(ccc_pack_mat);
    labels = data.Properties.VariableNames(:);
    abs_labeled = array2table(absolute,'VariableNames',labels);
    abs_labeled.Properties.RowNames = labels(:);
    ccc_labeled = array2table(ccc_pack_mat,'VariableNames',labels);
    ccc_labeled.Properties.RowNames = labels(:);
    % Run Part B
    data = table2array(data);
    Part_B(data);
end

% Completes part A of the assignment
% Uses a package/built in command to funs the cross-correlation
% coefficients of all attributes of a given matrix. 
% Records the values to two decimal points.
function att_mat = Part_A(data)
    data = table2array(data);
    % Get the cross correlational coefficient of all the attributes
    att_mat = corrcoef(data);
    % Round to the nearest 2 decimal points
    att_mat = round(att_mat,2);
end

% Completes part B of the assignment
% Uses our built agglomeration clustering to group the data into clusters
% using the manhattan distance and the center of mass to determine distance
% and linkage
function Part_B(data)
    
    % Cluster the guests into groups as follows:
    % a. At the start of agglomerative clustering, assign each record to 
    % its own cluster prototype. Suppose we have 1000+ records. So, you 
    % start with 1000-plus clusters and 1000-plus prototypes of those 
    % clusters.

    %creates a new cluster for each customer
    clusters = {};
    for customerId = 1:height(data)
        clusters = [clusters, CustomerCluster(data(customerId,:),customerId)];
    end

    %loop through all  rows and add them to a cluster
  
    % And use the distance between these centers as the linkage method.
    
    % d. Note: At each step of clustering, two clusters are merged together.
    % Track the size of the smallest of the two clusters that are merged together.

    smallest = [];
    for clusterCount = 1:width(clusters)-1
        %extract the center from all clusters
        % c. Use the center of mass as the prototype center, the center of mass
        % of a set of records, to represent its center location in data space.  
        centers = vertcat(clusters.center);
    
        %calculate the distances
        %Use the Manhattan distance between cluster centers as the distance metric.
        distances = pdist2(centers,centers,'cityblock');
    
        %mask out the diagonal so we dont pick it
        distances(logical(eye(size(distances)))) = Inf;
    
        %pick the id of the 2 closest customer (can be speed up)
        min_dist = min(distances,[],'all');
        [customer_id_left,customer_id_right] = find(distances == min_dist,1);
    
        %merge the right customer custer into the left customer cluster
        clusterLeft = clusters(customer_id_left);
        clusterRight = clusters(customer_id_right);
        
        % Track the size of the smallest of the two clusters that are 
        % merged together.

        if size(clusterLeft.members,1) < size(clusterRight.members,1)
            smallest = cat(1,smallest,[size(clusterLeft.members,1)]);
        else
            smallest = cat(1,smallest,[size(clusterRight.members,1)]);
        end

        clusterLeft.mergeCluster(clusterRight);
        
        %delete the right cluster as it has been moerged away
        clusters(customer_id_right) = [];
        % Create a dendrogram with the last 20 clusters
        if size(clusters,2) == 20
            Dendrogram(clusters);
        end
    end
    % Find the centroids of the four clusters
    parent = clusters(1).children;
    cent_one = Find_Centroid(parent{1,1}.children{1,1});
    cent_two = Find_Centroid(parent{1,1}.children{1,2});
    cent_three = Find_Centroid(parent{1,2}.children{1,1});
    cent_four = Find_Centroid(parent{1,2}.children{1,2});
end

% Given a cluster find the centroid
function centroid = Find_Centroid(cluster)
    center = cluster.center;
    smallest = [-1  Inf];
    % Look through all points
    for index = 1:size(cluster.members,1)
        % Check the distance to the center
        dist = pdist2(center,cluster.members(index,:));
        % If it's closest, store it as the centroid
        if dist < smallest(:,2)
            smallest = [index dist];
        end
    end
    % Return the item that was found to be closest
    centroid = cluster.members(smallest(:,1),:); 
end

%Creates a dendrogram with the last 20 clusters, and returns the dendrogram
function dendro = Dendrogram(clusters)
    figure;
    % Use the centers of the clusters
    centers = vertcat(clusters.center);
    % Use the manhattan distance
    distances = pdist2(centers,centers,'cityblock');
    link = linkage(distances,"centroid");
    % reorder the leaves so that our graph looks nice :)
    leaforder = optimalleaforder(link,distances);
    % create the dendrogram
    dendro = dendrogram(link,Reorder=leaforder);
end