GitLab-CI Runner
================

This formula sets up the repo for GitLab-CI Runners, installs a runner of
your choice and configures it.

Optionally, afterwards, it can register it as well.

gltlab-ci-runner
----------------
The init state installs the repo and the runner as both are required for this formula to make sense.

gltlab-ci-runner.runner
-----------------------
Currently only aliases gltlab-ci-runner.multirunner. Once we have more runners, add them here.

gltlab-ci-runner.multirunner
----------------------------
Installs the multirunner if it's not installed, configures any runners form the pillar, and
registers them. This is all done from the commandline and not by writing the toml config directly.

Usage Scenario
==============
If you have a GitLab-CI setup, you need runners. If you are using salt,
this formula enables you to fully setup a system or VM. Since you are probably
using salt to manage your environments, including the one for the application
you are developing using GitLab and GitLab-CI, it would make sense to manage
the runner environment as well, as you will most likely need a bunch of DevDeps
from your existing config on the runner environment too. This way, you can re-use
that existing salt config.

TODO
====

- Add more runners for cases where the multirunner doesn't fit
- Split registration off in to register.sls
- Allow for direct toml manipulation, if needed using a jinja template
