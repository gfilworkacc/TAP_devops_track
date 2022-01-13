#!/usr/bin/env python3

def bold(f):
    def d():
        return "<b> " + f() + " </b>"
    return d

def underline(f):
    def d():
        return "<u> " + f() + " </u>"
    return d

def italic(f):
    def d():
        return "<i> " + f() + " </i>"
    return d
