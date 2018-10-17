#!/bin/bash

# (issue with ubuntu phantomjs distro)
# https://github.com/teampoltergeist/poltergeist/issues/866 
# (issue installing phantomjs)
# https://github.com/Medium/phantomjs/issues/722 

version='2.1.1'

wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$version-linux-x86_64.tar.bz2 -O ~/Downloads/phantomjs-$version.tar.bz2
tar xjf ~/Downloads/phantomjs-$version.tar.bz2 --directory ~/Downloads/
sudo cp ~/Downloads/phantomjs-$version-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

