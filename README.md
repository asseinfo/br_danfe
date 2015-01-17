# BrDanfe

[![Code Climate](https://codeclimate.com/github/asseinfo/br_danfe.png)](https://codeclimate.com/github/asseinfo/br_danfe) [![Build Status](https://travis-ci.org/asseinfo/br_danfe.png?branch=master)](https://travis-ci.org/asseinfo/br_danfe)

This gem generates PDF files for Brazilian DANFE (_Documento Auxiliar da Nota Fiscal Eletrônica_) from a valid NF-e XML.

[See an example here.](https://github.com/asseinfo/br_danfe/blob/master/spec/fixtures/v2.00/nfe_with_logo.xml.fixture.pdf?raw=true)

This gem requires `ruby >= 1.9.3`.

## Supported NF-e versions

XML version | Supported?
----------- | ----------
1.00        | no
2.00        | yes
3.10        | yes

## Installing

        gem install ruby_danfe

## Usage

### Usage in Ruby

        xml = File.read("nfe.xml")

        danfe = BrDanfe::Danfe.new(xml)
        danfe.options.logo_path = "logo.png"
        danfe.save_pdf("nfe.pdf")

### Usage in Rails Controller

        class DanfeController < ApplicationController
          def new
            invoice = Invoice.find(params[:id])
            xml_as_string = invoice.generate_xml # your method that generates the NF-e's xml

            danfe = BrDanfe::Danfe.new(xml_as_string)

            send_data danfe.render_pdf, filename: "danfe.pdf", type: "application/pdf"
          end
        end

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

        xml = File.read "test/nfe_with_ns.xml"

        danfe = BrDanfe::Danfe.new(xml)
        danfe.save_pdf "output.pdf"

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

#### Generating new fixtures

If you need to generate new danfes for using as fixtures, please don't use real data.

These data bellow are suggested:

**Sender:**

Field        | Content
------------ | ----------------------
Name         | Nome do Remetente Ltda
Trade        | Nome Fantasia do Remetente Ltda
Address      | Rua do Remetente
Number       | 123
Complement   | Casa
Neighborhood | Bairro do Remetente
CEP          | 12.345-678
City         | São Paulo - SP
Phone        | (11) 1234-5678
CNPJ         | 62.013.294/0001-43
IE           | 526.926.313.553

**Recipient:**

Field        | Content
------------ | -------------------------
Name         | Nome do Destinatário PJ Ltda
Address      | Rua do Destinatário PJ
Number       | 345
Complement   | SL 1 e 2
Neighborhood | Bairro do Destinatário PJ
CEP          | 23.456-789
City         | Sumaré - SP
Phone        | (19) 2345-6789
CNPJ         | 71.058.884/0001-83
IE           | 671.008.375.110

Field        | Content
------------ | -------------------------
Name         | Nome do Destinatário PF
Address      | Rua do Destinatário PF
Number       | 345
Complement   | 1o Andar
Neighborhood | Bairro do Destinatário PF
CEP          | 98.765-432
City         | Vinhedo - SP
Phone        | (16) 4567-8901
CPF          | 485.325.574-57
RG           | 11.420.947-9

**Transporter:**

Field        | Content
------------ | --------------------------
Name         | Nome do Transportador Ltda
Address      | Rua do Transportador, 456
City         | Votorantim - SP
CNPJ         | 71.434.064/0001-49
IE           | 964.508.990.089

You can generate new data using [4devs generators](http://www.4devs.com.br).

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

## Ruby DANFE gem

This project is based on [Ruby DANFE gem](http://github.com/taxweb/ruby_danfe).

## License

BrDanfe is released under the [MIT License](http://www.opensource.org/licenses/MIT).
