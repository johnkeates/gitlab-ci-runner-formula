# Enable HTTPS Transport for Apt, as the GitLab PackageCloud repo uses HTTPS
gitlab-ci-multi-runner-packagecloud-repo-dependency:
  pkg.installed:
    - name: apt-transport-https
    - require_in: gitlab-ci-multi-runner-packagecloud-repo #We must block the repo as it will break APT if HTTPS was not installed yet!

# Install the actual repo
gitlab-ci-multi-runner-packagecloud-repo:
  pkgrepo.managed:
    - humanname: GitLab Multi-Runner Packagecloud Repository
    - name: deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/ jessie main
    - dist: jessie
    - file: /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list
    - key_url: https://packages.gitlab.com/gpg.key
    - require_in:
      - pkg: gitlab-ci-multi-runner-package-installed # We won't even try to install it if the repo isn't there yet
