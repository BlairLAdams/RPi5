{% macro docs_coverage(model) %}
    {% if not model.description %}
        {{ exceptions.raise_compiler_error("Model " ~ model.name ~ " is missing a description.") }}
    {% endif %}

    {% for col in model.columns %}
        {% if not col.description %}
            {{ exceptions.raise_compiler_error("Column '" ~ col.name ~ "' in model " ~ model.name ~ " is missing a description.") }}
        {% endif %}
    {% endfor %}
{% endmacro %}
