#!/bin/bash
hexo g && hexo d
git pull
git add .
git commit -m"update blog"
git push
