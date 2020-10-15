.phony: all release debug clean

all:
	make debug
	make release

release:
	mkdir -p build/release
	cd build/release && cmake ../.. -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DCMAKE_BUILD_TYPE=Release && make all

debug:
	mkdir -p build/debug
	cd build/debug && cmake ../.. -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DCMAKE_BUILD_TYPE=Debug && make all

clean:
	rm -r build
