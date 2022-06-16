default: all

all: bin/os

bin/os: .dummy
	@mkdir -p bin
	echo "TODO: write os" >> bin/os

.dummy:
