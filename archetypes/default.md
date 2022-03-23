---
date: {{ .Date }}
image = "./img/" 
tags = ["tag1", "tag2"] 
title: "{{ replace .Name "-" " " | title }}"
draft: true
---

