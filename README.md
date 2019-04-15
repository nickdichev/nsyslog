# NSyslog

## Description

The goal of this project is to send arbitrary messages to a dynamic number of syslog servers. Currently, the project supports RFC3164 and RFC5424 formatted messages and destinations. However, the only supported protocols are TCP (for RFC3164 messages/destinations) or SSL (for RFC5424 messages/destinations).

An example application that uses this library can be found [here](https://github.com/nickdichev/kafka_syslog).

## Setup

For RFC5424 destinations, SSL is required. For testing a self-signed certificate will suffice. Update the path to your certificate in the following files:

* `config/dev.exs`

The default path in `prod.exs` is populated during a Docker build. More on this in a following section.

Additionally, if you plan to use the `syslog-ng` container provided in this repository for testing you should create a self-signed certificate and drop it in `docker/syslog-ng/certs`.

## Usage

What follows is an example of how a syslog client can be created and used.

```bash
nsyslog/ $ iex -S mix

iex(1)> alias NSyslog.Writer
iex(2)> alias NSyslog.Writer.Supervisor

iex(3)> Supervisor.create_writer(%Writer{rfc: :rfc5424, protocol: :tcp, host: "localhost", port: 6514, aid: "1"})
iex(4)> Supervisor.create_writer(%Writer{rfc: :rfc3164, protocol: :tcp, host: {10,3,123,11}, port: 514, aid: "2"})

iex(5)> Writer.send("1", "test message -- account ID 1")
iex(6)> Writer.send("2", "test message -- account ID 2")
```

Assuming everything is configured correctly, you should see a formatted syslog message on the destination server.

Let's take a quick look at what each field in the `%Writer{}` struct represents.

* `:rfc` - the RFC specification which is used to format and send messages. Possible values are `:rfc3164` or `:rfc5424`.
* `:protocol` - the protocol which will be used to send messages. Currently only `:tcp` is supported.
* `:host` - the host which will receive the message. You can pass a binary, or a tuple-formatted IP address.
* `:port` - the port whch will receive the message. An integer value is expected.
* `:aid` - the "account ID" which this `Writer` is for. A binary value is expected.

The `:aid` field is used as a lookup key in a registry to determine which `NSyslog.Writer` will handle the message.

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
* Add typespecs.