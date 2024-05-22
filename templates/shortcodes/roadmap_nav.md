{% set data = load_data(path="/roadmap/nav.yaml") -%}
{% for item in data %}
{% if loop.index == selected %}
* **▶ {{ item.name }}**
  {% else %}
* [{{ item.name }}]({{ item.url }})
  {% endif %}
  {% endfor %}