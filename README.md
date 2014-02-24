# BrDanfe

[![Code Climate](https://codeclimate.com/github/asseinfo/br_danfe.png)](https://codeclimate.com/github/asseinfo/br_danfe) [![Build Status](https://travis-ci.org/asseinfo/br_danfe.png?branch=master)](https://travis-ci.org/asseinfo/br_danfe)

This gem generates PDF files for Brazilian DANFE (_Documento Auxiliar da Nota Fiscal Eletrônica_) from a valid NF-e XML.

This gem requires `ruby >= 1.9.x`.

It's a fork of [Ruby DANFE](http://github.com/taxweb/ruby_danfe) project.

The difference is that this project doesn't support DACTE (_Documento Auxiliar do Conhecimento de Transporte Eletrônico_) or NFC-e (_Nota Fiscal do Consumidor Eletrônica_). It's only focused on DANFE.

## Installing

        gem install ruby_danfe

## Usage

If you have the xml saved in a file:

        require "br_danfe"
        BrDanfe.generate("sample.pdf", "sample.xml")

If you have the xml in a variable:

        xml = BrDanfe::XML.new(my_xml_string)
        pdf = BrDanfe.generatePDF(xml)
        pdf.render_file "output.pdf"

## I18n

By default, your rails application must be configured to `pt-Br`.

If you need to customize some message or field label, you can override the content of pt-Br.yml file.

## Development

### Installing dependencies

You can install all necessaries dependencies using bunder like above:

        $ bundle install

### Tests

#### Manual tests

You can use it following the steps above:

        $ rake pdf_from["spec/fixtures/nfe_with_ns.xml","./output.pdf"]

You can also use an special version of irb with all classes pre-loaded. Just use:

        $ rake console
        I18n.locale = "pt-BR"
        BrDanfe.generate("output.pdf", "test/nfe_with_ns.xml")

or

        $ rake console

        I18n.locale = "pt-BR"

        my_xml_string = ""
        file = File.new("test/nfe_with_ns.xml", "r")
        while (line = file.gets)
            my_xml_string = my_xml_string + line
        end
        file.close

        xml = BrDanfe::XML.new(my_xml_string)
        pdf = BrDanfe.generatePDF(xml)

        pdf.render_file "output.pdf"

#### Automated tests with RSpec

You can run all specs using:

        $ rspec

In the `spec/fixtures` folder, you are going to find some xml files. Each one represent a different NF-e context.

Each xml file must have its respective pdf file.

If you did some change that caused general visual changes at output pdfs, so you have to rebuild all fixtures pdf files.

You can do this automagically running the following taks:

        $ rake spec:fixtures:recreate_pdfs

#### Code coverage

Code coverage is available through of SimpleCov. Just run `rspec` and open the coverage report in your browser.

### Building and publishing

You can build using one of the above tasks

        $ rake build    # Build br_danfe-X.X.X.gem into the pkg directory
        $ rake install  # Build and install br_danfe-X.X.X.gem into system gems
        $ rake release  # Create tag vX.X.X and build and push br_danfe-X.X.X.gem to Rubygems

## Contributing

We encourage you to contribute to BrDanfe!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

BrDanfe is released under the [MIT License](http://www.opensource.org/licenses/MIT).
