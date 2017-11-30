{% from "gitlab-ci-runner/map.jinja" import gitlab_ci_runner with context %}

{% set ssh_key_install_path = "/home/gitlab-runner/.ssh/" %}

add-runner-sshkey-dir:
  file.directory:
    - name: {{ssh_key_install_path}}
    - user: gitlab-runner
    - group: gitlab-runner
    - mode: 600

# loop through all defined multi-runner instances and register/unregister them
{% for name, keypair in salt['pillar.get']('gitlab-ci-runner:sshkeys', {}).items() %}
{% if keypair.public %}
add-runner-sshkey-{{ name }}-public:
  file.managed:
    - name: {{ssh_key_install_path}}{{name}}.pub
    - user: gitlab-runner
    - group: gitlab-runner
    - mode: 600
    - contents_pillar: gitlab-ci-runner:sshkeys:{{name}}:public
{% endif %}

{% if keypair.private %}
add-runner-sshkey-{{ name }}-private:
  file.managed:
    - name: {{ssh_key_install_path}}{{name}}
    - user: gitlab-runner
    - group: gitlab-runner
    - mode: 600
    - contents_pillar: gitlab-ci-runner:sshkeys:{{name}}:private
{% endif %}
{% endfor %}