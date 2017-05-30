# RedPoll

Plugin for creating polls.

## Environment:
```
Ruby 2.2+
Redmine 3.3+
breadcrumbs_on_rails (3.0.1)
```

## Installation a plugin:
 1. cd {REDMINE_ROOT}/plugins
 2. git clone github.com/em70/redpoll.git
 3. bundle install
 5. bundle exec rake redmine:plugins:migrate RAILS_ENV=production
 6. Restart Redmine
 7. Then enable the plugin "Administration->Plugins" for projects
 8. Create group "redpoll" "Administration->Groups->New group"
 9. Add users who are allowed to create polls in a group of redpoll or create new users

## Tests:
 rake redmine:plugins:test NAME=redpoll

## Run:
Log in Redmine "redpoll" user and create a new poll.
Create a new question and a list of answers to this question.
Consistently create all questions and answers to them.
Copy the code like *{{redpoll(70%, 300px, 1)}}* and paste to the wiki page

## Settings:
Administration->Plugins->Redpoll plugin Configure
If you want, you can determine the name of the band Redpoll group (default redpoll)
and the output format of the voting user
User output format

## Uninstalling a plugin:
  1. bundle exec rake redmine:plugins:migrate NAME=plugin_name VERSION=0 RAILS_ENV=production
  2. rm #{RAILS_ROOT}/plugins/redpoll
  3. Restart Redmine

## License:

MIT

## Autors of the Plugin:
[Elecard-Med Company](https://em70.ru/) (Aleksey Shimonchuk, Ivan Lysenko, Valery Dacyuk, Sergey Kochetkov)