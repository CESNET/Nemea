---
layout: page
title: Information for current and future developers
menuentry: Developer
public: false
docmenu: false
permalink: /developer/github-workflow
---

For efficient collaboration, please bear in mind the following advices:

0. If you are not a member of NEMEA team, please fork the project on Github. Otherwise, you can probably push into the repo thus skip to 1.

1. Before you start hacking, please switch to a new branch with some self-explanation name:

`git branch flow_meter-cifs; git checkout flow_meter-cifs`

2. Make your idea real! This is the most funny part - programming. Please, follow our [Git commit policy](/developers/git-policy) to make code reviews easier for us.

3. Write documentation immediatelly. It is really necessary for reviewers to see what parameters and return values your functions/methods have. And description of functionality is needed as well - it is possible to find errors in the code thanks to such brief description of your idea (what it should do vs. what it does).

4. Push your branch either into your forked repo or into our repo, into a NEW branch:

`git push origin flow_meter-cifs:flow_meter-cifs`

5. Create a Pull Request (PR) using the Github web interface (it is quite intuitive) from your branch into `master` (base).

6. Wait for our code review, please don'ŧ get angry because of the feedback, we don't want to insult you, we just need a perfect code and consistent project. In case there is something we need to fix in the PR, it will be very kind of you to help us.

Final notes:

When the PR is merged into master, we usually delete the original branch that is no longer needed.
For the next PR, we always use a new branch.


