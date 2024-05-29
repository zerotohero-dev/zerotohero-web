{#
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'
#}
{% set data = load_data(path="/vadideki-geyik/geyik-academy/nav.yaml") -%}
{% for item in data %}
{% if loop.index == selected %}
* **▶ {{ item.name }}**
  {% else %}
* [{{ item.name }}]({{ item.url }})
  {% endif %}
  {% endfor %}
