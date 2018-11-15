{% from "gitlab-ci-runner/map.jinja" import gitlab_ci_runner with context %}

{% set config_file = "/etc/gitlab-runner/config.toml" %}

# loop through all defined multi-runner instances and register/unregister them
{% for name, multirunner in salt['pillar.get']('gitlab-ci-runner:multirunners', {}).items() %}
{% if multirunner.register == True %}
register-runner-{{ name }}:
  cmd.run:
    - name: gitlab-runner register -u {{ multirunner.url }} -r {{ multirunner.token }} --name {{ name }} --executor {{ multirunner.executor }} {% if 'options' in multirunner %} {% for opt, val in multirunner.options.items() %} --{{ opt }} {{ val }} {% endfor %}{% endif %} {% if multirunner.tags %} --tag-list {{ multirunner.tags }} {% endif %} -n
    # check to make sure we don't over-register the same runner
    # this depends on the name ending up in the toml file
    - unless: grep 'name = "{{ name }}"' {{ config_file }}
{% endif %}

{% if multirunner.register == False %}
unregister-runner-{{ name }}:
  cmd.run:
    - name: gitlab-runner unregister -u {{ multirunner.url }} -t {{ multirunner.token }} --name {{ name }}
    - onlyif: grep 'name = "{{ name }}"' {{ config_file }}
{% endif %}
{% endfor %}
