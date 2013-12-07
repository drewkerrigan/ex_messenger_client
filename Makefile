.PHONY: all

all:
	mix

run:
	rm ex_messenger_client
	mix escriptize
	./ex_messenger_client