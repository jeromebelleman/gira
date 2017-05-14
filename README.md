# NAME

gira - JIRA command line interface

# SYNOPSIS

**gira [-h] [-p PREFIX] [project]**

# OPTIONS

**-h, --help**
:   Show help message and exit.

**-p, --prefix**
:   installation prefix (default: **/usr**)

**project**
:   JIRA project.

# CONFIGURATION

You'll need to at least specify the JIRA server you wish to use in
**~/.gira/gira.cfg**.  Other parameters are optional.

```ini
[issues]
closed = Closed, Done, Resolved

[jira]
server = https://example.net/jira
# How many times to retry running curl when JIRA is unavailable 
retry = 10
retrywait = .1
```

# AUTHENTICATION

Gira expects an authentication cookie in a file. Since this is done a
different way for each different site, you'll need to write a **gira.cookie**
Python module visible in your Python path and providing a **getcookie()**
function looking like this:

```python
import os
import time
import subprocess

def getcookie(lock, server, path, force=False):
    lock.acquire()
    renew = False
    try:
        # Renew if cookie file older than a day
        if time.time() - os.stat(path).st_mtime > 60 * 60 * 24:
            renew = True
    except OSError:
        renew = True

    if renew or force:
        returncode = 1
        while returncode != 0:
            print "Getting a fresh cookie... "
            returncode = subprocess.call(['/usr/bin/getcookie', '-s', server,
                                          '-o', path])
    lock.release()
```

  - You need to acquire a **threading.Lock()** passed as parameter because
    gira attempts to get cookies behind your back as soon as possible without
    keeping you from working.
  - This example chooses to renew the cookie if it's too old, but that's of
    course up to you.
  - An imaginary command getting a cookie file is run here. The **getcookie()**
    function expects a JIRA instance **server** name to get the cookie
    from. This server name is specified in **~/.gira/gira.cfg**. Maybe you
    don't even need this.
  - The **path** parameter refers to the path of the cookie file, including
    its file name.
  - The **force** parameter is used to get a new cookie no matter what.

# SELECTING A PROJECT

If you haven't already done so with **gira**'s **project** argument,
select a project once in the CLI:

```
gira% projects
The Foo Project                                      FOO
The Bar Project                                      BAR
The Baz Project                                      BAZ
The Boo Project                                      BOO
gira% use BAR
BAR%
```

# VERSIONS AND COMPONENTS

You can list **versions** and **components** known to the project with the
respective commands. This is useful to list project issues in a clearer way,
e.g. by grouping them by version or component:

```
BAR% issues -g versions
BAR% issues -g components
```

# LISTING AND SEARCHING ISSUES

Issues are displayed in a Vim buffer. You can use the Vim buffer to move
issues between versions and components. The **search** command also lists issues,
except that they will result from a JQL search passed as argument. Either
way, you can prefix one or more issues with the character **o** which, once
you save the Vim buffer and exit it, will have the effect of presenting
their key to the next command line to open them with the **issue** command:

```
BAR% issue BAR-1234 BAR-1235 BAR-1236
```

# VIEWING, EDITING, CREATING ISSUES

The **issue** command displays one or more issues in a single Vim buffer. You
can edit fields, add comments, choose values from contextual menus – there's
a short description at the top of the buffer of what you can do and how.
Since this is all presented by Vim, nothing keeps you from automating any
large-scale operations you might fancy. Saving the buffer will apply the
changes.

Similarly, you can create new issues with the **create** command.  Make sure
you don't leave any fields to **TODO**, lest the issue won't be created.

# ODDS AND ENDS

The **edit** command edits a command line. The **page** command pages the last
output inside Vim. The **debug** command shows the raw JSON data sent from
the server in answer to a request:

```
BAR% search /issue/BAR-1236
```

# HELP

All commands are documented with their **-h** option or the **help** command.
