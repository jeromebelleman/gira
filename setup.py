#!/usr/bin/env python
# coding=utf-8

import os
from distutils.core import setup

delattr(os, 'link')

setup(
    name='gira',
    version='1.0',
    author='Jerome Belleman',
    author_email='Jerome.Belleman@gmail.com',
    url='http://cern.ch/jbl',
    description="JIRA CLI",
    long_description="A fast JIRA CLI allowing to handle tickets massively and display them in a single, clear view. Means \"turn\" in Spanish.",
    scripts=['gira'],
    data_files=[
        ('share/man/man1', ['gira.1'])
        ('share/gira', ['vimrc', 'issue.vimrc', 'issues.vimrc']),
    ],
)
