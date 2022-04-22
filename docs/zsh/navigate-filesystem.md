# navigate-filesystem

## autocd option

Set option with: `setopt autocd`.

Now you can just type `/etc` and this will be equivalent to `cd /etc`.

## directory aliases

Yoy can set custom directory names with the `hash` command.

Create a custom name with: `hash -d md=~/Documents/myDir`

To use, precede the custom name with tilde (~) ad in: `ls ~md`.

Use `hash` alone to list all custom names.