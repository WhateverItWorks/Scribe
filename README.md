# Scribe - An Alternative Medium Frontend

This is a project written using [Lucky](https://luckyframework.org). It's main website is [scribe.rip](https://scribe.rip).

## Deploying Your Own

I'd love it if you deployed your own version of this app! A [few others](docs/instances.md) have already. To do so currently will take some knowledge of how a webserver runs. This app is built with the [Lucky framework](https://luckyframework.org) and there are a bunch of different ways to deploy. The main instance runs on [Ubuntu](https://luckyframework.org/guides/deploying/ubuntu) but there are also directions for [Heroku](https://luckyframework.org/guides/deploying/heroku) or [Dokku](https://luckyframework.org/guides/deploying/dokku).

Hopefully a more comprehensive guide will be written at some point, but for now feel free to reach out to the [mailing list](https://lists.sr.ht/~edwardloveall/scribe) if you have any questions.

### Docker (Unsupported)

A Dockerfile is included to build and run your own OCI images. I don't use Docker personally so this is all community created and supported. If it breaks, please write to the [mailing list](https://lists.sr.ht/~edwardloveall/scribe).

To build:

```
$ docker build [--build-arg PUID=1000] [--build-arg PGID=1000] -t scribe:latest -f ./Dockerfile .
```

To run (generating a base config from environment variables):

```
$ docker run -it --rm -p 8080:8080 -e SCRIBE_PORT=8080 -e SCRIBE_HOST=0.0.0.0 scribe:latest
```

To run with mounted config from local fs:

```
$ docker run -it --rm -v `pwd`/config/watch.yml:/app/config/watch.yml -p 8080:8080 scribe:latest
```

### Configuration

To allow your domain to show up on the homepage, the `APP_DOMAIN` environment variable must be set. Note that this only takes effect if the `LUCKY_ENV` environment variable is also set to `production`.

See the [route_helper](https://git.sr.ht/~edwardloveall/scribe/tree/main/item/config/route_helper.cr) config for the code that powers this feature.

Other configuration needed when in `production` mode:

* PORT: The port Scribe should run on
* SECRET_KEY_BASE: A 32-bit string. Can be generated with `lucky gen.secret_key`
* GITHUB_PERSONAL_ACCESS_TOKEN: to proxy gists with authenticated GitHub API requests
* GITHUB_USERNAME: to proxy gists with authenticated GitHub API requests

### GitHub Gist Proxying

Scribe proxies GitHub gists. It does this by making API requests to GitHub's ReST API to get the gist file contents. GitHub limits API requests to 5000/hour with a valid api token and 60/hour without. 60 is pretty tight for the usage that scribe.rip gets, but 5000 is reasonable most of the time.

API credentials are in the form of a GitHub username and a personal access token attached to that username. To get a token, visit https://github.com/settings/tokens and create a new token. The only permission it needs is `gist`.

This token is set via the `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable. The username also needs to be set via `GITHUB_USERNAME`. When developing locally, these can both be set in the .env file. Authentication is probably not necessary locally, but it's there if you want to test. If either token is missing, unauthenticated requests are made.

## Project goals

I believe that Medium is a bad actor on the web. They offer a [bad reading experience](https://twitter.com/BretFisher/status/1206766086961745920). Writing there [benefits Medium](https://www.manton.org/2016/01/15/silos-as-shortcuts.html) more than the author. Counter to their promise of a wider reach, [they offer worse SEO](https://pawelurbanek.com/medium-blogging-platform-seo). They use [extortionist business tactics](https://www.cdevn.com/why-medium-actually-sucks/). Finally, they want to [centralize the currently decentralized world of blogging](http://scripting.com/liveblog/users/davewiner/2016/01/20/0900.html).

Since Scribe uses Medium content, I don't want to help people engage with it more than they must. My goal here is not to make a nicer Medium to engage with, but to make a less bad experience when people are forced to engage with it. I want Scribe to be a tool, not a platform.

It's intentional that there is no way to browse content from a user, see popular posts, consume via an RSS feed, or further engage with an article via comments or "claps". I want to spend my time encouraging writers to move to worthy platforms, not making a bad platform worthy.

## Contributing

1. Install required dependencies (see sub-sections below)
1. Run `script/setup`
1. Run `lucky dev` to start the app
1. [Send a patch](https://man.sr.ht/git.sr.ht/#sending-patches-upstream) to `~edwardloveall/Scribe@lists.sr.ht` (it may not look like it at first, but that's an email address).

### Installing dependencies

General instructions for installing Lucky and its dependencies can be found at <https://luckyframework.org/guides/getting-started/installing#install-required-dependencies>.

### Installing dependencies with Nix

If you are using the [Nix](https://nixos.org/) package manager, you can get a shell with all dependencies with the following command(s):

``` shell
nix-shell

# Or if you are using the (still experimental) Nix Flakes feature
nix flake update # Update dependencies (optional)
nix develop
```

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
