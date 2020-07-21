# Identicon

Small program to create "Identity Icons" based on a string input

This project is part of [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/share/101WuiAkYfcFZRRXg=/) by [@StephenGrider](https://github.com/StephenGrider)


## How to execute

Requires:

 - Elixir 1.10.4


Clone the repository, navigate to the project folder and install the dependencies:

```
mix deps.get
```

Then you can run an `iex` shell and execute the `generate` function.

```
iex -S mix

iex(1)> Identicon.generate('myname')
```

The program will create a file called `myname.png` inside the current directory.