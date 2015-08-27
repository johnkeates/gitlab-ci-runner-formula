# Enable HTTPS Transport for Apt
gitlab-ci-runner-deps-are-installed:
  pkg.installed

# Install the actual repo
gitlab-ci-multi-runner-packagecloud-repo:
  pkgrepo.managed:
    - humanname: GitLab Multi-Runner Packagecloud Repository
    - name: deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/ jessie main
    - dist: jessie
    - file: /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list
    - key_url: https://packages.gitlab.com/gpg.key
    - require_in:
      - pkg: gitlab-ci-multi-runner-package-installed
