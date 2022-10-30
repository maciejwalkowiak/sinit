# sinit

*sinit* - command line shiny Spring Boot project initialzer 🚀

## Highlights

- generates new project from https://start.spring.io
- adds option to create a new Git repository and push to Github
- adds option to open project in Intellij IDA or [Gitpod](https://gitpod.io)

![sinit in action](./sinit.gif)

## Installation

At this stage only Homebrew packages are available:

```bash
$ brew tap maciejwalkowiak/sinit
$ brew install sinit
```

Interested in making package for other operating systems? Go ahead 🙂

Once the package is installed, just run `sinit` in your terminal.

## How does it work?

Check `sinit.sh` file in the repository - I think it is quite straightforward. 

The basic idea is - it uses what's offered in https://start.spring.io - so if new Spring 
Boot version is released, there is no need to upgrade the `sinit` package.

It uses [Github CLI](https://github.com/cli/cli) to create the repository, and 
[gum](https://github.com/charmbracelet/gum) for fancy UI.

To open Intellij IDEA or browser with Gitpod it calls `open` command which AFAIK is 
available only on MacOS - it may not be trivial to use it on Linux 🤷‍♂️.

## Contributing

If you have any ideas how to improve it, go ahead and file an issue/PR!
