# til-template

A template repository for TIL's posts powered by [tiller](https://github.com/woodruffw/tiller).

Special thanks to [William Woodruff](https://github.com/woodruffw/) for creating [tiller](https://github.com/woodruffw/tiller). This template is inspired from [woodruffw/til](https://github.com/woodruffw/til).

## Getting Started

1. Click **"Use this template"** on GitHub to create your own repository from this template.
2. Clone your new repository.
3. Install [tiller](https://github.com/woodruffw/tiller).
4. Edit `tiller.toml` with your site's `base_url` and links.
5. Edit `_index.md` to customize your site's homepage.
6. Run `make serve` to build and preview your site.

## Usage

### Create a new TIL

```bash
make new title="Your TIL Title" tags="tag1, tag2"
```

This creates a new markdown file in `tils/` with today's date and the given title and tags. If `tags` is omitted, the default tags from [tils/template.md](tils/template.md) are used.

### Build the site

```bash
make build
```

Generates the static site into the `site/` directory.

### Preview locally

```bash
make serve
```

Builds the site in dev mode and serves it at `http://localhost:8000`. You can change the port:

```bash
make serve PORT=3000
```

### Run in dev mode

```bash
make dev
```

Generates the site in dev mode (suitable for local development).

### Clean generated files

```bash
make clean
```

Removes the `site/` directory.

### View all commands

```bash
make help
```

## License

See [LICENSE](LICENSE) for details.
