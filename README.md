GitLab-CI Runner
================

This formula sets up the repo for GitLab-CI Runners, installs a runner of
your choice and configures it.

Optionally, afterwards, it can register it as well.

gltlab-ci-runner
----------------
The init state installs the repo and the runner as both are required for this formula to make sense.

gltlab-ci-runner.repo
---------------------
Setup APT repo for the current os_family + oscodename. Not RPM compatible at this time.

gltlab-ci-runner.install
------------------------
Installs the latest gitlab-runner package

gltlab-ci-runner.config
-----------------------
Registers and unregisters runners according to the pillar data.

gltlab-ci-runner.service
------------------------
Starts and enables the gitlab-runner service.


Usage Scenario
==============
If you have a GitLab setup, you probably need runners. This formula does the basic setup, install and configuration of the runner.
A basic configuration for a single runner might be:

```
gitlab-ci-runner:
  multirunners:
    runner-1:
      url: 'https://gitlab.domain.com/'
      token: ercasdxBxasdhasdNbbb
      executor: 'shell'
      register: True
```

Setting resiter to True registers the runner, setting it to False gracefully de-registers them.

Todo
----
Currently, no additional parameters are supported, but they are easy to implement.