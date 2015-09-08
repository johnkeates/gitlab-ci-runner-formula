{% from "gitlab-ci-runner/map.jinja" import gitlab_ci_runner with context %}

# Install the runner
gitlab-ci-multi-runner-package-installed:
  pkg.latest:
    - name: gitlab-ci-multi-runner

# make sure global runner is started

# loop through all defined multi-runner instances and register/unregister them
{% for name, multirunner in salt['pillar.get']('gitlab-ci-runner:multirunners', {}).items() %}

{% if multirunner.user is not defined or multirunner.user == 'root' %}
  {% set user = 'root' %}
  {% set config_file = '/etc/gitlab-runner/config.toml' %}
{% else %}
  {% set user = multirunner.user %}
  {% set config_file = '/home/'+user+'/.gitlab-runner/config.toml' %}
{% endif %}

{% if multirunner.register == True %}
register-runner-{{ name }}:
  cmd.run:
    - name: gitlab-ci-multi-runner register -n -r {{ multirunner.token }} -u {{ multirunner.url }} -d {{ name }} -e {{ multirunner.executor }} -t '{{ multirunner.tags }}'
    - user: {{ user }}
    - unless: grep 'name = "{{ name }}"' {{ config_file }}


make-sure-multi-runner-for-{{ user }}-is-started:
  cmd.run:
    {% if user == 'root' %}
    - name: gitlab-ci-multi-runner start
    {% else %}
    - name: gitlab-ci-multi-runner run >> ~/{{ name }}.log 2>&1 &
    {% endif %}
    - user: {{ user }}
    - unless: pgrep -u {{ user }} gitlab-ci-multi

{% else %}
unregister-runner-{{ name }}:
  cmd.run:
    - name: gitlab-ci-multi-runner unregister --token {{ multirunner.token }} --url {{ multirunner.url }}
    - user: {{ user }}
    - onlyif: grep 'name = "{{ name }}"' {{ config_file }}
{% endif %}

{% endfor %}

