function main()
    client = RHXClient(ServerPort=5000);

    console = Console(client);
    console.run();
end