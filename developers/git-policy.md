---
layout: page
title: Git commit policy
menuentry: Developer
public: false
docmenu: false
permalink: /developer/git-policy
---

* A commit has its purpose. It SHOULD be just a SINGLE purpose. Commits should be "atomic", i.e., one commit is a single change of one funcionality/feature/module. It is usually up to developer's intuition whether a commit is or is not atomic... So think about changes you put in one commit.

* Commit message must explain what the changes do or what they should have done.  Commit message helps reviewer to decide whether the change does the right thing or there is some error. Therefore, pay attention on writting a proper message in the following format:

```
libtrap: TLS ifc: bugfix double close()

There was no prevention from calling close() repeatedly for the already
closed socket descriptor.

This patch sets the closed socket descriptor to `-1` and checks this value
before closing.

The patch relates to issue #123.
```

Explained in more details:

`libtrap: TLS ifc: bugfix double close()` generally consists of 2 parts:
the first one **identifies** scope of this patch (such as `libtrap: TLS ifc:`).
It can be just `libtrap` or more precisly `libtrap: TLS ifc` as it is in the
example. The second part identifies the problem that is being solved by this
commit.

The first line should be short enough but it should be informative.

After this first line, skip one empty line. This is a common practice for git messages.
It is important because tools count on it. Github can show the first lines

The rest of this example (as well as your commit messages) contains details about this
commit.

Don't forget to reference issue number. Hashtag of the issue should be enough.
This helps Github to present all related work at a single page of the issue.

## Keywords in commit messages

*This part is just a draft by now.*

We are planning to prepare ChangeLogs somehow automatically. Therefore, we
need to mark commits with some keywords.

Add a line into the detailed description:

* `changelog: Add module <mymodule>.` (`<mymodulei>` was added into the package)
* `changelog: Add feature <nameoffeature> to <mymodule>.` (`<nameoffeature>` was added into `<mymodulei>`)
* `changelog: Fix <nameoffeature> in <mymodule>.` (`<nameoffeature>` was fixed into `<mymodulei>`)
* `changelog: Bugfixes in <mymodule>.`


