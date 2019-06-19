# frozen_string_literal: true

require "active_model"
require "resolv"

module ActiveModel
  module Validations
    class IpAddressValidator < ::ActiveModel::EachValidator
      PERMITTED_VERSION = %i[v4 v6].freeze

      def initialize(options)
        options[:version] ||= %i[v4 v6]
        options[:version] = Array(options[:version])
        super
      end

      def validate_each(record, attribute, value)
        return if options[:version].include?(:v4) && ::Resolv::IPv4::Regex.match?(value)
        return if options[:version].include?(:v6) && ::Resolv::IPv6::Regex.match?(value)

        record_error(record, attribute, value)
      end

      def check_validity!
        return if options[:version].present? && (options[:version] - PERMITTED_VERSION).blank?

        raise ArgumentError, "Either :v4 and/or :v6 must be supplied."
      end

      private

      def record_error(record, attribute, value)
        record.errors.add(attribute, :invalid, options.except(:version).merge!(value: value))
      end
    end

    module HelperMethods
      def validates_ip_address_of(*attr_names)
        validates_with IpAddressValidator, _merge_attributes(attr_names)
      end
    end
  end
end
