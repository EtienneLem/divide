# Divide
Start `Procfile` processes in different Terminal/iTerm tabs.

I’m well aware of [foreman][], but it starts all processes in the same tab which can be inconvenient.<br>
I’m well aware of [tmux][], but obviously not everyone’s using it (if you do, check out [teamocil][]).

## Usage
```sh
$ gem install divide
$ divide
```

## Options
**Divide** is option-free. You may however overwrite any options of your `Procfile` processes by passing them to `divide`.

```
# Procfile
web: bundle exec unicorn -c ./config/unicorn.rb
```

```sh
$ divide -c ./another_folder/unicorn.rb
# => bundle exec unicorn -c ./another_folder/unicorn.rb
```

### ENV
**Divide** automatically loads `.env` file and overwrite any `$VARIABLE` of your processes.

```
# .env
PORT=1337
RACK_ENV=development
```
```
# Procfile
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb -E $RACK_ENV
```

```sh
$ divide
# => bundle exec unicorn -p 1337 -c ./config/unicorn.rb -E development
```

### $PORT
If you don’t specify a port, **Divide** will overwrite `$PORT` with 5000.

```
# Procfile
web: bundle exec rails s -p $PORT
```

```sh
$ divide
# => bundle exec rails s -p 5000
```

## Changelog
### 0.0.2
- iTerm.app support
- Automatically load `.env file`
- Open new tabs in current directory

## Contributing
Why yes! You’re welcome to submit any [issue][] or [pull request][] as long as everything’s green when you `bundle exec rake spec`. Meanwhile, you can give these folks a tap on the back for helping out:

- [@remiprev](https://github.com/remiprev)

## License
Copyright © 2013 Etienne Lemay. See [LICENSE][] for details.

[foreman]: https://github.com/dollar/foreman
[tmux]: http://tmux.sourceforge.net
[teamocil]: https://github.com/remiprev/teamocil
[issue]: https://github.com/EtienneLem/divide/issues
[pull request]: https://github.com/EtienneLem/divide/pulls
[LICENSE]: /LICENSE.md
