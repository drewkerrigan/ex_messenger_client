defmodule ExMessengerClient.Mixfile do
  use Mix.Project

  def project do

    IO.puts System.get_env("HELO")
    [ app: :ex_messenger_client,
      version: "0.0.1",
      deps: deps,
#      escript_name: :"yeahboy",
      escript_emu_args: "%%!-sname client\n"]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat.git" }
  defp deps do
    []
  end
end