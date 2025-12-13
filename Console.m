classdef Console
    properties
        ignoreErrors
        rhxClient

        killFlag = false
    end

    methods
        function obj = Console(rhxClient, args)
            arguments
                rhxClient RHXClient
                args.IgnoreErrors logical = true
            end

            obj.ignoreErrors = args.IgnoreErrors;
            obj.rhxClient = rhxClient;
        end

        function run(obj)
            fprintf("Running console. \n=====================\n\n");
            
            while ~obj.killFlag
                command = input("Enter a command (type exit or press Ctrl+C to exit): ", "s");
                obj = obj.parseCommand(command);
            end
        end

        function obj = parseCommand(obj, command)
            if lower(command) == "exit"
                obj.killFlag = true;
                fprintf("Bye\n");
            end

            
        end
    end
end