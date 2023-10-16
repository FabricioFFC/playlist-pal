# Playlist Pal

The best friend of streaming platforms.


## How to run

We will need to install Ruby (3.2.0 is recommended). With Ruby installed just run the command line application using the command below:

```sh
$ playlist.pal sample-data/spotify.json changes.json new_spotify.json
```

To validate its output run the unit tests using RSpec:

```sh
$ rspec specs/
```

It's also possible to Rubocop for static analysis:

```sh
$ rubocop
```

## How to scale this app

This app was built in just x hours and y minutes, so there are plenty of room for improvements, particularly for handling very large files.


## Design ideas behind the app

The main idea during the development was how to create a simple, efficient and maintainable code in only 2 hours. To do that some concepts and approaches were taken:

* create unit test to ensure we are in the right path and avoid time debugging;
* create small function with meaningful names;
* failfast and with good feedback for the user;