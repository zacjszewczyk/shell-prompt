# Shell Prompt

The purpose of this repository is to share my custom shell prompt. I also posted a brief writeup on my blog: [*ChatGPT Wrote my Shell Prompt*](https://zacs.site/blog/chatgpt-shell-prompt.html)

## Table of Contents

* [**Description**](#description)
* [**Dependencies**](#dependencies)
* [**Installation**](#installation)
* [**Project structure**](#project-structure)
* [**Background and Motivation**](#background-and-motivation)
* [**License**](#license)

## Description

This script changes the shell prompt to conform to the following pattern:

```
{user}@{hostname}:{directory} [{local branch} {upstream branch} {branch tracking symbol}|{local status}]
{privilege character} 
```

1. If the previous command succeeded, `{user}` and `{hostname}` would be green but the at symbol (@) would be left black to differentiate the current username from the current hostname; if the previous command failed, those portions of the prompt would be colored red to indidcate that something had gone wrong.
1. The directory variable would be replaced by the current working directory with `$HOME` abbreviated with a tilde (~). `{directory}` would always be light blue to make it easy to know where I was at all times.
2. The privilege character would be a dollar sign ($) when running as an unprivileged user, and an octothorp (#) when running with elevated privileges. Note that the privilege character would appear on the second line. Although not necessary in most scenarios, when the username and hostname got long and the prompt had to display a lot of information for a complex `git` repository, this helped keep everything readable.
5. The variables in the square brackets, which present `git` information, would be determined according to a series of rules.

If the current working directory was not a git repository, this entire block would be ommitted. This would help keep my prompt clean when navigating the filesystem and debugging applications.

`{local branch}` would show the local branch if it existed. If there were unstaged changes in the local branch, the local branch would be colored orange. This visual cue would remind me to act on changes.

`{upstream branch}` would show the remote tracking branch. I typically work with multiple remotes, and on multiple occasions I have accidentally pushed code to the wrong location. This helps mitigate those types of accidents.

`{branch tracking symbol}` is determined by the following criteria (thanks [Martin Gondermann](https://github.com/magicmonty/bash-git-prompt)):

* ↑n: ahead of remote by n commits
* ↓n: behind remote by n commits
* ↓m↑n: branches diverged, other by m commits, yours by n commits
* L: local branch, not remotely tracked

`{local status}` is determined by the following criteria: 

* ✔: repository clean
* ●n: there are n staged files
* ✖n: there are n files with merge conflicts
* ✖-n: there are n staged files waiting for removal
* ✚n: there are n changed but unstaged files
* …n: there are n untracked files
* ⚑n: there are n stash entries

## Dependencies

This project has no dependencies.

## Installation

To use this custom shell prompt, download [custom_prompt.sh](./custom_prompt.sh) and append `source custom_prompt.sh` to your `.bash_profile` file. Next time you open a shell, `custom_prompt.sh` will automatically load.

## Project structure

```
./repo
|_ README.md # This file.
|
|_ custom_prompt.sh # Custom prompt shell script.
|
|_ makefile # Project makefile
|_ LICENSE.md # Project license.
```

## Background and Motivation

I have, for years now, wanted a cool shell prompt--something worth showing off on [r/linux](https://www.reddit.com/r/linux/) or even [r/unixporn](https://www.reddit.com/r/unixporn/). Not enough to dig into the weeds and figure out how to write one myself, but enough that it came up every once in a while. Then, the other day, I had a great idea: why not just let ChatGPT make it for me? This project is the result.

## License

This project is licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/). You can view the full text of the license in [LICENSE.md](./LICENSE.md). Read more about the license [at the original author’s website](https://zacs.site/disclaimers.html). Generally speaking, this license allows individuals to remix this work provided they release their adaptation under the same license and cite this project as the original, and prevents anyone from turning this work or its derivatives into a commercial product.
