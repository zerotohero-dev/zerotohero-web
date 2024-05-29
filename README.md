```txt
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'
```

This is the public website for <https://zerotohero.dev>.

The code is [MIT-licensed](LICENSE) and the content is licensed under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Quick Start

To build the pages (using Docker):

```bash
./hack/build-docker.sh
```

To publish the website (using Docker; after building the pages):

```bash
./hack/dist.sh
```

To publish the website if you have `zola` installed on your system:

```bash
./hack/publish.sh
```

This little script fetches images and saves them under the static files folder
where you can refer to them in your markdown files. It is used to migrate
old Zero to Hero assets to  this new structure:

```bash
./hack/wget.sh
```
