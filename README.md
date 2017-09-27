[![Build Status](https://travis-ci.org/rubyx/rx-file.svg?branch=master)](https://travis-ci.org/rubyx/rx-file)
[![Gem Version](https://badge.fury.io/rb/rx-file.svg)](http://badge.fury.io/rb/rx-file)
[![Code Climate](https://codeclimate.com/github/rubyx/rx-file/badges/gpa.svg)](https://codeclimate.com/github/rubyx/rx-file)
[![Test Coverage](https://codeclimate.com/github/rubyx/rx-file/badges/coverage.svg)](https://codeclimate.com/github/rubyx/rx-file)

### Reading the code

Knowing what's going on while coding rubyx is not so easy: Hence the need to look at code dumps

Hence the need for a code/object file format
(remember an oo program is just objects, some data, some code, all objects)

I started with yaml, which is nice in that it has a solid implementation, reads and writes,
handles arbitrary objects, handles graphs and is a sort of readable text format.

But the "sort of" started to get to me, because

- 1) it's way to verbose (long files, object groups over many pages) and
- 2) does not allow for (easy) ordering.
- 3) has no concept of dumping only parts of an object

To fix this i started on RxFile, with an eye to expand it.

The main starting goal was quite like yaml, but with

- more text per line, specifically objects with simple attributes to have a constructor like syntax
- also short versions of arrays and hashes
- Shorter class names (no ruby/object or even ruby/struct stuff)
- references at the most shallow level
- a way specify attributes that should not be serialized

### Usage

The module's main useful api is

    RxFile::Writer.write(object_to_derialize)


### Ruby X File

Ok, so we all heard about object files, it's the things compilers create so we don't have to have
huge compiles and can link them later.

Much fewer know what they include, and that is not because they are not very useful,
but rather very complicated.

An object machine must off course have it's own object files, because:

- otherwise we'd have to express the object machine in c formats (nischt gut)
- we would be forced to read the source every time (slow)
- we would have no language independent format

And i was going to get there, just not now. I mean i think it's a great idea to have many languages
compile and run  on the same object machine.
Not necessarily my idea, but i haven't seen it pulled off. Not that i will.

I just want to be able to read my compiled code!!

And so this is a little start, just some outputter.

#### Direction

The way this is meant to go (planned for 2020+) was a rubyx core with only a rx-filw parser (as that is soo much simpler).

Then to_ruby for all the ast classes to be able to roundtrip ruby code.

Then go to storing rxf in git, rather than ruby.

Then write a python/java parser and respective runtime conversion. Extracting common features.
With the respective to_python on the ast's to roundtrip that too.
Have to since by now we work on rx-file's. Etc . ..
