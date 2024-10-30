classdef CustomerCluster < handle
    properties
        %core properties for each cluster to have
        members = []; % all members
        children = [] % history of previouse node sizes merged in
        size = 1 % member count
        center = [] % the center point of this cluster
        customerId = 0; %id to refer to the cluster
    end
    methods
        %constructor
        function obj = CustomerCluster(member,id)
            obj.members = member;
            obj.center = member;
            obj.customerId = id;
        end
        %merge a cluster into this cluster and records historical data to
        %track what happend
        function mergeCluster(obj,cluster)
            %add itsled and the passed in cluster as a child
            obj.children = [obj,cluster];

            %combined the members
            obj.members = vertcat(obj.members,cluster.members);

            %update the size
            obj.size = height(obj.members);
            
            % update the center
            obj.center = mean(obj.members,1);

        end
    end
end