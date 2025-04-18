# smartcd.fish

> Part of my [utilities collection](https://sr.ht/~ficd/utils/).
>
> `cd`, but _slightly_ smarter.

`smartcd` makes `cd` smarter when used without arguments. It adapts based on
your current location, helping you more around Git repos and your system more
efficiently.

## Usage

When you run `cd` with **no arguments**:

- If **inside a Git repository**:
  - Jumps to the **repository root**.
  - If **already at the root**, jumps to the **previous directory**.
- If **outside a Git repository**:
  - Jumps to the **home directory**.
  - If **already at home**, jumps to the **previous directory**.

This enables a kind of "bouncing" navigation.

## Installation

To install, copy [smartcd.fish](./smartcd.fish) to your `conf.d` directory. Use
`exec` to reinitialize `fish` if you want to use `smartcd` in the same session.

```fish
curl https://git.sr.ht/~ficd/smartcd.fish/blob/main/smartcd.fish \
    -o $fish_config/conf.d/smartcd.fish
exec fish
```

## License

[ISC](./LICENSE)
