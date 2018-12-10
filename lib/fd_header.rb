# frozen_string_literal: true

class FdHeader
  attr_accessor :url, :payload, :header

  DEFAULT_PAYLOAD = {
    'request_id' => '135862',
    'id_type' => '1'
  }.with_indifferent_access

  DEFAULT_HEADER = {
    'x-foody-access-token' => '22',
    'x-foody-api-version' => '1',
    'x-foody-app-type' => '1004',
    'x-foody-client-id' => '',
    'x-foody-client-language' =>  'vi',
    'x-foody-client-type' => '1',
    'x-foody-client-version' =>  '3.0.0'
  }

  DEFAULT_URL = 'https://gappapi.deliverynow.vn/api/dish/get_delivery_dishes'

  def initialize(url: nil, payload: nil, header: nil)
    @url = url || DEFAULT_URL
    @payload = payload || DEFAULT_PAYLOAD
    @header = (header || aggr_header).with_indifferent_access
  end

  def aggr_header
    DEFAULT_HEADER.merge('params' => payload)
  end
end
