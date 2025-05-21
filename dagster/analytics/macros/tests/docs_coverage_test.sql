-- tests/docs_coverage_test.sql
{% for model in graph.nodes.values() if model.resource_type == 'model' %}
    {% do docs_coverage(model) %}
{% endfor %}
