# T & C generator

Project requires ruby 3.0.3.
After running `bundle install`, specs can be run with `bundle exec rspec spec`

Project is structured similarly to a rails service: a single `Generator` class, that needs to be instantiated with 3 parameters:

- path of a text file containing the template
- an array of hashes containing the clauses
- an array of hashes containig the sections

Document is generated calling `#perform` method on the class instance. All other methods are private.
`#perfom` method executes a series of steps to generate the document; some initial data validation (which could probably be improved), clauses replacement and sections replacement.

Given more time, I would probably improve the test suite to cover more anomalous situations.

This took me about 3,5 hours to complete.