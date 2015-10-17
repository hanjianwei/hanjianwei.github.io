---
layout: default
title: Archive
---

{% for post in site.posts %}

{% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}

{% unless post.next %}
## {{ year }}
{% else %}
{% capture next_year %}{{ post.next.date | date: '%Y' }}{% endcapture %}
{% unless year == next_year %}
## {{ year }}
{% endunless %}
{% endunless %}

- <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %d" }}</time> [{{ post.title }}]({{ post.url }})
{% endfor %}
