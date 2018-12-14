# Example multi-module repository



## How to build libraries?

Note that [nodelib](./nodelib) and [nodelib2](./libsfolder/nodelib2) don't have `Dockerfile`s.
How do you build libraries with your service?
Publishing them is quite inconvenient during build even if you have a local module registry,
because you's publish all libraries every time.

Docker caching is pretty great for this use case.
