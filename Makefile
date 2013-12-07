.PHONY: all

all:
	mix

run:
	rm -f ex_messenger_client
	mix escriptize
	./ex_messenger_client
