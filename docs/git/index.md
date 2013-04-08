---
title: Git
layout: page
---

## Tutorials

* [Git From the Bottom Up](http://ftp.newartisans.com/pub/git.from.bottom.up.pdf)
* [Pro Git](https://github.com/progit/progit)

## Bindings

* [libgit2](https://github.com/libgit2)

### Ruby

* [ruby-git](https://github.com/schacon/ruby-git)
* [grit](https://github.com/mojombo/grit)
* [rugged](https://github.com/libgit2/rugged)

#### Grit Usage

``` ruby
require 'grit'

# Initialize a Git repo
repo = Grit::Repo.init(path)

# Initialize a bare Git repo
repo = Grit::Repo.init_bare(path)

# Open an existing repo
repo = Grit::Repo.new(path)

# Add new file and its content
index = repo.index
index.add('foo.txt', 'hello')

# Delete a file
index.delete('bar.txt')

# Use current head as parent commit
index.read_tree("master")

# Commit with given Actor
index.commit('Commit message', [repo.head.commit], Grit::Actor.new('author name', 'email'))

# Checkout file from git to file system
repo.git.checkout({}, 'HEAD', '--', path)

# Remove the file
repo.git.rm({'f' => true}, '--', 'bar.txt')

```
## Tips

* [How do I edit an incorrect commit message in Git?](http://stackoverflow.com/questions/179123/how-do-i-edit-an-incorrect-commit-message-in-git)
