# smartcd.fish

> Part of my [utilities collection](https://sr.ht/~ficd/utils/).
>
> `cd`, but _slightly_ smarter.

`smartcd` makes `cd` smarter when used without arguments. It adapts based on
your current location, helping you more around Git repos and your system more
efficiently. It works inside the [fish](https://fishshell.com/) shell.

## Usage

The command is accessible as `cd`:

```fish
# arguments work as before
cd /foo/bar
# including - to go backwards manually
cd -
# running cd _without_ arguments
# triggers the smart behavior
cd
# help is also available
cd --help
```

- `ROOT`:
  - Repository root if **inside** a Git repository.
  - `$HOME` if **_not_ inside** a Git repository.
- `PREV`:
  - Your _previous_ directory.
  - Last element of `$dirprev`.

When you invoke `cd` without arguments:

- If not at `ROOT`, return to `ROOT`.
- If _already_ at `ROOT`, return to `PREV`.
- If `PREV` is _not_ a child of `ROOT`, prompt before jumping.

An update function, `smartcd_update`, is provided. It uses `curl` to save the
latest version of `smartcd.fish` to `$fish_config/conf.d`.

## Installation

To install, copy [smartcd.fish](./smartcd.fish) to your `conf.d` directory. Use
`exec` to reinitialize `fish` if you want to use `smartcd` in the same session.

```fish
curl https://git.sr.ht/~ficd/smartcd.fish/blob/main/smartcd.fish \
    -o $fish_config/conf.d/smartcd.fish
exec fish
```

Once installed, `smartcd` provides an update function. You may invoke it at any
time to update `smartcd` to the latest version. Pass `-d` or `--dry` to print
the script to `STDOUT` without saving the file.

```fish
# Check connectivity & print script to STDOUT
smartcd_update --dry
# Update conf.d
smartcd_update
# View help
smartcd_update --help
```

## License

[ISC](./LICENSE)
