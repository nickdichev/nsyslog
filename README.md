# NSyslog

## Description

The goal of this project is to send arbitrary messages to a dynamic number of syslog servers. Currently, the project supports RFC3164 and RFC5424 formatted messages and destinations. However, the only supported protocols are TCP (for RFC3164 messages/destinations) or SSL (for RFC5424 messages/destinations).

An example application that uses this library can be found [here](https://github.com/nickdichev/kafka_syslog).

## Setup

For RFC5424 destinations, a valid certificate is required. For testing a self-signed certificate will suffice. The path to the certificate should be provided at runtime in the `conn_opts` when starting a `NSyslog.Writer`.

Additionally, if you plan to use the `syslog-ng` container provided in this repository for testing you should create a self-signed certificate and drop it in `docker/syslog-ng/certs`. There is more information on this in the "Development" section of this document.

## Usage

To use the library, add the project to your dependencies in `mix.exs`:

```elixir
  defp deps do
    [
      {:nsyslog, git: "https://github.com/nickdichev/nsyslog.git", tag: "0.3.0"}
    ]
  end
```

You can now use the library as follows:

```bash
nsyslog/ $ iex -S mix

iex(1)> alias NSyslog.Writer
iex(2)> alias NSyslog.Writer.{Supervisor, Protocol}

iex(3)> Supervisor.create_writer(%Writer{protocol: Protocol.SSL, host: "localhost", port: 6514, aid: "1"})
iex(4)> Supervisor.create_writer(%Writer{protocol: Protocol.TCP, host: {10,3,123,11}, port: 514, aid: "2"})

iex(5)> Writer.send("1", "test message -- account ID 1")
iex(6)> Writer.send("2", "test message -- account ID 2")
```

Assuming everything is configured correctly, you should see a formatted syslog message on the destination server.

Let's take a quick look at what each field in the `%Writer{}` struct represents.

* `:protocol` - the protocol which will be used to send messages. Two protocols are provided, `NSyslog.Protocol.{TCP, SSL}`. You may provide your own by passing a module that implements the `NSyslog.Protocol` behaviour.
* `:conn_opts` - the keyword option list for the `:ssl` or `:gen_tcp` connection options which is merged into a list of defaults. Note: for `Writer`'s which use the `NSyslog.Protocol.SSL` the `:certfile` option is required.
* `:host` - the host which will receive the message. You can pass a binary, or a tuple-formatted IP address.
* `:port` - the port whch will receive the message. An integer value is expected.
* `:aid` - the "account ID" which this `Writer` is for. A binary value is expected.

The `:aid` field is used as a lookup key in a registry to determine which `NSyslog.Writer` will handle the message when you call `send/2`.

## Development

A `syslog-ng` container for testing can be created with `docker-compose`. However, for development, you should provide a self-signed certificate which will be included in the container. Add the following files:

```bash
docker/syslog-ng/certs/domain.crt
docker/syslog-ng/certs/domain.key
```

You can use a different name for the cert files, however, then you will have to modify `docker/syslog-ng/syslog-ng.conf`.

Finally, the syslog-ng container can be launched:

```bash
nsyslog/ $ docker-compose up -d syslog-ng
```

As previously seen, the application can be run with `iex -S mix` for development. 

The unit test suite can be run with `mix test`.

## Benchmark

A simple benchmark is provided by `benchmark/benchmark.exs`. It can be run as follows:

```bash
mix run benchmark/benchmark.exs 10000
Took 1 second to send 10000 messages.
```

I am hoping to improve the performance and benchmark against a larger number of destination servers. Additionally, I am hoping to benchmark the memory usage of the application as well.

## TODO

* Determine why the `NSyslog.Writer` goes "reconnect crazy" when a RFC3164 connection is closed.
* Improve source documentation and add doctests.
* Improve unit test coverage.
* Investigate connection pooling. (dynamically?)
* Add ability to update connection options of an `NSylog.Writer`. (would anyone even want this?)
* Add typespecs.
