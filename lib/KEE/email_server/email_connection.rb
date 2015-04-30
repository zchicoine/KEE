require 'gmail'
module KEE
    module EmailServer
        module EmailConnection

            class << self

                # :description establish a connection to a gmail account
                # see https://github.com/nfo/gmail_xoauth for more info
                # read data from email_config.yml
                # :param [symbol] [ :xoauth2, :basic]
                # :return [Gmail::Client]
                def establish_connection(type = :basic)
                    # read gmail credentials
                    credentials = YAML::load(File.read(File.expand_path('../email_config.yml', __FILE__)))['gmail']

                    if type == :basic
                        email = credentials['auth_basic']['email_address']
                        password = credentials['auth_basic']['password']
                        return  Gmail.connect(email, password)
                    elsif type == :xoauth2
                        email = credentials['auth_xoauth2']['email_address']
                        token =credentials['auth_xoauth2']['token']
                        return Gmail.connect(:xoauth2,email, token)
                    end
                end

                # :description configuration credential a connection to a gmail account
                # :param [ Hash] {:auth_basic => {:email_address, :password}, :auth_xoauth2 => {:email_address, :token}}
                def config_connection(config)
                    raise ArgumentError.new('config cannot both be nil') if config.nil?
                    credentials = YAML::load(File.read(File.expand_path('../email_config.yml', __FILE__)))
                    credentials['gmail']['auth_basic']['email_address'] = config[:email_address]
                    credentials['gmail']['auth_basic']['password'] = config[:password]
                    credentials['gmail']['auth_xoauth2']['email_address'] = config[:email_address]
                    credentials['gmail']['auth_xoauth2']['token'] = config[:password]

                    File.open(File.expand_path('../email_config.yml', __FILE__),'w') do |file|
                        file.write credentials.to_yaml
                    end
                end

            end #  self
        end
    end # EmailServer
end
