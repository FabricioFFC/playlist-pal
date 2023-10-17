# Playlist Pal
[![Ruby][Ruby-icon]][Ruby-url]

The best friend of streaming platforms.


## How to run

We will need to install Ruby (3.2.0 is recommended). With Ruby installed run the command line application using the command below:

```sh
$ ./playlist_pal.rb sample-data/spotify.json sample-data/changes.json new_spotify.json
```

To validate its output run the unit tests using RSpec:

```sh
$ bundle install && rspec specs/
```

It's also possible to Rubocop for static analysis:

```sh
$ rubocop
```

## How to scale this app

This app was built in just 1 hour and 58 minutes, so there are plenty of room for improvements, particularly for handling very large files.

Some ideas that could to handle this scenario:

* avoid very large files, for example split the input file according to the data type and changes file according to the operation;
* don't put the entire files on memory like I did. To solve this we could try [oj](https://github.com/ohler55/oj) or using Streams (I did this using [Elixir](https://github.com/FabricioFFC/geolocation-service/blob/main/lib/import_service/producer.ex#L16), I don't if `oj` uses streams of if there other gems that use);
* adopt a map and reduce approach, splitting into other servers/processes each operation;
* use Sidekiq workers and control the number of file processing per worker, using for example [sidekiq-limit](https://github.com/deanpcmad/sidekiq-limit_fetch). We doesn't solve the initial problem, but it can solve another problem of having multiple files to be processed;

## Design ideas behind the app

The main idea during the development was how to create a simple, efficient and maintainable code in only 2 hours. To do that some concepts and approaches were taken:

* create unit test to ensure we are in the right path and avoid time debugging;
* create small function with meaningful names;
* failfast and with good feedback for the user;


## Things left behind

Due the time constraint, there were certain tasks I had intended to develop, but I couldn't complete:

* create unit tests for `PlaylistUpdater`. In the end I just created two integration tests to help me to validate the code;
* validate the input file format deeply (e.g.: if all songs have an ID);
* validate the changes file format deeply (e.g.: all songs ids exist);
* parse/sanitize data to avoid convertions during the output generation;
* use the class `Logger`, instead of, `puts`;

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[Ruby-icon]: https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white
[Ruby-url]: https://ruby-lang.org
