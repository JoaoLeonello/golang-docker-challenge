# golang-docker-challenge

Full Cycle challenge: build a Docker image for a Go program that prints `Full Cycle Rocks!`, and keep the image under 2MB using a multi-stage build.

The final image is about 1.7MB uncompressed.

Image on Docker Hub: [leonello/fullcycle](https://hub.docker.com/r/leonello/fullcycle)

## Running

```bash
docker run --rm leonello/fullcycle
```

Or build it locally:

```bash
docker build -t fullcycle .
docker run --rm fullcycle
docker images fullcycle   # check the size
```

## How the image stays small

The `Dockerfile` has two stages. The first one compiles the program with the `golang:alpine` image, which is around 250MB. The second one starts from `scratch`, an empty image, and copies only the compiled binary, so nothing from the Go toolchain or the OS ends up in the final image.

A few build settings shrink the binary itself:

- `CGO_ENABLED=0` produces a static binary that doesn't depend on libc, which `scratch` doesn't have.
- `-ldflags="-s -w"` strips the symbol table and DWARF debug info.
- `-trimpath` removes local file paths from the binary.
- The program writes with `os.Stdout.WriteString` instead of `fmt.Println`. The `fmt` package pulls in reflection and adds about 0.7MB.

CI builds the image on every push and fails if it goes over 2MB.
