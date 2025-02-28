# BrDanfe

[![Code Climate](https://codeclimate.com/github/asseinfo/br_danfe.png)](https://codeclimate.com/github/asseinfo/br_danfe)

This gem generates PDF files for Brazilian DANFE (_Documento Auxiliar da Nota Fiscal Eletrônica_) from a valid NF-e XML. It also can generates PDF file for CC-e (_Carta de Correção Eletrônica_).

[See an example here.](https://github.com/asseinfo/br_danfe/blob/master/spec/fixtures/v2.00/nfe_with_logo.xml.fixture.pdf?raw=true)

This gem requires `ruby >= 2.0`.

## Supported NF-e versions

XML version | Supported?
----------- | ----------
1.00        | no
2.00        | yes
3.10        | yes
4.00        | yes

## Installing

    gem install br_danfe

## Usage

### DANFE - _Documento Auxiliar da Nota Fiscal Eletrônica_
#### Usage in Ruby

    xml = File.read("spec/fixtures/nfe/v2.00/nfe_simples_nacional.xml")

    danfe = BrDanfe::Danfe.new(xml)
    danfe.options.logo = "spec/fixtures/logo.png"
    danfe.options.logo_dimensions = { width: 100, height: 100 }
    danfe.save_pdf("output.pdf")

#### Usage in Rails Controller

    class DanfeController < ApplicationController
      def new
        invoice = Invoice.find(params[:id])
        xml_as_string = invoice.generate_xml # your method that generates the NF-e's xml

        danfe = BrDanfe::Danfe.new(xml_as_string)

        send_data danfe.render_pdf, filename: "danfe.pdf", type: "application/pdf"
      end
    end

#### Usage in Rails Controller with more than one xml

    class DanfeController < ApplicationController
      def new
        invoices = Invoice.where(ids: params[:ids])
        xmls_as_string = []

        invoices.each do |invoice|
            xmls_as_string << invoice.generate_xml # your method that generates the NF-e's xml
        end

        danfe = BrDanfe::Danfe.new(xmls_as_string)

        send_data danfe.render_pdf, filename: "danfe.pdf", type: "application/pdf"
      end
    end

### Options

* `logo_path`: Path of sender's logo image.
* `logo_dimensions`: Dimensions of the logo. Ex: logo_dimensions = { width: 100, height: 90 }

### CC-e - Carta de Correção Eletrônica

#### Usage in Ruby

    xml = File.read("cce.xml")

    cce = BrDanfe::Cce.new(xml)
    cce.save_pdf("nfe.pdf")

#### Usage in Rails Controller

    class CCeController < ApplicationController
      def new
        invoice = Invoice.find(params[:id])
        xml_as_string = invoice.generate_xml # your method that generates the CC-e's xml

        cce = BrDanfe::Cce.new(xml_as_string)

        send_data cce.render_pdf, filename: "cce.pdf", type: "application/pdf"
      end
    end

### DAMDFE - _Documento Auxiliar do Manifesto Eletrônico de Documentos Fiscais_

#### Usage in Ruby

    xml = File.read("mdfe.xml")

    mdfe = BrDanfe::Mdfe.new(xml)
    mdfe.save_pdf("mdfe.pdf")

#### Usage in Rails Controller

    class MdfeController < ApplicationController
      def new
        mdfe = Mdfe.find(params[:id])
        xml_as_string = mdfe.generate_xml # your method that generates the MDF-e's xml

        mdfe = BrDanfe::Mdfe.new(xml_as_string)

        send_data mdfe.render_pdf, filename: "mdfe.pdf", type: "application/pdf"
      end
    end


## I18n

By default, your rails application must be configured to `pt-Br`.

If you need to customize some message or field label, you can override the content of pt-Br.yml file.

## Development - With Docker

You needs to build docker container like above:

    $ docker-compose build

You can run all RSpec specs using:

    $ docker-compose run --rm br_danfe rspec


## Development - Without Docker

You needs to install all necessaries dependencies using bunder like above:

    $ bundle install


You can run all RSpec specs using:

    $ bundle exec rspec


## About tests

> If you modify something that caused general visual changes at output pdf's, so you have to rebuild the fixtures pdf files.
>
> You can do this simply deleting the fixture pdf file. The `have_same_content_of` matcher will recreate the fixture in the next time you run the `bundle exec rspec` command.


## Environment variables

The following variables are necessary to be set:

Environment var       | Development? | Test? | CI?   | Production? | Data
----------------------|--------------|-------|-------|-------------|-----
TZ                    | no           | no    | yes   | no          | America/Sao_Paulo
BUNDLE_PATH           | no           | no    | yes   | no          | vendor/bundle
CC_TEST_REPORTER_ID   | no           | no    | yes   | no          | get at codeclimate
RAILS_ENV             | no           | no    | yes   | no          | test

### Code coverage

Code coverage is available through of SimpleCov. Just run `bundle exec rspec` and open the coverage report in your browser.

### Fake data for generating new fixtures

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
IE ST        | 611.724.092.039

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

## Deploy to Rubygems

1. To deploy a new version:

  * Define the new version at `lib/br_danfe/version.rb`;
  * Execute `$ bundle`;
  * Commit all and push to Github;

2. Send the new version to Rubygems

  * $ bundle exec rake release

3. Create a [new release on Github](https://github.com/asseinfo/br_danfe/releases/new)

* Choose **the new tag** (Ex.: v0.10.1)
* Fill the **Release title** (Ex.: 0.10.1)
* Click at **Generate release notes**
* Click at **Publish release**

4. Done!

You can build or install the gem using one of the above tasks

    $ bundle exec rake build    # Build br_danfe-X.X.X.gem into the pkg directory
    $ bundle exec rake install  # Build and install br_danfe-X.X.X.gem into system gems

#### Login
    $ gem signin
    $ gem signout

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
