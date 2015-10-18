---
layout: archive
title: Archive
---

# Archive

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
- <span class="time">{{ post.date | date: "%b %d" }}</span> [{{ post.title }}]({{ post.url }})
{% endfor %}
