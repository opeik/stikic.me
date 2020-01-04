---
layout: page
title: Projects
sidebar_link: true
---

<!-- See https://blog.lanyonm.org/articles/2013/11/21/alphabetize-jekyll-page-tags-pure-liquid.html -->
<!-- With added pipe to handle lack of sort_natural -->
{% capture site_tags %}{% for tag in site.tags %}{{ tag | first | downcase }}|{{ tag | first }}{% unless forloop.last %},{% endunless %}{% endfor %}{% endcapture %}
<!-- site_tags: {{ site_tags }} -->
{% assign tag_words = site_tags | split:',' | sort %}
<!-- tag_words: {{ tag_words }} -->
<!-- <small>{{ post.date | date_to_string }}</small> -->

{% comment %}
  Check if we have a tags page active before linking to it.
{% endcomment %}
{% assign tags_page = false %}
{% for node in site.pages %}
  {% if node.layout == "tags" %}
    {% assign tags_page = node %}
  {% endif %}
{% endfor %}

<div class="projects">
  {% assign tag = "project" %}
  <div id="{{ tag | slugify }}" class="project">
    <ul class="project-ul">
      {% for post in site.tags[tag] %}
        <li>
          <span class="project-post">
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>: {{ post.description }}
          </span>
          <span class="project-tags">
            {% for tag in post.tags %}
              {% unless tag == "project" %}
                <a class="post-tag-small" href="{{ tags_page.url }}#{{ tag | slugify }}">
                #{{ tag }}
                </a>
              {% endunless %}
            {% endfor %}
          </span>
        </li>
      {% endfor %}
    </ul>
  </div>
</div>
