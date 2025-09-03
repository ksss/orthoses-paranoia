# frozen_string_literal: true

require "orthoses"
require_relative "paranoia/version"

module Orthoses
  class Paranoia
    def initialize(loader)
      @loader = loader
    end

    def call
      acts_as_paranoid = CallTracer::Lazy.new
      store = acts_as_paranoid.trace("ActiveRecord::Base.acts_as_paranoid") do
        @loader.call
      end

      acts_as_paranoid.captures.each do |capture|
        base_name = Utils.module_name(capture.method.receiver) or next
        relation_class = "#{base_name}::ActiveRecord_Relation"
        paranoia_instance_methods = "::Paranoia::InstanceMethods[#{base_name}]"
        paranoia_class_methods = "::Paranoia::ClassMethods[#{base_name}, #{relation_class}]"

        store[base_name] << "include #{paranoia_instance_methods}"
        store[base_name] << "extend #{paranoia_class_methods}"

        store[relation_class] << "include #{paranoia_class_methods}"

        store["#{base_name}::ActiveRecord_Associations_CollectionProxy"] << "include #{paranoia_class_methods}"
      end

      store
    end
  end
end
