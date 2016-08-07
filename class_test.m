classdef class_test <handle
    properties (SetAccess = public)
        a;
    end
    methods
        function test_a(obj)
            b = obj.a;
            b = b+2;
        end
    end
end
            
            
        
        