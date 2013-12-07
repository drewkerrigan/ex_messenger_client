defmodule ExMessengerClient do

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    switches =
      [
       help: :boolean,
       server: :string,
       nick: :string
      ]

    aliases =
      [
       h: :help,
       s: :server,
       n: :nick
      ]

    options = OptionParser.parse(args, switches: switches, aliases: aliases)

    IO.inspect options

    case options do
      { [ help: true], _, _}            -> :help
      { [ server: server], _, _}        -> [server]
      { [ server: server, nick: nick], _, _} -> [server, nick]
      _                              -> :help
    end
  end

  def process(:help) do
    IO.puts """
      Usage:
        ./ex_messenger_client -s server_name [-n nickname]

      Options:
        -s, --server = fully qualified server name
        -n, --nick   = nickname (optional, you will be promted if not specified)

      Example:
        ./ex_messenger_client -s server@192.168.1.1 -n dr00

      Options:
        -h, [--help]      # Show this help message and quit.
    """
    System.halt(0)
  end

  def process([server]) do
    process([server, nil])
  end

  def process([server, nick]) do
    server = list_to_atom(bitstring_to_list(server))

    IO.puts "Connecting to server[#{server}]..."
    IO.puts Node.self()
    IO.inspect Node.set_cookie(Node.self(), :"chocolate-chip")
    IO.inspect Node.get_cookie()
    IO.inspect Node.connect(server)

    IO.puts "Connected"

    nick = case nick do
             nil ->
               IO.puts "Nickname: "
               IO.read :line
             n -> n
           end

    IO.puts "Joining the chatroom"
    IO.inspect :gen_server.call({:message_server, server}, {:connect, nick})
    IO.puts "Joined the chatroom, type /help for options"
    # Start genserver to handle input / output from server
    input_loop([server, nick])
  end

  def input_loop([server, nick]) do
    IO.puts "#{Node.self()}->#{server}: "
    command = IO.read :line
    handle_command(command, [server, nick])

    input_loop([server, nick])
  end

  def handle_command(command, [server, nick]) do
    case command do
      "/help\n" ->
        IO.puts "Avaliable commands: /leave, /join, /pm, or just type a message to send"
      "/leave\n" ->
        :gen_server.call({:message_server, server}, {:disconnect, nick})
        IO.puts "You have exited the chatroom, you can rejoin with /join or quit with <Control>-c a"
      "/join\n" ->
        IO.puts "Joining the chatroom"
        IO.inspect :gen_server.call({:message_server, server}, {:connect, nick})
        IO.puts "Joined the chatroom"
      "/pm\n" ->
        IO.puts "To (nickname): "
        to = IO.read(:line)
        IO.puts "Msg: "
        message = IO.read(:line)
        :gen_server.cast({:message_server, server}, {:private_message, nick, to, message})
      message ->
        :gen_server.cast({:message_server, server}, {:say, nick, message})
    end
  end

end
