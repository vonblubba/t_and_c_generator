# T & C generator

Project requires ruby 3.0.3.
After running `bundle install`, specs can be run with `bundle exec rspec spec`

Project is structured similarly to a rails service: a single `Generator` class, that needs to be instantiated with 3 parameters:

- path of a text file containing the template
- an array of hashes containing the clauses
- an array of hashes containig the sections

Document is generated calling `#perform` method on the class instance. All other methods are private.
`#perfom` method executes a series of steps to generate the document; some initial data validation (which could probably be improved), clauses replacement and sections replacement.

Also provided are an example of usage `application.rb` and dataset in `data` folder.
Usage:

`ruby application.rb data/template.txt data/clauses.json data/sections.json`

Given more time, I would probably improve the test suite to cover more anomalous situations.
Also, I would probably refactor using [dry-transaction](https://dry-rb.org/gems/dry-transaction/0.13/). Maybe in this case, given the simplicity of the task, it would be a little overengineered, but this is the way I normally choose when I have to perform complex procedures, composed of several steps, where any number on things could go wrong.

This took me about 3,5 hours to complete.