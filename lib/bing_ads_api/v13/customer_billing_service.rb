  # Encoding: utf-8
  #
  # This is auto-generated code, changes will be overwritten.
  #
  # Copyright:: Copyright , Google Inc. All Rights Reserved.
  # License:: Licensed under the Apache License, Version 2.0.
  #
  # Code generated by AdsCommon library 0.9.9 on 2022-05-11 07:18:59.
  require 'ads_common/savon_service'
  require 'bing_ads_api/v13/customer_billing_service_registry'

  module BingAdsApi; module V13; module CustomerBillingService
  class CustomerBillingService < AdsCommonForBingAds::SavonService
    def initialize(config, endpoint)
		  namespace = 'https://bingads.microsoft.com/Billing/v13'
		  super(config, endpoint, namespace, :v13)
    end

    def get_billing_documents_info(*args, &block)
		  return execute_action('get_billing_documents_info', args, &block)
    end

    def get_billing_documents(*args, &block)
		  return execute_action('get_billing_documents', args, &block)
    end

    def add_insertion_order(*args, &block)
		  return execute_action('add_insertion_order', args, &block)
    end

    def update_insertion_order(*args, &block)
		  return execute_action('update_insertion_order', args, &block)
    end

    def search_insertion_orders(*args, &block)
		  return execute_action('search_insertion_orders', args, &block)
    end

    def get_account_monthly_spend(*args, &block)
		  return execute_action('get_account_monthly_spend', args, &block)
    end

    def dispatch_coupons(*args, &block)
		  return execute_action('dispatch_coupons', args, &block)
    end

    def redeem_coupon(*args, &block)
		  return execute_action('redeem_coupon', args, &block)
    end

    def search_coupons(*args, &block)
		  return execute_action('search_coupons', args, &block)
    end

    private

    def get_service_registry()
		  return CustomerBillingServiceRegistry
    end

    def get_module()
		  return BingAdsApi::V13::CustomerBillingService
    end
  end
  end; end; end