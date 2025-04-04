# Run the project
run:
    stack --compiler=ghc-9.6.6 run

# Build the project
build:
    stack --compiler=ghc-9.6.6 build

# Run tests
test:
    stack --compiler=ghc-9.6.6 test

# Clean build artifacts
clean:
    stack --compiler=ghc-9.6.6 clean

# Install dependencies
install:
    stack --compiler=ghc-9.6.6 install

# Start REPL
repl:
    stack --compiler=ghc-9.6.6 ghci
