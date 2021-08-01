class GistService

  def initialize(gist, client: default_client)
    @gist = gist
    @client = client
  end

  def call
    result = @client.gist(@gist)
    result.files.to_hash.first[0].to_s
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GIST_TOKEN'])
  end
end
