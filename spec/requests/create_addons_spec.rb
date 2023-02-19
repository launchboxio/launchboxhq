require 'rails_helper'

RSpec.describe 'Create addons', type: :request do
  before { host! "api.lvh.me" }
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'manage_addons') }

  describe 'POST /v1/addons' do
    before do
      post '/v1/addons' , params: {
        addon: {
          name: Faker::App.name,
          cluster_attachable: false,
          project_attachable: true,
          definition: "---\napiVersion: test/v1\nkind: Testarooni",
          json_schema: "{}",
          mapping: "{}"
        }
      }, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'creates an addon' do
      expect(response).to have_http_status(:success)
      expect(json['id']).not_to be_nil
      expect(json['cluster_attachable']).to be_falsey
      expect(json['project_attachable']).to be_truthy
    end
  end
end
