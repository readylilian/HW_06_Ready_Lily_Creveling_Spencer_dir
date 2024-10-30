classdef CustomerCluster < handle
    properties
        %core properties for each cluster to have
        members = []; % All members
        children = {} % History of previouse node sizes merged in
        size = 1 % Member count
        center = [] % The center point of this cluster
        customerId = 0; %Id to refer to the cluster
    end
    methods
        %constructor
        function obj = CustomerCluster(member,id)
            obj.members = member;
            obj.center = member;
            obj.customerId = id;
        end

        %deep copy
        function newObj = deepCopy(obj)
            % Create a new instance of the class
            newObj = CustomerCluster([], 0);
            
            % Copy primitives
            newObj.members = obj.members;  
            newObj.size = obj.size;        
            newObj.center = obj.center;    
            newObj.customerId = obj.customerId; 
            
            % Recursively deep copy the children if any exist
            if ~isempty(obj.children)
                newObj.children{1} = obj.children{1}.deepCopy(); % Recursive copy
                newObj.children{2} = obj.children{2}.deepCopy(); % Recursive copy
            end
        end

        % Merge a cluster into this cluster and records historical data to
        % Track what happend
        function mergeCluster(obj,cluster)
            %add itsled and the passed in cluster as a child
            deepCopy = obj.deepCopy();
            obj.children = {deepCopy,cluster};

            % Combined the members
            obj.members = vertcat(obj.members,cluster.members);

            % Update the size
            obj.size = height(obj.members);

            % Update the center
            obj.center = mean(obj.members,1);

        end
        % Function to print out the tree as a string
        function cmdDisp(obj,fpointer)
            fprintf(fpointer, "" + obj.customerId);
            if ~isempty(obj.children)
                fprintf(fpointer, " -> " + obj.children{1}.customerId + ", " +  obj.children{2}.customerId + "\n");
                obj.children{1}.cmdDisp(fpointer)
                obj.children{2}.cmdDisp(fpointer)
            end
        end
    end
end