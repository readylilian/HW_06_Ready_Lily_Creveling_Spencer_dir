% Runs all parts of the assignment on a given file
function HW_06_Ready_Lily_Creveling_Spencer(file_in)
    % Turn the csv into a table
    data = readtable(file_in);
    % remove the Record IDs
    data = removevars(data,"ID");
    % Run Part A
    ccc_pack_mat = Part_A(data);
    % Add nice labels to the columns and rows for east comparison
    absolute = abs(ccc_pack_mat);
    labels = data.Properties.VariableNames(:);
    abs_labeled = array2table(absolute,'VariableNames',labels);
    abs_labeled.Properties.RowNames = labels(:);
    ccc_labeled = array2table(ccc_pack_mat,'VariableNames',labels);
    ccc_labeled.Properties.RowNames = labels(:);
    ccc_labeled;
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
function Part_B(file_in)
    % Cluster the guests into groups as follows:
    % a. At the start of agglomerative clustering, assign each record to 
    % its own cluster prototype. Suppose we have 1000+ records. So, you 
    % start with 1000-plus clusters and 1000-plus prototypes of those 
    % clusters.
    
    % b. Use the Manhattan distance between cluster centers as the distance metric.
    
    % c. Use the center of mass as the prototype center, the center of mass
    % of a set of records, to represent its center location in data space. 
    % And use the distance between these centers as the linkage method.
    
    % d. Note: At each step of clustering, two clusters are merged together.
    % Track the size of the smallest of the two clusters that are merged together.
end

function Dendrogram(file_in)
    figure;

end