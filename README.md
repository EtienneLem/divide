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
web: bundle exec unicorn -c ./config/unicorn.rb
```

```sh
$ divide -c ./another_folder/unicorn.rb
# => bundle exec unicorn -c ./another_folder/unicorn.rb
```

### Port
If you don’t specify a port, **Divide** will overwrite `$PORT` with 5000.

```
web: bundle exec rails s -p $PORT
```

```sh
$ divide
# => bundle exec rails s -p 5000
```

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
