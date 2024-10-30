classdef CustomerCluster
    properties
        %core properties for each cluster to have
        members = []; % all members
        mergeHistory = [] % history of previouse node sizes merged in
        size = 1 % member count
        center = [] % the center point of this cluster
    end
    methods
        %constructor
        function obj = CustomerCluster(member)
            obj.members = member;
            obj.center = member;
        end
    end
end