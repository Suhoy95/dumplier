#!/bin/sh

# set -x

if [ "$#" -ne 3 ] ; then
  echo "Usage: $0 TITLE SUBJECT NUMBER" >&2
  exit 1
fi

TITLE=$1
SUBJECT=$2
NUMBER=$3

cat <<PREAMBLE
---
title: $TITLE
subtitle: $SUBJECT -- Research Project
author: Sukhoplyuev Ilya
rights: Innopolis University, Security and Networking Engineering
date: $(date +%Y-%m-%d)
documentclass: book
classoption: oneside
papersize: a4
geometry: top=3cm, left=2cm, right=2cm, bottom=3cm
colorlinks: blue
fontsize: 12pt
mainfont: Liberation Serif
---

PREAMBLE
