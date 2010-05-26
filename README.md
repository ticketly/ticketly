Ticketly Heroku Plugin - manage your tickets from the command line
========================================================

This library wraps the REST API for managing tickets on Ticketly

For more about Ticketly see <http://tikt.ly>.

For full documentation see <http://tikt.ly/docs>.


Setup
-----

    heroku plugin:install git@github.com:ticketly/ticketly.git

Note that this command requires git to run.
("apt-get install git-core" on Ubuntu or "port install git-core" on OS X)

The first time you run a command, such as "heroku tix:list," you will be prompted
for your Ticketly username and password. If you're on a Mac, these are saved to
your Keychain. Otherwise they are stored in plain text in ~/.heroku/plugins/ticketly/credentials
for future requests.


Meta
----

Created by Jeff Michels

Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
<http://github.com/ticketly/ticketly>
