require 'spec_helper'

shared_examples_for 'search references controller' do
  before { login_as_api_user }

  render_views

  before { search_reference }

  describe "GET #index" do
    let(:pattern) {
      [
        {id: Integer, title: String, referenced_entity: Hash, reference_class: String }
      ]
    }

    context 'without pagination' do
      it 'returns rendered records with default pagination values' do
        get :index, { format: :json }.merge(collection_query)

        response.body.should match_json_expression pattern
      end
    end

    context 'with pagination' do
      context 'with odd pagination page/offset values' do
        it 'does not raise exception with offset equal to zero' do
          expect {
            get(:index, { format: :json, offset: 0 }.merge(collection_query))
          }.not_to raise_error
        end

        it 'does not raise exception with negative limit' do
          expect {
            get(:index, { format: :json, limit: -10 }.merge(collection_query))
          }.not_to raise_error
        end

        it 'defaults to first page' do
          get(:index, { format: :json }.merge(collection_query))

          response.body.should match_json_expression pattern
        end
      end
    end

    it 'includes pagination meta data in HTTP meta header' do
      get(:index, { format: :json }.merge(collection_query))

      expect(response.headers).to have_key 'X-Meta'
      expect(JSON.parse(response.headers['X-Meta'])).to have_key 'pagination'
    end
  end

  describe "GET to #show" do
    let(:pattern) {
      {id: Integer, title: String, referenced_entity: Hash, reference_class: String }.ignore_extra_keys!
    }

    it 'returns rendered search reference record' do
      get :show, {
        format: :json
      }.merge(resource_query)

      response.body.should match_json_expression pattern
    end
  end

  describe "POST to #create" do
    let(:search_reference)  { build :search_reference }

    context 'valid params provided' do
      let(:pattern) {
        { id: Integer, title: String, referenced_entity: Hash }
      }

      before {
        post :create, {
            search_reference: {
              title: search_reference.title
            },
            format: :json
        }.merge(collection_query)
      }

      it 'persists SearchReference entry' do
        expect(SearchReference.all).not_to be_none
      end

      it 'returns persisted record' do
        expect(response.body).to match_json_expression pattern
      end
    end

    context 'invalid params provided' do
      let(:pattern) {
        { errors: Hash }
      }

      before {
        post :create, {
          search_reference: { title: '' },
          format: :json
        }.merge(collection_query)
      }

      it 'does not persist SearchReference entry' do
        expect(SearchReference.all).to be_none
      end

      it 'returns validation errors' do
        expect(response.body).to match_json_expression pattern
      end
    end
  end

  describe "DELETE #destroy" do
    context 'search reference exists' do
      it 'destroys SearchReference entry' do
        expect {
          delete :destroy, {
            format: :json
          }.merge(resource_query)
        }.to change { SearchReference.count }.by(-1)
      end
    end

    context 'search reference does not exist' do
      let(:bogus_search_ref_id) { 666 }

      it 'does not destroy SearchReference entry' do
        expect {
          delete :destroy, {
            id: bogus_search_ref_id,
            format: :json
          }.merge(collection_query)
        }.not_to change { SearchReference.count }
      end

      it 'returns 404 response' do
        delete :destroy, {
          id: bogus_search_ref_id,
          format: :json
        }.merge(collection_query)

        expect(response.status).to eq 404
      end
    end
  end

  describe "PUT #update" do
    let(:new_title)         { 'new title' }

    context 'valid params provided' do
      before {
        put :update, {
          search_reference: {
            title: new_title
          },
          format: :json
        }.merge(resource_query)
      }

      it 'updates SearchReference entry' do
        expect(search_reference.reload.title).to eq new_title
      end

      it 'returns no content status' do
        expect(response.status).to eq 204
      end

      it 'returns no content' do
        expect(response.body).to be_blank
      end
    end

    context 'invalid params provided' do
      let(:pattern) {
        { errors: Hash }
      }

      before {
        put :update, {
          search_reference: {
            title: '',
          },
          format: :json
        }.merge(resource_query)
      }

      it 'does not update SearchReference entry' do
        expect(search_reference.reload.title).not_to eq new_title
      end

      it 'returns not acceptable status' do
        expect(response.status).to eq 422
      end

      it 'returns record errors' do
        expect(response.body).to match_json_expression pattern
      end
    end
  end
end
