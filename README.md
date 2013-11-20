# Get ready for the Hacker Cup!

Want to join the Facebook Hacker Cup and try programming in Ruby?

Here is a quick skeleton containing some template files and scripts that should make it easier to jump in!

It provides:

  * Guard to automatically test and run benchmarks whenever you save your source code.
  * A `BaseRunner` class file that will make it easy to define various algorithms to test on the given input.

Happy Hacking !

## Environments

It should work on Mac and Linux (it may also work - expect for the `script/*` part - on Windows but I didn't tested it)

## Dependencies

  * git
  * ruby
  * bundler
  * a notification library [supported by Guard](https://github.com/guard/guard#notification) like libnotify (`apt-get install libnotify-bin`) or growl.
  * pry (optional) if you need a nice debugger (`gem install pry`)

Need to install Ruby ? Here is a one-liner to get you started with Ruby (with some rbenv love):

```sh
# Mac and Linux only
bash <(curl https://raw.github.com/goodtouch/rbenv-ruby-install/master/install-web)
```

## Quick Test

```sh
git clone https://github.com/goodtouch/facebook-hacker-cup-rb.git
cd facebook-hacker-cup-rb
./script/bootstrap
./script/run
```

In your editor, open and save `example/round_01/01_card_game.rb`

You should see some notification.

Wanna see how `algo_1` and `algo_2` compete with bigger numbers?

```sh
cp example/round_01/01_card_game.in.high example/round_01/01_card_game.in &&
cp example/round_01/01_card_game.out.high example/round_01/01_card_game.out
```

## Usage

### 1. generate the template files for a problem:

```sh
./script/new_problem <round> <problem> <title>

# Example - If the first problem of the first round is a card_game, run:

./script/new_problem 1 1 card_game
```

it will generate a `round_01` folder with:

  * `01_card_game.md`: Put the summary of the problem (and your notes) inside.
  * `01_card_game.in`: copy & paste the input inside.
  * `01_card_game.out`: copy & paste the expected output inside.
  * `01_card_game.rb`: Edit the FIXME and replace the `raise` by some nice ruby code

### 2. Automatically monitor your files and run benchmarks whenever you save files:

```sh
./script/run
```

## Howto?

For each problem of each round, it will generate:

  * a "standalone" Ruby file with some FIXME (You'll need to upload it, so I put everything needed inside).
  * placeholder files to copy & paste the input and expected output from Facebook.

If you scroll down in the generated rb file you should find interesting stuff like:

  * a place to define `CONSTANTS` if needed.
  * a `ParseInput` module to define helper methods (to parse the input).
  * a place do define helpers you could use in your algorithms (like tree implementation or mathematical functions...).
  * the `Runner` class, inherited from `BaseRunner` where you can easily define one or more algorithms than solve the problem.

Each algorithm will be tested and benchmarked automatically as you save the file.

Everything is documented according to [TomDoc](http://tomdoc.org/) so it should be easy to understand ;)

## Tips

* Don't forget to `gem install pry` and `require 'pry'` if you need to debug your code (add `binding.pry` wherever you need a break point).
